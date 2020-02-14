//
//  MainMenu.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 15.03.19.
//  Copyright © 2019 me. All rights reserved.
//

import SpriteKit

class OptionsScene: SKScene {
    
    let backButtonNode = SKSpriteNode(imageNamed: "back-button4")
    
    var musicButtonLableNode = SKLabelNode()
    var sfxButtonLableNode = SKLabelNode()
    var vibrationButtonLableNode = SKLabelNode()
    
    let resetButton = SKShapeNode(circleOfRadius: Screen.width * 0.03)
    
    override func didMove(to view: SKView) {
        
        print("- In den OPTIONS -")
        
        self.view?.tintColor = .green
        self.backgroundColor = UIColor(hexFromString: "120d27")
        
        addBackButtonNode()
        addTitleNode()
        addMusicButtonNode()
        addSFXButtonNode()
        addVibrationButtonNode()
//        addResetButton()
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
    
    func addResetButton() {
        resetButton.strokeColor = UIColor.red
        resetButton.lineWidth = 10
        resetButton.name = "resetButton"
        resetButton.position = CGPoint(x: Screen.width * 0.15, y: Screen.height * 0.2)
        
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
    
    func addTitleNode() {
        
        let titleNode = SKLabelNode(text: "OPTIONS")
        titleNode.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.85)
        titleNode.alpha = 1
        titleNode.fontName = "LCD14"
        titleNode.fontColor = .green
        titleNode.fontSize = 28
        addChild(titleNode)
        
    }
    
    func addMusicButtonNode() {
        
        if backgroundMusicPlayerStatus == true {
            musicButtonLableNode = SKLabelNode(text: "- MUSIC: ON")
            musicButtonLableNode.fontColor = .green
        } else {
            musicButtonLableNode = SKLabelNode(text: "- MUSIC: OFF")
            musicButtonLableNode.fontColor = .red
        }
        
        musicButtonLableNode.position = CGPoint(x: 30, y: Screen.height * 0.75)
        musicButtonLableNode.alpha = 1
        musicButtonLableNode.fontName = "LCD14"
        musicButtonLableNode.fontSize = 18
        musicButtonLableNode.horizontalAlignmentMode = .left
        addChild(musicButtonLableNode)
    }
    
    func addSFXButtonNode() {
        
        if fxOn == true {
            sfxButtonLableNode = SKLabelNode(text: "- SOUND-FX: ON")
            sfxButtonLableNode.fontColor = .green
        } else {
            sfxButtonLableNode = SKLabelNode(text: "- SOUND-FX: OFF")
            sfxButtonLableNode.fontColor = .red
        }
        
        sfxButtonLableNode.position = CGPoint(x: 30, y: Screen.height * 0.7)
        sfxButtonLableNode.alpha = 1
        sfxButtonLableNode.fontName = "LCD14"
        sfxButtonLableNode.fontSize = 18
        sfxButtonLableNode.horizontalAlignmentMode = .left
        addChild(sfxButtonLableNode)
    }
    
    func addVibrationButtonNode() {
        
        if vibrationOn == true {
            vibrationButtonLableNode = SKLabelNode(text: "- VIBRATION: ON")
            vibrationButtonLableNode.fontColor = .green
        } else {
            vibrationButtonLableNode = SKLabelNode(text: "- VIBRATION: OFF")
            vibrationButtonLableNode.fontColor = .red
        }
        
        vibrationButtonLableNode.position = CGPoint(x: 30, y: Screen.height * 0.65)
        vibrationButtonLableNode.alpha = 1
        vibrationButtonLableNode.fontName = "LCD14"
        vibrationButtonLableNode.fontSize = 18
        vibrationButtonLableNode.horizontalAlignmentMode = .left
        addChild(vibrationButtonLableNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == touches.first {
                
                if backButtonNode.contains(touch.location(in: self)) {
                    print("<- ab zum Hauptmenü <-")
                    SceneManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.fade(withDuration: 0.5))

                    if fxOn == true {
                        let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                        backButtonNode.run(pling)
                    }
                    if vibrationOn == true {
                        generator.impactOccurred()
                    }
                }
                
                if musicButtonLableNode.contains(touch.location(in: self)) {
                    if backgroundMusicPlayerStatus == true {
                        musicButtonLableNode.text = "- MUSIC: OFF"
                        musicButtonLableNode.fontColor = .red
                        UserDefaults.standard.set(false, forKey: "backgroundMusicPlayerStatus")
                        backgroundMusicPlayer?.stop()
                        backgroundMusicPlayerStatus = false
                    } else {
                        musicButtonLableNode.text = "- MUSIC: ON"
                        musicButtonLableNode.fontColor = .green
                        UserDefaults.standard.set(true, forKey: "backgroundMusicPlayerStatus")
                        backgroundMusicPlayer?.play()
                        backgroundMusicPlayerStatus = true
                    }

                    if fxOn == true {
                        let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                        musicButtonLableNode.run(pling)
                    }
                    if vibrationOn == true {
                        generator.impactOccurred()
                    }
                }
                
                if sfxButtonLableNode.contains(touch.location(in: self)) {
                    if fxOn == true {
                        sfxButtonLableNode.text = "- SOUND-FX: OFF"
                        sfxButtonLableNode.fontColor = .red
                        UserDefaults.standard.set(false, forKey: "fxOn")
                        fxOn = false
                    } else {
                        sfxButtonLableNode.text = "- SOUND-FX: ON"
                        sfxButtonLableNode.fontColor = .green
                        UserDefaults.standard.set(true, forKey: "fxOn")
                        fxOn = true
                    }

                    if fxOn == true {
                        let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                        sfxButtonLableNode.run(pling)
                    }
                    if vibrationOn == true {
                        generator.impactOccurred()
                    }
                }
                
                if vibrationButtonLableNode.contains(touch.location(in: self)) {
                    if vibrationOn == true {
                        vibrationButtonLableNode.text = "- VIBRATION: OFF"
                        vibrationButtonLableNode.fontColor = .red
                        UserDefaults.standard.set(false, forKey: "vibrationOn")
                        vibrationOn = false
                    } else {
                        vibrationButtonLableNode.text = "- VIBRATION: ON"
                        vibrationButtonLableNode.fontColor = .green
                        UserDefaults.standard.set(true, forKey: "vibrationOn")
                        vibrationOn = true
                    }

                    if fxOn == true {
                        let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                        vibrationButtonLableNode.run(pling)
                    }
                    if vibrationOn == true {
                        generator.impactOccurred()
                    }
                }
                
                // PRESTIGE_BUTTON????
                
//                if resetButton.contains(touch.location(in: self)) {
//                    print("- HIGHSCORE AUF 0 -")
//                    let generator = UIImpactFeedbackGenerator(style: .heavy)
//                    generator.impactOccurred()
//                    lastHighscore = 0
//                    UserDefaults.standard.set(lastHighscore, forKey: "highscore")
//                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}

