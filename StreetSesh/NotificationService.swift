import Foundation
import UserNotifications

@MainActor
final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    func requestPermission() async {
        do {
            try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
        } catch {}
    }

    // Daily challenge reminder — fires every day at 9 AM
    func scheduleDailyChallenge() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Challenge 🛹"
        content.body = "A new skate challenge is waiting. Get out there."
        content.sound = .default

        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: "streetsesh.daily_challenge",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    // Daily 7 PM reminder to keep the session streak alive
    func scheduleStreakReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Keep Your Streak Alive"
        content.body = "You haven't skated today yet. Don't break the run."
        content.sound = .default
        var components = DateComponents()
        components.hour = 19
        components.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: "streetsesh.streak_reminder",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    // Sunday 6 PM weekly recap nudge
    func scheduleWeeklySummary() {
        let content = UNMutableNotificationContent()
        content.title = "Weekly Recap"
        content.body = "Check your stats to see how you rolled this week."
        content.sound = .default
        var components = DateComponents()
        components.weekday = 1
        components.hour    = 18
        components.minute  = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: "streetsesh.weekly_summary",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    // Fires immediately — used for trophy unlocks and moderation alerts
    func scheduleLocal(title: String, body: String, identifier: String? = nil) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let id = identifier ?? UUID().uuidString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
