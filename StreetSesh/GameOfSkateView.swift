import SwiftUI

// MARK: - Game of S.K.A.T.E — Pokémon-Go style live challenge

struct GameOfSkateView: View {
    @EnvironmentObject private var appState: SkateCityAppState
    @Environment(\.dismiss)  private var dismiss

    @State private var phase:          GameOfSkatePhase = .browse
    @State private var selectedSkater: NearbySkater?    = nil
    @State private var coinResult:     CoinFace?        = nil
    @State private var pickedSpot:     String           = ""
    @State private var activeMatch:    SKATEMatchRecord? = nil
    @State private var sweepAngle:     Double           = 0

    private let skaters = SKMockData.nearbySkaters
    private let myHandle: String = "@you"

    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#060A10").ignoresSafeArea()

            VStack(spacing: 0) {
                navBar
                radarSection
                Divider().background(Color.skBorder.opacity(0.5))
                nearbyListSection
            }

            // Phase overlays
            phaseOverlay
        }
        .animation(.spring(response: 0.38, dampingFraction: 0.82), value: phase)
        .onAppear {
            withAnimation(.linear(duration: 3.5).repeatForever(autoreverses: false)) {
                sweepAngle = 360
            }
            // Simulate an incoming challenge after 4s if still browsing
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                if phase == .browse, let challenger = skaters.first {
                    withAnimation { phase = .incomingChallenge(challenger.id) }
                }
            }
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
            }
            Spacer()
            VStack(spacing: 2) {
                Text("GAME OF S.K.A.T.E")
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(.white)
                HStack(spacing: 5) {
                    Circle().fill(Color.skCoral).frame(width: 5, height: 5)
                    Text("\(skaters.filter(\.isChallengeable).count) SKATERS LIVE NEAR YOU")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(Color.skCoral)
                }
            }
            Spacer()
            // Match tracker button if active
            if case .matchActive = phase, let match = activeMatch {
                Button {
                    withAnimation { phase = .matchActive }
                } label: {
                    Text("MATCH")
                        .font(.system(size: 9, weight: .black))
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color(hex: "#C77DFF").opacity(0.2))
                        .foregroundStyle(Color(hex: "#C77DFF"))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color(hex: "#C77DFF").opacity(0.5), lineWidth: 1))
                }
                .opacity(match.isOver ? 0 : 1)
            } else {
                Color.clear.frame(width: 60)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Radar Section

    private var radarSection: some View {
        GeometryReader { geo in
            ZStack {
                Color(hex: "#060A10")

                // Street grid (faint background lines)
                streetGrid(size: geo.size)

                let cx = geo.size.width  / 2
                let cy = geo.size.height / 2
                let radius = min(cx, cy) - 28

                // Radar rings
                ForEach([0.33, 0.65, 1.0], id: \.self) { f in
                    Circle()
                        .stroke(Color.white.opacity(0.055), lineWidth: 1)
                        .frame(width: radius * 2 * f, height: radius * 2 * f)
                        .position(x: cx, y: cy)
                }

                // Range labels
                Text("0.5 mi")
                    .font(.system(size: 8))
                    .foregroundStyle(Color.white.opacity(0.18))
                    .position(x: cx + radius * 0.65, y: cy + 6)
                Text("1.0 mi")
                    .font(.system(size: 8))
                    .foregroundStyle(Color.white.opacity(0.18))
                    .position(x: cx + radius * 0.98, y: cy + 6)

                // Cardinal directions
                ForEach([(0.0, "N"), (90.0, "E"), (180.0, "S"), (270.0, "W")],
                        id: \.0) { (deg, label) in
                    let ang = (deg - 90) * .pi / 180
                    Text(label)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(Color.white.opacity(0.14))
                        .position(
                            x: cx + (radius + 16) * cos(ang),
                            y: cy + (radius + 16) * sin(ang)
                        )
                }

                // Radar sweep wedge
                radarSweep(center: CGPoint(x: cx, y: cy), radius: radius)

                // Skater pins
                ForEach(skaters) { skater in
                    let pos = radarPosition(skater: skater,
                                            center: CGPoint(x: cx, y: cy),
                                            radius: radius)
                    SkaterRadarPin(skater: skater,
                                   isSelected: selectedSkater?.id == skater.id)
                        .position(pos)
                        .onTapGesture {
                            guard phase == .browse || phase == .confirmChallenge else { return }
                            if skater.isChallengeable {
                                withAnimation {
                                    selectedSkater = skater
                                    phase = .confirmChallenge
                                }
                            }
                        }
                }

                // User pin (center)
                userCenterPin
                    .position(x: cx, y: cy)
            }
        }
        .frame(height: 340)
    }

    private func streetGrid(size: CGSize) -> some View {
        Canvas { ctx, s in
            let spacing: CGFloat = 36
            var x: CGFloat = 0
            while x <= s.width {
                var p = Path()
                p.move(to: CGPoint(x: x, y: 0))
                p.addLine(to: CGPoint(x: x, y: s.height))
                ctx.stroke(p, with: .color(Color.white.opacity(0.025)), lineWidth: 1)
                x += spacing
            }
            var y: CGFloat = 0
            while y <= s.height {
                var p = Path()
                p.move(to: CGPoint(x: 0, y: y))
                p.addLine(to: CGPoint(x: s.width, y: y))
                ctx.stroke(p, with: .color(Color.white.opacity(0.025)), lineWidth: 1)
                y += spacing
            }
        }
    }

    private func radarSweep(center: CGPoint, radius: CGFloat) -> some View {
        let startDeg = sweepAngle - 40
        return Path { p in
            p.move(to: center)
            p.addArc(center: center, radius: radius,
                     startAngle: .degrees(startDeg - 90),
                     endAngle:   .degrees(sweepAngle - 90),
                     clockwise: false)
            p.closeSubpath()
        }
        .fill(
            AngularGradient(
                gradient: Gradient(colors: [
                    Color.skLime.opacity(0.0),
                    Color.skLime.opacity(0.08)
                ]),
                center: .center,
                startAngle: .degrees(startDeg - 90),
                endAngle:   .degrees(sweepAngle - 90)
            )
        )
    }

    private var userCenterPin: some View {
        ZStack {
            PulsingRing(color: Color.skLime, baseSize: 56, maxScale: 2.4)
            Image("SSMapSticker")
                .resizable()
                .scaledToFit()
                .frame(width: 46, height: 46)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.skLime, lineWidth: 2)
                )
                .shadow(color: Color.skLime.opacity(0.7), radius: 8)
        }
    }

    private func radarPosition(skater: NearbySkater,
                               center: CGPoint,
                               radius: CGFloat) -> CGPoint {
        let angleRad = (skater.radarAngleDeg - 90) * .pi / 180
        let dist = radius * skater.radarNorm
        return CGPoint(
            x: center.x + dist * cos(angleRad),
            y: center.y + dist * sin(angleRad)
        )
    }

    // MARK: - Nearby List

    private var nearbyListSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("NEARBY SKATERS")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(Color.skSub)
                    .tracking(1)
                Spacer()
                Text("Tap a pin or row to challenge")
                    .font(.system(size: 9))
                    .foregroundStyle(Color.skSub.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 6) {
                    ForEach(skaters) { skater in
                        NearbySkaterRow(skater: skater,
                                        isSelected: selectedSkater?.id == skater.id)
                            .onTapGesture {
                                guard skater.isChallengeable else { return }
                                guard phase == .browse || phase == .confirmChallenge else { return }
                                withAnimation {
                                    selectedSkater = skater
                                    phase = .confirmChallenge
                                }
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Phase Overlay

    @ViewBuilder
    private var phaseOverlay: some View {
        switch phase {
        case .browse:
            EmptyView()

        case .confirmChallenge:
            if let sk = selectedSkater {
                confirmSheet(skater: sk)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

        case .challengeSent:
            challengeSentOverlay
                .transition(.opacity)

        case .incomingChallenge(let id):
            if let challenger = skaters.first(where: { $0.id == id }) {
                incomingBanner(skater: challenger)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

        case .coinFlip:
            if let sk = selectedSkater {
                Color.black.opacity(0.92).ignoresSafeArea()
                    .transition(.opacity)
                CoinFlipView(
                    challengerHandle: myHandle,
                    challengedHandle: sk.handle,
                    onResult: { face in
                        coinResult = face
                        withAnimation { phase = .locationPick }
                    }
                )
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }

        case .locationPick:
            if let face = coinResult, let sk = selectedSkater {
                locationPickSheet(coinFace: face, skater: sk)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

        case .matchActive:
            if let match = activeMatch {
                Color.clear.overlay(alignment: .bottom) {
                    matchTrackerBanner(match: match)
                        .padding(.bottom, 8)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }

    // MARK: - Confirm Sheet

    private func confirmSheet(skater: NearbySkater) -> some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                // Handle pill
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.skBorder)
                    .frame(width: 36, height: 4)
                    .padding(.top, 10)
                    .padding(.bottom, 16)

                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: skater.avatarColorHex).opacity(0.2))
                            .frame(width: 56, height: 56)
                        Text(skater.avatarInitial)
                            .font(.system(size: 22, weight: .black))
                            .foregroundStyle(Color(hex: skater.avatarColorHex))
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(skater.handle)
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                        HStack(spacing: 6) {
                            Image(systemName: "location.fill")
                                .font(.caption2)
                            Text(skater.distanceText)
                            Text("·")
                            Text(skater.statusText)
                        }
                        .font(.caption)
                        .foregroundStyle(Color.skSub)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

                // Challenge button
                Button {
                    withAnimation { phase = .challengeSent }
                    // Simulate acceptance after 2.5s
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation { phase = .coinFlip }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "flag.checkered")
                        Text("CHALLENGE TO S.K.A.T.E")
                            .font(.system(size: 16, weight: .black))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "#C77DFF"))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 20)

                Button { withAnimation { phase = .browse; selectedSkater = nil } } label: {
                    Text("Cancel")
                        .font(.subheadline)
                        .foregroundStyle(Color.skSub)
                        .padding(.vertical, 14)
                }
            }
            .background(Color.skCard)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Challenge Sent Overlay

    private var challengeSentOverlay: some View {
        VStack {
            Spacer()
            VStack(spacing: 16) {
                ProgressView()
                    .tint(Color(hex: "#C77DFF"))
                    .scaleEffect(1.4)
                Text("Challenge sent\nWaiting for response…")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(Color.skCard.opacity(0.95))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 24)
            Spacer()
        }
    }

    // MARK: - Incoming Challenge Banner

    private func incomingBanner(skater: NearbySkater) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hex: skater.avatarColorHex).opacity(0.2))
                    .frame(width: 44, height: 44)
                Text(skater.avatarInitial)
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(Color(hex: skater.avatarColorHex))
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("\(skater.handle) challenges you!")
                    .font(.subheadline.weight(.black))
                    .foregroundStyle(.white)
                Text("Game of S.K.A.T.E · \(skater.distanceText) away")
                    .font(.caption)
                    .foregroundStyle(Color.skSub)
            }
            Spacer()
            VStack(spacing: 4) {
                Button {
                    selectedSkater = skater
                    withAnimation { phase = .coinFlip }
                } label: {
                    Text("ACCEPT")
                        .font(.system(size: 10, weight: .black))
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(Color(hex: "#C77DFF"))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                Button {
                    withAnimation { phase = .browse }
                } label: {
                    Text("Decline")
                        .font(.system(size: 9))
                        .foregroundStyle(Color.skSub)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "#1C0E3A"))
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "#C77DFF").opacity(0.4), lineWidth: 1))
        )
        .padding(.horizontal, 14)
        .padding(.top, 60)
    }

    // MARK: - Location Pick Sheet

    private func locationPickSheet(coinFace: CoinFace, skater: NearbySkater) -> some View {
        let isMyPick = coinFace == .heads  // heads = challenger (@you) picks
        return VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.skBorder)
                    .frame(width: 36, height: 4)
                    .padding(.top, 10)
                    .padding(.bottom, 14)

                VStack(alignment: .leading, spacing: 4) {
                    Text(isMyPick ? "YOU PICK THE SPOT" : "\(skater.handle) picks the spot")
                        .font(.system(size: 11, weight: .black))
                        .foregroundStyle(coinFace == .heads ? Color(hex: "#FFD700") : Color.skSub)
                        .tracking(1)
                    Text(isMyPick
                         ? "Heads — you won the coin flip. Pick a spot to meet."
                         : "Tails — waiting for \(skater.handle) to pick a spot.")
                        .font(.caption)
                        .foregroundStyle(Color.skSub)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 14)

                Group {
                if isMyPick {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 6) {
                            ForEach(SKMockData.skateSpotOptions, id: \.self) { spot in
                                Button {
                                    pickedSpot = spot
                                    let match = SKATEMatchRecord(
                                        id: UUID(),
                                        challengerHandle: myHandle,
                                        challengedHandle: skater.handle,
                                        challengerLetters: [],
                                        challengedLetters: [],
                                        agreedSpotName: spot,
                                        coinResult: coinFace,
                                        startedAt: Date()
                                    )
                                    activeMatch = match
                                    withAnimation { phase = .matchActive }
                                    appState.earnXP(50)
                                } label: {
                                    HStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundStyle(Color(hex: "#C77DFF"))
                                        Text(spot)
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(.white)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundStyle(Color.skSub)
                                    }
                                    .padding(.horizontal, 16).padding(.vertical, 13)
                                    .background(Color.skMuted)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .frame(maxHeight: 280)
                } else {
                    // Waiting state
                    HStack {
                        ProgressView().tint(Color(hex: "#C77DFF"))
                        Text("Waiting for \(skater.handle) to choose…")
                            .font(.subheadline)
                            .foregroundStyle(Color.skSub)
                    }
                    .padding(20)
                    .onAppear {
                        // Auto-pick a spot after 2s to simulate opponent
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            let spot = SKMockData.skateSpotOptions.randomElement() ?? "Pier 7"
                            let match = SKATEMatchRecord(
                                id: UUID(),
                                challengerHandle: myHandle,
                                challengedHandle: skater.handle,
                                challengerLetters: [],
                                challengedLetters: [],
                                agreedSpotName: spot,
                                coinResult: coinFace,
                                startedAt: Date()
                            )
                            activeMatch = match
                            withAnimation { phase = .matchActive }
                            appState.earnXP(50)
                        }
                    }
                }
                } // Group
                .padding(.bottom, 20)
            }
            .background(Color.skCard)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Match Tracker Banner

    private func matchTrackerBanner(match: SKATEMatchRecord) -> some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "flag.checkered")
                    .foregroundStyle(Color(hex: "#C77DFF"))
                Text("MATCH IN PROGRESS")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(Color(hex: "#C77DFF"))
                    .tracking(1)
                Spacer()
                Text(match.agreedSpotName)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.skSub)
            }

            HStack(spacing: 0) {
                // Challenger (you)
                VStack(spacing: 4) {
                    Text(match.challengerHandle)
                        .font(.caption.weight(.black))
                        .foregroundStyle(Color.skLime)
                    Text(match.challengerDisplay)
                        .font(.system(size: 18, weight: .black, design: .monospaced))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)

                Text("VS")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(Color.skSub)
                    .frame(width: 30)

                // Challenged
                VStack(spacing: 4) {
                    Text(match.challengedHandle)
                        .font(.caption.weight(.black))
                        .foregroundStyle(Color(hex: "#3AB5E6"))
                    Text(match.challengedDisplay)
                        .font(.system(size: 18, weight: .black, design: .monospaced))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
            }

            // Letter buttons (simulate adding letters)
            if !match.isOver {
                HStack(spacing: 8) {
                    Button {
                        if var m = activeMatch {
                            let next = SKATEMatchRecord.letters[safe: m.challengerLetters.count]
                            if let l = next { m.challengerLetters.append(l) }
                            activeMatch = m
                            if m.challengerLetters.count == 5 { appState.earnXP(-50) }
                        }
                    } label: {
                        Text("I missed a trick")
                            .font(.system(size: 11, weight: .semibold))
                            .padding(.horizontal, 12).padding(.vertical, 7)
                            .background(Color.skCoral.opacity(0.15))
                            .foregroundStyle(Color.skCoral)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)

                    Button {
                        if var m = activeMatch {
                            let next = SKATEMatchRecord.letters[safe: m.challengedLetters.count]
                            if let l = next { m.challengedLetters.append(l) }
                            activeMatch = m
                            if m.challengedLetters.count == 5 { appState.earnXP(200) }
                        }
                    } label: {
                        Text("They missed")
                            .font(.system(size: 11, weight: .semibold))
                            .padding(.horizontal, 12).padding(.vertical, 7)
                            .background(Color.skLime.opacity(0.12))
                            .foregroundStyle(Color.skLime)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            } else {
                let youWon = (activeMatch?.challengedLetters.count == 5)
                Text(youWon ? "🏆 You won! +200 XP" : "Better luck next time")
                    .font(.subheadline.weight(.black))
                    .foregroundStyle(youWon ? Color.skLime : Color.skSub)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(hex: "#12082E"))
                .overlay(RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(hex: "#C77DFF").opacity(0.35), lineWidth: 1))
        )
        .padding(.horizontal, 12)
    }
}

