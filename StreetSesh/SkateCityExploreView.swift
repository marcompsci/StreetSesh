import SwiftUI
import MapKit

struct SkateCityExploreView: View {
    @EnvironmentObject private var state: SkateCityAppState
    @State private var locationManager = SKLocationManager()
    @State private var displayMode: DisplayMode = .map
    @State private var mapPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: SKMockData.defaultLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)
        )
    )
    @State private var selectedShop: SkateShop? = nil
    @State private var selectedSpot: SkateSpot? = nil
    @State private var filterMode: FilterMode = .all
    @State private var showPrivacyInfo = false

    enum DisplayMode: String, CaseIterable {
        case map  = "Map"
        case list = "List"
    }
    enum FilterMode: String, CaseIterable {
        case all    = "All"
        case shops  = "Shops"
        case spots  = "Spots"
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
        .sheet(isPresented: $showPrivacyInfo) {
            SKPrivacyPanel(locationManager: locationManager)
                .presentationDetents([.medium])
                .presentationBackground(Color.skDark)
        }
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

            // Mode + Filter
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
        Map(position: $mapPosition) {
            // Shops
            if filterMode != .spots {
                ForEach(SKMockData.shops) { shop in
                    Annotation(shop.name, coordinate: shop.coordinate, anchor: .bottom) {
                        shopPin(shop)
                            .onTapGesture { selectedShop = shop }
                    }
                }
            }
            // Spots
            if filterMode != .shops {
                ForEach(SKMockData.spots) { spot in
                    Annotation(spot.name, coordinate: spot.coordinate, anchor: .bottom) {
                        spotPin(spot)
                            .onTapGesture { selectedSpot = spot }
                    }
                }
            }
        }
        .mapStyle(.standard)
        .ignoresSafeArea(edges: .bottom)
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
            }
            .padding(16)
        }
    }

    private var shopsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SKSectionHeader(title: "SKATE SHOPS")
            ForEach(SKMockData.shops) { shop in
                Button { selectedShop = shop } label: {
                    shopRow(shop)
                }
            }
        }
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
                Text(shop.specialty)
                    .font(.caption).foregroundStyle(.skSub)
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
            ForEach(SKMockData.spots) { spot in
                Button { selectedSpot = spot } label: {
                    spotRow(spot)
                }
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
}

// MARK: - Triangle shape for map pins

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

// MARK: - Shop Detail Sheet

struct SKShopDetailSheet: View {
    let shop: SkateShop

    var body: some View {
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
                    Text(shop.address).font(.subheadline).foregroundStyle(.skSub)
                }
            }
            HStack(spacing: 20) {
                infoChip(icon: "star.fill", value: String(format: "%.1f", shop.rating), color: .yellow)
                infoChip(icon: "location.fill", value: shop.distanceText, color: .skLime)
                infoChip(icon: "tag.fill", value: shop.specialty, color: .skCoral)
            }
            Divider().background(Color.skBorder)
            VStack(alignment: .leading, spacing: 6) {
                Text("FEATURED CHALLENGE").font(.system(size: 10, weight: .black)).foregroundStyle(.skSub)
                Text(shop.featuredChallenge).font(.subheadline.bold()).foregroundStyle(.skText)
            }
            .padding(14).background(Color.skMuted).clipShape(RoundedRectangle(cornerRadius: 12))
            Spacer()
        }
        .padding(20)
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
            Spacer()
        }
        .padding(20)
    }
}
