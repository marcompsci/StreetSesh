import Foundation
import Supabase

// MARK: - Analytics Event Types

enum AnalyticsEventType: String {
    case appOpen           = "app_open"
    case spotViewed        = "spot_viewed"
    case sessionStarted    = "session_started"
    case conditionReported = "condition_reported"
    case trickAdded        = "trick_added"
    case clipViewed        = "clip_viewed"
    case arPreviewOpened   = "ar_preview_opened"
    case journalEntry      = "journal_entry"
    case featureOpened     = "feature_opened"
    case checkIn           = "check_in"
    case proUpgrade        = "pro_upgrade"
    case coachPlanGenerated = "coach_plan_generated"
}

// MARK: - Payload

private struct AnalyticsPayload: Encodable {
    let event_type: String
    let username: String
    let meta_value: String?
    let occurred_at: String
}

// MARK: - Service

final class AnalyticsService {
    static let shared = AnalyticsService()

    var currentUsername: String = ""

    private let formatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    private init() {}

    func track(_ type: AnalyticsEventType, meta: String? = nil) {
        guard !currentUsername.isEmpty else { return }
        let payload = AnalyticsPayload(
            event_type: type.rawValue,
            username: currentUsername,
            meta_value: meta,
            occurred_at: formatter.string(from: Date())
        )
        Task {
            try? await SupabaseService.shared.client
                .from("analytics_events")
                .insert(payload)
                .execute()
        }
    }
}
