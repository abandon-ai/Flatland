import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    var square = Square()
    private var circle: SKSpriteNode!
    private var gamePad: GamePad?
    private let motionManager = CMMotionManager()
    var cameraNode: SKCameraNode!
    
    override func didMove(to view: SKView) {
        configureGamePad()
        
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 60.0
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData, error) in
                guard let accelerometerData = accelerometerData else { return }
                let acceleration = accelerometerData.acceleration
                self.physicsWorld.gravity = CGVector(dx: acceleration.x * 1, dy: acceleration.y * 1)
            }
        }
        
        cameraNode = SKCameraNode()
        camera = cameraNode
        addChild(cameraNode)
        
        let naturalLight = NaturalLightNode(size: self.size)
        naturalLight.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        naturalLight.physicsBody?.friction = 1
        naturalLight.physicsBody?.restitution = 0
        
        self.addChild(naturalLight)
        
        let dotGrid = DotGridNode(gridSize: CGSize(width: 1024, height: 1024), dotSize: 2.0, spacing: 50)
        dotGrid.position = CGPoint(x: frame.midX - 512, y: frame.midY - 512)
        addChild(dotGrid)
        
        square.name = "Angle"
        square.physicsBody = SKPhysicsBody(rectangleOf: square.size)
        square.physicsBody?.friction = 1
        square.physicsBody?.allowsRotation = true
        square.physicsBody?.isDynamic = true
        square.physicsBody?.restitution = 0.5
        self.addChild(square)
        
        let circleStrokeNode = CreateBloomStrokeNode(size: CGSize(width: 64, height: 64), lineWidth: 4, radius: 32, bloomIntensity: 2.0, bloomRadius: 10)
        circle = SKSpriteNode()
        circle.addChild(circleStrokeNode)
        circle.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
        ]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let n = self.circle?.copy() as! SKSpriteNode? {
                n.position = location
                self.addChild(n)
            }
            if square.contains(location) {
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                    feedbackGenerator.prepare()
                    feedbackGenerator.impactOccurred()
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let n = self.circle?.copy() as! SKSpriteNode? {
                n.position = location
                self.addChild(n)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let location = touch.location(in: self)
            if let n = self.circle?.copy() as! SKSpriteNode? {
                n.position = location
                self.addChild(n)
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let n = self.circle?.copy() as! SKSpriteNode? {
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
        
//        gamePad?.leftShoulderPressed = { [weak self] in
//
//        }
//
//        gamePad?.rightShoulderPressed = { [weak self] in
//            
//        }
        
        gamePad?.rightThumbstickMoved = { [weak self] xValue, yValue in
            if xValue == 0 && yValue == 0 {
                self?.square.updateZ(angle: 0)
            } else {
                let angle = atan2(CGFloat(yValue), CGFloat(xValue))
                self?.square.updateZ(angle: angle)
            }
        }
        
        gamePad?.leftThumbstickMoved = { [weak self] xValue, yValue in
            if xValue == 0 && yValue == 0 {
                self?.square.updateZ(angle: 0)
            } else {
                let angle = atan2(CGFloat(yValue), CGFloat(xValue))
                self?.square.updateZ(angle: angle)
            }
        }
        
//        gamePad?.leftTriggerPressed =  { [weak self] value in
//            
//        }
//        
//        gamePad?.rightTriggerPressed =  { [weak self] value in
//            
//        }
    }
    
    func moveCamera() {
        let playerPositionInScene = convert(square.position, from: square.parent!)
        
        let boundX = size.width / 2
        let boundY = size.height / 2
        let newX = max(-boundX, min(playerPositionInScene.x, boundX))
        let newY = max(-boundY, min(playerPositionInScene.y, boundY))

        cameraNode.position = CGPoint(x: newX, y: newY)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.square.update()
        self.moveCamera()
    }
}

