//
//  MovementController.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import Foundation
import CoreGraphics

/// Converts joystick input into player movement. Pure logic over `GameState`,
/// independent of SpriteKit so it stays unit-testable — see research.md §4.
enum MovementController {

    static func update(joystickVector: CGVector, deltaTime: TimeInterval, state: GameState) {
        let deflection = min(1.0, (joystickVector.dx * joystickVector.dx + joystickVector.dy * joystickVector.dy).squareRoot())

        guard deflection > 0.001 else {
            state.player.movementState = .idle
            return
        }

        let isSprinting = deflection >= GameConfig.sprintJoystickThreshold
        state.player.movementState = isSprinting ? .sprinting : .walking

        let speed = GameConfig.walkSpeed * (isSprinting ? GameConfig.sprintMultiplier : 1.0)
        let normalized = CGVector(dx: joystickVector.dx / deflection, dy: joystickVector.dy / deflection)
        state.player.facingDirection = normalized

        let pointsPerSecond = speed * 200.0 // world-unit-to-point scale for this room's dimensions
        let dx = normalized.dx * deflection * pointsPerSecond * deltaTime
        let dy = normalized.dy * deflection * pointsPerSecond * deltaTime

        var next = state.player.position
        next.x += dx
        next.y += dy

        state.player.position = clamp(next, to: state.room.bounds)
    }

    /// Player-to-wall collision — kept separate from camera clamping (spec Edge Cases).
    private static func clamp(_ point: CGPoint, to bounds: CGRect) -> CGPoint {
        CGPoint(
            x: min(max(point.x, bounds.minX), bounds.maxX),
            y: min(max(point.y, bounds.minY), bounds.maxY)
        )
    }
}
