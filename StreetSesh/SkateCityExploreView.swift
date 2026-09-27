import SwiftUI
import MapKit
import Combine

// MARK: - SF Landmark Data

private struct SFLandmark {
    let name: String
    let icon: String
    let coordinate: CLLocationCoordinate2D

    static let all: [SFLandmark] = [
        SFLandmark(
            name: "Golden Gate Bridge",
            icon: "building.columns.fill",
            coordinate: CLLocationCoordinate2D(latitude: 37.8199, longitude: -122.4783)
        ),
        SFLandmark(
            name: "Bay Bridge",
            icon: "road.lanes.curved.right",
            coordinate: CLLocationCoordinate2D(latitude: 37.7983, longitude: -122.3778)
        ),
        SFLandmark(
            name: "Twin Peaks",
            icon: "mountain.2.fill",
            coordinate: CLLocationCoordinate2D(latitude: 37.7544, longitude: -122.4477)
        )
    ]
}

// MARK: - Explore View

struct SkateCityExploreView: View {
    @EnvironmentObject private var state: SkateCityAppState
    @State private var locationManager = SKLocationManager()
    @State private var displayMode: DisplayMode = .map
    @State private var mapPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.18, longitudeDelta: 0.18)
        )
    )
    @State private var selectedShop: SkateShop? = nil
    @State private var selectedSpot: SkateSpot? = nil
    @State private var selectedLiveShop: MKMapItem? = nil
    @State private var showLiveShopSheet = false
    @State private var filterMode: FilterMode = .all
    @State private var showPrivacyInfo = false
    @State private var liveShops: [MKMapItem] = []
    @State private var activeRoute: MKRoute? = nil
    @State private var isLoadingDirections = false

    // Map appearance — auto (time-based) or manual override
    @State private var mapSchemeOverride: ColorScheme? = nil
    @State private var clockTick = Date()
    private let mapTimer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    // MARK: - Time-based map style helpers

    private var timeBasedIsDark: Bool {
        _ = clockTick  // depend on tick so auto updates each minute
        let h = Calendar.current.component(.hour, from: Date())
        return h < 6 || h >= 20   // dark: 8 pm – 6 am
    }

    private var effectiveColorScheme: ColorScheme {
        mapSchemeOverride ?? (timeBasedIsDark ? .dark : .light)
    }

    private var isMapDark: Bool { effectiveColorScheme == .dark }

    enum DisplayMode: String, CaseIterable {
        case map  = "Map"
        case list = "List"
    }
    enum FilterMode: String, CaseIterable {
        case all   = "All"
        case shops = "Shops"
        case spots = "Spots"
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.skDark.ignoresSafeArea()
                VStack(spacing: 0) {
                    topBar
                    if displayMode == .map {
                        mapContent
                    } else {
                        listContent
                    }
                }
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
        .sheet(item: $selectedShop) { shop in
            SKShopDetailSheet(shop: shop)
                .presentationDetents([.medium, .large])
                .presentationBackground(Color.skDark)
        }
        .sheet(item: $selectedSpot) { spot in
            SKSpotDetailSheet(spot: spot)
                .environmentObject(state)
                .presentationDetents([.medium, .large])
                .presentationBackground(Color.skDark)
        }
        .sheet(isPresented: $showLiveShopSheet) {
            if let shop = selectedLiveShop {
                LiveShopDetailSheet(item: shop) {
                    Task { await getDirections(to: shop) }
                }
                .presentationDetents([.medium, .large])
                .presentationBackground(Color.skDark)
            }
        }
        .sheet(isPresented: $showPrivacyInfo) {
            SKPrivacyPanel(locationManager: locationManager)
                .presentationDetents([.medium])
                .presentationBackground(Color.skDark)
        }
        .task {
            await searchRealShops()
        }
        .onReceive(mapTimer) { date in clockTick = date }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Explore")
                    .font(.system(size: 24, weight: .black))
                    .foregroundStyle(.skText)
                Spacer()
                Button { showPrivacyInfo = true } label: {
                    HStack(spacing: 5) {
                        Image(systemName: locationManager.isEnabled ? "location.fill" : "location.slash")
                            .font(.caption)
                        Text(locationManager.isEnabled ? "Nearby On" : "Location Off")
                            .font(.caption.weight(.semibold))
                    }
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(locationManager.isEnabled ? Color.skLime.opacity(0.15) : Color.skMuted)
                    .foregroundStyle(locationManager.isEnabled ? .skLime : .skSub)
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            HStack(spacing: 10) {
                Picker("Mode", selection: $displayMode) {
                    ForEach(DisplayMode.allCases, id: \.self) { Text($0.rawValue) }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 140)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(FilterMode.allCases, id: \.self) { mode in
                            filterChip(mode)
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 10)
        .background(Color.skDark)
    }

    private func filterChip(_ mode: FilterMode) -> some View {
        let selected = filterMode == mode
        return Button { filterMode = mode } label: {
            Text(mode.rawValue)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(selected ? Color.skLime : Color.skMuted)
                .foregroundStyle(selected ? Color.black : Color.skSub)
                .clipShape(Capsule())
        }
    }

    // MARK: - Map

    private var mapContent: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(position: $mapPosition) {

                // Shops — all California shops visible + live Apple Maps overlay
                if filterMode != .spots {
                    ForEach(SkateShop.bayArea + SkateShop.california) { shop in
                        Annotation(shop.name, coordinate: shop.coordinate, anchor: .bottom) {
                            shopPin(shop)
                                .onTapGesture { selectedShop = shop }
                        }
                    }
                    ForEach(liveShops.indices, id: \.self) { i in
                        let item = liveShops[i]
                        Annotation(item.name ?? "Skate Shop",
                                   coordinate: item.placemark.coordinate,
                                   anchor: .bottom) {
                            liveShopPin()
                                .onTapGesture {
                                    selectedLiveShop = item
                                    showLiveShopSheet = true
                                }
                        }
                    }
                }

                // Skate spots
                if filterMode != .shops {
                    ForEach(SKMockData.realSpots + SKMockData.fresnoSpots + SKMockData.laSpots) { spot in
                        Annotation(spot.name, coordinate: spot.coordinate, anchor: .bottom) {
                            spotPin(spot)
                                .onTapGesture { selectedSpot = spot }
                        }
                    }
                }

                // SF Landmarks — always visible regardless of filter
                ForEach(SFLandmark.all, id: \.name) { landmark in
                    Annotation(landmark.name, coordinate: landmark.coordinate, anchor: .bottom) {
                        landmarkPin(landmark)
                    }
                }

                // Walking route overlay
                if let route = activeRoute {
                    MapPolyline(route.polyline)
                        .stroke(Color(hex: "#CCFF40"), lineWidth: 5)
                }
            }
            .mapStyle(.standard)
            .environment(\.colorScheme, effectiveColorScheme)
            .ignoresSafeArea(edges: .bottom)
            .overlay(alignment: .topTrailing) {
                mapModeToggleButton
                    .padding(.top, 14)
                    .padding(.trailing, 12)
            }

            // Route / loading controls
            if activeRoute != nil || isLoadingDirections {
                VStack(spacing: 8) {
                    if isLoadingDirections {
                        HStack(spacing: 8) {
                            ProgressView().tint(Color(hex: "#CCFF40"))
                            Text("Getting walking route…")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.skText)
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(Color.skDark.opacity(0.92))
                        .clipShape(Capsule())
                    }
                    if activeRoute != nil {
                        Button { activeRoute = nil } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "xmark.circle.fill")
                                Text("Clear Route")
                                    .font(.caption.weight(.semibold))
                            }
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .background(Color.skDark.opacity(0.92))
                            .foregroundStyle(.skText)
                            .clipShape(Capsule())
                        }
                    }
                }
                .padding(.bottom, 100)
                .padding(.trailing, 16)
            }
        }
    }

    // MARK: - Map Mode Toggle

    private var mapModeToggleButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.22)) {
                // Cycle: auto → force-dark → force-light → auto
                switch mapSchemeOverride {
                case nil:
                    mapSchemeOverride = timeBasedIsDark ? .light : .dark
                case .dark:
                    mapSchemeOverride = .light
                case .light:
                    mapSchemeOverride = nil
                default:
                    mapSchemeOverride = nil
                }
            }
        } label: {
            VStack(spacing: 3) {
                Group {
                    if mapSchemeOverride == nil {
                        Image(systemName: "clock.arrow.2.circlepath")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.skLime)
                    } else if isMapDark {
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(hex: "#C77DFF"))
                    } else {
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(hex: "#FFD700"))
                    }
                }
                Text(mapSchemeOverride == nil
                     ? "AUTO"
                     : (isMapDark ? "NIGHT" : "DAY"))
                    .font(.system(size: 7, weight: .black))
                    .foregroundStyle(.white.opacity(0.75))
                    .tracking(0.5)
            }
            .frame(width: 48, height: 48)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            .shadow(color: .black.opacity(0.25), radius: 6, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .stroke(
                        mapSchemeOverride == nil ? Color.skLime.opacity(0.4) :
                        (isMapDark ? Color(hex: "#C77DFF").opacity(0.5) : Color(hex: "#FFD700").opacity(0.5)),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Map Pins

    private var homeBasePin: some View {
        VStack(spacing: 0) {
            ZStack {
                // Pulsing lime ring
                Circle()
                    .stroke(Color.skLime.opacity(0.4), lineWidth: 8)
                    .frame(width: 52, height: 52)
                Image("SSMapSticker")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.skLime, lineWidth: 2)
                    )
                    .shadow(color: Color.skLime.opacity(0.6), radius: 8)
            }
            Triangle()
                .fill(Color.skLime)
                .frame(width: 8, height: 6)
        }
    }

    private func liveShopPin() -> some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#0ADFB4"))
                    .frame(width: 36, height: 36)
                    .shadow(color: Color(hex: "#0ADFB4").opacity(0.5), radius: 6)
                Image(systemName: "storefront.fill")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.black)
            }
            Triangle()
                .fill(Color(hex: "#0ADFB4"))
                .frame(width: 8, height: 5)
        }
    }

    private func shopPin(_ shop: SkateShop) -> some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color(hex: shop.accentColorHex))
                    .frame(width: 34, height: 34)
                Image(systemName: "storefront.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
            }
            Triangle()
                .fill(Color(hex: shop.accentColorHex))
                .frame(width: 8, height: 5)
        }
    }

    private func landmarkPin(_ landmark: SFLandmark) -> some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#FF9500"))
                    .frame(width: 32, height: 32)
                    .shadow(color: Color(hex: "#FF9500").opacity(0.45), radius: 5)
                Image(systemName: landmark.icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            }
            Triangle()
                .fill(Color(hex: "#FF9500"))
                .frame(width: 7, height: 4)
        }
    }

    private func spotPin(_ spot: SkateSpot) -> some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(spot.difficulty.color)
                    .frame(width: 28, height: 28)
                Image(systemName: "skateboard")
                    .font(.system(size: 12))
                    .foregroundStyle(.black)
            }
            Triangle()
                .fill(spot.difficulty.color)
                .frame(width: 6, height: 4)
        }
    }

    // MARK: - List

    private var listContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                if filterMode != .spots {
                    shopsSection
                }
                if filterMode != .shops {
                    spotsSection
                }
                landmarksSection
            }
            .padding(16)
        }
    }

    private var shopsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SKSectionHeader(title: "CALIFORNIA SKATE SHOPS")
            ForEach(SkateShop.bayArea + SkateShop.california) { shop in
                Button { selectedShop = shop } label: { shopRow(shop) }
            }
            if !liveShops.isEmpty {
                SKSectionHeader(title: "NEARBY  ·  LIVE")
                    .padding(.top, 8)
                ForEach(liveShops.indices, id: \.self) { i in
                    let item = liveShops[i]
                    Button {
                        selectedLiveShop = item
                        showLiveShopSheet = true
                    } label: {
                        liveShopRow(item)
                    }
                }
            }
        }
    }

    private func liveShopRow(_ item: MKMapItem) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#0ADFB4").opacity(0.12))
                    .frame(width: 48, height: 48)
                Image(systemName: "storefront.fill")
                    .font(.title3)
                    .foregroundStyle(Color(hex: "#0ADFB4"))
            }
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(item.name ?? "Skate Shop")
                        .font(.subheadline.bold())
                        .foregroundStyle(.skText)
                    Text("LIVE")
                        .font(.system(size: 8, weight: .black))
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Color(hex: "#0ADFB4").opacity(0.15))
                        .foregroundStyle(Color(hex: "#0ADFB4"))
                        .clipShape(Capsule())
                }
                if let thoroughfare = item.placemark.thoroughfare {
                    Text(thoroughfare)
                        .font(.caption)
                        .foregroundStyle(.skSub)
                }
                if let locality = item.placemark.locality {
                    Text(locality)
                        .font(.caption2)
                        .foregroundStyle(.skSub)
                }
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundStyle(.skSub)
        }
        .skBorderCard(padding: 12)
    }

    private func shopRow(_ shop: SkateShop) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: shop.accentColorHex).opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: "storefront.fill")
                    .font(.title3)
                    .foregroundStyle(Color(hex: shop.accentColorHex))
            }
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(shop.name).font(.subheadline.bold()).foregroundStyle(.skText)
                    Text(shop.isOpen ? "OPEN" : "CLOSED")
                        .font(.system(size: 8, weight: .black))
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(shop.isOpen ? Color.green.opacity(0.15) : Color.skMuted)
                        .foregroundStyle(shop.isOpen ? Color.green : Color.skSub)
                        .clipShape(Capsule())
                }
                Text(shop.specialty).font(.caption).foregroundStyle(.skSub)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").font(.system(size: 9)).foregroundStyle(.yellow)
                    Text(String(format: "%.1f", shop.rating)).font(.caption2).foregroundStyle(.skSub)
                    Text("·").foregroundStyle(.skSub)
                    Text(shop.distanceText).font(.caption2).foregroundStyle(.skSub)
                }
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundStyle(.skSub)
        }
        .skBorderCard(padding: 12)
    }

    private var spotsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SKSectionHeader(title: "SKATE SPOTS")
            ForEach(SKMockData.realSpots + SKMockData.fresnoSpots + SKMockData.laSpots) { spot in
                Button { selectedSpot = spot } label: { spotRow(spot) }
            }
        }
    }

    private func spotRow(_ spot: SkateSpot) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(spot.difficulty.color.opacity(0.12))
                    .frame(width: 48, height: 48)
                Image(systemName: "skateboard")
                    .font(.title3)
                    .foregroundStyle(spot.difficulty.color)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(spot.name).font(.subheadline.bold()).foregroundStyle(.skText)
                Text(spot.neighborhood).font(.caption).foregroundStyle(.skSub)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        SKDifficultyBadge(difficulty: spot.difficulty)
                        ForEach(spot.terrainTags.prefix(2), id: \.self) { tag in
                            SKTag(label: tag, small: true)
                        }
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 2) {
                    Image(systemName: "flame.fill").font(.caption).foregroundStyle(.skCoral)
                    Text("\(spot.popularity)").font(.caption.weight(.bold)).foregroundStyle(.skText)
                }
                Button {
                    if state.isSaved(spot.id) { state.removeSpot(spot.id) }
                    else { state.saveSpot(spot.id) }
                } label: {
                    Image(systemName: state.isSaved(spot.id) ? "bookmark.fill" : "bookmark")
                        .font(.caption)
                        .foregroundStyle(state.isSaved(spot.id) ? .skLime : .skSub)
                }
            }
        }
        .skBorderCard(padding: 12)
    }

    private var landmarksSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SKSectionHeader(title: "SF LANDMARKS")
            ForEach(SFLandmark.all, id: \.name) { landmark in
                Button {
                    let item = MKMapItem(placemark: MKPlacemark(coordinate: landmark.coordinate))
                    item.name = landmark.name
                    item.openInMaps(launchOptions: [
                        MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
                    ])
                } label: {
                    landmarkRow(landmark)
                }
            }
        }
    }

    private func landmarkRow(_ landmark: SFLandmark) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#FF9500").opacity(0.12))
                    .frame(width: 48, height: 48)
                Image(systemName: landmark.icon)
                    .font(.title3)
                    .foregroundStyle(Color(hex: "#FF9500"))
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(landmark.name)
                    .font(.subheadline.bold())
                    .foregroundStyle(.skText)
                Text("San Francisco · Tap for directions")
                    .font(.caption)
                    .foregroundStyle(.skSub)
            }
            Spacer()
            Image(systemName: "arrow.triangle.turn.up.right.circle")
                .font(.subheadline)
                .foregroundStyle(.skSub)
        }
        .skBorderCard(padding: 12)
    }

    // MARK: - Data & Directions

    private func searchRealShops() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "skate shop"
        request.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        guard let response = try? await MKLocalSearch(request: request).start() else { return }
        liveShops = response.mapItems
    }

    private func getDirections(to item: MKMapItem) async {
        isLoadingDirections = true
        let request = MKDirections.Request()
        request.source = locationManager.isEnabled
            ? MKMapItem.forCurrentLocation()
            : MKMapItem(placemark: MKPlacemark(coordinate: locationManager.mapCenter))
        request.destination = item
        request.transportType = .walking
        if let response = try? await MKDirections(request: request).calculate(),
           let route = response.routes.first {
            activeRoute = route
            mapPosition = .rect(route.polyline.boundingMapRect.insetBy(dx: -3000, dy: -3000))
        }
        isLoadingDirections = false
    }
}

