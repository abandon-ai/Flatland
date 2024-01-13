import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    private var squareNode : SKNode?
    private var circleNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        // add background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = [UIColor(hex: "#6775F2").cgColor, UIColor(hex: "#D585F6").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let backgroundTexture = SKTexture(image: backgroundImage!)

        let backgroundNode = SKSpriteNode(texture: backgroundTexture)
        backgroundNode.size = self.size
        backgroundNode.position = CGPoint(x: 0, y: 0)
        backgroundNode.zPosition = -1
        self.addChild(backgroundNode)
        
        // circleNode
        self.circleNode = SKShapeNode.init(rectOf: CGSize.init(width: 144, height: 144), cornerRadius: 144)
        if let spinnyNode = self.circleNode {
            spinnyNode.lineWidth = 4
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                                SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        // squareNode
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.frame = CGRect(origin: .zero, size: CGSize(width: 96, height: 96))
        gradientLayer2.colors = [UIColor(hex: "#3D70E5").cgColor, UIColor(hex: "#CEFEEC").cgColor]
        gradientLayer2.startPoint = CGPoint(x: 0.0, y: 0.5) // 左边开始
        gradientLayer2.endPoint = CGPoint(x: 1.0, y: 0.5) // 右边结束
        
        UIGraphicsBeginImageContext(gradientLayer2.bounds.size)
        gradientLayer2.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let texture = SKTexture(image: gradientImage2!)
        let characterSprite = SKSpriteNode(texture: texture)
        let squareBodyNode = SKEffectNode()
        squareBodyNode.shouldRasterize = true
        squareBodyNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 20.0])
        squareBodyNode.addChild(characterSprite)
        
        let borderNode = SKShapeNode(rectOf: CGSize(width: 96, height: 96))
        borderNode.strokeColor = SKColor.white
        borderNode.lineWidth = 4
        borderNode.fillColor = SKColor.clear
        
        let glowEffectNode = SKEffectNode()

        let bloomFilter = CIFilter(name: "CIBloom")!
        bloomFilter.setValue(1.0, forKey: kCIInputIntensityKey)
        bloomFilter.setValue(10.0, forKey: kCIInputRadiusKey)
        glowEffectNode.filter = bloomFilter
        glowEffectNode.shouldEnableEffects = true
        glowEffectNode.addChild(borderNode)
        
        self.squareNode = SKNode()
        self.squareNode?.addChild(squareBodyNode)
        self.squareNode?.addChild(glowEffectNode)
        
        self.addChild(self.squareNode!)
    }
    
    func moveSquareNode(toPoint pos: CGPoint) {
        let asstNodeSpeed: CGFloat = 500
        if let squareNode = self.squareNode {
            let distance = hypot(pos.x - squareNode.position.x, pos.y - squareNode.position.y)
            let duration = TimeInterval(distance / asstNodeSpeed)
            
            let moveAction = SKAction.move(to: pos, duration: duration)
            squareNode.run(moveAction)
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.circleNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.white
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.circleNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.white
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.circleNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.white
            self.addChild(n)
        }
//        moveSquareNode(toPoint: pos)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
//            feedbackGenerator.prepare()
//            feedbackGenerator.impactOccurred()
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
