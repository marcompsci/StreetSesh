import Foundation
import Supabase
import SwiftData

// MARK: - DTOs (CodingKeys map camelCase Swift ↔ snake_case Postgres)

struct AppUserDTO: Codable {
    var username: String
    var city: String
    var sessionCount: Int
    var isUnder18: Bool
    var joinedAt: String
    enum CodingKeys: String, CodingKey {
        case username, city
        case sessionCount = "session_count"
        case isUnder18 = "is_under_18"
        case joinedAt = "joined_at"
    }
    init(from user: AppUser) {
        username = user.username
        city = user.city
        sessionCount = user.sessionCount
        isUnder18 = user.isUnder18
        joinedAt = ISO8601DateFormatter().string(from: user.joinedAt)
    }
}

struct SpotDTO: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    var obstacles: [String]
    var spotDescription: String
    var visibilityRaw: String
    var bustStatusRaw: String
    var bustConfidenceDate: String
    var fameTierRaw: String
    var bestTimeOfDay: String
    var isRetired: Bool
    var submittedAt: String
    enum CodingKeys: String, CodingKey {
        case name, latitude, longitude, obstacles
        case spotDescription = "spot_description"
        case visibilityRaw = "visibility_raw"
        case bustStatusRaw = "bust_status_raw"
        case bustConfidenceDate = "bust_confidence_date"
        case fameTierRaw = "fame_tier_raw"
        case bestTimeOfDay = "best_time_of_day"
        case isRetired = "is_retired"
        case submittedAt = "submitted_at"
    }
    init(from spot: Spot) {
        name = spot.name
        latitude = spot.latitude
        longitude = spot.longitude
        obstacles = spot.obstacles
        spotDescription = spot.spotDescription
        visibilityRaw = spot.visibilityRaw
        bustStatusRaw = spot.bustStatusRaw
        fameTierRaw = spot.fameTierRaw
        bestTimeOfDay = spot.bestTimeOfDay
        isRetired = spot.isRetired
        let f = ISO8601DateFormatter()
        bustConfidenceDate = f.string(from: spot.bustConfidenceDate)
        submittedAt = f.string(from: spot.submittedAt)
    }
    func toSpot() -> Spot {
        let s = Spot(
            name: name,
            latitude: latitude,
            longitude: longitude,
            obstacles: obstacles,
            description: spotDescription,
            visibility: VisibilityTier(rawValue: visibilityRaw) ?? .public,
            bustStatus: BustStatus(rawValue: bustStatusRaw) ?? .green,
            fameTier: FameTier(rawValue: fameTierRaw) ?? .local,
            bestTimeOfDay: bestTimeOfDay
        )
        if let date = ISO8601DateFormatter().date(from: bustConfidenceDate) {
            s.bustConfidenceDate = date
        }
        return s
    }
}

struct LiveSessionDTO: Codable {
    var username: String
    var spotName: String
    var latitude: Double
    var longitude: Double
    var visibilityRaw: String
    var activity: String
    var startedAt: String
    var expiresAt: String
    var isActive: Bool
    enum CodingKeys: String, CodingKey {
        case username, latitude, longitude, activity
        case spotName = "spot_name"
        case visibilityRaw = "visibility_raw"
        case startedAt = "started_at"
        case expiresAt = "expires_at"
        case isActive = "is_active"
    }
    init(from session: LiveSession) {
        username = session.username
        spotName = session.spotName
        latitude = session.latitude
        longitude = session.longitude
        visibilityRaw = session.visibilityRaw
        activity = session.activity
        isActive = session.isActive
        let f = ISO8601DateFormatter()
        startedAt = f.string(from: session.startedAt)
        expiresAt = f.string(from: session.expiresAt)
    }
    func toSession() -> LiveSession {
        let s = LiveSession(
            username: username,
            spotName: spotName,
            latitude: latitude,
            longitude: longitude,
            visibility: SessionVisibility(rawValue: visibilityRaw) ?? .locals,
            activity: activity,
            isCurrentUser: false
        )
        let f = ISO8601DateFormatter()
        if let d = f.date(from: startedAt) { s.startedAt = d }
        if let d = f.date(from: expiresAt)  { s.expiresAt = d }
        s.isActive = isActive
        return s
    }
}

