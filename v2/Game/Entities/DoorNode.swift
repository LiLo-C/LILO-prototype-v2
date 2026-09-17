//
//  DoorNode.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import SpriteKit

/// Placeholder door. One-way `isOpen` transition, visually distinguished by color (FR-010).
final class DoorNode: SKShapeNode {

    init(size: CGSize = CGSize(width: 40, height: 80)) {
        super.init()
        path = CGPath(rect: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height), transform: nil)
        fillColor = .systemBrown
        strokeColor = .white
        lineWidth = 2
        zPosition = 4
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setOpen(_ isOpen: Bool) {
        fillColor = isOpen ? .systemTeal : .systemBrown
        alpha = isOpen ? 0.4 : 1.0
    }
}
