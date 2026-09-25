import SwiftUI

// MARK: - Coin Flip View

struct CoinFlipView: View {
    let challengerHandle: String
    let challengedHandle: String
    var onResult: (CoinFace) -> Void

    @State private var showHeads:   Bool    = true
    @State private var scaleX:      CGFloat = 1
    @State private var isFlipping:  Bool    = false
    @State private var result:      CoinFace? = nil
    @State private var resultScale: CGFloat = 0

    var body: some View {
        ZStack {
            Color(hex: "#080C12").ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 6) {
                    Text("COIN FLIP")
                        .font(.system(size: 11, weight: .black))
                        .foregroundStyle(Color.skSub)
                        .tracking(5)

                    Text(isFlipping
                         ? "Flipping..."
                         : (result == nil ? "Determines who picks the spot" : ""))
                        .font(.caption)
                        .foregroundStyle(Color.skSub.opacity(0.6))
                        .animation(.easeInOut, value: isFlipping)
                }

                Spacer().frame(height: 40)

                // Coin
                ZStack {
                    if showHeads { CoinHeadsFace() } else { CoinTailsFace() }
                }
                .frame(width: 240, height: 240)
                .scaleEffect(x: scaleX, y: 1)
                .shadow(
                    color: (showHeads ? Color(hex: "#FFD700") : Color(hex: "#CCFF40")).opacity(0.35),
                    radius: 28
                )

                Spacer().frame(height: 44)

                // Result or CTA
                if let r = result {
                    resultPanel(r)
                        .transition(.scale(scale: 0.5).combined(with: .opacity))
                } else if !isFlipping {
                    flipButton
                        .transition(.opacity)
                }

                Spacer()
            }
        }
    }

    // MARK: - Subviews

    private func resultPanel(_ r: CoinFace) -> some View {
        VStack(spacing: 12) {
            Text(r.rawValue.uppercased())
                .font(.system(size: 56, weight: .black))
                .foregroundStyle(r == .heads ? Color(hex: "#FFD700") : Color(hex: "#C0C0C0"))
                .scaleEffect(resultScale)
                .onAppear {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.5)) {
                        resultScale = 1
                    }
                }

            Text(r == .heads
                 ? "@\(challengerHandle) picks the location"
                 : "@\(challengedHandle) picks the location")
                .font(.subheadline)
                .foregroundStyle(Color.skSub)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }

    private var flipButton: some View {
        Button { startFlip() } label: {
            HStack(spacing: 10) {
                Image(systemName: "circle.dotted")
                    .font(.title3)
                Text("FLIP THE COIN")
                    .font(.system(size: 17, weight: .black))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.skLime)
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.horizontal, 40)
    }

    // MARK: - Flip Logic

    private func startFlip() {
        isFlipping = true
        let totalFlips = Int.random(in: 8...14)
        let target: CoinFace = Bool.random() ? .heads : .tails
        runFlip(remaining: totalFlips, target: target)
    }

    private func runFlip(remaining: Int, target: CoinFace) {
        let speed: Double = remaining > 6 ? 0.07 : (remaining > 3 ? 0.13 : 0.3)

        withAnimation(.easeIn(duration: speed * 0.42)) { scaleX = 0.0 }

        DispatchQueue.main.asyncAfter(deadline: .now() + speed * 0.42) {
            showHeads.toggle()
            withAnimation(.easeOut(duration: speed * 0.58)) { scaleX = 1.0 }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
            if remaining <= 1 {
                let shouldShowHeads = (target == .heads)
                if showHeads != shouldShowHeads {
                    withAnimation(.easeIn(duration: 0.22)) { scaleX = 0 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                        showHeads = shouldShowHeads
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) { scaleX = 1 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            finishFlip(target)
                        }
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        finishFlip(target)
                    }
                }
            } else {
                runFlip(remaining: remaining - 1, target: target)
            }
        }
    }

    private func finishFlip(_ r: CoinFace) {
        isFlipping = false
        withAnimation(.spring(response: 0.35)) { result = r }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            onResult(r)
        }
    }
}

// MARK: - Heads Face (gold coin · skater doing kickflip)

struct CoinHeadsFace: View {
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2
            let r  = min(cx, cy) - 2

            // Base coin fill
            ctx.fill(Path(ellipseIn: CGRect(x: cx-r, y: cy-r, width: r*2, height: r*2)),
                     with: .color(Color(hex: "#C8900A")))

            // Inner highlight
            let hl = r * 0.72
            ctx.fill(Path(ellipseIn: CGRect(x: cx-hl, y: cy-hl, width: hl*2, height: hl*2)),
                     with: .color(Color(hex: "#E5A812").opacity(0.45)))

            // Outer ring
            ctx.stroke(Path(ellipseIn: CGRect(x: cx-r+2, y: cy-r+2, width: (r-2)*2, height: (r-2)*2)),
                       with: .color(Color(hex: "#FFD700")), lineWidth: 4)

            // Inner decorative ring
            let ir = r - 18
            ctx.stroke(Path(ellipseIn: CGRect(x: cx-ir, y: cy-ir, width: ir*2, height: ir*2)),
                       with: .color(Color(hex: "#A07000").opacity(0.45)), lineWidth: 1)

            let dark = Color(hex: "#180800")

            // Head
            ctx.fill(Path(ellipseIn: CGRect(x: cx-9, y: cy-54, width: 18, height: 18)),
                     with: .color(dark))

            // Torso
            var torso = Path()
            torso.move(to: CGPoint(x: cx, y: cy-36))
            torso.addLine(to: CGPoint(x: cx-2, y: cy+4))
            ctx.stroke(torso, with: .color(dark), style: StrokeStyle(lineWidth: 4, lineCap: .round))

