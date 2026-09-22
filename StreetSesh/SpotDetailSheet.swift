import SwiftUI
import SwiftData

struct SpotDetailSheet: View {
    let spot: Spot
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openURL) private var openURL
    @Query private var allSessions: [LiveSession]
    @Query private var checkIns: [SpotCheckIn]
    @Query private var bustVotes: [BustVote]
    @Query private var clips: [SpotClip]
    @Query private var users: [AppUser]

    @State private var showAddClip = false

    private var currentUsername: String? { users.first?.username }

    var activeSessions: [LiveSession] {
        allSessions.filter { $0.spotName == spot.name && $0.isActive && !$0.isExpired }
    }

    var myVisitCount: Int {
        guard let me = currentUsername else { return 0 }
        return checkIns.filter { $0.username == me && $0.spotName == spot.name }.count
    }

    var uniqueVisitorCount: Int {
        Set(checkIns.filter { $0.spotName == spot.name }.map { $0.username }).count
    }

    var spotClips: [SpotClip] {
        clips.filter { $0.spotName == spot.name }.sorted { $0.addedAt > $1.addedAt }
    }

    var voteCounts: [BustStatus: Int] {
        BustVoteEngine.voteCounts(for: spot.name, in: bustVotes)
    }

    var myVote: BustStatus? {
        guard let me = currentUsername else { return nil }
        return bustVotes
            .filter { $0.spotName == spot.name && $0.username == me }
            .max { $0.votedAt < $1.votedAt }?
            .vote
    }

    var bustColor: Color {
        switch spot.bustStatus {
        case .green:  return .green
        case .yellow: return .yellow
        case .red:    return .red
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                bustRow
                if !spot.obstacles.isEmpty { obstaclesSection }
                if uniqueVisitorCount > 0 || myVisitCount > 0 { localsRow }
                if !activeSessions.isEmpty { liveSection }
                bustVoteSection
                clipsSection
            }
            .padding()
        }
        .sheet(isPresented: $showAddClip) {
            AddClipView(spotName: spot.name)
                .presentationDetents([.medium])
                .presentationBackground(Color.black)
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(spot.name)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                HStack(spacing: 5) {
                    Image(systemName: spot.visibility.icon).font(.caption2)
                    Text(spot.visibility.label).font(.caption)
                }
                .foregroundStyle(.secondary)
            }
            Spacer()
            Text(spot.fameTier.label.uppercased())
                .font(.system(size: 10, weight: .black))
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(Color.orange)
                .foregroundStyle(.black)
                .clipShape(Capsule())
        }
    }

    // MARK: - Bust Row

    private var bustRow: some View {
        HStack(spacing: 10) {
            Circle().fill(bustColor).frame(width: 10, height: 10)
            Text(spot.bustStatus.label)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
            if spot.bustIsStale {
                Text("· may be outdated")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Label(spot.bestTimeOfDay, systemImage: "clock")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Obstacles

    private var obstaclesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("OBSTACLES")
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(.secondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(spot.obstacles, id: \.self) { ob in
                        Text(ob)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(Color.white.opacity(0.1))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }

    // MARK: - Locals Row

    private var localsRow: some View {
        HStack(spacing: 16) {
            if uniqueVisitorCount > 0 {
                Label("\(uniqueVisitorCount) local\(uniqueVisitorCount == 1 ? "" : "s")", systemImage: "person.2.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if myVisitCount > 0 {
                Label("You've been here \(myVisitCount)×", systemImage: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
        }
    }

    // MARK: - Live

    private var liveSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Circle().fill(Color.orange).frame(width: 7, height: 7)
                Text("OUT RIGHT NOW")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(.orange)
            }
            ForEach(activeSessions) { session in
                LiveSessionRow(session: session)
            }
        }
    }

    // MARK: - Bust Vote

    private var bustVoteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RATE BUST STATUS")
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                bustVoteButton(.green, label: "All Clear")
                bustVoteButton(.yellow, label: "Watch Out")
                bustVoteButton(.red, label: "Hot")
            }

            let total = voteCounts.values.reduce(0, +)
            if total > 0 {
                HStack(spacing: 14) {
                    ForEach([BustStatus.green, .yellow, .red], id: \.rawValue) { status in
                        let count = voteCounts[status] ?? 0
                        if count > 0 {
                            Label("\(count)", systemImage: "person.fill")
                                .font(.caption2)
                                .foregroundStyle(statusColor(status))
                        }
                    }
                    Text("(\(total) vote\(total == 1 ? "" : "s"))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func bustVoteButton(_ status: BustStatus, label: String) -> some View {
        let selected = myVote == status
        Button { castVote(status) } label: {
            VStack(spacing: 5) {
                Circle()
                    .fill(statusColor(status).opacity(selected ? 0.9 : 0.12))
                    .frame(width: 40, height: 40)
                    .overlay(Circle().stroke(statusColor(status), lineWidth: selected ? 2 : 1))
                Text(label)
                    .font(.system(size: 9, weight: selected ? .black : .regular))
                    .foregroundStyle(selected ? statusColor(status) : Color.secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Clips

    private var clipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("CLIPS")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(.secondary)
                Spacer()
                Button { showAddClip = true } label: {
                    Label("Add", systemImage: "plus")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                }
            }

            if spotClips.isEmpty {
                Text("No clips yet. Be the first to add one.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                VStack(spacing: 0) {
                    ForEach(spotClips) { clip in
                        clipRow(clip)
                        if clip.id != spotClips.last?.id {
                            Divider().background(Color.white.opacity(0.06))
                        }
                    }
                }
                .background(Color.white.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    @ViewBuilder
    private func clipRow(_ clip: SpotClip) -> some View {
        Button {
            if let url = URL(string: clip.clipURL) { openURL(url) }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "play.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.orange)
                VStack(alignment: .leading, spacing: 3) {
                    Text(clip.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Text("by \(clip.addedBy)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
    }

    // MARK: - Helpers

    private func statusColor(_ status: BustStatus) -> Color {
        switch status {
        case .green:  return .green
        case .yellow: return .yellow
        case .red:    return .red
        }
    }

    private func castVote(_ status: BustStatus) {
        guard let me = currentUsername else { return }

        // Remove existing votes from this user for this spot
        let toRemove = bustVotes.filter { $0.spotName == spot.name && $0.username == me }
        toRemove.forEach { modelContext.delete($0) }

        let newVote = BustVote(spotName: spot.name, vote: status, username: me)
        modelContext.insert(newVote)

        // Auto-update spot bust status if consensus reached
        let remaining = bustVotes.filter { $0.spotName == spot.name && $0.username != me }
        if let consensus = BustVoteEngine.consensusBust(for: spot.name, in: remaining + [newVote]) {
            spot.bustStatusRaw = consensus.rawValue
            spot.bustConfidenceDate = Date()
        }
    }
}
