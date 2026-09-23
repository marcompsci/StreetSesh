import Foundation

// MARK: - Stance

enum Stance: String, Codable, CaseIterable {
    case regular = "Regular"
    case goofy   = "Goofy"
    var footLabel: String {
        self == .regular ? "Left foot forward" : "Right foot forward"
    }
}

// MARK: - Skating Style

enum SkateStyle: String, Codable, CaseIterable {
    case street = "Street"
    case park   = "Park"
    case vert   = "Vert"
    case hesh   = "Hesh"
    case chill  = "Chill"
    case brute  = "Brute"

    var icon: String {
        switch self {
        case .street: return "road.lanes"
        case .park:   return "flame.fill"
        case .vert:   return "arrow.up.right.circle.fill"
        case .hesh:   return "bolt.fill"
        case .chill:  return "leaf.fill"
        case .brute:  return "hammer.fill"
        }
    }
    var tagline: String {
        switch self {
        case .street: return "Ledges, rails, stairs."
        case .park:   return "Bowls and smooth concrete."
        case .vert:   return "Airs above the coping."
        case .hesh:   return "Raw. Gnarly. Old school."
        case .chill:  return "Just vibing, no pressure."
        case .brute:  return "Heavy and powerful."
        }
    }
}

// MARK: - Avatar

struct AvatarData: Codable, Equatable {
    var skinToneIndex: Int   = 0
    var hairStyle: Int       = 0
    var hairColorIndex: Int  = 0
    var topColorIndex: Int   = 0
    var pantsColorIndex: Int = 8
    var shoeColorIndex: Int  = 7

    static let skinPalette: [String] = [
        "#FDDCB0", "#F3A96A", "#C68642", "#8D5524", "#4A2B19", "#FFE0C8"
    ]
    static let hairPalette: [String] = [
        "#1A1A1A", "#4A2912", "#8B4513", "#C8A165",
        "#F5C240", "#E8490F", "#A0A0A0", "#F0F0F0"
    ]
    static let clothesPalette: [String] = [
        "#E74C3C", "#E67E22", "#F1C40F", "#2ECC71",
        "#3498DB", "#9B59B6", "#1ABC9C", "#ECF0F1",
        "#2C3E50", "#7F8C8D"
    ]
    static let hairStyleNames: [String] = [
        "Short", "Curly", "Mohawk", "Long", "Beanie", "Bald"
    ]
}

// MARK: - Board

struct BoardData: Codable, Equatable {
    var deckColorIndex:  Int = 0
    var deckGraphic:     Int = 0
    var truckColorIndex: Int = 0
    var wheelColorIndex: Int = 0

    static let deckPalette: [String] = [
        "#E74C3C", "#E67E22", "#F1C40F", "#2ECC71",
        "#3498DB", "#9B59B6", "#1ABC9C", "#ECF0F1",
        "#2C2C2C", "#8E44AD"
    ]
    static let truckPalette: [String] = ["#C0C0C0", "#FFD700", "#2C2C2C", "#3498DB"]
    static let truckNames: [String]   = ["Silver", "Gold", "Raw", "Blue"]
    static let wheelPalette: [String] = [
        "#FFFFFF", "#F1C40F", "#E74C3C", "#3498DB", "#2C2C2C"
    ]
    static let graphics: [String] = ["🔥", "⚡️", "💀", "🌊", "🎯", "🐍", "🦅", "👾"]
}
