//
//  StartScene.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 11.02.20.
//  Copyright © 2020 me. All rights reserved.
//

import SpriteKit
import UIKit


// MARK: - Beginn der Klasse

class StartScene: SKScene {
    
    
    // MARK: - Variablen & Instanzen
    
    
    
    
    // MARK: - Beginn der Funktionen
    
    override func didMove(to view: SKView) {
        
        print("- Im Start Bildschirm -")
                
        let backgroundNode = SKSpriteNode(imageNamed: "leather_texture")
        
        backgroundNode.position = Screen.center
        let backgroundAspectRatio = backgroundNode.size.width/backgroundNode.size.height
        backgroundNode.size = CGSize(width: Screen.height * 1.0, height: Screen.height * 1.0 / backgroundAspectRatio)
        addChild(backgroundNode)
        
        addLogo()
        addAutomatNode()
        addCoinNode()
    }
    
    func addLogo() {
        let logoNode = SKSpriteNode(imageNamed: "plinko-blaster-logo3")
        let logoAspectRatio = logoNode.size.width/logoNode.size.height
        logoNode.size = CGSize(width: Screen.width * 0.8, height: Screen.width * 0.8 / logoAspectRatio)
        
        logoNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        logoNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.85)
        logoNode.name = "logo"
        //        logoNode.run(endlessAction3) für Logo eine eigene Action erstellen
        
        addChild(logoNode)
    }
    
    func addAutomatNode() {
        let automatNode = SKSpriteNode(imageNamed: "Münzeinwurfsschlitz😂 2")
        let automatAspectRatio = automatNode.size.width/automatNode.size.height
        automatNode.size = CGSize(width: Screen.width * 1.0, height: Screen.width * 1.0 / automatAspectRatio)
        automatNode.position = CGPoint(x: Screen.width / 2, y: Screen.height / 2)
        automatNode.name = "automatNode"
        
        
        addChild(automatNode)
    }
    
    func addCoinNode() {
        let coinNode = SKSpriteNode(imageNamed: "coin")
        let coinAspectRatio = coinNode.size.width/coinNode.size.height
        coinNode.size = CGSize(width: (self.childNode(withName: "automatNode")?.frame.size.height)! * 0.25, height: (self.childNode(withName: "automatNode")?.frame.size.height)! * 0.25 / coinAspectRatio)
        coinNode.position = CGPoint(x: Screen.width * 0.7, y: Screen.height / 2)
        coinNode.name = "coin"
        
        
        addChild(coinNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("☝️")
        
        if let touch = touches.first {
            let coinPosition = CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).y + 50)
            if self.childNode(withName: "coin")!.contains(touch.location(in: self)) {
                self.childNode(withName: "coin")!.position = coinPosition
            }
        } else { return }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == touches.first {
                print("👉👆👇👈")
                let coinPosition = CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).y + 50)
                self.childNode(withName: "coin")!.position = coinPosition
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("✊")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            
            var scene = SceneManager.SceneType.WelcomeScene
            
            if launchedBefore == true {
                
                print("Not first launch.")
                
                scene = SceneManager.SceneType.MainMenu
                
            } else {
                
                print("First launch, setting UserDefaults.")
                
                UserDefaults.standard.set(true, forKey: "fxOn")
                UserDefaults.standard.set(true, forKey: "vibrationOn")
                UserDefaults.standard.set(true, forKey: "backgroundMusicPlayerStatus")
                UserDefaults.standard.set(false, forKey: "tutorialShown")
                
                
                scene = SceneManager.SceneType.WelcomeScene
                
                let playerName = UserDefaults.standard.string(forKey: "playerName")
                
                UserDefaults.standard.synchronize()
                
                if playerName != "" && playerName != nil {

                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                }
                
            }
            
            SceneManager.shared.transition(self, toScene: scene, transition: SKTransition.push(with: SKTransitionDirection.down, duration: 1.5))
//            SceneManager.shared.transition(self, toScene: scene, transition: SKTransition.fade(withDuration: 0.5))
        })
    }
}
