import Foundation

// MARK: - Rate Limiter
// Actor-isolated per-endpoint throttle. Prevents accidental API floods
// and makes brute-force attacks significantly harder.

actor RateLimiter {
    static let shared = RateLimiter()
    private init() {}

    private var lastCallTimes: [String: Date] = [:]

    /// Returns true if the call is allowed; false if it should be suppressed.
    /// `minimumInterval` is in seconds.
    func allow(endpoint: RateLimitedEndpoint) -> Bool {
        let key = endpoint.rawValue
        let now = Date()
        if let last = lastCallTimes[key], now.timeIntervalSince(last) < endpoint.minimumInterval {
            return false
        }
        lastCallTimes[key] = now
        return true
    }

    /// Same as `allow` but async — waits until the interval has passed.
    func waitAndAllow(endpoint: RateLimitedEndpoint) async {
        let key = endpoint.rawValue
        let now = Date()
        if let last = lastCallTimes[key] {
            let elapsed = now.timeIntervalSince(last)
            let remaining = endpoint.minimumInterval - elapsed
            if remaining > 0 {
                try? await Task.sleep(for: .seconds(remaining))
            }
        }
        lastCallTimes[key] = Date()
    }
}

// MARK: - Endpoints

enum RateLimitedEndpoint: String {
    case contentScan       = "content_scan"
    case userSearch        = "user_search"
    case banCheck          = "ban_check"
    case moderationReport  = "moderation_report"
    case spotSubmit        = "spot_submit"
    case commentPost       = "comment_post"
    case sessionStart      = "session_start"
    case ipFetch           = "ip_fetch"

    /// Minimum seconds between allowed calls
    var minimumInterval: TimeInterval {
        switch self {
        case .contentScan:      return 0.5
        case .userSearch:       return 1.0
        case .banCheck:         return 2.0
        case .moderationReport: return 3.0
        case .spotSubmit:       return 5.0
        case .commentPost:      return 1.0
        case .sessionStart:     return 10.0
        case .ipFetch:          return 30.0
        }
    }
}
