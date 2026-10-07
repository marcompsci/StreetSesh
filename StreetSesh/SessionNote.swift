import Foundation
import SwiftData

@Model
final class SessionNote {
    var id:       UUID
    var date:     Date
    var spotName: String
    var text:     String
    var moodRaw:  String
    var tags:     [String]
    var createdAt: Date

    init(date: Date = Date(), spotName: String = "", text: String,
         mood: NoteMood = .solid, tags: [String] = []) {
        self.id        = UUID()
        self.date      = date
        self.spotName  = spotName
        self.text      = text
        self.moodRaw   = mood.rawValue
        self.tags      = tags
        self.createdAt = Date()
    }
}

extension SessionNote {
    var mood: NoteMood { NoteMood(rawValue: moodRaw) ?? .solid }
}

// MARK: - Mood

enum NoteMood: String, CaseIterable, Identifiable {
    case stoked      = "stoked"
    case solid       = "solid"
    case tired       = "tired"
    case frustrated  = "frustrated"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .stoked:     return "Stoked"
        case .solid:      return "Solid"
        case .tired:      return "Tired"
        case .frustrated: return "Frustrated"
        }
    }

    var emoji: String {
        switch self {
        case .stoked:     return "🤙"
        case .solid:      return "✅"
        case .tired:      return "😮‍💨"
        case .frustrated: return "😤"
        }
    }

    var colorHex: String {
        switch self {
        case .stoked:     return "#34C759"
        case .solid:      return "#3AB5E6"
        case .tired:      return "#8E8E93"
        case .frustrated: return "#FF3B30"
        }
    }
}
