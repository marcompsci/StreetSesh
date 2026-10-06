import Foundation
import NaturalLanguage
import Supabase
import SwiftData

// MARK: - Content Violation

struct ContentViolation {
    let trigger: String
    let severity: Severity
    let originalText: String
    enum Severity { case low, medium, high }
}

// MARK: - Moderation Status

struct ModerationStatus {
    let isBanned: Bool
    let isSuspended: Bool
    let reason: String
    let expiresAt: Date?

    static let clear = ModerationStatus(isBanned: false, isSuspended: false, reason: "", expiresAt: nil)
}

// MARK: - Content Filter

enum ContentFilter {
    // Prohibited pattern categories — extend this list as needed
    private static let prohibitedPatterns: [String] = [
        // violence threats
        "kill yourself", "kys", "i will kill", "i'll kill", "go die",
        "death threat", "bomb threat",
        // hate-group indicators
        "white power", "ethnic cleansing",
        // explicit harassment
        "doxx", "doxing", "swat you"
    ]

    // Returns a violation if the text triggers any rule
    static func scan(_ text: String) -> ContentViolation? {
        let lower = text.lowercased()

        // Pattern match
        for pattern in prohibitedPatterns where lower.contains(pattern) {
            return ContentViolation(trigger: pattern, severity: .high, originalText: text)
        }

        // NL sentiment — flag extreme hostility (score < -0.85 on Apple's -1 to +1 scale)
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let (tag, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        if let scoreStr = tag?.rawValue, let score = Double(scoreStr), score < -0.85 {
            return ContentViolation(trigger: "extreme_negative_sentiment(\(String(format: "%.2f", score)))",
                                    severity: .medium, originalText: text)
        }

        return nil
    }
}

// MARK: - Moderation Service

@MainActor
final class ModerationService {
    static let shared = ModerationService()
    private init() {}

    // MARK: - Ban check (called at signup)
    // Returns true if ANY identifier matches a banned record in Supabase.
    func isIdentifierBanned(email: String, username: String) async -> Bool {
        do {
            let emailHit: [BannedIdentifierDTO] = try await SupabaseService.shared.client
                .from("banned_identifiers")
                .select()
                .eq("type", value: "email")
                .eq("value", value: email.lowercased())
                .execute()
                .value
            if !emailHit.isEmpty { return true }

            let nameHit: [BannedIdentifierDTO] = try await SupabaseService.shared.client
                .from("banned_identifiers")
                .select()
                .eq("type", value: "username")
                .eq("value", value: username.lowercased())
                .execute()
                .value
            if !nameHit.isEmpty { return true }

            // IP check
            if let ip = await fetchPublicIP() {
                let ipHit: [BannedIdentifierDTO] = try await SupabaseService.shared.client
                    .from("banned_identifiers")
                    .select()
                    .eq("type", value: "ip")
                    .eq("value", value: ip)
                    .execute()
                    .value
                if !ipHit.isEmpty { return true }
            }
        } catch {
            // Network failure — fail open (allow signup, validate server-side later)
        }
        return false
    }

    // MARK: - Moderation status check (called on app launch)
    func fetchModerationStatus(username: String) async -> ModerationStatus {
        do {
            let rows: [ModerationActionDTO] = try await SupabaseService.shared.client
                .from("moderation_actions")
                .select()
                .eq("username", value: username)
                .eq("is_resolved", value: false)
                .order("actioned_at", ascending: false)
                .execute()
                .value

            let now = Date()
            var isBanned = false
            var isSuspended = false
            var reason = ""
            var expiresAt: Date? = nil

            for row in rows {
                if row.action == "ban" {
                    isBanned = true
                    reason = row.reason ?? "Violation of community guidelines"
                    break
                }
                if row.action == "suspend" {
                    let expires = row.expiresAt.flatMap { ISO8601DateFormatter().date(from: $0) }
                    if expires == nil || expires! > now {
                        isSuspended = true
                        reason = row.reason ?? "Temporary suspension pending review"
                        expiresAt = expires
                    }
                }
            }
            return ModerationStatus(isBanned: isBanned, isSuspended: isSuspended,
                                    reason: reason, expiresAt: expiresAt)
        } catch {
            return .clear
        }
    }

    // MARK: - Report content (users flagging posts/messages)
    func reportContent(reporter: String, targetUsername: String, content: String, reason: String) async {
        let report = ContentReportDTO(
            reporterUsername: reporter,
            targetUsername: targetUsername,
            content: content,
            reason: reason,
            reportedAt: ISO8601DateFormatter().string(from: Date())
        )
        try? await SupabaseService.shared.client
            .from("content_reports")
            .insert(report)
            .execute()
    }

