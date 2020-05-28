//
//  Ball.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 10.08.19.
//  Copyright © 2019 me. All rights reserved.
//

import GameKit

class Ball: SKShapeNode {
    
    var active = false
    
    private let valueLable = SKLabelNode(fontNamed: "PixelSplitter")
    
    init(color: UIColor = .yellow, radius: CGFloat = Screen.width * 0.035, value: Int = ballPointValue) {
        super.init()
        
        path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -radius, y: -radius), size: CGSize(width: radius * 2, height: radius * 2)), transform: nil)
        strokeColor = color
        fillColor = UIColor(hexFromString: "140032").withAlphaComponent(0.5)
        lineWidth = Screen.width * 0.008
        
        valueLable.text = "X\(value)"
        valueLable.fontSize = 10
        valueLable.fontColor = color
        valueLable.zPosition = self.zPosition + 1
        valueLable.position.y = valueLable.position.y - valueLable.frame.height / 2.2
        
        addChild(valueLable)
    }
    
    func activatePhysicsBody() {
        active = true
        physicsBody = SKPhysicsBody(circleOfRadius: Screen.width * 0.038 )
        physicsBody?.isDynamic = false
        physicsBody?.allowsRotation = true
        physicsBody?.friction = 0
        physicsBody?.restitution = 0.45
        physicsBody?.categoryBitMask = ColliderType.Ball
        physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.Obstacle | ColliderType.Scene | ColliderType.Line | ColliderType.BottomLine
        physicsBody?.contactTestBitMask = ColliderType.Ball | ColliderType.Obstacle | ColliderType.BottomLine | ColliderType.Box | ColliderType.Collectible
        
    }
    
    func turnGlowOn() {
        for child in children {
            if child.name == "glow" {
                child.removeFromParent()
            }
        }
        addGlow(radius: 5)
        addGlow(radius: 10, alpha: 0.25)
        addGlow(radius: 15, alpha: 0.25)
    }
    
    func turnGlowOff() {
        for child in children {
            if child.name == "glow" {
                child.removeFromParent()
            }
        }
    }
    
    func changePath(toPath: CGPath, forSeconds: Double, allowRotation: Bool = false) {
        self.turnGlowOff()
        let initialPath = self.path
        self.run(.scale(to: 0.1, duration: 0.01))
        self.path = toPath
        self.run(.scale(to: 1, duration: 0.01))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.turnGlowOn()
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + forSeconds) {
            
            self.path = initialPath
            self.turnGlowOn()
            
        }
        
    }
    
    func addEmitter(emitterName: String, forSeconds: Double = 0) {
        if let emitter = SKEmitterNode(fileNamed: emitterName) {
            emitter.targetNode = self
            emitter.position = self.position
            self.parent!.addChild(emitter)
            
            if forSeconds > 0 {
                self.run(SKAction.wait(forDuration: forSeconds)) {
                    emitter.removeFromParent()
                }
            }
        }
    }
    
    
    func changeValue(toValue: Int = ballPointValue * 2, forSeconds: Double = 0) {
        
        let initialBallPoinValue = ballPointValue
        
        ballPointValue = toValue
        valueLable.text = "X\(ballPointValue)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + forSeconds, execute: {
            ballPointValue = initialBallPoinValue
            self.valueLable.text = "X\(initialBallPoinValue)"
        })
    }
    
    
    func changeBallColor(color: UIColor, forSeconds: Double = 0) {
        let initialStrokeColor = strokeColor
        let initialValueLabelFontColor = valueLable.fontColor
        
        strokeColor = color
        valueLable.fontColor = color
        
        if forSeconds != Double(0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + forSeconds, execute: {
                self.strokeColor = initialStrokeColor
                self.valueLable.fontColor = initialValueLabelFontColor
            })
        }
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
