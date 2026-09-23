import SwiftUI

// MARK: - Color Palette (on Color for direct use)

extension Color {
    static let skLime:   Color = Color(hex: "#CCFF40")   // electric lime — primary
    static let skCoral:  Color = Color(hex: "#FF5A35")   // coral — secondary
    static let skDark:   Color = Color(hex: "#0C0C0C")   // near-black bg
    static let skCard:   Color = Color(hex: "#181818")   // card surface
    static let skMuted:  Color = Color(hex: "#272727")   // muted elements
    static let skBorder: Color = Color(hex: "#303030")   // subtle borders
    static let skText:   Color = Color(hex: "#F0EDE8")   // off-white body text
    static let skSub:    Color = Color(hex: "#888888")   // secondary/muted text
}

// ShapeStyle extension so `.skLime` etc. work in foregroundStyle(_:) / fill(_:)

extension ShapeStyle where Self == Color {
    static var skLime:   Color { .init(hex: "#CCFF40") }
    static var skCoral:  Color { .init(hex: "#FF5A35") }
    static var skDark:   Color { .init(hex: "#0C0C0C") }
    static var skCard:   Color { .init(hex: "#181818") }
    static var skMuted:  Color { .init(hex: "#272727") }
    static var skBorder: Color { .init(hex: "#303030") }
    static var skText:   Color { .init(hex: "#F0EDE8") }
    static var skSub:    Color { .init(hex: "#888888") }
}

// MARK: - View Extensions

extension View {
    func skCard(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(Color.skCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    func skBorderCard(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(Color.skCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.skBorder, lineWidth: 1))
    }
}

extension Date {
    var skRelative: String {
        let interval = -timeIntervalSinceNow
        if interval < 60    { return "Just now" }
        if interval < 3600  { return "\(Int(interval / 60))m ago" }
        if interval < 86400 { return "\(Int(interval / 3600))h ago" }
        return "\(Int(interval / 86400))d ago"
    }

    var skTimeLabel: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

// MARK: - SKButton

struct SKButton: View {
    let title: String
    var style: Style = .primary
    var icon: String? = nil
    let action: () -> Void

    enum Style { case primary, secondary, ghost }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon).font(.subheadline.weight(.bold)) }
                Text(title).font(.system(size: 15, weight: .black))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(bg)
            .foregroundStyle(fg)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                style == .secondary
                    ? RoundedRectangle(cornerRadius: 12).stroke(Color.skLime, lineWidth: 1.5)
                    : nil
            )
        }
    }

    private var bg: Color {
        switch style {
        case .primary:   return .skLime
        case .secondary: return .clear
        case .ghost:     return Color.white.opacity(0.07)
        }
    }
    private var fg: Color {
        switch style {
        case .primary: return .black
        default:       return .skLime
        }
    }
}

// MARK: - SKTag

struct SKTag: View {
    let label: String
    var color: Color = .skLime
    var small: Bool  = false

    var body: some View {
        Text(label)
            .font(.system(size: small ? 9 : 10, weight: .semibold))
            .padding(.horizontal, small ? 8 : 10)
            .padding(.vertical, small ? 4 : 5)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

// MARK: - XPBar

struct SKXPBar: View {
    let progress: Double
    let xp: Int
    let xpMax: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("XP").font(.system(size: 10, weight: .black)).foregroundStyle(.skLime)
                Spacer()
                Text("\(xp) / \(xpMax)").font(.system(size: 10, weight: .medium)).foregroundStyle(.skSub)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4).fill(Color.skMuted).frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.skLime)
                        .frame(width: geo.size.width * min(max(progress, 0), 1), height: 6)
                        .animation(.easeInOut(duration: 0.6), value: progress)
                }
            }
            .frame(height: 6)
        }
    }
}

// MARK: - Mini Skater (AvatarStyle → shapes)

struct SKMiniSkater: View {
    let style: AvatarStyle
    var size: CGFloat = 60

