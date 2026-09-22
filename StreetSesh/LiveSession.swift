import Foundation
import SwiftData

enum SessionVisibility: String, Codable, CaseIterable {
    case crew = "crew"
    case locals = "locals"
    case `public` = "public"

    var label: String {
        switch self {
        case .crew: return "Crew only"
        case .locals: return "Locals"
        case .public: return "Everyone"
        }
    }

    var icon: String {
        switch self {
        case .crew: return "lock.fill"
        case .locals: return "person.2.fill"
        case .public: return "globe"
        }
    }
}

@Model
final class LiveSession {
    var username: String
    var spotName: String
    var latitude: Double
    var longitude: Double
    var visibilityRaw: String
    var activity: String
    var startedAt: Date
    var expiresAt: Date
    var isActive: Bool
    var isCurrentUser: Bool

    var visibility: SessionVisibility {
        get { SessionVisibility(rawValue: visibilityRaw) ?? .locals }
        set { visibilityRaw = newValue.rawValue }
    }

    var timeActive: String {
        let elapsed = Int(-startedAt.timeIntervalSinceNow / 60)
        if elapsed < 1 { return "just now" }
        if elapsed < 60 { return "\(elapsed)m ago" }
        return "\(elapsed / 60)h \(elapsed % 60)m ago"
    }

    var isExpired: Bool {
        Date() > expiresAt
    }

    init(
        username: String,
        spotName: String,
        latitude: Double,
        longitude: Double,
        visibility: SessionVisibility = .locals,
        activity: String = "Skating",
        isCurrentUser: Bool = false
    ) {
        self.username = username
        self.spotName = spotName
        self.latitude = latitude
        self.longitude = longitude
        self.visibilityRaw = visibility.rawValue
        self.activity = activity
        self.startedAt = Date()
        self.expiresAt = Date().addingTimeInterval(3 * 60 * 60)
        self.isActive = true
        self.isCurrentUser = isCurrentUser
    }
}
