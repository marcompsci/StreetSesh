import SwiftUI
import SwiftData

struct SkaterProfileView: View {
    let username: String
    let hintCity: String
    let hintSessionCount: Int

    init(username: String, city: String = "", sessionCount: Int = 0) {
        self.username        = username
        self.hintCity        = city
        self.hintSessionCount = sessionCount
    }

    @Environment(\.dismiss)       private var dismiss
    @Environment(\.modelContext)  private var modelContext
    @Query private var users:     [AppUser]
    @Query private var follows:   [FollowRelation]
    @Query(sort: \LiveSession.startedAt,   order: .reverse) private var allSessions: [LiveSession]
    @Query(sort: \Trophy.earnedAt,         order: .reverse) private var allTrophies:  [Trophy]
    @Query(sort: \SpotCheckIn.checkedInAt, order: .reverse) private var allCheckIns: [SpotCheckIn]

    @State private var showFollowers     = false
    @State private var followersInitTab  = FollowersView.Tab.followers

    // MARK: - Derived

    private var currentUser: AppUser? { users.first }
    private var isSelf: Bool          { currentUser?.username == username }

    private var amFollowing: Bool {
        guard let me = currentUser else { return false }
        return FollowEngine.isFollowing(follower: me.username, target: username, in: follows)
    }
    private var followerCount: Int { FollowEngine.followerUsernames(for: username, in: follows).count }
    private var followingCount: Int { FollowEngine.followingUsernames(for: username, in: follows).count }

    private var displayCity: String {
        hintCity.isEmpty ? "Unknown city" : hintCity
    }
    private var displaySessions: Int {
        let local = allSessions.filter { $0.username == username }.count
        return local > 0 ? local : hintSessionCount
    }
    private var theirTrophies:  [Trophy]       { allTrophies.filter  { $0.username == username } }
    private var theirCheckIns:  [SpotCheckIn]  { allCheckIns.filter  { $0.username == username } }
    private var recentSessions: [LiveSession]  { allSessions.filter  { $0.username == username }.prefix(5).map { $0 } }
    private var uniqueSpots:    Int            { Set(theirCheckIns.map { $0.spotName }).count }
    private var hasLocalData:   Bool           { !theirTrophies.isEmpty || !recentSessions.isEmpty }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        profileHero
                        followStatsRow
                        statsGrid
                        if !theirTrophies.isEmpty { trophySection }
                        if !recentSessions.isEmpty { recentActivitySection }
                        if !hasLocalData { noDataCard }
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .navigationTitle(username)
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
            }
            .sheet(isPresented: $showFollowers) {
                FollowersView(username: username, initialTab: followersInitTab)
                    .presentationBackground(Color.black)
            }
        }
    }

    // MARK: - Hero

    private var profileHero: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isSelf ? Color.orange : Color.orange.opacity(0.85))
                    .frame(width: 80, height: 80)
                Text(String(username.prefix(2)).uppercased())
                    .font(.system(size: 28, weight: .black))
                    .foregroundStyle(.black)
            }

            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    Text(username)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    if isSelf {
                        Text("YOU")
                            .font(.system(size: 9, weight: .black))
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(Color.orange.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
                Text(displayCity)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if !isSelf, let me = currentUser {
                Button {
                    if amFollowing {
                        FollowEngine.unfollow(follower: me.username, target: username,
                                             context: modelContext, existing: follows)
                    } else {
                        FollowEngine.follow(follower: me.username, target: username,
                                           context: modelContext, existing: follows)
                    }
                } label: {
                    Text(amFollowing ? "Following" : "Follow")
                        .font(.subheadline.weight(.black))
                        .frame(width: 120)
                        .padding(.vertical, 10)
                        .background(amFollowing ? Color.white.opacity(0.10) : Color.orange)
                        .foregroundStyle(amFollowing ? .white : .black)
                        .clipShape(Capsule())
                        .animation(.spring(response: 0.3), value: amFollowing)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    // MARK: - Follow Stats

    private var followStatsRow: some View {
        HStack(spacing: 0) {
            followStatButton(value: followerCount, label: "Followers") {
                followersInitTab = .followers
                showFollowers = true
            }
            Divider().frame(height: 36).background(Color.white.opacity(0.12))
            followStatButton(value: followingCount, label: "Following") {
                followersInitTab = .following
                showFollowers = true
            }
        }
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func followStatButton(value: Int, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Text("\(value)")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
    }

    // MARK: - Stats Grid

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            statCard(value: "\(displaySessions)", label: "Sessions", icon: "bolt.fill",          colorHex: "#CCFF40")
            statCard(value: "\(uniqueSpots)",     label: "Spots",    icon: "mappin.circle.fill",  colorHex: "#3AB5E6")
            statCard(value: "\(theirTrophies.count)", label: "Trophies", icon: "trophy.fill",    colorHex: "#FFD700")
        }
    }

    private func statCard(value: String, label: String, icon: String, colorHex: String) -> some View {
        let accent = Color(hex: colorHex)
        return VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(accent)
            Text(value)
                .font(.system(size: 22, weight: .black))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(accent.opacity(0.15), lineWidth: 1))
    }

    // MARK: - Trophies

    private var trophySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel(title: "TROPHIES", icon: "trophy.fill", colorHex: "#FFD700")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(theirTrophies.prefix(8)) { trophy in
                        let color: Color = {
                            switch trophy.rarity {
                            case .common:    return .white
                            case .rare:      return Color(hex: "#3AB5E6")
                            case .legendary: return .orange
                            }
                        }()
                        VStack(spacing: 6) {
                            ZStack {
                                Circle()
                                    .fill(color.opacity(0.12))
                                    .frame(width: 52, height: 52)
                                Image(systemName: trophy.icon)
                                    .font(.system(size: 20))
                                    .foregroundStyle(color)
                            }
                            Text(trophy.name)
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .frame(width: 58)
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Recent Activity

    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel(title: "RECENT SESSIONS", icon: "bolt.fill", colorHex: "#CCFF40")
            VStack(spacing: 0) {
                ForEach(Array(recentSessions.enumerated()), id: \.offset) { i, session in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.orange.opacity(session.isActive ? 1 : 0.35))
                            .frame(width: 8, height: 8)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(session.spotName)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                            Text(session.activity.isEmpty ? "Session" : session.activity)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(session.startedAt.skRelative)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 10)
                    if i < recentSessions.count - 1 {
                        Divider().background(Color.white.opacity(0.06))
                    }
                }
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - No Data

    private var noDataCard: some View {
        VStack(spacing: 10) {
            Image(systemName: "antenna.radiowaves.left.and.right.slash")
                .font(.system(size: 28))
                .foregroundStyle(.secondary)
            Text("Activity syncs when \(username) is nearby or sessions overlap.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Helpers

    private func sectionLabel(title: String, icon: String, colorHex: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(Color(hex: colorHex))
            Text(title)
                .font(.system(size: 10, weight: .black))
                .tracking(1.0)
                .foregroundStyle(Color(hex: colorHex).opacity(0.85))
        }
    }
}
