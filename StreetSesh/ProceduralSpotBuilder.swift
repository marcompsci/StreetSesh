//  ProceduralSpotBuilder.swift
//  Builds a 3D scene for any Spot3D from its JSON recipe.
//  Used when no bundled .usdz exists — generates at runtime.

import SceneKit
import UIKit
import simd

enum ProceduralSpotBuilder {

    static func build(_ spot: Spot3D) -> SCNNode {
        let k = ShapeKit()
        var rng = SeededRandom(string: spot.id)
        if spot.category == .shop {
            buildStorefront(spot, k, &rng)
        } else {
            let f = spot.features ?? SpotFeatures()
            switch spot.kind {
            case "bowlpark":   bowlPark(f, k, &rng)
            case "plazapark":  plazaPark(f, k, &rng)
            case "flatground": flatground(k, &rng)
            case "hill":       hill(f, k, &rng)
            default:           street(spot, f, k, &rng)
            }
        }
        return k.root
    }

    @discardableResult
    static func stairs(_ k: ShapeKit, n: Int, width: Float = 4, riser: Float = 0.17, tread: Float = 0.32,
                       landing: Float = 3, at pos: SIMD3<Float>, rotY: Float = 0, m: String = "concrete") -> (Float, Float) {
        let H = Float(n) * riser, run = Float(n) * tread
        var pts: [CGPoint] = [CGPoint(x: CGFloat(-landing), y: 0), CGPoint(x: CGFloat(-landing), y: CGFloat(H)), CGPoint(x: 0, y: CGFloat(H))]
        for i in 0..<n {
            let y = CGFloat(H - Float(i + 1) * riser)
            pts.append(CGPoint(x: CGFloat(Float(i) * tread), y: y))
            pts.append(CGPoint(x: CGFloat(Float(i + 1) * tread), y: y))
        }
        k.prism(m, pts, depth: width, at: pos, rotY: rotY)
        return (H, run)
    }

    static func handrail(_ k: ShapeKit, H: Float, run: Float, z: Float, origin o: SIMD3<Float>, kinked: Bool = false) {
        let rh: Float = 0.85
        var pts = [SIMD3<Float>(-0.4, H + rh, z), SIMD3(run + 0.1, rh, z)]
        if kinked { pts = [SIMD3(-1.2, H + rh, z), SIMD3(0, H + rh, z), SIMD3(run, rh, z), SIMD3(run + 0.6, rh, z)] }
        k.polyTube("steel", pts.map { $0 + o }, r: 0.024)
        k.tube("steel", o + SIMD3(pts[0].x, H, z), o + pts[0], r: 0.022)
        k.tube("steel", o + SIMD3(pts.last!.x, 0, z), o + pts.last!, r: 0.022)
    }

    static func hubba(_ k: ShapeKit, H: Float, run: Float, z: Float, origin o: SIMD3<Float>) {
        let prof = [CGPoint(x: -0.6, y: 0), CGPoint(x: -0.6, y: CGFloat(H + 0.45)),
                    CGPoint(x: CGFloat(run + 0.3), y: 0.45), CGPoint(x: CGFloat(run + 0.3), y: 0)]
        k.prism("granite", prof, depth: 0.55, at: o + SIMD3(0, 0, z))
        k.tube("steel", o + SIMD3(-0.6, H + 0.45, z - 0.275), o + SIMD3(run + 0.3, 0.45, z - 0.275), r: 0.02)
    }

    static func ledge(_ k: ShapeKit, x: Float, z: Float, length: Float, h: Float = 0.45, depth: Float = 0.5,
                      m: String = "granite", rotY: Float = 0, coping: Bool = true) {
        let g = k.group(SIMD3(x, 0, z), rotY: rotY)
        k.box(m, -length / 2, 0, -depth / 2, length / 2, h, depth / 2, in: g)
        if coping { k.box("steel", -length / 2, h - 0.03, depth / 2 - 0.03, length / 2, h + 0.004, depth / 2 + 0.004, in: g) }
    }

