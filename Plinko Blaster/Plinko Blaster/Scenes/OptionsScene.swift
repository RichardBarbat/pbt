//
//  MainMenu.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 15.03.19.
//  Copyright © 2019 me. All rights reserved.
//

import GameKit

let multiplyedPrestigeCount = Int(Double(prestigeCount * 10).rounded())
var ballsToCollectForNextPrestige: Int = UserDefaults.standard.value(forKey: "ballsToCollectForNextPrestige") as! Int

class OptionsScene: SKScene, GKGameCenterControllerDelegate {
    
    let backButtonNode = SKSpriteNode(imageNamed: "back-button4")
    let gameCenterButtonNode = SKSpriteNode(imageNamed: "gc-icon")
    
    let optionsTitleLabelNode = SKLabelNode(text: "OPTIONS")
    let extrasTitleLabelNode = SKLabelNode(text: "EXTRAS")
    var musicButtonLabelNode = SKLabelNode()
    var sfxButtonLabelNode = SKLabelNode()
    var vibrationButtonLabelNode = SKLabelNode()
    var startScreenButtonLabelNode = SKLabelNode()
    var tutorialButtonLabelNode = SKLabelNode()
    var prestigeButtonLabelNode = SKLabelNode()
    
    var secretDebugTapCounter = 0
    
    let resetButton = SKShapeNode(circleOfRadius: Screen.width * 0.03)

    
    override func didMove(to view: SKView) {
        
        print("- In den OPTIONS -")
        
        self.backgroundColor = UIColor.init(hexFromString: "242d24")
        
        self.view?.tintColor = .green
                
        addBackButtonNode()
        addGameCenterButtonNode()
        addOptionsTitleLabelNode()
        addMusicButtonLabelNode()
        addSFXButtonLabelNode()
        addVibrationButtonLabelNode()
//        addShowStartScreenButtonLabelNode()
        addShowTutorialButtonLabelNode()
        addPrestigeButtonLabelNode()
        addExtrasSection()
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
    
    func addGameCenterButtonNode() {
        gameCenterButtonNode.size = CGSize(width: Screen.width * 0.08, height: Screen.width * 0.08 )
        
        gameCenterButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameCenterButtonNode.position = CGPoint(x: Screen.width * 0.9, y: Screen.height * 0.95)
        gameCenterButtonNode.alpha = 0.7
        addChild(gameCenterButtonNode)
    }
    
    func addOptionsTitleLabelNode() {
        
        optionsTitleLabelNode.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.88)
        optionsTitleLabelNode.alpha = 1
        optionsTitleLabelNode.fontName = "PixelSplitter"
        optionsTitleLabelNode.fontColor = (DEBUGMODE == 0) ? .green : .red
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
        musicButtonLabelNode.fontName = "PixelSplitter"
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
        sfxButtonLabelNode.fontName = "PixelSplitter"
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
        vibrationButtonLabelNode.fontName = "PixelSplitter"
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
        startScreenButtonLabelNode.fontName = "PixelSplitter"
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
        
        tutorialButtonLabelNode.position = CGPoint(x: 30, y: vibrationButtonLabelNode.position.y - 33)
        tutorialButtonLabelNode.alpha = 1
        tutorialButtonLabelNode.fontName = "PixelSplitter"
        tutorialButtonLabelNode.fontSize = 18
        tutorialButtonLabelNode.horizontalAlignmentMode = .left
        addChild(tutorialButtonLabelNode)
    }
    
