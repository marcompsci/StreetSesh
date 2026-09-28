//  SpotStore.swift
//  Loads 3D spots from the bundle and sharpens estimated pins with Apple's geocoder (cached).

import Foundation
import CoreLocation
import MapKit
import Observation

@MainActor
@Observable
final class SpotStore {
    private(set) var spots: [Spot3D] = []
    private(set) var regions: [String] = []
    var loadError: String?

    private let cacheKey = "streetsesh.geocodeCache.v1"

    func load() {
        guard spots.isEmpty else { return }
        guard let url = Bundle.main.url(forResource: "streetsesh_spots", withExtension: "json") else {
            loadError = "streetsesh_spots.json missing from app bundle"; return
        }
        do {
            let catalog = try JSONDecoder().decode(SpotCatalog.self, from: Data(contentsOf: url))
            regions = catalog.regions
            spots = applyCache(to: catalog.spots)
        } catch {
            loadError = "Could not read spots: \(error)"
        }
    }

    func filtered(_ categories: Set<SpotCategory>, region: String? = nil) -> [Spot3D] {
        spots.filter { categories.contains($0.category) && (region == nil || $0.region == region) }
    }

    func mapRegion(for region: String?) -> MKCoordinateRegion {
        let list = region == nil ? spots : spots.filter { $0.region == region }
        guard !list.isEmpty else {
            return MKCoordinateRegion(center: .init(latitude: 37.7749, longitude: -122.4194),
                                      span: .init(latitudeDelta: 0.15, longitudeDelta: 0.15))
        }
        let lats = list.map(\.latitude), lons = list.map(\.longitude)
        let center = CLLocationCoordinate2D(latitude: (lats.min()! + lats.max()!) / 2,
                                             longitude: (lons.min()! + lons.max()!) / 2)
        return MKCoordinateRegion(
            center: center,
            span: .init(latitudeDelta: max(0.02, (lats.max()! - lats.min()!) * 1.35),
                        longitudeDelta: max(0.02, (lons.max()! - lons.min()!) * 1.35))
        )
    }

    func refineCoordinates() async {
        var cache = loadCache()
        let geocoder = CLGeocoder()
        for spot in spots where !spot.coordVerified && cache[spot.id] == nil {
            do {
                let marks = try await geocoder.geocodeAddressString(spot.address)
                if let loc = marks.first?.location {
                    let est = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
                    if loc.distance(from: est) < 3_000 {
                        cache[spot.id] = [loc.coordinate.latitude, loc.coordinate.longitude]
                        saveCache(cache)
                        if let i = spots.firstIndex(where: { $0.id == spot.id }) {
                            spots[i].latitude = loc.coordinate.latitude
                            spots[i].longitude = loc.coordinate.longitude
                        }
                    }
                }
            } catch { }
            try? await Task.sleep(for: .milliseconds(1100))
        }
    }

    private func applyCache(to list: [Spot3D]) -> [Spot3D] {
        let cache = loadCache()
        return list.map { s in
            var s = s
            if !s.coordVerified, let c = cache[s.id], c.count == 2 {
                s.latitude = c[0]; s.longitude = c[1]
            }
            return s
        }
    }
    private func loadCache() -> [String: [Double]] {
        (UserDefaults.standard.dictionary(forKey: cacheKey) as? [String: [Double]]) ?? [:]
    }
    private func saveCache(_ c: [String: [Double]]) { UserDefaults.standard.set(c, forKey: cacheKey) }
}
