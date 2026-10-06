import SwiftUI

// Shown instead of the normal app when a device integrity check fails.
// This is a terminal screen — there is no dismiss or bypass path.

struct AppSecurityGateView: View {
    enum Reason {
        case jailbreak
        case screenRecording

        var title: String {
            switch self {
            case .jailbreak:       return "Device Not Supported"
            case .screenRecording: return "Screen Recording Detected"
            }
        }

        var body: String {
            switch self {
            case .jailbreak:
                return "StreetSesh cannot run on a modified device. This protects the privacy and safety of the entire community."
            case .screenRecording:
                return "Screen recording is active. Please stop recording before using StreetSesh to protect other users' data."
            }
        }

        var icon: String {
            switch self {
            case .jailbreak:       return "lock.trianglebadge.exclamationmark.fill"
            case .screenRecording: return "record.circle.fill"
            }
        }
    }

    let reason: Reason

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 28) {
                Spacer()

                Image(systemName: reason.icon)
                    .font(.system(size: 64))
                    .foregroundStyle(.red)

                VStack(spacing: 12) {
                    Text(reason.title)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text(reason.body)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                if reason == .screenRecording {
                    Text("The app will resume automatically once recording stops.")
                        .font(.caption)
                        .foregroundStyle(.secondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer()

                Text("StreetSesh · Community Safety")
                    .font(.caption2)
                    .foregroundStyle(.secondary.opacity(0.4))
                    .padding(.bottom, 32)
            }
        }
    }
}
