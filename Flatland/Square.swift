import SpriteKit
import UIKit

class Square: SKSpriteNode {
    init() {
        super.init(texture: nil, color: .clear, size: CGSize(width: 96, height: 96))
        
        let squareBodyNode = createSquareBodyNode(size: CGSize(width: 96, height: 96), blurRadius: 10, colors: ["#3D70E5", "#CEFEEC"])
        let squareStrokeNode = createBloomStrokeNode(size: CGSize(width: 96, height: 96), lineWidth: 4, radius: 0, bloomIntensity: 2.0, bloomRadius: 10.0)
        
        let leftEye = createEyeNode()
        let rightEye = createEyeNode()
        let nose = createNoseNode()
        
        leftEye.position = CGPoint(x: -16, y: 16)
        rightEye.position = CGPoint(x: 64, y: 20)
        nose.position = CGPoint(x: 24, y: 10)
        
        self.addChild(squareBodyNode)
        self.addChild(squareStrokeNode)
        self.addChild(leftEye)
        self.addChild(rightEye)
        self.addChild(nose)
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
    
    private func createNoseNode() -> SKShapeNode {
        let nose = SKShapeNode(rectOf: CGSize(width: 16, height: 4))
        nose.fillColor = SKColor.black
        nose.lineWidth = 0
        return nose
    }
    
    private func createSquareNode(size: CGSize, blurRadius: CGFloat, colors: [String], bloomIntensity: CGFloat, bloomRadius: CGFloat) -> SKSpriteNode {
        let squareBodyNode = createSquareBodyNode(size: size, blurRadius: blurRadius, colors: colors)
        let squareStrokeNode = createBloomStrokeNode(size: size, lineWidth: 4, radius: 0, bloomIntensity: bloomIntensity, bloomRadius: bloomRadius)
        
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
        
        let gradientLayer = createGradientLayer(frame: CGRect(origin: .zero, size: size), colors: colors, startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
        let gradientImage = image(from: gradientLayer)
        
        let spriteNode = SKSpriteNode(texture: SKTexture(image: gradientImage))
        effectNode.addChild(spriteNode)
        return effectNode
    }
}
