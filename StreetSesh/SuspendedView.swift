import SwiftUI

struct SuspendedView: View {
    let status: ModerationStatus
    let onSignOut: () -> Void

    private var isPermanent: Bool { status.isBanned }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Icon
                ZStack {
                    Circle()
                        .fill(isPermanent ? Color.red.opacity(0.12) : Color.orange.opacity(0.12))
                        .frame(width: 100, height: 100)
                    Image(systemName: isPermanent ? "xmark.shield.fill" : "lock.shield.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(isPermanent ? .red : .orange)
                }
                .padding(.bottom, 28)

                // Title
                Text(isPermanent ? "Account Permanently Banned" : "Account Suspended")
                    .font(.system(size: 26, weight: .black))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 12)

                // Reason
                if !status.reason.isEmpty {
                    Text(status.reason)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 36)
                        .padding(.bottom, 16)
                }

                // Expiry or permanent notice
                if isPermanent {
                    permanentNotice
                } else {
                    suspensionNotice
                }

                Spacer()

                // Actions
                VStack(spacing: 12) {
                    if !isPermanent {
                        Link(destination: URL(string: "mailto:appeals@streetsesh.app?subject=Suspension%20Appeal")!) {
                            Text("Appeal Suspension")
                                .font(.headline.weight(.black))
                                .frame(maxWidth: .infinity).padding(18)
                                .background(Color.orange).foregroundStyle(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }

                    Button(action: onSignOut) {
                        Text("Sign Out")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity).padding(16)
                            .background(Color.white.opacity(0.08))
                            .foregroundStyle(.secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 52)
            }
        }
    }

    private var permanentNotice: some View {
        VStack(spacing: 8) {
            Text("This account has been permanently removed from StreetSesh.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
            Text("Creating a new account using the same email, phone, name, or device is not permitted.")
                .font(.caption)
                .foregroundStyle(Color.red.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
        }
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private var suspensionNotice: some View {
        if let expires = status.expiresAt {
            let formatter: RelativeDateTimeFormatter = {
                let f = RelativeDateTimeFormatter()
                f.unitsStyle = .full
                return f
            }()
            Text("Suspension lifts \(formatter.localizedString(for: expires, relativeTo: Date()))")
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
        } else {
            Text("Your account is under review by our moderation team.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
                .padding(.bottom, 8)
        }
    }
}
