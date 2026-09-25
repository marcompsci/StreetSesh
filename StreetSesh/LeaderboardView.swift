import SwiftUI

// MARK: - Leaderboard Root

struct LeaderboardView: View {
    @EnvironmentObject private var appState: SkateCityAppState
    @State private var selectedCategory: SKLeaderboardCategory = .sessionKings
    @State private var selectedYear:     SKLeaderboardYear     = .y2026
    @State private var showGameOfSkate                         = false

    private var entries: [SKLeaderboardEntry] {
        SKMockData.leaderboardEntries(for: selectedCategory, year: selectedYear)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skDark.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        gameOfSkateBanner
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 20)

                        categorySelector
                            .padding(.bottom, 16)

                        yearFilter
                            .padding(.horizontal, 16)
                            .padding(.bottom, 10)

                        subtitleRow
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)

                        rankingsList
                            .padding(.horizontal, 16)
                            .padding(.bottom, 36)
                    }
                }
            }
            .navigationTitle("Leaderboard")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
        }
        #if os(iOS)
        .fullScreenCover(isPresented: $showGameOfSkate) {
            GameOfSkateView()
                .environmentObject(appState)
        }
        #endif
    }

    // MARK: - Game of S.K.A.T.E Banner

    private var gameOfSkateBanner: some View {
        Button { showGameOfSkate = true } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        colors: [Color(hex: "#1C0E3A"), Color(hex: "#0D1117")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "#C77DFF").opacity(0.45), lineWidth: 1.5)
                    )

                HStack(spacing: 14) {
                    // Mini radar preview
                    SkateRadarMiniView()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(hex: "#C77DFF").opacity(0.3), lineWidth: 1))

                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 5) {
                            Circle()
                                .fill(Color.skCoral)
                                .frame(width: 6, height: 6)
                            Text("\(SKMockData.nearbySkaters.filter(\.isChallengeable).count) SKATERS LIVE NEARBY")
                                .font(.system(size: 9, weight: .black))
                                .foregroundStyle(Color.skCoral)
                                .tracking(0.5)
                        }
                        Text("GAME OF\nS.K.A.T.E")
                            .font(.system(size: 24, weight: .black))
                            .foregroundStyle(.white)
                            .lineSpacing(1)
                        Text("Challenge · Flip · Meet up · Skate")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.white.opacity(0.4))
                    }

                    Spacer()

                    VStack(spacing: 5) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#C77DFF").opacity(0.18))
                                .frame(width: 40, height: 40)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .black))
                                .foregroundStyle(Color(hex: "#C77DFF"))
                        }
                        Text("GO LIVE")
                            .font(.system(size: 8, weight: .black))
                            .foregroundStyle(Color(hex: "#C77DFF"))
                    }
                }
                .padding(16)
            }
            .frame(height: 110)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Category Selector

    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(SKLeaderboardCategory.allCases) { cat in
                    LeaderboardCategoryCard(category: cat,
                                           isSelected: selectedCategory == cat)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                                selectedCategory = cat
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
    }

    // MARK: - Year Filter

    private var yearFilter: some View {
        HStack(spacing: 0) {
            ForEach(SKLeaderboardYear.allCases) { year in
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) { selectedYear = year }
                } label: {
                    Text(year.rawValue)
                        .font(.system(size: 13, weight: selectedYear == year ? .black : .regular))
                        .foregroundStyle(selectedYear == year ? Color.skLime : Color.skSub)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(selectedYear == year
                                    ? Color.skLime.opacity(0.10)
                                    : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                if year != .allTime { Spacer() }
            }
        }
    }

    // MARK: - Subtitle

    private var subtitleRow: some View {
        HStack {
            Text(selectedCategory.subtitle.uppercased())
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(Color(hex: selectedCategory.accentHex).opacity(0.75))
                .tracking(0.8)
            Spacer()
        }
    }

    // MARK: - Rankings

    private var rankingsList: some View {
        VStack(spacing: 7) {
            ForEach(entries) { entry in
                LeaderboardRow(entry: entry,
                               metricLabel: selectedCategory.metricLabel,
                               accentHex: selectedCategory.accentHex)
            }
        }
    }
}

// MARK: - Category Card

struct LeaderboardCategoryCard: View {
    let category: SKLeaderboardCategory
    let isSelected: Bool

    var body: some View {
        let accent = Color(hex: category.accentHex)
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(accent.opacity(isSelected ? 0.22 : 0.12))
                        .frame(width: 36, height: 36)
                    Image(systemName: category.iconName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(accent)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .black))
                        .foregroundStyle(accent)
                        .padding(5)
                        .background(accent.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            Text(category.rawValue)
                .font(.system(size: 12, weight: .black))
                .foregroundStyle(.white)
                .lineLimit(1)
            Text(category.subtitle)
                .font(.system(size: 9))
                .foregroundStyle(Color.skSub)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(13)
        .frame(width: 138, height: 116)
        .background(isSelected ? accent.opacity(0.08) : Color.skCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? accent.opacity(0.55) : Color.skBorder, lineWidth: isSelected ? 1.5 : 1)
        )
        .shadow(color: isSelected ? accent.opacity(0.18) : .clear, radius: 10)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Leaderboard Row

struct LeaderboardRow: View {
    let entry: SKLeaderboardEntry
    let metricLabel: String
    let accentHex: String

