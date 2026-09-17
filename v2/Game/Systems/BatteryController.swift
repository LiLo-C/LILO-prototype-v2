//
//  BatteryController.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import Foundation

/// Real-time battery drain, pickup, and install logic (FR-004, FR-007, FR-008, FR-009, FR-016).
/// Wall-clock driven, not frame-count driven — see research.md §3.
enum BatteryController {

    static func drain(deltaTime: TimeInterval, state: GameState) {
        guard var battery = state.installedBattery else { return }
        battery.charge = max(0, battery.charge - deltaTime)
        state.installedBattery = battery
    }

    /// worldBattery → .spare (FR-007). Rejected when the spare slot is already occupied (FR-008).
    static func pickupWorldBattery(state: GameState) {
        guard var world = state.worldBattery, world.location == .world else { return }

        guard state.spareBattery == nil else {
            state.pickupRejected = true
            return
        }

        world.location = .spare
        state.spareBattery = world
        state.worldBattery = nil // never respawns — FR-016
        state.pickupRejected = false
    }

    /// spareBattery → .installed: always a full refill, discarding whatever was installed (FR-009).
    static func installSpareBattery(state: GameState) {
        guard var spare = state.spareBattery else { return }
        spare.charge = GameConfig.batteryDuration
        spare.location = .installed
        state.installedBattery = spare
        state.spareBattery = nil
    }
}