    // MARK: - Auto-suspend (triggered by ContentFilter)
    func autoSuspend(username: String, reason: String, flaggedContent: String) async {
        let action = ModerationActionDTO(
            username: username,
            action: "suspend",
            reason: reason,
            contentFlagged: flaggedContent,
            actionedAt: ISO8601DateFormatter().string(from: Date()),
            expiresAt: nil,  // nil = indefinite until admin review
            isResolved: false
        )
        try? await SupabaseService.shared.client
            .from("moderation_actions")
            .insert(action)
            .execute()

        // Also log the identifier to prevent re-registration
        // (admin promotes to 'ban' and adds banned_identifiers after review)
    }

    // MARK: - Scan and auto-action any submitted text
    // Call this wherever a user submits text (post, comment, bio, spot name).
    // Returns false if the content was blocked.
    func validateAndSubmit(text: String, username: String) async -> Bool {
        // Rate-limit: max one content scan per 0.5 s
        guard await RateLimiter.shared.allow(endpoint: .contentScan) else { return true }

        // Enforce max input length (10 000 chars — well past any legitimate use)
        let truncated = String(text.prefix(10_000))
        guard let violation = ContentFilter.scan(truncated) else { return true }

        let reason = "Prohibited content detected: \(violation.trigger)"
        await autoSuspend(username: username, reason: reason, flaggedContent: violation.originalText)
        return false
    }

    // MARK: - Fetch public IP (rate-limited to once per 30 s)
    func fetchPublicIP() async -> String? {
        // Return cached Keychain value if still fresh
        if let cached = KeychainService.shared.get(.ipBanCache) { return cached }

        guard await RateLimiter.shared.allow(endpoint: .ipFetch) else { return nil }
        guard let url = URL(string: "https://api64.ipify.org?format=json") else { return nil }
        guard let (data, _) = try? await URLSession.shared.data(from: url) else { return nil }
        struct IPResponse: Decodable { let ip: String }
        guard let ip = (try? JSONDecoder().decode(IPResponse.self, from: data))?.ip else { return nil }
        KeychainService.shared.set(ip, for: .ipBanCache)
        return ip
    }

    // MARK: - Permanent ban (called by admin / server action result)
    func permanentlyBan(username: String, email: String, reason: String) async {
        let ban = ModerationActionDTO(
            username: username, action: "ban", reason: reason,
            contentFlagged: nil,
            actionedAt: ISO8601DateFormatter().string(from: Date()),
            expiresAt: nil, isResolved: false
        )
        try? await SupabaseService.shared.client.from("moderation_actions").insert(ban).execute()

        // Register all identifiers to block re-registration
        let identifiers: [BannedIdentifierDTO] = [
            BannedIdentifierDTO(type: "email", value: email.lowercased(), reason: reason),
            BannedIdentifierDTO(type: "username", value: username.lowercased(), reason: reason)
        ]
        for id in identifiers {
            try? await SupabaseService.shared.client
                .from("banned_identifiers")
                .upsert(id, onConflict: "type,value")
                .execute()
        }
        if let ip = await fetchPublicIP() {
            let ipBan = BannedIdentifierDTO(type: "ip", value: ip, reason: reason)
            try? await SupabaseService.shared.client
                .from("banned_identifiers")
                .upsert(ipBan, onConflict: "type,value")
                .execute()
        }
    }
}

// MARK: - DTOs

struct BannedIdentifierDTO: Codable {
    let type: String      // 'email' | 'username' | 'ip' | 'phone'
    let value: String
    let reason: String?
    enum CodingKeys: String, CodingKey {
        case type, value, reason
    }
}

struct ModerationActionDTO: Codable {
    let username: String
    let action: String    // 'suspend' | 'ban' | 'warn' | 'unsuspend'
    let reason: String?
    let contentFlagged: String?
    let actionedAt: String
    let expiresAt: String?
    let isResolved: Bool
    enum CodingKeys: String, CodingKey {
        case username, action, reason
        case contentFlagged = "content_flagged"
        case actionedAt = "actioned_at"
        case expiresAt = "expires_at"
        case isResolved = "is_resolved"
    }
}

struct ContentReportDTO: Codable {
    let reporterUsername: String
    let targetUsername: String
    let content: String
    let reason: String
    let reportedAt: String
    enum CodingKeys: String, CodingKey {
        case reporterUsername = "reporter_username"
        case targetUsername = "target_username"
        case content, reason
        case reportedAt = "reported_at"
    }
}
