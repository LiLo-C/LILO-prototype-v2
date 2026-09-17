//
//  LightStateTests.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import XCTest
@testable import v2

final class LightStateTests: XCTestCase {

    private func makeState(charge: Double) -> GameState {
        let room = TestRoom(
            bounds: CGRect(x: -600, y: -400, width: 1200, height: 800),
            playerSpawn: CGPoint(x: 0, y: -300),
            batterySpawn: CGPoint(x: 220, y: 60),
            doorPosition: CGPoint(x: 0, y: 330)
        )
        let state = GameState(room: room)
        state.installedBattery = Battery(charge: charge, location: .installed)
        return state
    }

    // FR-005 exact boundaries: 30% < charge <= 100% is .normal.
    func testNormalRange() {
        XCTAssertEqual(makeState(charge: 180).lightState, .normal) // 100%
        XCTAssertEqual(makeState(charge: 54.01).lightState, .normal) // just above 30%
    }

    // Exactly 30% charge is .flickering, not .normal.
    func testExactly30PercentIsFlickering() {
        XCTAssertEqual(makeState(charge: 54).lightState, .flickering) // exactly 30% of 180
    }

    func testFlickeringRange() {
        XCTAssertEqual(makeState(charge: 18.01).lightState, .flickering) // just above 10%
    }

    // Exactly 10% charge is .critical, not .flickering.
    func testExactly10PercentIsCritical() {
        XCTAssertEqual(makeState(charge: 18).lightState, .critical) // exactly 10% of 180
    }

    func testCriticalRange() {
        XCTAssertEqual(makeState(charge: 0.01).lightState, .critical) // just above 0
    }

    func testExactlyZeroIsCompactDarkness() {
        XCTAssertEqual(makeState(charge: 0).lightState, .compactDarkness)
    }
}
