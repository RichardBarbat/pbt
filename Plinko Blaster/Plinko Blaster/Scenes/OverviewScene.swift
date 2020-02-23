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
    
    let backButtonNode = SKSpriteNode(imageNamed: "back-button4")

    override func didMove(to view: SKView) {
        
        print("OverviewScene")
        
        self.view?.tintColor = .green
        
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
                        mediumVibration.impactOccurred()
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
            backButtonNode.size = CGSize(width: Screen.width * 0.08, height: Screen.width * 0.08 / backButtonAspectRatio)
        } else {
            backButtonNode.size = CGSize(width: Screen.width * 0.1, height: Screen.width * 0.1 / backButtonAspectRatio)
        }
        backButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backButtonNode.position = CGPoint(x: Screen.width * 0.1, y: Screen.height * 0.95)
        backButtonNode.alpha = 0.7
        addChild(backButtonNode)
    }
    
    func addTitleNode() {
        
        let titleNode = SKLabelNode(text: "PLAYER-OVERVIEW")
        titleNode.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.85)
        titleNode.alpha = 1
        titleNode.fontName = "LCD14"
        titleNode.fontColor = .green
        titleNode.fontSize = 28
        addChild(titleNode)
        
        let highscoreLableNode = SKLabelNode(text: "- HIGHSCORE:\n"+"  \(UserDefaults.standard.integer(forKey: "highscore"))")
        highscoreLableNode.position = CGPoint(x: 30, y: Screen.height * 0.7)
        highscoreLableNode.alpha = 1
        highscoreLableNode.fontName = "LCD14"
        highscoreLableNode.fontColor = .green
        highscoreLableNode.fontSize = 18
        highscoreLableNode.numberOfLines = 2
        highscoreLableNode.horizontalAlignmentMode = .left
        addChild(highscoreLableNode)
        
        let totalPointsLableNode = SKLabelNode(text: "- TOTAL POINTS COLLECTED:\n"+"  \(UserDefaults.standard.integer(forKey: "totalPointsCollected"))")
        totalPointsLableNode.position = CGPoint(x: 30, y: Screen.height * 0.6)
        totalPointsLableNode.alpha = 1
        totalPointsLableNode.fontName = "LCD14"
        totalPointsLableNode.fontColor = .green
        totalPointsLableNode.fontSize = 18
        totalPointsLableNode.numberOfLines = 2
        totalPointsLableNode.horizontalAlignmentMode = .left
        addChild(totalPointsLableNode)
        
        let totalBallsLableNode = SKLabelNode(text: "- TOTAL BALLS DROPPED:\n"+"  \(UserDefaults.standard.integer(forKey: "totalBallsDropped"))")
        totalBallsLableNode.position = CGPoint(x: 30, y: Screen.height * 0.5)
        totalBallsLableNode.alpha = 1
        totalBallsLableNode.fontName = "LCD14"
        totalBallsLableNode.fontColor = .green
        totalBallsLableNode.fontSize = 18
        totalBallsLableNode.numberOfLines = 2
        totalBallsLableNode.horizontalAlignmentMode = .left
        addChild(totalBallsLableNode)
    }
}
