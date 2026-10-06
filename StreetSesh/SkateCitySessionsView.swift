import SwiftUI
import SwiftData

struct SkateCitySessionsView: View {
    @EnvironmentObject private var state: SkateCityAppState
    @State private var showCreateSession = false
    @State private var showPostClip      = false
    @State private var showComments: SkateClip? = nil
    @State private var showNativeShare   = false
    @State private var shareItems: [Any] = []

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skDark.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        headerSection
                        sessionsSection
                        Divider().background(Color.skBorder).padding(.horizontal)
                        clipFeedSection
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
        .sheet(isPresented: $showCreateSession) {
            SKCreateSessionSheet()
                .environmentObject(state)
                .presentationDetents([.large])
                .presentationBackground(Color.skDark)
        }
        .sheet(isPresented: $showPostClip) {
            SKPostClipSheet()
                .environmentObject(state)
                .presentationDetents([.large])
                .presentationBackground(Color.skDark)
        }
        .sheet(item: $showComments) { clip in
            SKCommentSheet(clip: clip)
                .environmentObject(state)
                .presentationDetents([.large])
                .presentationBackground(Color.skDark)
        }
        #if os(iOS)
        .sheet(isPresented: $showNativeShare) {
            ActivityView(items: shareItems)
                .presentationDetents([.medium, .large])
        }
        #endif
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Sessions")
                    .font(.system(size: 28, weight: .black))
                    .foregroundStyle(.skText)
                Text("Crew sessions & clips")
                    .font(.subheadline)
                    .foregroundStyle(.skSub)
            }
            Spacer()
            Button { showPostClip = true } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                    Text("Clip")
                }
                .font(.caption.weight(.black))
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Color.skLime)
                .foregroundStyle(.black)
                .clipShape(Capsule())
            }
        }
    }

    // MARK: - Sessions

    private var sessionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SKSectionHeader(title: "CREW SESSIONS") { showCreateSession = true }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    createSessionCard
                    ForEach(state.sessions) { session in
                        sessionCard(session)
                    }
                }
                .padding(.horizontal, 1)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(Color.skCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var createSessionCard: some View {
        Button { showCreateSession = true } label: {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(Color.skLime.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 44, height: 44)
                    Image(systemName: "plus")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.skLime)
                }
                Text("New")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.skLime)
            }
            .frame(width: 80)
            .padding(.vertical, 14)
            .background(Color.skMuted)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private func sessionCard(_ session: CrewSession) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                statusDot(session.status)
                Spacer()
                privacyIcon(session.privacy)
            }
            Text(session.title)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.skText)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Text(session.neighborhood)
                .font(.caption2)
                .foregroundStyle(.skSub)
            Spacer()
            HStack {
                Image(systemName: "person.2.fill")
                    .font(.caption2)
                    .foregroundStyle(.skSub)
                Text("\(session.participantCount)/\(session.maxParticipants)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.skSub)
            }
            if session.status == .upcoming {
                Text(session.startTime, style: .relative)
                    .font(.system(size: 10))
                    .foregroundStyle(.skLime)
            } else {
                Text("LIVE NOW")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(.skCoral)
            }
            Button {
                state.joinSession(session.id)
            } label: {
                Text("Join")
                    .font(.system(size: 11, weight: .black))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 7)
                    .background(Color.skLime)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(session.participantCount >= session.maxParticipants)
        }
        .padding(12)
        .frame(width: 145)
        .background(Color.skMuted)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func statusDot(_ status: SessionStatus) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(status == .active ? Color.skCoral : Color.skSub)
                .frame(width: 6, height: 6)
            Text(status.rawValue)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(status == .active ? .skCoral : .skSub)
        }
    }

    private func privacyIcon(_ privacy: SessionPrivacy) -> some View {
        let icon: String
        switch privacy {
        case .friendsOnly: icon = "person.2.fill"
        case .crew:        icon = "person.3.fill"
        case .inviteOnly:  icon = "lock.fill"
        }
        return Image(systemName: icon)
            .font(.caption2)
            .foregroundStyle(.skSub)
    }

    // MARK: - Clip Feed

    private var clipFeedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SKSectionHeader(title: "CLIP FEED")
            VStack(spacing: 12) {
                ForEach(state.clips) { clip in
                    clipCard(clip)
                }
            }
        }
    }

    private func clipCard(_ clip: SkateClip) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Creator row
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.skMuted)
                        .frame(width: 38, height: 38)
                    Text(String(clip.creatorName.prefix(1)))
                        .font(.system(size: 15, weight: .black))
                        .foregroundStyle(.skLime)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(clip.creatorName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.skText)
                    Text(clip.creatorHandle)
                        .font(.caption2)
                        .foregroundStyle(.skSub)
                }
                Spacer()
                Text(clip.createdAt.skRelative)
                    .font(.caption2)
                    .foregroundStyle(.skSub)
            }

            // Challenge + score
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(clip.challengeTitle)
                        .font(.subheadline.bold())
                        .foregroundStyle(.skText)
                        .lineLimit(1)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(clip.trickTags, id: \.self) { tag in
                                SKTag(label: tag, small: true)
                            }
                        }
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(clip.score)")
                        .font(.system(size: 22, weight: .black))
                        .foregroundStyle(.skLime)
                    Text("pts")
                        .font(.caption2)
                        .foregroundStyle(.skSub)
                }
            }

            // Actions row — like · comment · share
            HStack(spacing: 20) {
                // Like
                Button { state.toggleLike(clipID: clip.id) } label: {
                    HStack(spacing: 5) {
                        Image(systemName: clip.isLiked ? "heart.fill" : "heart")
                            .font(.subheadline)
                            .foregroundStyle(clip.isLiked ? .skCoral : .skSub)
                        Text("\(clip.likes)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(clip.isLiked ? .skCoral : .skSub)
                    }
                }
                .buttonStyle(.plain)

                // Comment — taps open comment sheet
                Button { showComments = clip } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "bubble.right")
                            .font(.subheadline)
                            .foregroundStyle(.skSub)
                        Text("\(clip.comments)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.skSub)
                    }
                }
                .buttonStyle(.plain)

                Spacer()

                // Share → Instagram Stories or native share
                Button { shareClip(clip) } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.subheadline)
                        Text("Share")
                            .font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(.skSub)
                }
                .buttonStyle(.plain)
            }
        }
        .skCard()
    }

    // MARK: - Share helper

    private func shareClip(_ clip: SkateClip) {
        #if os(iOS)
        let igStoriesURL = URL(string: "instagram-stories://share")!
        let igAppURL     = URL(string: "instagram://app")!

        let pasteboardItems: [[String: Any]] = [[
            "com.instagram.sharedSticker.contentURL":        "https://streetsesh.app",
            "com.instagram.sharedSticker.backgroundTopColor":    "#0D1117",
            "com.instagram.sharedSticker.backgroundBottomColor": "#2D1B4E"
        ]]

        if UIApplication.shared.canOpenURL(igStoriesURL) {
            UIPasteboard.general.setItems(pasteboardItems,
                                          options: [.expirationDate: Date().addingTimeInterval(300)])
            UIApplication.shared.open(igStoriesURL)
        } else if UIApplication.shared.canOpenURL(igAppURL) {
            UIApplication.shared.open(igAppURL)
        } else {
            let text = "🛹 \(clip.challengeTitle) · \(clip.trickTags.joined(separator: " · "))\nvia @StreetSesh — streetsesh.app"
            shareItems = [text]
            showNativeShare = true
        }
        #endif
    }
}

