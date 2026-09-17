//
//  GameConfig.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import Foundation

/// Single source of truth for every tunable number in the Phase 1 prototype.
/// See specs/001-core-prototype/contracts/game-config.md.
enum GameConfig {

    // MARK: - Player

    static let walkSpeed: Double = 1.0
    static let sprintMultiplier: Double = 1.6
    static let sprintJoystickThreshold: Double = 0.9
    static let interactionRadius: Double = 60.0

    // MARK: - Light & Battery

    static let batteryDuration: Double = 180.0
    static let lightStateFlickerStart: Double = 0.30
    static let lightStateCriticalStart: Double = 0.10
    static let compactDarknessRadiusFraction: Double = 0.10

    // MARK: - Camera

    static let cameraFollowLerpFactor: Double = 0.12
    static let roomBoundsInset: Double = 80.0
}
