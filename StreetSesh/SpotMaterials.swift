//  SpotMaterials.swift
//  PBR materials for the procedural SceneKit builder.

import SceneKit
import UIKit

enum SpotMaterials {

    struct Spec {
        let tex: String?; let color: UIColor; let rough: CGFloat
        let metal: CGFloat; let tile: CGFloat; var opacity: CGFloat = 1; var emission: UIColor? = nil
    }

    static let specs: [String: Spec] = [
        "concrete":        Spec(tex: "concrete",        color: .white, rough: 0.85, metal: 0, tile: 2),
        "concrete_smooth": Spec(tex: "concrete_smooth", color: .white, rough: 0.55, metal: 0, tile: 3),
        "concrete_light":  Spec(tex: "concrete_light",  color: .white, rough: 0.85, metal: 0, tile: 2),
        "concrete_old":    Spec(tex: "concrete_old",    color: .white, rough: 0.95, metal: 0, tile: 3),
        "asphalt":         Spec(tex: "asphalt",         color: .white, rough: 0.95, metal: 0, tile: 3),
        "asphalt_court":   Spec(tex: "asphalt_court",   color: .white, rough: 0.80, metal: 0, tile: 4),
        "granite":         Spec(tex: "granite",         color: .white, rough: 0.45, metal: 0, tile: 1.5),
        "brick_pave":      Spec(tex: "brick_pave",      color: .white, rough: 0.80, metal: 0, tile: 1.6),
        "brick_bg":        Spec(tex: "brick_bg",        color: .white, rough: 0.90, metal: 0, tile: 2.5),
        "stucco_a":        Spec(tex: "stucco_a",        color: .white, rough: 0.90, metal: 0, tile: 4),
        "stucco_b":        Spec(tex: "stucco_b",        color: .white, rough: 0.90, metal: 0, tile: 4),
        "stucco_c":        Spec(tex: "stucco_c",        color: .white, rough: 0.90, metal: 0, tile: 4),
        "grass":           Spec(tex: "grass",           color: .white, rough: 1.00, metal: 0, tile: 3),
        "wood":            Spec(tex: "wood",            color: .white, rough: 0.70, metal: 0, tile: 1),
        "pool_tile":       Spec(tex: "pool_tile",       color: .white, rough: 0.30, metal: 0, tile: 0.8),
        "tile_wall":       Spec(tex: "pool_tile",       color: .white, rough: 0.35, metal: 0, tile: 1.2),
        "mural":           Spec(tex: "mural",           color: .white, rough: 0.80, metal: 0, tile: 20),
        "window":          Spec(tex: "window",          color: .white, rough: 0.15, metal: 0.2, tile: 1),
        "steel":           Spec(tex: nil, color: UIColor(white: 0.74, alpha: 1), rough: 0.30, metal: 1.0, tile: 1),
        "steel_dark":      Spec(tex: nil, color: UIColor(white: 0.17, alpha: 1), rough: 0.50, metal: 0.8, tile: 1),
        "coping":          Spec(tex: nil, color: UIColor(white: 0.80, alpha: 1), rough: 0.25, metal: 1.0, tile: 1),
        "bark":            Spec(tex: nil, color: UIColor(red: 0.45, green: 0.33, blue: 0.24, alpha: 1), rough: 1.0, metal: 0, tile: 1),
        "leaves":          Spec(tex: nil, color: UIColor(red: 0.40, green: 0.62, blue: 0.36, alpha: 1), rough: 0.90, metal: 0, tile: 1),
        "orange":          Spec(tex: nil, color: .systemOrange, rough: 0.60, metal: 0, tile: 1),
        "paint_yellow":    Spec(tex: nil, color: UIColor(red: 0.98, green: 0.85, blue: 0.35, alpha: 1), rough: 0.70, metal: 0, tile: 1),
        "roof":            Spec(tex: nil, color: UIColor(white: 0.45, alpha: 1), rough: 0.90, metal: 0, tile: 1),
        "lamp":            Spec(tex: nil, color: .white, rough: 0.50, metal: 0, tile: 1, emission: UIColor(red: 1, green: 0.9, blue: 0.6, alpha: 1)),
        "glass":           Spec(tex: nil, color: UIColor(red: 0.6, green: 0.75, blue: 0.85, alpha: 1), rough: 0.05, metal: 0, tile: 1, opacity: 0.28),
        "interior":        Spec(tex: nil, color: UIColor(white: 0.95, alpha: 1), rough: 0.90, metal: 0, tile: 1),
        "neon":            Spec(tex: nil, color: .systemPink, rough: 0.50, metal: 0, tile: 1, emission: .systemPink),
        "sign_frame":      Spec(tex: nil, color: UIColor(white: 0.08, alpha: 1), rough: 0.60, metal: 0, tile: 1),
        "trim":            Spec(tex: nil, color: UIColor(white: 0.95, alpha: 1), rough: 0.60, metal: 0, tile: 1),
        "ghost":           Spec(tex: nil, color: UIColor(red: 0.4, green: 0.85, blue: 1, alpha: 1), rough: 0.30, metal: 0, tile: 1,
                                opacity: 0.45, emission: UIColor(red: 0.15, green: 0.45, blue: 0.6, alpha: 1)),
    ]

    nonisolated(unsafe) private static var imageCache: [String: UIImage] = [:]

