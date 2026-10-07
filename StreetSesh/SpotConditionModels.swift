import Foundation
import SwiftData

// MARK: - Spot Condition

@Model
final class SpotCondition {
    var id:         UUID
    var spotName:   String
    var reporter:   String
    var typeRaw:    String
    var notes:      String
    var reportedAt: Date

    init(spotName: String, reporter: String, type: SpotConditionType, notes: String = "") {
        self.id         = UUID()
        self.spotName   = spotName
        self.reporter   = reporter
        self.typeRaw    = type.rawValue
        self.notes      = notes
        self.reportedAt = Date()
    }
}

extension SpotCondition {
    var type: SpotConditionType { SpotConditionType(rawValue: typeRaw) ?? .fresh }
    var isStale: Bool { Date().timeIntervalSince(reportedAt) > type.expirySeconds }
    var freshnessProgress: Double {
        let elapsed = Date().timeIntervalSince(reportedAt)
        return max(0, 1.0 - elapsed / type.expirySeconds)
    }
}

// MARK: - Condition Type

enum SpotConditionType: String, CaseIterable, Identifiable {
    case fresh    = "fresh"
    case wet      = "wet"
    case security = "security"
    case crowded  = "crowded"
    case dusty    = "dusty"
    case closed   = "closed"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .fresh:    return "Skating now"
        case .wet:      return "Wet / damp"
        case .security: return "Security"
        case .crowded:  return "Crowded"
        case .dusty:    return "Dusty / rough"
        case .closed:   return "Spot closed"
        }
    }

    var emoji: String {
        switch self {
        case .fresh:    return "🟢"
        case .wet:      return "💧"
        case .security: return "🚨"
        case .crowded:  return "👥"
        case .dusty:    return "🌬️"
        case .closed:   return "🔒"
        }
    }

    var colorHex: String {
        switch self {
        case .fresh:    return "#34C759"
        case .wet:      return "#3AB5E6"
        case .security: return "#FF3B30"
        case .crowded:  return "#FFD700"
        case .dusty:    return "#8E8E93"
        case .closed:   return "#FF453A"
        }
    }

    // How long a report stays valid
    var expirySeconds: TimeInterval {
        switch self {
        case .fresh:    return 2  * 3600
        case .wet:      return 4  * 3600
        case .security: return 1  * 3600
        case .crowded:  return 2  * 3600
        case .dusty:    return 6  * 3600
        case .closed:   return 8  * 3600
        }
    }

    var expiryLabel: String {
        switch self {
        case .fresh:    return "2 hr"
        case .wet:      return "4 hr"
        case .security: return "1 hr"
        case .crowded:  return "2 hr"
        case .dusty:    return "6 hr"
        case .closed:   return "8 hr"
        }
    }
}
