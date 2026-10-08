import SwiftUI
import SwiftData

@main
struct StreetSeshApp: App {
    init() {
        CrashReporter.shared.configure()
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Spot.self,
            LiveSession.self,
            AppUser.self,
            HuntScore.self,
            Crew.self,
            SpotCheckIn.self,
            Trophy.self,
            SpotClip.self,
            BustVote.self,
            SpotPhotoReport.self,
            NotificationItem.self,
            SpotBookmark.self,
            FollowRelation.self,
            SessionNote.self,
            SpotCondition.self,
            PersonalTrick.self,
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
    }
}