    static func image(_ name: String) -> UIImage? {
        if let img = imageCache[name] { return img }
        let url = Bundle.main.url(forResource: name, withExtension: "jpg")
            ?? Bundle.main.url(forResource: name, withExtension: "jpg", subdirectory: "Textures")
        guard let url, let img = UIImage(contentsOfFile: url.path) else { return nil }
        imageCache[name] = img
        return img
    }

    static func make(_ name: String, size: CGSize = CGSize(width: 1, height: 1), tint: UIColor? = nil) -> SCNMaterial {
        let s = specs[name] ?? specs["concrete"]!
        let m = SCNMaterial()
        m.lightingModel = .physicallyBased
        if let t = s.tex, let img = image(t) {
            m.diffuse.contents = img
            m.diffuse.wrapS = .repeat; m.diffuse.wrapT = .repeat
            m.diffuse.contentsTransform = SCNMatrix4MakeScale(
                Float(max(size.width / s.tile, 0.05)), Float(max(size.height / s.tile, 0.05)), 1)
            if let tint { m.multiply.contents = tint }
        } else {
            m.diffuse.contents = tint ?? s.color
        }
        m.roughness.contents = s.rough
        m.metalness.contents = s.metal
        if let e = s.emission { m.emission.contents = e }
        if s.opacity < 1 { m.transparency = s.opacity; m.blendMode = .alpha; m.isDoubleSided = true; m.writesToDepthBuffer = false }
        return m
    }

    static func flat(_ color: UIColor, rough: CGFloat = 0.8, metal: CGFloat = 0) -> SCNMaterial {
        let m = SCNMaterial(); m.lightingModel = .physicallyBased
        m.diffuse.contents = color; m.roughness.contents = rough; m.metalness.contents = metal
        return m
    }

    static func imageMaterial(_ img: UIImage) -> SCNMaterial {
        let m = SCNMaterial(); m.lightingModel = .physicallyBased
        m.diffuse.contents = img; m.roughness.contents = 0.5
        return m
    }

    static func signImage(text: String, accent: UIColor) -> UIImage {
        let size = CGSize(width: 1024, height: 256)
        return UIGraphicsImageRenderer(size: size).image { ctx in
            UIColor(white: 0.07, alpha: 1).setFill(); ctx.fill(CGRect(origin: .zero, size: size))
            var fontSize: CGFloat = 150
            let str = text.uppercased()
            var attrs: [NSAttributedString.Key: Any] = [:]
            repeat {
                attrs = [.font: UIFont.systemFont(ofSize: fontSize, weight: .black), .foregroundColor: accent]
                fontSize -= 4
            } while (str as NSString).size(withAttributes: attrs).width > size.width * 0.9 && fontSize > 20
            let ts = (str as NSString).size(withAttributes: attrs)
            (str as NSString).draw(at: CGPoint(x: (size.width - ts.width) / 2, y: (size.height - ts.height) / 2), withAttributes: attrs)
            accent.setStroke(); ctx.cgContext.setLineWidth(8)
            ctx.cgContext.stroke(CGRect(x: 8, y: 8, width: size.width - 16, height: size.height - 16))
        }
    }

    static func signColor(_ hex: String) -> UIColor {
        let c = UIColor(hexString: hex)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        c.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (0.3 * r + 0.59 * g + 0.11 * b) > 0.35 ? c : .white
    }

    static func deckImage(seed: Int) -> UIImage {
        var rng = SeededRandom(seed: UInt64(seed + 100))
        let size = CGSize(width: 128, height: 512)
        return UIGraphicsImageRenderer(size: size).image { ctx in
            UIColor(hue: rng.next(), saturation: 0.7, brightness: 0.9, alpha: 1).setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            for _ in 0..<6 {
                UIColor(hue: rng.next(), saturation: 0.8, brightness: 0.85, alpha: 1).setFill()
                ctx.fill(CGRect(x: 0, y: rng.next() * 480, width: 128, height: 10 + rng.next() * 70))
            }
            UIColor.white.setFill()
            ctx.cgContext.fillEllipse(in: CGRect(x: 24, y: 200, width: 80, height: 80))
        }
    }

    static func skyImage() -> UIImage {
        let size = CGSize(width: 8, height: 512)
        return UIGraphicsImageRenderer(size: size).image { ctx in
            let colors = [UIColor(red: 0.36, green: 0.56, blue: 0.84, alpha: 1).cgColor,
                          UIColor(red: 0.87, green: 0.91, blue: 0.95, alpha: 1).cgColor]
            let g = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: [0, 1])!
            ctx.cgContext.drawLinearGradient(g, start: .zero, end: CGPoint(x: 0, y: size.height), options: [])
        }
    }
}

struct SeededRandom {
    private var state: UInt64
    init(seed: UInt64) { state = seed &+ 0x9E3779B97F4A7C15 }
    init(string: String) { self.init(seed: string.utf8.reduce(UInt64(1469598103934665603)) { ($0 ^ UInt64($1)) &* 1099511628211 }) }
    mutating func nextUInt() -> UInt64 { state ^= state << 13; state ^= state >> 7; state ^= state << 17; return state }
    mutating func next() -> CGFloat { CGFloat(nextUInt() % 10_000) / 10_000 }
    mutating func range(_ a: Float, _ b: Float) -> Float { a + Float(next()) * (b - a) }
    mutating func pick<T>(_ xs: [T]) -> T { xs[Int(nextUInt() % UInt64(xs.count))] }
}
