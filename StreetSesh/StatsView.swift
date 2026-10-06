import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [AppUser]
    @Query(sort: \LiveSession.startedAt,   order: .reverse) private var sessions: [LiveSession]
    @Query(sort: \Trophy.earnedAt,         order: .reverse) private var trophies: [Trophy]
    @Query(sort: \SpotCheckIn.checkedInAt, order: .reverse) private var checkIns: [SpotCheckIn]

    private var currentUser: AppUser? { users.first }
    private var mySessions: [LiveSession] { sessions.filter { $0.isCurrentUser } }
    private var myTrophies: [Trophy] {
        guard let u = currentUser else { return [] }
        return trophies.filter { $0.username == u.username }
    }
    private var myCheckIns: [SpotCheckIn] {
        guard let u = currentUser else { return [] }
        return checkIns.filter { $0.username == u.username }
    }
    private var uniqueSpotCount: Int { Set(myCheckIns.map { $0.spotName }).count }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        overviewGrid
                        sessionChartCard
                        HStack(spacing: 16) {
                            trophyCard
                            topSpotsCard
                        }
                        milestonesCard
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
            }
            .navigationTitle("My Stats")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
            }
        }
    }

    // MARK: - Overview Grid (2×2)

    private var overviewGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            overviewCard(value: "\(currentUser?.sessionCount ?? mySessions.count)",
                         label: "Sessions",    icon: "bolt.fill",          colorHex: "#CCFF40")
            overviewCard(value: "\(uniqueSpotCount)",
                         label: "Spots Found", icon: "mappin.circle.fill",  colorHex: "#3AB5E6")
            overviewCard(value: "\(myTrophies.count)",
                         label: "Trophies",    icon: "trophy.fill",          colorHex: "#FFD700")
            overviewCard(value: "\(currentStreak) day\(currentStreak == 1 ? "" : "s")",
                         label: "Streak",      icon: "flame.fill",           colorHex: "#FF5A35")
        }
    }

    private func overviewCard(value: String, label: String, icon: String, colorHex: String) -> some View {
        let accent = Color(hex: colorHex)
        return VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(accent.opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(accent)
            }
            Text(value)
                .font(.system(size: 26, weight: .black))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(accent.opacity(0.18), lineWidth: 1))
    }

    // MARK: - Session Chart (8 weeks)

    private struct WeekBar: Identifiable {
        let id: Int
        let label: String
        let count: Int
    }

    private var weekBars: [WeekBar] {
        let cal = Calendar.current
        let now = Date()
        let fmt = DateFormatter()
        fmt.dateFormat = "M/d"
        return (0..<8).reversed().map { offset -> WeekBar in
            let weekAnchor = cal.startOfWeek(for: now)
            let weekStart  = cal.date(byAdding: .weekOfYear, value: -offset, to: weekAnchor)!
            let weekEnd    = cal.date(byAdding: .weekOfYear, value: 1, to: weekStart)!
            let count      = mySessions.filter { $0.startedAt >= weekStart && $0.startedAt < weekEnd }.count
            let label      = offset == 0 ? "Now" : fmt.string(from: weekStart)
            return WeekBar(id: -offset, label: label, count: count)
        }
    }

    private var sessionChartCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            cardHeader(title: "SESSIONS · LAST 8 WEEKS", icon: "chart.bar.fill", colorHex: "#CCFF40")

            if mySessions.isEmpty {
                placeholder("Start a session to see your weekly chart here.")
            } else {
                Chart(weekBars) { bar in
                    BarMark(
                        x: .value("Week", bar.label),
                        y: .value("Sessions", bar.count)
                    )
                    .foregroundStyle(
                        bar.id == 0
                            ? Color(hex: "#CCFF40").gradient
                            : Color(hex: "#CCFF40").opacity(0.45).gradient
                    )
                    .cornerRadius(5)
                    .annotation(position: .top) {
                        if bar.count > 0 {
                            Text("\(bar.count)")
                                .font(.system(size: 9, weight: .black))
                                .foregroundStyle(Color(hex: "#CCFF40").opacity(0.85))
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel(centered: true)
                            .font(.system(size: 9))
                            .foregroundStyle(Color.secondary)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) { _ in
                        AxisValueLabel()
                            .font(.system(size: 9))
                            .foregroundStyle(Color.secondary)
                        AxisGridLine()
                            .foregroundStyle(Color.white.opacity(0.06))
                    }
                }
                .chartPlotStyle { plot in
                    plot.background(Color.clear)
                }
                .frame(height: 150)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Trophy Card

    private var trophyCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            cardHeader(title: "TROPHIES", icon: "trophy.fill", colorHex: "#FFD700")

            if myTrophies.isEmpty {
                placeholder("Discover legendary spots to earn trophies.")
            } else {
                let total = max(myTrophies.count, 1)
                VStack(spacing: 10) {
                    trophyBar(label: "Common",    count: myTrophies.filter { $0.rarity == .common    }.count, total: total, colorHex: "#A0A0A0")
                    trophyBar(label: "Rare",      count: myTrophies.filter { $0.rarity == .rare      }.count, total: total, colorHex: "#3AB5E6")
                    trophyBar(label: "Legendary", count: myTrophies.filter { $0.rarity == .legendary }.count, total: total, colorHex: "#FFD700")
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func trophyBar(label: String, count: Int, total: Int, colorHex: String) -> some View {
        let accent = Color(hex: colorHex)
        let frac   = total > 0 ? CGFloat(count) / CGFloat(total) : 0
        return VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label).font(.system(size: 11)).foregroundStyle(.secondary)
                Spacer()
                Text("\(count)").font(.system(size: 11, weight: .black)).foregroundStyle(accent)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2).fill(Color.white.opacity(0.08)).frame(height: 5)
                    RoundedRectangle(cornerRadius: 2).fill(accent)
                        .frame(width: geo.size.width * frac, height: 5)
                }
            }
            .frame(height: 5)
        }
    }

    // MARK: - Top Spots Card

    private var topSpotsData: [(name: String, count: Int)] {
        var counts: [String: Int] = [:]
        for c in myCheckIns { counts[c.spotName, default: 0] += 1 }
        return counts.map { (name: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
            .prefix(5)
            .map { $0 }
    }

    private var topSpotsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            cardHeader(title: "TOP SPOTS", icon: "mappin.and.ellipse", colorHex: "#3AB5E6")

            if topSpotsData.isEmpty {
                placeholder("Check in at spots to track your favorites.")
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(topSpotsData.enumerated()), id: \.offset) { i, spot in
                        HStack(spacing: 8) {
                            Text("\(i + 1)")
                                .font(.system(size: 11, weight: .black))
                                .foregroundStyle(i == 0 ? Color(hex: "#FFD700") : .secondary)
                                .frame(width: 14, alignment: .center)
                            Text(spot.name)
                                .font(.system(size: 12))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                            Spacer()
                            Text("×\(spot.count)")
                                .font(.system(size: 11, weight: .black))
                                .foregroundStyle(Color(hex: "#3AB5E6"))
                        }
                        .padding(.vertical, 7)
                        if i < topSpotsData.count - 1 {
                            Divider().background(Color.white.opacity(0.06))
                        }
                    }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Milestones Card

    private var currentStreak: Int {
        let cal      = Calendar.current
        let playDays = Set(mySessions.map { cal.startOfDay(for: $0.startedAt) })
        let today    = cal.startOfDay(for: Date())
        var streak   = 0
        var check    = today
        while playDays.contains(check) {
            streak += 1
            check = cal.date(byAdding: .day, value: -1, to: check)!
        }
        return streak
    }

    private var favoriteActivity: String? {
        var counts: [String: Int] = [:]
        for s in mySessions where !s.activity.isEmpty {
            counts[s.activity, default: 0] += 1
        }
        return counts.max { $0.value < $1.value }?.key
    }

    private var milestonesCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            cardHeader(title: "MILESTONES", icon: "flag.checkered", colorHex: "#FF5A35")
            VStack(spacing: 0) {
                milestoneRow(icon: "flame.fill",          colorHex: "#FF5A35", label: "Current Streak",  value: "\(currentStreak) day\(currentStreak == 1 ? "" : "s")")
                Divider().background(Color.white.opacity(0.06))
                milestoneRow(icon: "mappin.circle.fill",  colorHex: "#3AB5E6", label: "Unique Spots",    value: "\(uniqueSpotCount)")
                Divider().background(Color.white.opacity(0.06))
                milestoneRow(icon: "bolt.fill",           colorHex: "#CCFF40", label: "Total Sessions",  value: "\(currentUser?.sessionCount ?? mySessions.count)")
                Divider().background(Color.white.opacity(0.06))
                milestoneRow(icon: "trophy.fill",         colorHex: "#FFD700", label: "Trophies Earned", value: "\(myTrophies.count)")
                if let fav = favoriteActivity {
                    Divider().background(Color.white.opacity(0.06))
                    milestoneRow(icon: "skateboard",      colorHex: "#C77DFF", label: "Favorite Style",  value: fav)
                }
                if uniqueSpotCount > 0 {
                    Divider().background(Color.white.opacity(0.06))
                    milestoneRow(icon: "figure.skating",  colorHex: "#CCFF40", label: "Check-ins",       value: "\(myCheckIns.count)")
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func milestoneRow(icon: String, colorHex: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(Color(hex: colorHex))
                .frame(width: 22)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .black))
                .foregroundStyle(.white)
        }
        .padding(.vertical, 11)
    }

    // MARK: - Shared Helpers

    private func cardHeader(title: String, icon: String, colorHex: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(Color(hex: colorHex))
            Text(title)
                .font(.system(size: 10, weight: .black))
                .tracking(1.0)
                .foregroundStyle(Color(hex: colorHex).opacity(0.8))
        }
    }

    private func placeholder(_ message: String) -> some View {
        Text(message)
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
    }
}

// MARK: - Calendar helper

private extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components) ?? date
    }
}
