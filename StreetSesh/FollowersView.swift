import SwiftUI
import SwiftData

struct FollowersView: View {
    let username: String

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss)      private var dismiss
    @Query private var users:   [AppUser]
    @Query private var follows: [FollowRelation]

    @State private var tab: Tab
    @State private var profileTarget: String? = nil
    @State private var showProfile = false

    init(username: String, initialTab: Tab = .followers) {
        self.username = username
        _tab = State(initialValue: initialTab)
    }

    enum Tab: String, CaseIterable {
        case followers = "Followers"
        case following = "Following"
    }

    private var currentUser: AppUser? { users.first }

    private var followerNames: [String] {
        FollowEngine.followerUsernames(for: username, in: follows)
    }

    private var followingNames: [String] {
        FollowEngine.followingUsernames(for: username, in: follows)
    }

    private var displayed: [String] {
        tab == .followers ? followerNames : followingNames
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    tabPicker
                    Divider().background(Color.white.opacity(0.08))
                    if displayed.isEmpty {
                        emptyState
                    } else {
                        userList
                    }
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
            .sheet(isPresented: $showProfile) {
                if let target = profileTarget {
                    SkaterProfileView(username: target)
                        .presentationBackground(Color.black)
                }
            }
        }
    }

    // MARK: - Tab picker

    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { t in
                let count = t == .followers ? followerNames.count : followingNames.count
                Button { withAnimation(.easeInOut(duration: 0.15)) { tab = t } } label: {
                    VStack(spacing: 4) {
                        Text("\(count)")
                            .font(.system(size: 20, weight: .black))
                            .foregroundStyle(tab == t ? .orange : .white)
                        Text(t.rawValue)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(tab == t ? .orange : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                }
                .buttonStyle(.plain)
            }
        }
        .overlay(alignment: .bottom) {
            GeometryReader { geo in
                let w = geo.size.width / 2
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: w, height: 2)
                    .offset(x: tab == .followers ? 0 : w)
                    .animation(.easeInOut(duration: 0.15), value: tab)
            }
            .frame(height: 2)
        }
    }

    // MARK: - List

    private var userList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(displayed, id: \.self) { uname in
                    userRow(uname)
                    Divider()
                        .background(Color.white.opacity(0.06))
                        .padding(.leading, 72)
                }
            }
            .padding(.bottom, 32)
        }
    }

    @ViewBuilder
    private func userRow(_ uname: String) -> some View {
        let isSelf = uname == currentUser?.username
        let amFollowing = currentUser.map {
            FollowEngine.isFollowing(follower: $0.username, target: uname, in: follows)
        } ?? false

        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(isSelf ? 0.5 : 0.85))
                    .frame(width: 48, height: 48)
                Text(String(uname.prefix(2)).uppercased())
                    .font(.system(size: 15, weight: .black))
                    .foregroundStyle(.black)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(uname)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                if isSelf {
                    Text("You")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
            }

            Spacer()

            if !isSelf, let me = currentUser {
                Button {
                    if amFollowing {
                        FollowEngine.unfollow(
                            follower: me.username, target: uname,
                            context: modelContext, existing: follows
                        )
                    } else {
                        FollowEngine.follow(
                            follower: me.username, target: uname,
                            context: modelContext, existing: follows
                        )
                    }
                } label: {
                    Text(amFollowing ? "Following" : "Follow")
                        .font(.caption.weight(.black))
                        .padding(.horizontal, 14).padding(.vertical, 7)
                        .background(amFollowing ? Color.white.opacity(0.10) : Color.orange)
                        .foregroundStyle(amFollowing ? .white : .black)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture {
            if !isSelf {
                profileTarget = uname
                showProfile = true
            }
        }
    }

    // MARK: - Empty state

    @ViewBuilder
    private var emptyState: some View {
        Spacer()
        VStack(spacing: 12) {
            Image(systemName: tab == .followers ? "person.2" : "person.badge.plus")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text(tab == .followers
                 ? "No followers yet."
                 : "Not following anyone yet.\nFind skaters to follow.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        Spacer()
    }
}