// MARK: - Triangle Shape

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Live Shop Detail Sheet

struct LiveShopDetailSheet: View {
    let item: MKMapItem
    let onDirections: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var lookAroundScene: MKLookAroundScene? = nil
    @State private var lookAroundChecked = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                shopHeader
                if item.phoneNumber != nil || item.url != nil {
                    contactRow
                }
                Divider().background(Color.skBorder)
                storefrontSection
                Divider().background(Color.skBorder)
                actionsSection
                Spacer(minLength: 40)
            }
            .padding(20)
        }
        .task {
            lookAroundScene = try? await MKLookAroundSceneRequest(
                coordinate: item.placemark.coordinate
            ).scene
            lookAroundChecked = true
        }
    }

    private var shopHeader: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "#0ADFB4").opacity(0.15))
                    .frame(width: 60, height: 60)
                Image(systemName: "storefront.fill")
                    .font(.title2)
                    .foregroundStyle(Color(hex: "#0ADFB4"))
            }
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Text(item.name ?? "Skate Shop")
                        .font(.title3.bold())
                        .foregroundStyle(.skText)
                    Text("LIVE")
                        .font(.system(size: 8, weight: .black))
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Color(hex: "#0ADFB4").opacity(0.15))
                        .foregroundStyle(Color(hex: "#0ADFB4"))
                        .clipShape(Capsule())
                }
                if let title = item.placemark.title {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.skSub)
                        .lineLimit(2)
                }
            }
        }
    }

    private var contactRow: some View {
        HStack(spacing: 10) {
            if let phone = item.phoneNumber,
               let phoneURL = URL(string: "tel:\(phone.filter { $0.isNumber || $0 == "+" })") {
                Link(destination: phoneURL) {
                    contactChip(icon: "phone.fill", label: phone)
                }
            }
            if let url = item.url {
                Link(destination: url) {
                    contactChip(icon: "globe", label: "Website")
                }
            }
        }
    }

    private func contactChip(icon: String, label: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.caption).foregroundStyle(.skLime)
            Text(label).font(.caption.weight(.semibold)).foregroundStyle(.skText)
        }
        .padding(.horizontal, 10).padding(.vertical, 7)
        .background(Color.skMuted)
        .clipShape(Capsule())
    }

    @ViewBuilder
    private var storefrontSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("STOREFRONT VIEW")
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(.skSub)

            if !lookAroundChecked {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.skMuted)
                    .frame(height: 160)
                    .overlay { ProgressView().tint(.skSub) }
            } else if let scene = lookAroundScene {
                #if os(iOS)
                LookAroundPreview(initialScene: scene)
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                #endif
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.skMuted)
                    .frame(height: 80)
                    .overlay {
                        HStack(spacing: 8) {
                            Image(systemName: "eye.slash").foregroundStyle(.skSub)
                            Text("Street view not available here")
                                .font(.caption).foregroundStyle(.skSub)
                        }
                    }
            }
        }
    }

    private var actionsSection: some View {
        VStack(spacing: 10) {
            Button {
                dismiss()
                onDirections()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                    Text("Show Walking Route")
                }
                .font(.subheadline.weight(.black))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(hex: "#CCFF40"))
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Button {
                item.openInMaps(launchOptions: [
                    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
                ])
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "map.fill")
                    Text("Open in Apple Maps")
                }
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.skMuted)
                .foregroundStyle(.skText)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }
}

