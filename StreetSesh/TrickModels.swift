import Foundation
import SwiftData

// MARK: - Personal Trick

@Model
final class PersonalTrick {
    var id:           UUID
    var username:     String
    var name:         String
    var categoryRaw:  String
    var difficultyRaw: Int
    var statusRaw:    String
    var notes:        String
    var addedAt:      Date
    var landedAt:     Date?

    init(username: String, name: String, category: TrickCategory,
         difficulty: TrickDifficulty, status: TrickStatus, notes: String = "") {
        self.id           = UUID()
        self.username     = username
        self.name         = name
        self.categoryRaw  = category.rawValue
        self.difficultyRaw = difficulty.rawValue
        self.statusRaw    = status.rawValue
        self.notes        = notes
        self.addedAt      = Date()
        self.landedAt     = status == .landed ? Date() : nil
    }
}

extension PersonalTrick {
    var category:   TrickCategory  { TrickCategory(rawValue: categoryRaw)    ?? .flatground }
    var difficulty: TrickDifficulty { TrickDifficulty(rawValue: difficultyRaw) ?? .intermediate }
    var status:     TrickStatus    { TrickStatus(rawValue: statusRaw)        ?? .wantToLearn }

    func setStatus(_ newStatus: TrickStatus) {
        statusRaw = newStatus.rawValue
        if newStatus == .landed && landedAt == nil { landedAt = Date() }
    }
}

// MARK: - Trick Category

enum TrickCategory: String, CaseIterable, Identifiable {
    case flatground  = "flatground"
    case grinds      = "grinds"
    case manual      = "manual"
    case park        = "park"
    case street      = "street"
    case nollieSwtch = "nollieSwtch"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .flatground:  return "Flatground"
        case .grinds:      return "Grinds"
        case .manual:      return "Manuals"
        case .park:        return "Park"
        case .street:      return "Street"
        case .nollieSwtch: return "Nollie/Switch"
        }
    }

    var emoji: String {
        switch self {
        case .flatground:  return "🛹"
        case .grinds:      return "🔩"
        case .manual:      return "⚖️"
        case .park:        return "🏄"
        case .street:      return "🏙️"
        case .nollieSwtch: return "🔄"
        }
    }

    var colorHex: String {
        switch self {
        case .flatground:  return "#3AB5E6"
        case .grinds:      return "#FF9500"
        case .manual:      return "#CCFF40"
        case .park:        return "#34C759"
        case .street:      return "#FF3B30"
        case .nollieSwtch: return "#C77DFF"
        }
    }

    // Curated quick-add suggestions per category
    var suggestions: [String] {
        switch self {
        case .flatground:
            return ["Ollie", "Kickflip", "Heelflip", "360 Flip", "Hardflip",
                    "Varial Kickflip", "Varial Heelflip", "Inward Heelflip",
                    "Pop Shove-it", "Frontside 180", "Backside 180",
                    "Frontside Bigspin", "Backside Bigspin", "Impossible"]
        case .grinds:
            return ["50-50", "5-0", "Nosegrind", "Crooked Grind",
                    "Bluntslide", "Noseslide", "Tailslide", "Boardslide",
                    "Lipslide", "Feeble Grind", "Smith Grind", "Salad Grind"]
        case .manual:
            return ["Manual", "Nose Manual", "Nose Manual 180 Out",
                    "Manual 180 Out", "Casper", "One-Foot Manual",
                    "Handstand Manual", "Primo"]
        case .park:
            return ["Drop In", "Carve", "FS Rock", "BS Rock",
                    "Rock n Roll", "Disaster", "Blunt", "Stall",
                    "FS Ollie", "FS Kickflip", "FS 180 Kickflip",
                    "Invert", "Mctwist"]
        case .street:
            return ["Gap Ollie", "FS Gap", "BS Gap", "Stair Set Ollie",
                    "Rail FS Board", "Rail BS Board", "Wallie",
                    "FS Nosegrind Rail", "BS 50-50 Rail", "Over the Hip"]
        case .nollieSwtch:
            return ["Nollie", "Nollie Kickflip", "Nollie Heelflip",
                    "Nollie FS 180", "Nollie BS 180",
                    "Switch Ollie", "Switch Kickflip", "Switch Heelflip",
                    "Switch 360 Flip", "Switch FS 180", "Switch BS 180",
                    "Fakie Ollie", "Fakie Kickflip"]
        }
    }
}

// MARK: - Trick Difficulty

enum TrickDifficulty: Int, CaseIterable, Comparable, Identifiable {
    case beginner     = 1
    case intermediate = 2
    case advanced     = 3
    case expert       = 4
    case legendary    = 5

    var id: Int { rawValue }

    static func < (lhs: TrickDifficulty, rhs: TrickDifficulty) -> Bool { lhs.rawValue < rhs.rawValue }

    var label: String {
        switch self {
        case .beginner:     return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced:     return "Advanced"
        case .expert:       return "Expert"
        case .legendary:    return "Legendary"
        }
    }

    var stars: String { String(repeating: "★", count: rawValue) + String(repeating: "☆", count: 5 - rawValue) }
}

// MARK: - Trick Status

enum TrickStatus: String, CaseIterable, Identifiable {
    case landed      = "landed"
    case learning    = "learning"
    case wantToLearn = "wantToLearn"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .landed:      return "Landed"
        case .learning:    return "Learning"
        case .wantToLearn: return "Want to Learn"
        }
    }

    var icon: String {
        switch self {
        case .landed:      return "checkmark.circle.fill"
        case .learning:    return "arrow.triangle.2.circlepath"
        case .wantToLearn: return "bookmark.circle.fill"
        }
    }

    var colorHex: String {
        switch self {
        case .landed:      return "#34C759"
        case .learning:    return "#FF9500"
        case .wantToLearn: return "#8E8E93"
        }
    }

    var nextStatus: TrickStatus {
        switch self {
        case .wantToLearn: return .learning
        case .learning:    return .landed
        case .landed:      return .landed
        }
    }
}
