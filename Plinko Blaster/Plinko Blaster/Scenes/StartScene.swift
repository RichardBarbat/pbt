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
    
    var coinAspectRatio = CGFloat()
    
    var myScene = SceneManager.SceneType.WelcomeScene
    
    let logoNode = SKSpriteNode(imageNamed: "plinko-blaster-logo3")
    
    
    // MARK: - Beginn der Funktionen
    
    override func didMove(to view: SKView) {
        
        print("- Im Start Bildschirm -")
                
        let ambientAudioAction = SKAction.playSoundFileNamed("ambient.mp3", waitForCompletion: false)
//        let changeVolumeAction = SKAction.changeVolume(to: 0.1, duration: 0.01)
//        let ambientAudioGroup = SKAction.group([ambientAudioAction, changeVolumeAction])
        logoNode.run(ambientAudioAction)
        
        
        let backgroundNode = SKSpriteNode(imageNamed: "leather_texture")
        
        backgroundNode.position = Screen.center
        let backgroundAspectRatio = backgroundNode.size.width/backgroundNode.size.height
        backgroundNode.size = CGSize(width: Screen.height * 1.0, height: Screen.height * 1.0 / backgroundAspectRatio)
        addChild(backgroundNode)
        
        addLogo()
        addAutomatNode()
        addCoinNode()
        addCoinFlipNode()
        addCoinInsertNode()
        
        self.view?.showsFPS = true
        self.view?.showsNodeCount = true
        
    }
    
    func addLogo() {
        
        let logoBackgroundNode = SKSpriteNode(imageNamed: "logoBackground")
        let logoBackgroundAspectRatio = logoBackgroundNode.size.width/logoBackgroundNode.size.height
        logoBackgroundNode.size = CGSize(width: Screen.width * 0.85, height: Screen.width * 0.85 / logoBackgroundAspectRatio)
        
        logoBackgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        logoBackgroundNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.83)
        logoBackgroundNode.alpha = 1
        logoBackgroundNode.name = "logoBackgroundNode"
        
        addChild(logoBackgroundNode)
        
        let logoAspectRatio = logoNode.size.width/logoNode.size.height
        logoNode.size = CGSize(width: Screen.width * 0.8, height: Screen.width * 0.8 / logoAspectRatio)
        
        logoNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        logoNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.83)
        logoNode.alpha = 0.3
        logoNode.name = "logo"
        
        
        addChild(logoNode)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.logoNode.alpha = 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.logoNode.alpha = 0.5

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.logoNode.alpha = 1

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                        self.logoNode.alpha = 0.5

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.logoNode.alpha = 1

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.logoNode.alpha = 0.5

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    self.logoNode.alpha = 1
                                    
                                    self.startFlickering(spriteNode: self.logoNode)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func startFlickering(spriteNode: SKSpriteNode) {
        
        spriteNode.run(SKAction.run {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                spriteNode.alpha = 0.5

                DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 0.01...0.1)) {
                    spriteNode.alpha = 1
                }
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 0.01...6)) {
            self.startFlickering(spriteNode: spriteNode)
        }
    }
    
    func addAutomatNode() {
        let automatNode = SKSpriteNode(imageNamed: "Münzeinwurfsschlitz😂 3")
        let automatAspectRatio = automatNode.size.width/automatNode.size.height
        automatNode.size = CGSize(width: Screen.width / 2, height: Screen.width / 2 / automatAspectRatio)
        automatNode.position = CGPoint(x: Screen.width / 2, y: Screen.height / 2)
        automatNode.name = "automatNode"
        
        
        addChild(automatNode)
    }
    
    func addCoinNode() {
        let coinNode = SKSpriteNode(imageNamed: "coin")
        coinAspectRatio = coinNode.size.width/coinNode.size.height
        coinNode.size = CGSize(width: (self.childNode(withName: "automatNode")?.frame.size.height)! * 0.2, height: (self.childNode(withName: "automatNode")?.frame.size.height)! * 0.2 / coinAspectRatio)
        coinNode.position = CGPoint(x: Screen.width * 0.5, y: 100)
        coinNode.name = "coin"
        
        addChild(coinNode)
    }
    
    func addCoinFlipNode() {
        let coinFlipNode = SKShapeNode(circleOfRadius: 60)
        coinFlipNode.fillColor = .red
        coinFlipNode.alpha = 0
        coinFlipNode.position = CGPoint(x: (self.childNode(withName: "automatNode")?.position.x)!, y: (self.childNode(withName: "automatNode")?.position.y)! - 30)
        coinFlipNode.name = "coinFlip"
        
        addChild(coinFlipNode)
    }
    
    func addCoinInsertNode() {
        let coinInsertNode = SKShapeNode(circleOfRadius: 25)
        coinInsertNode.fillColor = .blue
        coinInsertNode.alpha = 0
        coinInsertNode.position = CGPoint(x: (self.childNode(withName: "automatNode")?.position.x)!, y: (self.childNode(withName: "automatNode")?.position.y)! - 30)
        coinInsertNode.name = "coinInsert"
        
        addChild(coinInsertNode)
    }
    
    var hasCoin = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("☝️")
        
        if let touch = touches.first {
            let coinPosition = CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).y + 100)
            if self.childNode(withName: "coin")!.contains(touch.location(in: self)) {
                self.childNode(withName: "coin")!.position = coinPosition
                hasCoin = true
                self.run(SKAction.playSoundFileNamed("pickUpCoin.mp3", waitForCompletion: false))
                generator.impactOccurred()
            } else {
                hasCoin = false
            }
        } else { return }
        
        
    }
    
    var isInsertAnimationRunning = false
    var coinSide = false
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == touches.first {
                
                let coinNode = self.childNode(withName: "coin")! as! SKSpriteNode
                
                if isInsertAnimationRunning { return }
                if self.childNode(withName: "coinFlip")!.contains(touch.location(in: self)) {
                    
                    if coinSide == false {
                        if coinNode.texture == SKTexture(imageNamed: "coinSide") { return }
                        coinNode.texture = SKTexture(imageNamed: "coinSide")
                        coinNode.size.width = 10
                        
                        coinSide = true
                        
                        generator.impactOccurred()
                    }
                    
                    
                    if self.childNode(withName: "coinInsert")!.contains(touch.location(in: self)) {
                        
                        coinNode.isUserInteractionEnabled = false
                        
                        let setPositionAnimation = SKAction.move(to: CGPoint(x: Screen.center.x, y: (self.childNode(withName: "automatNode")?.position.y)! + 85), duration: 0.1)
                        let fadeOutAnimation = SKAction.fadeOut(withDuration: 0.4)

                        isInsertAnimationRunning = true
                        coinNode.run(setPositionAnimation) {
                            
                            self.run(SKAction.playSoundFileNamed("insertCoin.mp3", waitForCompletion: false))
                            generator.impactOccurred()
                            
                            coinNode.run(SKAction.wait(forDuration: 0.5)) {
                                coinNode.run(fadeOutAnimation) {
                                    // TODO: make fancy sequence of impacts ;)


                                    if launchedBefore == true {
                                        
                                        print("Not first launch.")
                                        
                                        self.myScene = SceneManager.SceneType.MainMenu
                                        
                                    } else {
                                        
                                        print("First launch, setting UserDefaults.")
                                        
                                        UserDefaults.standard.set(true, forKey: "fxOn")
                                        UserDefaults.standard.set(true, forKey: "vibrationOn")
                                        UserDefaults.standard.set(true, forKey: "backgroundMusicPlayerStatus")
                                        UserDefaults.standard.set(false, forKey: "tutorialShown")
                                        
                                        
                                        self.myScene = SceneManager.SceneType.WelcomeScene
                                        
                                        let playerName = UserDefaults.standard.string(forKey: "playerName")
                                        
                                        UserDefaults.standard.synchronize()
                                        
                                        if playerName != "" && playerName != nil {

                                            UserDefaults.standard.set(true, forKey: "launchedBefore")
                                        }
                                        
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {

                                        self.logoNode.removeAction(forKey: "ambient")
                                        
                                        SceneManager.shared.transition(self, toScene: self.myScene, transition: SKTransition.push(with: SKTransitionDirection.down, duration: 2))
                                    }
                                    
                                    
                                }
                            }
                        }
                        
                    }
                } else {
                    
                    if coinSide == true {
                        coinNode.texture = SKTexture(imageNamed: "coin")
                        coinNode.size = CGSize(width: (self.childNode(withName: "automatNode")?.frame.size.height)! * 0.2, height: (self.childNode(withName: "automatNode")?.frame.size.height)! * 0.2 / coinAspectRatio)
                        
                        coinSide = false
                        
                        generator.impactOccurred()
                    }
                    
                    
                }
                let coinPosition = CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).y + 100)
                if hasCoin {
                    self.childNode(withName: "coin")!.position = coinPosition
                }
                
            }
        }
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("✊")
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
