import Foundation
import CoreLocation

// MARK: - Mock Data (no copyrighted content)

enum SKMockData {

    static let defaultLocation = CLLocationCoordinate2D(latitude: 37.6879, longitude: -122.4702) // Daly City

    // MARK: Boards (all fictional)

    static let boards: [SKBoard] = [
        SKBoard(id: "asphalt_ghost",  name: "Asphalt Ghost",  tagline: "Built for the streets",  accentHex: "#CCFF40"),
        SKBoard(id: "cinder_block",   name: "Cinder Block",   tagline: "Heavy. Solid. Reliable.", accentHex: "#FF5A35"),
        SKBoard(id: "tide_line",      name: "Tide Line",      tagline: "Coastal flow, all day",   accentHex: "#3AB5E6"),
        SKBoard(id: "iron_ledge",     name: "Iron Ledge",     tagline: "Lock in and grind",       accentHex: "#C77DFF")
    ]

    // MARK: Shops

    static let shops: [SkateShop] = [
        SkateShop(
            id: UUID(),
            name: "Concrete Shrine",
            address: "2180 Mission St",
            neighborhood: "Mission District",
            coordinate: CLLocationCoordinate2D(latitude: 37.7620, longitude: -122.4186),
            distanceText: "0.4 mi",
            rating: 4.8,
            isOpen: true,
            specialty: "Street Decks",
            accentColorHex: "#FF5A35",
            featuredChallenge: "The Mission Grind"
        ),
        SkateShop(
            id: UUID(),
            name: "Bay Boards",
            address: "742 Haight St",
            neighborhood: "Haight-Ashbury",
            coordinate: CLLocationCoordinate2D(latitude: 37.7699, longitude: -122.4469),
            distanceText: "1.2 mi",
            rating: 4.6,
            isOpen: true,
            specialty: "Park & Vert",
            accentColorHex: "#3AB5E6",
            featuredChallenge: "Haight Street Hustle"
        ),
        SkateShop(
            id: UUID(),
            name: "Fog City Skates",
            address: "105 Geneva Ave",
            neighborhood: "Geneva",
            coordinate: CLLocationCoordinate2D(latitude: 37.7088, longitude: -122.4406),
            distanceText: "2.3 mi",
            rating: 4.7,
            isOpen: false,
            specialty: "Cruisers & Longboards",
            accentColorHex: "#CCFF40",
            featuredChallenge: "Geneva Drop"
        )
    ]

    // MARK: Spots

    static let spots: [SkateSpot] = [
        SkateSpot(
            id: UUID(),
            name: "Pier 7",
            neighborhood: "Embarcadero",
            coordinate: CLLocationCoordinate2D(latitude: 37.7989, longitude: -122.3973),
            difficulty: .advanced,
            terrainTags: ["Ledges", "Marble", "Benches"],
            popularity: 97,
            featuredTrick: "Back Nosegrind"
        ),
        SkateSpot(
            id: UUID(),
            name: "Potrero del Sol",
            neighborhood: "Mission",
            coordinate: CLLocationCoordinate2D(latitude: 37.7545, longitude: -122.4084),
            difficulty: .intermediate,
            terrainTags: ["Banks", "Ledges", "Hubba"],
            popularity: 85,
            featuredTrick: "Switch Heelflip"
        ),
        SkateSpot(
            id: UUID(),
            name: "Wallenberg Four",
            neighborhood: "Richmond",
            coordinate: CLLocationCoordinate2D(latitude: 37.7766, longitude: -122.4515),
            difficulty: .pro,
            terrainTags: ["4-Block", "Rails", "Big Drop"],
            popularity: 93,
            featuredTrick: "KF Front Board"
        ),
        SkateSpot(
            id: UUID(),
            name: "Geneva Banks",
            neighborhood: "Daly City",
            coordinate: CLLocationCoordinate2D(latitude: 37.7050, longitude: -122.4450),
            difficulty: .beginner,
            terrainTags: ["Banks", "Smooth Concrete"],
            popularity: 61,
            featuredTrick: "Ollie to Fakie"
        )
    ]