    func addPrestigeButtonLabelNode() {
        
        prestigeButtonLabelNode = SKLabelNode(text: "- PRESTIGE")
        var prestigeButtonLevelLabelNode = SKLabelNode()
        var prestigeButtonDescriptionLabelNode = SKLabelNode()
                
        prestigeButtonLabelNode.position = CGPoint(x: 30, y: tutorialButtonLabelNode.position.y - 50)
        prestigeButtonLabelNode.fontName = "PixelSplitter"
        prestigeButtonLabelNode.fontSize = 18
        prestigeButtonLabelNode.horizontalAlignmentMode = .left
        addChild(prestigeButtonLabelNode)
        
        
        if ballsToCollectForNextPrestige > 0 {
            
            prestigeButtonLabelNode.isUserInteractionEnabled = true //???
            prestigeButtonLabelNode.fontColor = .red

            prestigeButtonLevelLabelNode = SKLabelNode(text: "YOUR PRESTIGE LEVEL: \(prestigeCount + 1)")
            prestigeButtonLevelLabelNode.position = CGPoint(x: 15, y: -8)
            prestigeButtonLevelLabelNode.fontName = "PixelSplitter"
            prestigeButtonLevelLabelNode.fontColor = .yellow
            prestigeButtonLevelLabelNode.fontSize = 10
            prestigeButtonLevelLabelNode.horizontalAlignmentMode = .left
            prestigeButtonLevelLabelNode.verticalAlignmentMode = .top
            prestigeButtonLabelNode.addChild(prestigeButtonLevelLabelNode)
            
            prestigeButtonDescriptionLabelNode = SKLabelNode(text: "DROP \(ballsToCollectForNextPrestige) MORE BALLS FOR NEXT PRESTIGE.")
            prestigeButtonDescriptionLabelNode.position = CGPoint(x: 15, y: -25)
            prestigeButtonDescriptionLabelNode.fontName = "PixelSplitter"
            prestigeButtonDescriptionLabelNode.fontSize = 10
            prestigeButtonDescriptionLabelNode.fontColor = .yellow
            prestigeButtonDescriptionLabelNode.horizontalAlignmentMode = .left
            prestigeButtonDescriptionLabelNode.verticalAlignmentMode = .top
            prestigeButtonLabelNode.addChild(prestigeButtonDescriptionLabelNode)
            
        } else {
            
            prestigeButtonLabelNode.isUserInteractionEnabled = false //???
            prestigeButtonLabelNode.fontColor = .green

            prestigeButtonLevelLabelNode = SKLabelNode(text: "YOUR PRESTIGE LEVEL: \(prestigeCount + 1) -> NEXT LEVEL: \(prestigeCount + 2)")
            prestigeButtonLevelLabelNode.numberOfLines = 2
            prestigeButtonLevelLabelNode.position = CGPoint(x: 15, y: -8)
            prestigeButtonLevelLabelNode.fontName = "PixelSplitter"
            prestigeButtonLevelLabelNode.fontColor = .green
            prestigeButtonLevelLabelNode.fontSize = 10
            prestigeButtonLevelLabelNode.horizontalAlignmentMode = .left
            prestigeButtonLevelLabelNode.verticalAlignmentMode = .top
            prestigeButtonLabelNode.addChild(prestigeButtonLevelLabelNode)
            
            prestigeButtonDescriptionLabelNode = SKLabelNode(text: "YOU CAN PRESTIGE NOW.\nBALLS WILL COLLECT \(ballPointValue + prestigeValue)X POINTS.")
            prestigeButtonDescriptionLabelNode.position = CGPoint(x: 15, y: -40)
            prestigeButtonDescriptionLabelNode.fontName = "PixelSplitter"
            prestigeButtonDescriptionLabelNode.numberOfLines = 2
            prestigeButtonDescriptionLabelNode.preferredMaxLayoutWidth = Screen.width * 0.75
            prestigeButtonDescriptionLabelNode.fontSize = 10
            prestigeButtonDescriptionLabelNode.fontColor = .green
            prestigeButtonDescriptionLabelNode.horizontalAlignmentMode = .left
            prestigeButtonDescriptionLabelNode.verticalAlignmentMode = .top
            prestigeButtonLabelNode.addChild(prestigeButtonDescriptionLabelNode)
            
        }
    }

