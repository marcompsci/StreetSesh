import Foundation
import SwiftUI

// MARK: - Leaderboard Category

enum SKLeaderboardCategory: String, CaseIterable, Identifiable {
    case sessionKings = "SESSION KINGS"
    case spotHunters  = "SPOT HUNTERS"
    case quizMasters  = "QUIZ MASTERS"
    case skateChamps  = "S.K.A.T.E CHAMPS"

    var id: String { rawValue }

    var subtitle: String {
        switch self {
        case .sessionKings: return "Most sessions logged"
        case .spotHunters:  return "Most spots discovered"
        case .quizMasters:  return "Know The Spot wins"
        case .skateChamps:  return "Game of S.K.A.T.E wins"
        }
    }

    var metricLabel: String {
        switch self {
        case .sessionKings: return "Sessions"
        case .spotHunters:  return "Spots"
        case .quizMasters:  return "Wins"
        case .skateChamps:  return "Wins"
        }
    }

    var accentHex: String {
        switch self {
        case .sessionKings: return "#CCFF40"
        case .spotHunters:  return "#FF5A35"
        case .quizMasters:  return "#3AB5E6"
        case .skateChamps:  return "#C77DFF"
        }
    }

    var iconName: String {
        switch self {
        case .sessionKings: return "bolt.fill"
        case .spotHunters:  return "mappin.and.ellipse"
        case .quizMasters:  return "lightbulb.fill"
        case .skateChamps:  return "trophy.fill"
        }
    }
}

// MARK: - Year Filter

enum SKLeaderboardYear: String, CaseIterable, Identifiable {
    case y2026   = "2026"
    case y2025   = "2025"
    case y2024   = "2024"
    case allTime = "All Time"
    var id: String { rawValue }
}

// MARK: - Entry

struct SKLeaderboardEntry: Identifiable {
    let id: UUID
    let rank: Int
    let handle: String
    let city: String
    let metricValue: Int
    let avatarInitial: String
    let avatarColorHex: String
    let isCurrentUser: Bool
}

// MARK: - Nearby Skater (simulated positions — not real-time tracking)

struct NearbySkater: Identifiable {
    let id: UUID
    let handle: String
    let displayName: String
    let avatarInitial: String
    let avatarColorHex: String
    let distanceText: String
    let statusText: String
    let radarAngleDeg: Double   // 0 = top (north), clockwise
    let radarNorm: Double       // 0 = center, 1 = radar edge
    var isChallengeable: Bool   = true
}

// MARK: - Coin

enum CoinFace: String, Equatable {
    case heads = "Heads"
    case tails = "Tails"
}

// MARK: - S.K.A.T.E Match

struct SKATEMatchRecord: Identifiable {
    let id: UUID
    let challengerHandle: String
    let challengedHandle: String
    var challengerLetters: [String]   // e.g. ["S", "K"]
    var challengedLetters: [String]
    var agreedSpotName: String
    let coinResult: CoinFace
    let startedAt: Date

    static let letters = ["S", "K", "A", "T", "E"]

    var challengerDisplay: String {
        challengerLetters.isEmpty ? "—" : challengerLetters.joined(separator: "·")
    }
    var challengedDisplay: String {
        challengedLetters.isEmpty ? "—" : challengedLetters.joined(separator: "·")
    }
    var isOver: Bool {
        challengerLetters.count == 5 || challengedLetters.count == 5
    }
}

// MARK: - Game Phase

enum GameOfSkatePhase: Equatable {
    case browse
    case confirmChallenge
    case challengeSent
    case incomingChallenge(UUID)
    case coinFlip
    case locationPick
    case matchActive

    static func == (lhs: GameOfSkatePhase, rhs: GameOfSkatePhase) -> Bool {
        switch (lhs, rhs) {
        case (.browse, .browse),
             (.confirmChallenge, .confirmChallenge),
             (.challengeSent, .challengeSent),
             (.coinFlip, .coinFlip),
             (.locationPick, .locationPick),
             (.matchActive, .matchActive): return true
        case (.incomingChallenge(let a), .incomingChallenge(let b)): return a == b
        default: return false
        }
    }
}

// MARK: - Mock Data

extension SKMockData {

    static func leaderboardEntries(for category: SKLeaderboardCategory,
                                   year: SKLeaderboardYear) -> [SKLeaderboardEntry] {
        let factor: Double = {
            switch year {
            case .y2026: return 1.0
            case .y2025: return 0.74
            case .y2024: return 0.52
            case .allTime: return 3.1
            }
        }()
        return rawBoard(for: category).map { e in
            SKLeaderboardEntry(id: UUID(), rank: e.rank, handle: e.handle, city: e.city,
                               metricValue: Int(Double(e.metricValue) * factor),
                               avatarInitial: e.avatarInitial,
                               avatarColorHex: e.avatarColorHex,
                               isCurrentUser: e.isCurrentUser)
        }
    }

