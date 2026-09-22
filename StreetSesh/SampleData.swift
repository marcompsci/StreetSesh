import Foundation
import SwiftData

struct SampleData {

    static func seed(into context: ModelContext) {
        let descriptor = FetchDescriptor<Spot>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        let spots: [(String, Double, Double, [String], BustStatus, FameTier, String)] = [
            ("Pier 7",              37.7989, -122.3973, ["Ledges", "Benches", "Stairs"],       .green,  .legendary, "Morning"),
            ("Potrero del Sol",     37.7545, -122.4084, ["Ledges", "Hubba", "Banks"],           .green,  .iconic,    "Anytime"),
            ("Embarcadero",         37.7955, -122.3937, ["Marble ledges", "Rail", "Banks"],     .yellow, .legendary, "Weekend mornings"),
            ("Wallenberg",          37.7766, -122.4515, ["Big 4-block", "Rails"],               .green,  .legendary, "Weekdays"),
            ("Fort Miley Banks",    37.7843, -122.5093, ["Banks", "Ledges", "Stairs"],          .green,  .local,     "Anytime"),
            ("China Banks",         37.7956, -122.4015, ["Banks", "Ledges"],                    .yellow, .iconic,    "Evenings"),
            ("Justin Herman Plaza", 37.7954, -122.3953, ["Pyramids", "Ledges", "Rails"],        .red,    .iconic,    "Weekends"),
            ("Civic Center Plaza",  37.7793, -122.4192, ["Ledges", "Stairs", "Manual pad"],    .yellow, .local,     "Evenings"),
            ("Mission Dolores",     37.7596, -122.4269, ["Banks", "Stairs"],                    .green,  .local,     "Anytime"),
            ("Hubba Hideout",       37.7752, -122.4145, ["Hubba ledge", "Stairs"],              .green,  .legendary, "Weekdays"),
            ("Black Rock",          37.7701, -122.4076, ["Ledge", "Banks"],                     .green,  .local,     "Mornings"),
            ("Clipper Street",      37.7576, -122.4296, ["Banks", "Manual pad"],                .green,  .local,     "Anytime"),
        ]

        for (name, lat, lng, obstacles, bust, fame, bestTime) in spots {
            context.insert(Spot(
                name: name,
                latitude: lat,
                longitude: lng,
                obstacles: obstacles,
                visibility: .public,
                bustStatus: bust,
                fameTier: fame,
                bestTimeOfDay: bestTime
            ))
        }

        // Seed mock live sessions so the feed and map aren't empty on first launch
        let mockSessions: [(String, String, Double, Double, String)] = [
            ("grindset_99",  "Pier 7",           37.7989, -122.3973, "Skating"),
            ("skate_rat_sf", "Potrero del Sol",   37.7545, -122.4084, "Filming"),
            ("olliemaster",  "Wallenberg",         37.7766, -122.4515, "Sessioning"),
        ]

        for (username, spot, lat, lng, activity) in mockSessions {
            let session = LiveSession(username: username, spotName: spot, latitude: lat, longitude: lng, visibility: .locals, activity: activity)
            session.startedAt = Date().addingTimeInterval(-Double.random(in: 300...2400))
            context.insert(session)
        }

        try? context.save()
    }

    static func seedHuntScores(into context: ModelContext) {
        let descriptor = FetchDescriptor<HuntScore>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        let mocks: [(String, Int, Int, Int)] = [
            ("grindset_99",  675, 5, 5),
            ("skate_rat_sf", 525, 4, 5),
            ("olliemaster",  350, 3, 5),
        ]

        for (username, points, correct, total) in mocks {
            context.insert(HuntScore(
                username: username,
                totalPoints: points,
                correctCount: correct,
                roundCount: total
            ))
        }

        try? context.save()
    }

