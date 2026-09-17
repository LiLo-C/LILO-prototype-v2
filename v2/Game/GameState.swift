//
//  GameState.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import Foundation
import CoreGraphics

enum MovementState: Equatable {
    case idle
    case walking
    case sprinting
}

enum BatteryLocation: Equatable {
    case world
    case spare
    case installed
}

struct Battery: Equatable {
    var charge: Double
    var location: BatteryLocation
}

enum LightState: Equatable {
    case normal
    case flickering
    case critical
    case compactDarkness
}

@Observable
final class PlayerCharacter {
    var position: CGPoint
    var movementState: MovementState = .idle
    var facingDirection: CGVector = CGVector(dx: 0, dy: 1)

    init(position: CGPoint) {
        self.position = position
    }
}

@Observable
final class Door {
    let position: CGPoint
    var isOpen: Bool = false

    init(position: CGPoint) {
        self.position = position
    }
}

struct TestRoom {
    let bounds: CGRect
    let playerSpawn: CGPoint
    let batterySpawn: CGPoint
    let doorPosition: CGPoint
}

/// Root aggregate for Phase 1 gameplay state. Owned by the SwiftUI root view and
/// shared, unowned, with the SpriteKit scene — see specs/001-core-prototype/research.md §2.
@Observable
final class GameState {
    let player: PlayerCharacter
    let door: Door
    let room: TestRoom

    var installedBattery: Battery?
    var spareBattery: Battery?
    var worldBattery: Battery?

    /// Set by BatteryController when a pickup is attempted while the spare slot is full (FR-008).
    /// Read-and-cleared by the UI layer to drive transient rejection feedback.
    var pickupRejected: Bool = false

    /// Written continuously by JoystickView, read each frame by MovementController.
    var joystickVector: CGVector = .zero

    /// Written each frame by InteractionController, read by ActionButtonView (FR-011).
    var nearestInteractable: Interactable = .none

    init(room: TestRoom) {
        self.room = room
        self.player = PlayerCharacter(position: room.playerSpawn)
        self.door = Door(position: room.doorPosition)
        self.installedBattery = Battery(charge: GameConfig.batteryDuration, location: .installed)
        self.worldBattery = Battery(charge: GameConfig.batteryDuration, location: .world)
        self.spareBattery = nil
    }

    /// Derived, never stored independently — see data-model.md "LightState (derived, not stored)".
    var lightState: LightState {
        guard let charge = installedBattery?.charge else { return .compactDarkness }
        let flickerStart = GameConfig.batteryDuration * GameConfig.lightStateFlickerStart
        let criticalStart = GameConfig.batteryDuration * GameConfig.lightStateCriticalStart

        if charge <= 0 {
            return .compactDarkness
        } else if charge <= criticalStart {
            return .critical
        } else if charge <= flickerStart {
            return .flickering
        } else {
            return .normal
        }
    }

    /// Derived HUD values — see data-model.md "Derived HUD values (not stored)".
    var batteryChargeFraction: Double {
        (installedBattery?.charge ?? 0) / GameConfig.batteryDuration
    }

    var spareSlotOccupied: Bool {
        spareBattery != nil
    }
}
