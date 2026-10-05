import Foundation
import SwiftData

@Model
final class AppUser {
    var username: String
    var email: String
    var city: String
    var sessionCount: Int
    var joinedAt: Date
    var isUnder18: Bool
    var stanceRaw: String
    var skatingStyleRaw: String
    var avatarJSON: String
    var boardJSON: String
    var isSuspended: Bool = false
    var isBanned: Bool = false
    var banReason: String = ""
    var isAgeVerified: Bool = false

    var stance: Stance {
        get { Stance(rawValue: stanceRaw) ?? .regular }
        set { stanceRaw = newValue.rawValue }
    }
    var skatingStyle: SkateStyle {
        get { SkateStyle(rawValue: skatingStyleRaw) ?? .street }
        set { skatingStyleRaw = newValue.rawValue }
    }
    var avatar: AvatarData {
        get {
            guard let d = avatarJSON.data(using: .utf8),
                  let v = try? JSONDecoder().decode(AvatarData.self, from: d) else { return AvatarData() }
            return v
        }
        set {
            avatarJSON = (try? String(data: JSONEncoder().encode(newValue), encoding: .utf8)) ?? ""
        }
    }
    var board: BoardData {
        get {
            guard let d = boardJSON.data(using: .utf8),
                  let v = try? JSONDecoder().decode(BoardData.self, from: d) else { return BoardData() }
            return v
        }
        set {
            boardJSON = (try? String(data: JSONEncoder().encode(newValue), encoding: .utf8)) ?? ""
        }
    }

    init(
        username: String,
        email: String = "",
        city: String = "San Francisco",
        isUnder18: Bool = false,
        stance: Stance = .regular,
        skatingStyle: SkateStyle = .street,
        avatar: AvatarData = AvatarData(),
        board: BoardData = BoardData()
    ) {
        self.username = username
        self.email = email
        self.city = city
        self.sessionCount = 0
        self.joinedAt = Date()
        self.isUnder18 = isUnder18
        self.stanceRaw = stance.rawValue
        self.skatingStyleRaw = skatingStyle.rawValue
        self.avatarJSON = (try? String(data: JSONEncoder().encode(avatar), encoding: .utf8)) ?? ""
        self.boardJSON  = (try? String(data: JSONEncoder().encode(board),  encoding: .utf8)) ?? ""
    }
}