    @discardableResult
    static func bank(_ k: ShapeKit, x: Float, z: Float, length: Float, width: Float, angle: Float = 25,
                     m: String = "concrete", rotY: Float = 0, deck: Float = 1.2) -> Float {
        let h = length * tan(angle * .pi / 180)
        let prof = [CGPoint(x: 0, y: 0), CGPoint(x: CGFloat(length), y: CGFloat(h)),
                    CGPoint(x: CGFloat(length + deck), y: CGFloat(h)), CGPoint(x: CGFloat(length + deck), y: 0)]
        k.prism(m, prof, depth: width, at: SIMD3(x, 0, z), rotY: rotY)
        return h
    }

    static func flatRail(_ k: ShapeKit, x: Float, z: Float, length: Float, h: Float = 0.35) {
        k.tube("steel", SIMD3(x - length / 2, h, z), SIMD3(x + length / 2, h, z), r: 0.03)
        for dx in [-length / 2 + 0.2, length / 2 - 0.2] { k.tube("steel", SIMD3(x + dx, 0, z), SIMD3(x + dx, h, z), r: 0.025) }
    }

    static func quarterpipe(_ k: ShapeKit, x: Float, z: Float, width: Float = 5, h: Float = 1.5, rotY: Float = 0, deck: Float = 1.4) {
        let R = h * 1.15
        var prof: [CGPoint] = []
        for i in 0...12 {
            let th = Float(i) / 12 * .pi / 2
            var px = R * sin(th), py = R - R * cos(th)
            if py > h { py = h; px = sqrt(max(0, R * R - (R - h) * (R - h))) }
            prof.append(CGPoint(x: CGFloat(px), y: CGFloat(py)))
        }
        let xe = Float(prof.last!.x)
        prof += [CGPoint(x: CGFloat(xe + deck), y: CGFloat(h)), CGPoint(x: CGFloat(xe + deck), y: 0)]
        let g = k.group(SIMD3(x, 0, z), rotY: rotY)
        k.prism("concrete", prof, depth: width, at: .zero, in: g)
        k.tube("steel", SIMD3(xe, h, -width / 2), SIMD3(xe, h, width / 2), r: 0.04, in: g)
    }

    static func pyramid(_ k: ShapeKit, x: Float, z: Float) {
        let p = SCNPyramid(width: 6, height: 1.6, length: 6)
        p.firstMaterial = SpotMaterials.make(k.ghost ? "ghost" : "granite", size: .init(width: 6, height: 6))
        k.add(p, SIMD3(x, 0, z))
        k.box("granite", x - 1.25, 0, z - 1.25, x + 1.25, 0.9, z + 1.25)
    }

    static func ground(_ k: ShapeKit, _ m: String, _ x0: Float, _ z0: Float, _ x1: Float, _ z1: Float, y: Float = 0, th: Float = 0.15) {
        k.box(m, x0, y - th, z0, x1, y, z1)
    }

    static func road(_ k: ShapeKit, z0: Float, z1: Float, x0: Float = -12, x1: Float = 12) {
        k.box("asphalt", x0, -0.15, z0, x1, 0, z1)
        let zc = (z0 + z1) / 2
        var x = x0 + 0.5
        while x < x1 - 2 { k.box("paint_yellow", x, 0, zc - 0.06, x + 1.8, 0.012, zc + 0.06); x += 3 }
    }

    static func backdrop(_ k: ShapeKit, _ rng: inout SeededRandom, zBack: Float = -11) {
        var x: Float = -12
        while x < 12 {
            let w = rng.range(4, 7), h = rng.pick([7, 10.5, 14, 17.5, 21] as [Float])
            k.building(x, zBack - 6, min(x + w, 12), zBack, h: h, rng.pick(["stucco_a", "stucco_b", "brick_bg", "stucco_c"]))
            x += w + 0.1
        }
    }

    static func parkEdges(_ k: ShapeKit, _ rng: inout SeededRandom) {
        for x: Float in [-12, -6, 0, 6, 12] { k.tree(x, -12.5, h: rng.range(4, 6.5)) }
        k.lamp(-10.5, -9.5); k.lamp(10.5, -9.5); k.bench(-6, 10.5); k.trash(-3.5, 10.4)
    }

