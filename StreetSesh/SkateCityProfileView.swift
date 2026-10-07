import SwiftUI
import SwiftData

struct SkateCityProfileView: View {
    @EnvironmentObject private var state: SkateCityAppState
    @Query private var users:   [AppUser]
    @Query private var follows: [FollowRelation]

    @State private var showSettings      = false
    @State private var showCustomize     = false
    @State private var showFollowers     = false
    @State private var followersInitTab  = FollowersView.Tab.followers

    private var currentUsername: String { users.first?.username ?? state.profile.displayName }

    private var followerCount: Int {
        FollowEngine.followerUsernames(for: currentUsername, in: follows).count
    }

    private var followingCount: Int {
        FollowEngine.followingUsernames(for: currentUsername, in: follows).count
    }

    private let badges: [SKProfileBadge] = [
        SKProfileBadge(id: "first",    name: "First Sesh",     icon: "flag.fill",       hex: "#CCFF40"),
        SKProfileBadge(id: "grinder",  name: "Grinder",        icon: "skateboard",      hex: "#FF5A35"),
        SKProfileBadge(id: "explorer", name: "Explorer",       icon: "map.fill",         hex: "#3AB5E6"),
        SKProfileBadge(id: "crew",     name: "Crew Life",      icon: "person.3.fill",   hex: "#C77DFF"),
        SKProfileBadge(id: "daily",    name: "Daily Dose",     icon: "calendar",        hex: "#F1C40F"),
        SKProfileBadge(id: "local",    name: "Local Legend",   icon: "star.fill",       hex: "#FF9F40")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skDark.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        profileHero
                        statsRow
                        followStatsRow
                        badgesSection
                        settingsSection
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
        .sheet(isPresented: $showCustomize) {
            SkateCityCustomizeSheet()
                .environmentObject(state)
                .presentationDetents([.large])
                .presentationBackground(Color.skDark)
        }
        .sheet(isPresented: $showSettings) {
            SKSettingsSheet()
                .environmentObject(state)
                .presentationDetents([.large])
                .presentationBackground(Color.skDark)
        }
        .sheet(isPresented: $showFollowers) {
            FollowersView(username: currentUsername, initialTab: followersInitTab)
                .presentationBackground(Color.black)
        }
    }

    // MARK: - Hero

