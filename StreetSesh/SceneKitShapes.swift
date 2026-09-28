//  SceneKitShapes.swift
//  Low-level primitives for the procedural builder (Y-up, meters).

import SceneKit
import UIKit
import simd

final class ShapeKit {
    let root = SCNNode()
    var ghost = false

    private func mat(_ name: String, _ size: CGSize, tint: UIColor? = nil) -> SCNMaterial {
        SpotMaterials.make(ghost ? "ghost" : name, size: size, tint: tint)
    }

    @discardableResult
    func add(_ geo: SCNGeometry, _ pos: SIMD3<Float>, rotY: Float = 0, to parent: SCNNode? = nil) -> SCNNode {
        let n = SCNNode(geometry: geo)
        n.simdPosition = pos
        n.simdEulerAngles = SIMD3(0, rotY, 0)
        n.castsShadow = true
        (parent ?? root).addChildNode(n)
        return n
    }

    func group(_ pos: SIMD3<Float>, rotY: Float = 0, in parent: SCNNode? = nil) -> SCNNode {
        let g = SCNNode(); g.simdPosition = pos; g.simdEulerAngles = SIMD3(0, rotY, 0)
        (parent ?? root).addChildNode(g); return g
    }

    @discardableResult
    func box(_ m: String, _ x0: Float, _ y0: Float, _ z0: Float, _ x1: Float, _ y1: Float, _ z1: Float,
             tint: UIColor? = nil, in parent: SCNNode? = nil) -> SCNNode {
        let w = abs(x1 - x0), h = abs(y1 - y0), l = abs(z1 - z0)
        let g = SCNBox(width: CGFloat(w), height: CGFloat(h), length: CGFloat(l), chamferRadius: 0)
        g.firstMaterial = mat(m, CGSize(width: CGFloat(max(w, l)), height: CGFloat(max(h, min(w, l)))), tint: tint)
        return add(g, SIMD3((x0 + x1) / 2, (y0 + y1) / 2, (z0 + z1) / 2), to: parent)
    }

    @discardableResult
    func tube(_ m: String, _ a: SIMD3<Float>, _ b: SIMD3<Float>, r: Float = 0.025, in parent: SCNNode? = nil) -> SCNNode {
        let d = b - a, L = simd_length(d)
        let g = SCNCylinder(radius: CGFloat(r), height: CGFloat(L)); g.radialSegmentCount = 12
        g.firstMaterial = mat(m, CGSize(width: 1, height: 1))
        let n = add(g, (a + b) / 2, to: parent)
        if L > 0 { n.simdOrientation = simd_quatf(from: SIMD3(0, 1, 0), to: d / L) }
        return n
    }

    func polyTube(_ m: String, _ pts: [SIMD3<Float>], r: Float = 0.025, in parent: SCNNode? = nil) {
        for i in 0..<(pts.count - 1) { tube(m, pts[i], pts[i + 1], r: r, in: parent) }
        for p in pts.dropFirst().dropLast() {
            let s = SCNSphere(radius: CGFloat(r)); s.firstMaterial = mat(m, .init(width: 1, height: 1))
            add(s, p, to: parent)
        }
    }

    @discardableResult
    func prism(_ m: String, _ profile: [CGPoint], depth: Float, at pos: SIMD3<Float>,
               rotY: Float = 0, in parent: SCNNode? = nil) -> SCNNode {
        let p = UIBezierPath(); p.move(to: profile[0]); profile.dropFirst().forEach { p.addLine(to: $0) }; p.close()
        let g = SCNShape(path: p, extrusionDepth: CGFloat(depth))
        let xs = profile.map(\.x), ys = profile.map(\.y)
        g.firstMaterial = mat(m, CGSize(width: (xs.max()! - xs.min()!),
                                         height: max(ys.max()! - ys.min()!, CGFloat(depth))))
        return add(g, pos, rotY: rotY, to: parent)
    }

    @discardableResult
    func plane(_ material: SCNMaterial, w: Float, h: Float, center: SIMD3<Float>,
               rotY: Float = 0, in parent: SCNNode? = nil) -> SCNNode {
        let g = SCNPlane(width: CGFloat(w), height: CGFloat(h))
        g.firstMaterial = ghost ? mat("ghost", .init(width: 1, height: 1)) : material
        let n = add(g, center, rotY: rotY, to: parent); n.castsShadow = false; return n
    }

