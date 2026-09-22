import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [AppUser]
    @State private var selectedTab = 0

    var body: some View {
        Group {
            if users.isEmpty {
                OnboardingView()
            } else {
                TabView(selection: $selectedTab) {
                    MapContainerView()
                        .tabItem { Label("Map", systemImage: "map.fill") }
                        .tag(0)

                    LiveFeedView()
                        .tabItem { Label("Live", systemImage: "antenna.radiowaves.left.and.right") }
                        .tag(1)

                    SpotHuntView()
                        .tabItem { Label("Hunt", systemImage: "scope") }
                        .tag(2)

                    ProfileView()
                        .tabItem { Label("Profile", systemImage: "person.fill") }
                        .tag(3)
                }
                .tint(.orange)
            }
        }
        .onAppear {
            SampleData.seed(into: modelContext)
            SampleData.seedHuntScores(into: modelContext)
            SampleData.seedCheckIns(into: modelContext)
            SampleData.seedClips(into: modelContext)
            SampleData.seedBustVotes(into: modelContext)
        }
    }
}

