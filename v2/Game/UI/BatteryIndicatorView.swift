//
//  BatteryIndicatorView.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import SwiftUI

/// Persistent HUD bar for the flashlight's charge, plus a spare-slot indicator
/// (FR-017). Gives FR-008's pickup-rejection feedback a persistent explanation
/// beyond the action button's transient shake.
struct BatteryIndicatorView: View {
    var gameState: GameState

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.2))
                    Capsule()
                        .fill(barColor)
                        .frame(width: geo.size.width * CGFloat(max(0, min(1, gameState.batteryChargeFraction))))
                }
            }
            .frame(width: 140, height: 14)

            HStack(spacing: 6) {
                Circle()
                    .fill(gameState.spareSlotOccupied ? Color.green : Color.white.opacity(0.25))
                    .frame(width: 10, height: 10)
                Text(gameState.spareSlotOccupied ? "Spare: full" : "Spare: empty")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
    }

    private var barColor: Color {
        switch gameState.lightState {
        case .normal: return .green
        case .flickering: return .yellow
        case .critical: return .orange
        case .compactDarkness: return .red
        }
    }
}
