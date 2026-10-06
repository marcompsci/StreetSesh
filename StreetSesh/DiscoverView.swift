import SwiftUI
import SwiftData

struct DiscoverView: View {
    @Environment(\.dismiss)       private var dismiss
    @Environment(\.modelContext)  private var modelContext
    @Query private var spots:    [Spot]
    @Query private var sessions: [LiveSession]
    @Query(sort: \SpotCheckIn.checkedInAt, order: .reverse) private var checkIns: [SpotCheckIn]
    @Query private var users:    [AppUser]
    @Query(sort: \SpotBookmark.addedAt, order: .reverse) private var bookmarks: [SpotBookmark]

    @State private var tab: DiscoverTab = .forYou

    enum DiscoverTab: String, CaseIterable {
        case forYou     = "For You"
        case bucketList = "Bucket List"
    }

    private var currentUsername: String { users.first?.username ?? "" }

    // MARK: - Recommendation Engine

    struct ScoredSpot: Identifiable {
        var id: String { spot.name }
        let spot: Spot
        let score: Int
        let isBookmarked: Bool
        let hasActiveSession: Bool
    }

    var recommendations: [ScoredSpot] {
        let myCheckIns     = Set(checkIns.filter { $0.username == currentUsername }.map { $0.spotName })
        let bookmarkNames  = Set(bookmarks.map { $0.spotName })
        let activeNames    = Set(sessions.filter { $0.isActive }.map { $0.spotName })

        return spots
            .filter { !$0.isRetired }
            .map { spot -> ScoredSpot in
                var score = 0
                switch spot.bustStatus {
                case .green:  score += 3
                case .yellow: score += 1
                case .red:    break
                }
                switch spot.fameTier {
                case .legendary: score += 4
                case .iconic:    score += 3
                case .local:     score += 2
                case .hidden:    score += 1
                }
                let hot = activeNames.contains(spot.name)
                if hot                               { score += 4 }
                if !myCheckIns.contains(spot.name)  { score += 2 }
                return ScoredSpot(spot: spot, score: score,
                                  isBookmarked: bookmarkNames.contains(spot.name),
                                  hasActiveSession: hot)
            }
            .sorted { $0.score > $1.score }
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    tabPicker
                    Group {
                        if tab == .forYou {
                            forYouContent
                        } else {
                            bucketListContent
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: tab)
                }
            }
            .navigationTitle("Discover")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
                if tab == .bucketList && !bookmarks.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Text("\(bookmarks.count) saved")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Tab Picker

    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(DiscoverTab.allCases, id: \.self) { t in
                Button {
                    withAnimation(.snappy) { tab = t }
                } label: {
                    VStack(spacing: 0) {
                        Text(t.rawValue)
                            .font(.system(size: 13, weight: .black))
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(tab == t ? Color.white : Color.secondary)
                        Rectangle()
                            .fill(tab == t ? Color.orange : Color.clear)
                            .frame(height: 2)
                    }
                }
            }
        }
        .background(Color.white.opacity(0.04))
    }

    // MARK: - For You

    private var forYouContent: some View {
        Group {
            if recommendations.isEmpty {
                emptyState(icon: "sparkles",
                           title: "No Spots Yet",
                           message: "Spots will appear here as they're added to the map.")
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        let hot  = recommendations.filter { $0.hasActiveSession }
                        let rest = recommendations.filter { !$0.hasActiveSession }

                        if !hot.isEmpty {
                            sectionHeader(title: "HOT RIGHT NOW",        icon: "flame.fill",  colorHex: "#FF5A35")
                                .padding(.top, 8)
                            ForEach(hot.prefix(5)) { spotRow($0) }
                        }

                        sectionHeader(title: "RECOMMENDED FOR YOU", icon: "sparkles",    colorHex: "#CCFF40")
                            .padding(.top, hot.isEmpty ? 8 : 16)
                        ForEach(rest.prefix(40)) { spotRow($0) }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    private func sectionHeader(title: String, icon: String, colorHex: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(Color(hex: colorHex))
            Text(title)
                .font(.system(size: 10, weight: .black))
                .tracking(1.0)
                .foregroundStyle(Color(hex: colorHex).opacity(0.85))
            Spacer()
        }
    }

    private func spotRow(_ scored: ScoredSpot) -> some View {
        let spot = scored.spot
        return HStack(spacing: 12) {
            Circle()
                .fill(bustColor(spot.bustStatus))
                .frame(width: 9, height: 9)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(spot.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    if scored.hasActiveSession {
                        Label("LIVE", systemImage: "bolt.fill")
                            .font(.system(size: 8, weight: .black))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Color(hex: "#CCFF40"))
                            .clipShape(Capsule())
                    }
                }
                HStack(spacing: 5) {
                    Text(spot.fameTier.label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if !spot.obstacles.isEmpty {
                        Text("·").foregroundStyle(.secondary).font(.caption)
                        Text(spot.obstacles.prefix(2).joined(separator: ", "))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }

            Spacer()

            Button { toggleBookmark(spot) } label: {
                Image(systemName: scored.isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 16))
                    .foregroundStyle(scored.isBookmarked ? Color.orange : Color.secondary)
                    .animation(.spring(response: 0.3), value: scored.isBookmarked)
            }
        }
        .padding(.vertical, 11)
        .padding(.horizontal, 14)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Bucket List

    private var bucketListContent: some View {
        Group {
            if bookmarks.isEmpty {
                emptyState(icon: "bookmark.slash.fill",
                           title: "Nothing Saved Yet",
                           message: "Tap the bookmark icon on any spot to save it for later.")
            } else {
                List {
                    ForEach(bookmarks) { bookmark in
                        bucketRow(bookmark)
                            .listRowBackground(Color.white.opacity(0.06))
                            .listRowSeparatorTint(Color.white.opacity(0.08))
                    }
                    .onDelete { offsets in
                        for i in offsets { modelContext.delete(bookmarks[i]) }
                        try? modelContext.save()
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
    }

    private func bucketRow(_ bookmark: SpotBookmark) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(bustColor(bookmark.bustStatus))
                .frame(width: 9, height: 9)

            VStack(alignment: .leading, spacing: 4) {
                Text(bookmark.spotName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)

                HStack(spacing: 5) {
                    Text(bookmark.fameTier.label)
                    if !bookmark.obstacles.isEmpty {
                        Text("·")
                        Text(bookmark.obstacles.prefix(2).joined(separator: ", "))
                            .lineLimit(1)
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(bookmark.addedAt.skRelative)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                bustPill(bookmark.bustStatus)
            }
        }
        .padding(.vertical, 4)
    }

    private func bustPill(_ status: BustStatus) -> some View {
        Text(status.label)
            .font(.system(size: 9, weight: .black))
            .foregroundStyle(bustColor(status))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(bustColor(status).opacity(0.12))
            .clipShape(Capsule())
    }

    // MARK: - Helpers

    private func emptyState(icon: String, title: String, message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 42))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
            Spacer()
        }
    }

    private func bustColor(_ status: BustStatus) -> Color {
        switch status {
        case .green:  return Color(hex: "#34C759")
        case .yellow: return Color(hex: "#FFD700")
        case .red:    return Color(hex: "#FF3B30")
        }
    }

    private func toggleBookmark(_ spot: Spot) {
        if let existing = bookmarks.first(where: { $0.spotName == spot.name }) {
            modelContext.delete(existing)
        } else {
            modelContext.insert(SpotBookmark(from: spot))
        }
        try? modelContext.save()
    }
}
