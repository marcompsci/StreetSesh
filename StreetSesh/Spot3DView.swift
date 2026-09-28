//  Spot3DView.swift
//  Interactive 3D viewer: drag to orbit, pinch to zoom, slow auto-spin.

import SwiftUI
import SceneKit

struct Spot3DView: UIViewRepresentable {
    let spot: Spot3D
    var autoSpin: Bool = true

    func makeUIView(context: Context) -> SCNView {
        let v = SCNView()
        v.scene = SpotSceneFactory.makeScene(for: spot)
        v.pointOfView = v.scene?.rootNode.childNode(withName: "camera", recursively: false)
        v.allowsCameraControl = true
        v.defaultCameraController.interactionMode = .orbitTurntable
        v.defaultCameraController.target = SCNVector3(0, 1.2, 0)
        v.defaultCameraController.maximumVerticalAngle = 80
        v.defaultCameraController.minimumVerticalAngle = 5
        v.antialiasingMode = .multisampling4X
        v.preferredFramesPerSecond = 60
        v.backgroundColor = .clear
        v.rendersContinuously = false
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.stopSpin))
        tap.cancelsTouchesInView = false; v.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.stopSpin))
        pan.cancelsTouchesInView = false; pan.delegate = context.coordinator; v.addGestureRecognizer(pan)
        context.coordinator.view = v
        if autoSpin { context.coordinator.startSpin() }
        return v
    }

    func updateUIView(_ v: SCNView, context: Context) {}

    static func dismantleUIView(_ v: SCNView, coordinator: Coordinator) {
        v.scene?.rootNode.childNode(withName: SpotSceneFactory.turntableName, recursively: false)?.removeAllActions()
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        weak var view: SCNView?
        func startSpin() {
            guard let t = view?.scene?.rootNode.childNode(withName: SpotSceneFactory.turntableName, recursively: false) else { return }
            t.removeAllActions()
            t.runAction(.repeatForever(.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 40)), forKey: "spin")
            view?.rendersContinuously = true
        }
        @objc func stopSpin() {
            view?.scene?.rootNode.childNode(withName: SpotSceneFactory.turntableName, recursively: false)?.removeAction(forKey: "spin")
        }
        func gestureRecognizer(_ g: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool { true }
    }
}
