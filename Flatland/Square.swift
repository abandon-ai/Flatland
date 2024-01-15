import SpriteKit
import UIKit

class Square: SKSpriteNode {
    private let moveDistance: CGFloat = 1.0
    
    private var leftEye: SKNode!
    private var rightEye: SKNode!
    private var mouth: SKNode!
    // Temperature is the emotional expression value of the character, [0, 1].
    private var temperature: CGFloat = 0.5
    
    init() {
        super.init(texture: nil, color: .clear, size: CGSize(width: 96, height: 96))
        
        let squareBodyNode = createSquareBodyNode(size: CGSize(width: 96, height: 96), blurRadius: 10, colors: ["#3D70E5", "#CEFEEC"])
        let squareStrokeNode = CreateBloomStrokeNode(size: CGSize(width: 96, height: 96), lineWidth: 4, radius: 0, bloomIntensity: 2.0, bloomRadius: 10.0)
        
        leftEye = createEyeNode()
        rightEye = createEyeNode()
        mouth = createMouth()
        
        self.lookRight()
        
        self.addChild(squareBodyNode)
        self.addChild(squareStrokeNode)
        self.addChild(leftEye)
        self.addChild(rightEye)
        self.addChild(mouth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createEyeNode() -> SKShapeNode {
        let eye = SKShapeNode(rectOf: CGSize(width: 16, height: 16), cornerRadius: 8)
        eye.fillColor = SKColor.black
        eye.lineWidth = 0
        return eye
    }
    
    private func createMouth() -> SKShapeNode {
        let mouthWidth: CGFloat = 16
        let mouthHeight: CGFloat = 8
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -1 * mouthWidth / 2, y: 0))
        if (self.temperature < 0.4) {
            path.addLine(to: CGPoint(x: 0, y: mouthHeight))
        }
        path.addLine(to: CGPoint(x: mouthWidth / 2, y: 0))
        
        let mouth = SKShapeNode(path: path.cgPath)
        mouth.fillColor = SKColor.clear
        mouth.lineWidth = 4
        mouth.strokeColor = SKColor.black
        
        return mouth
    }
    
    private func createSquareNode(size: CGSize, blurRadius: CGFloat, colors: [String], bloomIntensity: CGFloat, bloomRadius: CGFloat) -> SKSpriteNode {
        let squareBodyNode = createSquareBodyNode(size: size, blurRadius: blurRadius, colors: colors)
        let squareStrokeNode = CreateBloomStrokeNode(size: size, lineWidth: 4, radius: 0, bloomIntensity: bloomIntensity, bloomRadius: bloomRadius)
        
        let leftEye = SKShapeNode(rectOf: CGSize(width: 16, height: 16), cornerRadius: 16)
        let rightEye = SKShapeNode(rectOf: CGSize(width: 16, height: 16), cornerRadius: 16)
        let noce = SKShapeNode(rectOf: CGSize(width: 16, height: 4))
        leftEye.fillColor = SKColor.black
        leftEye.lineWidth = 0
        noce.fillColor = SKColor.black
        noce.lineWidth = 0
        rightEye.fillColor = SKColor.black
        rightEye.lineWidth = 0
        leftEye.position = CGPoint(x: -16, y: 16)
        rightEye.position = CGPoint(x: 64, y: 20)
        noce.position = CGPoint(x: 24, y: 10)
        
        let squareNode = SKSpriteNode()
        squareNode.addChild(squareBodyNode)
        squareNode.addChild(squareStrokeNode)
        squareNode.addChild(leftEye)
        squareNode.addChild(rightEye)
        squareNode.addChild(noce)
        return squareNode
    }
    
    private func createSquareBodyNode(size: CGSize, blurRadius: CGFloat, colors: [String]) -> SKEffectNode {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": blurRadius])
        
        let gradientLayer = CreateGradientLayer(frame: CGRect(origin: .zero, size: size), colors: colors, startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
        let gradientImage = CreateImage(from: gradientLayer)
        
        let spriteNode = SKSpriteNode(texture: SKTexture(image: gradientImage))
        effectNode.addChild(spriteNode)
        return effectNode
    }
    
    func moveBy(x: CGFloat, y: CGFloat) {
        let moveUpAction = SKAction.moveBy(x: x, y: y, duration: 0.1)
        self.run(moveUpAction)
    }
    
    func rotate(clockwise: Bool, angle: CGFloat) {
        let rotateAction = SKAction.rotate(byAngle: clockwise ? -angle : angle, duration: 0.1)
        self.run(rotateAction)
    }
    
    func lookRight() {
        leftEye.position = CGPoint(x: -16, y: 16)
        rightEye.position = CGPoint(x: 64, y: 20)
        mouth.position = CGPoint(x: 24, y: 10)
    }
    
    func lookLeft() {
        leftEye.position = CGPoint(x: -16, y: -16)
        rightEye.position = CGPoint(x: 64, y: -20)
        mouth.position = CGPoint(x: 24, y: -10)
    }
    
    func update() {
        self.mouth?.removeFromParent()
        let newMouth = createMouth()
        self.addChild(newMouth)
        self.mouth = newMouth
    }
}
