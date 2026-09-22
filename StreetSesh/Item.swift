import Foundation
import SwiftData

@Model
final class AppUser {
    var username: String
    var city: String
    var sessionCount: Int
    var joinedAt: Date
    var isUnder18: Bool

    init(username: String, city: String = "San Francisco", isUnder18: Bool = false) {
        self.username = username
        self.city = city
        self.sessionCount = 0
        self.joinedAt = Date()
        self.isUnder18 = isUnder18
    }
}
