//
//  InteractionController.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import Foundation
import CoreGraphics

enum Interactable: Equatable {
    case none
    case pickUpBattery
    case installBattery
    case openDoor
}

/// Nearest-interactable detection for the context-sensitive action button
/// (FR-007, FR-009, FR-010, FR-011) — see contracts/action-button-states.md for the
/// exact priority rule this mirrors.
enum InteractionController {

    static func nearestInteractable(state: GameState) -> Interactable {
        let doorInRange = !state.door.isOpen
            && distance(state.player.position, state.room.doorPosition) <= GameConfig.interactionRadius

        let batteryPickupInRange = state.worldBattery != nil
            && distance(state.player.position, state.room.batterySpawn) <= GameConfig.interactionRadius

        // Both are position-gated (have a real distance to compare) — nearest wins.
        if doorInRange && batteryPickupInRange {
            let doorDistance = distance(state.player.position, state.room.doorPosition)
            let batteryDistance = distance(state.player.position, state.room.batterySpawn)
            return doorDistance <= batteryDistance ? .openDoor : .pickUpBattery
        }

        if doorInRange { return .openDoor }
        if batteryPickupInRange { return .pickUpBattery }

        // Installing the spare isn't position-gated — available anywhere except
        // when the door already took priority above (contracts/action-button-states.md).
        if state.spareBattery != nil { return .installBattery }

        return .none
    }

    private static func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let dx = a.x - b.x
        let dy = a.y - b.y
        return (dx * dx + dy * dy).squareRoot()
    }
}