// MARK: - UIActivityViewController wrapper

#if os(iOS)
struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#endif

// MARK: - Comment Sheet

struct SKCommentSheet: View {
    let clip: SkateClip
    @EnvironmentObject private var state: SkateCityAppState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var newComment = ""
    @State private var showViolationAlert = false

    private var comments: [SKComment] { state.comments(for: clip.id) }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skDark.ignoresSafeArea()
                VStack(spacing: 0) {
                    // Clip header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(clip.challengeTitle)
                                .font(.subheadline.bold())
                                .foregroundStyle(.skText)
                            Text(clip.creatorHandle)
                                .font(.caption2)
                                .foregroundStyle(.skSub)
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: clip.isLiked ? "heart.fill" : "heart")
                                .foregroundStyle(clip.isLiked ? .skCoral : .skSub)
                            Text("\(clip.likes)")
                                .foregroundStyle(.skSub)
                        }
                        .font(.caption)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.skCard)

                    Divider().background(Color.skBorder)

                    // Comments list
                    if comments.isEmpty {
                        Spacer()
                        VStack(spacing: 10) {
                            Image(systemName: "bubble.right")
                                .font(.system(size: 40))
                                .foregroundStyle(.skSub)
                            Text("No comments yet.\nBe the first to drop one.")
                                .font(.subheadline)
                                .foregroundStyle(.skSub)
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                ForEach(comments) { comment in
                                    commentRow(comment)
                                    Divider().background(Color.skBorder).padding(.leading, 56)
                                }
                            }
                            .padding(.top, 4)
                        }
                    }

                    Divider().background(Color.skBorder)

                    // Input bar
                    HStack(spacing: 12) {
                        ZStack {
                            Circle().fill(Color.skMuted).frame(width: 34, height: 34)
                            Text(String(state.profile.displayName.prefix(1)))
                                .font(.system(size: 13, weight: .black))
                                .foregroundStyle(.skLime)
                        }
                        TextField("Add a comment…", text: $newComment)
                            .foregroundStyle(.skText)
                            .submitLabel(.send)
                            .onSubmit { postComment() }

                        Button { postComment() } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                                .foregroundStyle(newComment.isEmpty ? .skSub : .skLime)
                        }
                        .disabled(newComment.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.skCard)
                }
            }
            .navigationTitle("Comments")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(.skLime)
                }
            }
        }
        .alert("Content Blocked", isPresented: $showViolationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your comment was flagged and not posted. Keep it positive and respectful.")
        }
    }

    private func commentRow(_ comment: SKComment) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle().fill(Color.skMuted).frame(width: 34, height: 34)
                Text(String(comment.author.prefix(1)))
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(.skLime)
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(comment.handle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.skText)
                    Text(comment.createdAt.skRelative)
                        .font(.caption2)
                        .foregroundStyle(.skSub)
                }
                Text(comment.text)
                    .font(.subheadline)
                    .foregroundStyle(.skText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func postComment() {
        let text = newComment
        let username = state.profile.displayName
        newComment = ""
        Task {
            let ok = await ModerationService.shared.validateAndSubmit(text: text, username: username)
            guard ok else { showViolationAlert = true; return }
            state.addComment(to: clip.id, text: text)
            // In-app notification for the clip's creator
            let notif = NotificationItem(
                kind: "comment",
                title: "New comment",
                body: "\(username) commented on \"\(clip.challengeTitle)\"",
                targetID: clip.id.uuidString
            )
            modelContext.insert(notif)
            try? modelContext.save()
        }
    }
}

