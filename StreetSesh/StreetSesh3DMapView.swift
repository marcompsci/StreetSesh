//  StreetSesh3DMapView.swift
//  Standalone map with 3D spot pins. Used as a tab in the main app or embedded inside existing maps.
//  Tap a pin → 3D preview bubble + bottom card. Tap again → full 3D sheet with AR button.

import SwiftUI
import MapKit
import CoreLocation

struct StreetSesh3DMapView: View {
    @State private var store = SpotStore()
    @State private var locationProvider = Spot3DLocationProvider()
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedID: String?
    @State private var sheetSpot: Spot3D?
    @State private var categories: Set<SpotCategory> = Set(SpotCategory.allCases)
    @State private var region: String? = nil
    @State private var live = false

    private var visible: [Spot3D] { store.filtered(categories, region: region) }

    var body: some View {
        Map(position: $position, selection: $selectedID) {
            UserAnnotation()
            ForEach(visible) { spot in
                Annotation(spot.name, coordinate: spot.coordinate, anchor: .bottom) {
                    Spot3DPin(spot: spot, isSelected: selectedID == spot.id)
                        .onTapGesture {
                            if selectedID == spot.id { sheetSpot = spot } else { selectedID = spot.id }
                        }
                }
                .annotationTitles(.hidden)
                .tag(spot.id)
            }
        }
        .mapStyle(live ? .hybrid(elevation: .realistic, pointsOfInterest: .excludingAll)
                       : .standard(elevation: .realistic, emphasis: .muted, pointsOfInterest: .excludingAll))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapPitchToggle()
            MapScaleView()
        }
        .safeAreaInset(edge: .top) { topBar }
        .safeAreaInset(edge: .bottom) { if let s = selectedSpot { previewCard(s) } }
        .sheet(item: $sheetSpot) { spot in
            Spot3DDetailSheet(spot: spot)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: live) { _, on in
            if on {
                locationProvider.start()
                position = .userLocation(followsHeading: true, fallback: .region(store.mapRegion(for: region)))
            } else {
                position = .region(store.mapRegion(for: region))
            }
        }
        .task {
            store.load()
            position = .region(store.mapRegion(for: nil))
            await store.refineCoordinates()
        }
    }

    private var selectedSpot: Spot3D? { visible.first { $0.id == selectedID } }

    // MARK: - Top bar: region jump + category filters + live toggle

    private var topBar: some View {
        VStack(spacing: 8) {
            HStack {
                Menu {
                    Button("All California spots") { jump(to: nil) }
                    ForEach(store.regions, id: \.self) { r in Button(r) { jump(to: r) } }
                } label: {
                    Label(region ?? "All regions", systemImage: "map").font(.subheadline.weight(.semibold))
                }
                .buttonStyle(.bordered)
                Spacer()
                Toggle(isOn: $live) {
                    Label("Live", systemImage: live ? "dot.radiowaves.left.and.right" : "location")
                }
                .toggleStyle(.button).tint(.red)
            }
            HStack {
                ForEach(SpotCategory.allCases) { c in
                    let on = categories.contains(c)
                    Button {
                        if on { if categories.count > 1 { categories.remove(c) } } else { categories.insert(c) }
                    } label: {
                        Label(c.label, systemImage: c.symbol).font(.caption.weight(.semibold))
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(on ? c.tint : Color.secondary.opacity(0.15), in: Capsule())
                            .foregroundStyle(on ? .white : .primary)
                    }
                }
                Spacer()
            }
            if live, let here = locationProvider.last {
                nearbyStrip(from: here)
            }
        }
        .padding(.horizontal).padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }

    private func nearbyStrip(from here: CLLocation) -> some View {
        let near = visible.sorted {
            here.distance(from: CLLocation(latitude: $0.latitude, longitude: $0.longitude)) <
            here.distance(from: CLLocation(latitude: $1.latitude, longitude: $1.longitude))
        }.prefix(8)
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(near)) { s in
                    let miles = here.distance(from: CLLocation(latitude: s.latitude, longitude: s.longitude)) / 1609.34
                    Button {
                        selectedID = s.id
                        withAnimation { position = .camera(MapCamera(centerCoordinate: s.coordinate, distance: 600, heading: 0, pitch: 60)) }
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(s.name).font(.caption.bold()).lineLimit(1)
                            Text(String(format: "%.1f mi", miles)).font(.caption2).foregroundStyle(.secondary)
                        }
                        .padding(8).frame(width: 140, alignment: .leading)
                        .background(.background, in: RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Bottom preview card (tap → full 3D sheet)

    private func previewCard(_ s: Spot3D) -> some View {
        Button { sheetSpot = s } label: {
            HStack(spacing: 12) {
                Image(uiImage: SpotSceneFactory.snapshot(for: s))
                    .resizable().scaledToFill().frame(width: 96, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading, spacing: 3) {
                    Text(s.name).font(.headline).lineLimit(1)
                    Text("\(s.kindLabel) · \(s.city)").font(.caption).foregroundStyle(.secondary)
                    Text("Tap for 3D view").font(.caption2.weight(.semibold)).foregroundStyle(s.category.tint)
                }
                Spacer()
                Image(systemName: "cube.transparent").font(.title2).foregroundStyle(s.category.tint)
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
            .padding(.horizontal).padding(.bottom, 6)
        }
        .buttonStyle(.plain)
    }

    private func jump(to r: String?) {
        region = r; selectedID = nil; live = false
        withAnimation { position = .region(store.mapRegion(for: r)) }
    }
}

// MARK: - Location provider for Live mode

@Observable
final class Spot3DLocationProvider: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var last: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    func start() { manager.requestWhenInUseAuthorization(); manager.startUpdatingLocation() }
    func locationManager(_ m: CLLocationManager, didUpdateLocations locs: [CLLocation]) { last = locs.last }
}
