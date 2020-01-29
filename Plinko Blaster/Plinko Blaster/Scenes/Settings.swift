//
//  MainMenu.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 15.03.19.
//  Copyright © 2019 me. All rights reserved.
//

import SpriteKit

class Settings: SKScene {
    
    let backButtonNode = SKSpriteNode(imageNamed: "back-button4")
    
    let resetButton = SKShapeNode(circleOfRadius: ScreenSize.width * 0.03)
    
    override func didMove(to view: SKView) {
        
        print("- In den Settings -")
        
        self.backgroundColor = UIColor(hexFromString: "120d27")
        
        addBackButtonNode()
        addResetButton()
    }
    
    func addBackButtonNode() {
        let backButtonAspectRatio = backButtonNode.size.width/backButtonNode.size.height
        if DeviceType.isiPad || DeviceType.isiPadPro {
            backButtonNode.size = CGSize(width: ScreenSize.width * 0.08, height: ScreenSize.width * 0.08 / backButtonAspectRatio)
        } else {
            backButtonNode.size = CGSize(width: ScreenSize.width * 0.1, height: ScreenSize.width * 0.1 / backButtonAspectRatio)
        }
        backButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backButtonNode.position = CGPoint(x: ScreenSize.width * 0.1, y: ScreenSize.height * 0.95)
        backButtonNode.alpha = 0.7
        addChild(backButtonNode)
    }
    
    func addResetButton() {
        resetButton.strokeColor = UIColor.red
        resetButton.lineWidth = 10
        resetButton.name = "resetButton"
        resetButton.position = CGPoint(x: ScreenSize.width * 0.15, y: ScreenSize.height * 0.2)
        
        let buttonLabel = SKLabelNode()
        buttonLabel.text = "RESET ALL POINTS"
        buttonLabel.color = UIColor.white
        buttonLabel.fontSize = 20
        buttonLabel.fontName = "HelveticaNeue-Light"
        buttonLabel.verticalAlignmentMode = .center
        buttonLabel.horizontalAlignmentMode = .left
        buttonLabel.position = CGPoint(x: buttonLabel.position.x + (resetButton.frame.size.width) , y: buttonLabel.position.y)
        
        resetButton.addChild(buttonLabel)
        
        addChild(resetButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == touches.first {
                if backButtonNode.contains(touch.location(in: self)) {
                    print("<- ab zum Hauptmenü <-")
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                    SceneManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.fade(withDuration: 0.5))
                }
                if resetButton.contains(touch.location(in: self)) {
                    print("- HIGHSCORE AUF 0 -")
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                    lastHighscore = 0
                    UserDefaults.standard.set(lastHighscore, forKey: "highscore")
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}

