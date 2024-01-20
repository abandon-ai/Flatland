import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    var square = Square()
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let strokeParticle = createStrokeParticleNode()
            strokeParticle.position = location
            self.addChild(strokeParticle)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let strokeParticle = createStrokeParticleNode()
            strokeParticle.position = location
            self.addChild(strokeParticle)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let strokeParticle = createStrokeParticleNode()
            strokeParticle.position = location
            self.addChild(strokeParticle)
        }
    }
    
    func createStrokeParticleNode() -> SKEmitterNode {
        let particle = SKEmitterNode()
        particle.particleColor = UIColor.white
        particle.particleSize = CGSize(width: 4, height: 4) // 粒子的大小
        particle.particleBirthRate = 50
        particle.particleLifetime = 1.5
        particle.particleSpeed = 40
        particle.particleSpeedRange = 10
        particle.emissionAngleRange = .pi * 2
        particle.particleAlpha = 0.8
        particle.particleAlphaRange = 0.2
        particle.particleAlphaSpeed = -0.3
        particle.particleScale = 0.5
        particle.particleScaleRange = 0.2
        particle.particleScaleSpeed = -0.1
        particle.particleColorBlendFactor = 1
        particle.particleColorBlendFactorRange = 0.2
        particle.particleColorBlendFactorSpeed = -0.2
        particle.particleBlendMode = .add

        particle.particleColorSequence = SKKeyframeSequence(
            keyframeValues: [UIColor.white, UIColor.gray, UIColor.lightGray],
            times: [0, 0.5, 1]
        )
        
        let removeAction = SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
        ])
        particle.run(removeAction)

        return particle
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
   
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
        
        let screenWidth = self.view?.bounds.width ?? 0
        let screenHeight = self.view?.bounds.height ?? 0
        
        let leftEdge = cameraNode.position.x - screenWidth / 2
        let rightEdge = cameraNode.position.x + screenWidth / 2
        let topEdge = cameraNode.position.y + screenHeight / 2
        let bottomEdge = cameraNode.position.y - screenHeight / 2
        
        var newCameraPosition = cameraNode.position
        if playerPositionInScene.x < leftEdge {
            newCameraPosition.x = square.position.x + screenWidth / 2
        } else if playerPositionInScene.x > rightEdge {
            newCameraPosition.x = square.position.x - screenWidth / 2
        }
        
        if playerPositionInScene.y < bottomEdge {
            newCameraPosition.y = square.position.y + screenHeight / 2
        } else if playerPositionInScene.y > topEdge {
            newCameraPosition.y = square.position.y - screenHeight / 2
        }

        cameraNode.position = newCameraPosition
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.square.update()
        self.moveCamera()
    }
}