struct HuntScoreDTO: Codable {
    var username: String
    var totalPoints: Int
    var correctCount: Int
    var roundCount: Int
    var playedAt: String
    var huntDateKey: String
    enum CodingKeys: String, CodingKey {
        case username
        case totalPoints = "total_points"
        case correctCount = "correct_count"
        case roundCount = "round_count"
        case playedAt = "played_at"
        case huntDateKey = "hunt_date_key"
    }
    init(from score: HuntScore) {
        username = score.username
        totalPoints = score.totalPoints
        correctCount = score.correctCount
        roundCount = score.roundCount
        huntDateKey = score.huntDateKey
        playedAt = ISO8601DateFormatter().string(from: score.playedAt)
    }
    func toHuntScore() -> HuntScore {
        HuntScore(
            username: username,
            totalPoints: totalPoints,
            correctCount: correctCount,
            roundCount: roundCount,
            isCurrentUser: false
        )
    }
}

struct SpotCheckInDTO: Codable {
    var username: String
    var spotName: String
    var fameTierRaw: String
    var checkedInAt: String
    enum CodingKeys: String, CodingKey {
        case username
        case spotName = "spot_name"
        case fameTierRaw = "fame_tier_raw"
        case checkedInAt = "checked_in_at"
    }
    init(from c: SpotCheckIn) {
        username = c.username
        spotName = c.spotName
        fameTierRaw = c.fameTierRaw
        checkedInAt = ISO8601DateFormatter().string(from: c.checkedInAt)
    }
}

struct TrophyDTO: Codable {
    var key: String
    var name: String
    var icon: String
    var rarityRaw: String
    var username: String
    var spotName: String
    var earnedAt: String
    enum CodingKeys: String, CodingKey {
        case key, name, icon, username
        case rarityRaw = "rarity_raw"
        case spotName = "spot_name"
        case earnedAt = "earned_at"
    }
    init(from t: Trophy) {
        key = t.key
        name = t.name
        icon = t.icon
        rarityRaw = t.rarityRaw
        username = t.username
        spotName = t.spotName
        earnedAt = ISO8601DateFormatter().string(from: t.earnedAt)
    }
}

struct SpotClipDTO: Codable {
    var spotName: String
    var clipURL: String
    var title: String
    var addedBy: String
    var addedAt: String
    enum CodingKeys: String, CodingKey {
        case title
        case spotName = "spot_name"
        case clipURL = "clip_url"
        case addedBy = "added_by"
        case addedAt = "added_at"
    }
    init(from c: SpotClip) {
        spotName = c.spotName
        clipURL = c.clipURL
        title = c.title
        addedBy = c.addedBy
        addedAt = ISO8601DateFormatter().string(from: c.addedAt)
    }
}

struct LeaderboardEntryDTO: Codable {
    var username: String
    var city: String
    var sessionCount: Int
    enum CodingKeys: String, CodingKey {
        case username, city
        case sessionCount = "session_count"
    }
}

struct BustVoteDTO: Codable {
    var spotName: String
    var voteRaw: String
    var username: String
    var votedAt: String
    enum CodingKeys: String, CodingKey {
        case username
        case spotName = "spot_name"
        case voteRaw = "vote_raw"
        case votedAt = "voted_at"
    }
    init(from v: BustVote) {
        spotName = v.spotName
        voteRaw = v.voteRaw
        username = v.username
        votedAt = ISO8601DateFormatter().string(from: v.votedAt)
    }
}

// MARK: - Service

final class SupabaseService {
    static let shared = SupabaseService()

