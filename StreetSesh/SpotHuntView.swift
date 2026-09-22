import SwiftUI
import SwiftData

struct SpotHuntView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var spots: [Spot]
    @Query private var huntScores: [HuntScore]
    @Query private var users: [AppUser]

    @State private var game: HuntGame?
    @State private var showGame = false

    var currentUser: AppUser? { users.first }

    var todayKey: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: Date())
    }

    var todayScore: HuntScore? {
        huntScores.first { $0.huntDateKey == todayKey && $0.isCurrentUser }
    }

    var alreadyPlayedToday: Bool { todayScore != nil }

    var huntStreak: Int {
        let myScores = huntScores.filter { $0.isCurrentUser }
        let calendar = Calendar.current
        let playDays = Set(myScores.map { calendar.startOfDay(for: $0.playedAt) })
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        var checkDay = today
        while playDays.contains(checkDay) {
            streak += 1
            checkDay = calendar.date(byAdding: .day, value: -1, to: checkDay)!
        }
        return streak
    }

    var todayTopScores: [HuntScore] {
        Array(
            huntScores
                .filter { $0.huntDateKey == todayKey }
                .sorted { $0.totalPoints > $1.totalPoints }
                .prefix(10)
        )
    }

    var allTimeTopScores: [HuntScore] {
        var best: [String: HuntScore] = [:]
        for score in huntScores {
            if let existing = best[score.username] {
                if score.totalPoints > existing.totalPoints { best[score.username] = score }
            } else {
                best[score.username] = score
            }
        }
        return Array(best.values.sorted { $0.totalPoints > $1.totalPoints }.prefix(10))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        dailyCard
                        if !todayTopScores.isEmpty {
                            leaderboardSection(title: "TODAY", scores: todayTopScores)
                        }
                        if !allTimeTopScores.isEmpty {
                            leaderboardSection(title: "ALL TIME", scores: allTimeTopScores)
                        }
                        howItWorksSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Spot Hunt")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
        }
        .sheet(isPresented: $showGame) {
            if let g = game {
                HuntGameView(game: g) { completedGame in
                    saveScore(completedGame)
                    showGame = false
                }
            }
        }
    }

    // MARK: - Daily Card

    private var dailyCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text("DAILY HUNT")
                            .font(.system(size: 11, weight: .black))
                            .foregroundStyle(.orange)
                        if huntStreak > 1 {
                            Label("\(huntStreak)d", systemImage: "flame.fill")
                                .font(.system(size: 10, weight: .black))
                                .foregroundStyle(.orange)
                        }
                    }
                    Text(alreadyPlayedToday ? "Completed" : "5 spots · ~3 min")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if alreadyPlayedToday, let score = todayScore {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(score.totalPoints)")
                            .font(.title2.bold())
                            .foregroundStyle(.orange)
                        Text("\(score.correctCount)/\(score.roundCount) correct")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            if alreadyPlayedToday {
                Text("Come back tomorrow for the next hunt.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Button { startGame() } label: {
                    Text("PLAY TODAY'S HUNT")
                        .font(.headline.weight(.black))
                        .frame(maxWidth: .infinity)
                        .padding(14)
                        .background(Color.orange)
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orange.opacity(0.25), lineWidth: 1))
    }

    // MARK: - Leaderboard

    @ViewBuilder
    private func leaderboardSection(title: String, scores: [HuntScore]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(.secondary)

            VStack(spacing: 0) {
                ForEach(Array(scores.enumerated()), id: \.offset) { index, score in
                    leaderboardRow(rank: index + 1, score: score)
                    if index < scores.count - 1 {
                        Divider().background(Color.white.opacity(0.06))
                    }
                }
            }
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    @ViewBuilder
    private func leaderboardRow(rank: Int, score: HuntScore) -> some View {
        HStack(spacing: 12) {
            Text("\(rank)")
                .font(.system(size: 13, weight: .black))
                .foregroundStyle(rank == 1 ? Color.orange : Color.secondary)
                .frame(width: 22)

            ZStack {
                Circle()
                    .fill(score.isCurrentUser ? Color.orange : Color.white.opacity(0.15))
                    .frame(width: 32, height: 32)
                Text(String(score.username.prefix(2)).uppercased())
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(score.isCurrentUser ? .black : .white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(score.username)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(score.isCurrentUser ? Color.orange : Color.white)
                Text("\(score.correctCount)/\(score.roundCount) correct")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(score.totalPoints)")
                .font(.headline.bold())
                .foregroundStyle(rank == 1 ? Color.orange : Color.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    // MARK: - How It Works

    private var howItWorksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("HOW IT WORKS")
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 10) {
                howRow(icon: "scope",         text: "5 spots per day, picked from the map.")
                howRow(icon: "clock",         text: "Faster answers earn more points.")
                howRow(icon: "flame.fill",    text: "Streak bonus for consecutive correct answers.")
                howRow(icon: "calendar",      text: "New hunt every day. Same for everyone.")
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    @ViewBuilder
    private func howRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).foregroundStyle(.orange).frame(width: 20)
            Text(text).font(.subheadline).foregroundStyle(.secondary)
        }
    }

    // MARK: - Actions

    private func startGame() {
        game = HuntGame(spots: spots)
        showGame = true
    }

    private func saveScore(_ g: HuntGame) {
        guard let user = currentUser else { return }
        let score = HuntScore(
            username: user.username,
            totalPoints: g.totalPoints,
            correctCount: g.correctCount,
            roundCount: g.rounds.count,
            isCurrentUser: true
        )
        modelContext.insert(score)
    }
}