    private static func rawBoard(for cat: SKLeaderboardCategory) -> [SKLeaderboardEntry] {
        switch cat {
        case .sessionKings: return _sessionKings
        case .spotHunters:  return _spotHunters
        case .quizMasters:  return _quizMasters
        case .skateChamps:  return _skateChamps
        }
    }

    private static let _sessionKings: [SKLeaderboardEntry] = [
        .init(id: UUID(), rank: 1,  handle: "@grind_marcus",  city: "San Francisco, CA", metricValue: 233, avatarInitial: "M", avatarColorHex: "#CCFF40", isCurrentUser: false),
        .init(id: UUID(), rank: 2,  handle: "@jade_fakie",    city: "Oakland, CA",       metricValue: 187, avatarInitial: "J", avatarColorHex: "#3AB5E6", isCurrentUser: false),
        .init(id: UUID(), rank: 3,  handle: "@dre_rips",      city: "San Jose, CA",      metricValue: 142, avatarInitial: "D", avatarColorHex: "#FF5A35", isCurrentUser: false),
        .init(id: UUID(), rank: 4,  handle: "@rosagrind",     city: "Daly City, CA",     metricValue: 98,  avatarInitial: "R", avatarColorHex: "#C77DFF", isCurrentUser: false),
        .init(id: UUID(), rank: 5,  handle: "@sk8_cali",      city: "Fresno, CA",        metricValue: 87,  avatarInitial: "S", avatarColorHex: "#FFD700", isCurrentUser: false),
        .init(id: UUID(), rank: 6,  handle: "@tone_ledge",    city: "Sacramento, CA",    metricValue: 74,  avatarInitial: "T", avatarColorHex: "#FF5A35", isCurrentUser: false),
        .init(id: UUID(), rank: 7,  handle: "@you",           city: "Daly City, CA",     metricValue: 62,  avatarInitial: "Y", avatarColorHex: "#CCFF40", isCurrentUser: true),
        .init(id: UUID(), rank: 8,  handle: "@concrete_k",   city: "Berkeley, CA",      metricValue: 55,  avatarInitial: "K", avatarColorHex: "#3AB5E6", isCurrentUser: false),
        .init(id: UUID(), rank: 9,  handle: "@bayboarder",   city: "San Francisco, CA", metricValue: 41,  avatarInitial: "B", avatarColorHex: "#C77DFF", isCurrentUser: false),
        .init(id: UUID(), rank: 10, handle: "@flowstate",    city: "San Diego, CA",     metricValue: 38,  avatarInitial: "F", avatarColorHex: "#FF5A35", isCurrentUser: false),
    ]

    private static let _spotHunters: [SKLeaderboardEntry] = [
        .init(id: UUID(), rank: 1, handle: "@jade_fakie",    city: "Oakland, CA",       metricValue: 47, avatarInitial: "J", avatarColorHex: "#3AB5E6", isCurrentUser: false),
        .init(id: UUID(), rank: 2, handle: "@dre_rips",      city: "San Jose, CA",      metricValue: 38, avatarInitial: "D", avatarColorHex: "#FF5A35", isCurrentUser: false),
        .init(id: UUID(), rank: 3, handle: "@sk8_cali",      city: "Fresno, CA",        metricValue: 31, avatarInitial: "S", avatarColorHex: "#FFD700", isCurrentUser: false),
        .init(id: UUID(), rank: 4, handle: "@grind_marcus",  city: "San Francisco, CA", metricValue: 29, avatarInitial: "M", avatarColorHex: "#CCFF40", isCurrentUser: false),
        .init(id: UUID(), rank: 5, handle: "@rosagrind",     city: "Daly City, CA",     metricValue: 22, avatarInitial: "R", avatarColorHex: "#C77DFF", isCurrentUser: false),
        .init(id: UUID(), rank: 6, handle: "@you",           city: "Daly City, CA",     metricValue: 18, avatarInitial: "Y", avatarColorHex: "#CCFF40", isCurrentUser: true),
        .init(id: UUID(), rank: 7, handle: "@bayboarder",   city: "San Francisco, CA", metricValue: 15, avatarInitial: "B", avatarColorHex: "#C77DFF", isCurrentUser: false),
        .init(id: UUID(), rank: 8, handle: "@concrete_k",   city: "Berkeley, CA",      metricValue: 12, avatarInitial: "K", avatarColorHex: "#3AB5E6", isCurrentUser: false),
    ]

