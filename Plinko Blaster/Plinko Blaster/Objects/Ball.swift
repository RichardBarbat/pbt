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
        
        ballNode.strokeColor = .yellow
        ballNode.fillColor = UIColor(hexFromString: "140032").withAlphaComponent(0.5)
        ballNode.lineWidth = Screen.width * 0.008
                
        let lable = SKLabelNode(fontNamed: "PixelSplitter")
        
        lable.text = "X\(ballPointValue)"
        lable.fontSize = 10
        lable.fontColor = .yellow
        lable.zPosition = ballNode.zPosition + 1
        lable.position.y = lable.position.y - lable.frame.height / 2.2
        
        ballNode.addChild(lable)
        
        return ballNode
    }
    
}