// MARK: - Skater Radar Pin

struct SkaterRadarPin: View {
    let skater: NearbySkater
    let isSelected: Bool
    @State private var pulse: CGFloat = 1.0

    var body: some View {
        ZStack {
            PulsingRing(color: Color(hex: skater.avatarColorHex), baseSize: 28, maxScale: 2.2)

            // Pin circle
            Circle()
                .fill(Color(hex: skater.avatarColorHex).opacity(0.25))
                .frame(width: 30, height: 30)
                .overlay(
                    Circle().stroke(
                        skater.isChallengeable
                        ? Color(hex: skater.avatarColorHex)
                        : Color.skSub,
                        lineWidth: isSelected ? 2.5 : 1.5
                    )
                )

            Text(skater.avatarInitial)
                .font(.system(size: 12, weight: .black))
                .foregroundStyle(Color(hex: skater.avatarColorHex))

            // Not challengeable overlay
            if !skater.isChallengeable {
                Circle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 30, height: 30)
            }

            // Handle label below pin
            Text(skater.handle)
                .font(.system(size: 8, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 5).padding(.vertical, 2)
                .background(Color.black.opacity(0.65))
                .clipShape(Capsule())
                .offset(y: 24)
        }
        .scaleEffect(isSelected ? 1.15 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

// MARK: - Nearby Skater Row

struct NearbySkaterRow: View {
    let skater: NearbySkater
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hex: skater.avatarColorHex).opacity(0.18))
                    .frame(width: 42, height: 42)
                Text(skater.avatarInitial)
                    .font(.system(size: 17, weight: .black))
                    .foregroundStyle(Color(hex: skater.avatarColorHex))
            }
            .overlay(
                Circle().stroke(skater.isChallengeable
                                ? Color(hex: skater.avatarColorHex).opacity(0.5)
                                : Color.skBorder, lineWidth: 1.5)
            )

