//
//  Ball.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 10.08.19.
//  Copyright © 2019 me. All rights reserved.
//

import GameKit

class Ball: SKShapeNode {
    
    func create() -> SKShapeNode {
        
        let ballNode = SKShapeNode(circleOfRadius: Screen.width * 0.035)
        
        ballNode.strokeColor = UIColor.yellow
        ballNode.lineWidth = Screen.width * 0.008
        
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: ballNode.frame.size.width / 2.1 )
        ballNode.physicsBody?.isDynamic = false
        ballNode.physicsBody?.friction = 0
        ballNode.physicsBody?.restitution = 0.45
        ballNode.physicsBody?.categoryBitMask = ColliderType.Ball
        ballNode.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.Obstacle | ColliderType.Scene | ColliderType.Line | ColliderType.BottomLine
        ballNode.physicsBody?.contactTestBitMask = ColliderType.Ball | ColliderType.Obstacle | ColliderType.BottomLine | ColliderType.Box | ColliderType.Collectible
        ballNode.zPosition = 300
        
        let lable = SKLabelNode(fontNamed: "LCD14")
        
        lable.text = "X\(ballPointValue)"
        lable.fontSize = 10
        lable.fontColor = Color.yellow
        lable.position.y = lable.position.y - lable.frame.height / 2.2
        lable.addGlow()
        
        ballNode.addChild(lable)
        
        return ballNode
    }
    
}
