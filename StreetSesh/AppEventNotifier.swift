import Foundation
import SwiftData

// MARK: - AppEventNotifier
// Creates an in-app NotificationItem AND fires a UNUserNotificationCenter local push.
// Call from any view or service that holds a ModelContext.

@MainActor
struct AppEventNotifier {
    let context: ModelContext

    func trophyEarned(_ trophy: Trophy) {
        fire(kind: "trophy",
             title: "Trophy Unlocked",
             body: "\(trophy.icon) You earned '\(trophy.name)' at \(trophy.spotName).",
             targetID: trophy.spotName,
             identifier: "trophy_\(trophy.key)_\(trophy.username)")
    }

    func streakMilestone(days: Int) {
        fire(kind: "session",
             title: "\(days)-Day Streak",
             body: "You've been out \(days) days in a row. Keep it rolling.",
             targetID: "",
             identifier: "streak_milestone_\(days)")
    }

    func bookmarkedSpotLive(spotName: String) {
        // Deduplicate: skip if an unread notification for this spot was created in the last hour
        let cutoff = Date().addingTimeInterval(-3600)
        let existing = (try? context.fetch(
            FetchDescriptor<NotificationItem>(
                predicate: #Predicate { $0.targetID == spotName && !$0.isRead && $0.createdAt > cutoff }
            )
        )) ?? []
        guard existing.isEmpty else { return }

        let slug = spotName.lowercased().replacingOccurrences(of: " ", with: "_")
        fire(kind: "session",
             title: "\(spotName) is Hot Right Now",
             body: "A session just kicked off at one of your saved spots.",
             targetID: spotName,
             identifier: "bookmark_live_\(slug)")
    }

    func crewMemberLive(username: String, spotName: String) {
        fire(kind: "crew",
             title: "\(username) is out",
             body: "Your crew is skating \(spotName) right now.",
             targetID: spotName,
             identifier: "crew_live_\(username)")
    }

    // MARK: - Private

    private func fire(kind: String, title: String, body: String, targetID: String, identifier: String) {
        let item = NotificationItem(kind: kind, title: title, body: body, targetID: targetID)
        context.insert(item)
        try? context.save()
        NotificationService.shared.scheduleLocal(title: title, body: body, identifier: identifier)
    }
}
