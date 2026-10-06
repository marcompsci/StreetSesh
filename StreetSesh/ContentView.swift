import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [AppUser]

    @State private var moderationStatus: ModerationStatus = .clear

    private var currentUser: AppUser? { users.first }

    var body: some View {
        Group {
            if users.isEmpty {
                OnboardingView()
            } else if moderationStatus.isBanned || moderationStatus.isSuspended {
                SuspendedView(status: moderationStatus) {
                    // Sign out: delete local user so onboarding is shown
                    if let user = currentUser { modelContext.delete(user) }
                    try? modelContext.save()
                }
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
            // Request push notification permission once user is onboarded
            if currentUser != nil {
                await NotificationService.shared.requestPermission()
                NotificationService.shared.scheduleDailyChallenge()
            }

            // Check moderation status for existing user
            if let user = currentUser {
                let status = await ModerationService.shared.fetchModerationStatus(username: user.username)
                moderationStatus = status
                user.isSuspended = status.isSuspended
                user.isBanned = status.isBanned
                user.banReason = status.reason
                try? modelContext.save()
            }

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
