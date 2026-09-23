import Foundation
import CoreLocation

// Privacy-safe, one-shot location manager for SkateCity nearby discovery.
// Never persists coordinates. Never runs in background. Never calls startUpdatingLocation.

@Observable
final class SKLocationManager: NSObject, CLLocationManagerDelegate {

    var authStatus: CLAuthorizationStatus = .notDetermined
    var approximateCoordinate: CLLocationCoordinate2D? = nil
    var nearestNeighborhood: String = ""
    var statusLabel: String = "Location is off"

    private let manager = CLLocationManager()
    private var hasFetched = false

    override init() {
        super.init()
        manager.delegate = self
        authStatus = manager.authorizationStatus
    }

    // Call only when the user explicitly taps "Enable Nearby Discovery"
    func requestPermission() {
        #if os(iOS)
        manager.requestWhenInUseAuthorization()
        #endif
    }

    // Called after permission is granted — one-shot, low-accuracy fetch
    private func fetchOnce() {
        guard !hasFetched else { return }
        guard isEnabled else { return }
        hasFetched = true
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestLocation()
    }

    // CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        // Truncate to ~1 km resolution for privacy
        let lat = (loc.coordinate.latitude  * 10).rounded() / 10
        let lng = (loc.coordinate.longitude * 10).rounded() / 10
        approximateCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        statusLabel = "Nearby discovery is on"
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        hasFetched = false
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authStatus = manager.authorizationStatus
        if isEnabled {
            fetchOnce()
            statusLabel = "Nearby discovery is on"
        } else if authStatus == .denied || authStatus == .restricted {
            statusLabel = "Location is off"
        }
    }

    // The map center — falls back to Daly City when permission is off
    var mapCenter: CLLocationCoordinate2D {
        approximateCoordinate ?? SKMockData.defaultLocation
    }

    var isEnabled: Bool {
        #if os(iOS)
        return authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways
        #else
        return authStatus == .authorizedAlways
        #endif
    }
}