// MARK: - Privacy Panel

struct SKPrivacyPanel: View {
    @Bindable var locationManager: SKLocationManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Location Privacy")
                    .font(.title3.bold())
                    .foregroundStyle(.skText)
                Spacer()
                Button("Done") { dismiss() }.foregroundStyle(.skLime)
            }

            Text("StreetSesh uses your location only to suggest nearby shops and spots while the app is open. We never store, share, or track your position.")
                .font(.subheadline)
                .foregroundStyle(.skSub)
                .fixedSize(horizontal: false, vertical: true)

            Divider().background(Color.skBorder)

            HStack {
                Image(systemName: locationManager.isEnabled ? "location.fill" : "location.slash.fill")
                    .foregroundStyle(locationManager.isEnabled ? .skLime : .skSub)
                Text(locationManager.statusLabel)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.skText)
                Spacer()
            }
            .padding(14)
            .background(Color.skMuted)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            if !locationManager.isEnabled {
                SKButton(title: "Enable Nearby Discovery", icon: "location.fill") {
                    locationManager.requestPermission()
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                privacyRow("Never tracked in the background")
                privacyRow("No exact coordinates saved")
                privacyRow("Only used while app is open")
                privacyRow("Location rounded to ~1 km")
            }
            Spacer()
        }
        .padding(20)
    }

    private func privacyRow(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill").foregroundStyle(.skLime).font(.subheadline)
            Text(text).font(.subheadline).foregroundStyle(.skSub)
        }
    }
}

