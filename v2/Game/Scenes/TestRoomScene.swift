//
//  TestRoomScene.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import SpriteKit
import SceneKit

/// The Phase 1 prototype room: one fixed space, one battery, one door — see
/// data-model.md "TestRoom". Owns no gameplay state itself; reads/writes through
/// the shared `GameState` each frame.
final class TestRoomScene: SKScene {

    private let state: GameState
    private var lastUpdateTime: TimeInterval?

    private var playerNode: PlayerNode!
    private var cameraNode: SKCameraNode!
    private var batteryNode: BatteryNode?
    private var doorNode: DoorNode!
    private var vignetteMask: SKSpriteNode!

    init(state: GameState, size: CGSize) {
        self.state = state
        super.init(size: size)
        scaleMode = .resizeFill
        backgroundColor = SKColor(white: 0.08, alpha: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        setUpRoom()
        setUpCamera()
        setUpPlayer()
        setUpBattery()
        setUpDoor()
        setUpVignette()
    }

    private func setUpRoom() {
        let bounds = state.room.bounds
        let floor = SKSpriteNode(color: SKColor(white: 0.2, alpha: 1), size: bounds.size)
        floor.position = CGPoint(x: bounds.midX, y: bounds.midY)
        floor.zPosition = 0
        addChild(floor)

        let walls = SKShapeNode(rect: bounds)
        walls.strokeColor = .darkGray
        walls.lineWidth = 6
        walls.fillColor = .clear
        walls.zPosition = 1
        addChild(walls)

        // Placeholder occluding object (e.g. a desk) — proves 2D-in-front-of-3D
        // layering works (FR-014).
        let desk = SKSpriteNode(color: .brown, size: CGSize(width: 90, height: 50))
        desk.position = CGPoint(x: state.room.playerSpawn.x + 40, y: state.room.playerSpawn.y + 120)
        desk.zPosition = 15 // above the player's default zPosition (10)
        addChild(desk)
    }

    private func setUpCamera() {
        cameraNode = SKCameraNode()
        cameraNode.position = state.player.position
        addChild(cameraNode)
        camera = cameraNode
    }

    private func setUpPlayer() {
        playerNode = PlayerNode(viewportSize: CGSize(width: 160, height: 220))
        playerNode.position = state.player.position
        playerNode.zPosition = 10
        addChild(playerNode)
    }

    private func setUpBattery() {
        guard state.worldBattery != nil else { return }
        let node = BatteryNode()
        node.position = state.room.batterySpawn
        addChild(node)
        batteryNode = node
    }

    private func setUpDoor() {
        doorNode = DoorNode()
        doorNode.position = state.room.doorPosition
        addChild(doorNode)
    }

    private func setUpVignette() {
        let textureSize: CGFloat = 2048
        let texture = LightingController.makeVignetteHoleTexture(size: textureSize, holeRadius: 480)
        let mask = SKSpriteNode(texture: texture)

        let overlay = SKSpriteNode(color: .black, size: CGSize(width: textureSize, height: textureSize))
        let crop = SKCropNode()
        crop.maskNode = mask
        crop.addChild(overlay)
        crop.zPosition = 100
        cameraNode.addChild(crop)

        vignetteMask = mask
    }

    override func update(_ currentTime: TimeInterval) {
        defer { lastUpdateTime = currentTime }
        guard let last = lastUpdateTime else { return }
        let deltaTime = min(currentTime - last, 1.0 / 15.0) // clamp huge gaps (e.g. app resume)

        MovementController.update(joystickVector: state.joystickVector, deltaTime: deltaTime, state: state)
        BatteryController.drain(deltaTime: deltaTime, state: state)

        playerNode.position = state.player.position
        playerNode.updateFacing(state.player.facingDirection)

        cameraNode.position = CameraController.update(
            currentPosition: cameraNode.position,
            target: state.player.position,
            viewportSize: size,
            room: state.room.bounds,
            deltaTime: deltaTime
        )

        LightingController.update(lightState: state.lightState, vignetteMask: vignetteMask, spotLight: playerNode.spotLight)

        if state.worldBattery == nil, let node = batteryNode {
            node.removeFromParent()
            batteryNode = nil
        }
        doorNode.setOpen(state.door.isOpen)

        state.nearestInteractable = InteractionController.nearestInteractable(state: state)
    }
}