    func windowPlane(w: Float, h: Float, center: SIMD3<Float>, rotY: Float = 0, in parent: SCNNode? = nil) {
        plane(SpotMaterials.make("window"), w: w, h: h, center: center, rotY: rotY, in: parent)
    }

    func bowl(center c: SIMD3<Float>, r0: Float, depth d: Float, half: Float, segments: Int = 48, steps: Int = 10) {
        var verts: [SCNVector3] = [], norms: [SCNVector3] = [], uvs: [CGPoint] = [], idx: [Int32] = []
        var tileVerts: [SCNVector3] = [], tileNorms: [SCNVector3] = [], tileUVs: [CGPoint] = [], tileIdx: [Int32] = []
        let R = r0 + d
        for k in 0..<steps {
            let t0 = Float(k) / Float(steps) * .pi / 2, t1 = Float(k + 1) / Float(steps) * .pi / 2
            let isTile = k == steps - 1
            for s in 0..<segments {
                let a0 = Float(s) / Float(segments) * 2 * .pi, a1 = Float(s + 1) / Float(segments) * 2 * .pi
                func P(_ a: Float, _ t: Float) -> SIMD3<Float> {
                    let r = r0 + d * sin(t); return c + SIMD3(r * cos(a), -d * cos(t), r * sin(a))
                }
                func N(_ a: Float, _ t: Float) -> SIMD3<Float> {
                    simd_normalize(SIMD3(-sin(t) * cos(a), cos(t), -sin(t) * sin(a)))
                }
                let quad = [(a0, t0), (a1, t0), (a1, t1), (a0, t1)]
                let base = Int32(isTile ? tileVerts.count : verts.count)
                for (a, t) in quad {
                    let p = P(a, t), n = N(a, t)
                    let uv = CGPoint(x: CGFloat(a * R / 1.5), y: CGFloat(t * d / 1.5))
                    if isTile { tileVerts.append(SCNVector3(p)); tileNorms.append(SCNVector3(n)); tileUVs.append(CGPoint(x: uv.x * 2, y: uv.y * 6)) }
                    else { verts.append(SCNVector3(p)); norms.append(SCNVector3(n)); uvs.append(uv) }
                }
                let tri: [Int32] = [base, base + 2, base + 1, base, base + 3, base + 2]
                if isTile { tileIdx += tri } else { idx += tri }
            }
        }
        let cb = Int32(verts.count)
        verts.append(SCNVector3(c + SIMD3(0, -d, 0))); norms.append(SCNVector3(0, 1, 0)); uvs.append(.zero)
        for s in 0...segments {
            let a = Float(s) / Float(segments) * 2 * .pi
            verts.append(SCNVector3(c + SIMD3(r0 * cos(a), -d, r0 * sin(a))))
            norms.append(SCNVector3(0, 1, 0))
            uvs.append(CGPoint(x: CGFloat(r0 * cos(a) / 2), y: CGFloat(r0 * sin(a) / 2)))
            if s > 0 { idx += [cb, Int32(verts.count - 1), Int32(verts.count - 2)] }
        }
        func geo(_ v: [SCNVector3], _ n: [SCNVector3], _ t: [CGPoint], _ i: [Int32], _ m: String) -> SCNGeometry {
            let g = SCNGeometry(
                sources: [SCNGeometrySource(vertices: v), SCNGeometrySource(normals: n), SCNGeometrySource(textureCoordinates: t)],
                elements: [SCNGeometryElement(indices: i, primitiveType: .triangles)])
            let material = mat(m, .init(width: 1, height: 1))
            material.diffuse.contentsTransform = SCNMatrix4Identity; material.isDoubleSided = true
            g.firstMaterial = material; return g
        }
        add(geo(verts, norms, uvs, idx, "concrete_smooth"), .zero)
        add(geo(tileVerts, tileNorms, tileUVs, tileIdx, "pool_tile"), .zero)
        let torus = SCNTorus(ringRadius: CGFloat(R + 0.02), pipeRadius: 0.055); torus.ringSegmentCount = 64
        torus.firstMaterial = mat("coping", .init(width: 1, height: 1)); add(torus, c + SIMD3(0, 0.04, 0))
        let path = UIBezierPath(rect: CGRect(x: CGFloat(-half), y: CGFloat(-half),
                                              width: CGFloat(half * 2), height: CGFloat(half * 2)))
        path.append(UIBezierPath(ovalIn: CGRect(x: CGFloat(-R), y: CGFloat(-R),
                                                 width: CGFloat(R * 2), height: CGFloat(R * 2))))
        path.usesEvenOddFillRule = true; path.flatness = 0.02
        let deck = SCNShape(path: path, extrusionDepth: 0.3)
        deck.firstMaterial = mat("concrete", CGSize(width: CGFloat(half * 2), height: CGFloat(half * 2)))
        let dn = add(deck, c + SIMD3(0, -0.15, 0)); dn.simdEulerAngles = SIMD3(-.pi / 2, 0, 0)
    }

