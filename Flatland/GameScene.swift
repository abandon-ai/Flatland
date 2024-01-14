import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var squareNode = Square()
    private var circleNode: Circle!
    
    override func didMove(to view: SKView) {
        let backgroundNode = Background(size: self.size)
        self.addChild(backgroundNode)
        
        circleNode = Circle()
        squareNode.name = "Angle"
        self.addChild(squareNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