    private static let _quizMasters: [SKLeaderboardEntry] = [
        .init(id: UUID(), rank: 1, handle: "@rosagrind",     city: "Daly City, CA",     metricValue: 14, avatarInitial: "R", avatarColorHex: "#C77DFF", isCurrentUser: false),
        .init(id: UUID(), rank: 2, handle: "@tone_ledge",    city: "Sacramento, CA",    metricValue: 11, avatarInitial: "T", avatarColorHex: "#FF5A35", isCurrentUser: false),
        .init(id: UUID(), rank: 3, handle: "@grind_marcus",  city: "San Francisco, CA", metricValue: 9,  avatarInitial: "M", avatarColorHex: "#CCFF40", isCurrentUser: false),
        .init(id: UUID(), rank: 4, handle: "@you",           city: "Daly City, CA",     metricValue: 7,  avatarInitial: "Y", avatarColorHex: "#CCFF40", isCurrentUser: true),
        .init(id: UUID(), rank: 5, handle: "@sk8_cali",      city: "Fresno, CA",        metricValue: 6,  avatarInitial: "S", avatarColorHex: "#FFD700", isCurrentUser: false),
        .init(id: UUID(), rank: 6, handle: "@jade_fakie",    city: "Oakland, CA",       metricValue: 5,  avatarInitial: "J", avatarColorHex: "#3AB5E6", isCurrentUser: false),
        .init(id: UUID(), rank: 7, handle: "@dre_rips",      city: "San Jose, CA",      metricValue: 4,  avatarInitial: "D", avatarColorHex: "#FF5A35", isCurrentUser: false),
    ]

    private static let _skateChamps: [SKLeaderboardEntry] = [
        .init(id: UUID(), rank: 1, handle: "@dre_rips",      city: "San Jose, CA",      metricValue: 8, avatarInitial: "D", avatarColorHex: "#FF5A35", isCurrentUser: false),
        .init(id: UUID(), rank: 2, handle: "@grind_marcus",  city: "San Francisco, CA", metricValue: 6, avatarInitial: "M", avatarColorHex: "#CCFF40", isCurrentUser: false),
        .init(id: UUID(), rank: 3, handle: "@jade_fakie",    city: "Oakland, CA",       metricValue: 5, avatarInitial: "J", avatarColorHex: "#3AB5E6", isCurrentUser: false),
        .init(id: UUID(), rank: 4, handle: "@you",           city: "Daly City, CA",     metricValue: 3, avatarInitial: "Y", avatarColorHex: "#CCFF40", isCurrentUser: true),
        .init(id: UUID(), rank: 5, handle: "@tone_ledge",    city: "Sacramento, CA",    metricValue: 3, avatarInitial: "T", avatarColorHex: "#FF5A35", isCurrentUser: false),
        .init(id: UUID(), rank: 6, handle: "@rosagrind",     city: "Daly City, CA",     metricValue: 2, avatarInitial: "R", avatarColorHex: "#C77DFF", isCurrentUser: false),
        .init(id: UUID(), rank: 7, handle: "@sk8_cali",      city: "Fresno, CA",        metricValue: 2, avatarInitial: "S", avatarColorHex: "#FFD700", isCurrentUser: false),
    ]

    // Simulated nearby skaters for Game of S.K.A.T.E — not real-time location data
    static let nearbySkaters: [NearbySkater] = [
        NearbySkater(id: UUID(), handle: "@grind_marcus", displayName: "Marcus R.",
                     avatarInitial: "M", avatarColorHex: "#CCFF40",
                     distanceText: "0.3 mi", statusText: "At Pier 7",
                     radarAngleDeg: 35,  radarNorm: 0.30),
        NearbySkater(id: UUID(), handle: "@jade_fakie", displayName: "Jade W.",
                     avatarInitial: "J", avatarColorHex: "#3AB5E6",
                     distanceText: "0.5 mi", statusText: "Skating nearby",
                     radarAngleDeg: 210, radarNorm: 0.48),
        NearbySkater(id: UUID(), handle: "@dre_rips", displayName: "Dre O.",
                     avatarInitial: "D", avatarColorHex: "#FF5A35",
                     distanceText: "0.7 mi", statusText: "At Potrero Banks",
                     radarAngleDeg: 130, radarNorm: 0.62),
        NearbySkater(id: UUID(), handle: "@tone_ledge", displayName: "Tony L.",
                     avatarInitial: "T", avatarColorHex: "#C77DFF",
                     distanceText: "1.1 mi", statusText: "Looking to skate",
                     radarAngleDeg: 280, radarNorm: 0.76),
        NearbySkater(id: UUID(), handle: "@sk8_cali", displayName: "Jordan L.",
                     avatarInitial: "S", avatarColorHex: "#FFD700",
                     distanceText: "1.4 mi", statusText: "On the move",
                     radarAngleDeg: 70,  radarNorm: 0.88, isChallengeable: false),
    ]

    static let skateSpotOptions = [
        "Pier 7", "Potrero Banks", "Civic Center Plaza",
        "Embarcadero Ledges", "Mission Hubba", "Geneva Banks",
        "Wallenberg Four", "Custom Location"
    ]
}
