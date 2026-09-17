//
//  JoystickView.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import SwiftUI

/// 360° virtual joystick, left side of the screen (FR-001, FR-002). Reports a
/// normalized direction × deflection vector directly into `GameState`, read each
/// frame by `MovementController`.
struct JoystickView: View {
    var gameState: GameState

    private let baseRadius: CGFloat = 60
    @State private var knobOffset: CGSize = .zero

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: baseRadius * 2, height: baseRadius * 2)
            Circle()
                .fill(Color.white.opacity(0.45))
                .frame(width: baseRadius, height: baseRadius)
                .offset(knobOffset)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let dx = value.translation.width
                    let dy = value.translation.height
                    let distance = min(baseRadius, (dx * dx + dy * dy).squareRoot())
                    let angle = atan2(dy, dx)
                    knobOffset = CGSize(width: cos(angle) * distance, height: sin(angle) * distance)

                    let deflection = distance / baseRadius
                    // SpriteKit's Y axis points up; SwiftUI's drag translation.height points down.
                    gameState.joystickVector = CGVector(dx: cos(angle) * deflection, dy: -sin(angle) * deflection)
                }
                .onEnded { _ in
                    knobOffset = .zero
                    gameState.joystickVector = .zero
                }
        )
    }
}