    private var s: CGFloat { size }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Shoes
            HStack(spacing: s * 0.06) {
                shoe; shoe
            }
            // Legs
            HStack(spacing: s * 0.06) {
                leg; leg
            }
            .offset(y: -s * 0.08)
            // Body
            RoundedRectangle(cornerRadius: s * 0.07)
                .fill(Color(hex: style.top))
                .frame(width: s * 0.42, height: s * 0.38)
                .offset(y: -s * 0.36)
            // Head
            Circle()
                .fill(Color(hex: style.skinTone))
                .frame(width: s * 0.26, height: s * 0.26)
                .offset(y: -s * 0.72)
            // Hair
            Capsule()
                .fill(Color(hex: style.hairColor))
                .frame(width: s * 0.24, height: s * 0.1)
                .offset(y: -s * 0.84)
        }
        .frame(width: s * 0.55, height: s)
    }

    private var leg: some View {
        RoundedRectangle(cornerRadius: s * 0.04)
            .fill(Color(hex: style.pants))
            .frame(width: s * 0.17, height: s * 0.3)
    }

    private var shoe: some View {
        RoundedRectangle(cornerRadius: s * 0.03)
            .fill(Color(hex: style.shoes))
            .frame(width: s * 0.2, height: s * 0.09)
    }
}

// MARK: - Mini Board (SKBoard → shapes)

struct SKBoardMini: View {
    let accentHex: String
    var width: CGFloat  = 34
    var height: CGFloat = 80

    var body: some View {
        ZStack {
            // Deck
            RoundedRectangle(cornerRadius: width * 0.48)
                .fill(Color(hex: accentHex))
                .frame(width: width, height: height)
            // Trucks
            truckBar(yOffset: -height * 0.28)
            truckBar(yOffset:  height * 0.28)
            // Wheels
            wheel(x: -(width * 0.88), y: -height * 0.28)
            wheel(x:  (width * 0.88), y: -height * 0.28)
            wheel(x: -(width * 0.88), y:  height * 0.28)
            wheel(x:  (width * 0.88), y:  height * 0.28)
        }
    }

    private func truckBar(yOffset: CGFloat) -> some View {
        Capsule()
            .fill(Color(hex: "#888888").opacity(0.6))
            .frame(width: width * 1.65, height: 7)
            .offset(y: yOffset)
    }

    private func wheel(x: CGFloat, y: CGFloat) -> some View {
        Circle()
            .fill(Color.white.opacity(0.75))
            .frame(width: 9, height: 9)
            .offset(x: x, y: y)
    }
}

// MARK: - Room Illustration

struct SKRoomIllustration: View {
    let theme: HomeTheme
    let boardAccentHex: String
    let avatarStyle: AvatarStyle

    var body: some View {
        ZStack(alignment: .bottom) {
            // Wall
            LinearGradient(colors: theme.wallGradient, startPoint: .top, endPoint: .bottom)

            // Window (top-right)
            skWindow
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(14)

            // Board on wall (left side)
            SKBoardMini(accentHex: boardAccentHex, width: 18, height: 46)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding([.top, .leading], 16)

            // Floor stripe
            Rectangle()
                .fill(Color.black.opacity(0.2))
                .frame(height: 1.5)
                .padding(.bottom, 26)

            // Skater standing on floor
            SKMiniSkater(style: avatarStyle, size: 50)
                .padding(.bottom, 26)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var skWindow: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(theme.accent.opacity(0.06))
                .frame(width: 40, height: 32)
            RoundedRectangle(cornerRadius: 3)
                .stroke(theme.accent.opacity(0.22), lineWidth: 1)
                .frame(width: 40, height: 32)
            Rectangle().fill(theme.accent.opacity(0.1)).frame(width: 0.5, height: 32)
            Rectangle().fill(theme.accent.opacity(0.1)).frame(width: 40, height: 0.5)
        }
    }
}

// MARK: - Section Header

struct SKSectionHeader: View {
    let title: String
    var action: (() -> Void)? = nil
    var actionLabel: String = "See All"

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 11, weight: .black))
                .tracking(1)
                .foregroundStyle(.skSub)
            Spacer()
            if let action {
                Button(actionLabel, action: action)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.skLime)
            }
        }
    }
}

// MARK: - Difficulty badge

struct SKDifficultyBadge: View {
    let difficulty: SpotDifficulty
    var body: some View {
        Text(difficulty.rawValue.uppercased())
            .font(.system(size: 9, weight: .black))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(difficulty.color.opacity(0.2))
            .foregroundStyle(difficulty.color)
            .clipShape(Capsule())
    }
}
