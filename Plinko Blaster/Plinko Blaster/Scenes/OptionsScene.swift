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
    
    let optionsTitleLabelNode = SKLabelNode(text: "OPTIONS")
    let donateTitleLabelNode = SKLabelNode(text: "LIKE THE GAME ?")
    var musicButtonLabelNode = SKLabelNode()
    var sfxButtonLabelNode = SKLabelNode()
    var vibrationButtonLabelNode = SKLabelNode()
    var startScreenButtonLabelNode = SKLabelNode()
    var tutorialButtonLabelNode = SKLabelNode()
    var prestigeButtonLabelNode = SKLabelNode()
    var prestigeButtonDescriptionLabelNode = SKLabelNode()
    
    let resetButton = SKShapeNode(circleOfRadius: Screen.width * 0.03)

    
    override func didMove(to view: SKView) {
        
        print("- In den OPTIONS -")
        
        self.view?.tintColor = .green
        
        addBackButtonNode()
        addOptionsTitleLabelNode()
        addMusicButtonLabelNode()
        addSFXButtonLabelNode()
        addVibrationButtonLabelNode()
        addShowStartScreenButtonLabelNode()
        addShowTutorialButtonLabelNode()
        addPrestigeButtonLabelNode()
        addDonateTitleLabelNode()
        addDonateSection()
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
    
    func addOptionsTitleLabelNode() {
        
        optionsTitleLabelNode.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.88)
        optionsTitleLabelNode.alpha = 1
        optionsTitleLabelNode.fontName = "LCD14"
        optionsTitleLabelNode.fontColor = .green
        optionsTitleLabelNode.fontSize = 28
        addChild(optionsTitleLabelNode)
        
    }
    
    func addMusicButtonLabelNode() {
        
        if backgroundMusicPlayerStatus == true {
            musicButtonLabelNode = SKLabelNode(text: "- MUSIC: ON")
            musicButtonLabelNode.fontColor = .green
        } else {
            musicButtonLabelNode = SKLabelNode(text: "- MUSIC: OFF")
            musicButtonLabelNode.fontColor = .red
        }
        
        musicButtonLabelNode.position = CGPoint(x: 30, y: optionsTitleLabelNode.position.y - 50)
        musicButtonLabelNode.alpha = 1
        musicButtonLabelNode.fontName = "LCD14"
        musicButtonLabelNode.fontSize = 18
        musicButtonLabelNode.horizontalAlignmentMode = .left
        addChild(musicButtonLabelNode)
    }
    
    func addSFXButtonLabelNode() {
        
        if fxOn == true {
            sfxButtonLabelNode = SKLabelNode(text: "- SOUND-FX: ON")
            sfxButtonLabelNode.fontColor = .green
        } else {
            sfxButtonLabelNode = SKLabelNode(text: "- SOUND-FX: OFF")
            sfxButtonLabelNode.fontColor = .red
        }
        
        sfxButtonLabelNode.position = CGPoint(x: 30, y: musicButtonLabelNode.position.y - 33)
        sfxButtonLabelNode.alpha = 1
        sfxButtonLabelNode.fontName = "LCD14"
        sfxButtonLabelNode.fontSize = 18
        sfxButtonLabelNode.horizontalAlignmentMode = .left
        addChild(sfxButtonLabelNode)
    }
    
    func addVibrationButtonLabelNode() {
        
        if vibrationOn == true {
            vibrationButtonLabelNode = SKLabelNode(text: "- VIBRATION: ON")
            vibrationButtonLabelNode.fontColor = .green
        } else {
            vibrationButtonLabelNode = SKLabelNode(text: "- VIBRATION: OFF")
            vibrationButtonLabelNode.fontColor = .red
        }
        
        vibrationButtonLabelNode.position = CGPoint(x: 30, y: sfxButtonLabelNode.position.y - 33)
        vibrationButtonLabelNode.alpha = 1
        vibrationButtonLabelNode.fontName = "LCD14"
        vibrationButtonLabelNode.fontSize = 18
        vibrationButtonLabelNode.horizontalAlignmentMode = .left
        addChild(vibrationButtonLabelNode)
    }
    
    func addShowStartScreenButtonLabelNode() {
        
        if startScreenOn == true {
            startScreenButtonLabelNode = SKLabelNode(text: "- START-SCREEN: ON")
            startScreenButtonLabelNode.fontColor = .green
        } else {
            startScreenButtonLabelNode = SKLabelNode(text: "- START-SCREEN: OFF")
            startScreenButtonLabelNode.fontColor = .red
        }
        
        startScreenButtonLabelNode.position = CGPoint(x: 30, y: vibrationButtonLabelNode.position.y - 33)
        startScreenButtonLabelNode.alpha = 1
        startScreenButtonLabelNode.fontName = "LCD14"
        startScreenButtonLabelNode.fontSize = 18
        startScreenButtonLabelNode.horizontalAlignmentMode = .left
        addChild(startScreenButtonLabelNode)
    }
    
    func addShowTutorialButtonLabelNode() {
        
        if tutorialShown == true {
            tutorialButtonLabelNode = SKLabelNode(text: "- GAME-TUTORIAL: OFF")
            tutorialButtonLabelNode.fontColor = .red
        } else {
            tutorialButtonLabelNode = SKLabelNode(text: "- GAME-TUTORIAL: ON")
            tutorialButtonLabelNode.fontColor = .green
        }
        
        tutorialButtonLabelNode.position = CGPoint(x: 30, y: startScreenButtonLabelNode.position.y - 33)
        tutorialButtonLabelNode.alpha = 1
        tutorialButtonLabelNode.fontName = "LCD14"
        tutorialButtonLabelNode.fontSize = 18
        tutorialButtonLabelNode.horizontalAlignmentMode = .left
        addChild(tutorialButtonLabelNode)
    }
    
    func addPrestigeButtonLabelNode() {
        
        prestigeButtonLabelNode = SKLabelNode(text: "- PRESTIGE")
        
        let ballsTillPrestige = 50 - UserDefaults.standard.integer(forKey: "ballsDroppedSincePrestige")
        
        print("ballsDroppedTillPrestige = \(50 - UserDefaults.standard.integer(forKey: "ballsDroppedSincePrestige"))")
        
        if UserDefaults.standard.integer(forKey: "ballsDroppedSincePrestige") < 50 {
            
            prestigeButtonLabelNode.isUserInteractionEnabled = true
            prestigeButtonLabelNode.fontColor = .red
        } else {
            
            prestigeButtonLabelNode.isUserInteractionEnabled = false
            prestigeButtonLabelNode.fontColor = .green
        }
        
        prestigeButtonLabelNode.position = CGPoint(x: 30, y: tutorialButtonLabelNode.position.y - 50)
        prestigeButtonLabelNode.fontName = "LCD14"
        prestigeButtonLabelNode.fontSize = 18
        prestigeButtonLabelNode.horizontalAlignmentMode = .left
        addChild(prestigeButtonLabelNode)
        
        if ballsTillPrestige > 0 {
            
            prestigeButtonDescriptionLabelNode = SKLabelNode(text: "\(ballsTillPrestige) MORE BALLS FOR NEXT PRESTIGE.")
            prestigeButtonDescriptionLabelNode.position = CGPoint(x: 0, y: -23)
            prestigeButtonDescriptionLabelNode.fontName = "LCD14"
            prestigeButtonDescriptionLabelNode.fontColor = .red
            prestigeButtonDescriptionLabelNode.fontSize = 11
            prestigeButtonDescriptionLabelNode.horizontalAlignmentMode = .left
            prestigeButtonLabelNode.addChild(prestigeButtonDescriptionLabelNode)
        }
    }
    
    func addDonateTitleLabelNode() {
        
        donateTitleLabelNode.position = CGPoint(x: Screen.width / 2, y: prestigeButtonLabelNode.position.y - 110)
        donateTitleLabelNode.alpha = 1
        donateTitleLabelNode.fontName = "LCD14"
        donateTitleLabelNode.fontColor = .green
        donateTitleLabelNode.fontSize = 26
        donateTitleLabelNode.horizontalAlignmentMode = .center
        addChild(donateTitleLabelNode)
        
    }
    
    func addDonateSection() {
        let donateFrameWidth = Screen.width * 0.8
        let donateFrameHeight = Screen.height * 0.3
        let donateFramePositionX = Screen.width * 0.1
        let donateFramePositionY = (donateTitleLabelNode.position.y - 20) - donateFrameHeight
        let donateSectionFrame = SKShapeNode(rect: CGRect(x: donateFramePositionX, y: donateFramePositionY, width: donateFrameWidth, height: donateFrameHeight), cornerRadius: 20)
        donateSectionFrame.fillColor = UIColor.black.withAlphaComponent(0.3)
        donateSectionFrame.lineWidth = 5
        donateSectionFrame.strokeColor = .green
        addChild(donateSectionFrame)
        
        let thankYouLabel = SKLabelNode(text: "WELCOME AND THANK YOU SO MUCH FOR PLAYING MY GAME!!!\nWANT MORE FUNNY FREE GAMES?\nSUPPORT ME:")
        thankYouLabel.alpha = 1
        thankYouLabel.fontName = "LCD14"
        thankYouLabel.fontColor = .green
        thankYouLabel.fontSize = 13
        thankYouLabel.horizontalAlignmentMode = .center
        thankYouLabel.preferredMaxLayoutWidth = donateFrameWidth - 30
        thankYouLabel.numberOfLines = 3
        thankYouLabel.position.x = Screen.center.x
        thankYouLabel.position.y = donateFramePositionY + donateFrameHeight - thankYouLabel.frame.size.height - 20
        donateSectionFrame.addChild(thankYouLabel)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == touches.first {
                
                if backButtonNode.contains(touch.location(in: self)) {
                    print("<- ab zum Hauptmenü <-")
                    if fxOn == true {
                        let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                        backButtonNode.run(pling)
                    }
                    if vibrationOn == true {
                        mediumVibration.impactOccurred()
                    }
                    SceneManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.fade(withDuration: 0.5))
                }
                
                if musicButtonLabelNode.contains(touch.location(in: self)) {
                    if fxOn == true {
                        let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                        backButtonNode.run(pling)
                    }
                    if vibrationOn == true {
                        mediumVibration.impactOccurred()
                    }
                    if backgroundMusicPlayerStatus == true {
                        musicButtonLabelNode.text = "- MUSIC: OFF"
                        musicButtonLabelNode.fontColor = .red
                        UserDefaults.standard.set(false, forKey: "backgroundMusicPlayerStatus")
                        backgroundMusicPlayer?.stop()
                        backgroundMusicPlayerStatus = false
                    } else {
                        musicButtonLabelNode.text = "- MUSIC: ON"
                        musicButtonLabelNode.fontColor = .green
                        UserDefaults.standard.set(true, forKey: "backgroundMusicPlayerStatus")
                        backgroundMusicPlayer?.play()
                        backgroundMusicPlayerStatus = true
                    }
                }
                
                if sfxButtonLabelNode.contains(touch.location(in: self)) {
                    if fxOn == true {
                        sfxButtonLabelNode.text = "- SOUND-FX: OFF"
                        sfxButtonLabelNode.fontColor = .red
                        UserDefaults.standard.set(false, forKey: "fxOn")
                        fxOn = false
                    } else {
                        sfxButtonLabelNode.text = "- SOUND-FX: ON"
                        sfxButtonLabelNode.fontColor = .green
                        UserDefaults.standard.set(true, forKey: "fxOn")
                        fxOn = true
                    }
                    if fxOn == true {
                        let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                        backButtonNode.run(pling)
                    }
                    if vibrationOn == true {
                        mediumVibration.impactOccurred()
                    }
                }
                
                if vibrationButtonLabelNode.contains(touch.location(in: self)) {
                    if vibrationOn == true {
                        vibrationButtonLabelNode.text = "- VIBRATION: OFF"
                        vibrationButtonLabelNode.fontColor = .red
                        UserDefaults.standard.set(false, forKey: "vibrationOn")
                        vibrationOn = false
                    } else {
                        vibrationButtonLabelNode.text = "- VIBRATION: ON"
                        vibrationButtonLabelNode.fontColor = .green
                        UserDefaults.standard.set(true, forKey: "vibrationOn")
                        vibrationOn = true
                    }
                    if fxOn == true {
                        let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                        backButtonNode.run(pling)
                    }
                    if vibrationOn == true {
                        mediumVibration.impactOccurred()
                    }
                }
                
                if startScreenButtonLabelNode.contains(touch.location(in: self)) {
                    if startScreenOn == true {
                        startScreenButtonLabelNode.text = "- START-SCREEN: OFF"
                        startScreenButtonLabelNode.fontColor = .red
                        UserDefaults.standard.set(false, forKey: "startScreenOn")
                        startScreenOn = false
                    } else {
                        startScreenButtonLabelNode.text = "- START-SCREEN: ON"
                        startScreenButtonLabelNode.fontColor = .green
                        UserDefaults.standard.set(true, forKey: "startScreenOn")
                        startScreenOn = true
                    }
                    if fxOn == true {
                        let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                        backButtonNode.run(pling)
                    }
                    if vibrationOn == true {
                        mediumVibration.impactOccurred()
                    }
                }
                
                if tutorialButtonLabelNode.contains(touch.location(in: self)) {
                    if tutorialShown == true {
                        tutorialButtonLabelNode.text = "- GAME-TUTORIAL: ON"
                        tutorialButtonLabelNode.fontColor = .green
                        UserDefaults.standard.set(false, forKey: "tutorialShown")
                        tutorialShown = false
                    } else {
                        tutorialButtonLabelNode.text = "- GAME-TUTORIAL: OFF"
                        tutorialButtonLabelNode.fontColor = .red
                        UserDefaults.standard.set(true, forKey: "tutorialShown")
                        tutorialShown = true
                    }
                    if fxOn == true {
                        let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                        backButtonNode.run(pling)
                    }
                    if vibrationOn == true {
                        mediumVibration.impactOccurred()
                    }
                }
                
                if prestigeButtonLabelNode.contains(touch.location(in: self)) {
                    
                    let prestigeValue = Double(lastHighscore) * prestigeMultiplyer
                    let roundedPrestigeValue = round(prestigeValue)
                    

                    print("prestigeValue = \(prestigeValue)")
                    print("roundedPrestigeValue = \(roundedPrestigeValue)")
                    
                    UserDefaults.standard.set(ballPointValue + Int(roundedPrestigeValue), forKey: "ballPointValue")
                    UserDefaults.standard.set(0, forKey: "highscore")

                    UserDefaults.standard.set(0, forKey: "ballsDroppedSincePrestige")
                    
                    ballPointValue = ballPointValue + Int(roundedPrestigeValue)
                    lastHighscore = 0
                    
                    prestigeButtonLabelNode.removeFromParent()
                    prestigeButtonDescriptionLabelNode.removeFromParent()
                    
                    addPrestigeButtonLabelNode()
                    
                    UserDefaults.standard.synchronize()
                    
                    if fxOn == true {
                        let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                        backButtonNode.run(pling)
                    }
                    if vibrationOn == true {
                        mediumVibration.impactOccurred()
                    }
                }
                
                
                
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}

