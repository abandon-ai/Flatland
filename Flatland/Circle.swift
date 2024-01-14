import SpriteKit

class Circle: SKSpriteNode {
    init() {
        super.init(texture: nil, color: .clear, size: CGSize(width: 96, height: 96))
        let circleStrokeNode = createBloomStrokeNode(size: CGSize(width: 96, height: 96), lineWidth: 4, radius: 48, bloomIntensity: 2.0, bloomRadius: 10)
        self.addChild(circleStrokeNode)
        self.alpha = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createAndRunFadeOutAction() {
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
        ]))
    }
}