            VStack(alignment: .leading, spacing: 3) {
                Text(skater.handle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(skater.isChallengeable ? .white : Color.skSub)
                Text(skater.statusText)
                    .font(.caption)
                    .foregroundStyle(Color.skSub)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(skater.distanceText)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                if skater.isChallengeable {
                    Text("TAP TO CHALLENGE")
                        .font(.system(size: 8, weight: .black))
                        .foregroundStyle(Color(hex: "#C77DFF"))
                } else {
                    Text("On the move")
                        .font(.system(size: 8))
                        .foregroundStyle(Color.skSub)
                }
            }
        }
        .padding(.horizontal, 14).padding(.vertical, 11)
        .background(isSelected
                    ? Color(hex: "#C77DFF").opacity(0.1)
                    : Color.skCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected
                        ? Color(hex: "#C77DFF").opacity(0.4)
                        : Color.skBorder.opacity(0.5), lineWidth: 1)
        )
        .opacity(skater.isChallengeable ? 1.0 : 0.55)
    }
}

// MARK: - Pulsing Ring Helper

struct PulsingRing: View {
    let color: Color
    let baseSize: CGFloat
    let maxScale: CGFloat
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Circle()
            .stroke(color.opacity(0.35), lineWidth: 1.5)
            .frame(width: baseSize, height: baseSize)
            .scaleEffect(scale)
            .opacity(Double(maxScale + 1 - scale) / Double(maxScale))
            .onAppear {
                withAnimation(.easeOut(duration: 1.6).repeatForever(autoreverses: false)) {
                    scale = maxScale
                }
            }
    }
}