    static func bowlPark(_ f: SpotFeatures, _ k: ShapeKit, _ rng: inout SeededRandom) {
        let d = Float(f.bowlDepthM ?? 2.5), r0 = max(1.5, d * 0.8), hw = r0 + d + 1.5
        let X0 = -3.5 - hw, X1: Float = 11
        ground(k, "grass", -14, -14, 14, -hw, y: -0.02, th: 0.3); ground(k, "grass", -14, hw, 14, 14, y: -0.02, th: 0.3)
        ground(k, "grass", -14, -hw, X0, hw, y: -0.02, th: 0.3); ground(k, "grass", X1, -hw, 14, hw, y: -0.02, th: 0.3)
        k.bowl(center: SIMD3(-3.5, 0, 0), r0: r0, depth: d, half: hw)
        ground(k, "concrete", -3.5 + hw, -hw, X1, hw)
        if f.spine == true {
            quarterpipe(k, x: 5.2, z: 0, width: 4, h: 1.3); quarterpipe(k, x: 5.2, z: 0, width: 4, h: 1.3, rotY: .pi)
        } else { quarterpipe(k, x: 6.5, z: 0, width: 5, h: 1.4) }
        if (f.rails ?? 0) > 0 { flatRail(k, x: 4, z: 3.2, length: 3) }
        if (f.ledges ?? 0) > 0 { ledge(k, x: 4, z: -3.4, length: 3.5) }
        if f.fullPipe == true {
            let t = SCNTube(innerRadius: 2.2, outerRadius: 2.45, height: 5); t.radialSegmentCount = 24
            t.firstMaterial = SpotMaterials.make(k.ghost ? "ghost" : "concrete_smooth", size: .init(width: 6, height: 5))
            let n = k.add(t, SIMD3(3.5, 1.8, -hw + 2.5)); n.simdEulerAngles = SIMD3(0, 0, .pi / 2)
        }
        parkEdges(k, &rng)
    }

    static func plazaPark(_ f: SpotFeatures, _ k: ShapeKit, _ rng: inout SeededRandom) {
        ground(k, "grass", -14, -14, 14, 14, y: -0.02, th: 0.3)
        ground(k, f.surface == "asphalt" ? "asphalt_court" : "concrete", -10, -8, 10, 8)
        if f.overpass == true {
            for x: Float in [-7, 0, 7] { k.box("concrete_light", x - 0.6, 0, -7.5, x + 0.6, 7, -6.3) }
            k.box("concrete_light", -10, 7, -9, 10, 8.2, 6)
        }
        if let n = f.stairs, n > 0 {
            let o = SIMD3<Float>(-3.5, 0, -3.5)
            let (H, run) = stairs(k, n: n, width: 4, at: o)
            handrail(k, H: H, run: run, z: 0, origin: o)
            if (f.hubbas ?? 0) > 0 { hubba(k, H: H, run: run, z: 2.3, origin: o) }
        }
        for i in 0..<min(f.ledges ?? 0, 5) {
            ledge(k, x: 2.5 + Float(i % 2) * 3.5, z: -5 + Float(i) * 2.4,
                  length: i % 2 == 0 ? 3.5 : 2.5, h: 0.4 + 0.08 * Float(i % 3), rotY: 0.2 * Float(i % 2))
        }
        for i in 0..<min(f.rails ?? 0, 3) { flatRail(k, x: -6 + Float(i) * 2.2, z: 5, length: 2.8, h: 0.3 + 0.1 * Float(i)) }
        for i in 0..<min(f.banks ?? 0, 3) { bank(k, x: -9.5, z: [1.5, -1.5, 4.0][i], length: 2.2, width: 2.4) }
        for i in 0..<(f.krails ?? 0) {
            let prof = [CGPoint(x: -0.3, y: 0), CGPoint(x: -0.1, y: 0.8), CGPoint(x: 0.1, y: 0.8), CGPoint(x: 0.3, y: 0)]
            k.prism("concrete_light", prof, depth: 3, at: SIMD3(6, 0, 3 + Float(i) * 1.8), rotY: .pi / 2)
        }
        if f.pyramid == true { pyramid(k, x: 0, z: 2.5); ledge(k, x: -5, z: 2.5, length: 3, rotY: .pi / 2); ledge(k, x: 5, z: 2.5, length: 3, rotY: .pi / 2) }
        if f.miniBowl == true || (f.bowls ?? 0) > 0 {
            quarterpipe(k, x: 7, z: -1, width: 4, h: 1.2); quarterpipe(k, x: 5.2, z: -1, width: 4, h: 1.2, rotY: .pi)
        }
        if f.murals == true { k.box("mural", -10, 0, 7.6, 10, 2.6, 8) }
        parkEdges(k, &rng)
    }

