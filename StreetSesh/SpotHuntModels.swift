import Foundation
import SwiftData

// MARK: - SwiftData Model

@Model
final class HuntScore {
    var username: String
    var totalPoints: Int
    var correctCount: Int
    var roundCount: Int
    var playedAt: Date
    var isCurrentUser: Bool
    var huntDateKey: String  // "yyyy-MM-dd" — prevents replaying the same day

    var accuracy: Double {
        guard roundCount > 0 else { return 0 }
        return Double(correctCount) / Double(roundCount)
    }

    init(username: String, totalPoints: Int, correctCount: Int, roundCount: Int, isCurrentUser: Bool = false) {
        self.username = username
        self.totalPoints = totalPoints
        self.correctCount = correctCount
        self.roundCount = roundCount
        self.playedAt = Date()
        self.isCurrentUser = isCurrentUser
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        self.huntDateKey = fmt.string(from: Date())
    }
}

// MARK: - Spot Clue

struct SpotClue {
    let obstacles: String   // What's there
    let vibe: String        // Atmosphere
    let geoHint: String     // Vague location
}

// MARK: - Clue Library

enum HuntClueData {
    static let clues: [String: SpotClue] = [
        "Pier 7": SpotClue(
            obstacles: "Long marble ledges, benches, gap over the water",
            vibe: "Historic wooden pier. Perfect glass in the morning.",
            geoHint: "East edge of downtown, right on the water."
        ),
        "Potrero del Sol": SpotClue(
            obstacles: "Hubba ledge, smooth banks, long ledges",
            vibe: "Community park. A session's always going.",
            geoHint: "South Mission, south of Highway 101."
        ),
        "Embarcadero": SpotClue(
            obstacles: "Curved marble ledges, rail, banks",
            vibe: "Every major photographer has shot here. Iconic.",
            geoHint: "Along the waterfront, near the Ferry Building."
        ),
        "Wallenberg": SpotClue(
            obstacles: "Big 4-block with two rails",
            vibe: "School gap. The gnarliest drop in the city.",
            geoHint: "Inner Richmond district."
        ),
        "Fort Miley Banks": SpotClue(
            obstacles: "Old concrete banks, ledges, short stairs",
            vibe: "By the ocean. Nobody knows it's there.",
            geoHint: "Far western edge of the city."
        ),
        "China Banks": SpotClue(
            obstacles: "Concrete banks, ledges",
            vibe: "Old school classic. Tucked under the freeway.",
            geoHint: "Downtown, near Chinatown."
        ),
        "Justin Herman Plaza": SpotClue(
            obstacles: "Pyramid ledges, rails, flat ground",
            vibe: "Hot spot. Go at sunrise or don't go.",
            geoHint: "Between the Ferry Building and Market Street."
        ),
        "Civic Center Plaza": SpotClue(
            obstacles: "Long ledges, stairs, manual pad",
            vibe: "Government plaza. Opens up after 5pm on weekdays.",
            geoHint: "Near City Hall, Civic Center BART."
        ),
        "Mission Dolores": SpotClue(
            obstacles: "Rolling banks, stairs",
            vibe: "By the famous park. Good carve territory.",
            geoHint: "Mission district, on Dolores Street."
        ),
        "Hubba Hideout": SpotClue(
            obstacles: "The original hubba ledge, 10-stair",
            vibe: "Where the trick got its name.",
            geoHint: "SOMA district."
        ),
        "Black Rock": SpotClue(
            obstacles: "Natural ledge, rough concrete banks",
            vibe: "Hidden gem. You have to know someone.",
            geoHint: "South of Market, industrial area."
        ),
        "Clipper Street": SpotClue(
            obstacles: "Angled banks, manual pad",
            vibe: "On a steep SF hill. Weird angle, great spot.",
            geoHint: "Noe Valley / Castro border."
        ),
    ]
}

// MARK: - Deterministic RNG (same daily hunt for all players on a given day)

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed == 0 ? 1 : seed
    }

    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}

// MARK: - Game State

@Observable
final class HuntGame {
    var rounds: [Round] = []
    var currentIndex = 0
    var streak = 0
    var totalPoints = 0
    var showResult = false
    var lastCorrect = false
    var lastPointsEarned = 0
    var isComplete = false
    private var roundStartTime = Date()

    struct Round: Identifiable {
        let id = UUID()
        let targetSpot: Spot
        let options: [Spot]
        let clue: SpotClue
        var answered = false
        var correct = false
        var pointsEarned = 0
    }

    var currentRound: Round? {
        guard currentIndex < rounds.count else { return nil }
        return rounds[currentIndex]
    }

    var progress: Double {
        guard !rounds.isEmpty else { return 0 }
        return Double(currentIndex) / Double(rounds.count)
    }

    var correctCount: Int {
        rounds.filter { $0.correct }.count
    }

    init(spots: [Spot]) {
        rounds = Self.makeRounds(from: spots)
        roundStartTime = Date()
    }

    private static func makeRounds(from spots: [Spot]) -> [Round] {
        let cal = Calendar.current
        let dayOrdinal = cal.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let year = cal.component(.year, from: Date())
        let seed = UInt64(year) * 366 + UInt64(dayOrdinal)
        var rng = SeededRNG(seed: seed)

        let eligible = spots.filter { !$0.isRetired && HuntClueData.clues[$0.name] != nil }
        guard eligible.count >= 4 else { return [] }

        let targets = Array(eligible.shuffled(using: &rng).prefix(min(5, eligible.count)))

        return targets.map { target in
            var rng2 = rng  // separate seed per target for option variation
            let others = Array(eligible.filter { $0.name != target.name }.shuffled(using: &rng2).prefix(3))
            let options = ([target] + others).shuffled(using: &rng2)
            let clue = HuntClueData.clues[target.name]!
            return Round(targetSpot: target, options: options, clue: clue)
        }
    }

    func answer(_ spot: Spot) {
        guard currentIndex < rounds.count, !rounds[currentIndex].answered else { return }

        let correct = spot.name == rounds[currentIndex].targetSpot.name
        let elapsed = -roundStartTime.timeIntervalSinceNow

        var points = 0
        if correct {
            points = 100
            if elapsed < 5        { points += 50 }
            else if elapsed < 10  { points += 25 }
            else if elapsed < 20  { points += 10 }
            streak += 1
            if streak > 1 { points += (streak - 1) * 25 }
        } else {
            streak = 0
        }

        rounds[currentIndex].answered = true
        rounds[currentIndex].correct = correct
        rounds[currentIndex].pointsEarned = points
        totalPoints += points
        lastCorrect = correct
        lastPointsEarned = points
        showResult = true
    }

    func advance() {
        showResult = false
        currentIndex += 1
        roundStartTime = Date()
        if currentIndex >= rounds.count {
            isComplete = true
        }
    }
}
