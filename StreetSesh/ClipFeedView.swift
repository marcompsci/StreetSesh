import SwiftUI
import SwiftData

// MARK: - Clip Feed View

struct ClipFeedView: View {
    @Environment(\.dismiss)       private var dismiss
    @Environment(\.modelContext)  private var modelContext
    @Query(sort: \SpotClip.addedAt, order: .reverse) private var allClips: [SpotClip]
    @Query private var users:    [AppUser]
    @Query private var follows:  [FollowRelation]
    @Query private var checkIns: [SpotCheckIn]

    @State private var tab     = Tab.all
    @State private var showAdd = false

    private var currentUsername: String { users.first?.username ?? "" }

    private var followingNames: Set<String> {
        Set(FollowEngine.followingUsernames(for: currentUsername, in: follows))
    }

    private var recentSpotNames: [String] {
        let mine = checkIns.filter { $0.username == currentUsername }
        var seen = Set<String>()
        return mine.compactMap { seen.insert($0.spotName).inserted ? $0.spotName : nil }
            .prefix(20).map { $0 }
    }

    private var displayedClips: [SpotClip] {
        switch tab {
        case .all:       return allClips
        case .following: return allClips.filter { followingNames.contains($0.addedBy) }
        case .mine:      return allClips.filter { $0.addedBy == currentUsername }
        }
    }

