import UIKit
import SpriteKit
import SwiftUI

@available(iOS 15.0, *)
class ParticleScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)

        backgroundColor = .clear

        guard
            let confettiImage = UIImage(named: "confetti", in: .module, compatibleWith: nil)
        else {
            return
        }
        
        let emitter = SKEmitterNode()
        let texture = SKTexture(image: confettiImage)
        emitter.particleTexture = texture
        
        emitter.numParticlesToEmit = 400
        emitter.particleBirthRate = 80.385
        emitter.particleLifetime = 7
        emitter.particleLifetimeRange = 2
        emitter.particlePositionRange = CGVector(dx: 700.247, dy: 0)
        emitter.position = CGPoint(x: size.width / 2, y: size.height + 60)
        emitter.particleSpeed = 70.322
        emitter.particleSpeedRange = 50
        emitter.yAcceleration = -250
        emitter.particleAlpha = 1
        emitter.particleAlphaRange = 0
        emitter.particleAlphaSpeed = 0
        
        // Adjust the particle size
        emitter.particleScale = 1.0 // Increase the base size
        emitter.xScale = 0.95
        emitter.particleScaleRange = 0.2 // Increase the size variation
        emitter.particleScaleSpeed = 0
        
        // Adjust rotation settings if needed
        emitter.particleRotation = CGFloat.pi / 4
        emitter.particleRotationRange = CGFloat.pi * 190.333 / 180
        emitter.particleRotationSpeed = CGFloat.pi * 79.658 / 180
        
        emitter.particleColorBlendFactor = 1
        emitter.particleColor = UIColor(Color.dispatchBlue)
        
        addChild(emitter)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

