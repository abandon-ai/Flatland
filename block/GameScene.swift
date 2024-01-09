//
//  GameScene.swift
//  block
//
//  Created by 丁涯 on 2024/1/9.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    private var asstNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.asstNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: 0)
        
        if let asstNode = self.asstNode {
            asstNode.fillColor = SKColor.white
            asstNode.physicsBody = SKPhysicsBody(rectangleOf: asstNode.frame.size)
            asstNode.physicsBody?.isDynamic = false
            self.addChild(asstNode)
        }
    }
    
    func moveAsstNode(toPoint pos: CGPoint) {
            // Calculate the distance and speed to move the asstNode
            let asstNodeSpeed: CGFloat = 500 // points per second
            if let asstNode = self.asstNode {
                let distance = hypot(pos.x - asstNode.position.x, pos.y - asstNode.position.y)
                let duration = TimeInterval(distance / asstNodeSpeed)
                
                // Move the asstNode to the new position
                let moveAction = SKAction.move(to: pos, duration: duration)
                asstNode.run(moveAction)
            }
        }
    
    
    func touchDown(atPoint pos : CGPoint) {
        moveAsstNode(toPoint: pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        moveAsstNode(toPoint: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        moveAsstNode(toPoint: pos)
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
