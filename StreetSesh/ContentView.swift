import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [AppUser]

    var body: some View {
        Group {
            if users.isEmpty {
                OnboardingView()
            } else {
                SkateCityView()
            }
        }
        .onAppear {
            SampleData.seed(into: modelContext)
            SampleData.seedFresnoSpots(into: modelContext)
            SampleData.seedHuntScores(into: modelContext)
            SampleData.seedCheckIns(into: modelContext)
            SampleData.seedClips(into: modelContext)
            SampleData.seedBustVotes(into: modelContext)
        }
        .task {
            do {
                try await SupabaseService.shared.syncSpots(into: modelContext)
                try await SupabaseService.shared.syncActiveSessions(into: modelContext)
                try await SupabaseService.shared.syncLeaderboard(into: modelContext)
            } catch {
                // Fall back to local sample data if Supabase is unreachable
            }
        }
    }
}
