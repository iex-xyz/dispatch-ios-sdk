import UIKit
import SpriteKit
import SwiftUI

@available(iOS 15.0, *)
/// A SwiftUI wrapper for SKView to display particle effects
struct ParticleView: UIViewRepresentable {
    let size: CGSize
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.allowsTransparency = true
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Only create a new scene if one doesn't exist or if the size has changed
        // This prevents unnecessary scene recreation and improves performance
        if uiView.scene == nil || uiView.scene?.size != size {
            let scene = ParticleScene(size: size)
            scene.scaleMode = .aspectFill
            uiView.presentScene(scene)
        }
    }
}

/// Custom SKScene for rendering particle effects
@available(iOS 15.0, *)
class ParticleScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        setupScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScene() {
        backgroundColor = .clear
        removeAllChildren()
        
        // Load the confetti image from the app's asset catalog
        guard let confettiImage = UIImage(named: "confetti", in: .module, compatibleWith: nil) else {
            return
        }
        
        let emitter = SKEmitterNode()
        emitter.particleTexture = SKTexture(image: confettiImage)
        
        // Configure the emitter for a confetti-like effect
        // These values can be adjusted to change the appearance of the particles
        emitter.numParticlesToEmit = 400
        emitter.particleBirthRate = 80.385
        emitter.particleLifetime = 7
        emitter.particleLifetimeRange = 2
        emitter.particlePositionRange = CGVector(dx: 700.247, dy: 0)
        emitter.position = CGPoint(x: size.width / 2, y: size.height + 60)
        emitter.particleSpeed = 70.322
        emitter.particleSpeedRange = 50
        emitter.yAcceleration = -250 // Gravity effect
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
}