// MARK: - Create Session Sheet

struct SKCreateSessionSheet: View {
    @EnvironmentObject private var state: SkateCityAppState
    @Environment(\.dismiss) private var dismiss

    @State private var title         = ""
    @State private var neighborhood  = "Mission"
    @State private var privacy       = SessionPrivacy.crew
    @State private var maxParticipants = 6
    @State private var sessionDate   = Date().addingTimeInterval(7200)
    @State private var showViolationAlert = false

    private var isValid: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skDark.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        formField("SESSION NAME") {
                            TextField("e.g. Saturday Mission Sesh", text: $title)
                                .foregroundStyle(.skText)
                        }
                        formField("NEIGHBORHOOD") {
                            TextField("Where are you skating?", text: $neighborhood)
                                .foregroundStyle(.skText)
                        }
                        formField("START TIME") {
                            DatePicker("", selection: $sessionDate, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(.compact)
                                .colorScheme(.dark)
                        }
                        formField("MAX CREW SIZE") {
                            Stepper("\(maxParticipants) skaters", value: $maxParticipants, in: 2...20)
                                .foregroundStyle(.skText)
                        }
                        formField("PRIVACY") {
                            Picker("Privacy", selection: $privacy) {
                                ForEach(SessionPrivacy.allCases, id: \.self) { p in
                                    Text(p.rawValue).tag(p)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        SKButton(title: "Create Session", style: isValid ? .primary : .ghost) {
                            guard isValid else { return }
                            let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
                            Task {
                                let ok = await ModerationService.shared.validateAndSubmit(text: trimmedTitle, username: state.profile.displayName)
                                guard ok else { showViolationAlert = true; return }
                                let session = CrewSession(
                                    id: UUID(),
                                    title: trimmedTitle,
                                    hostName: state.profile.displayName,
                                    neighborhood: neighborhood,
                                    startTime: sessionDate,
                                    participantCount: 1,
                                    maxParticipants: maxParticipants,
                                    privacy: privacy,
                                    status: .upcoming
                                )
                                state.addSession(session)
                                dismiss()
                            }
                        }
                        .disabled(!isValid)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Session")
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.skText)
                }
            }
        }
        .alert("Content Blocked", isPresented: $showViolationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your session name was flagged. Please keep it positive and respectful.")
        }
    }

    @ViewBuilder
    private func formField<C: View>(_ label: String, @ViewBuilder content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.system(size: 10, weight: .black)).foregroundStyle(.skSub)
            content()
                .padding(14)
                .background(Color.skMuted)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Post Clip Sheet

