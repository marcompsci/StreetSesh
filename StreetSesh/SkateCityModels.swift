import Foundation
import SwiftUI
import CoreLocation

// MARK: - Location Privacy

enum LocationMode: String, CaseIterable {
    case off               = "Off"
    case approximateNearby = "Nearby Discovery"
    case activeSessionOnly = "Active Session Only"
}

struct PrivacySettings: Equatable {
    var locationMode: LocationMode = .off
    var discoverability: String    = "Friends"
    var profileVisibility: String  = "Public"
}

// MARK: - Home Theme

enum HomeTheme: String, CaseIterable, Codable {
    case concrete = "Concrete"
    case sunset   = "Sunset"
    case neon     = "Neon"
    case minimal  = "Minimal"

    var wallGradient: [Color] {
        switch self {
        case .concrete: return [Color(hex: "#252525"), Color(hex: "#131313")]
        case .sunset:   return [Color(hex: "#3D1000"), Color(hex: "#120500")]
        case .neon:     return [Color(hex: "#031403"), Color(hex: "#0A0A0A")]
        case .minimal:  return [Color(hex: "#1E1E1E"), Color(hex: "#0E0E0E")]
        }
    }
    var accent: Color {
        switch self {
        case .concrete: return .skLime
        case .sunset:   return .skCoral
        case .neon:     return .skLime
        case .minimal:  return Color.white.opacity(0.5)
        }
    }
}

// MARK: - Avatar Style

struct AvatarStyle: Codable, Equatable {
    var skinTone:  String = "#F3A96A"
    var hairStyle: Int    = 0
    var hairColor: String = "#1A1A1A"
    var top:       String = "#E74C3C"
    var pants:     String = "#2C3E50"
    var shoes:     String = "#F1C40F"
    var accessory: String = "none"
}

// MARK: - User Profile

struct UserProfile: Identifiable {
    let id: UUID
    var displayName: String
    var handle: String
    var city: String
    var crewName: String
    var level: Int
    var xp: Int
    var xpMax: Int
    var avatarStyle: AvatarStyle
    var selectedBoard: String   // board ID key
    var homeTheme: HomeTheme
    var privacySettings: PrivacySettings

    var xpProgress: Double { min(Double(xp) / Double(max(xpMax, 1)), 1.0) }
}

// MARK: - Skate Shop

struct SkateShop: Identifiable {
    let id: UUID
    var name: String
    var address: String
    var neighborhood: String
    var coordinate: CLLocationCoordinate2D
    var distanceText: String
    var rating: Double
    var isOpen: Bool
    var specialty: String
    var accentColorHex: String
    var featuredChallenge: String
    var phone: String?    = nil
    var website: String?  = nil
    var owners: String?   = nil
}

// MARK: - Skate Spot

struct SkateSpot: Identifiable {
    let id: UUID
    var name: String
    var neighborhood: String
    var coordinate: CLLocationCoordinate2D
    var difficulty: SpotDifficulty
    var terrainTags: [String]
    var popularity: Int
    var featuredTrick: String
}

enum SpotDifficulty: String {
    case beginner     = "Beginner"
    case intermediate = "Intermediate"
    case advanced     = "Advanced"
    case pro          = "Pro"

    var color: Color {
        switch self {
        case .beginner:     return .green
        case .intermediate: return Color(hex: "#F1C40F")
        case .advanced:     return .skCoral
        case .pro:          return Color(hex: "#E74C3C")
        }
    }
}

// MARK: - Skate Challenge

struct SkateChallenge: Identifiable {
    let id: UUID
    var title: String
    var description: String
    var difficulty: String
    var rewardXP: Int
    var duration: String
    var trickTags: [String]
    var isCompleted: Bool
    var shopName: String
}

// MARK: - Skate Clip

struct SkateClip: Identifiable {
    let id: UUID
    var creatorName: String
    var creatorHandle: String
    var challengeTitle: String
    var score: Int
    var likes: Int
    var comments: Int
    var createdAt: Date
    var trickTags: [String]
    var isLiked: Bool
}

// MARK: - Crew Session

struct CrewSession: Identifiable {
    let id: UUID
    var title: String
    var hostName: String
    var neighborhood: String
    var startTime: Date
    var participantCount: Int
    var maxParticipants: Int
    var privacy: SessionPrivacy
    var status: SessionStatus
}

enum SessionPrivacy: String, CaseIterable {
    case friendsOnly = "Friends Only"
    case crew        = "Crew"
    case inviteOnly  = "Invite Only"
}

enum SessionStatus: String {
    case upcoming = "Upcoming"
    case active   = "Active"
    case ended    = "Ended"
}

// MARK: - Board

struct SKBoard: Identifiable {
    let id: String
    let name: String
    let tagline: String
    let accentHex: String
}