    // MARK: Challenges

    static let challenges: [SkateChallenge] = [
        SkateChallenge(
            id: UUID(),
            title: "Daily Line: Mission",
            description: "String 3 ledge tricks in the Mission District before sundown.",
            difficulty: "Medium",
            rewardXP: 150,
            duration: "45 min",
            trickTags: ["Grind", "Ledge", "Manual"],
            isCompleted: false,
            shopName: "Concrete Shrine"
        ),
        SkateChallenge(
            id: UUID(),
            title: "Haight Hustle",
            description: "Navigate Haight and stomp a clean switch-stance trick on camera.",
            difficulty: "Hard",
            rewardXP: 250,
            duration: "1 hr",
            trickTags: ["Switch", "Street", "Rails"],
            isCompleted: true,
            shopName: "Bay Boards"
        ),
        SkateChallenge(
            id: UUID(),
            title: "Pier 7 Marble Run",
            description: "Hit the marble ledge three times in one line — no footing.",
            difficulty: "Hard",
            rewardXP: 200,
            duration: "30 min",
            trickTags: ["Ledge", "Combo", "Marble"],
            isCompleted: false,
            shopName: "Fog City Skates"
        )
    ]

    // MARK: Clips

    static let clips: [SkateClip] = [
        SkateClip(
            id: UUID(),
            creatorName: "Marcus Reyes",
            creatorHandle: "@grind_marcus",
            challengeTitle: "Daily Line: Mission",
            score: 875,
            likes: 234,
            comments: 18,
            createdAt: Date().addingTimeInterval(-3_600),
            trickTags: ["Nosegrind", "Kickflip", "Manual"],
            isLiked: false
        ),
        SkateClip(
            id: UUID(),
            creatorName: "Jade Wu",
            creatorHandle: "@jade_fakie",
            challengeTitle: "Pier 7 Marble Run",
            score: 920,
            likes: 412,
            comments: 31,
            createdAt: Date().addingTimeInterval(-7_200),
            trickTags: ["Heelflip", "Ledge", "Backside"],
            isLiked: true
        ),
        SkateClip(
            id: UUID(),
            creatorName: "Dre Okafor",
            creatorHandle: "@dre_rips",
            challengeTitle: "Haight Hustle",
            score: 760,
            likes: 198,
            comments: 12,
            createdAt: Date().addingTimeInterval(-14_400),
            trickTags: ["Switch", "Front Board"],
            isLiked: false
        ),
        SkateClip(
            id: UUID(),
            creatorName: "Rosa Kim",
            creatorHandle: "@rosagrind",
            challengeTitle: "Daily Line: Mission",
            score: 810,
            likes: 155,
            comments: 9,
            createdAt: Date().addingTimeInterval(-28_800),
            trickTags: ["Smith Grind", "Kickflip Out"],
            isLiked: false
        )
    ]

    // MARK: Sessions

    static let sessions: [CrewSession] = [
        CrewSession(
            id: UUID(),
            title: "Mission Crew Night",
            hostName: "Marcus Reyes",
            neighborhood: "Mission",
            startTime: Date().addingTimeInterval(7_200),
            participantCount: 5,
            maxParticipants: 8,
            privacy: .crew,
            status: .upcoming
        ),
        CrewSession(
            id: UUID(),
            title: "Pier 7 Sunday",
            hostName: "Jade Wu",
            neighborhood: "Embarcadero",
            startTime: Date().addingTimeInterval(86_400),
            participantCount: 3,
            maxParticipants: 6,
            privacy: .friendsOnly,
            status: .upcoming
        ),
        CrewSession(
            id: UUID(),
            title: "Wallenberg Saturday",
            hostName: "Local Crew",
            neighborhood: "Richmond",
            startTime: Date().addingTimeInterval(-1_800),
            participantCount: 7,
            maxParticipants: 10,
            privacy: .inviteOnly,
            status: .active
        )
    ]
}
