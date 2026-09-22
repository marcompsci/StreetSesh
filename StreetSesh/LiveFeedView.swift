import SwiftUI
import SwiftData

struct LiveFeedView: View {
    @Query private var liveSessions: [LiveSession]
    @State private var showGoLive = false

    var activeSessions: [LiveSession] {
        liveSessions
            .filter { $0.isActive && !$0.isExpired }
            .sorted { $0.startedAt > $1.startedAt }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    goLiveBanner
                    if activeSessions.isEmpty {
                        emptyState
                    } else {
                        List(activeSessions) { session in
                            LiveSessionRow(session: session)
                                .listRowBackground(Color.clear)
                                .listRowSeparatorTint(Color.white.opacity(0.08))
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Out Right Now")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
        }
        .sheet(isPresented: $showGoLive) {
            GoLiveView()
                .presentationBackground(Color.black)
        }
    }

    private var goLiveBanner: some View {
        Button { showGoLive = true } label: {
            HStack(spacing: 10) {
                Circle().fill(Color.orange).frame(width: 8, height: 8)
                Text("GO LIVE").font(.headline.weight(.black))
                Spacer()
                Image(systemName: "chevron.right").font(.caption.weight(.bold))
            }
            .padding()
            .foregroundStyle(.orange)
            .background(Color.orange.opacity(0.10))
            .overlay(
                Rectangle().frame(height: 1).foregroundStyle(Color.orange.opacity(0.2)),
                alignment: .bottom
            )
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 52))
                .foregroundStyle(.orange.opacity(0.4))
            Text("Nobody's out right now.")
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text("Be the first.\nTap Go Live and show up on the map.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding()
    }
}

struct LiveSessionRow: View {
    let session: LiveSession
    @State private var showJoinAlert = false

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(Color.orange).frame(width: 44, height: 44)
                Text(String(session.username.prefix(2)).uppercased())
                    .font(.system(size: 14, weight: .black))
                    .foregroundStyle(.black)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(session.username)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                Text(session.spotName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(session.activity) · \(session.timeActive)")
                    .font(.caption2)
                    .foregroundStyle(.orange)
            }

            Spacer()

            if session.isCurrentUser {
                Text("YOU")
                    .font(.caption.weight(.black))
                    .foregroundStyle(.orange)
            } else {
                Button { showJoinAlert = true } label: {
                    Text("Join")
                        .font(.caption.weight(.bold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.orange.opacity(0.12))
                        .foregroundStyle(.orange)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.orange.opacity(0.3), lineWidth: 1))
                }
            }
        }
        .padding(.vertical, 6)
        .alert("On my way!", isPresented: $showJoinAlert) {
            Button("Got it") {}
        } message: {
            Text("\(session.username) will see you're heading to \(session.spotName).")
        }
    }
}
