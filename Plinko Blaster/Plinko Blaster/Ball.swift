//
//  Ball.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 10.08.19.
//  Copyright © 2019 me. All rights reserved.
//

import Foundation
import SpriteKit

class Ball {
    
//    var label: SKLabelNode
        
    func create() -> SKShapeNode{
        
        let shapeNode = SKShapeNode(circleOfRadius: Screen.width * 0.035)
        
        shapeNode.physicsBody = SKPhysicsBody(circleOfRadius: shapeNode.frame.size.width / 2.1 )
        shapeNode.physicsBody?.isDynamic = false
        shapeNode.physicsBody?.friction = 0
        shapeNode.physicsBody?.restitution = 0.45
        shapeNode.physicsBody?.categoryBitMask = ColliderType.Ball
        shapeNode.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.Obstacle | ColliderType.Scene | ColliderType.Line | ColliderType.BottomLine
        shapeNode.physicsBody?.contactTestBitMask = ColliderType.Ball | ColliderType.Obstacle | ColliderType.BottomLine | ColliderType.Box | ColliderType.Extra
//        shapeNode.fillColor = UIColor.black.withAlphaComponent(0.5)
//        shapeNode.fillColor = UIColor.yellow.withAlphaComponent(0.5)
        shapeNode.zPosition = 300
        
        let lable = SKLabelNode(fontNamed: "LCD14")
        
        lable.text = "X\(ballPointValue)"
        lable.fontSize = 10
        lable.fontColor = Color.yellow
        lable.position.y = lable.position.y - lable.frame.height / 2.2
        lable.addGlow()
        
        shapeNode.addChild(lable)
        
        return shapeNode
    }
    
    
        
    
    
}