    func tree(_ x: Float, _ z: Float, h: Float = 4.5) {
        tube("bark", SIMD3(x, 0, z), SIMD3(x, h * 0.6, z), r: 0.14)
        let s = SCNSphere(radius: CGFloat(h * 0.3)); s.segmentCount = 10
        s.firstMaterial = mat("leaves", .init(width: 1, height: 1)); add(s, SIMD3(x, h * 0.72, z))
        let s2 = SCNSphere(radius: CGFloat(h * 0.2)); s2.segmentCount = 8
        s2.firstMaterial = mat("leaves", .init(width: 1, height: 1)); add(s2, SIMD3(x + 0.4, h * 0.6, z + 0.2))
    }
    func palm(_ x: Float, _ z: Float, h: Float = 7) {
        tube("bark", SIMD3(x, 0, z), SIMD3(x, h, z), r: 0.16)
        for k in 0..<7 {
            let a = Float(k) / 7 * 2 * .pi
            tube("leaves", SIMD3(x, h, z), SIMD3(x + 1.8 * cos(a), h - 0.8, z + 1.8 * sin(a)), r: 0.12)
        }
    }
    func bench(_ x: Float, _ z: Float) {
        box("wood", x - 0.9, 0.42, z - 0.22, x + 0.9, 0.48, z + 0.22)
        for sx: Float in [-0.75, 0.75] { box("steel_dark", x + sx - 0.04, 0, z - 0.2, x + sx + 0.04, 0.42, z + 0.2) }
    }
    func lamp(_ x: Float, _ z: Float) {
        tube("steel_dark", SIMD3(x, 0, z), SIMD3(x, 4.6, z), r: 0.07)
        tube("steel_dark", SIMD3(x, 4.6, z), SIMD3(x + 0.8, 4.7, z), r: 0.05)
        box("lamp", x + 0.6, 4.5, z - 0.12, x + 1.0, 4.62, z + 0.12)
    }
    func trash(_ x: Float, _ z: Float) {
        let c = SCNCylinder(radius: 0.28, height: 0.95)
        c.firstMaterial = mat("steel_dark", .init(width: 1, height: 1)); add(c, SIMD3(x, 0.475, z))
    }
    func cone(_ x: Float, _ z: Float) {
        let c = SCNCone(topRadius: 0, bottomRadius: 0.16, height: 0.45)
        c.firstMaterial = mat("orange", .init(width: 1, height: 1)); add(c, SIMD3(x, 0.225, z))
    }

    func building(_ x0: Float, _ z0: Float, _ x1: Float, _ z1: Float, h: Float, _ m: String, skipGround: Bool = false) {
        box(m, x0, 0, z0, x1, h, z1)
        let floors = Int(h / 3.4), W = x1 - x0, nw = max(1, Int(W / 2.4)), step = W / Float(nw)
        for f in 0..<floors where !(skipGround && f == 0) {
            let y = Float(f) * 3.4 + 1.8
            for i in 0..<nw { windowPlane(w: step * 0.5, h: 1.6, center: SIMD3(x0 + step * (Float(i) + 0.5), y, z1 + 0.02)) }
        }
    }
}
