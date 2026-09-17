//
//  PlayerNode.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import SpriteKit
import SceneKit
import UIKit

/// Placeholder 3D player character (a capsule) rendered via `SK3DNode` over the 2D
/// environment — the phase's core technical-risk validation (FR-013).
final class PlayerNode: SK3DNode {

    let spotLight = SCNLight()
    private let characterNode: SCNNode

    override init(viewportSize: CGSize) {
        let capsule = SCNCapsule(capRadius: 0.35, height: 1.8)
        capsule.firstMaterial?.diffuse.contents = UIColor.systemOrange
        characterNode = SCNNode(geometry: capsule)
        characterNode.position = SCNVector3(0, 0.9, 0)

        super.init(viewportSize: viewportSize)

        let scene = SCNScene()
        scene.rootNode.addChildNode(characterNode)

        spotLight.type = .spot
        spotLight.spotOuterAngle = 45
        spotLight.intensity = 1000
        spotLight.castsShadow = true
        let lightNode = SCNNode()
        lightNode.light = spotLight
        lightNode.position = SCNVector3(0, 2.2, 0.2)
        lightNode.look(at: characterNode.position)
        scene.rootNode.addChildNode(lightNode)

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        // Fixed local framing of the capsule; the outer SK2D position (set each
        // frame from GameState.player.position) is what makes it follow the
        // SpriteKit camera pan, since zoom is fixed — see research.md §5.
        cameraNode.position = SCNVector3(0, 1.6, 3.2)
        cameraNode.look(at: characterNode.position)
        scene.rootNode.addChildNode(cameraNode)
        scene.background.contents = UIColor.clear

        self.scnScene = scene
        self.pointOfView = cameraNode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Rotate the capsule to match movement direction — cheap stand-in for facing
    /// until real directional art exists.
    func updateFacing(_ direction: CGVector) {
        let angle = atan2(direction.dx, direction.dy)
        characterNode.eulerAngles.y = Float(angle)
    }
}
