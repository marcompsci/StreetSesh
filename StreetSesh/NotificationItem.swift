import Foundation
import SwiftData

@Model
final class NotificationItem {
    var id: UUID
    var kind: String        // "comment" | "session" | "trophy" | "moderation" | "crew" | "challenge"
    var title: String
    var body: String
    var createdAt: Date
    var isRead: Bool
    var targetID: String    // deep-link hint (clip title, spot name, etc.)

    init(kind: String, title: String, body: String, targetID: String = "") {
        self.id = UUID()
        self.kind = kind
        self.title = title
        self.body = body
        self.createdAt = Date()
        self.isRead = false
        self.targetID = targetID
    }
}

extension NotificationItem {
    var icon: String {
        switch kind {
        case "comment":    return "bubble.right.fill"
        case "session":    return "antenna.radiowaves.left.and.right"
        case "trophy":     return "trophy.fill"
        case "moderation": return "shield.fill"
        case "crew":       return "person.3.fill"
        case "challenge":  return "star.fill"
        default:           return "bell.fill"
        }
    }

    var tintHex: String {
        switch kind {
        case "comment":    return "#4CAF50"
        case "session":    return "#FF9800"
        case "trophy":     return "#FFD700"
        case "moderation": return "#F44336"
        case "crew":       return "#9C27B0"
        case "challenge":  return "#00BCD4"
        default:           return "#9E9E9E"
        }
    }
}