    static func flatground(_ k: ShapeKit, _ rng: inout SeededRandom) {
        ground(k, "grass", -14, -14, 14, 14, y: -0.02, th: 0.3)
        ground(k, "asphalt_court", -10, -6, 10, 6)
        for i in 0..<8 { k.cone(-6 + Float(i) * 1.7, 0.6 * sin(Float(i))) }
        for x: Float in [-8, -3, 3, 8] { k.tree(x, -8.5, h: rng.range(4, 6)) }
        k.bench(-4, 7); k.bench(4, 7)
    }

    static func street(_ spot: Spot3D, _ f: SpotFeatures, _ k: ShapeKit, _ rng: inout SeededRandom) {
        let pad = f.bricks == true ? "brick_pave" : (f.bricks == false ? "granite" : "concrete")
        ground(k, pad, -12, -10, 12, 7)
        k.box("concrete_light", -12, -0.15, 7, 12, 0.14, 7.25)
        road(k, z0: 7.25, z1: 14)
        backdrop(k, &rng)
        k.lamp(-10.5, 6.5); k.lamp(10.5, 6.5)
        if spot.kind != "gap" {
            for x: Float in [-10, 9.5] { k.box("concrete_light", x - 0.8, 0, -8.8, x + 0.8, 0.6, -7.2); k.tree(x, -8, h: rng.range(4, 5.5)) }
            k.trash(6, 6.2)
        }
        k.ghost = spot.isGhost

        switch spot.kind {
        case "stairs", "handrail", "hubba":
            let n = f.stairs ?? 6
            let o = SIMD3<Float>(n > 8 ? -4.5 : -2.5, 0, -1)
            if f.rail == "doubleKink" {
                let n1 = n / 2, n2 = n - n1, r: Float = 0.17, t: Float = 0.32, H = Float(n) * r, Hm = Float(n2) * r
                stairs(k, n: n1, width: 5, landing: 4, at: o + SIMD3(0, Hm, 0))
                k.box("concrete", o.x - 4, 0, o.z - 2.5, o.x + Float(n1) * t + 2, Hm, o.z + 2.5)
                let o2 = o + SIMD3(Float(n1) * t + 2, 0, 0)
                stairs(k, n: n2, width: 5, landing: 0.01, at: o2)
                let x1 = Float(n1) * t, x2 = x1 + 2 + Float(n2) * t, rh: Float = 0.85
                k.polyTube("steel", [SIMD3(-0.8, H + rh, 0), SIMD3(0, H + rh, 0), SIMD3(x1, Hm + rh, 0),
                                      SIMD3(x1 + 2, Hm + rh, 0), SIMD3(x2, rh, 0), SIMD3(x2 + 0.6, rh, 0)].map { $0 + o }, r: 0.024)
            } else {
                let (H, run) = stairs(k, n: n, width: 5, landing: 4, at: o)
                if spot.kind == "handrail" || (spot.kind == "stairs" && (f.rail ?? "none") != "none") { handrail(k, H: H, run: run, z: 0, origin: o) }
                if spot.kind == "hubba" {
                    hubba(k, H: H, run: run, z: 2.8, origin: o)
                    if (f.hubbaSides ?? 1) > 1 { hubba(k, H: H, run: run, z: -2.8, origin: o) }
                }
                if f.upDown == true { stairs(k, n: n, width: 5, landing: 0.01, at: o + SIMD3(-4 - run, 0, 0), rotY: .pi) }
                if (f.ledges ?? 0) > 0 { for s: Float in [-1, 1] { ledge(k, x: o.x - 2, z: o.z + s * 3.2, length: 3.5, h: H + 0.35, depth: 0.45) } }
            }
        case "ledge":
            let n = max(1, f.ledges ?? f.blocks ?? 1), blocks = f.blocks != nil
            for i in 0..<min(n, 5) {
                ledge(k, x: -5 + Float(i % 3) * 5, z: -3 + Float(i / 3) * 4,
                      length: blocks ? 2.5 : Float(f.ledgeLengthM ?? 4),
                      h: Float(f.ledgeHeightM ?? 0.45), depth: blocks ? 1.2 : 0.55)
            }
            k.bench(7.5, 4.5)
        case "bank":
            for i in 0..<(f.banks ?? 1) {
                bank(k, x: -4 + Float(i) * 6, z: -3, length: 3, width: 4, angle: Float(f.bankAngle ?? 30),
                     m: spot.id.contains("china") ? "brick_pave" : "concrete")
            }
            if f.bunker == true { k.box("concrete_old", -10, 0, -9, 10, 3.5, -6) }
            if (f.ledges ?? 0) > 0 { ledge(k, x: 5, z: 3, length: 4) }
            if f.railToBank == true { flatRail(k, x: 0, z: 2.5, length: 3.5) }
        case "gap":
            let n = f.stairs ?? 4, drop = Float(f.dropM ?? 1), gap = Float(f.gapLengthM ?? 3)
            let o = SIMD3<Float>(-3, 0, -1)
            let (H, _) = stairs(k, n: n, width: 6, riser: drop / Float(n), tread: gap / Float(n), landing: 7, at: o)
            for zs: Float in [-3.2, 3.2] { k.box("concrete_light", o.x - 7, 0, o.z + zs - 0.2, o.x, H + 0.5, o.z + zs + 0.2) }
            k.tree(gap + 1, -6, h: 5); k.tree(gap + 5, -6, h: 5)
        case "plaza":
            for i in 0..<min(f.ledges ?? 3, 5) { ledge(k, x: -7 + Float(i) * 3.4, z: -2.5 + Float(i % 2) * 2.5, length: 3, h: 0.5, depth: 0.7, coping: false) }
            for i in 0..<(f.benches ?? 0) { ledge(k, x: -6 + Float(i) * 5, z: 4.5, length: 2.4, h: 0.45, depth: 0.6, coping: false) }
            if f.gap == true || (f.stairs ?? 0) > 0 { stairs(k, n: f.gapStairs ?? f.stairs ?? 3, width: 6, landing: 1, at: SIMD3(-9, 0, -7)) }
            if f.palms == true { k.palm(-9, 3); k.palm(9, 3) }
            if f.slabs == true { for i in 0..<4 { k.box("granite", 3 + Float(i) * 1.8, 0, -6, 4.4 + Float(i) * 1.8, 0.3 + 0.1 * Float(i), -4) } }
        case "wallride":
            let wh = Float(f.wallHeightM ?? 3)
            k.box("tile_wall", -6, 0, -3.5, 6, wh, -3)
            k.prism("concrete", [CGPoint(x: 0, y: 0), CGPoint(x: 1.2, y: 0), CGPoint(x: 1.2, y: 0.6)], depth: 12, at: SIMD3(0, 0, -1.8), rotY: .pi / 2)
            k.box("steel_dark", -6, wh, -3.6, 6, wh + 0.3, -2.9)
        default:
            ledge(k, x: 0, z: 0, length: 4)
        }
        k.ghost = false
    }

