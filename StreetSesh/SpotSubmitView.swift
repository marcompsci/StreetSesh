import SwiftUI
import SwiftData
import CoreLocation

struct SpotSubmitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [AppUser]
    @State private var locationManager = LocationManager()

    @State private var name = ""
    @State private var obstacleInput = ""
    @State private var obstacles: [String] = []
    @State private var visibility: VisibilityTier = .public
    @State private var bustStatus: BustStatus = .green
    @State private var fameTier: FameTier = .local
    @State private var bestTime = "Anytime"
    @State private var showEthicsGate = true
    @State private var showViolationAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                if showEthicsGate {
                    ethicsView.transition(.opacity)
                } else {
                    formView.transition(.opacity)
                }
            }
            .navigationTitle("Add a Spot")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.white)
                }
            }
        }
        .onAppear {
            locationManager.requestAuthorization()
        }
        .alert("Content Blocked", isPresented: $showViolationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your spot submission was flagged. Please use appropriate names.")
        }
    }

    // Non-skippable respect acknowledgment before the form is revealed
    private var ethicsView: some View {
        VStack(spacing: 28) {
            Spacer()
            Image(systemName: "hand.raised.fill")
                .font(.system(size: 52))
                .foregroundStyle(.orange)
            Text("Respect the Spot")
                .font(.title.bold())
                .foregroundStyle(.white)
            VStack(alignment: .leading, spacing: 14) {
                ruleRow(icon: "trash.slash.fill",       text: "Leave no trace. Pack out what you bring.")
                ruleRow(icon: "speaker.slash.fill",     text: "Keep it quiet. Don't blow up the spot.")
                ruleRow(icon: "person.fill.checkmark",  text: "Be respectful to locals and property owners.")
                ruleRow(icon: "eye.slash.fill",         text: "You control visibility. Share responsibly.")
            }
            .padding()
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            Spacer()
            Button {
                withAnimation { showEthicsGate = false }
            } label: {
                Text("Got it — let's add the spot")
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Color.orange)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding()
    }

    @ViewBuilder
    private func ruleRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).foregroundStyle(.orange).frame(width: 24)
            Text(text).font(.subheadline).foregroundStyle(.white)
        }
    }

    private var formView: some View {
        Form {
            Section("SPOT NAME") {
                TextField("e.g. Pier 7, Wallenberg…", text: $name)
            }

            Section("OBSTACLES") {
                HStack {
                    TextField("Add obstacle…", text: $obstacleInput)
                    Button("Add") {
                        let trimmed = obstacleInput.trimmingCharacters(in: .whitespaces)
                        guard !trimmed.isEmpty else { return }
                        obstacles.append(trimmed)
                        obstacleInput = ""
                    }
                    .foregroundStyle(.orange)
                    .disabled(obstacleInput.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                ForEach(obstacles, id: \.self) { ob in Text(ob) }
                    .onDelete { obstacles.remove(atOffsets: $0) }
            }

            Section("VISIBILITY") {
                Picker("Visibility", selection: $visibility) {
                    ForEach(VisibilityTier.allCases, id: \.self) { Text($0.label).tag($0) }
                }
                .tint(.orange)
            }

            Section("BUST STATUS") {
                Picker("Bust level", selection: $bustStatus) {
                    ForEach(BustStatus.allCases, id: \.self) { Text($0.label).tag($0) }
                }
                .tint(.orange)
            }

            Section("FAME TIER") {
                Picker("Fame tier", selection: $fameTier) {
                    ForEach(FameTier.allCases, id: \.self) { Text($0.label).tag($0) }
                }
                .tint(.orange)
            }

            Section("BEST TIME") {
                TextField("e.g. Weekday mornings", text: $bestTime)
            }

            Section {
                Button("Add Spot") { submitSpot() }
                    .fontWeight(.bold)
                    .foregroundStyle(name.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.orange)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .scrollContentBackground(.hidden)
    }

    private func submitSpot() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        let username = users.first?.username ?? "skater"
        Task {
            let textToScan = ([trimmedName] + obstacles).joined(separator: " ")
            let ok = await ModerationService.shared.validateAndSubmit(text: textToScan, username: username)
            guard ok else { showViolationAlert = true; return }

            let lat = locationManager.location?.coordinate.latitude  ?? 37.7749
            let lng = locationManager.location?.coordinate.longitude ?? -122.4194

            let spot = Spot(
                name: trimmedName,
                latitude: lat,
                longitude: lng,
                obstacles: obstacles,
                visibility: visibility,
                bustStatus: bustStatus,
                fameTier: fameTier,
                bestTimeOfDay: bestTime
            )
            modelContext.insert(spot)
            Task { try? await SupabaseService.shared.pushSpot(spot) }
            dismiss()
        }
    }
}
