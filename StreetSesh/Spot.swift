import Foundation
import SwiftData
import CoreLocation

@Model
final class Spot {
    var name: String
    var latitude: Double
    var longitude: Double
    var obstacles: [String]
    var spotDescription: String
    var visibilityRaw: String
    var bustStatusRaw: String
    var bustConfidenceDate: Date
    var fameTierRaw: String
    var bestTimeOfDay: String
    var isRetired: Bool
    var submittedAt: Date

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var visibility: VisibilityTier {
        get { VisibilityTier(rawValue: visibilityRaw) ?? .public }
        set { visibilityRaw = newValue.rawValue }
    }

    var bustStatus: BustStatus {
        get { BustStatus(rawValue: bustStatusRaw) ?? .green }
        set { bustStatusRaw = newValue.rawValue }
    }

    var fameTier: FameTier {
        get { FameTier(rawValue: fameTierRaw) ?? .local }
        set { fameTierRaw = newValue.rawValue }
    }

    // Bust info is considered stale after 90 days without an update
    var bustIsStale: Bool {
        Date().timeIntervalSince(bustConfidenceDate) > (90 * 24 * 60 * 60)
    }

    init(
        name: String,
        latitude: Double,
        longitude: Double,
        obstacles: [String] = [],
        description: String = "",
        visibility: VisibilityTier = .public,
        bustStatus: BustStatus = .green,
        fameTier: FameTier = .local,
        bestTimeOfDay: String = "Anytime"
    ) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.obstacles = obstacles
        self.spotDescription = description
        self.visibilityRaw = visibility.rawValue
        self.bustStatusRaw = bustStatus.rawValue
        self.bustConfidenceDate = Date()
        self.fameTierRaw = fameTier.rawValue
        self.bestTimeOfDay = bestTimeOfDay
        self.isRetired = false
        self.submittedAt = Date()
    }
}

enum VisibilityTier: String, Codable, CaseIterable {
    case `public` = "public"
    case localOnly = "local_only"
    case crewOnly = "crew_only"
    case radiusOnly = "radius_only"

    var label: String {
        switch self {
        case .public: return "Public"
        case .localOnly: return "Locals Only"
        case .crewOnly: return "Crew Only"
        case .radiusOnly: return "Nearby Only"
        }
    }

    var icon: String {
        switch self {
        case .public: return "globe"
        case .localOnly: return "person.2.fill"
        case .crewOnly: return "lock.fill"
        case .radiusOnly: return "location.circle.fill"
        }
    }
}

enum BustStatus: String, Codable, CaseIterable {
    case green = "green"
    case yellow = "yellow"
    case red = "red"

    var label: String {
        switch self {
        case .green: return "All Clear"
        case .yellow: return "Watch Out"
        case .red: return "Hot"
        }
    }
}

enum FameTier: String, Codable, CaseIterable {
    case legendary = "legendary"
    case iconic = "iconic"
    case local = "local"
    case hidden = "hidden"

    var label: String {
        switch self {
        case .legendary: return "Legendary"
        case .iconic: return "Iconic"
        case .local: return "Local"
        case .hidden: return "Hidden Gem"
        }
    }
}
