import SwiftUI
import SwiftData
import AuthenticationServices
import Supabase
import Auth

// MARK: - Main Coordinator

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var step = 0
    @State private var goingForward = true
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0

    @State private var username  = ""
    @State private var email     = ""
    @State private var ageText   = ""
    @State private var stance: Stance       = .regular
    @State private var skateStyle: SkateStyle = .street
    @State private var avatar = AvatarData()
    @State private var board  = BoardData()
    @State private var avatarCat: AvatarCategory = .look
    @State private var boardCat: BoardCategory = .deck
    @State private var usedSocialAuth = false

    private let totalSteps = 7

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if step > 0 {
                VStack {
                    progressBar
                        .padding(.top, 56)
                    Spacer()
                }
                .transition(.opacity)
                .animation(.easeIn(duration: 0.3), value: step > 0)
            }

            Group {
                switch step {
                case 0: splashStep
                case 1: authStep
                case 2: nameStep
                case 3: emailStep
                case 4: ageStep
                case 5: stanceStep
                case 6: styleStep
                case 7: readyStep
                default: splashStep
                }
            }
            .id(step)
            .transition(
                goingForward
                ? .asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                              removal:   .move(edge: .leading).combined(with: .opacity))
                : .asymmetric(insertion: .move(edge: .leading).combined(with: .opacity),
                              removal:   .move(edge: .trailing).combined(with: .opacity))
            )
        }
        .animation(.spring(response: 0.42, dampingFraction: 0.84), value: step)
    }

    private var progressBar: some View {
        GeometryReader { g in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.1)).frame(height: 3)
                Capsule()
                    .fill(Color.orange)
                    .frame(width: g.size.width * (CGFloat(step) / CGFloat(totalSteps)), height: 3)
                    .animation(.spring(response: 0.4), value: step)
            }
        }
        .frame(height: 3)
        .padding(.horizontal, 28)
    }

    private func next() {
        goingForward = true
        withAnimation(.spring(response: 0.42, dampingFraction: 0.84)) { step += 1 }
    }
    private func back() {
        goingForward = false
        withAnimation(.spring(response: 0.42, dampingFraction: 0.84)) { step -= 1 }
    }

    private func createUser() {
        let name = username.trimmingCharacters(in: .whitespaces)
        let age  = Int(ageText) ?? 0
        let user = AppUser(
            username: name.isEmpty ? "skater" : name,
            email: email.trimmingCharacters(in: .whitespaces),
            isUnder18: age > 0 && age < 18,
            stance: stance,
            skatingStyle: skateStyle,
            avatar: avatar,
            board: board
        )
        modelContext.insert(user)
        Task { try? await SupabaseService.shared.upsertUser(user) }
    }
}

// MARK: - Step Views

extension OnboardingView {

    // MARK: Splash (0)

