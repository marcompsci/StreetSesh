import Foundation
import SwiftData

// MARK: - Spot Clip

@Model
final class SpotClip {
    var spotName: String
    var clipURL: String
    var title: String
    var addedBy: String
    var addedAt: Date

    init(spotName: String, clipURL: String, title: String, addedBy: String) {
        self.spotName = spotName
        self.clipURL = clipURL
        self.title = title
        self.addedBy = addedBy
        self.addedAt = Date()
    }
}

// MARK: - Bust Vote

@Model
final class BustVote {
    var spotName: String
    var voteRaw: String   // "green", "yellow", "red"
    var username: String
    var votedAt: Date

    var vote: BustStatus { BustStatus(rawValue: voteRaw) ?? .yellow }

    init(spotName: String, vote: BustStatus, username: String) {
        self.spotName = spotName
        self.voteRaw = vote.rawValue
        self.username = username
        self.votedAt = Date()
    }
}

// MARK: - Bust Vote Engine

enum BustVoteEngine {
    // Most recent vote per user, last 30 days
    static func deduplicatedVotes(for spotName: String, in allVotes: [BustVote]) -> [BustVote] {
        let cutoff = Date().addingTimeInterval(-30 * 86400)
        let recent = allVotes.filter { $0.spotName == spotName && $0.votedAt >= cutoff }

        var latestPerUser: [String: BustVote] = [:]
        for vote in recent {
            if let existing = latestPerUser[vote.username] {
                if vote.votedAt > existing.votedAt { latestPerUser[vote.username] = vote }
            } else {
                latestPerUser[vote.username] = vote
            }
        }
        return Array(latestPerUser.values)
    }

    static func voteCounts(for spotName: String, in allVotes: [BustVote]) -> [BustStatus: Int] {
        let deduped = deduplicatedVotes(for: spotName, in: allVotes)
        return Dictionary(grouping: deduped, by: { $0.vote }).mapValues { $0.count }
    }

    // Returns consensus status if ≥3 votes and one status has >50% — otherwise nil
    static func consensusBust(for spotName: String, in allVotes: [BustVote]) -> BustStatus? {
        let counts = voteCounts(for: spotName, in: allVotes)
        let total = counts.values.reduce(0, +)
        guard total >= 3 else { return nil }
        for (status, count) in counts where Double(count) / Double(total) > 0.5 {
            return status
        }
        return nil
    }
}
