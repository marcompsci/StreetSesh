import Foundation

// MARK: - Feed Item

struct FeedItem: Identifiable {
    let id: String
    let kind: FeedKind
    let username: String
    let headline: String
    let detail: String
    let happenedAt: Date
    let isCurrentUser: Bool

    enum FeedKind {
        case session
        case checkIn
        case trophy
        case spot

        var iconName: String {
            switch self {
            case .session: return "bolt.fill"
            case .checkIn: return "mappin.circle.fill"
            case .trophy:  return "trophy.fill"
            case .spot:    return "plus.circle.fill"
            }
        }

        var colorHex: String {
            switch self {
            case .session: return "#CCFF40"
            case .checkIn: return "#3AB5E6"
            case .trophy:  return "#FFD700"
            case .spot:    return "#FF5A35"
            }
        }

        var label: String {
            switch self {
            case .session: return "SESSION"
            case .checkIn: return "CHECK-IN"
            case .trophy:  return "TROPHY"
            case .spot:    return "NEW SPOT"
            }
        }
    }
}

// MARK: - Feed Service

@MainActor
final class FeedService {
    static let shared = FeedService()
    private init() {}

    func buildMyFeed(
        sessions: [LiveSession],
        trophies: [Trophy],
        checkIns: [SpotCheckIn],
        spots: [Spot],
        username: String
    ) -> [FeedItem] {
        var items: [FeedItem] = []

        for s in sessions where s.isCurrentUser {
            items.append(FeedItem(
                id: "sess_\(s.username)_\(s.startedAt.timeIntervalSince1970)",
                kind: .session,
                username: username,
                headline: "You started a session",
                detail: "at \(s.spotName) · \(s.activity)",
                happenedAt: s.startedAt,
                isCurrentUser: true
            ))
        }

        for t in trophies where t.username == username {
            let detail = t.spotName.isEmpty ? t.name : "\(t.name) · \(t.spotName)"
            items.append(FeedItem(
                id: "trophy_\(t.username)_\(t.key)",
                kind: .trophy,
                username: username,
                headline: "You earned a trophy",
                detail: detail,
                happenedAt: t.earnedAt,
                isCurrentUser: true
            ))
        }

        for c in checkIns where c.username == username {
            items.append(FeedItem(
                id: "checkin_\(c.username)_\(c.spotName)_\(c.checkedInAt.timeIntervalSince1970)",
                kind: .checkIn,
                username: username,
                headline: "You checked in",
                detail: c.spotName,
                happenedAt: c.checkedInAt,
                isCurrentUser: true
            ))
        }

        for s in spots {
            items.append(FeedItem(
                id: "spot_\(s.name)_\(s.submittedAt.timeIntervalSince1970)",
                kind: .spot,
                username: username,
                headline: "You added a new spot",
                detail: s.name,
                happenedAt: s.submittedAt,
                isCurrentUser: true
            ))
        }

        return items.sorted { $0.happenedAt > $1.happenedAt }
    }

    func buildRemoteFeed(
        sessions: [LiveSessionDTO],
        trophies: [TrophyDTO],
        currentUsername: String
    ) -> [FeedItem] {
        let fmt = ISO8601DateFormatter()
        var items: [FeedItem] = []

        for s in sessions {
            let date = fmt.date(from: s.startedAt) ?? Date()
            let isCurrent = s.username == currentUsername
            items.append(FeedItem(
                id: "remote_sess_\(s.username)_\(s.startedAt)",
                kind: .session,
                username: s.username,
                headline: isCurrent ? "You started a session" : "@\(s.username) started a session",
                detail: "at \(s.spotName)",
                happenedAt: date,
                isCurrentUser: isCurrent
            ))
        }

        for t in trophies {
            let date = fmt.date(from: t.earnedAt) ?? Date()
            let isCurrent = t.username == currentUsername
            let detail = t.spotName.isEmpty ? t.name : "\(t.name) · \(t.spotName)"
            items.append(FeedItem(
                id: "remote_trophy_\(t.username)_\(t.key)",
                kind: .trophy,
                username: t.username,
                headline: isCurrent ? "You earned a trophy" : "@\(t.username) earned a trophy",
                detail: detail,
                happenedAt: date,
                isCurrentUser: isCurrent
            ))
        }

        return items.sorted { $0.happenedAt > $1.happenedAt }
    }
}
