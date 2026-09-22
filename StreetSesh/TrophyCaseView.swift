import SwiftUI
import SwiftData

private extension TrophyRarity {
    var color: Color {
        switch self {
        case .common:    return .white
        case .rare:      return Color(red: 0.4, green: 0.6, blue: 1.0)
        case .legendary: return .orange
        }
    }

    var label: String {
        switch self {
        case .common:    return "Common"
        case .rare:      return "Rare"
        case .legendary: return "Legendary"
        }
    }
}

struct TrophyCaseView: View {
    let username: String
    @Query private var allTrophies: [Trophy]

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var myTrophies: [Trophy] {
        allTrophies
            .filter { $0.username == username }
            .sorted { $0.earnedAt > $1.earnedAt }
    }

    private var legendaryTrophies: [Trophy] { myTrophies.filter { $0.rarity == .legendary } }
    private var rareTrophies: [Trophy]      { myTrophies.filter { $0.rarity == .rare } }
    private var commonTrophies: [Trophy]    { myTrophies.filter { $0.rarity == .common } }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                if myTrophies.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            if !legendaryTrophies.isEmpty {
                                trophySection(title: "LEGENDARY", trophies: legendaryTrophies)
                            }
                            if !rareTrophies.isEmpty {
                                trophySection(title: "RARE", trophies: rareTrophies)
                            }
                            if !commonTrophies.isEmpty {
                                trophySection(title: "COMMON", trophies: commonTrophies)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Trophy Case")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "trophy")
                .font(.system(size: 60))
                .foregroundStyle(.orange.opacity(0.3))
            Text("No trophies yet.")
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text("Go live at a legendary spot to earn your first.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    @ViewBuilder
    private func trophySection(title: String, trophies: [Trophy]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(.secondary)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(trophies) { trophy in
                    trophyCard(trophy)
                }
            }
        }
    }

    @ViewBuilder
    private func trophyCard(_ trophy: Trophy) -> some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(trophy.rarity.color.opacity(0.15))
                    .frame(width: 56, height: 56)
                Image(systemName: trophy.icon)
                    .font(.system(size: 24))
                    .foregroundStyle(trophy.rarity.color)
            }
            Text(trophy.name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Text(trophy.rarity.label)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(trophy.rarity.color.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .padding(.horizontal, 10)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(trophy.rarity.color.opacity(0.2), lineWidth: 1))
    }
}
