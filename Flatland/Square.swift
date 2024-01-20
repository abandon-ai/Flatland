import SpriteKit
import UIKit

class Square: SKSpriteNode {
    private let moveDistance: CGFloat = 1.0
    
    private var leftEye: SKNode!
    private var rightEye: SKNode!
    private var mouth: SKNode!
    // Temperature is the emotional expression value of the character, [0, 1].
    private var temperature: CGFloat = 0.5
    // Speed
    private var v: CGFloat = 100
    // zRotation
    private var z: CGFloat = 0
    let width: CGFloat = 64.0
    
    init() {
        super.init(texture: nil, color: .clear, size: CGSize(width: width, height: width))
        
        let squareBodyNode = createSquareBodyNode(size: CGSize(width: width, height: width), blurRadius: 10, colors: ["#3D70E5", "#CEFEEC"])
        let squareStrokeNode = CreateBloomStrokeNode(size: CGSize(width: width, height: width), lineWidth: 4, radius: 0, bloomIntensity: 2.0, bloomRadius: 10.0)
        
        leftEye = createEyeNode()
        rightEye = createEyeNode()
        mouth = createMouth()
        
        self.lookLeft()
        
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
        let eye = SKShapeNode(rectOf: CGSize(width: width / 6, height: width / 6), cornerRadius: width / 3)
        eye.fillColor = SKColor.black
        eye.lineWidth = 0
        return eye
    }
    
    private func createMouth() -> SKShapeNode {
        let mouthWidth: CGFloat = width / 6
        let mouthHeight: CGFloat = width / 12
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -1 * mouthWidth / 2, y: 0))
        if (self.temperature < 0.4) {
            path.addLine(to: CGPoint(x: 0, y: mouthHeight))
        }
        path.addLine(to: CGPoint(x: mouthWidth / 2, y: 0))
        
        let mouth = SKShapeNode(path: path.cgPath)
        mouth.fillColor = SKColor.clear
        mouth.lineWidth = width / 24
        mouth.strokeColor = SKColor.black
        
        return mouth
    }
    
    private func createSquareNode(size: CGSize, blurRadius: CGFloat, colors: [String], bloomIntensity: CGFloat, bloomRadius: CGFloat) -> SKSpriteNode {
        let squareBodyNode = createSquareBodyNode(size: size, blurRadius: blurRadius, colors: colors)
        let squareStrokeNode = CreateBloomStrokeNode(size: size, lineWidth: 4, radius: 0, bloomIntensity: bloomIntensity, bloomRadius: bloomRadius)
        
        let squareNode = SKSpriteNode()
        squareNode.addChild(squareBodyNode)
        squareNode.addChild(squareStrokeNode)
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
    
    private func lookRight() {
        leftEye.position = CGPoint(x: -width / 6, y: width / 6)
        rightEye.position = CGPoint(x: width / 1.5, y: width / 6 + width / 24)
        mouth.position = CGPoint(x: width / 4, y: width / 6 - width / 24)
    }
    
    private func lookLeft() {
        leftEye.position = CGPoint(x: -width / 6, y: -width / 6)
        rightEye.position = CGPoint(x: width / 1.5, y: -width / 6 - width / 24)
        mouth.position = CGPoint(x: width / 4, y: -width / 6 + width / 24)
    }
    
    func updateZ(angle value: CGFloat) {
        self.zRotation = value
        z = value
    }
    
    func update() {
        self.mouth?.removeFromParent()
        let newMouth = createMouth()
        self.addChild(newMouth)
        self.mouth = newMouth
        
        if abs(z).truncatingRemainder(dividingBy: 2 * .pi) > .pi / 2 {
            self.lookLeft()
        } else {
            self.lookRight()
        }
    }
}