struct SKPostClipSheet: View {
    @EnvironmentObject private var state: SkateCityAppState
    @Environment(\.dismiss) private var dismiss

    @State private var selectedChallenge = 0
    @State private var trickInput        = ""
    @State private var score             = 500
    @State private var showViolationAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skDark.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 20) {
                    Text("CHALLENGE")
                        .font(.system(size: 10, weight: .black))
                        .foregroundStyle(.skSub)
                    Picker("Challenge", selection: $selectedChallenge) {
                        ForEach(SKMockData.challenges.indices, id: \.self) { i in
                            Text(SKMockData.challenges[i].title).tag(i)
                        }
                    }
                    #if os(iOS)
                    .pickerStyle(.wheel)
                    #else
                    .pickerStyle(.menu)
                    #endif
                    .frame(height: 120)
                    .background(Color.skMuted).clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 6) {
                        Text("TRICKS (comma separated)")
                            .font(.system(size: 10, weight: .black))
                            .foregroundStyle(.skSub)
                        TextField("Kickflip, Backside Grind...", text: $trickInput)
                            .foregroundStyle(.skText)
                            .padding(14)
                            .background(Color.skMuted)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("SCORE")
                                .font(.system(size: 10, weight: .black))
                                .foregroundStyle(.skSub)
                            Spacer()
                            Text("\(score) pts")
                                .font(.system(size: 14, weight: .black))
                                .foregroundStyle(.skLime)
                        }
                        Slider(value: Binding(
                            get: { Double(score) },
                            set: { score = Int($0) }
                        ), in: 100...1000, step: 25)
                        .tint(.skLime)
                    }

                    Spacer()
                    SKButton(title: "Post Clip") {
                        let rawTricks = trickInput
                        let tags = rawTricks.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                        Task {
                            let ok = await ModerationService.shared.validateAndSubmit(text: rawTricks, username: state.profile.displayName)
                            guard ok else { showViolationAlert = true; return }
                            let clip = SkateClip(
                                id: UUID(),
                                creatorName: state.profile.displayName,
                                creatorHandle: state.profile.handle,
                                challengeTitle: SKMockData.challenges[selectedChallenge].title,
                                score: score,
                                likes: 0,
                                comments: 0,
                                createdAt: Date(),
                                trickTags: tags.isEmpty ? ["Trick"] : tags,
                                isLiked: false
                            )
                            state.postClip(clip)
                            state.earnXP(score / 10)
                            dismiss()
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle("Post Clip")
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.skText)
                }
            }
        }
        .alert("Content Blocked", isPresented: $showViolationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your post was flagged. Keep it positive — only good vibes here.")
        }
    }
}