    func addExtrasSection() {
        
        extrasTitleLabelNode.position = CGPoint(x: Screen.width / 2, y: prestigeButtonLabelNode.position.y - 150)
        extrasTitleLabelNode.alpha = 1
        extrasTitleLabelNode.fontName = "PixelSplitter"
        extrasTitleLabelNode.fontColor = .green
        extrasTitleLabelNode.fontSize = 26
        extrasTitleLabelNode.horizontalAlignmentMode = .center
        addChild(extrasTitleLabelNode)
        
        let extraSectionFrameWidth = Screen.width * 0.8
        let extraSectionFrameHeight = Screen.height * 0.21
        let extraSectionFramePositionX = Screen.width * 0.1
        let extraSectionFramePositionY = (extrasTitleLabelNode.position.y - 20) - extraSectionFrameHeight
        let extraSectionFrame = SKShapeNode(rect: CGRect(x: extraSectionFramePositionX, y: extraSectionFramePositionY, width: extraSectionFrameWidth, height: extraSectionFrameHeight), cornerRadius: 20)
        extraSectionFrame.fillColor = UIColor.black.withAlphaComponent(0.3)
        extraSectionFrame.lineWidth = 5
        extraSectionFrame.strokeColor = .green
        extraSectionFrame.alpha = 0.3
        addChild(extraSectionFrame)

        let extraTitleDescriptionLabel = SKLabelNode(text: "BOOST YOUR HIGHSCORE WITH THESE AWESOME EXTRAS:")
        extraTitleDescriptionLabel.alpha = 1
        extraTitleDescriptionLabel.fontName = "PixelSplitter"
        extraTitleDescriptionLabel.fontColor = .green
        extraTitleDescriptionLabel.fontSize = 14
        extraTitleDescriptionLabel.horizontalAlignmentMode = .center
        extraTitleDescriptionLabel.preferredMaxLayoutWidth = extraSectionFrameWidth - 30
        extraTitleDescriptionLabel.numberOfLines = 3
        extraTitleDescriptionLabel.position.x = Screen.center.x
        extraTitleDescriptionLabel.position.y = extraSectionFramePositionY + extraSectionFrameHeight - extraTitleDescriptionLabel.frame.size.height - 20
        extraSectionFrame.addChild(extraTitleDescriptionLabel)
        
        
        
        let firstExtraFrame = SKShapeNode(rect: CGRect(x: extraSectionFramePositionX, y: extraSectionFramePositionY, width: extraSectionFrameWidth / 3, height: extraSectionFrameHeight / 2), cornerRadius: 20)
        firstExtraFrame.lineWidth = 0
        firstExtraFrame.name = "firstExtraFrame"
        
        let firstExtraFrameImageRect = SKSpriteNode(imageNamed: "option_extra1")
        firstExtraFrameImageRect.position = CGPoint(x: firstExtraFrame.frame.origin.x + firstExtraFrame.frame.size.width / 2, y: firstExtraFrame.frame.origin.y + firstExtraFrame.frame.size.height / 1.6)
        firstExtraFrameImageRect.setScale(0.5)
        firstExtraFrame.addChild(firstExtraFrameImageRect)
        
        let firstExtraFramePriceLabel = SKLabelNode(text: "0,79€")
        firstExtraFramePriceLabel.fontName = "PixelSplitter"
        firstExtraFramePriceLabel.fontColor = .green
        firstExtraFramePriceLabel.fontSize = 16
        firstExtraFramePriceLabel.horizontalAlignmentMode = .center
        firstExtraFramePriceLabel.preferredMaxLayoutWidth = firstExtraFrame.frame.size.width
        firstExtraFramePriceLabel.position = CGPoint(x: firstExtraFrame.frame.origin.x + firstExtraFrame.frame.size.width / 2, y: firstExtraFrame.frame.origin.y + 10)
        firstExtraFrame.addChild(firstExtraFramePriceLabel)
        
        
        
        
        
        let secondExtraFrame = SKShapeNode(rect: CGRect(x: extraSectionFramePositionX + firstExtraFrame.frame.size.width, y: extraSectionFramePositionY, width: extraSectionFrameWidth / 3, height: extraSectionFrameHeight / 2), cornerRadius: 20)
        secondExtraFrame.lineWidth = 0
        secondExtraFrame.name = "secondExtraFrame"
        
        let secondExtraFrameImageRect = SKSpriteNode(imageNamed: "option_extra2")
        secondExtraFrameImageRect.position = CGPoint(x: secondExtraFrame.frame.origin.x + secondExtraFrame.frame.size.width / 2, y: secondExtraFrame.frame.origin.y + secondExtraFrame.frame.size.height / 1.6)
        secondExtraFrameImageRect.setScale(0.5)
        secondExtraFrame.addChild(secondExtraFrameImageRect)
        
        let secondExtraFramePriceLabel = SKLabelNode(text: "1,99€")
        secondExtraFramePriceLabel.fontName = "PixelSplitter"
        secondExtraFramePriceLabel.fontColor = .green
        secondExtraFramePriceLabel.fontSize = 16
        secondExtraFramePriceLabel.horizontalAlignmentMode = .center
        secondExtraFramePriceLabel.preferredMaxLayoutWidth = secondExtraFrame.frame.size.width
        secondExtraFramePriceLabel.position = CGPoint(x: secondExtraFrame.frame.origin.x + secondExtraFrame.frame.size.width / 2, y: secondExtraFrame.frame.origin.y + 10)
        secondExtraFrame.addChild(secondExtraFramePriceLabel)
        
        
        
        
        let thirdExtraFrame = SKShapeNode(rect: CGRect(x: extraSectionFramePositionX + firstExtraFrame.frame.size.width + secondExtraFrame.frame.size.width, y: extraSectionFramePositionY, width: extraSectionFrameWidth / 3, height: extraSectionFrameHeight / 2), cornerRadius: 20)
        thirdExtraFrame.lineWidth = 0
        thirdExtraFrame.name = "thirdExtraFrame"
        
        let thirdExtraFrameImageRect = SKSpriteNode(imageNamed: "option_extra3")
        thirdExtraFrameImageRect.position = CGPoint(x: thirdExtraFrame.frame.origin.x + thirdExtraFrame.frame.size.width / 2, y: thirdExtraFrame.frame.origin.y + thirdExtraFrame.frame.size.height / 1.6)
        thirdExtraFrameImageRect.setScale(0.5)
        thirdExtraFrame.addChild(thirdExtraFrameImageRect)
        
        let thirdExtraFramePriceLabel = SKLabelNode(text: "4,99€")
        thirdExtraFramePriceLabel.fontName = "PixelSplitter"
        thirdExtraFramePriceLabel.fontColor = .green
        thirdExtraFramePriceLabel.fontSize = 16
        thirdExtraFramePriceLabel.horizontalAlignmentMode = .center
        thirdExtraFramePriceLabel.preferredMaxLayoutWidth = thirdExtraFrame.frame.size.width
        thirdExtraFramePriceLabel.position = CGPoint(x: thirdExtraFrame.frame.origin.x + thirdExtraFrame.frame.size.width / 2, y: thirdExtraFrame.frame.origin.y + 10)
        thirdExtraFrame.addChild(thirdExtraFramePriceLabel)
        
        
        
        extraSectionFrame.addChild(firstExtraFrame)
        extraSectionFrame.addChild(secondExtraFrame)
        extraSectionFrame.addChild(thirdExtraFrame)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == touches.first {
                
                // BACK BUTTON
                if backButtonNode.contains(touch.location(in: self)) {
                    print("<- ab zum Hauptmenü <-")
                    if vibrationOn == true {
                        runHaptic()
                    }
                    if fxOn == true {
                        self.run(backButtonSound)
                    }
                    SceneManager.shared.transition(self, toScene: .MainScene, transition: SKTransition.fade(withDuration: 0.5))
                }
                
                // GAME CENTER BUTTON
                if gameCenterButtonNode.contains(touch.location(in: self)) {
                    print("OPEN GAME CENTER !!!")
                    if vibrationOn == true {
                        runHaptic()
                    }
                    
                    let currentViewController: UIViewController = UIApplication.shared.windows.filter{$0.isKeyWindow}.first!.rootViewController!
                    let gameCenterViewController = GKGameCenterViewController()
                    gameCenterViewController.gameCenterDelegate = self
                    currentViewController.present(gameCenterViewController, animated: true, completion: nil)
                    
                }
                
                // MUSIC BUTTON
                if musicButtonLabelNode.contains(touch.location(in: self)) {
                    if fxOn == true {
                        self.run(pling)
                    }
                    if vibrationOn == true {
                        runHaptic()
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
                
                // SFX BUTTON
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
                        self.run(pling)
                    }
                    if vibrationOn == true {
                        runHaptic()
                    }
                }
                
                // VIBRATION BUTTON
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
                        self.run(pling)
                    }
                    if vibrationOn == true {
                        runHaptic()
                    }
                }
                
