import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [AppUser]

    @State private var moderationStatus: ModerationStatus = .clear
    @State private var securityGateReason: AppSecurityGateView.Reason? = nil

    private var currentUser: AppUser? { users.first }

    var body: some View {
        Group {
            if let reason = securityGateReason {
                // Terminal security screen — no bypass
                AppSecurityGateView(reason: reason)
            } else if users.isEmpty {
                OnboardingView()
            } else if moderationStatus.isBanned || moderationStatus.isSuspended {
                SuspendedView(status: moderationStatus) {
                    if let user = currentUser { modelContext.delete(user) }
                    try? modelContext.save()
                }
            } else {
                SkateCityView()
            }
        }
        .onAppear {
            // Device integrity check — runs synchronously before anything else
            if SecurityService.shared.isDeviceCompromised() {
                securityGateReason = .jailbreak
                return
            }
            if SecurityService.shared.isScreenBeingRecorded() {
                securityGateReason = .screenRecording
            }

            // Watch for screen recording starting mid-session
            SecurityService.shared.observeScreenCapture { isCapturing in
                securityGateReason = isCapturing ? .screenRecording : nil
            }

            SampleData.seed(into: modelContext)
            SampleData.seedFresnoSpots(into: modelContext)
            SampleData.seedHuntScores(into: modelContext)
            SampleData.seedCheckIns(into: modelContext)
            SampleData.seedClips(into: modelContext)
            SampleData.seedBustVotes(into: modelContext)
        }
        .task {
            guard securityGateReason == nil else { return }

            if currentUser != nil {
                await NotificationService.shared.requestPermission()
                NotificationService.shared.scheduleDailyChallenge()
                NotificationService.shared.scheduleStreakReminder()
                NotificationService.shared.scheduleWeeklySummary()
            }

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
