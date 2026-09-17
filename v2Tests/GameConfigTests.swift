//
//  GameConfigTests.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import XCTest
@testable import v2

final class GameConfigTests: XCTestCase {

    func testAllTunablesArePositive() {
        XCTAssertGreaterThan(GameConfig.walkSpeed, 0)
        XCTAssertGreaterThan(GameConfig.sprintMultiplier, 1)
        XCTAssertTrue(GameConfig.sprintJoystickThreshold > 0 && GameConfig.sprintJoystickThreshold <= 1)
        XCTAssertGreaterThan(GameConfig.interactionRadius, 0)
        XCTAssertGreaterThan(GameConfig.batteryDuration, 0)
        XCTAssertGreaterThan(GameConfig.lightStateFlickerStart, GameConfig.lightStateCriticalStart)
        XCTAssertGreaterThan(GameConfig.lightStateCriticalStart, 0)
        XCTAssertTrue(GameConfig.compactDarknessRadiusFraction > 0 && GameConfig.compactDarknessRadiusFraction < 1)
        XCTAssertTrue(GameConfig.cameraFollowLerpFactor > 0 && GameConfig.cameraFollowLerpFactor <= 1)
        XCTAssertGreaterThanOrEqual(GameConfig.roomBoundsInset, 0)
    }

    func testBatteryDurationMatchesSpecFR004() {
        // FR-004: a fully charged battery reaches 0% at exactly 180 seconds.
        XCTAssertEqual(GameConfig.batteryDuration, 180)
    }
}