// MARK: - Shop Detail Sheet (mock data)

struct SKShopDetailSheet: View {
    let shop: SkateShop

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: shop.accentColorHex).opacity(0.18))
                            .frame(width: 60, height: 60)
                        Image(systemName: "storefront.fill")
                            .font(.title2)
                            .foregroundStyle(Color(hex: shop.accentColorHex))
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(shop.name).font(.title3.bold()).foregroundStyle(.skText)
                        Text(shop.neighborhood).font(.caption.weight(.semibold)).foregroundStyle(Color(hex: shop.accentColorHex))
                        Text(shop.address).font(.caption).foregroundStyle(.skSub)
                    }
                }
                HStack(spacing: 20) {
                    infoChip(icon: "star.fill",     value: String(format: "%.1f", shop.rating), color: .yellow)
                    infoChip(icon: "location.fill", value: shop.distanceText,                   color: .skLime)
                    infoChip(icon: "tag.fill",      value: shop.specialty,                      color: .skCoral)
                }

                // Contact info
                if shop.phone != nil || shop.website != nil || shop.owners != nil {
                    Divider().background(Color.skBorder)
                    contactRow
                }

                Divider().background(Color.skBorder)
                VStack(alignment: .leading, spacing: 6) {
                    Text("FEATURED CHALLENGE").font(.system(size: 10, weight: .black)).foregroundStyle(.skSub)
                    Text(shop.featuredChallenge).font(.subheadline.bold()).foregroundStyle(.skText)
                }
                .padding(14).background(Color.skMuted).clipShape(RoundedRectangle(cornerRadius: 12))

                Button {
                    let item = MKMapItem(placemark: MKPlacemark(coordinate: shop.coordinate))
                    item.name = shop.name
                    item.openInMaps(launchOptions: [
                        MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
                    ])
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                        Text("Get Directions in Maps")
                    }
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.skMuted)
                    .foregroundStyle(.skText)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                Spacer(minLength: 40)
            }
            .padding(20)
        }
    }

    @ViewBuilder
    private var contactRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let owners = shop.owners {
                HStack(spacing: 6) {
                    Image(systemName: "person.fill").font(.caption).foregroundStyle(.skSub)
                    Text(owners).font(.caption).foregroundStyle(.skSub)
                }
            }
            HStack(spacing: 10) {
                if let phone = shop.phone,
                   let phoneURL = URL(string: "tel:\(phone.filter { $0.isNumber || $0 == "+" })") {
                    Link(destination: phoneURL) {
                        contactChip(icon: "phone.fill", label: phone)
                    }
                }
                if let website = shop.website, let url = URL(string: website) {
                    Link(destination: url) {
                        contactChip(icon: "globe", label: "Website")
                    }
                }
            }
        }
    }

    private func contactChip(icon: String, label: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.caption).foregroundStyle(.skLime)
            Text(label).font(.caption.weight(.semibold)).foregroundStyle(.skText)
        }
        .padding(.horizontal, 10).padding(.vertical, 7)
        .background(Color.skMuted)
        .clipShape(Capsule())
    }

    private func infoChip(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.caption).foregroundStyle(color)
            Text(value).font(.caption.weight(.semibold)).foregroundStyle(.skText)
        }
    }
}