    static func seedCheckIns(into context: ModelContext) {
        let descriptor = FetchDescriptor<SpotCheckIn>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        // Check-ins for mock users — grindset_99 is the scene veteran
        let checkIns: [(String, String, FameTier)] = [
            ("grindset_99",  "Pier 7",           .legendary),
            ("grindset_99",  "Pier 7",           .legendary),
            ("grindset_99",  "Embarcadero",       .legendary),
            ("grindset_99",  "Wallenberg",        .legendary),
            ("grindset_99",  "Potrero del Sol",   .iconic),
            ("grindset_99",  "China Banks",       .iconic),
            ("skate_rat_sf", "Pier 7",            .legendary),
            ("skate_rat_sf", "Potrero del Sol",   .iconic),
            ("skate_rat_sf", "Hubba Hideout",     .legendary),
            ("olliemaster",  "Wallenberg",        .legendary),
            ("olliemaster",  "Justin Herman Plaza", .iconic),
        ]

        for (username, spotName, fameTier) in checkIns {
            context.insert(SpotCheckIn(username: username, spotName: spotName, fameTier: fameTier))
        }

        // Trophies earned by mock users from those check-ins
        // order: (username, key, name, rarity, icon)
        let trophies: [(String, String, String, TrophyRarity, String)] = [
            ("grindset_99",  "first_drop",                 "First Drop",          .common,    "skateboard"),
            ("grindset_99",  "legendary_Pier 7",           "Pier 7",              .legendary, "star.fill"),
            ("grindset_99",  "legendary_Embarcadero",      "Embarcadero",         .legendary, "star.fill"),
            ("grindset_99",  "legendary_Wallenberg",       "Wallenberg",          .legendary, "star.fill"),
            ("grindset_99",  "iconic_Potrero del Sol",     "Potrero del Sol",     .rare,      "mappin.and.ellipse.fill"),
            ("grindset_99",  "iconic_China Banks",         "China Banks",         .rare,      "mappin.and.ellipse.fill"),
            ("grindset_99",  "spot_collector",             "Spot Collector",      .rare,      "map.fill"),
            ("skate_rat_sf", "first_drop",                 "First Drop",          .common,    "skateboard"),
            ("skate_rat_sf", "legendary_Pier 7",           "Pier 7",              .legendary, "star.fill"),
            ("skate_rat_sf", "legendary_Hubba Hideout",    "Hubba Hideout",       .legendary, "star.fill"),
            ("skate_rat_sf", "iconic_Potrero del Sol",     "Potrero del Sol",     .rare,      "mappin.and.ellipse.fill"),
            ("olliemaster",  "first_drop",                 "First Drop",          .common,    "skateboard"),
            ("olliemaster",  "legendary_Wallenberg",       "Wallenberg",          .legendary, "star.fill"),
            ("olliemaster",  "iconic_Justin Herman Plaza", "Justin Herman Plaza", .rare,      "mappin.and.ellipse.fill"),
        ]

        for (username, key, name, rarity, icon) in trophies {
            context.insert(Trophy(key: key, name: name, icon: icon, rarity: rarity, username: username))
        }

        try? context.save()
    }

    static func seedClips(into context: ModelContext) {
        let descriptor = FetchDescriptor<SpotClip>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        let clips: [(String, String, String, String)] = [
            ("Pier 7",          "https://youtube.com", "Morning glass sesh",     "grindset_99"),
            ("Pier 7",          "https://youtube.com", "Smith grind to fakie",   "skate_rat_sf"),
            ("Wallenberg",      "https://youtube.com", "Kickflip front board",   "olliemaster"),
            ("Embarcadero",     "https://youtube.com", "Classic EMB footage",    "grindset_99"),
            ("Hubba Hideout",   "https://youtube.com", "Hubba nosegrind line",   "skate_rat_sf"),
        ]

        for (spotName, url, title, addedBy) in clips {
            context.insert(SpotClip(spotName: spotName, clipURL: url, title: title, addedBy: addedBy))
        }

        try? context.save()
    }

    static func seedBustVotes(into context: ModelContext) {
        let descriptor = FetchDescriptor<BustVote>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        let votes: [(String, BustStatus, String)] = [
            ("Pier 7",              .green,  "grindset_99"),
            ("Pier 7",              .green,  "skate_rat_sf"),
            ("Pier 7",              .green,  "olliemaster"),
            ("Embarcadero",         .yellow, "grindset_99"),
            ("Embarcadero",         .yellow, "skate_rat_sf"),
            ("Justin Herman Plaza", .red,    "olliemaster"),
            ("Justin Herman Plaza", .red,    "grindset_99"),
            ("Justin Herman Plaza", .red,    "skate_rat_sf"),
            ("Wallenberg",          .green,  "grindset_99"),
            ("Wallenberg",          .green,  "olliemaster"),
        ]

        for (spotName, vote, username) in votes {
            context.insert(BustVote(spotName: spotName, vote: vote, username: username))
        }

        try? context.save()
    }
}
