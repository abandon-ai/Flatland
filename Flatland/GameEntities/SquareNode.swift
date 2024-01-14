import SpriteKit
import GameplayKit

class SquareNode: SKSpriteNode {
    var velocity: CGPoint = CGPoint.zero
    let gravity: CGFloat = -9.8
    let moveSpeed: CGFloat = 200.0
    let jumpForce: CGFloat = 300.0
    
    var isOnGround: Bool = true

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
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.name = "player"
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Enemy
        self.physicsBody?.collisionBitMask = PhysicsCategory.Ground
        
        let squareBodyNode = createSquareBodyNode(size: size, blurRadius: 1, colors: ["#3D70E5", "#CEFEEC"])
        let squareStrokeNode = createBloomStrokeNode(size: size, lineWidth: 4, radius: 0, bloomIntensity: 2.0, bloomRadius: 10)
        
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
        
        self.addChild(squareBodyNode)
        self.addChild(squareStrokeNode)
        self.addChild(leftEye)
        self.addChild(rightEye)
        self.addChild(noce)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(deltaTime: TimeInterval) {
        position.x += velocity.x * CGFloat(deltaTime)
        position.y += velocity.y * CGFloat(deltaTime)
        
        if !isOnGround {
            velocity.y += gravity
        }
    }
    
    func move(direction: CGFloat) {
        velocity.x = direction * moveSpeed
    }
    
    func jump() {
        if isOnGround {
            velocity.y = jumpForce
            isOnGround = false
        }
    }
    
    func didBeginContact(with other: SKPhysicsBody) {
        if other.categoryBitMask == PhysicsCategory.Ground {
            isOnGround = true
            velocity.y = 0
        }
        
        if other.categoryBitMask == PhysicsCategory.Enemy {
        }
    }
    
    func didEndContact(with other: SKPhysicsBody) {
        if other.categoryBitMask == PhysicsCategory.Ground {
            isOnGround = false
        }
    }
}

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let All: UInt32 = UInt32.max
    static let Player: UInt32 = 0b1 // 1
    static let Ground: UInt32 = 0b10 // 2
    static let Enemy: UInt32 = 0b100 // 4
}
