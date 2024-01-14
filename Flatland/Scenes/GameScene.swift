import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    var squareNode = SquareNode()
    private var circleNode : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        // Background
        let backgroundNode = createBackgroundNode(size: self.size, colors: ["#6775F2", "#D585F6"], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
        backgroundNode.position = .zero
        backgroundNode.zPosition = -1
        self.addChild(backgroundNode)
        
        // Circle Node
        createCircleNode()
        self.addChild(squareNode)
    }

    private func createBackgroundNode(size: CGSize, colors: [String], startPoint: CGPoint, endPoint: CGPoint) -> SKSpriteNode {
        let gradientLayer = createGradientLayer(frame: CGRect(origin: .zero, size: size), colors: colors, startPoint: startPoint, endPoint: endPoint)
        let backgroundImage = image(from: gradientLayer)
        let backgroundTexture = SKTexture(image: backgroundImage)
        return SKSpriteNode(texture: backgroundTexture)
    }

    private func createCircleNode() {
        let circleStrokeNode = createBloomStrokeNode(size: CGSize(width: 96, height: 96), lineWidth: 4, radius: 48, bloomIntensity: 2.0, bloomRadius: 10)
        circleNode = SKSpriteNode()
        circleNode.addChild(circleStrokeNode)
        circleNode.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
        ]))
        circleNode.alpha = 0.5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let n = self.circleNode?.copy() as! SKNode? {
                n.position = location
                self.addChild(n)
            }
            if squareNode.contains(location) {
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                    feedbackGenerator.prepare()
                    feedbackGenerator.impactOccurred()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let n = self.circleNode?.copy() as! SKNode? {
                n.position = location
                self.addChild(n)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let location = touch.location(in: self)
            if let n = self.circleNode?.copy() as! SKNode? {
                n.position = location
                self.addChild(n)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let n = self.circleNode?.copy() as! SKNode? {
                n.position = location
                self.addChild(n)
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
