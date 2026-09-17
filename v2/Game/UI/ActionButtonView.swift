//
//  ActionButtonView.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import SwiftUI

/// Single context-sensitive action button, right side of the screen — see
/// contracts/action-button-states.md (FR-007, FR-009, FR-010, FR-011).
struct ActionButtonView: View {
    var gameState: GameState

    @State private var showRejection = false

    private var label: String? {
        switch gameState.nearestInteractable {
        case .none: return nil
        case .pickUpBattery: return "Pick up"
        case .installBattery: return "Install battery"
        case .openDoor: return "Open door"
        }
    }

    var body: some View {
        Group {
            if let label {
                Button(action: performAction) {
                    Text(label)
                        .font(.headline)
                        .padding()
                        .background(Circle().fill(Color.white.opacity(0.85)))
                }
                .offset(x: showRejection ? -6 : 0)
                .animation(showRejection ? .default.repeatCount(3, autoreverses: true) : .default, value: showRejection)
            }
        }
        .frame(width: 90, height: 90)
    }

    private func performAction() {
        switch gameState.nearestInteractable {
        case .pickUpBattery:
            BatteryController.pickupWorldBattery(state: gameState)
            if gameState.pickupRejected {
                showRejection = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { showRejection = false }
            }
        case .installBattery:
            BatteryController.installSpareBattery(state: gameState)
        case .openDoor:
            gameState.door.isOpen = true
        case .none:
            break
        }
    }
}
