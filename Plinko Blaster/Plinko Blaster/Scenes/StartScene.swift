//
//  StartScene.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 11.02.20.
//  Copyright © 2020 me. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

// MARK: - Beginn der Klasse

class StartScene: SKScene {
    
    
    // MARK: - Variablen & Instanzen

    let coinNode = SKSpriteNode(imageNamed: "coin")
    let backgroundNode = SKSpriteNode(imageNamed: "leather_texture")
    let logoBackgroundNode = SKSpriteNode(imageNamed: "logoBackground")
    let automatNode = SKSpriteNode(imageNamed: "Münzeinwurfsschlitz😂 3")
    
    var hasCoin = false
    let pickUpCoinSoundAction = SKAction.playSoundFileNamed("pickUpCoin.mp3", waitForCompletion: false)
    let neonOutSoundAction = SKAction.playSoundFileNamed("neonOut.mp3", waitForCompletion: false)
    
    var coinAspectRatio = CGFloat()
    
    var myScene = SceneManager.SceneType.WelcomeScene
    
    let logoNode = SKSpriteNode(imageNamed: "plinko-blaster-logo3")

    var backgroundAmbientPlayer: AVAudioPlayer?
    
    // MARK: - Beginn der Funktionen
    
    override func didMove(to view: SKView) {
        
        print("- Im Start Bildschirm -")
                
//        let ambientAudioAction = SKAction.playSoundFileNamed("ambient.mp3", waitForCompletion: true)
        
//        let changeVolumeAction = SKAction.changeVolume(to: 0.1, duration: 0.01)
//        let ambientAudioGroup = SKAction.group([ambientAudioAction, changeVolumeAction])
        
        UserDefaults.standard.set(true, forKey: "startScreenOn")
        startScreenOn = true
        
        playBackgroundAmbientInLoop(playerStatus: UserDefaults.standard.bool(forKey: "backgroundAmbientPlayerStatus"))
        
        
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
    
    func playBackgroundAmbientInLoop(playerStatus: Bool) {
        guard let url = Bundle.main.url(forResource: "ambient", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. */
            backgroundAmbientPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = backgroundAmbientPlayer else { return }
            
            
            player.numberOfLoops = -1
            
            player.play()
            print("AMBIENT MUSIC PLAYS")
            
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func addLogo() {
        
        
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
                self.run(self.neonOutSoundAction)
                lightVibration.impactOccurred()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.logoNode.alpha = 1

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                        self.logoNode.alpha = 0.5
                        self.run(self.neonOutSoundAction)
                        lightVibration.impactOccurred()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.logoNode.alpha = 1

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.logoNode.alpha = 0.5
                                self.run(self.neonOutSoundAction)
                                lightVibration.impactOccurred()

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
                self.run(self.neonOutSoundAction)
                lightVibration.impactOccurred()
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
        let automatAspectRatio = automatNode.size.width/automatNode.size.height
        automatNode.size = CGSize(width: Screen.width / 2, height: Screen.width / 2 / automatAspectRatio)
        automatNode.position = CGPoint(x: Screen.width / 2, y: Screen.height / 2)
        automatNode.name = "automatNode"
        
        
        addChild(automatNode)
    }
    
    func addCoinNode() {
        coinAspectRatio = coinNode.size.width/coinNode.size.height
        coinNode.size = CGSize(width: (self.childNode(withName: "automatNode")?.frame.size.height)! * 0.25, height: (self.childNode(withName: "automatNode")?.frame.size.height)! * 0.25 / coinAspectRatio)
        coinNode.position = CGPoint(x: Screen.width * 0.5, y: 100)
        coinNode.name = "coin"
        
        addChild(coinNode)
    }
    
    func addCoinFlipNode() {
        let coinFlipNode = SKShapeNode(circleOfRadius: 70)
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let coinPosition = CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).y + 100)
            if self.childNode(withName: "coin")!.contains(touch.location(in: self)) {
                self.childNode(withName: "coin")!.position = coinPosition
                hasCoin = true
                self.run(pickUpCoinSoundAction)
                mediumVibration.impactOccurred()
            } else {
                hasCoin = false
            }
        }
        
        
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
                        let coinSideTexture = SKTexture(imageNamed: "coinSide")
                        
                        coinNode.texture = coinSideTexture
                        coinNode.size.width = 21
                        
                        coinSide = true
                        
                        mediumVibration.impactOccurred()
                    }
                    
                    if self.childNode(withName: "coinInsert")!.contains(touch.location(in: self)) {
                        
                        coinNode.isUserInteractionEnabled = false
                        
                        let setPositionAnimation = SKAction.move(to: CGPoint(x: Screen.center.x, y: (self.childNode(withName: "automatNode")?.position.y)! + 85), duration: 0.1)

                        isInsertAnimationRunning = true
                        
                        coinNode.run(setPositionAnimation) {
                            
                            let fadeOutAnimation = SKAction.fadeOut(withDuration: 0.1)
                            
                            mediumVibration.impactOccurred()
                            coinNode.run(SKAction.wait(forDuration: 0.3)) {
                                mediumVibration.impactOccurred()
                                coinNode.run(fadeOutAnimation) {
                                    self.run(SKAction.playSoundFileNamed("insertCoin.mp3", waitForCompletion: false))
                                    heavyVibration.impactOccurred()
                                    if launchedBefore == true {
                                        print("Not first launch.")
                                        self.myScene = SceneManager.SceneType.MainMenu
                                    } else {
                                        print("First launch, setting UserDefaults.")
                                        UserDefaults.standard.set(true, forKey: "fxOn")
                                        UserDefaults.standard.set(true, forKey: "vibrationOn")
                                        UserDefaults.standard.set(true, forKey: "startScreenOn")
                                        UserDefaults.standard.set(true, forKey: "backgroundMusicPlayerStatus")
                                        UserDefaults.standard.set(false, forKey: "tutorialShown")
                                        UserDefaults.standard.set(1, forKey: "ballPointValue")
                                        UserDefaults.standard.set(1, forKey: "prestigeValue")
                                        UserDefaults.standard.set(0, forKey: "ballsDroppedSincePrestige")
                                        
                                        self.myScene = SceneManager.SceneType.WelcomeScene
                                        
                                        let playerName = UserDefaults.standard.string(forKey: "playerName")
                                        
                                        UserDefaults.standard.synchronize()
                                        
                                        if playerName != "" && playerName != nil {

                                            UserDefaults.standard.set(true, forKey: "launchedBefore")
                                        }
                                        
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                        
                                        self.backgroundAmbientPlayer?.setVolume(0, fadeDuration: 2)
                                        
                                        SceneManager.shared.transition(self, toScene: self.myScene, transition: SKTransition.push(with: SKTransitionDirection.down, duration: 2))
                                    }
                                }
                            }
                        }
                    }
                } else {
                    
                    if coinSide == true {
                        coinNode.texture = SKTexture(imageNamed: "coin")
                        coinNode.size = CGSize(width: (self.childNode(withName: "automatNode")?.frame.size.height)! * 0.25, height: (self.childNode(withName: "automatNode")?.frame.size.height)! * 0.25 / coinAspectRatio)
                        
                        coinSide = false
                        
                        mediumVibration.impactOccurred()
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
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
