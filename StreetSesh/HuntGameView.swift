import SwiftUI

// MARK: - Game Container

struct HuntGameView: View {
    let game: HuntGame
    let onDone: (HuntGame) -> Void

    var body: some View {
        if game.isComplete {
            HuntResultsView(game: game, onDone: { onDone(game) })
        } else if game.showResult, let round = game.currentRound {
            HuntRoundResultView(round: round, game: game, onNext: { game.advance() })
        } else {
            HuntRoundView(game: game)
        }
    }
}

// MARK: - Active Round

struct HuntRoundView: View {
    let game: HuntGame

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                header
                if let round = game.currentRound {
                    clueCard(round)
                    Spacer()
                    optionButtons(round)
                }
                Spacer(minLength: 32)
            }
            .padding()
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                Text("SPOT HUNT")
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(.orange)
                Spacer()
                Text("\(game.totalPoints) pts")
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(.orange)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3).fill(Color.white.opacity(0.12)).frame(height: 4)
                    RoundedRectangle(cornerRadius: 3).fill(Color.orange)
                        .frame(width: geo.size.width * game.progress, height: 4)
                }
            }
            .frame(height: 4)

            HStack {
                Text("Round \(game.currentIndex + 1) of \(game.rounds.count)")
                    .font(.caption).foregroundStyle(.secondary)
                Spacer()
                if game.streak > 1 {
                    Label("\(game.streak) streak", systemImage: "flame.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding(.top, 56)
    }

    @ViewBuilder
    private func clueCard(_ round: HuntGame.Round) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("IDENTIFY THE SPOT")
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 14) {
                clueRow(icon: "skateboard", label: "OBSTACLES", text: round.clue.obstacles)
                clueRow(icon: "sun.horizon.fill", label: "VIBE", text: round.clue.vibe)
                clueRow(icon: "location.fill", label: "WHERE", text: round.clue.geoHint)
            }
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orange.opacity(0.15), lineWidth: 1))
    }

    @ViewBuilder
    private func clueRow(icon: String, label: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.orange)
                .frame(width: 20)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 9, weight: .black))
                    .foregroundStyle(.secondary)
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
        }
    }

    @ViewBuilder
    private func optionButtons(_ round: HuntGame.Round) -> some View {
        VStack(spacing: 10) {
            ForEach(round.options) { spot in
                Button { game.answer(spot) } label: {
                    Text(spot.name)
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(14)
                        .background(Color.white.opacity(0.09))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.08), lineWidth: 1))
                }
            }
        }
    }
}

// MARK: - Round Result

struct HuntRoundResultView: View {
    let round: HuntGame.Round
    let game: HuntGame
    let onNext: () -> Void

    private var isLastRound: Bool { game.currentIndex >= game.rounds.count - 1 }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 28) {
                Spacer()

                resultIcon

                VStack(spacing: 8) {
                    Text(round.correct ? "CORRECT!" : "NOT QUITE")
                        .font(.system(size: 28, weight: .black))
                        .foregroundStyle(.white)
                    if !round.correct {
                        Text("It was \(round.targetSpot.name)")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    if round.pointsEarned > 0 {
                        Text("+\(round.pointsEarned) pts")
                            .font(.title2.bold())
                            .foregroundStyle(.orange)
                            .padding(.top, 4)
                    }
                }

                spotInfoCard

                Spacer()

                Button(action: onNext) {
                    Text(isLastRound ? "SEE RESULTS" : "NEXT SPOT")
                        .font(.headline.weight(.black))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color.orange)
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding()
        }
    }

    private var resultIcon: some View {
        Image(systemName: round.correct ? "checkmark.circle.fill" : "xmark.circle.fill")
            .font(.system(size: 80))
            .foregroundStyle(round.correct ? Color.green : Color.red)
    }

    private var spotInfoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(round.targetSpot.name.uppercased())
                .font(.system(size: 11, weight: .black))
                .foregroundStyle(.orange)
            Text(round.targetSpot.fameTier.label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if !round.targetSpot.obstacles.isEmpty {
                Text(round.targetSpot.obstacles.joined(separator: " · "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Final Results

struct HuntResultsView: View {
    let game: HuntGame
    let onDone: () -> Void

    private var grade: String {
        let pct = game.rounds.isEmpty ? 0 : Double(game.correctCount) / Double(game.rounds.count)
        if pct == 1.0 { return "PERFECT" }
        if pct >= 0.8 { return "SOLID" }
        if pct >= 0.6 { return "DECENT" }
        return "KEEP SKATING"
    }

    private var gradeColor: Color {
        let pct = game.rounds.isEmpty ? 0 : Double(game.correctCount) / Double(game.rounds.count)
        if pct == 1.0 { return .orange }
        if pct >= 0.6 { return .green }
        return .secondary
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 28) {
                Spacer()

                VStack(spacing: 8) {
                    Text(grade)
                        .font(.system(size: 32, weight: .black))
                        .foregroundStyle(gradeColor)
                    Text("\(game.totalPoints)")
                        .font(.system(size: 64, weight: .black))
                        .foregroundStyle(.white)
                    Text("POINTS")
                        .font(.system(size: 14, weight: .black))
                        .foregroundStyle(.secondary)
                        .padding(.top, -16)
                    Text("\(game.correctCount) of \(game.rounds.count) correct")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }

                roundBreakdown

                Text("Same hunt tomorrow. New spots, new score.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Spacer()

                Button(action: onDone) {
                    Text("DONE")
                        .font(.headline.weight(.black))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color.orange)
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding()
        }
    }

    private var roundBreakdown: some View {
        VStack(spacing: 0) {
            ForEach(Array(game.rounds.enumerated()), id: \.offset) { index, round in
                HStack(spacing: 12) {
                    Image(systemName: round.correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(round.correct ? Color.green : Color.red)
                    Text(round.targetSpot.name)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                    Spacer()
                    Text(round.pointsEarned > 0 ? "+\(round.pointsEarned)" : "—")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(round.correct ? Color.orange : Color.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                if index < game.rounds.count - 1 {
                    Divider().background(Color.white.opacity(0.06))
                }
            }
        }
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
