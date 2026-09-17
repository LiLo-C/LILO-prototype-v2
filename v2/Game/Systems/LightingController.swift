import SpriteKit
import SceneKit
import UIKit

/// Drives the 2D vignette and the 3D spotlight from the same `LightState` so their
/// radius never disagrees (FR-005, FR-006). The vignette is a fixed-size "hole" mask
/// sprite that gets scaled per frame, rather than a texture regenerated every frame.
enum LightingController {

    static func update(lightState: LightState, vignetteMask: SKSpriteNode, spotLight: SCNLight) {
        let radiusFraction: CGFloat
        switch lightState {
        case .normal:
            radiusFraction = 1.0
        case .flickering:
            radiusFraction = CGFloat.random(in: 0.75...0.95)
        case .critical:
            radiusFraction = 0.4
        case .compactDarkness:
            radiusFraction = CGFloat(GameConfig.compactDarknessRadiusFraction)
        }

        vignetteMask.setScale(radiusFraction)

        spotLight.spotOuterAngle = lightState == .compactDarkness ? 15 : 45
        spotLight.intensity = lightState == .compactDarkness ? 200 : 1000
    }

    /// A generously large square texture: opaque white everywhere except a
    /// transparent circular hole at its center, at `holeRadius` of `size`.
    static func makeVignetteHoleTexture(size: CGFloat, holeRadius: CGFloat) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let image = renderer.image { context in
            let cg = context.cgContext
            cg.setFillColor(UIColor.white.cgColor)
            cg.fill(CGRect(x: 0, y: 0, width: size, height: size))
            cg.setBlendMode(.clear)
            let center = CGPoint(x: size / 2, y: size / 2)
            let holeRect = CGRect(x: center.x - holeRadius, y: center.y - holeRadius, width: holeRadius * 2, height: holeRadius * 2)
            cg.fillEllipse(in: holeRect)
        }
        return SKTexture(image: image)
    }
}
