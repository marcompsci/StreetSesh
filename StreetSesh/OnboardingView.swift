import SwiftUI
import SwiftData

// MARK: - Main Coordinator

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var step = 0
    @State private var goingForward = true

    // Splash animation
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0

    // Form data
    @State private var username  = ""
    @State private var email     = ""
    @State private var ageText   = ""
    @State private var stance: Stance     = .regular
    @State private var skateStyle: SkateStyle = .street
    @State private var avatar = AvatarData()
    @State private var board  = BoardData()

    private let totalSteps = 8

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Progress dots (shown after splash)
            if step > 0 {
                VStack {
                    progressDots
                        .padding(.top, 56)
                    Spacer()
                }
                .transition(.opacity)
                .animation(.easeIn(duration: 0.3), value: step > 0)
            }

            // Step content
            Group {
                switch step {
                case 0: splashStep
                case 1: nameStep
                case 2: emailStep
                case 3: ageStep
                case 4: stanceStep
                case 5: styleStep
                case 6: avatarStep
                case 7: boardStep
                case 8: readyStep
                default: splashStep
                }
            }
            .id(step)
            .transition(
                goingForward
                ? .asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal:   .move(edge: .leading).combined(with: .opacity))
                : .asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal:   .move(edge: .trailing).combined(with: .opacity))
            )
        }
        .animation(.spring(response: 0.42, dampingFraction: 0.84), value: step)
    }

    // MARK: - Progress Dots

    private var progressDots: some View {
        HStack(spacing: 6) {
            ForEach(1...totalSteps, id: \.self) { i in
                Capsule()
                    .fill(i <= step ? Color.orange : Color.white.opacity(0.18))
                    .frame(width: i <= step ? 20 : 6, height: 6)
                    .animation(.spring(response: 0.3), value: step)
            }
        }
        .padding(.horizontal, 28)
    }

    // MARK: - Navigation

    private func next() {
        goingForward = true
        withAnimation(.spring(response: 0.42, dampingFraction: 0.84)) { step += 1 }
    }
    private func back() {
        goingForward = false
        withAnimation(.spring(response: 0.42, dampingFraction: 0.84)) { step -= 1 }
    }

    // MARK: - Create User

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

    // MARK: Splash (step 0)

    private var splashStep: some View {
        VStack(spacing: 0) {
            Spacer()
            // Wordmark
            VStack(spacing: -8) {
                Text("STREET")
                    .font(.system(size: 76, weight: .black, design: .default))
                    .foregroundStyle(.orange)
                Text("SESH")
                    .font(.system(size: 76, weight: .black, design: .default))
                    .foregroundStyle(.white)
            }
            .scaleEffect(logoScale)
            .opacity(logoOpacity)

            Text("The spot app skaters actually trust.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 12)
                .opacity(logoOpacity)

            Spacer()

            // Board icon
            Image(systemName: "skateboard.fill")
                .font(.system(size: 64))
                .foregroundStyle(.orange.opacity(0.85))
                .opacity(logoOpacity)
                .padding(.bottom, 60)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.58)) {
                logoScale   = 1.0
                logoOpacity = 1.0
            }
            Task {
                try? await Task.sleep(for: .seconds(2.6))
                next()
            }
        }
    }

    // MARK: Name (step 1)

    private var nameStep: some View {
        stepShell(
            title: "What do they\ncall you?",
            subtitle: "Your tag on the streets.",
            canContinue: !username.trimmingCharacters(in: .whitespaces).isEmpty
        ) {
            TextField(
                "",
                text: $username,
                prompt: Text("grindset_99").foregroundStyle(.secondary)
            )
            .font(.system(size: 30, weight: .bold))
            .foregroundStyle(.white)
            .autocorrectionDisabled()
            .multilineTextAlignment(.center)
            .padding(18)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 28)
        }
    }

    // MARK: Email (step 2)

    private var emailStep: some View {
        stepShell(
            title: "Drop your\nemail.",
            subtitle: "Account recovery only. We don't spam.",
            canContinue: email.contains("@") && email.contains(".")
        ) {
            TextField(
                "",
                text: $email,
                prompt: Text("you@example.com").foregroundStyle(.secondary)
            )
            .font(.system(size: 24, weight: .semibold))
            .foregroundStyle(.white)
            .autocorrectionDisabled()
            .multilineTextAlignment(.center)
            #if os(iOS)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            #endif
            .padding(18)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 28)
        }
    }

    // MARK: Age (step 3)

    private var ageStep: some View {
        stepShell(
            title: "How old\nare you?",
            subtitle: "Keeps content age-appropriate.",
            canContinue: Int(ageText) != nil
        ) {
            VStack(spacing: 16) {
                TextField(
                    "",
                    text: $ageText,
                    prompt: Text("18").foregroundStyle(.secondary)
                )
                .font(.system(size: 52, weight: .black))
                .foregroundStyle(.orange)
                #if os(iOS)
                .keyboardType(.numberPad)
                #endif
                .multilineTextAlignment(.center)
                .frame(width: 140)
                .padding(18)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                if let age = Int(ageText), age > 0 && age < 18 {
                    Label("Under-18 visibility limits apply.", systemImage: "lock.shield.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
        }
    }

    // MARK: Stance (step 4)

    private var stanceStep: some View {
        stepShell(
            title: "Regular\nor Goofy?",
            subtitle: "Which foot do you lead with?",
            canContinue: true
        ) {
            HStack(spacing: 14) {
                stanceCard(.regular)
                stanceCard(.goofy)
            }
            .padding(.horizontal, 28)
        }
    }

    @ViewBuilder
    private func stanceCard(_ s: Stance) -> some View {
        let selected = stance == s
        Button { stance = s } label: {
            VStack(spacing: 14) {
                // Foot diagram
                HStack(spacing: s == .regular ? 6 : -6) {
                    // Front foot (bigger)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(selected ? Color.orange : Color.white.opacity(0.3))
                        .frame(width: s == .regular ? 34 : 26, height: 20)
                    // Back foot (smaller)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(selected ? Color.orange.opacity(0.55) : Color.white.opacity(0.18))
                        .frame(width: s == .regular ? 26 : 34, height: 20)
                }
                .padding(.top, 6)

                Text(s.rawValue.uppercased())
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(selected ? .orange : .white)

                Text(s.footLabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(selected ? Color.orange.opacity(0.12) : Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(selected ? Color.orange : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: Style (step 5)

    private var styleStep: some View {
        stepShell(
            title: "What's\nyour vibe?",
            subtitle: "Pick the style that fits.",
            canContinue: true
        ) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(SkateStyle.allCases, id: \.self) { style in
                    styleCard(style)
                }
            }
            .padding(.horizontal, 24)
        }
    }

    @ViewBuilder
    private func styleCard(_ s: SkateStyle) -> some View {
        let selected = skateStyle == s
        Button { skateStyle = s } label: {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: s.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(selected ? .orange : .white)
                Text(s.rawValue.uppercased())
                    .font(.system(size: 15, weight: .black))
                    .foregroundStyle(selected ? .orange : .white)
                Text(s.tagline)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(selected ? Color.orange.opacity(0.14) : Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(selected ? Color.orange : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: Avatar (step 6)

    private var avatarStep: some View {
        VStack(spacing: 0) {
            stepHeader(title: "Build your\nskater.")
            // Character preview
            ZStack {
                Color.white.opacity(0.04)
                SkaterCharacterView(avatar: avatar)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(height: 220)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    pickerRow("Skin Tone", palette: AvatarData.skinPalette, selection: $avatar.skinToneIndex)
                    // Hair style chips
                    VStack(alignment: .leading, spacing: 10) {
                        sectionLabel("Hair Style")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(AvatarData.hairStyleNames.indices, id: \.self) { i in
                                    Button { avatar.hairStyle = i } label: {
                                        Text(AvatarData.hairStyleNames[i])
                                            .font(.system(size: 12, weight: .semibold))
                                            .padding(.horizontal, 14).padding(.vertical, 8)
                                            .background(avatar.hairStyle == i ? Color.orange : Color.white.opacity(0.1))
                                            .foregroundStyle(avatar.hairStyle == i ? .black : .white)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }
                    pickerRow("Hair Color",  palette: AvatarData.hairPalette,    selection: $avatar.hairColorIndex)
                    pickerRow("Top Color",   palette: AvatarData.clothesPalette, selection: $avatar.topColorIndex)
                    pickerRow("Pants Color", palette: AvatarData.clothesPalette, selection: $avatar.pantsColorIndex)
                    pickerRow("Shoe Color",  palette: AvatarData.clothesPalette, selection: $avatar.shoeColorIndex)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }

            nextButton(label: "LOOKING GOOD →") { next() }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
        }
    }

    // MARK: Board (step 7)

    private var boardStep: some View {
        VStack(spacing: 0) {
            stepHeader(title: "Set up your\nboard.")
            // Board preview
            ZStack {
                Color.white.opacity(0.04)
                SkateboardTopView(board: board)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(height: 230)
            .padding(.horizontal, 24)
            .padding(.bottom, 16)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    pickerRow("Deck Color", palette: BoardData.deckPalette, selection: $board.deckColorIndex)
                    // Deck graphic chips
                    VStack(alignment: .leading, spacing: 10) {
                        sectionLabel("Graphic")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(BoardData.graphics.indices, id: \.self) { i in
                                    Button { board.deckGraphic = i } label: {
                                        Text(BoardData.graphics[i])
                                            .font(.system(size: 22))
                                            .frame(width: 46, height: 46)
                                            .background(board.deckGraphic == i ? Color.orange.opacity(0.25) : Color.white.opacity(0.08))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(board.deckGraphic == i ? Color.orange : Color.clear, lineWidth: 2)
                                            )
                                    }
                                }
                            }
                        }
                    }
                    // Truck color chips
                    VStack(alignment: .leading, spacing: 10) {
                        sectionLabel("Trucks")
                        HStack(spacing: 8) {
                            ForEach(BoardData.truckNames.indices, id: \.self) { i in
                                Button { board.truckColorIndex = i } label: {
                                    Text(BoardData.truckNames[i])
                                        .font(.system(size: 12, weight: .semibold))
                                        .padding(.horizontal, 14).padding(.vertical, 8)
                                        .background(board.truckColorIndex == i ? Color.orange : Color.white.opacity(0.1))
                                        .foregroundStyle(board.truckColorIndex == i ? .black : .white)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                    pickerRow("Wheels", palette: BoardData.wheelPalette, selection: $board.wheelColorIndex)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }

            nextButton(label: "READY →") { next() }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
        }
    }

    // MARK: Ready (step 8)

    private var readyStep: some View {
        VStack(spacing: 0) {
            Spacer()

            // Combined preview
            HStack(alignment: .bottom, spacing: 32) {
                SkaterCharacterView(avatar: avatar, size: 160)
                SkateboardTopView(board: board, scale: 0.62)
            }
            .padding(.bottom, 28)

            // Identity
            VStack(spacing: 6) {
                Text("You're locked in.")
                    .font(.system(size: 38, weight: .black))
                    .foregroundStyle(.white)
                Text("@\(username.isEmpty ? "skater" : username)")
                    .font(.title3.weight(.black))
                    .foregroundStyle(.orange)
                HStack(spacing: 8) {
                    statPill(stance.rawValue)
                    statPill(skateStyle.rawValue)
                }
                .padding(.top, 4)
            }

            Spacer()

            Button(action: createUser) {
                HStack(spacing: 10) {
                    Text("LET'S SKATE")
                        .font(.headline.weight(.black))
                    Text("🛹")
                        .font(.title3)
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(Color.orange)
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 52)
        }
    }

    // MARK: - Shared UI Helpers

    @ViewBuilder
    private func stepShell(
        title: String,
        subtitle: String,
        canContinue: Bool,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(spacing: 0) {
            stepHeader(title: title, subtitle: subtitle)
            Spacer()
            content()
            Spacer()
            nextButton(canContinue: canContinue) { next() }
                .padding(.horizontal, 28)
                .padding(.bottom, 52)
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
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 28)
                .padding(.top, 100)
            } else {
                Spacer().frame(height: 110)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 36, weight: .black))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28)
            .padding(.top, step > 1 ? 16 : 0)
            .padding(.bottom, 24)
        }
    }

    @ViewBuilder
    private func nextButton(label: String = "NEXT  →", canContinue: Bool = true, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.headline.weight(.black))
                .frame(maxWidth: .infinity)
                .padding(18)
                .background(canContinue ? Color.orange : Color.white.opacity(0.1))
                .foregroundStyle(canContinue ? Color.black : Color.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(!canContinue)
    }

    @ViewBuilder
    private func pickerRow(_ label: String, palette: [String], selection: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionLabel(label)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(palette.indices, id: \.self) { i in
                        Button { selection.wrappedValue = i } label: {
                            Circle()
                                .fill(Color(hex: palette[i]))
                                .frame(width: 34, height: 34)
                                .overlay(
                                    Circle()
                                        .stroke(Color.orange, lineWidth: selection.wrappedValue == i ? 3 : 0)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                )
                                .scaleEffect(selection.wrappedValue == i ? 1.15 : 1.0)
                                .animation(.spring(response: 0.25), value: selection.wrappedValue)
                        }
                    }
                }
            }
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.system(size: 10, weight: .black))
            .foregroundStyle(.secondary)
    }

    private func statPill(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .bold))
            .padding(.horizontal, 12).padding(.vertical, 5)
            .background(Color.white.opacity(0.1))
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}

// MARK: - Skater Character View

struct SkaterCharacterView: View {
    let avatar: AvatarData
    var size: CGFloat = 200  // total height

    private var sc: CGFloat { size / 200 }

    private var skinC: Color { Color(hex: AvatarData.skinPalette[safe: avatar.skinToneIndex] ?? AvatarData.skinPalette[0]) }
    private var hairC: Color { Color(hex: AvatarData.hairPalette[safe: avatar.hairColorIndex] ?? AvatarData.hairPalette[0]) }
    private var topC:  Color { Color(hex: AvatarData.clothesPalette[safe: avatar.topColorIndex] ?? AvatarData.clothesPalette[0]) }
    private var pantsC: Color { Color(hex: AvatarData.clothesPalette[safe: avatar.pantsColorIndex] ?? AvatarData.clothesPalette[8]) }
    private var shoeC:  Color { Color(hex: AvatarData.clothesPalette[safe: avatar.shoeColorIndex] ?? AvatarData.clothesPalette[7]) }

    var body: some View {
        ZStack(alignment: .top) {
            // Long hair goes behind everything
            if avatar.hairStyle == 3 {
                RoundedRectangle(cornerRadius: 8 * sc)
                    .fill(hairC)
                    .frame(width: 56 * sc, height: 90 * sc)
                    .offset(y: hairTopOffset + 8 * sc)
            }

            VStack(spacing: 0) {
                // Hair on top of head
                hairOnTop
                    .frame(height: hairTopOffset)

                // Head
                ZStack {
                    Circle()
                        .fill(skinC)
                        .frame(width: 56 * sc, height: 56 * sc)
                    // Eyes
                    HStack(spacing: 12 * sc) {
                        Circle().fill(Color.black.opacity(0.75)).frame(width: 7 * sc, height: 7 * sc)
                        Circle().fill(Color.black.opacity(0.75)).frame(width: 7 * sc, height: 7 * sc)
                    }
                    .offset(y: -3 * sc)
                    // Smile
                    SmilePath()
                        .stroke(Color.black.opacity(0.45), lineWidth: 2 * sc)
                        .frame(width: 18 * sc, height: 7 * sc)
                        .offset(y: 10 * sc)
                }
                .offset(y: -hairTopOffset * 0.5)

                // Neck
                Rectangle()
                    .fill(skinC)
                    .frame(width: 14 * sc, height: 7 * sc)

                // Torso
                RoundedRectangle(cornerRadius: 6 * sc)
                    .fill(topC)
                    .frame(width: 60 * sc, height: 62 * sc)

                // Belt line
                Rectangle()
                    .fill(pantsC.opacity(0.7))
                    .frame(width: 60 * sc, height: 5 * sc)

                // Legs
                HStack(spacing: 5 * sc) {
                    RoundedRectangle(cornerRadius: 5 * sc).fill(pantsC)
                        .frame(width: 26 * sc, height: 65 * sc)
                    RoundedRectangle(cornerRadius: 5 * sc).fill(pantsC)
                        .frame(width: 26 * sc, height: 65 * sc)
                }

                // Shoes
                HStack(spacing: 5 * sc) {
                    RoundedRectangle(cornerRadius: 4 * sc).fill(shoeC)
                        .frame(width: 32 * sc, height: 15 * sc)
                    RoundedRectangle(cornerRadius: 4 * sc).fill(shoeC)
                        .frame(width: 32 * sc, height: 15 * sc)
                }
            }
        }
        .frame(width: 70 * sc, height: 215 * sc)
    }

    private var hairTopOffset: CGFloat {
        switch avatar.hairStyle {
        case 1: return 16 * sc  // curly
        case 2: return 32 * sc  // mohawk
        case 3: return 8 * sc   // long (minimal top)
        case 4: return 14 * sc  // beanie
        default: return 12 * sc
        }
    }

    @ViewBuilder
    private var hairOnTop: some View {
        switch avatar.hairStyle {
        case 1: // Curly
            Circle()
                .fill(hairC)
                .frame(width: 60 * sc, height: 34 * sc)
        case 2: // Mohawk
            RoundedRectangle(cornerRadius: 5 * sc)
                .fill(hairC)
                .frame(width: 14 * sc, height: 36 * sc)
        case 3: // Long (minimal top cap)
            Capsule()
                .fill(hairC)
                .frame(width: 56 * sc, height: 14 * sc)
        case 4: // Beanie
            RoundedRectangle(cornerRadius: 6 * sc)
                .fill(hairC)
                .frame(width: 58 * sc, height: 22 * sc)
        case 5: // Bald — no hair shown
            Color.clear
        default: // Short
            Capsule()
                .fill(hairC)
                .frame(width: 54 * sc, height: 16 * sc)
        }
    }
}

private struct SmilePath: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: 0))
        p.addQuadCurve(
            to: CGPoint(x: rect.width, y: 0),
            control: CGPoint(x: rect.width / 2, y: rect.height)
        )
        return p
    }
}

// MARK: - Skateboard Top View

struct SkateboardTopView: View {
    let board: BoardData
    var scale: CGFloat = 1.0

    private var deckC:  Color { Color(hex: BoardData.deckPalette[safe: board.deckColorIndex] ?? BoardData.deckPalette[0]) }
    private var truckC: Color { Color(hex: BoardData.truckPalette[safe: board.truckColorIndex] ?? BoardData.truckPalette[0]) }
    private var wheelC: Color { Color(hex: BoardData.wheelPalette[safe: board.wheelColorIndex] ?? BoardData.wheelPalette[0]) }

    private var dw: CGFloat { 88 * scale }
    private var dh: CGFloat { 200 * scale }

    var body: some View {
        ZStack {
            // Deck shape
            DeckShape()
                .fill(deckC)
                .frame(width: dw, height: dh)

            // Grip tape (dark overlay in center area)
            DeckShape()
                .fill(Color.black.opacity(0.55))
                .frame(width: dw * 0.84, height: dh * 0.76)

            // Deck graphic
            Text(BoardData.graphics[safe: board.deckGraphic] ?? "🔥")
                .font(.system(size: 30 * scale))

            // Truck bars
            ForEach([0, 1], id: \.self) { i in
                Capsule()
                    .fill(truckC)
                    .frame(width: dw * 1.28, height: 7 * scale)
                    .offset(y: (i == 0 ? -1 : 1) * dh * 0.29)
            }

            // Wheels — 4 corners
            let xOff = dw * 0.72
            let yOff = dh * 0.29
            ForEach(0..<4) { i in
                Capsule()
                    .fill(wheelC)
                    .frame(width: 20 * scale, height: 30 * scale)
                    .offset(
                        x: (i % 2 == 0 ? -xOff : xOff),
                        y: (i < 2 ? -yOff : yOff)
                    )
            }
        }
        .frame(width: dw + 40 * scale, height: dh)
    }
}

private struct DeckShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width, h = rect.height
        let cr = w * 0.48
        var p = Path()
        p.move(to: CGPoint(x: w / 2, y: 0))
        p.addCurve(
            to: CGPoint(x: w, y: cr),
            control1: CGPoint(x: w + cr * 0.55, y: 0),
            control2: CGPoint(x: w, y: 0)
        )
        p.addLine(to: CGPoint(x: w, y: h - cr * 0.88))
        p.addCurve(
            to: CGPoint(x: w / 2, y: h),
            control1: CGPoint(x: w, y: h),
            control2: CGPoint(x: w + cr * 0.4, y: h)
        )
        p.addCurve(
            to: CGPoint(x: 0, y: h - cr * 0.88),
            control1: CGPoint(x: -cr * 0.4, y: h),
            control2: CGPoint(x: 0, y: h)
        )
        p.addLine(to: CGPoint(x: 0, y: cr))
        p.addCurve(
            to: CGPoint(x: w / 2, y: 0),
            control1: CGPoint(x: 0, y: 0),
            control2: CGPoint(x: -cr * 0.55, y: 0)
        )
        p.closeSubpath()
        return p
    }
}
