import Foundation
import SwiftData

// MARK: - Crew

@Model
final class Crew {
    var name: String
    var tag: String            // short crew tag, max 5 chars, e.g. "SFSK8"
    var ownerUsername: String
    var membersRaw: String     // comma-separated usernames
    var city: String
    var createdAt: Date

    var memberList: [String] {
        get {
            membersRaw.isEmpty ? [] : membersRaw.components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
        }
        set { membersRaw = newValue.joined(separator: ",") }
    }

    init(name: String, tag: String, ownerUsername: String, city: String = "") {
        self.name = name
        self.tag = String(tag.uppercased().prefix(5))
        self.ownerUsername = ownerUsername
        self.membersRaw = ownerUsername
        self.city = city
        self.createdAt = Date()
    }
}

// MARK: - Spot Check-In

@Model
final class SpotCheckIn {
    var username: String
    var spotName: String
    var fameTierRaw: String   // raw FameTier value
    var checkedInAt: Date

    var fameTier: FameTier {
        FameTier(rawValue: fameTierRaw) ?? .local
    }

    init(username: String, spotName: String, fameTier: FameTier) {
        self.username = username
        self.spotName = spotName
        self.fameTierRaw = fameTier.rawValue
        self.checkedInAt = Date()
    }
}

// MARK: - Trophy

@Model
final class Trophy {
    var key: String        // unique per user+achievement, e.g. "legendary_Pier 7"
    var name: String
    var icon: String       // SF symbol name
    var rarityRaw: String  // "common", "rare", "legendary"
    var username: String
    var spotName: String   // empty for non-spot trophies
    var earnedAt: Date

    var rarity: TrophyRarity {
        TrophyRarity(rawValue: rarityRaw) ?? .common
    }

    init(key: String, name: String, icon: String, rarity: TrophyRarity, username: String, spotName: String = "") {
        self.key = key
        self.name = name
        self.icon = icon
        self.rarityRaw = rarity.rawValue
        self.username = username
        self.spotName = spotName
        self.earnedAt = Date()
    }
}

enum TrophyRarity: String, CaseIterable {
    case common    = "common"
    case rare      = "rare"
    case legendary = "legendary"
}

// MARK: - Trophy Engine

enum TrophyEngine {
    static func checkAndAward(
        username: String,
        newCheckIn: SpotCheckIn,
        allCheckIns: [SpotCheckIn],
        existingTrophies: [Trophy],
        context: ModelContext
    ) {
        let myCheckIns = allCheckIns.filter { $0.username == username }
        let myKeys = Set(existingTrophies.filter { $0.username == username }.map { $0.key })

        // First Drop — first session ever
        if myCheckIns.count == 1, !myKeys.contains("first_drop") {
            context.insert(Trophy(
                key: "first_drop",
                name: "First Drop",
                icon: "skateboard",
                rarity: .common,
                username: username
            ))
        }

        // Legendary spot trophy — first visit to any legendary spot
        if newCheckIn.fameTier == .legendary {
            let key = "legendary_\(newCheckIn.spotName)"
            if !myKeys.contains(key) {
                context.insert(Trophy(
                    key: key,
                    name: newCheckIn.spotName,
                    icon: "star.fill",
                    rarity: .legendary,
                    username: username,
                    spotName: newCheckIn.spotName
                ))
            }
        }

        // Iconic spot trophy — first visit to any iconic spot
        if newCheckIn.fameTier == .iconic {
            let key = "iconic_\(newCheckIn.spotName)"
            if !myKeys.contains(key) {
                context.insert(Trophy(
                    key: key,
                    name: newCheckIn.spotName,
                    icon: "mappin.and.ellipse.fill",
                    rarity: .rare,
                    username: username,
                    spotName: newCheckIn.spotName
                ))
            }
        }

        // Spot Collector — 5+ unique spots visited
        let uniqueSpots = Set(myCheckIns.map { $0.spotName })
        if uniqueSpots.count >= 5, !myKeys.contains("spot_collector") {
            context.insert(Trophy(
                key: "spot_collector",
                name: "Spot Collector",
                icon: "map.fill",
                rarity: .rare,
                username: username
            ))
        }

        // Regular — 10+ total sessions
        if myCheckIns.count >= 10, !myKeys.contains("regular") {
            context.insert(Trophy(
                key: "regular",
                name: "Regular",
                icon: "person.fill.checkmark",
                rarity: .rare,
                username: username
            ))
        }
    }
}