// MARK: - Spot Detail Sheet

struct SKSpotDetailSheet: View {
    let spot: SkateSpot
    @EnvironmentObject private var state: SkateCityAppState

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(spot.name).font(.title3.bold()).foregroundStyle(.skText)
                    Text(spot.neighborhood).font(.subheadline).foregroundStyle(.skSub)
                }
                Spacer()
                Button {
                    if state.isSaved(spot.id) { state.removeSpot(spot.id) }
                    else { state.saveSpot(spot.id) }
                } label: {
                    Image(systemName: state.isSaved(spot.id) ? "bookmark.fill" : "bookmark")
                        .font(.title3)
                        .foregroundStyle(state.isSaved(spot.id) ? .skLime : .skSub)
                }
            }
            SKDifficultyBadge(difficulty: spot.difficulty)
            Divider().background(Color.skBorder)
            VStack(alignment: .leading, spacing: 8) {
                Text("TERRAIN").font(.system(size: 10, weight: .black)).foregroundStyle(.skSub)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(spot.terrainTags, id: \.self) { tag in SKTag(label: tag) }
                    }
                }
            }
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("FEATURED TRICK").font(.system(size: 10, weight: .black)).foregroundStyle(.skSub)
                    Text(spot.featuredTrick).font(.subheadline.bold()).foregroundStyle(.skText)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text("POPULARITY").font(.system(size: 10, weight: .black)).foregroundStyle(.skSub)
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill").foregroundStyle(.skCoral).font(.subheadline)
                        Text("\(spot.popularity)").font(.subheadline.bold()).foregroundStyle(.skText)
                    }
                }
            }

            Button {
                let item = MKMapItem(placemark: MKPlacemark(coordinate: spot.coordinate))
                item.name = spot.name
                item.openInMaps(launchOptions: [
                    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
                ])
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                    Text("Get Directions in Maps")
                }
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.skMuted)
                .foregroundStyle(.skText)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            Spacer()
        }
        .padding(20)
    }
}