    private var splashStep: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: -8) {
                Text("STREET")
                    .font(.system(size: 76, weight: .black))
                    .foregroundStyle(.white)
                Text("SESH")
                    .font(.system(size: 76, weight: .black))
                    .foregroundStyle(Color(hex: "#CCFF40"))
            }
            .scaleEffect(logoScale)
            .opacity(logoOpacity)
            Text("The spot app skaters actually trust.")
                .font(.subheadline).foregroundStyle(.secondary)
                .padding(.top, 12).opacity(logoOpacity)
            Spacer()
            Image(systemName: "skateboard.fill")
                .font(.system(size: 64)).foregroundStyle(Color(hex: "#CCFF40").opacity(0.88))
                .opacity(logoOpacity).padding(.bottom, 60)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.58)) {
                logoScale = 1.0; logoOpacity = 1.0
            }
            Task { try? await Task.sleep(for: .seconds(2.6)); next() }
        }
    }

    // MARK: Auth (1)

    private var authStep: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 110)
            VStack(alignment: .leading, spacing: 6) {
                Text("Join the\ncrew.").font(.system(size: 36, weight: .black)).foregroundStyle(.white)
                Text("Quick sign-in, or build your profile with email.")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28).padding(.bottom, 36)

            Spacer()

            VStack(spacing: 14) {
                SignInWithAppleButton(.signIn,
                    onRequest: { req in req.requestedScopes = [.fullName, .email] },
                    onCompletion: handleAppleSignIn
                )
                .signInWithAppleButtonStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 56)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Button(action: handleGoogleSignIn) {
                    HStack(spacing: 10) {
                        Text("G").font(.system(size: 20, weight: .bold)).foregroundStyle(Color(hex: "#4285F4"))
                        Text("Sign in with Google").font(.headline.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity).frame(minHeight: 56)
                    .background(Color.white).foregroundStyle(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                HStack {
                    Rectangle().fill(Color.white.opacity(0.15)).frame(height: 1)
                    Text("or").font(.caption).foregroundStyle(.secondary).padding(.horizontal, 12)
                    Rectangle().fill(Color.white.opacity(0.15)).frame(height: 1)
                }
                .padding(.vertical, 4)

                Button(action: next) {
                    Text("Continue with email  →")
                        .font(.headline.weight(.black))
                        .frame(maxWidth: .infinity).padding(18)
                        .background(Color.orange).foregroundStyle(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal, 28).padding(.bottom, 52)
        }
    }

    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        guard case .success(let auth) = result,
              let cred = auth.credential as? ASAuthorizationAppleIDCredential else { return }
        if let firstName = cred.fullName?.givenName, !firstName.isEmpty { username = firstName }
        if let appleEmail = cred.email { email = appleEmail }
        usedSocialAuth = true
        if let tokenData = cred.identityToken, let tokenStr = String(data: tokenData, encoding: .utf8) {
            Task {
                try? await SupabaseService.shared.client.auth.signInWithIdToken(
                    credentials: .init(provider: .apple, idToken: tokenStr)
                )
            }
        }
        goingForward = true
        withAnimation(.spring(response: 0.42, dampingFraction: 0.84)) { step = 7 }
    }

    private func handleGoogleSignIn() {
        Task {
            do {
                try await SupabaseService.shared.client.auth.signInWithOAuth(provider: .google)
                usedSocialAuth = true
                await MainActor.run {
                    goingForward = true
                    withAnimation(.spring(response: 0.42, dampingFraction: 0.84)) { step = 7 }
                }
            } catch { }
        }
    }

    // MARK: Name (2)

    private var nameStep: some View {
        stepShell(title: "What do they\ncall you?", subtitle: "Your tag on the streets.",
                  canContinue: !username.trimmingCharacters(in: .whitespaces).isEmpty) {
            TextField("", text: $username,
                      prompt: Text("grindset_99").foregroundStyle(.secondary))
                .font(.system(size: 30, weight: .bold)).foregroundStyle(.white)
                .autocorrectionDisabled().multilineTextAlignment(.center)
                .padding(18).background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14)).padding(.horizontal, 28)
        }
    }

    // MARK: Email (3)

    private var emailStep: some View {
        stepShell(title: "Drop your\nemail.", subtitle: "Account recovery only. We don't spam.",
                  canContinue: email.contains("@") && email.contains(".")) {
            TextField("", text: $email,
                      prompt: Text("you@example.com").foregroundStyle(.secondary))
                .font(.system(size: 24, weight: .semibold)).foregroundStyle(.white)
                .autocorrectionDisabled().multilineTextAlignment(.center)
                #if os(iOS)
                .keyboardType(.emailAddress).textInputAutocapitalization(.never)
                #endif
                .padding(18).background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14)).padding(.horizontal, 28)
        }
    }

    // MARK: Age (4)

    private var ageStep: some View {
        stepShell(title: "How old\nare you?", subtitle: "Keeps content age-appropriate.",
                  canContinue: Int(ageText) != nil) {
            VStack(spacing: 16) {
                TextField("", text: $ageText, prompt: Text("18").foregroundStyle(.secondary))
                    .font(.system(size: 52, weight: .black)).foregroundStyle(.orange)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
                    .multilineTextAlignment(.center).frame(width: 140)
                    .padding(18).background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                if let age = Int(ageText), age > 0 && age < 18 {
                    Label("Under-18 visibility limits apply.", systemImage: "lock.shield.fill")
                        .font(.caption).foregroundStyle(.orange)
                }
            }
        }
    }

    // MARK: Stance (5)

    private var stanceStep: some View {
        stepShell(title: "Regular\nor Goofy?", subtitle: "Which foot do you lead with?",
                  canContinue: true) {
            HStack(spacing: 14) { stanceCard(.regular); stanceCard(.goofy) }
                .padding(.horizontal, 28)
        }
    }

    @ViewBuilder
    private func stanceCard(_ s: Stance) -> some View {
        let sel = stance == s
        Button { stance = s } label: {
            VStack(spacing: 14) {
                HStack(spacing: s == .regular ? 6 : -6) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(sel ? Color.orange : Color.white.opacity(0.3))
                        .frame(width: s == .regular ? 34 : 26, height: 20)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(sel ? Color.orange.opacity(0.55) : Color.white.opacity(0.18))
                        .frame(width: s == .regular ? 26 : 34, height: 20)
                }.padding(.top, 6)
                Text(s.rawValue.uppercased()).font(.system(size: 18, weight: .black))
                    .foregroundStyle(sel ? .orange : .white)
                Text(s.footLabel).font(.caption).foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity).padding(.vertical, 24)
            .background(sel ? Color.orange.opacity(0.12) : Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(sel ? Color.orange : Color.clear, lineWidth: 2))
        }
        .buttonStyle(.plain)
    }

    // MARK: Style (6)

    private var styleStep: some View {
        stepShell(title: "What's\nyour vibe?", subtitle: "Pick the style that fits.", canContinue: true) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(SkateStyle.allCases, id: \.self) { style in styleCard(style) }
            }
            .padding(.horizontal, 24)
        }
    }

    @ViewBuilder
    private func styleCard(_ s: SkateStyle) -> some View {
        let sel = skateStyle == s
        Button { skateStyle = s } label: {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: s.icon).font(.system(size: 22))
                    .foregroundStyle(sel ? .orange : .white)
                Text(s.rawValue.uppercased()).font(.system(size: 15, weight: .black))
                    .foregroundStyle(sel ? .orange : .white)
                Text(s.tagline).font(.system(size: 11)).foregroundStyle(.secondary).lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading).padding(14)
            .background(sel ? Color.orange.opacity(0.14) : Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(sel ? Color.orange : Color.clear, lineWidth: 2))
        }
        .buttonStyle(.plain)
    }

    // MARK: Avatar (6) — game character creator

    private var avatarStep: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                // Subtle urban backdrop
                UrbanBackdrop()

                VStack(spacing: 0) {
                    // Top bar
                    HStack {
                        if step > 1 {
                            Button(action: back) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundStyle(.white)
                                    .frame(width: 36, height: 36)
                                    .background(Color.white.opacity(0.08))
                                    .clipShape(Circle())
                            }
                        }
                        Spacer()
                        Text("BUILD YOUR SKATER")
                            .font(.system(size: 11, weight: .black))
                            .tracking(2.5)
                            .foregroundStyle(.white.opacity(0.6))
                        Spacer()
                        Text("6 / 8")
                            .font(.system(size: 12, weight: .black))
                            .foregroundStyle(.orange)
                            .frame(width: 36)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    .padding(.bottom, 12)

                    // Character stage
                    ZStack(alignment: .bottom) {
                        // Floor glow
                        Ellipse()
                            .fill(Color.orange.opacity(0.08))
                            .blur(radius: 18)
                            .frame(width: 120, height: 24)
                            .padding(.bottom, 4)

                        SkaterCharacterView(avatar: avatar, size: geo.size.height * 0.44)
                            .shadow(color: .black.opacity(0.7), radius: 12, x: 0, y: 8)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geo.size.height * 0.46)

                    // Category tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(AvatarCategory.allCases, id: \.self) { cat in
                                avatarCatChip(cat)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 14)

                    // Options for selected category
                    avatarOptions
                        .frame(height: 130)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .animation(.spring(response: 0.3), value: avatarCat)

                    Spacer()

                    nextButton(label: "LOOKING GOOD  →") { next() }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private func avatarCatChip(_ cat: AvatarCategory) -> some View {
        let sel = avatarCat == cat
        return Button { withAnimation(.spring(response: 0.25)) { avatarCat = cat } } label: {
            HStack(spacing: 6) {
                Image(systemName: cat.icon)
                    .font(.system(size: 12, weight: .semibold))
                Text(cat.rawValue)
                    .font(.system(size: 12, weight: .black))
                    .tracking(0.8)
            }
            .padding(.horizontal, 14).padding(.vertical, 9)
            .background(sel ? Color.orange : Color.white.opacity(0.08))
            .foregroundStyle(sel ? Color.black : Color.white.opacity(0.85))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(sel ? Color.clear : Color.white.opacity(0.1), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var avatarOptions: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                switch avatarCat {
                case .look:
                    optionRow("Skin Tone", palette: AvatarData.skinPalette, sel: $avatar.skinToneIndex)
                case .hair:
                    chipRow("Style", names: AvatarData.hairStyleNames, sel: $avatar.hairStyle)
                    optionRow("Color", palette: AvatarData.hairPalette, sel: $avatar.hairColorIndex)
                case .fit:
                    optionRow("Top", palette: AvatarData.clothesPalette, sel: $avatar.topColorIndex)
                    optionRow("Pants", palette: AvatarData.clothesPalette, sel: $avatar.pantsColorIndex)
                case .kicks:
                    chipRow("Style", names: AvatarData.shoeStyleNames, sel: $avatar.shoeStyleIndex)
                    optionRow("Color", palette: AvatarData.clothesPalette, sel: $avatar.shoeColorIndex)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }

    // MARK: Board (7) — game style

    private var boardStep: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()
                UrbanBackdrop()

                VStack(spacing: 0) {
                    HStack {
                        Button(action: back) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .black))
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Circle())
                        }
                        Spacer()
                        Text("SET UP YOUR BOARD")
                            .font(.system(size: 11, weight: .black))
                            .tracking(2.5)
                            .foregroundStyle(.white.opacity(0.6))
                        Spacer()
                        Text("7 / 8")
                            .font(.system(size: 12, weight: .black))
                            .foregroundStyle(.orange)
                            .frame(width: 36)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    .padding(.bottom, 16)

                    // Board preview centered
                    ZStack {
                        // Drop glow
                        Ellipse()
                            .fill(Color.orange.opacity(0.12))
                            .blur(radius: 20)
                            .frame(width: 100, height: 20)
                            .offset(y: geo.size.height * 0.19)

                        SkateboardTopView(board: board, scale: geo.size.height * 0.0018)
                            .shadow(color: .black.opacity(0.6), radius: 14, x: 4, y: 6)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geo.size.height * 0.40)

                    // Category tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(BoardCategory.allCases, id: \.self) { cat in
                                boardCatChip(cat)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 14)

                    // Board options
                    boardOptions
                        .frame(height: 130)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .animation(.spring(response: 0.3), value: boardCat)

                    Spacer()

                    nextButton(label: "READY  →") { next() }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private func boardCatChip(_ cat: BoardCategory) -> some View {
        let sel = boardCat == cat
        return Button { withAnimation(.spring(response: 0.25)) { boardCat = cat } } label: {
            HStack(spacing: 6) {
                Image(systemName: cat.icon).font(.system(size: 12, weight: .semibold))
                Text(cat.rawValue).font(.system(size: 12, weight: .black)).tracking(0.8)
            }
            .padding(.horizontal, 14).padding(.vertical, 9)
            .background(sel ? Color.orange : Color.white.opacity(0.08))
            .foregroundStyle(sel ? Color.black : Color.white.opacity(0.85))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(sel ? Color.clear : Color.white.opacity(0.1), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var boardOptions: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                switch boardCat {
                case .deck:
                    optionRow("Deck Color", palette: BoardData.deckPalette, sel: $board.deckColorIndex)
                    graphicRow
                case .grip:
                    gripRow
                case .trucks:
                    truckRow
                case .wheels:
                    optionRow("Wheels", palette: BoardData.wheelPalette, sel: $board.wheelColorIndex)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }

    private var graphicRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            catLabel("Graphic")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(BoardData.graphics.indices, id: \.self) { i in
                        Button { board.deckGraphic = i } label: {
                            Text(BoardData.graphics[i])
                                .font(.system(size: 11, weight: .black, design: .rounded))
                                .tracking(1)
                                .padding(.horizontal, 12).padding(.vertical, 9)
                                .background(board.deckGraphic == i ? Color.orange.opacity(0.22) : Color.white.opacity(0.08))
                                .foregroundStyle(board.deckGraphic == i ? Color.orange : Color.white.opacity(0.75))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(
                                    board.deckGraphic == i ? Color.orange : Color.clear, lineWidth: 2))
                        }
                    }
                }
            }
        }
    }

    private var gripRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            catLabel("Grip Tape")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(BoardData.gripTapeNames.indices, id: \.self) { i in
                        Button { board.gripTapeIndex = i } label: {
                            VStack(spacing: 5) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(hex: BoardData.gripTapeBgColors[safe: i] ?? "#0A0A0A"))
                                        .frame(width: 44, height: 28)
                                    HStack(spacing: 4) {
                                        ForEach(0..<3, id: \.self) { _ in
                                            Circle().fill(Color.white.opacity(0.18)).frame(width: 3, height: 3)
                                        }
                                    }
                                }
                                .overlay(RoundedRectangle(cornerRadius: 6)
                                    .stroke(board.gripTapeIndex == i ? Color.orange : Color.clear, lineWidth: 2))
                                Text(BoardData.gripTapeNames[i])
                                    .font(.system(size: 9, weight: .semibold))
                                    .foregroundStyle(board.gripTapeIndex == i ? Color.orange : Color.secondary)
                            }
                        }
                    }
                }
            }
        }
    }

    private var truckRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            catLabel("Trucks")
            HStack(spacing: 8) {
                ForEach(BoardData.truckNames.indices, id: \.self) { i in
                    Button { board.truckColorIndex = i } label: {
                        HStack(spacing: 6) {
                            Circle().fill(Color(hex: BoardData.truckPalette[i])).frame(width: 16, height: 16)
                            Text(BoardData.truckNames[i]).font(.system(size: 12, weight: .semibold))
                        }
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(board.truckColorIndex == i ? Color.orange : Color.white.opacity(0.1))
                        .foregroundStyle(board.truckColorIndex == i ? Color.black : Color.white)
                        .clipShape(Capsule())
                    }
                }
            }
        }
    }

    // MARK: Ready (7)

    private var readyStep: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(systemName: "skateboard.fill")
                .font(.system(size: 72))
                .foregroundStyle(.orange.opacity(0.88))
                .padding(.bottom, 32)
            VStack(spacing: 6) {
                Text("You're locked in.")
                    .font(.system(size: 38, weight: .black)).foregroundStyle(.white)
                Text("@\(username.isEmpty ? "skater" : username)")
                    .font(.title3.weight(.black)).foregroundStyle(.orange)
                HStack(spacing: 8) { statPill(stance.rawValue); statPill(skateStyle.rawValue) }
                    .padding(.top, 4)
            }
            Spacer()
            Button(action: createUser) {
                HStack(spacing: 10) {
                    Text("LET'S SKATE").font(.headline.weight(.black))
                    Text("🛹").font(.title3)
                }
                .frame(maxWidth: .infinity).padding(20)
                .background(Color.orange).foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .padding(.horizontal, 28).padding(.bottom, 52)
        }
    }

    // MARK: - Shared Helpers

    @ViewBuilder
    private func stepShell(title: String, subtitle: String, canContinue: Bool,
                           @ViewBuilder content: () -> some View) -> some View {
        VStack(spacing: 0) {
            stepHeader(title: title, subtitle: subtitle)
            Spacer(); content(); Spacer()
            nextButton(canContinue: canContinue) { next() }
                .padding(.horizontal, 28).padding(.bottom, 52)
        }
    }

    @ViewBuilder
    private func stepHeader(title: String, subtitle: String = "") -> some View {
        VStack(spacing: 0) {
            if step > 1 {
                HStack {
                    Button(action: back) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left").fontWeight(.semibold)
                            Text("Back")
                        }
                        .font(.subheadline.weight(.semibold)).foregroundStyle(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 28).padding(.top, 100)
            } else {
                Spacer().frame(height: 110)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.system(size: 36, weight: .black)).foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                if !subtitle.isEmpty {
                    Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28).padding(.top, step > 1 ? 16 : 0).padding(.bottom, 24)
        }
    }

    @ViewBuilder
    private func nextButton(label: String = "NEXT  →", canContinue: Bool = true, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label).font(.headline.weight(.black))
                .frame(maxWidth: .infinity).padding(18)
                .background(canContinue ? Color.orange : Color.white.opacity(0.1))
                .foregroundStyle(canContinue ? Color.black : Color.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(!canContinue)
    }

    @ViewBuilder
    private func optionRow(_ label: String, palette: [String], sel: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            catLabel(label)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(palette.indices, id: \.self) { i in
                        Button { sel.wrappedValue = i } label: {
                            Circle().fill(Color(hex: palette[i])).frame(width: 34, height: 34)
                                .overlay(Circle().stroke(Color.orange, lineWidth: sel.wrappedValue == i ? 3 : 0))
                                .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                                .scaleEffect(sel.wrappedValue == i ? 1.15 : 1.0)
                                .animation(.spring(response: 0.25), value: sel.wrappedValue)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func chipRow(_ label: String, names: [String], sel: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            catLabel(label)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(names.indices, id: \.self) { i in
                        Button { sel.wrappedValue = i } label: {
                            Text(names[i]).font(.system(size: 12, weight: .semibold))
                                .padding(.horizontal, 14).padding(.vertical, 8)
                                .background(sel.wrappedValue == i ? Color.orange : Color.white.opacity(0.1))
                                .foregroundStyle(sel.wrappedValue == i ? Color.black : Color.white)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
    }

    private func catLabel(_ text: String) -> some View {
        Text(text.uppercased()).font(.system(size: 10, weight: .black))
            .foregroundStyle(.secondary)
    }

    private func statPill(_ text: String) -> some View {
        Text(text).font(.system(size: 12, weight: .bold))
            .padding(.horizontal, 12).padding(.vertical, 5)
            .background(Color.white.opacity(0.1)).foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

// MARK: - Category Enums

enum AvatarCategory: String, CaseIterable {
    case look  = "LOOK"
    case hair  = "HAIR"
    case fit   = "FIT"
    case kicks = "KICKS"

    var icon: String {
        switch self {
        case .look:  return "face.smiling"
        case .hair:  return "comb.fill"
        case .fit:   return "tshirt.fill"
        case .kicks: return "shoe.fill"
        }
    }
}

enum BoardCategory: String, CaseIterable {
    case deck   = "DECK"
    case grip   = "GRIP"
    case trucks = "TRUCKS"
    case wheels = "WHEELS"

    var icon: String {
        switch self {
        case .deck:   return "rectangle.portrait.fill"
        case .grip:   return "square.grid.3x3.fill"
        case .trucks: return "wrench.and.screwdriver.fill"
        case .wheels: return "circle.fill"
        }
    }
}

// MARK: - Urban Backdrop

private struct UrbanBackdrop: View {
    var body: some View {
        Canvas { ctx, size in
            // Subtle concrete wall texture - horizontal lines
            let lineColor = GraphicsContext.Shading.color(.white.opacity(0.018))
            let lineStep: CGFloat = 22
            var y: CGFloat = 0
            while y < size.height {
                var p = Path()
                p.move(to: CGPoint(x: 0, y: y))
                p.addLine(to: CGPoint(x: size.width, y: y))
                ctx.stroke(p, with: lineColor, lineWidth: 1)
                y += lineStep
            }
            // Vertical accent lines (right wall edge suggestion)
            for x in Swift.stride(from: size.width * 0.72, through: size.width * 0.72 + 3, by: 3) {
                var vp = Path()
                vp.move(to: CGPoint(x: x, y: 0))
                vp.addLine(to: CGPoint(x: x, y: size.height))
                ctx.stroke(vp, with: .color(.white.opacity(0.03)), lineWidth: 1)
            }
            // Bottom gradient shadow to ground
            ctx.fill(Path(CGRect(x: 0, y: size.height * 0.75, width: size.width, height: size.height * 0.25)),
                     with: .color(.black.opacity(0.35)))
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Skater Character View (game-quality illustration)

struct SkaterCharacterView: View {
    let avatar: AvatarData
    var size: CGFloat = 200

    private var sc: CGFloat { size / 200 }

    private var skinC: Color { Color(hex: AvatarData.skinPalette[safe: avatar.skinToneIndex] ?? "#FDDCB0") }
    private var hairC: Color { Color(hex: AvatarData.hairPalette[safe: avatar.hairColorIndex] ?? "#1A1A1A") }
    private var topC:  Color { Color(hex: AvatarData.clothesPalette[safe: avatar.topColorIndex] ?? "#E74C3C") }
    private var pantsC: Color { Color(hex: AvatarData.clothesPalette[safe: avatar.pantsColorIndex] ?? "#2C3E50") }
    private var shoeC:  Color { Color(hex: AvatarData.clothesPalette[safe: avatar.shoeColorIndex] ?? "#7F8C8D") }

    var body: some View {
        ZStack(alignment: .topLeading) {
            // ── Layer 0: board (behind body, left side) ──
            boardInHand
                .offset(x: 0 * sc, y: 126 * sc)

            // ── Layer 1: right arm (behind torso) ──
            armView(isLeft: false)
                .offset(x: 102 * sc, y: 80 * sc)

            // ── Layer 2: long hair behind head ──
            if avatar.hairStyle == 3 {
                longHairBehind
                    .offset(x: 41 * sc, y: 22 * sc)
            }

            // ── Layer 3: main body column ──
            bodyColumn
                .offset(x: 32 * sc, y: 72 * sc)

            // ── Layer 4: left arm (in front, holds board) ──
            armView(isLeft: true)
                .offset(x: 14 * sc, y: 80 * sc)

            // ── Layer 5: neck ──
            Capsule()
                .fill(skinC)
                .frame(width: 14 * sc, height: 12 * sc)
                .offset(x: 56 * sc, y: 68 * sc)

            // ── Layer 6: head + face ──
            headWithFace
                .offset(x: 36 * sc, y: 14 * sc)

            // ── Layer 7: hair (on top) ──
            hairView
        }
        .frame(width: 140 * sc, height: size)
    }

    // MARK: Board

    private var boardInHand: some View {
        ZStack {
            // Deck — side-on view showing edge + slight face
            BoardSideShape()
                .fill(
                    LinearGradient(colors: [topC.opacity(0.15), Color(hex: "#3498DB").opacity(0.6)],
                                   startPoint: .leading, endPoint: .trailing)
                )
                .frame(width: 16 * sc, height: 72 * sc)
            // Deck top edge color
            RoundedRectangle(cornerRadius: 2 * sc)
                .fill(Color(hex: "#1A1A1A"))
                .frame(width: 4 * sc, height: 72 * sc)
                .offset(x: -6 * sc)
            // Two trucks (horizontal nubs)
            ForEach([0.12, 0.78], id: \.self) { frac in
                RoundedRectangle(cornerRadius: 1.5 * sc)
                    .fill(Color(hex: "#C0C0C0"))
                    .frame(width: 22 * sc, height: 5 * sc)
                    .offset(x: 3 * sc, y: (CGFloat(frac) * 72 - 36) * sc)
            }
            // Wheels (4)
            ForEach(0..<4) { i in
                Circle()
                    .fill(Color.white.opacity(0.85))
                    .frame(width: 8 * sc, height: 8 * sc)
                    .overlay(Circle().fill(Color.gray.opacity(0.4)).frame(width: 4 * sc, height: 4 * sc))
                    .offset(x: (i < 2 ? -8 : 8) * sc,
                            y: (i % 2 == 0 ? -22 : 22) * sc)
            }
        }
        .frame(width: 24 * sc, height: 72 * sc)
    }

    // MARK: Arm

    private func armView(isLeft: Bool) -> some View {
        let sleeveC = topC
        let toeAngle: CGFloat = isLeft ? -4 : 4
        return VStack(spacing: 0) {
            // Upper arm / sleeve
            RoundedRectangle(cornerRadius: 7 * sc)
                .fill(sleeveC)
                .fill(
                    LinearGradient(
                        colors: [sleeveC, sleeveC.opacity(0.8)],
                        startPoint: isLeft ? .leading : .trailing,
                        endPoint: isLeft ? .trailing : .leading
                    )
                )
                .frame(width: 18 * sc, height: 42 * sc)
            // Forearm (skin — cuff rolls up slightly)
            RoundedRectangle(cornerRadius: 6 * sc)
                .fill(skinC)
                .frame(width: 15 * sc, height: 32 * sc)
            // Cuff detail
            RoundedRectangle(cornerRadius: 3 * sc)
                .fill(sleeveC.opacity(0.6))
                .frame(width: 16 * sc, height: 7 * sc)
                .offset(y: -28 * sc)
            // Hand
            RoundedRectangle(cornerRadius: 5 * sc)
                .fill(skinC)
                .frame(width: 13 * sc, height: 12 * sc)
        }
        .rotationEffect(.degrees(toeAngle))
        .frame(width: 20 * sc, height: 90 * sc)
    }

    // MARK: Long Hair (behind head)

    private var longHairBehind: some View {
        RoundedRectangle(cornerRadius: 8 * sc)
            .fill(
                LinearGradient(
                    colors: [hairC, hairC.opacity(0.7)],
                    startPoint: .top, endPoint: .bottom
                )
            )
            .frame(width: 56 * sc, height: 95 * sc)
    }

    // MARK: Body Column (torso + waist + legs)

    private var bodyColumn: some View {
        VStack(spacing: 0) {
            // Hoodie body
            ZStack(alignment: .bottom) {
                // Main torso shape
                RoundedRectangle(cornerRadius: 6 * sc)
                    .fill(topC)
                    .overlay(
                        // Shading gradient for depth
                        RoundedRectangle(cornerRadius: 6 * sc)
                            .fill(
                                LinearGradient(
                                    colors: [.black.opacity(0.08), .clear, .black.opacity(0.12)],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                    )
                    .frame(width: 64 * sc, height: 62 * sc)

                // Kangaroo pocket
                RoundedRectangle(cornerRadius: 4 * sc)
                    .fill(topC.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4 * sc)
                            .stroke(topC.opacity(0.4), lineWidth: 0.8 * sc)
                    )
                    .frame(width: 34 * sc, height: 18 * sc)
                    .offset(y: -6 * sc)
            }

            // Waistband
            RoundedRectangle(cornerRadius: 2 * sc)
                .fill(pantsC.opacity(0.9))
                .frame(width: 62 * sc, height: 6 * sc)

            // Hips / belt area
            Rectangle()
                .fill(pantsC)
                .frame(width: 62 * sc, height: 8 * sc)

            // Legs (slightly baggy: wider at top, narrower at knee)
            HStack(spacing: 6 * sc) {
                legShape(isLeft: true)
                legShape(isLeft: false)
            }
            // Shoes
            HStack(spacing: 6 * sc) {
                shoeShape(isRight: false)
                shoeShape(isRight: true)
            }
        }
        .frame(width: 76 * sc)
    }

    private func legShape(isLeft: Bool) -> some View {
        ZStack(alignment: .top) {
            // Main leg — fraction-based taper
            TaperedRectangle(topFraction: 1.0, bottomFraction: 0.82, cornerRadius: 6)
                .fill(pantsC)
                .overlay(
                    TaperedRectangle(topFraction: 1.0, bottomFraction: 0.82, cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [.black.opacity(0.06), .clear, .black.opacity(0.09)],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                )
                .frame(width: 28 * sc, height: 40 * sc)
            // Center crease
            Rectangle()
                .fill(pantsC.opacity(0.55))
                .frame(width: 1 * sc, height: 34 * sc)
                .offset(y: 3 * sc)
            // Pant cuff
            RoundedRectangle(cornerRadius: 2 * sc)
                .fill(pantsC.opacity(0.7))
                .frame(width: 26 * sc, height: 4 * sc)
                .offset(y: 36 * sc)
        }
        .frame(width: 28 * sc, height: 40 * sc)
    }

    // MARK: Head + Face

    private var headWithFace: some View {
        ZStack {
            // Head shape (slightly taller than wide — more realistic)
            Ellipse()
                .fill(skinC)
                .overlay(
                    // Subtle jaw shadow
                    Ellipse().fill(
                        LinearGradient(
                            colors: [.black.opacity(0.06), .clear],
                            startPoint: .bottom, endPoint: .top
                        )
                    )
                )
                .frame(width: 52 * sc, height: 58 * sc)

            // Ears
            HStack(spacing: 0) {
                Ellipse().fill(skinC).frame(width: 9 * sc, height: 13 * sc)
                    .overlay(Ellipse().fill(skinC.opacity(0.6)).frame(width: 5 * sc, height: 8 * sc))
                Spacer().frame(width: 34 * sc)
                Ellipse().fill(skinC).frame(width: 9 * sc, height: 13 * sc)
                    .overlay(Ellipse().fill(skinC.opacity(0.6)).frame(width: 5 * sc, height: 8 * sc))
            }
            .offset(y: 2 * sc)

            // Face details via Canvas
            Canvas { ctx, csz in
                drawFace(ctx: ctx, size: csz)
            }
            .frame(width: 52 * sc, height: 58 * sc)
        }
        .frame(width: 68 * sc, height: 58 * sc)
    }

    private func drawFace(ctx: GraphicsContext, size: CGSize) {
        let s = size.height / 58
        let cx = size.width / 2
        let cy = size.height / 2

        let hairHex = AvatarData.hairPalette[safe: avatar.hairColorIndex] ?? "#1A1A1A"
        let browColor = GraphicsContext.Shading.color(Color(hex: hairHex))
        let skinDark = GraphicsContext.Shading.color(skinC.opacity(0.45))
        let whiteEye  = GraphicsContext.Shading.color(Color.white.opacity(0.95))
        let blackPupil = GraphicsContext.Shading.color(Color.black)
        let irisColor  = GraphicsContext.Shading.color(Color(hex: "#5D3A1A").opacity(0.85))
        let eyeHighlight = GraphicsContext.Shading.color(Color.white)

        // ── Eyebrows ──
        let leftEyeX  = cx - 11 * s
        let rightEyeX = cx + 11 * s
        let eyeY = cy - 4 * s

        var leftBrow = Path()
        leftBrow.move(to: CGPoint(x: leftEyeX - 8 * s, y: eyeY - 8 * s))
        leftBrow.addCurve(
            to: CGPoint(x: leftEyeX + 7 * s, y: eyeY - 7.5 * s),
            control1: CGPoint(x: leftEyeX - 3 * s, y: eyeY - 12 * s),
            control2: CGPoint(x: leftEyeX + 4 * s, y: eyeY - 10.5 * s))
        ctx.stroke(leftBrow, with: browColor,
                   style: StrokeStyle(lineWidth: 2.2 * s, lineCap: .round))

        var rightBrow = Path()
        rightBrow.move(to: CGPoint(x: rightEyeX - 7 * s, y: eyeY - 7.5 * s))
        rightBrow.addCurve(
            to: CGPoint(x: rightEyeX + 8 * s, y: eyeY - 8 * s),
            control1: CGPoint(x: rightEyeX - 4 * s, y: eyeY - 10.5 * s),
            control2: CGPoint(x: rightEyeX + 3 * s, y: eyeY - 12 * s))
        ctx.stroke(rightBrow, with: browColor,
                   style: StrokeStyle(lineWidth: 2.2 * s, lineCap: .round))

        // ── Eyes (white + iris + pupil + highlight) ──
        for ex in [leftEyeX, rightEyeX] {
            ctx.fill(Path(ellipseIn: CGRect(x: ex - 7.5 * s, y: eyeY - 4.5 * s,
                                            width: 15 * s, height: 9 * s)), with: whiteEye)
            ctx.fill(Path(ellipseIn: CGRect(x: ex - 4 * s, y: eyeY - 4 * s,
                                            width: 8 * s, height: 8 * s)), with: irisColor)
            ctx.fill(Path(ellipseIn: CGRect(x: ex - 2.5 * s, y: eyeY - 2.5 * s,
                                            width: 5 * s, height: 5 * s)), with: blackPupil)
            ctx.fill(Path(ellipseIn: CGRect(x: ex - 1 * s, y: eyeY - 3 * s,
                                            width: 2.2 * s, height: 2.2 * s)), with: eyeHighlight)
            // Eyelid line
            var lid = Path()
            lid.move(to: CGPoint(x: ex - 7.5 * s, y: eyeY))
            lid.addCurve(to: CGPoint(x: ex + 7.5 * s, y: eyeY),
                         control1: CGPoint(x: ex - 3 * s, y: eyeY - 5.5 * s),
                         control2: CGPoint(x: ex + 3 * s, y: eyeY - 5.5 * s))
            ctx.stroke(lid, with: .color(.black.opacity(0.65)),
                       style: StrokeStyle(lineWidth: 1.2 * s, lineCap: .round))
        }

        // ── Nose ──
        var nose = Path()
        nose.move(to: CGPoint(x: cx, y: cy + 1 * s))
        nose.addCurve(to: CGPoint(x: cx - 4 * s, y: cy + 9 * s),
                      control1: CGPoint(x: cx - 1 * s, y: cy + 5 * s),
                      control2: CGPoint(x: cx - 5 * s, y: cy + 7 * s))
        nose.addQuadCurve(to: CGPoint(x: cx + 4 * s, y: cy + 9 * s),
                          control: CGPoint(x: cx, y: cy + 11.5 * s))
        ctx.stroke(nose, with: skinDark,
                   style: StrokeStyle(lineWidth: 1.4 * s, lineCap: .round, lineJoin: .round))

        // ── Mouth ──
        var upper = Path()
        upper.move(to: CGPoint(x: cx - 8 * s, y: cy + 16 * s))
        upper.addCurve(to: CGPoint(x: cx, y: cy + 14 * s),
                       control1: CGPoint(x: cx - 4 * s, y: cy + 13.5 * s),
                       control2: CGPoint(x: cx - 1.5 * s, y: cy + 13 * s))
        upper.addCurve(to: CGPoint(x: cx + 8 * s, y: cy + 16 * s),
                       control1: CGPoint(x: cx + 1.5 * s, y: cy + 13 * s),
                       control2: CGPoint(x: cx + 4 * s, y: cy + 13.5 * s))
        ctx.stroke(upper, with: skinDark,
                   style: StrokeStyle(lineWidth: 1.2 * s, lineCap: .round))

        var lower = Path()
        lower.move(to: CGPoint(x: cx - 8 * s, y: cy + 16 * s))
        lower.addQuadCurve(to: CGPoint(x: cx + 8 * s, y: cy + 16 * s),
                           control: CGPoint(x: cx, y: cy + 21 * s))
        ctx.stroke(lower, with: .color(skinC.opacity(0.5)),
                   style: StrokeStyle(lineWidth: 1.8 * s, lineCap: .round))
    }

    // MARK: Shoes

    @ViewBuilder
    private func shoeShape(isRight: Bool) -> some View {
        let toeDir: CGFloat = isRight ? 1 : -1
        switch avatar.shoeStyleIndex {

        case 1: // High-top
            ZStack(alignment: .bottom) {
                // Shaft
                RoundedRectangle(cornerRadius: 4 * sc)
                    .fill(shoeC).frame(width: 26 * sc, height: 24 * sc)
                // Sole
                RoundedRectangle(cornerRadius: 3 * sc)
                    .fill(shoeC.opacity(0.75)).frame(width: 30 * sc, height: 9 * sc)
                // Sole bottom rubber
                RoundedRectangle(cornerRadius: 2 * sc)
                    .fill(.white.opacity(0.25)).frame(width: 30 * sc, height: 3 * sc)
                    .offset(y: 0)
                // Lace crosses (3 lines)
                VStack(spacing: 4 * sc) {
                    ForEach(0..<3, id: \.self) { _ in
                        Rectangle().fill(.white.opacity(0.3))
                            .frame(width: 14 * sc, height: 1 * sc)
                    }
                }
                .offset(y: -10 * sc)
            }
            .frame(width: 30 * sc, height: 24 * sc)

        case 2: // Vulc
            ZStack(alignment: .bottom) {
                Capsule().fill(shoeC).frame(width: 34 * sc, height: 10 * sc)
                    .overlay(Capsule().fill(.white.opacity(0.18)).frame(width: 34 * sc, height: 3 * sc))
                Ellipse().fill(shoeC.opacity(0.8))
                    .frame(width: 14 * sc, height: 10 * sc)
                    .offset(x: toeDir * 10 * sc, y: -2 * sc)
            }
            .frame(width: 34 * sc, height: 12 * sc)

        case 3: // Boot
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 5 * sc).fill(shoeC)
                    .frame(width: 22 * sc, height: 32 * sc)
                RoundedRectangle(cornerRadius: 3 * sc).fill(shoeC.opacity(0.7))
                    .frame(width: 30 * sc, height: 10 * sc)
                Rectangle().fill(.white.opacity(0.2)).frame(width: 14 * sc, height: 1 * sc)
                    .offset(y: -20 * sc)
                Rectangle().fill(.white.opacity(0.2)).frame(width: 14 * sc, height: 1 * sc)
                    .offset(y: -14 * sc)
            }
            .frame(width: 30 * sc, height: 32 * sc)

        case 4: // Slip-on
            ZStack(alignment: .bottom) {
                Capsule().fill(shoeC).frame(width: 32 * sc, height: 11 * sc)
                // Wavy seam
                Canvas { ctx, sz in
                    var p = Path()
                    p.move(to: CGPoint(x: 4, y: sz.height * 0.3))
                    p.addCurve(to: CGPoint(x: sz.width - 4, y: sz.height * 0.3),
                               control1: CGPoint(x: sz.width * 0.3, y: sz.height * 0.0),
                               control2: CGPoint(x: sz.width * 0.7, y: sz.height * 0.6))
                    ctx.stroke(p, with: .color(.white.opacity(0.25)),
                               style: StrokeStyle(lineWidth: 1, lineCap: .round))
                }
                .frame(width: 32 * sc, height: 11 * sc)
            }
            .frame(width: 32 * sc, height: 11 * sc)

        default: // Low-top (0)
            ZStack(alignment: .bottom) {
                // Main upper
                RoundedRectangle(cornerRadius: 4 * sc).fill(shoeC)
                    .frame(width: 30 * sc, height: 14 * sc)
                // Sole
                RoundedRectangle(cornerRadius: 3 * sc).fill(.white.opacity(0.2))
                    .frame(width: 31 * sc, height: 4 * sc)
                // Toe cap
                Ellipse().fill(shoeC.opacity(0.7))
                    .frame(width: 13 * sc, height: 10 * sc)
                    .offset(x: toeDir * 9 * sc, y: -2 * sc)
                // Laces (3 horizontal dashes)
                VStack(spacing: 2.5 * sc) {
                    ForEach(0..<3, id: \.self) { _ in
                        Rectangle().fill(.white.opacity(0.3)).frame(width: 10 * sc, height: 1 * sc)
                    }
                }
                .offset(y: -6 * sc)
            }
            .frame(width: 31 * sc, height: 14 * sc)
        }
    }

    // MARK: Hair

    @ViewBuilder
    private var hairView: some View {
        let hairTopY: CGFloat = hairYOffset
        switch avatar.hairStyle {

        case 1: // Curly / Afro — overlapping puffs
            ZStack {
                Circle().fill(hairC.opacity(0.85)).frame(width: 30 * sc, height: 30 * sc).offset(x: -16 * sc, y: 4 * sc)
                Circle().fill(hairC).frame(width: 38 * sc, height: 38 * sc)
                Circle().fill(hairC.opacity(0.85)).frame(width: 30 * sc, height: 30 * sc).offset(x: 16 * sc, y: 4 * sc)
                Circle().fill(hairC.opacity(0.9)).frame(width: 26 * sc, height: 26 * sc).offset(x: 0, y: -10 * sc)
                // Texture dots
                Canvas { ctx, sz in
                    for _ in 0..<25 {
                        let px = CGFloat.random(in: sz.width * 0.15...sz.width * 0.85)
                        let py = CGFloat.random(in: sz.height * 0.1...sz.height * 0.85)
                        ctx.fill(Path(ellipseIn: CGRect(x: px, y: py, width: 2, height: 2)),
                                 with: .color(hairC.opacity(0.5)))
                    }
                }
                .frame(width: 64 * sc, height: 50 * sc)
                .clipShape(Circle().scale(0.85))
            }
            .frame(width: 64 * sc, height: 50 * sc)
            .offset(x: 39 * sc, y: hairTopY)

        case 2: // Mohawk
            ZStack {
                // Shaved sides — just a thin strip visible
                RoundedRectangle(cornerRadius: 4 * sc)
                    .fill(hairC)
                    .frame(width: 12 * sc, height: 38 * sc)
                    .overlay(
                        LinearGradient(
                            colors: [hairC, hairC.opacity(0.6)],
                            startPoint: .bottom, endPoint: .top
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 4 * sc))
                    )
                // Mohawk fin highlight
                RoundedRectangle(cornerRadius: 2 * sc)
                    .fill(.white.opacity(0.1))
                    .frame(width: 4 * sc, height: 30 * sc)
            }
            .frame(width: 16 * sc, height: 38 * sc)
            .offset(x: 61 * sc, y: hairTopY - 30 * sc)

        case 3: // Long — top cap only (back handled separately)
            Capsule()
                .fill(LinearGradient(colors: [hairC, hairC.opacity(0.8)], startPoint: .top, endPoint: .bottom))
                .frame(width: 55 * sc, height: 14 * sc)
                .offset(x: 41 * sc, y: hairTopY + 2 * sc)

        case 4: // Snapback cap
            ZStack(alignment: .bottom) {
                // Crown
                RoundedRectangle(cornerRadius: 8 * sc)
                    .fill(hairC)
                    .frame(width: 58 * sc, height: 26 * sc)
                // Brim
                Capsule()
                    .fill(hairC.opacity(0.85))
                    .frame(width: 70 * sc, height: 8 * sc)
                    .offset(y: 4 * sc)
                // Stitching line on crown
                Rectangle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 1 * sc, height: 18 * sc)
                    .offset(y: -4 * sc)
                // Brim underside shadow
                Capsule()
                    .fill(.black.opacity(0.15))
                    .frame(width: 68 * sc, height: 4 * sc)
                    .offset(y: 7 * sc)
            }
            .frame(width: 72 * sc, height: 30 * sc)
            .offset(x: 32 * sc, y: hairTopY - 4 * sc)

        case 5: // Bald — just a shine highlight
            Ellipse()
                .fill(.white.opacity(0.06))
                .frame(width: 20 * sc, height: 8 * sc)
                .offset(x: 59 * sc, y: hairTopY + 6 * sc)

        default: // Short/Fade (0)
            ZStack {
                // Hair cap
                Capsule()
                    .fill(
                        LinearGradient(colors: [hairC, hairC.opacity(0.75)],
                                       startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 54 * sc, height: 20 * sc)
                // Side fade — slightly lighter strips on sides
                HStack(spacing: 42 * sc) {
                    Capsule()
                        .fill(hairC.opacity(0.5))
                        .frame(width: 6 * sc, height: 14 * sc)
                    Capsule()
                        .fill(hairC.opacity(0.5))
                        .frame(width: 6 * sc, height: 14 * sc)
                }
                .offset(y: 2 * sc)
            }
            .frame(width: 56 * sc, height: 20 * sc)
            .offset(x: 41 * sc, y: hairTopY)
        }
    }

    private var hairYOffset: CGFloat {
        switch avatar.hairStyle {
        case 1: return 2 * sc   // afro sits low on head
        case 2: return 14 * sc  // mohawk starts mid-head
        case 3: return 14 * sc  // long top
        case 4: return 10 * sc  // cap sits on head
        case 5: return 18 * sc  // bald shine on top of head
        default: return 10 * sc // short sits on crown
        }
    }
}

// MARK: - Custom Shapes

private struct BoardSideShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width, h = rect.height
        var p = Path()
        p.move(to: CGPoint(x: w / 2, y: 0))
        p.addCurve(to: CGPoint(x: w, y: h * 0.07),
                   control1: CGPoint(x: w * 0.85, y: 0),
                   control2: CGPoint(x: w, y: h * 0.03))
        p.addLine(to: CGPoint(x: w, y: h * 0.93))
        p.addCurve(to: CGPoint(x: w / 2, y: h),
                   control1: CGPoint(x: w, y: h * 0.97),
                   control2: CGPoint(x: w * 0.8, y: h))
        p.addCurve(to: CGPoint(x: 0, y: h * 0.93),
                   control1: CGPoint(x: w * 0.2, y: h),
                   control2: CGPoint(x: 0, y: h * 0.97))
        p.addLine(to: CGPoint(x: 0, y: h * 0.07))
        p.addCurve(to: CGPoint(x: w / 2, y: 0),
                   control1: CGPoint(x: 0, y: h * 0.03),
                   control2: CGPoint(x: w * 0.15, y: 0))
        p.closeSubpath()
        return p
    }
}

private struct TaperedRectangle: Shape {
    // Fractions of rect.width — topFraction=1.0 means full width at top
    let topFraction: CGFloat
    let bottomFraction: CGFloat
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        let cx = rect.midX
        let h  = rect.height
        let tw = rect.width * topFraction
        let bw = rect.width * bottomFraction
        let cr = min(cornerRadius, min(tw, bw) / 2)
        let tl = cx - tw / 2
        let tr = cx + tw / 2
        let bl = cx - bw / 2
        let br = cx + bw / 2
        var p = Path()
        p.move(to: CGPoint(x: tl + cr, y: 0))
        p.addLine(to: CGPoint(x: tr - cr, y: 0))
        p.addQuadCurve(to: CGPoint(x: tr, y: cr), control: CGPoint(x: tr, y: 0))
        p.addLine(to: CGPoint(x: br, y: h - cr))
        p.addQuadCurve(to: CGPoint(x: br - cr, y: h), control: CGPoint(x: br, y: h))
        p.addLine(to: CGPoint(x: bl + cr, y: h))
        p.addQuadCurve(to: CGPoint(x: bl, y: h - cr), control: CGPoint(x: bl, y: h))
        p.addLine(to: CGPoint(x: tl, y: cr))
        p.addQuadCurve(to: CGPoint(x: tl + cr, y: 0), control: CGPoint(x: tl, y: 0))
        p.closeSubpath()
        return p
    }
}

// MARK: - Skateboard Top View (unchanged)

struct SkateboardTopView: View {
    let board: BoardData
    var scale: CGFloat = 1.0

    private var deckC:  Color { Color(hex: BoardData.deckPalette[safe: board.deckColorIndex] ?? BoardData.deckPalette[0]) }
    private var truckC: Color { Color(hex: BoardData.truckPalette[safe: board.truckColorIndex] ?? BoardData.truckPalette[0]) }
    private var wheelC: Color { Color(hex: BoardData.wheelPalette[safe: board.wheelColorIndex] ?? BoardData.wheelPalette[0]) }

    private var dw: CGFloat { 88 * scale }
    private var dh: CGFloat { 200 * scale }
    private var truckY: CGFloat { dh * 0.30 }

    var body: some View {
        ZStack {
            DeckShape()
                .fill(Color.black.opacity(0.45))
                .frame(width: dw + 2 * scale, height: dh + 3 * scale)
                .offset(x: 1 * scale, y: 3 * scale)
                .blur(radius: 4 * scale)
            DeckShape().fill(deckC).frame(width: dw, height: dh)
            DeckShape()
                .fill(LinearGradient(
                    stops: [.init(color: .black.opacity(0.22), location: 0.0),
                            .init(color: .clear, location: 0.20),
                            .init(color: .clear, location: 0.80),
                            .init(color: .black.opacity(0.22), location: 1.0)],
                    startPoint: .leading, endPoint: .trailing))
                .frame(width: dw, height: dh)
            Text(BoardData.graphics[safe: board.deckGraphic] ?? "PHANTOM")
                .font(.system(size: 8 * scale, weight: .black, design: .rounded))
                .tracking(2 * scale)
                .foregroundStyle(Color.white.opacity(0.72))
                .shadow(color: .black.opacity(0.9), radius: 1.5 * scale)
                .rotationEffect(.degrees(-90))
                .offset(y: dh * 0.21)
            GripTapeView(gripIndex: board.gripTapeIndex, scale: scale)
                .frame(width: dw * 0.88, height: dh * 0.76)
                .clipShape(DeckShape())
                .offset(y: -dh * 0.07)
            boltGroup(yOffset: -truckY)
            boltGroup(yOffset:  truckY)
            ForEach([0, 1], id: \.self) { i in
                ZStack {
                    RoundedRectangle(cornerRadius: 2 * scale)
                        .fill(truckC.opacity(0.72))
                        .frame(width: dw * 1.22, height: 9 * scale)
                    Capsule().fill(truckC)
                        .frame(width: dw * 1.40, height: 4 * scale)
                    Circle().fill(truckC.opacity(0.45))
                        .frame(width: 5 * scale, height: 5 * scale)
                }
                .offset(y: (i == 0 ? -1 : 1) * truckY)
            }
            let xOff = dw * 0.73
            ForEach(0..<4) { i in
                ZStack {
                    Capsule().fill(wheelC).frame(width: 14 * scale, height: 24 * scale)
                    Circle().fill(Color.white.opacity(0.28)).frame(width: 5 * scale, height: 5 * scale)
                    Capsule().stroke(wheelC.opacity(0.35), lineWidth: 1.5 * scale)
                        .frame(width: 11 * scale, height: 21 * scale)
                }
                .offset(x: (i % 2 == 0 ? -xOff : xOff), y: (i < 2 ? -truckY : truckY))
            }
        }
        .frame(width: dw + 44 * scale, height: dh)
    }

    private func boltGroup(yOffset: CGFloat) -> some View {
        HStack(spacing: dw * 0.46) { boltDot; boltDot }.offset(y: yOffset)
    }
    private var boltDot: some View {
        ZStack {
            Circle().fill(truckC.opacity(0.68)).frame(width: 5.5 * scale, height: 5.5 * scale)
            Rectangle().fill(Color.black.opacity(0.45)).frame(width: 3 * scale, height: 0.8 * scale)
            Rectangle().fill(Color.black.opacity(0.45)).frame(width: 0.8 * scale, height: 3 * scale)
        }
    }
}

private struct DeckShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width, h = rect.height
        let noseR = w * 0.44, tailR = w * 0.40
        var p = Path()
        p.move(to: CGPoint(x: w / 2, y: 0))
        p.addCurve(to: CGPoint(x: w, y: noseR),
                   control1: CGPoint(x: w * 0.88, y: 0), control2: CGPoint(x: w, y: noseR * 0.30))
        p.addLine(to: CGPoint(x: w, y: h - tailR))
        p.addCurve(to: CGPoint(x: w / 2, y: h),
                   control1: CGPoint(x: w, y: h - tailR * 0.18), control2: CGPoint(x: w * 0.82, y: h))
        p.addCurve(to: CGPoint(x: 0, y: h - tailR),
                   control1: CGPoint(x: w * 0.18, y: h), control2: CGPoint(x: 0, y: h - tailR * 0.18))
        p.addLine(to: CGPoint(x: 0, y: noseR))
        p.addCurve(to: CGPoint(x: w / 2, y: 0),
                   control1: CGPoint(x: 0, y: noseR * 0.30), control2: CGPoint(x: w * 0.12, y: 0))
        p.closeSubpath()
        return p
    }
}

struct GripTapeView: View {
    let gripIndex: Int
    let scale: CGFloat

    private var bgColor: Color { Color(hex: BoardData.gripTapeBgColors[safe: gripIndex] ?? "#0A0A0A") }
    private var dotColor: Color {
        switch gripIndex {
        case 1: return Color.black.opacity(0.14)
        case 2: return Color(hex: "#CCFF40").opacity(0.14)
        case 3: return Color(hex: "#FF5A35").opacity(0.22)
        case 4: return Color(hex: "#6B5CE7").opacity(0.13)
        default: return Color.white.opacity(0.08)
        }
    }
    var body: some View {
        Canvas { context, size in
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(bgColor))
            let spacing: CGFloat = 3.4 * scale
            let dotR: CGFloat = 0.82 * scale
            var col = 0
            var xPos: CGFloat = spacing
            while xPos < size.width {
                let rowOffset: CGFloat = col % 2 == 0 ? 0 : spacing * 0.5
                var yPos = spacing + rowOffset
                while yPos < size.height {
                    context.fill(Path(ellipseIn: CGRect(x: xPos - dotR, y: yPos - dotR,
                                                        width: dotR * 2, height: dotR * 2)),
                                 with: .color(dotColor))
                    yPos += spacing
                }
                xPos += spacing
                col += 1
            }
        }
    }
}
