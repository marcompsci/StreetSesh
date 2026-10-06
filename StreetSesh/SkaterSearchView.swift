import SwiftUI
import SwiftData

struct SkaterSearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [AppUser]
    @Query private var crews: [Crew]

    @State private var searchQuery    = ""
    @State private var results:       [AppUserDTO] = []
    @State private var isSearching    = false
    @State private var hasSearched    = false
    @State private var reportTarget:  String? = nil
    @State private var showReport     = false
    @State private var addedMembers:  Set<String> = []

    private var currentUser: AppUser? { users.first }
    private var myCrew: Crew? {
        guard let u = currentUser else { return nil }
        return crews.first { $0.ownerUsername == u.username }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    searchBar
                    Divider().background(Color.white.opacity(0.08))
                    resultArea
                }
            }
            .navigationTitle("Find Skaters")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
            }
            .confirmationDialog(
                "Report \(reportTarget ?? "this skater")?",
                isPresented: $showReport,
                titleVisibility: .visible
            ) {
                Button("Harassment or hate speech")   { submitReport("Harassment or hate speech") }
                Button("Inappropriate content")       { submitReport("Inappropriate content") }
                Button("Spam or fake account")        { submitReport("Spam or fake account") }
                Button("Cancel", role: .cancel)       { reportTarget = nil }
            }
        }
    }

    // MARK: - Search bar

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search by username…", text: $searchQuery)
                .foregroundStyle(.white)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
                .onSubmit { performSearch() }
            if !searchQuery.isEmpty {
                Button { searchQuery = ""; results = []; hasSearched = false } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Results

    @ViewBuilder
    private var resultArea: some View {
        if isSearching {
            Spacer()
            ProgressView().tint(.orange)
            Spacer()
        } else if hasSearched && results.isEmpty {
            Spacer()
            VStack(spacing: 12) {
                Image(systemName: "person.slash").font(.system(size: 40)).foregroundStyle(.secondary)
                Text("No skaters found for \"\(searchQuery)\"")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
        } else if !hasSearched {
            Spacer()
            VStack(spacing: 12) {
                Image(systemName: "magnifyingglass").font(.system(size: 40)).foregroundStyle(.secondary)
                Text("Search for skaters by username")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
        } else {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(results, id: \.username) { skater in
                        skaterRow(skater)
                        Divider().background(Color.white.opacity(0.06)).padding(.leading, 72)
                    }
                }
                .padding(.bottom, 32)
            }
        }
    }

    // MARK: - Skater row

    @ViewBuilder
    private func skaterRow(_ skater: AppUserDTO) -> some View {
        let isSelf = skater.username == currentUser?.username
        let alreadyInCrew = myCrew?.memberList.contains(skater.username) ?? false
        let justAdded = addedMembers.contains(skater.username)

        HStack(spacing: 14) {
            // Avatar initials
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(isSelf ? 0.5 : 0.85))
                    .frame(width: 48, height: 48)
                Text(String(skater.username.prefix(2)).uppercased())
                    .font(.system(size: 15, weight: .black))
                    .foregroundStyle(.black)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(skater.username)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    if isSelf {
                        Text("YOU")
                            .font(.system(size: 9, weight: .black))
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 5).padding(.vertical, 2)
                            .background(Color.orange.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
                Text(skater.city)
                    .font(.caption).foregroundStyle(.secondary)
                Text("\(skater.sessionCount) session\(skater.sessionCount == 1 ? "" : "s")")
                    .font(.caption2).foregroundStyle(.secondary.opacity(0.7))
            }

            Spacer()

            if !isSelf {
                HStack(spacing: 10) {
                    // Add to Crew
                    if myCrew != nil && !alreadyInCrew && !justAdded {
                        Button { addToCrew(skater.username) } label: {
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 16))
                                .foregroundStyle(.orange)
                                .frame(width: 36, height: 36)
                                .background(Color.orange.opacity(0.12))
                                .clipShape(Circle())
                        }
                    } else if alreadyInCrew || justAdded {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.orange.opacity(0.6))
                    }

                    // Report
                    Button {
                        reportTarget = skater.username
                        showReport = true
                    } label: {
                        Image(systemName: "flag")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.06))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Actions

    private func performSearch() {
        let q = searchQuery.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return }
        isSearching = true
        hasSearched = false
        Task {
            defer { isSearching = false; hasSearched = true }
            // Rate-limit: 1 search per second
            guard await RateLimiter.shared.allow(endpoint: .userSearch) else { return }
            results = (try? await SupabaseService.shared.searchUsers(query: q)) ?? []
        }
    }

    private func addToCrew(_ username: String) {
        guard let crew = myCrew, !crew.memberList.contains(username) else { return }
        var list = crew.memberList
        list.append(username)
        crew.memberList = list
        addedMembers.insert(username)
        try? modelContext.save()

        // In-app notification
        let notif = NotificationItem(
            kind: "crew",
            title: "Crew updated",
            body: "\(username) was added to \(crew.name).",
            targetID: username
        )
        modelContext.insert(notif)
        try? modelContext.save()
    }

    private func submitReport(_ reason: String) {
        guard let target = reportTarget, let reporter = currentUser?.username else { return }
        Task { await ModerationService.shared.reportContent(
            reporter: reporter,
            targetUsername: target,
            content: "User profile",
            reason: reason
        ) }
        reportTarget = nil
    }
}
