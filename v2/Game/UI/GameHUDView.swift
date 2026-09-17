//
//  GameHUDView.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import SwiftUI

/// Composes the joystick (left), action button (right), and battery indicator
/// (top) over the SpriteKit view — per GDD Ch. 15.1's HUD layout.
struct GameHUDView: View {
    var gameState: GameState

    var body: some View {
        VStack {
            HStack {
                BatteryIndicatorView(gameState: gameState)
                    .padding(.leading, 24)
                Spacer()
            }
            .padding(.top, 24)

            Spacer()

            HStack {
                JoystickView(gameState: gameState)
                    .padding(.leading, 32)
                Spacer()
                ActionButtonView(gameState: gameState)
                    .padding(.trailing, 32)
            }
            .padding(.bottom, 40)
        }
    }
}
