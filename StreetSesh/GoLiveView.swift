import SwiftUI
import SwiftData

struct GoLiveView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var spots: [Spot]
    @Query private var users: [AppUser]
    @Query private var allSessions: [LiveSession]
    @Query private var allCheckIns: [SpotCheckIn]
    @Query private var allTrophies: [Trophy]

    @State private var selectedSpotName = ""
    @State private var activity = "Skating"
    @State private var visibility: SessionVisibility = .locals
    @State private var showSpotPicker = false

    private let activities = ["Skating", "Filming", "Chilling", "Sessioning"]

    var currentUser: AppUser? { users.first }
    var isUnder18: Bool { currentUser?.isUnder18 ?? false }
    var availableVisibilities: [SessionVisibility] {
        isUnder18 ? [.crew, .locals] : SessionVisibility.allCases
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // Spot
                        sectionLabel("WHERE ARE YOU?")
                        Button { showSpotPicker = true } label: {
                            HStack {
                                Text(selectedSpotName.isEmpty ? "Pick a spot…" : selectedSpotName)
                                    .foregroundStyle(selectedSpotName.isEmpty ? Color.gray : Color.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        // Activity
                        sectionLabel("WHAT ARE YOU DOING?")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(activities, id: \.self) { act in
                                    Button { activity = act } label: {
                                        Text(act)
                                            .font(.subheadline.weight(.semibold))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 9)
                                            .background(activity == act ? Color.orange : Color.white.opacity(0.08))
                                            .foregroundStyle(activity == act ? .black : .white)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }

                        // Visibility
                        sectionLabel("WHO CAN SEE YOU?")
                        VStack(spacing: 8) {
                            ForEach(availableVisibilities, id: \.self) { tier in
                                Button { visibility = tier } label: {
                                    visibilityRow(tier)
                                }
                            }
                        }

                        Spacer(minLength: 24)

                        Button { goLive() } label: {
                            HStack {
                                Image(systemName: "antenna.radiowaves.left.and.right")
                                Text("GO LIVE").fontWeight(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(selectedSpotName.isEmpty ? Color.gray.opacity(0.3) : Color.orange)
                            .foregroundStyle(selectedSpotName.isEmpty ? Color.gray : Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .disabled(selectedSpotName.isEmpty)
                    }
                    .padding()
                }
            }
            .navigationTitle("Go Live")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.white)
                }
            }
            .sheet(isPresented: $showSpotPicker) {
                SpotPickerView(selectedSpotName: $selectedSpotName)
                    .presentationBackground(Color.black)
            }
        }
    }

    @ViewBuilder
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .black))
            .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private func visibilityRow(_ tier: SessionVisibility) -> some View {
        let active = visibility == tier
        HStack(spacing: 12) {
            Image(systemName: tier.icon)
                .frame(width: 22)
                .foregroundStyle(active ? Color.orange : Color.gray)
            Text(tier.label)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.white)
            Spacer()
            if active {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color.orange)
            }
        }
        .padding()
        .background(active ? Color.orange.opacity(0.12) : Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(active ? Color.orange.opacity(0.4) : Color.clear, lineWidth: 1)
        )
    }

    private func goLive() {
        guard !selectedSpotName.isEmpty,
              let spot = spots.first(where: { $0.name == selectedSpotName }),
              let user = currentUser else { return }

        // Deactivate any previous current-user session
        allSessions.filter { $0.isCurrentUser }.forEach { $0.isActive = false }

        let session = LiveSession(
            username: user.username,
            spotName: spot.name,
            latitude: spot.latitude,
            longitude: spot.longitude,
            visibility: visibility,
            activity: activity,
            isCurrentUser: true
        )
        modelContext.insert(session)
        user.sessionCount += 1

        let checkIn = SpotCheckIn(username: user.username, spotName: spot.name, fameTier: spot.fameTier)
        modelContext.insert(checkIn)
        let newTrophies = TrophyEngine.checkAndAward(
            username: user.username,
            newCheckIn: checkIn,
            allCheckIns: allCheckIns + [checkIn],
            existingTrophies: allTrophies,
            context: modelContext
        )

        Task {
            try? await SupabaseService.shared.deactivateSessions(for: user.username)
            try? await SupabaseService.shared.pushLiveSession(session)
            try? await SupabaseService.shared.pushCheckIn(checkIn)
            for trophy in newTrophies {
                try? await SupabaseService.shared.pushTrophy(trophy)
            }
        }

        dismiss()
    }
}

struct SpotPickerView: View {
    @Binding var selectedSpotName: String
    @Query private var spots: [Spot]
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    var filtered: [Spot] {
        let active = spots.filter { !$0.isRetired }.sorted { $0.name < $1.name }
        guard !searchText.isEmpty else { return active }
        return active.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                List(filtered) { spot in
                    Button {
                        selectedSpotName = spot.name
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(spot.name)
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                Text(spot.obstacles.joined(separator: " · "))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Circle()
                                .fill(spot.bustStatus == .green ? Color.green :
                                      spot.bustStatus == .yellow ? Color.yellow : Color.red)
                                .frame(width: 9, height: 9)
                        }
                    }
                    .listRowBackground(Color.black)
                    .listRowSeparatorTint(Color.white.opacity(0.08))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .searchable(text: $searchText, prompt: "Search spots")
            .navigationTitle("Pick a Spot")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.white)
                }
            }
        }
    }
}
