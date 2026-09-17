//
//  BatteryControllerTests.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import XCTest
@testable import v2

final class BatteryControllerTests: XCTestCase {

    private func makeState() -> GameState {
        let room = TestRoom(
            bounds: CGRect(x: -600, y: -400, width: 1200, height: 800),
            playerSpawn: CGPoint(x: 0, y: -300),
            batterySpawn: CGPoint(x: 220, y: 60),
            doorPosition: CGPoint(x: 0, y: 330)
        )
        return GameState(room: room)
    }

    // FR-004: a fully charged battery reaches 0 after 180s of wall-clock time.
    func testFullDrainAfter180Seconds() {
        let state = makeState()
        BatteryController.drain(deltaTime: 180, state: state)
        XCTAssertEqual(state.installedBattery?.charge, 0)
    }

    // FR-003: drain rate is identical whether idle or sprinting — the controller
    // only ever consumes deltaTime, never movementState, so this is definitional,
    // but assert it explicitly so a future change can't silently couple them.
    func testDrainIsIndependentOfMovementState() {
        let idleState = makeState()
        idleState.player.movementState = .idle
        BatteryController.drain(deltaTime: 10, state: idleState)

        let sprintingState = makeState()
        sprintingState.player.movementState = .sprinting
        BatteryController.drain(deltaTime: 10, state: sprintingState)

        XCTAssertEqual(idleState.installedBattery?.charge, sprintingState.installedBattery?.charge)
    }

    // FR-008: pickup rejected when the spare slot is already occupied; item stays in the world.
    func testPickupRejectedWhenSpareSlotFull() {
        let state = makeState()
        state.spareBattery = Battery(charge: 180, location: .spare)
        let worldBefore = state.worldBattery

        BatteryController.pickupWorldBattery(state: state)

        XCTAssertTrue(state.pickupRejected)
        XCTAssertEqual(state.worldBattery?.charge, worldBefore?.charge)
        XCTAssertEqual(state.worldBattery?.location, .world)
    }

    func testPickupSucceedsWhenSpareSlotEmpty() {
        let state = makeState()
        BatteryController.pickupWorldBattery(state: state)

        XCTAssertFalse(state.pickupRejected)
        XCTAssertNil(state.worldBattery)
        XCTAssertEqual(state.spareBattery?.location, .spare)
    }

    // FR-016: the world battery never respawns once collected.
    func testWorldBatteryNeverRespawnsAfterPickup() {
        let state = makeState()
        BatteryController.pickupWorldBattery(state: state)
        XCTAssertNil(state.worldBattery)

        // Even if the (already-collected) spare is later installed, worldBattery stays nil.
        BatteryController.installSpareBattery(state: state)
        XCTAssertNil(state.worldBattery)
    }

    // FR-009: install always sets charge to exactly batteryDuration and discards the old one.
    func testInstallAlwaysFullyRefillsAndDiscardsPrevious() {
        let state = makeState()
        state.installedBattery = Battery(charge: 12, location: .installed) // nearly empty
        state.spareBattery = Battery(charge: 180, location: .spare)

        BatteryController.installSpareBattery(state: state)

        XCTAssertEqual(state.installedBattery?.charge, GameConfig.batteryDuration)
        XCTAssertNil(state.spareBattery)
    }
}
