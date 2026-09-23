import SwiftUI

struct SkateCitySessionsView: View {
    @EnvironmentObject private var state: SkateCityAppState
    @State private var showCreateSession = false
    @State private var showPostClip     = false

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

            // Actions row
            HStack(spacing: 20) {
                Button {
                    state.toggleLike(clipID: clip.id)
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: clip.isLiked ? "heart.fill" : "heart")
                            .font(.subheadline)
                            .foregroundStyle(clip.isLiked ? .skCoral : .skSub)
                        Text("\(clip.likes)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(clip.isLiked ? .skCoral : .skSub)
                    }
                }
                HStack(spacing: 5) {
                    Image(systemName: "bubble.right")
                        .font(.subheadline)
                        .foregroundStyle(.skSub)
                    Text("\(clip.comments)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.skSub)
                }
                Spacer()
            }
        }
        .skCard()
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
                            let session = CrewSession(
                                id: UUID(),
                                title: title.trimmingCharacters(in: .whitespaces),
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
                        let tags = trickInput.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
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
    }
}
