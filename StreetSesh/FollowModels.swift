import Foundation
import SwiftData

@Model
final class FollowRelation {
    var followerUsername: String
    var followingUsername: String
    var followedAt: Date

    init(follower: String, following: String) {
        self.followerUsername = follower
        self.followingUsername = following
        self.followedAt = Date()
    }
}

enum FollowEngine {
    static func isFollowing(follower: String, target: String, in relations: [FollowRelation]) -> Bool {
        relations.contains { $0.followerUsername == follower && $0.followingUsername == target }
    }

    static func followingUsernames(for username: String, in relations: [FollowRelation]) -> [String] {
        relations.filter { $0.followerUsername == username }.map { $0.followingUsername }
    }

    static func followerUsernames(for username: String, in relations: [FollowRelation]) -> [String] {
        relations.filter { $0.followingUsername == username }.map { $0.followerUsername }
    }

    @discardableResult
    static func follow(follower: String, target: String, context: ModelContext, existing: [FollowRelation]) -> FollowRelation? {
        guard !isFollowing(follower: follower, target: target, in: existing) else { return nil }
        let relation = FollowRelation(follower: follower, following: target)
        context.insert(relation)
        try? context.save()
        return relation
    }

    static func unfollow(follower: String, target: String, context: ModelContext, existing: [FollowRelation]) {
        existing
            .filter { $0.followerUsername == follower && $0.followingUsername == target }
            .forEach { context.delete($0) }
        try? context.save()
    }
}
