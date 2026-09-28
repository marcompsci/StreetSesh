//  SpotSceneFactory.swift
//  Gives a lit, framed SCNScene for any Spot3D.
//  1) Uses the bundled "<id>.usdz" if present
//  2) Otherwise builds procedurally from the JSON recipe

import SceneKit
import Metal
import UIKit

enum SpotSceneFactory {

    static let turntableName = "turntable"
    nonisolated(unsafe) private static let cache = NSCache<NSString, SCNScene>()

    static func hasBundledModel(_ spot: Spot3D) -> Bool { bundledURL(spot) != nil }

    static func bundledURL(_ spot: Spot3D) -> URL? {
        Bundle.main.url(forResource: spot.id, withExtension: "usdz")
            ?? Bundle.main.url(forResource: spot.id, withExtension: "usdz", subdirectory: "USDZ")
    }

    static func makeScene(for spot: Spot3D) -> SCNScene {
        if let cached = cache.object(forKey: spot.id as NSString) { return cached }
        let scene = SCNScene()
        let turntable = SCNNode(); turntable.name = turntableName
        scene.rootNode.addChildNode(turntable)

        if let url = bundledURL(spot),
           let loaded = try? SCNScene(url: url, options: [.checkConsistency: false]) {
            let content = SCNNode()
            for child in loaded.rootNode.childNodes { child.removeFromParentNode(); content.addChildNode(child) }
            content.enumerateHierarchy { n, _ in n.castsShadow = true }
            turntable.addChildNode(content)
        } else {
            turntable.addChildNode(ProceduralSpotBuilder.build(spot))
        }

        let sky = SpotMaterials.skyImage()
        scene.background.contents = sky
        scene.lightingEnvironment.contents = sky
        scene.lightingEnvironment.intensity = 1.2

        let sun = SCNLight(); sun.type = .directional; sun.intensity = 1600
        sun.color = UIColor(red: 1, green: 0.95, blue: 0.87, alpha: 1)
        sun.castsShadow = true; sun.shadowMode = .deferred
        sun.shadowMapSize = CGSize(width: 2048, height: 2048)
        sun.orthographicScale = 22; sun.shadowRadius = 3; sun.shadowSampleCount = 8
        sun.shadowColor = UIColor(white: 0, alpha: 0.45); sun.automaticallyAdjustsShadowProjection = true
        let sunNode = SCNNode(); sunNode.light = sun
        sunNode.simdPosition = SIMD3(14, 22, 12); sunNode.simdLook(at: .zero)
        scene.rootNode.addChildNode(sunNode)

        let fill = SCNLight(); fill.type = .ambient; fill.intensity = 250
        fill.color = UIColor(red: 0.85, green: 0.9, blue: 1, alpha: 1)
        let fillNode = SCNNode(); fillNode.light = fill; scene.rootNode.addChildNode(fillNode)

        let cam = SCNCamera(); cam.fieldOfView = 40; cam.zNear = 0.1; cam.zFar = 400
        cam.wantsHDR = true; cam.wantsExposureAdaptation = false; cam.bloomIntensity = 0.2; cam.vignettingIntensity = 0.25
        let camNode = SCNNode(); camNode.name = "camera"; camNode.camera = cam
        camNode.simdPosition = SIMD3(11.5, 8, 14); camNode.simdLook(at: SIMD3(0, 1.2, 0))
        scene.rootNode.addChildNode(camNode)

        cache.setObject(scene, forKey: spot.id as NSString)
        return scene
    }

    nonisolated(unsafe) private static let thumbCache = NSCache<NSString, UIImage>()
    @MainActor
    static func snapshot(for spot: Spot3D, size: CGSize = CGSize(width: 480, height: 320)) -> UIImage {
        if let img = thumbCache.object(forKey: spot.id as NSString) { return img }
        let renderer = SCNRenderer(device: MTLCreateSystemDefaultDevice(), options: nil)
        let scene = makeScene(for: spot)
        renderer.scene = scene
        renderer.pointOfView = scene.rootNode.childNode(withName: "camera", recursively: false)
        let img = renderer.snapshot(atTime: 0, with: size, antialiasingMode: .multisampling4X)
        thumbCache.setObject(img, forKey: spot.id as NSString)
        return img
    }

    static func usdzForAR(_ spot: Spot3D) -> URL? {
        if let url = bundledURL(spot) { return url }
        let out = FileManager.default.temporaryDirectory.appendingPathComponent("\(spot.id).usdz")
        if FileManager.default.fileExists(atPath: out.path) { return out }
        let scene = SCNScene(); scene.rootNode.addChildNode(ProceduralSpotBuilder.build(spot))
        return scene.write(to: out, options: nil, delegate: nil, progressHandler: nil) ? out : nil
    }
}
