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
        
        emitter.numParticlesToEmit = 1000

        emitter.particleBirthRate = 360.385
        emitter.particleLifetime = 8
        emitter.particleLifetimeRange = 0
        emitter.particlePositionRange = CGVector(dx: 700.247, dy: 0)
        emitter.position = CGPoint(x: size.width / 2, y: size.height + 60) // Adjust based on your needs
        emitter.particleSpeed = 100.322
        emitter.particleSpeedRange = 250
        emitter.yAcceleration = -550
        emitter.particleAlpha = 1
        emitter.particleAlphaRange = 0
        emitter.particleAlphaSpeed = 0
        emitter.particleScale = 0.1
        emitter.particleScaleRange = 0.2
        emitter.particleScaleSpeed = 0
        emitter.particleRotation = CGFloat.pi / 4 // 45 degrees
        emitter.particleRotationRange = CGFloat.pi * 190.333 / 180 // Converted to radians
        emitter.particleRotationSpeed = CGFloat.pi * 79.658 / 180 // Converted to radians
        emitter.particleColorBlendFactor = 1
        emitter.particleColor = UIColor(Color.dispatchBlue)
        

        addChild(emitter)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
