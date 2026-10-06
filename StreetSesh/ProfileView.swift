import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var users: [AppUser]
    @Query private var liveSessions: [LiveSession]
    @Query private var huntScores: [HuntScore]
    @Query private var trophies: [Trophy]
    @Query private var crews: [Crew]

    @State private var showEditProfile   = false
    @State private var showTrophyCase    = false
    @State private var showCrew          = false
    @State private var showSkaterSearch  = false
    @State private var showLeaderboard   = false

    var currentUser: AppUser? { users.first }

    var myActiveSession: LiveSession? {
        liveSessions.filter { $0.isCurrentUser && $0.isActive && !$0.isExpired }.first
    }

    var bestHuntScore: Int {
        huntScores.filter { $0.isCurrentUser }.map { $0.totalPoints }.max() ?? 0
    }

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

    var myTrophies: [Trophy] {
        guard let user = currentUser else { return [] }
        return trophies.filter { $0.username == user.username }.sorted { $0.earnedAt > $1.earnedAt }
    }

    var myCrew: Crew? {
        guard let user = currentUser else { return nil }
        return crews.first { $0.ownerUsername == user.username || $0.memberList.contains(user.username) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        if let user = currentUser {
                            headerSection(user)
                            statsSection(user)
                        }
                        if let session = myActiveSession {
                            activeSessionCard(session)
                        }
                        crewSection
                        findSkatersButton
                        leaderboardButton
                        if !myTrophies.isEmpty {
                            trophyPreview
                        }
                        aboutSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Edit") { showEditProfile = true }.foregroundStyle(.orange)
                }
            }
        }
        .sheet(isPresented: $showEditProfile) {
            if let user = currentUser {
                EditProfileView(user: user)
                    .presentationDetents([.medium])
                    .presentationBackground(Color.black)
            }
        }
        .sheet(isPresented: $showTrophyCase) {
            if let user = currentUser {
                TrophyCaseView(username: user.username)
                    .presentationBackground(Color.black)
            }
        }
        .sheet(isPresented: $showCrew) {
            CrewView()
                .presentationBackground(Color.black)
        }
        .sheet(isPresented: $showSkaterSearch) {
            SkaterSearchView()
                .presentationBackground(Color.black)
        }
        .sheet(isPresented: $showLeaderboard) {
            LeaderboardView()
                .presentationBackground(Color.skDark)
        }
    }

    // MARK: - Header

    @ViewBuilder
    private func headerSection(_ user: AppUser) -> some View {
        VStack(spacing: 12) {
            ZStack {
                Circle().fill(Color.orange).frame(width: 80, height: 80)
                Text(String(user.username.prefix(2)).uppercased())
                    .font(.system(size: 28, weight: .black))
                    .foregroundStyle(.black)
            }
            HStack(spacing: 8) {
                Text(user.username).font(.title2.bold()).foregroundStyle(.white)
                if let crew = myCrew {
                    Text("[\(crew.tag)]")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(.orange)
                }
            }
            Text(user.city).font(.subheadline).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    // MARK: - Stats

    @ViewBuilder
    private func statsSection(_ user: AppUser) -> some View {
        HStack(spacing: 0) {
            statCell(value: "\(user.sessionCount)", label: "Sessions")
            Divider().frame(height: 40).foregroundStyle(Color.white.opacity(0.15))
            statCell(value: huntStreak > 0 ? "\(huntStreak)d" : "—", label: "Streak")
            Divider().frame(height: 40).foregroundStyle(Color.white.opacity(0.15))
            Button { showTrophyCase = true } label: {
                statCell(value: "\(myTrophies.count)", label: "Trophies")
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    @ViewBuilder
    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.title2.bold()).foregroundStyle(.orange)
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }

    // MARK: - Active Session

    @ViewBuilder
    private func activeSessionCard(_ session: LiveSession) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Circle().fill(Color.orange).frame(width: 7, height: 7)
                    Text("LIVE NOW").font(.system(size: 10, weight: .black)).foregroundStyle(.orange)
                }
                Text(session.spotName).font(.headline).foregroundStyle(.white)
                Text("\(session.activity) · \(session.timeActive)")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.orange.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.orange.opacity(0.3), lineWidth: 1))
    }

    // MARK: - Crew Section

    private var crewSection: some View {
        Button { showCrew = true } label: {
            if let crew = myCrew {
                HStack(spacing: 14) {
                    ZStack {
                        Circle().fill(Color.orange).frame(width: 44, height: 44)
                        Text(crew.tag)
                            .font(.system(size: 12, weight: .black))
                            .foregroundStyle(.black)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(crew.name)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                        Text("\(crew.memberList.count) member\(crew.memberList.count == 1 ? "" : "s")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            } else {
                HStack(spacing: 14) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.orange.opacity(0.6))
                        .frame(width: 44)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Start a Crew")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                        Text("Share spot access with your crew.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orange.opacity(0.2), lineWidth: 1))
            }
        }
    }

    // MARK: - Trophy Preview

    private var trophyPreview: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("TROPHIES")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(.secondary)
                Spacer()
                Button { showTrophyCase = true } label: {
                    Text("See all →")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                }
            }

            HStack(spacing: 10) {
                ForEach(myTrophies.prefix(4)) { trophy in
                    trophyBadge(trophy)
                }
                if myTrophies.count > 4 {
                    Button { showTrophyCase = true } label: {
                        ZStack {
                            Circle().fill(Color.white.opacity(0.08)).frame(width: 52, height: 52)
                            Text("+\(myTrophies.count - 4)")
                                .font(.system(size: 13, weight: .black))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    @ViewBuilder
    private func trophyBadge(_ trophy: Trophy) -> some View {
        let color: Color = {
            switch trophy.rarity {
            case .common:    return .white
            case .rare:      return Color(red: 0.4, green: 0.6, blue: 1.0)
            case .legendary: return .orange
            }
        }()
        ZStack {
            Circle().fill(color.opacity(0.12)).frame(width: 52, height: 52)
            Image(systemName: trophy.icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
        }
    }

    // MARK: - Find Skaters

    private var findSkatersButton: some View {
        Button { showSkaterSearch = true } label: {
            HStack(spacing: 14) {
                Image(systemName: "person.2.wave.2.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.orange.opacity(0.8))
                    .frame(width: 44)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Find Skaters")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text("Search for skaters to add to your crew.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orange.opacity(0.2), lineWidth: 1))
        }
    }

    // MARK: - Leaderboard

    private var leaderboardButton: some View {
        Button { showLeaderboard = true } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#FFD700").opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color(hex: "#FFD700"))
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("Leaderboard")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text("See where you rank among all skaters.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#FFD700").opacity(0.2), lineWidth: 1))
        }
    }

    // MARK: - About

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ABOUT").font(.system(size: 10, weight: .black)).foregroundStyle(.secondary)
            Text("StreetSesh").font(.headline).foregroundStyle(.white)
            Text("The spot app skaters actually trust.")
                .font(.subheadline).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct EditProfileView: View {
    let user: AppUser
    @Environment(\.dismiss) private var dismiss
    @State private var username: String
    @State private var city: String

    init(user: AppUser) {
        self.user = user
        _username = State(initialValue: user.username)
        _city = State(initialValue: user.city)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                Form {
                    Section("USERNAME") {
                        TextField("Username", text: $username)
                            .autocorrectionDisabled()
                    }
                    Section("CITY") {
                        TextField("City", text: $city)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Edit Profile")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        user.username = username
                        user.city = city
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
                    .disabled(username.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
