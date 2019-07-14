//
//  PlayerScene.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 14.04.19.
//  Copyright © 2019 me. All rights reserved.
//

import SpriteKit
import UIKit

class OverviewScene: SKScene, UITextFieldDelegate {
    
    let backButtonNode = SKSpriteNode(imageNamed: "back-button3")

    override func didMove(to view: SKView) {
        
        print("OverviewScene")
        
        self.view?.tintColor = .green
        self.backgroundColor = UIColor(hexFromString: "120d27")
        
        addBackButtonNode()
        
        addTitleNode()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.scene?.view!.endEditing(true)
        
        for touch in touches {
            if touch == touches.first {
                if backButtonNode.contains(touch.location(in: self)) {
                    
                    print("<- ab zum Hauptmenü <-")
                    
                    if vibrationOn {
                        generator.impactOccurred()
                    }
                    
                    if self.scene?.view!.subviews.count != 0 {
                        for subView in (self.scene?.view!.subviews)! {
                            subView.removeFromSuperview()
                        }
                    }
                    
                    self.removeAllChildren()
                    self.removeAllActions()
                    
                    SceneManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.fade(withDuration: 0.5))
                    
                }
            }
        }
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
        backButtonNode.alpha = 1
        addChild(backButtonNode)
    }
    
    func addTitleNode() {
        
        let titleNode = SKLabelNode(text: "PLAYER-OVERVIEW")
        titleNode.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height * 0.9)
        titleNode.alpha = 1
        titleNode.fontName = "LCD14"
        titleNode.fontColor = .green
        titleNode.fontSize = 30
        addChild(titleNode)
    }
}