    static func hill(_ f: SpotFeatures, _ k: ShapeKit, _ rng: inout SeededRandom) {
        let g = Float(f.gradePct ?? 12) / 100, L: Float = 24, drop = g * L
        func slope(_ m: String, _ z0: Float, _ z1: Float, lift: Float = 0) {
            let prof = [CGPoint(x: -12, y: -0.3), CGPoint(x: -12, y: CGFloat(drop + lift)),
                        CGPoint(x: 12, y: CGFloat(lift)), CGPoint(x: 12, y: -0.3)]
            k.prism(m, prof, depth: z1 - z0, at: SIMD3(0, 0, (z0 + z1) / 2))
        }
        slope("asphalt", -3.5, 3.5); slope("concrete", 3.5, 6, lift: 0.15); slope("concrete", -6, -3.5, lift: 0.15)
        slope("grass", 6, 12, lift: 0.1); slope("grass", -12, -6, lift: 0.1)
        if f.flatTop == true {
            k.polyTube("steel", [SIMD3(-12, drop + 1.1, 5.8), SIMD3(12, 1.1, 5.8)], r: 0.04)
            for x: Float in [-9, -3, 4, 10] { k.tree(x, -9, h: rng.range(3.5, 5)) }
        } else {
            var x: Float = -12
            while x < 12 {
                let w = rng.pick([5, 6] as [Float]), x1 = min(x + w, 12), base = g * (12 - x1)
                let h = rng.pick([7.5, 9, 10.5] as [Float]) + g * w
                let node = k.group(SIMD3(0, base, 0))
                k.box(rng.pick(["stucco_a", "stucco_b", "stucco_c", "brick_bg"]), x, 0, -13, x1 - 0.1, h, -6, in: node)
                for fl in 0..<Int(h / 3.4) { k.windowPlane(w: 1.4, h: 1.5, center: SIMD3((x + x1) / 2, Float(fl) * 3.4 + 1.8, -5.98), in: node) }
                x += w
            }
            for x: Float in [-8, 0, 8] { k.tree(x, 5.2, h: rng.range(3.5, 4.5)) }
        }
    }