                // STARTSCREEN BUTTON (currently not used)
//                if startScreenButtonLabelNode.contains(touch.location(in: self)) {
//                    if startScreenOn == true {
//                        startScreenButtonLabelNode.text = "- START-SCREEN: OFF"
//                        startScreenButtonLabelNode.fontColor = .red
//                        UserDefaults.standard.set(false, forKey: "startScreenOn")
//                        startScreenOn = false
//                    } else {
//                        startScreenButtonLabelNode.text = "- START-SCREEN: ON"
//                        startScreenButtonLabelNode.fontColor = .green
//                        UserDefaults.standard.set(true, forKey: "startScreenOn")
//                        startScreenOn = true
//                    }
//                    if fxOn == true {
//                        self.run(pling)
//                    }
//                    if vibrationOn == true {
//                        runHaptic()
//                    }
//                }
                
                // GAME TUTORIAL BUTTON
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
                        self.run(pling)
                    }
                    if vibrationOn == true {
                        runHaptic()
                    }
                }
                
                if optionsTitleLabelNode.contains(touch.location(in: self)) {
                    
                    secretDebugTapCounter += 1
                    
                    if secretDebugTapCounter == 20 && DEBUGMODE == 0 {
                        secretDebugTapCounter = 0
                        DEBUGMODE = 1
                        optionsTitleLabelNode.fontColor = .red
                    } else if secretDebugTapCounter == 20 && DEBUGMODE == 1 {
                        secretDebugTapCounter = 0
                        DEBUGMODE = 0
                        optionsTitleLabelNode.fontColor = .green
                    }
                    
                    print(secretDebugTapCounter)
                }
                
                
                
                // PRESTIGE BUTTON
                if prestigeButtonLabelNode.contains(touch.location(in: self)) {
                    
                    prestigeCount = prestigeCount + 1
                    UserDefaults.standard.set(prestigeCount, forKey: "prestigeCount")
                                        
                    UserDefaults.standard.set(ballPointValue + prestigeValue, forKey: "ballPointValue")
                    
                    UserDefaults.standard.set(0, forKey: "ballsDroppedSincePrestige")
                    
                    ballPointValue = ballPointValue + prestigeValue
                    ballsDroppedSincePrestige = 0
                    
                    UserDefaults.standard.set(50 - ballsDroppedSincePrestige + multiplyedPrestigeCount, forKey: "ballsToCollectForNextPrestige")
                    ballsToCollectForNextPrestige = UserDefaults.standard.value(forKey: "ballsToCollectForNextPrestige") as! Int
                    
                    prestigeButtonLabelNode.removeFromParent()
                    
                    addPrestigeButtonLabelNode()
                    
                    UserDefaults.standard.synchronize()
                    
                    if fxOn == true {
                        self.run(pling)
                    }
                    if vibrationOn == true {
                        runHaptic()
                    }
                }
            }
        }
    }
    
    
    
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}

