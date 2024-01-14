import SpriteKit

class Background: SKSpriteNode {
    init(size: CGSize) {
       let gradientLayer = CreateGradientLayer(frame: CGRect(origin: .zero, size: size), colors: ["#6775F2", "#D585F6"], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
       let backgroundImage = CreateImage(from: gradientLayer)
       let backgroundTexture = SKTexture(image: backgroundImage)
       super.init(texture: backgroundTexture, color: .clear, size: size)
       self.zPosition = -1
   }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