    enum Tab: String, CaseIterable {
        case all       = "All"
        case following = "Following"
        case mine      = "My Clips"
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    tabPicker
                    Divider().background(Color.white.opacity(0.08))
                    clipList
                }
            }
            .navigationTitle("Clip Feed")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.white)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button { showAdd = true } label: {
                        Image(systemName: "plus.circle.fill").foregroundStyle(.orange)
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                QuickAddClipSheet(recentSpots: recentSpotNames)
                    .presentationBackground(Color.black)
            }
        }
    }

    // MARK: - Tab Picker

    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { t in
                let count = countFor(t)
                Button { withAnimation(.easeInOut(duration: 0.15)) { tab = t } } label: {
                    VStack(spacing: 3) {
                        Text(t.rawValue)
                            .font(.system(size: 13, weight: tab == t ? .black : .regular))
                            .foregroundStyle(tab == t ? Color.white : Color.secondary)
                        if count > 0 {
                            Text("\(count)")
                                .font(.system(size: 10, weight: .black))
                                .foregroundStyle(tab == t ? Color.orange : Color.secondary.opacity(0.6))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
            }
        }
        .overlay(alignment: .bottom) {
            GeometryReader { geo in
                let w   = geo.size.width / CGFloat(Tab.allCases.count)
                let idx = CGFloat(Tab.allCases.firstIndex(of: tab) ?? 0)
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: w, height: 2)
                    .offset(x: idx * w)
                    .animation(.easeInOut(duration: 0.15), value: tab)
            }
            .frame(height: 2)
        }
    }

    private func countFor(_ t: Tab) -> Int {
        switch t {
        case .all:       return allClips.count
        case .following: return allClips.filter { followingNames.contains($0.addedBy) }.count
        case .mine:      return allClips.filter { $0.addedBy == currentUsername }.count
        }
    }

    // MARK: - Clip List

    @ViewBuilder
    private var clipList: some View {
        if displayedClips.isEmpty {
            emptyState
        } else {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(displayedClips) { clip in
                        ClipCard(clip: clip)
                        Divider().background(Color.white.opacity(0.06))
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        Spacer()
        VStack(spacing: 14) {
            Image(systemName: "film.stack")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text(tab == .following ? "No clips from people you follow yet."
                 : tab == .mine    ? "You haven't posted any clips yet."
                                   : "No clips posted yet.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            if tab != .following {
                Button { showAdd = true } label: {
                    Text("Post a Clip")
                        .font(.subheadline.weight(.black))
                        .padding(.horizontal, 24).padding(.vertical, 12)
                        .background(Color.orange)
                        .foregroundStyle(.black)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(32)
        Spacer()
    }
}

// MARK: - Clip Card

private struct ClipCard: View {
    let clip: SpotClip
    @Environment(\.openURL) private var openURL

    private var platform: ClipPlatform { ClipPlatform.detect(from: clip.clipURL) }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            // Platform badge
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: platform.colorHex).opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: platform.icon)
                    .font(.system(size: 17))
                    .foregroundStyle(Color(hex: platform.colorHex))
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(clip.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                HStack(spacing: 5) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(.orange)
                    Text(clip.spotName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                HStack(spacing: 5) {
                    Text(clip.addedBy)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text("·")
                        .font(.caption2)
                        .foregroundStyle(.secondary.opacity(0.5))
                    Text(clip.addedAt.skRelative)
                        .font(.caption2)
                        .foregroundStyle(.secondary.opacity(0.7))
                    Spacer()
                    Text(platform.label)
                        .font(.system(size: 9, weight: .black))
                        .foregroundStyle(Color(hex: platform.colorHex))
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Color(hex: platform.colorHex).opacity(0.12))
                        .clipShape(Capsule())
                }
            }

            Spacer(minLength: 0)

            Button {
                if let url = URL(string: clip.clipURL) { openURL(url) }
            } label: {
                Image(systemName: "arrow.up.right.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Color(hex: platform.colorHex))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - Platform Detection

enum ClipPlatform {
    case youtube, instagram, tiktok, other

    static func detect(from url: String) -> ClipPlatform {
        let l = url.lowercased()
        if l.contains("youtube") || l.contains("youtu.be") { return .youtube }
        if l.contains("instagram")                         { return .instagram }
        if l.contains("tiktok")                           { return .tiktok }
        return .other
    }

    var icon: String {
        switch self {
        case .youtube:   return "play.rectangle.fill"
        case .instagram: return "camera.fill"
        case .tiktok:    return "music.note"
        case .other:     return "link"
        }
    }

    var colorHex: String {
        switch self {
        case .youtube:   return "#FF3B30"
        case .instagram: return "#E1306C"
        case .tiktok:    return "#3AB5E6"
        case .other:     return "#8E8E93"
        }
    }

    var label: String {
        switch self {
        case .youtube:   return "YouTube"
        case .instagram: return "Instagram"
        case .tiktok:    return "TikTok"
        case .other:     return "Link"
        }
    }
}

// MARK: - Quick Add Clip Sheet

struct QuickAddClipSheet: View {
    let recentSpots: [String]

    @Environment(\.dismiss)       private var dismiss
    @Environment(\.modelContext)  private var modelContext
    @Query private var users:     [AppUser]

    @State private var spotName       = ""
    @State private var clipURL        = ""
    @State private var clipTitle      = ""
    @State private var showSpotPicker = false

    private var currentUser: AppUser? { users.first }

    private var isValidURL: Bool {
        let t = clipURL.trimmingCharacters(in: .whitespaces)
        return !t.isEmpty && URL(string: t) != nil
    }

    private var canSave: Bool {
        isValidURL && !spotName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        fieldBlock(label: "SPOT") {
                            HStack {
                                TextField("Which spot?", text: $spotName)
                                    .foregroundStyle(Color.white)
                                    .autocorrectionDisabled()
                                if !recentSpots.isEmpty {
                                    Button { showSpotPicker = true } label: {
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }

                        fieldBlock(label: "CLIP URL") {
                            TextField("YouTube, Instagram, TikTok…", text: $clipURL)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .keyboardType(.URL)
                                .foregroundStyle(Color.white)
                        }

                        fieldBlock(label: "TITLE (optional)") {
                            TextField("e.g. Kickflip nosegrind at EMB", text: $clipTitle)
                                .autocorrectionDisabled()
                                .foregroundStyle(Color.white)
                        }

                        Spacer(minLength: 32)

                        Button { saveClip() } label: {
                            Text("POST CLIP")
                                .font(.headline.weight(.black))
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(canSave ? Color.orange : Color.white.opacity(0.10))
                                .foregroundStyle(canSave ? Color.black : Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .disabled(!canSave)
                    }
                    .padding()
                }
            }
            .navigationTitle("Post a Clip")
            .inlineNavBar()
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.white)
                }
            }
            .confirmationDialog("Choose a Spot", isPresented: $showSpotPicker) {
                ForEach(recentSpots.prefix(10), id: \.self) { s in
                    Button(s) { spotName = s }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    @ViewBuilder
    private func fieldBlock<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(.secondary)
            content()
                .padding()
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    private func saveClip() {
        let url  = clipURL.trimmingCharacters(in: .whitespaces)
        let spot = spotName.trimmingCharacters(in: .whitespaces)
        guard canSave, let user = currentUser else { return }
        let title = clipTitle.trimmingCharacters(in: .whitespaces).isEmpty
            ? url
            : clipTitle.trimmingCharacters(in: .whitespaces)
        let clip = SpotClip(spotName: spot, clipURL: url, title: title, addedBy: user.username)
        modelContext.insert(clip)
        Task { try? await SupabaseService.shared.pushClip(clip) }
        try? modelContext.save()
        dismiss()
    }
}