    private var rankColor: Color {
        switch entry.rank {
        case 1:  return Color(hex: "#FFD700")
        case 2:  return Color(hex: "#C0C0C0")
        case 3:  return Color(hex: "#CD7F32")
        default: return Color.skSub
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            // Rank number
            Text("\(entry.rank)")
                .font(.system(size: entry.rank <= 3 ? 20 : 15,
                              weight: entry.rank <= 3 ? .black : .semibold,
                              design: .rounded))
                .foregroundStyle(rankColor)
                .frame(width: 28, alignment: .center)

            // Avatar
            ZStack {
                Circle()
                    .fill(Color(hex: entry.avatarColorHex).opacity(0.18))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle().stroke(
                            entry.rank == 1
                                ? Color(hex: "#FFD700")
                                : (entry.isCurrentUser ? Color.skLime : Color.clear),
                            lineWidth: 2
                        )
                    )
                Text(entry.avatarInitial)
                    .font(.system(size: 17, weight: .black))
                    .foregroundStyle(Color(hex: entry.avatarColorHex))
            }
            // Crown for #1
            .overlay(alignment: .topTrailing) {
                if entry.rank == 1 {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(Color(hex: "#FFD700"))
                        .offset(x: 4, y: -4)
                }
            }

            // Handle + city
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(entry.handle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(entry.isCurrentUser ? Color.skLime : .white)
                        .lineLimit(1)
                    if entry.isCurrentUser {
                        Text("YOU")
                            .font(.system(size: 7, weight: .black))
                            .padding(.horizontal, 5).padding(.vertical, 2)
                            .background(Color.skLime.opacity(0.18))
                            .foregroundStyle(Color.skLime)
                            .clipShape(Capsule())
                    }
                }
                Text(entry.city)
                    .font(.caption)
                    .foregroundStyle(Color.skSub)
            }

            Spacer()

            // Metric value
            Text("\(entry.metricValue)")
                .font(.system(size: 15, weight: .black))
                .foregroundStyle(entry.rank <= 3 ? rankColor : Color.white.opacity(0.85))
            + Text(" \(metricLabel)")
                .font(.system(size: 11, weight: .regular))
                .italic()
                .foregroundStyle(Color.skSub)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            entry.isCurrentUser
                ? Color.skLime.opacity(0.055)
                : (entry.rank <= 3 ? Color.white.opacity(0.035) : Color.skCard)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    entry.isCurrentUser
                        ? Color.skLime.opacity(0.28)
                        : (entry.rank == 1
                            ? Color(hex: "#FFD700").opacity(0.25)
                            : (entry.rank <= 3 ? Color.white.opacity(0.06) : Color.clear)),
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Mini Radar Preview (used in the banner)

struct SkateRadarMiniView: View {
    @State private var pulse: CGFloat = 1.0
    @State private var sweep: Double  = 0

    var body: some View {
        ZStack {
            Color(hex: "#0D0520")

            // Rings
            ForEach([0.35, 0.68, 1.0], id: \.self) { scale in
                Circle()
                    .stroke(Color(hex: "#C77DFF").opacity(0.14), lineWidth: 0.5)
                    .scaleEffect(scale)
            }

            // Sweep wedge
            GeometryReader { geo in
                let cx = geo.size.width  / 2
                let cy = geo.size.height / 2
                let r  = min(cx, cy)
                Path { p in
                    p.move(to: CGPoint(x: cx, y: cy))
                    p.addArc(center: CGPoint(x: cx, y: cy), radius: r,
                             startAngle: .degrees(sweep - 50 - 90),
                             endAngle:   .degrees(sweep - 90),
                             clockwise: false)
                    p.closeSubpath()
                }
                .fill(LinearGradient(
                    colors: [Color(hex: "#C77DFF").opacity(0.0), Color(hex: "#C77DFF").opacity(0.12)],
                    startPoint: .leading, endPoint: .trailing
                ))
            }

            // Pulse ring
            Circle()
                .stroke(Color(hex: "#C77DFF").opacity(0.5), lineWidth: 1)
                .scaleEffect(pulse)
                .opacity(Double(2.6 - pulse) / 1.6)

            // User center — app sticker
            Image("SSMapSticker")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                .shadow(color: Color.skLime.opacity(0.8), radius: 4)

            // Skater dots
            GeometryReader { geo in
                let cx = geo.size.width  / 2
                let cy = geo.size.height / 2
                let r  = min(cx, cy) - 4
                ForEach(SKMockData.nearbySkaters) { sk in
                    let ang = (sk.radarAngleDeg - 90) * .pi / 180
                    let d   = r * sk.radarNorm
                    Circle()
                        .fill(Color(hex: sk.avatarColorHex))
                        .frame(width: 5, height: 5)
                        .position(x: cx + d * cos(ang), y: cy + d * sin(ang))
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.8).repeatForever(autoreverses: false)) {
                pulse = 2.5
            }
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                sweep = 360
            }
        }
    }
}
