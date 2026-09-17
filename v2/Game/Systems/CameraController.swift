//
//  CameraController.swift
//  v2
//
//  Created by Calzy Akmal Indyramdhani on 17/09/26.
//

import Foundation
import CoreGraphics

/// Smooth-follow camera with room-boundary clamping (FR-012). Kept as pure math over
/// a target/current position pair so `PlayerNode` position-sync (FR-013) is a simple
/// child-of-scene relationship — see research.md §5.
enum CameraController {

    static func update(currentPosition: CGPoint, target: CGPoint, viewportSize: CGSize, room: CGRect, deltaTime: TimeInterval) -> CGPoint {
        let lerpAmount = 1.0 - pow(1.0 - GameConfig.cameraFollowLerpFactor, deltaTime * 60.0)

        let lerped = CGPoint(
            x: currentPosition.x + (target.x - currentPosition.x) * lerpAmount,
            y: currentPosition.y + (target.y - currentPosition.y) * lerpAmount
        )

        return clamp(lerped, viewportSize: viewportSize, room: room)
    }

    private static func clamp(_ point: CGPoint, viewportSize: CGSize, room: CGRect) -> CGPoint {
        let halfWidth = viewportSize.width / 2 - GameConfig.roomBoundsInset
        let halfHeight = viewportSize.height / 2 - GameConfig.roomBoundsInset

        let minX = room.minX + halfWidth
        let maxX = room.maxX - halfWidth
        let minY = room.minY + halfHeight
        let maxY = room.maxY - halfHeight

        guard minX <= maxX, minY <= maxY else {
            // Room smaller than viewport minus inset — center instead of clamping to an inverted range.
            return CGPoint(x: room.midX, y: room.midY)
        }

        return CGPoint(
            x: min(max(point.x, minX), maxX),
            y: min(max(point.y, minY), maxY)
        )
    }
}