    private var profileHero: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: state.profile.homeTheme.wallGradient,
                startPoint: .top, endPoint: .bottom
            )
            .frame(height: 110)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            // Name row
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(state.profile.displayName)
                        .font(.system(size: 22, weight: .black))
                        .foregroundStyle(.skText)
                    Text(state.profile.handle)
                        .font(.subheadline)
                        .foregroundStyle(.skSub)
                    Label(state.profile.city, systemImage: "location.fill")
                        .font(.caption)
                        .foregroundStyle(.skSub)
                }
                Spacer()
                Button { showCustomize = true } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.skLime)
                }
            }
            .padding(.top, 12)
        }
    }

    // MARK: - Stats

    private var statsRow: some View {
        HStack(spacing: 0) {
            statCell(label: "Level", value: "\(state.profile.level)")
            Divider().background(Color.skBorder).frame(height: 40)
            statCell(label: "XP", value: "\(state.profile.xp)")
            Divider().background(Color.skBorder).frame(height: 40)
            statCell(label: "Saved", value: "\(state.savedSpotIDs.count)")
            Divider().background(Color.skBorder).frame(height: 40)
            statCell(label: "Clips", value: "\(state.clips.filter { $0.creatorHandle == state.profile.handle }.count)")
        }
        .skBorderCard(padding: 14)
    }

    private func statCell(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .black))
                .foregroundStyle(.skText)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.skSub)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Follow Stats

    private var followStatsRow: some View {
        HStack(spacing: 0) {
            Button {
                followersInitTab = .followers
                showFollowers = true
            } label: {
                followStatCell(label: "Followers", value: "\(followerCount)")
            }
            .buttonStyle(.plain)

            Divider().background(Color.skBorder).frame(height: 40)

            Button {
                followersInitTab = .following
                showFollowers = true
            } label: {
                followStatCell(label: "Following", value: "\(followingCount)")
            }
            .buttonStyle(.plain)
        }
        .skBorderCard(padding: 14)
    }

    private func followStatCell(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .black))
                .foregroundStyle(.skLime)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.skSub)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Board Locker

    private var boardLockerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SKSectionHeader(title: "BOARD LOCKER") { showCustomize = true }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(SKMockData.boards) { board in
                        boardCard(board)
                    }
                }
                .padding(.horizontal, 1)
            }
        }
        .skCard()
    }

    private func boardCard(_ board: SKBoard) -> some View {
        let selected = state.profile.selectedBoard == board.id
        return Button {
            state.profile.selectedBoard = board.id
        } label: {
            VStack(spacing: 10) {
                SKBoardMini(accentHex: board.accentHex, width: 28, height: 70)
                Text(board.name)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(selected ? Color(hex: board.accentHex) : .skSub)
                    .lineLimit(1)
                Text(board.tagline)
                    .font(.system(size: 9))
                    .foregroundStyle(.skSub)
                    .lineLimit(1)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 10)
            .frame(width: 110)
            .background(Color.skMuted)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(selected ? Color(hex: board.accentHex) : Color.clear, lineWidth: 2)
            )
        }
    }

    // MARK: - Badges

    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SKSectionHeader(title: "BADGES")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 12) {
                ForEach(badges) { badge in
                    badgeCell(badge)
                }
            }
        }
        .skCard()
    }

    private func badgeCell(_ badge: SKProfileBadge) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color(hex: badge.hex).opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: badge.icon)
                    .font(.title3)
                    .foregroundStyle(Color(hex: badge.hex))
            }
            Text(badge.name)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.skText)
                .lineLimit(1)
        }
    }

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            SKSectionHeader(title: "ACCOUNT")
                .padding(.bottom, 10)
            VStack(spacing: 0) {
                settingsRow(icon: "lock.fill", label: "Privacy Settings") { showSettings = true }
                Divider().background(Color.skBorder)
                settingsRow(icon: "paintbrush.fill", label: "Customize Profile") { showCustomize = true }
                Divider().background(Color.skBorder)
                settingsRow(icon: "info.circle.fill", label: "About StreetSesh") { }
            }
            .background(Color.skMuted)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .skCard()
    }

    private func settingsRow(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(.skLime)
                    .frame(width: 22)
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.skText)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.skSub)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
        }
    }
}

// MARK: - Badge Model

private struct SKProfileBadge: Identifiable {
    let id: String
    let name: String
    let icon: String
    let hex: String
}

// MARK: - Settings Sheet

struct SKSettingsSheet: View {
    @EnvironmentObject private var state: SkateCityAppState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skDark.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 20) {
                    Text("Your data and location are never shared without your control.")
                        .font(.subheadline)
                        .foregroundStyle(Color.skSub)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("PROFILE VISIBILITY").font(.system(size: 10, weight: .black)).foregroundStyle(Color.skSub)
                        Picker("Visibility", selection: Binding(
                            get: { state.profile.privacySettings.profileVisibility },
                            set: { state.profile.privacySettings.profileVisibility = $0 }
                        )) {
                            Text("Public").tag("Public")
                            Text("Friends").tag("Friends")
                            Text("Private").tag("Private")
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("DISCOVERABILITY").font(.system(size: 10, weight: .black)).foregroundStyle(Color.skSub)
                        Picker("Discoverability", selection: Binding(
                            get: { state.profile.privacySettings.discoverability },
                            set: { state.profile.privacySettings.discoverability = $0 }
                        )) {
                            Text("Everyone").tag("Everyone")
                            Text("Friends").tag("Friends")
                            Text("No one").tag("No one")
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("DATA POLICY").font(.system(size: 10, weight: .black)).foregroundStyle(Color.skSub)
                        privacyNote("Location is used only while the app is open")
                        privacyNote("No coordinates are saved or shared")
                        privacyNote("You can delete your account at any time")
                    }

                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Privacy & Settings")
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(Color.skLime)
                }
            }
        }
    }

    private func privacyNote(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.skLime).font(.subheadline)
            Text(text).font(.caption).foregroundStyle(Color.skSub)
        }
    }
}
