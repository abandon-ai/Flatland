import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var squareNode = Square()
    private var circleNode: SKSpriteNode!
    private var gamePad: GamePad?
    
    var thumbstickX: CGFloat = 0.0
    var thumbstickY: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        configureGamePad()
        
        let backgroundNode = Background(size: self.size)
        self.addChild(backgroundNode)
        
        squareNode.name = "Angle"
        self.addChild(squareNode)
        
        let circleStrokeNode = CreateBloomStrokeNode(size: CGSize(width: 96, height: 96), lineWidth: 4, radius: 48, bloomIntensity: 2.0, bloomRadius: 10)
        circleNode = SKSpriteNode()
        circleNode.addChild(circleStrokeNode)
        circleNode.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
        ]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let n = self.circleNode?.copy() as! SKSpriteNode? {
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
            if let n = self.circleNode?.copy() as! SKSpriteNode? {
                n.position = location
                self.addChild(n)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let location = touch.location(in: self)
            if let n = self.circleNode?.copy() as! SKSpriteNode? {
                n.position = location
                self.addChild(n)
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let n = self.circleNode?.copy() as! SKSpriteNode? {
                n.position = location
                self.addChild(n)
            }
        }
    }
    
    private func configureGamePad() {
        gamePad = GamePad()
        
//        gamePad?.dpadLeftPressed = { [weak self] in
//        }
//
//        gamePad?.dpadRightPressed = { [weak self] in
//        }
//
//        gamePad?.dpadUpPressed = { [weak self] in
//        }
//
//        gamePad?.dpadDownPressed = { [weak self] in
//        }
        
        gamePad?.leftShoulderPressed = { [weak self] in
            self?.squareNode.rotate(clockwise: false, angle: 90 * .pi / 180)
        }
        
        gamePad?.rightShoulderPressed = { [weak self] in
            self?.squareNode.rotate(clockwise: true, angle: 90 * .pi / 180)
        }
        
        gamePad?.rightThumbstickMoved = { [weak self] xValue, yValue in
            if xValue == 0 && yValue == 0 {
                self?.squareNode.zRotation = 0
            } else {
                let angle = atan2(CGFloat(yValue), CGFloat(xValue))
                self?.squareNode.zRotation = angle
            }
        }
        
        gamePad?.leftThumbstickMoved = { [weak self] xValue, yValue in
            self?.thumbstickX = CGFloat(xValue)
            self?.thumbstickY = CGFloat(yValue)
        }
    }
    
    func updateSquare() {
        let moveSpeed: CGFloat = 10.0
        let xDistance = thumbstickX * moveSpeed
        let yDistance = thumbstickY * moveSpeed
        
        squareNode.moveBy(x: xDistance, y: yDistance)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.updateSquare()
    }
}

