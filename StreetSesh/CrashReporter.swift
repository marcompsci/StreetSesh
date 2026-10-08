import Foundation

// MARK: - CrashReporter
//
// Crash reporting wrapper — currently a no-op stub.
//
// To activate Sentry:
//   1. Xcode → File → Add Package Dependencies
//      URL: https://github.com/getsentry/sentry-cocoa  (~> 8.0)
//   2. Replace the stub body below with the live Sentry implementation (commented out inline).
//   3. Add your DSN from sentry.io → Settings → Projects → Client Keys.

final class CrashReporter {
    static let shared = CrashReporter()
    private init() {}

    func configure() {
        // Uncomment after adding Sentry SDK package:
        //
        // SentrySDK.start { options in
        //     options.dsn = "https://<key>@o<org>.ingest.sentry.io/<project>"
        //     options.tracesSampleRate = 0.2
        //     options.profilesSampleRate = 0.1
        //     options.enableAutoSessionTracking = true
        //     options.environment = ProcessInfo.processInfo.environment["APP_ENV"] ?? "production"
        // }
    }

    func setUser(username: String) {
        // let user = Sentry.User()
        // user.username = username
        // SentrySDK.setUser(user)
    }

    func captureError(_ error: Error, context: String? = nil) {
        // SentrySDK.capture(error: error)
        #if DEBUG
        print("[CrashReporter] \(context.map { "\($0): " } ?? "")\(error)")
        #endif
    }

    func breadcrumb(_ message: String, category: String = "app") {
        // let crumb = Breadcrumb()
        // crumb.category = category
        // crumb.message = message
        // SentrySDK.addBreadcrumb(crumb)
    }
}
