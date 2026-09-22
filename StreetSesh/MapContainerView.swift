import SwiftUI
import MapKit
import SwiftData

struct MapContainerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var spots: [Spot]
    @Query private var liveSessions: [LiveSession]

    @State private var locationManager = LocationManager()
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            distance: 500,
            heading: 0,
            pitch: 55
        )
    )
    @State private var isSessionMode = true
    @State private var selectedSpot: Spot?
    @State private var showGoLive = false
    @State private var showSpotSubmit = false
    @State private var showDiscover = false

    private let sfCenter = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)

    var activeOtherSessions: [LiveSession] {
        liveSessions.filter { $0.isActive && !$0.isExpired && !$0.isCurrentUser }
    }

    var body: some View {
        ZStack {
            mapLayer
            overlayLayer
        }
        .ignoresSafeArea()
        .sheet(item: $selectedSpot) { spot in
            SpotDetailSheet(spot: spot)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color.black)
        }
        .sheet(isPresented: $showGoLive) {
            GoLiveView()
                .presentationBackground(Color.black)
        }
        .sheet(isPresented: $showSpotSubmit) {
            SpotSubmitView()
                .presentationBackground(Color.black)
        }
        .sheet(isPresented: $showDiscover) {
            SpotDiscoverView(userCoordinate: locationManager.location?.coordinate)
                .presentationBackground(Color.black)
        }
        .onAppear {
            locationManager.requestAuthorization()
        }
    }

    private var mapLayer: some View {
        Map(position: $cameraPosition) {
            UserAnnotation()

            ForEach(spots.filter { !$0.isRetired }) { spot in
                let hasLive = liveSessions.contains {
                    $0.spotName == spot.name && $0.isActive && !$0.isExpired
                }
                Annotation(spot.name, coordinate: spot.coordinate, anchor: .bottom) {
                    SpotPinView(spot: spot, hasLiveSession: hasLive)
                        .onTapGesture { selectedSpot = spot }
                }
            }

            ForEach(activeOtherSessions) { session in
                Annotation(
                    session.username,
                    coordinate: CLLocationCoordinate2D(latitude: session.latitude, longitude: session.longitude),
                    anchor: .center
                ) {
                    LiveSessionPinView(session: session)
                }
            }
        }
        .mapStyle(
            isSessionMode
                ? .standard(elevation: .realistic, pointsOfInterest: .excludingAll)
                : .standard(elevation: .flat, pointsOfInterest: .all)
        )
    }

    private var overlayLayer: some View {
        VStack {
            HStack {
                modeToggle
                Spacer()
                discoverButton
            }
            .padding(.horizontal)
            .padding(.top, 60)

            Spacer()

            HStack {
                Spacer()
                VStack(spacing: 12) {
                    circleButton(icon: "plus", tint: .white) { showSpotSubmit = true }
                    circleButton(icon: "antenna.radiowaves.left.and.right", tint: .orange) { showGoLive = true }
                }
                .padding(.trailing)
                .padding(.bottom, 90)
            }
        }
    }

    private var discoverButton: some View {
        Button { showDiscover = true } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }

    private var modeToggle: some View {
        HStack(spacing: 0) {
            modeButton("SESSION", active: isSessionMode) {
                isSessionMode = true
                switchCamera()
            }
            modeButton("NAVIGATE", active: !isSessionMode) {
                isSessionMode = false
                switchCamera()
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange.opacity(0.4), lineWidth: 1))
    }

    @ViewBuilder
    private func modeButton(_ label: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 11, weight: .black))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(active ? Color.orange : Color.clear)
                .foregroundStyle(active ? .black : .white)
        }
    }

    @ViewBuilder
    private func circleButton(icon: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(tint == .white ? Color.black : Color.white)
                .frame(width: 52, height: 52)
                .background(tint)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        }
    }

    private func switchCamera() {
        let center = locationManager.location?.coordinate ?? sfCenter
        withAnimation(.easeInOut(duration: 0.7)) {
            cameraPosition = .camera(MapCamera(
                centerCoordinate: center,
                distance: isSessionMode ? 400 : 1500,
                heading: isSessionMode ? locationManager.heading : 0,
                pitch: isSessionMode ? 55 : 0
            ))
        }
    }
}
