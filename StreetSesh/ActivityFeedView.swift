import SwiftUI
import SwiftData

struct ActivityFeedView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [AppUser]
    @Query private var crews: [Crew]
    @Query(sort: \LiveSession.startedAt, order: .reverse)   private var sessions: [LiveSession]
    @Query(sort: \Trophy.earnedAt,       order: .reverse)   private var trophies: [Trophy]
    @Query(sort: \SpotCheckIn.checkedInAt, order: .reverse) private var checkIns: [SpotCheckIn]
    @Query(sort: \Spot.submittedAt,      order: .reverse)   private var spots: [Spot]

    @State private var scope: FeedScope = .mine
    @State private var remoteFeed: [FeedItem] = []
    @State private var isLoading = false

    enum FeedScope: String, CaseIterable {
        case mine   = "Mine"
        case crew   = "Crew"
        case global = "Global"
    }

    private var currentUser: AppUser? { users.first }
    private var myCrew: Crew? {
        guard let u = currentUser else { return nil }
        return crews.first { $0.ownerUsername == u.username || $0.memberList.contains(u.username) }
    }
    private var crewMembers: [String] {
        guard let crew = myCrew else { return [] }
        return (crew.memberList + [crew.ownerUsername]).filter { !$0.isEmpty }
    }

    private var myFeedItems: [FeedItem] {
        guard let user = currentUser else { return [] }
        return FeedService.shared.buildMyFeed(
            sessions: sessions, trophies: trophies,
            checkIns: checkIns, spots: spots,
            username: user.username
        )
    }

    private var displayedItems: [FeedItem] {
        scope == .mine ? myFeedItems : remoteFeed
    }

    private var groupedItems: [(String, [FeedItem])] {
        let cal   = Calendar.current
        let today     = cal.startOfDay(for: Date())
        let yesterday = cal.date(byAdding: .day, value: -1, to: today)!
        let weekAgo   = cal.date(byAdding: .day, value: -7, to: today)!

        var todayBucket:    [FeedItem] = []
        var yesterdayBucket:[FeedItem] = []
        var weekBucket:     [FeedItem] = []
        var earlierBucket:  [FeedItem] = []

        for item in displayedItems {
            let day = cal.startOfDay(for: item.happenedAt)
            if day >= today           { todayBucket.append(item)     }
            else if day >= yesterday  { yesterdayBucket.append(item) }
            else if day > weekAgo     { weekBucket.append(item)      }
            else                      { earlierBucket.append(item)   }
        }

        var result: [(String, [FeedItem])] = []
        if !todayBucket.isEmpty     { result.append(("Today",     todayBucket))     }
        if !yesterdayBucket.isEmpty { result.append(("Yesterday", yesterdayBucket)) }
        if !weekBucket.isEmpty      { result.append(("This Week", weekBucket))      }
        if !earlierBucket.isEmpty   { result.append(("Earlier",   earlierBucket))   }
        return result
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    scopePicker
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 12)
                    Divider().background(Color.white.opacity(0.07))
                    feedContent
                }
            }
            .navigationTitle("Activity")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
            }
        }
        .task { await loadFeed() }
        .onChange(of: scope) { _, _ in Task { await loadFeed() } }
    }

    // MARK: - Scope Picker

    private var scopePicker: some View {
        HStack(spacing: 6) {
            ForEach(FeedScope.allCases, id: \.self) { s in
                Button { withAnimation(.easeInOut(duration: 0.15)) { scope = s } } label: {
                    Text(s.rawValue)
                        .font(.system(size: 12, weight: .black))
                        .tracking(0.5)
                        .foregroundStyle(scope == s ? .black : .white)
                        .padding(.horizontal, 16).padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(scope == s ? Color.orange : Color.white.opacity(0.08))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var feedContent: some View {
        if isLoading {
            Spacer()
            ProgressView().tint(.orange)
            Spacer()
        } else if displayedItems.isEmpty {
            emptyState
        } else {
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                    ForEach(groupedItems, id: \.0) { group in
                        Section {
                            ForEach(group.1) { item in
                                feedRow(item)
                                Divider()
                                    .background(Color.white.opacity(0.05))
                                    .padding(.leading, 66)
                            }
                        } header: {
                            Text(group.0.uppercased())
                                .font(.system(size: 10, weight: .black))
                                .tracking(1.2)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.black)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .refreshable { await loadFeed(force: true) }
        }
    }

    // MARK: - Feed Row

    private func feedRow(_ item: FeedItem) -> some View {
        let accent = Color(hex: item.kind.colorHex)
        return HStack(alignment: .top, spacing: 12) {
            // Kind icon
            ZStack {
                Circle()
                    .fill(accent.opacity(item.isCurrentUser ? 0.22 : 0.10))
                    .frame(width: 38, height: 38)
                Image(systemName: item.kind.iconName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(accent)
            }

            // Text content
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Text(item.isCurrentUser ? "You" : "@\(item.username)")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(item.isCurrentUser ? .orange : .white)
                    Text(item.kind.label)
                        .font(.system(size: 8, weight: .black))
                        .tracking(0.6)
                        .foregroundStyle(accent)
                        .padding(.horizontal, 5).padding(.vertical, 2)
                        .background(accent.opacity(0.12))
                        .clipShape(Capsule())
                }
                Text(item.headline)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                if !item.detail.isEmpty {
                    Text(item.detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text(item.happenedAt.skRelative)
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
                .padding(.top, 3)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(item.isCurrentUser ? Color.orange.opacity(0.04) : Color.clear)
    }

    // MARK: - Empty State

    @ViewBuilder
    private var emptyState: some View {
        Spacer()
        VStack(spacing: 14) {
            Image(systemName: emptyIcon)
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text(emptyMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        Spacer()
    }

    private var emptyIcon: String {
        switch scope {
        case .mine:   return "skateboard"
        case .crew:   return "person.3"
        case .global: return "globe"
        }
    }

    private var emptyMessage: String {
        switch scope {
        case .mine:
            return "Nothing yet.\nStart a session or discover a new spot."
        case .crew:
            return crewMembers.isEmpty
                ? "Create a crew to see what your skaters are up to."
                : "Your crew hasn't been active recently."
        case .global:
            return "No recent public sessions found."
        }
    }

    // MARK: - Remote Data Loading

    private func loadFeed(force: Bool = false) async {
        guard scope != .mine else { return }
        guard force || remoteFeed.isEmpty else { return }
        guard await RateLimiter.shared.allow(endpoint: .leaderboard) else { return }

        isLoading = true
        defer { isLoading = false }

        let username = currentUser?.username ?? ""
        let since    = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()

        do {
            switch scope {
            case .crew:
                let members = crewMembers
                guard !members.isEmpty else { remoteFeed = []; return }
                async let sessTask = SupabaseService.shared.fetchCrewSessions(usernames: members, since: since, limit: 100)
                async let trophTask = SupabaseService.shared.fetchCrewTrophies(usernames: members, since: since, limit: 100)
                let (sess, troph) = try await (sessTask, trophTask)
                remoteFeed = FeedService.shared.buildRemoteFeed(sessions: sess, trophies: troph, currentUsername: username)
            case .global:
                let sess = try await SupabaseService.shared.fetchGlobalSessions(limit: 50)
                remoteFeed = FeedService.shared.buildRemoteFeed(sessions: sess, trophies: [], currentUsername: username)
            case .mine:
                break
            }
        } catch {
            remoteFeed = []
        }
    }
}
