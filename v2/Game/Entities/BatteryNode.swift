//
//  BatteryNode.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import SpriteKit

/// Placeholder loose-battery pickup. Removed from the scene once `GameState.worldBattery`
/// transitions out of `.world` — it never reappears (FR-016).
final class BatteryNode: SKShapeNode {

    init(radius: CGFloat = 14) {
        super.init()
        path = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: radius * 2, height: radius * 2), transform: nil)
        fillColor = .systemGreen
        strokeColor = .white
        lineWidth = 2
        zPosition = 5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