    static func buildStorefront(_ shop: Spot3D, _ k: ShapeKit, _ rng: inout SeededRandom) {
        guard let fz = shop.facade else { return }
        let W: Float = 9, D: Float = 10, FH: Float = 4, UH: Float = 3.4, U0 = FH + 1.45
        let stories = max(1, fz.stories)
        let H = U0 + Float(stories - 1) * UH
        let wallTex: String = ["brick": "brick_bg", "victorian": "stucco_b", "warehouse": "concrete_light", "glass": "window"][fz.style] ?? "stucco_a"
        let tint = UIColor(hexString: fz.color)
        func wall(_ x0: Float, _ y0: Float, _ z0: Float, _ x1: Float, _ y1: Float, _ z1: Float) {
            k.box(wallTex, x0, y0, z0, x1, y1, z1, tint: fz.style == "glass" ? nil : tint)
        }
        ground(k, "concrete", -14, -D, 14, 4.2)
        k.box("concrete_light", -14, -0.15, 4.2, 14, 0.14, 4.45)
        road(k, z0: 4.45, z1: 12, x0: -14, x1: 14)
        for side: Float in [-1, 1] {
            let x0: Float = side < 0 ? -14 : W / 2 + 0.05, x1: Float = side < 0 ? -W / 2 - 0.05 : 14
            k.building(x0, -D, x1, 0, h: rng.pick([7.4, 10.8, 14.2] as [Float]), rng.pick(["stucco_a", "stucco_b", "brick_bg", "stucco_c"]))
        }
        let rec: Float = 1.4
        k.box("interior", -W / 2, 0, -D, W / 2, FH, -rec)
        k.box("wood", -W / 2, 0, -rec, W / 2, 0.05, 0)
        k.box("interior", -W / 2, FH - 0.2, -rec, W / 2, FH, 0)
        for x in [-W / 2, W / 2 - 0.6] { wall(x, 0, -rec, x + 0.6, FH, 0.15) }
        for i in 0..<11 {
            let x = -W / 2 + 0.9 + Float(i) * (W - 1.8) / 10
            k.plane(SpotMaterials.imageMaterial(SpotMaterials.deckImage(seed: i % 8)), w: 0.2, h: 2, center: SIMD3(x, 2, -rec + 0.02))
        }
        k.box("wood", -3.5, 0, -rec, -1.2, 1, -rec + 0.6)
        k.box("wood", 1.8, 0, -rec, 3.8, 0.95, -rec + 0.5)
        let glass = SpotMaterials.make("glass")
        k.plane(glass, w: (W / 2 - 0.6) - 0.55, h: FH - 0.95, center: SIMD3(-(0.55 + W / 2 - 0.6) / 2, (FH - 0.25) / 2, 0))
        k.plane(glass, w: (W / 2 - 0.6) - 0.55, h: FH - 0.95, center: SIMD3((0.55 + W / 2 - 0.6) / 2, (FH - 0.25) / 2, 0))
        k.box("steel_dark", -0.55, 0, -0.06, 0.55, FH - 0.6, -0.02)
        wall(-W / 2 + 0.6, 0, -0.05, W / 2 - 0.6, 0.35, 0.05)
        k.box("steel_dark", -W / 2 + 0.6, FH - 0.64, -0.04, W / 2 - 0.6, FH - 0.56, 0.04)
        k.plane(SpotMaterials.make("neon"), w: 1, h: 0.35, center: SIMD3(2.9, 2.6, 0.02))
        wall(-W / 2, FH - 0.6, -0.05, W / 2, FH, 0.2)
        k.box("sign_frame", -W / 2 + 0.5, FH + 0.05, 0, W / 2 - 0.5, FH + 1.25, 0.25)
        let signImg = SpotMaterials.signImage(text: shop.name, accent: SpotMaterials.signColor(fz.accent))
        k.plane(SpotMaterials.imageMaterial(signImg), w: W - 1.2, h: 1.06, center: SIMD3(0, FH + 0.65, 0.26))
        let aw = SCNMaterial(); aw.lightingModel = .physicallyBased
        aw.diffuse.contents = UIColor(hexString: fz.awning); aw.roughness.contents = 0.8
        let awProf = [CGPoint(x: 0.2, y: CGFloat(FH - 0.55)), CGPoint(x: 1.5, y: CGFloat(FH - 1.2)),
                      CGPoint(x: 1.5, y: CGFloat(FH - 1.12)), CGPoint(x: 0.2, y: CGFloat(FH - 0.47))]
        let awn = k.prism("steel_dark", awProf, depth: W - 0.6, at: .zero, rotY: -.pi / 2)
        awn.geometry?.firstMaterial = aw
        k.box("steel_dark", -W / 2 + 0.3, FH - 1.5, 1.45, W / 2 - 0.3, FH - 1.2, 1.53).geometry?.firstMaterial = aw
        if stories == 1 {
            wall(-W / 2, FH, -D, W / 2, FH + 1.35 + (fz.style == "stripmall" ? 0.9 : 0.6), 0)
        } else {
            wall(-W / 2, FH, -D, W / 2, H, 0)
            for fl in 0..<(stories - 1) {
                let y0 = U0 + Float(fl) * UH + 0.7
                if fz.style == "victorian" {
                    let bay = [CGPoint(x: -2.2, y: 0), CGPoint(x: 2.2, y: 0), CGPoint(x: 1.5, y: 0.8), CGPoint(x: -1.5, y: 0.8)]
                    let bn = k.prism(wallTex, bay, depth: 2.5, at: SIMD3(0, y0 + 0.95, 0))
                    bn.simdEulerAngles = SIMD3(.pi / 2, 0, 0); bn.geometry?.firstMaterial?.multiply.contents = tint
                    k.windowPlane(w: 2.8, h: 1.8, center: SIMD3(0, y0 + 0.9, 0.81))
                    for x: Float in [-3.3, 3.3] { k.windowPlane(w: 1, h: 1.8, center: SIMD3(x, y0 + 0.9, 0.02)) }
                } else {
                    for x: Float in [-2.7, -0.2, 2.3] {
                        k.windowPlane(w: 1.8, h: 1.8, center: SIMD3(x, y0 + 0.9, 0.02))
                        k.box("trim", x - 0.98, y0 - 0.15, 0, x + 0.98, y0, 0.12)
                    }
                }
            }
            k.box("trim", -W / 2 - 0.2, H - 0.1, -0.2, W / 2 + 0.2, H + 0.45, 0.35)
        }
        if fz.mural == true { k.box("mural", W / 2 + 0.01, 0.4, -D + 0.5, W / 2 + 0.08, min(FH + 1.35, 7), -0.5) }
        k.bench(-3.2, 3.2); k.trash(3.9, 3.6)
        if fz.style == "stripmall" { k.palm(-7.5, 3.4) } else { k.tree(-7.5, 3.4, h: 5) }
        k.box("steel_dark", 1.2, 0, 1.9, 3.2, 0.06, 2.3)
        for i in 0..<4 {
            let p = k.plane(SpotMaterials.imageMaterial(SpotMaterials.deckImage(seed: (i + 3) % 8)), w: 0.2, h: 0.8,
                            center: SIMD3(1.4 + Float(i) * 0.5, 0.46, 2.05))
            p.simdEulerAngles = SIMD3(-0.12, 0, 0)
        }
    }
}