            // Left arm (balance out)
            var lArm = Path()
            lArm.move(to: CGPoint(x: cx-1, y: cy-24))
            lArm.addLine(to: CGPoint(x: cx-28, y: cy-12))
            ctx.stroke(lArm, with: .color(dark), style: StrokeStyle(lineWidth: 3, lineCap: .round))

            // Right arm (up + back)
            var rArm = Path()
            rArm.move(to: CGPoint(x: cx-1, y: cy-24))
            rArm.addLine(to: CGPoint(x: cx+26, y: cy-36))
            ctx.stroke(rArm, with: .color(dark), style: StrokeStyle(lineWidth: 3, lineCap: .round))

            // Left leg (back foot, bent)
            var lLeg = Path()
            lLeg.move(to: CGPoint(x: cx-1, y: cy+4))
            lLeg.addLine(to: CGPoint(x: cx-15, y: cy+22))
            lLeg.addLine(to: CGPoint(x: cx-4,  y: cy+40))
            ctx.stroke(lLeg, with: .color(dark), style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))

            // Right leg (front foot, kicked out)
            var rLeg = Path()
            rLeg.move(to: CGPoint(x: cx-1, y: cy+4))
            rLeg.addLine(to: CGPoint(x: cx+22, y: cy+16))
            rLeg.addLine(to: CGPoint(x: cx+36, y: cy+8))
            ctx.stroke(rLeg, with: .color(dark), style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))

            // Board (diagonal flip position below skater)
            var board = Path()
            let bx: CGFloat = cx - 30
            let by: CGFloat = cy + 52
            board.move(to: CGPoint(x: bx,    y: by))
            board.addLine(to: CGPoint(x: bx+54, y: by-12))
            board.addLine(to: CGPoint(x: bx+54, y: by-5))
            board.addLine(to: CGPoint(x: bx,    y: by+7))
            board.closeSubpath()
            ctx.fill(board, with: .color(dark))

            // Wheels
            for wx in [bx + 8, bx + 44] as [CGFloat] {
                ctx.fill(Path(ellipseIn: CGRect(x: wx-5, y: by+3, width: 10, height: 8)),
                         with: .color(Color(hex: "#3A2800")))
            }

            // Truck lines
            ctx.stroke({
                var p = Path()
                p.move(to: CGPoint(x: bx+6,  y: by+1))
                p.addLine(to: CGPoint(x: bx+6,  y: by+10))
                p.move(to: CGPoint(x: bx+46, y: by-10))
                p.addLine(to: CGPoint(x: bx+46, y: by-1))
                return p
            }(), with: .color(Color(hex: "#5A3A00").opacity(0.7)), lineWidth: 1.5)

            // "HEADS" label at coin bottom
            ctx.draw(Text("HEADS")
                .font(.system(size: 9, weight: .black))
                .foregroundStyle(Color(hex: "#7A5200")),
                     at: CGPoint(x: cx, y: cy + r - 15), anchor: .center)
        }
        .clipShape(Circle())
    }
}

// MARK: - Tails Face (dark metallic coin · SK logo)

struct CoinTailsFace: View {
    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2
            let r  = min(cx, cy) - 2

            // Base
            ctx.fill(Path(ellipseIn: CGRect(x: cx-r, y: cy-r, width: r*2, height: r*2)),
                     with: .color(Color(hex: "#383838")))

            // Center highlight
            let hl = r * 0.72
            ctx.fill(Path(ellipseIn: CGRect(x: cx-hl, y: cy-hl, width: hl*2, height: hl*2)),
                     with: .color(Color(hex: "#505050").opacity(0.4)))

            // Outer ring
            ctx.stroke(Path(ellipseIn: CGRect(x: cx-r+2, y: cy-r+2, width: (r-2)*2, height: (r-2)*2)),
                       with: .color(Color(hex: "#C0C0C0")), lineWidth: 4)

            // Inner ring
            let ir = r - 18
            ctx.stroke(Path(ellipseIn: CGRect(x: cx-ir, y: cy-ir, width: ir*2, height: ir*2)),
                       with: .color(Color(hex: "#888888").opacity(0.35)), lineWidth: 1)

            // "SK" monogram — lime
            ctx.draw(Text("SK")
                .font(.system(size: 60, weight: .black, design: .rounded))
                .foregroundStyle(Color(hex: "#CCFF40")),
                     at: CGPoint(x: cx, y: cy - 4), anchor: .center)

            // "STREET SESH" under SK
            ctx.draw(Text("STREET SESH")
                .font(.system(size: 8, weight: .black))
                .foregroundStyle(Color(hex: "#777777")),
                     at: CGPoint(x: cx, y: cy + r - 15), anchor: .center)

            // "TAILS" at top
            ctx.draw(Text("TAILS")
                .font(.system(size: 9, weight: .black))
                .foregroundStyle(Color(hex: "#666666")),
                     at: CGPoint(x: cx, y: cy - r + 15), anchor: .center)

            // Mini skateboard at bottom
            var bd = Path()
            bd.move(to: CGPoint(x: cx-24, y: cy+54))
            bd.addLine(to: CGPoint(x: cx+24, y: cy+54))
            ctx.stroke(bd, with: .color(Color(hex: "#606060")), lineWidth: 2.5)
            for wx in [cx - 14, cx + 14] as [CGFloat] {
                ctx.fill(Path(ellipseIn: CGRect(x: wx-4, y: cy+51, width: 8, height: 7)),
                         with: .color(Color(hex: "#505050")))
            }
        }
        .clipShape(Circle())
    }
}