    let client: SupabaseClient

    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: SupabaseConfig.projectURL)!,
            supabaseKey: SupabaseConfig.anonKey
        )
    }

    // MARK: - Users

    func upsertUser(_ user: AppUser) async throws {
        try await client.from("app_users")
            .upsert(AppUserDTO(from: user), onConflict: "username")
            .execute()
    }

    func searchUsers(query: String) async throws -> [AppUserDTO] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return [] }
        return try await client
            .from("app_users")
            .select()
            .ilike("username", value: "\(query.lowercased())%")
            .limit(25)
            .execute()
            .value
    }

    // MARK: - Spots

    func syncSpots(into context: ModelContext) async throws {
        let remote: [SpotDTO] = try await client.from("spots")
            .select()
            .eq("is_retired", value: false)
            .execute()
            .value

        let existing = try context.fetch(FetchDescriptor<Spot>())
        let existingNames = Set(existing.map { $0.name })
        for dto in remote where !existingNames.contains(dto.name) {
            context.insert(dto.toSpot())
        }
        try? context.save()
    }

    func pushSpot(_ spot: Spot) async throws {
        try await client.from("spots")
            .insert(SpotDTO(from: spot))
            .execute()
    }

    // MARK: - Live Sessions

    func syncActiveSessions(into context: ModelContext) async throws {
        let remote: [LiveSessionDTO] = try await client.from("live_sessions")
            .select()
            .eq("is_active", value: true)
            .execute()
            .value

        let existing = try context.fetch(FetchDescriptor<LiveSession>())
        let currentUsernames = Set(existing.filter { $0.isCurrentUser }.map { $0.username })
        existing.filter { !$0.isCurrentUser }.forEach { context.delete($0) }
        for dto in remote where !currentUsernames.contains(dto.username) {
            context.insert(dto.toSession())
        }
        try? context.save()
    }

    func pushLiveSession(_ session: LiveSession) async throws {
        try await client.from("live_sessions")
            .insert(LiveSessionDTO(from: session))
            .execute()
    }

    func deactivateSessions(for username: String) async throws {
        try await client.from("live_sessions")
            .update(["is_active": false])
            .eq("username", value: username)
            .execute()
    }

    // MARK: - Hunt Scores

    func syncLeaderboard(into context: ModelContext) async throws {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let todayKey = fmt.string(from: Date())

        let todayDTOs: [HuntScoreDTO] = try await client.from("hunt_scores")
            .select()
            .eq("hunt_date_key", value: todayKey)
            .order("total_points", ascending: false)
            .limit(50)
            .execute()
            .value

        let allDTOs: [HuntScoreDTO] = try await client.from("hunt_scores")
            .select()
            .order("total_points", ascending: false)
            .limit(100)
            .execute()
            .value

        let existing = try context.fetch(FetchDescriptor<HuntScore>())
        let localUsernames = Set(existing.filter { $0.isCurrentUser }.map { $0.username })
        existing.filter { !$0.isCurrentUser }.forEach { context.delete($0) }

        var seenKeys = Set<String>()
        for dto in (todayDTOs + allDTOs) {
            guard !localUsernames.contains(dto.username) else { continue }
            let key = "\(dto.username)_\(dto.huntDateKey)"
            guard !seenKeys.contains(key) else { continue }
            seenKeys.insert(key)
            context.insert(dto.toHuntScore())
        }
        try? context.save()
    }

    func pushHuntScore(_ score: HuntScore) async throws {
        try await client.from("hunt_scores")
            .insert(HuntScoreDTO(from: score))
            .execute()
    }

    // MARK: - Bust Votes

    func pushBustVote(_ vote: BustVote) async throws {
        try await client.from("bust_votes")
            .upsert(BustVoteDTO(from: vote), onConflict: "spot_name,username")
            .execute()
    }

    // MARK: - Clips

    func pushClip(_ clip: SpotClip) async throws {
        try await client.from("spot_clips")
            .insert(SpotClipDTO(from: clip))
            .execute()
    }

    // MARK: - Check-ins & Trophies

    func pushCheckIn(_ checkIn: SpotCheckIn) async throws {
        try await client.from("spot_check_ins")
            .insert(SpotCheckInDTO(from: checkIn))
            .execute()
    }

    func pushTrophy(_ trophy: Trophy) async throws {
        try await client.from("trophies")
            .upsert(TrophyDTO(from: trophy), onConflict: "key,username")
            .execute()
    }

    // MARK: - Leaderboard

    func fetchSessionsLeaderboard(
        city: String? = nil,
        usernames: [String]? = nil,
        limit: Int = 50
    ) async throws -> [LeaderboardEntryDTO] {
        var query = client
            .from("app_users")
            .select("username, city, session_count")
        if let city, !city.isEmpty {
            query = query.eq("city", value: city)
        }
        if let usernames, !usernames.isEmpty {
            query = query.in("username", values: usernames)
        }
        return try await query
            .order("session_count", ascending: false)
            .limit(limit)
            .execute()
            .value
    }

    // MARK: - Activity Feed

    func fetchCrewSessions(usernames: [String], since: Date, limit: Int) async throws -> [LiveSessionDTO] {
        let sinceStr = ISO8601DateFormatter().string(from: since)
        return try await client.from("live_sessions")
            .select()
            .in("username", values: usernames)
            .gte("started_at", value: sinceStr)
            .order("started_at", ascending: false)
            .limit(limit)
            .execute()
            .value
    }

    func fetchCrewTrophies(usernames: [String], since: Date, limit: Int) async throws -> [TrophyDTO] {
        let sinceStr = ISO8601DateFormatter().string(from: since)
        return try await client.from("trophies")
            .select()
            .in("username", values: usernames)
            .gte("earned_at", value: sinceStr)
            .order("earned_at", ascending: false)
            .limit(limit)
            .execute()
            .value
    }

    func fetchGlobalSessions(limit: Int) async throws -> [LiveSessionDTO] {
        return try await client.from("live_sessions")
            .select()
            .eq("visibility_raw", value: "public")
            .order("started_at", ascending: false)
            .limit(limit)
            .execute()
            .value
    }
}
