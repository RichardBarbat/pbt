//
//  MainMenu.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 15.03.19.
//  Copyright © 2019 me. All rights reserved.
//

import SpriteKit
import GameKit


// MARK: - globale Variablen

var pointsCount = 0
var multiplyerCount = 0

var ballsDroppedSincePrestige = UserDefaults.standard.integer(forKey: "ballsDroppedSincePrestige")
var prestigeCount = UserDefaults.standard.integer(forKey: "prestigeCount")
var prestigeValue = UserDefaults.standard.integer(forKey: "prestigeValue")
var ballPointValue = UserDefaults.standard.integer(forKey: "ballPointValue")
var lastHighscore = UserDefaults.standard.integer(forKey: "highscore")
let pointsLabelNode = SKLabelNode()
var highscoreLabelNode = SKLabelNode()
var miniMenu = SKShapeNode()
var vibrationOn = UserDefaults.standard.bool(forKey: "vibrationOn")
var startScreenOn = UserDefaults.standard.bool(forKey: "startScreenOn")
var fxOn = UserDefaults.standard.bool(forKey: "fxOn")
var highscoreLabelIsInFront = false
var multiplyerLabelNode = SKLabelNode()


var scaleToActionSequence = SKAction.sequence([])
var scaleByActionSequence = SKAction.sequence([])
var pulseActionSequence = SKAction.sequence([])
var rotateActionSequence = SKAction.sequence([])
var scalePlusPointsActionSequence = SKAction.sequence([])

let lightVibration = UIImpactFeedbackGenerator(style: .light)
let mediumVibration = UIImpactFeedbackGenerator(style: .medium)
let heavyVibration = UIImpactFeedbackGenerator(style: .heavy)
var gameOver = false

var tutorialShown = UserDefaults.standard.bool(forKey: "tutorialShown")


// MARK: - Beginn der Klasse

class MainMenu: SKScene {
    
    
    // MARK: - Variablen & Instanzen
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    let starFieldNode = SKShapeNode()
    let menuItems = ["PLAY", "COLLECTIBLES", "OVERVIEW", "OPTIONS", "MUSIC: ON "]
    
    let playerName = UserDefaults.standard.string(forKey: "playerName")!
    
    
    // MARK: - Beginn der Funktionen
    
    override func didMove(to view: SKView) {
        
        print("- Im Hauptmenü -")
        
        authenticatePlayer()
        
        self.backgroundColor = UIColor.init(hexFromString: "140032")
        
        if !UserDefaults.standard.bool(forKey: "mainMenuStartedBefore") {
            UserDefaults.standard.set(true, forKey: "mainMenuStartedBefore")
            
            UserDefaults.standard.set(true, forKey: "fxOn")
            UserDefaults.standard.set(true, forKey: "vibrationOn")
        }
        
        backgroundMusicPlayerStatus = UserDefaults.standard.bool(forKey: "backgroundMusicPlayerStatus")
        
//        self.backgroundColor = UIColor(hexFromString: "120d27")
        
        
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsDrawCount = true
        
        addStarFieldNode()
        addLaserFieldNode()
        addBgGlowLine()
        addBgLaserLines()
        addLogo()
        addWelcomeLabel()
        addSelections()
        
    }
    
    func authenticatePlayer() {
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                                
                let currentViewController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                currentViewController.present(view!, animated: true, completion: nil)
            }
        }
    }
    
    func addStarFieldNode() {
        let fieldNode = SKNode()
        
        for _ in 0...350 {
            
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.05...0.15))
            star.fillColor = .white
            star.glowWidth = CGFloat.random(in: 0.02...0.8)
            star.alpha = CGFloat.random(in: 0.1...0.4)
            
            star.position = CGPoint(x: CGFloat.random(in: 0...Screen.width), y: CGFloat.random(in: Screen.height * 0.38...Screen.height))
            fieldNode.addChild(star)
        }
        
        let fieldNodeSpriteNode = SKSpriteNode(texture: SKView().texture(from: fieldNode))
        fieldNodeSpriteNode.anchorPoint = .init(x: 0, y: 1)
        fieldNodeSpriteNode.position = CGPoint(x: 0, y: Screen.height)
        fieldNodeSpriteNode.zPosition = -1000
        addChild(fieldNodeSpriteNode)
    }
    
    func addLaserFieldNode() {
        
        let laserFrameNode = SKSpriteNode(imageNamed: "gitter")
        let laserFrameAspectRatio = laserFrameNode.size.width/laserFrameNode.size.height
        laserFrameNode.size = CGSize(width: Screen.width * 2.5 / laserFrameAspectRatio, height: Screen.height * 0.38)
        laserFrameNode.anchorPoint = CGPoint(x: 0.5, y: 0)
        laserFrameNode.position = CGPoint(x: Screen.width * 0.5, y: 0)
        laserFrameNode.zPosition = -900
        laserFrameNode.alpha = 1
        laserFrameNode.color = .blue
        laserFrameNode.colorBlendFactor = 0.7
        addChild(laserFrameNode)
        
    }
    
    func addBgGlowLine() {
        
        let bgGlowLinePath = CGMutablePath()
        bgGlowLinePath.move(to: CGPoint(x: -50, y: Screen.height * 0.38))
        bgGlowLinePath.addLine(to: CGPoint(x: Screen.width + 50, y: Screen.height * 0.38))
        let bgGlowLineNode = SKShapeNode()
        bgGlowLineNode.path = bgGlowLinePath
        bgGlowLineNode.strokeColor = UIColor(hexFromString: "3f00a0")
        bgGlowLineNode.lineWidth = 1
        bgGlowLineNode.glowWidth = 80
        bgGlowLineNode.alpha = 0.6
        
        let bgGlowLineTextureSpriteNode = SKSpriteNode(texture: SKView().texture(from: bgGlowLineNode))
        bgGlowLineTextureSpriteNode.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.38)
        bgGlowLineTextureSpriteNode.zPosition = -800
        
        
        
        let bgGlowLinePath2 = CGMutablePath()
        bgGlowLinePath2.move(to: CGPoint(x: -50, y: Screen.height * 0.38))
        bgGlowLinePath2.addLine(to: CGPoint(x: Screen.width + 50, y: Screen.height * 0.38))
        let bgGlowLineNode2 = SKShapeNode()
        bgGlowLineNode2.path = bgGlowLinePath2
        bgGlowLineNode2.strokeColor = UIColor(hexFromString: "3f00a0")
        bgGlowLineNode2.lineWidth = 1
        bgGlowLineNode2.glowWidth = 2
        bgGlowLineNode2.alpha = 0.8
        
        bgGlowLineNode2.addChild(bgGlowLineTextureSpriteNode)
        
        let bgGlowLineTextureSpriteNode2 = SKSpriteNode(texture: SKView().texture(from: bgGlowLineNode2))
        bgGlowLineTextureSpriteNode2.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.38)
        bgGlowLineTextureSpriteNode2.zPosition = -800
        
        addChild(bgGlowLineTextureSpriteNode2)
    }
    
    func addBgLaserLines() {
        let linePath1 = CGMutablePath()
        linePath1.move(to: CGPoint(x: -50, y: Screen.height * 0.72))
        linePath1.addLine(to: CGPoint(x: Screen.width + 50, y: Screen.height * 0.95))
        
        let linePath2 = CGMutablePath()
        linePath2.move(to: CGPoint(x: -50, y: Screen.height * 0.89))
        linePath2.addLine(to: CGPoint(x: Screen.width + 50, y: Screen.height * 0.655))
        
        let linePath3 = CGMutablePath()
        linePath3.move(to: CGPoint(x: -50, y: Screen.height * 0.63))
        linePath3.addLine(to: CGPoint(x: Screen.width + 50, y: Screen.height * 0.47))
        
        let linePath4 = CGMutablePath()
        linePath4.move(to: CGPoint(x: -50, y: Screen.height * 0.55))
        linePath4.addLine(to: CGPoint(x: Screen.width + 50, y: Screen.height * -0.07))
        
        let linePath5 = CGMutablePath()
        linePath5.move(to: CGPoint(x: -50, y: Screen.height * 0.33))
        linePath5.addLine(to: CGPoint(x: Screen.width + 50, y: Screen.height * 0.55))
        
        let linePath6 = CGMutablePath()
        linePath6.move(to: CGPoint(x: -50, y: Screen.height * -0.15))
        linePath6.addLine(to: CGPoint(x: Screen.width + 50, y: Screen.height * 0.38))
        
        let lineNode1 = SKShapeNode()
        lineNode1.path = linePath1
        lineNode1.strokeColor = UIColor(hexFromString: "d800ff")
        lineNode1.lineWidth = 2
        lineNode1.glowWidth = CGFloat.random(in: 0.0...1.2)
        lineNode1.alpha = CGFloat.random(in: 0.3...0.8)
        
        let lineNodeGlow1 = lineNode1.copy() as! SKShapeNode
        lineNodeGlow1.lineWidth = 0.1
        lineNodeGlow1.glowWidth = 14
        lineNode1.addChild(lineNodeGlow1)
        
        let lineNode2 = SKShapeNode()
        lineNode2.path = linePath2
        lineNode2.strokeColor = UIColor(hexFromString: "d800ff")
        lineNode2.lineWidth = 2
        lineNode2.glowWidth = CGFloat.random(in: 0.0...1.2)
        lineNode2.alpha = CGFloat.random(in: 0.3...0.8)
        
        let lineNodeGlow2 = lineNode2.copy() as! SKShapeNode
        lineNodeGlow2.lineWidth = 0.1
        lineNodeGlow2.glowWidth = 14
        lineNode2.addChild(lineNodeGlow2)
        
        let lineNode3 = SKShapeNode()
        lineNode3.path = linePath3
        lineNode3.strokeColor = UIColor(hexFromString: "d800ff")
        lineNode3.lineWidth = 2
        lineNode3.glowWidth = CGFloat.random(in: 0.0...1.2)
        lineNode3.alpha = CGFloat.random(in: 0.3...0.8)
        
        let lineNodeGlow3 = lineNode3.copy() as! SKShapeNode
        lineNodeGlow3.lineWidth = 0.1
        lineNodeGlow3.glowWidth = 14
        lineNode3.addChild(lineNodeGlow3)
        
        let lineNode4 = SKShapeNode()
        lineNode4.path = linePath4
        lineNode4.strokeColor = UIColor(hexFromString: "d800ff")
        lineNode4.lineWidth = 2
        lineNode4.glowWidth = CGFloat.random(in: 0.0...1.2)
        lineNode4.alpha = CGFloat.random(in: 0.3...0.8)
        
        let lineNodeGlow4 = lineNode4.copy() as! SKShapeNode
        lineNodeGlow4.lineWidth = 0.1
        lineNodeGlow4.glowWidth = 14
        lineNode4.addChild(lineNodeGlow4)
        
        let lineNode5 = SKShapeNode()
        lineNode5.path = linePath5
        lineNode5.strokeColor = UIColor(hexFromString: "d800ff")
        lineNode5.lineWidth = 2
        lineNode5.glowWidth = CGFloat.random(in: 0.0...1.2)
        lineNode5.alpha = CGFloat.random(in: 0.3...0.8)
        
        let lineNodeGlow5 = lineNode5.copy() as! SKShapeNode
        lineNodeGlow5.lineWidth = 0.1
        lineNodeGlow5.glowWidth = 14
        lineNode5.addChild(lineNodeGlow5)
        
        let lineNode6 = SKShapeNode()
        lineNode6.path = linePath6
        lineNode6.strokeColor = UIColor(hexFromString: "d800ff")
        lineNode6.lineWidth = 2
        lineNode6.glowWidth = CGFloat.random(in: 0.0...1.2)
        lineNode6.alpha = CGFloat.random(in: 0.3...0.8)
        
        let lineNodeGlow6 = lineNode6.copy() as! SKShapeNode
        lineNodeGlow6.lineWidth = 0.1
        lineNodeGlow6.glowWidth = 14
        lineNode6.addChild(lineNodeGlow6)
        
        let moveUpAction1 = SKAction.moveBy(x: 0, y:-30, duration:Double.random(in: 1...3))
        let moveUpAction2 = SKAction.moveBy(x: 0, y:-30, duration:Double.random(in: 1...3))
        let moveUpAction3 = SKAction.moveBy(x: 0, y:-30, duration:Double.random(in: 1...3))
        let moveUpAction4 = SKAction.moveBy(x: 0, y:-30, duration:Double.random(in: 1...3))
        let moveUpAction5 = SKAction.moveBy(x: 0, y:-30, duration:Double.random(in: 1...3))
        let moveUpAction6 = SKAction.moveBy(x: 0, y:-30, duration:Double.random(in: 1...3))

        let moveDownAction1 = SKAction.moveBy(x: 0, y:30, duration:Double.random(in: 1...3))
        let moveDownAction2 = SKAction.moveBy(x: 0, y:30, duration:Double.random(in: 1...3))
        let moveDownAction3 = SKAction.moveBy(x: 0, y:30, duration:Double.random(in: 1...3))
        let moveDownAction4 = SKAction.moveBy(x: 0, y:30, duration:Double.random(in: 1...3))
        let moveDownAction5 = SKAction.moveBy(x: 0, y:30, duration:Double.random(in: 1...3))
        let moveDownAction6 = SKAction.moveBy(x: 0, y:30, duration:Double.random(in: 1...3))

        let sequence1 = SKAction.sequence([moveUpAction1, moveDownAction1].shuffled())
        let sequence2 = SKAction.sequence([moveDownAction2, moveUpAction2].shuffled())
        let sequence3 = SKAction.sequence([moveUpAction3, moveDownAction3].shuffled())
        let sequence4 = SKAction.sequence([moveDownAction4, moveUpAction4].shuffled())
        let sequence5 = SKAction.sequence([moveUpAction5, moveDownAction5].shuffled())
        let sequence6 = SKAction.sequence([moveDownAction6, moveUpAction6].shuffled())

        let endlessAction1 = SKAction.repeatForever(sequence1)
        let endlessAction2 = SKAction.repeatForever(sequence2)
        let endlessAction3 = SKAction.repeatForever(sequence3)
        let endlessAction4 = SKAction.repeatForever(sequence4)
        let endlessAction5 = SKAction.repeatForever(sequence5)
        let endlessAction6 = SKAction.repeatForever(sequence6)


        
        let line1SpriteNode = SKSpriteNode(texture: SKView().texture(from: lineNode1))
        line1SpriteNode.zPosition = -701
        line1SpriteNode.anchorPoint = .init(x: 0, y: 0)
        line1SpriteNode.position = CGPoint(x: -50, y: Screen.height * 0.72)
        addChild(line1SpriteNode)
        line1SpriteNode.run(endlessAction1)
        
        let line2SpriteNode = SKSpriteNode(texture: SKView().texture(from: lineNode2))
        line2SpriteNode.zPosition = -702
        line2SpriteNode.anchorPoint = .init(x: 0, y: 0)
        line2SpriteNode.position = CGPoint(x: -50, y: Screen.height * 0.655)
        addChild(line2SpriteNode)
        line2SpriteNode.run(endlessAction2)
        
        let line3SpriteNode = SKSpriteNode(texture: SKView().texture(from: lineNode3))
        line3SpriteNode.zPosition = -703
        line3SpriteNode.anchorPoint = .init(x: 0, y: 0)
        line3SpriteNode.position = CGPoint(x: -50, y: Screen.height * 0.47)
        addChild(line3SpriteNode)
        line3SpriteNode.run(endlessAction3)
        
        let line4SpriteNode = SKSpriteNode(texture: SKView().texture(from: lineNode4))
        line4SpriteNode.zPosition = -704
        line4SpriteNode.anchorPoint = .init(x: 0, y: 0)
        line4SpriteNode.position = CGPoint(x: -50, y: Screen.height * -0.07)
        addChild(line4SpriteNode)
        line4SpriteNode.run(endlessAction4)
        
        let line5SpriteNode = SKSpriteNode(texture: SKView().texture(from: lineNode5))
        line5SpriteNode.zPosition = -705
        line5SpriteNode.anchorPoint = .init(x: 0, y: 0)
        line5SpriteNode.position = CGPoint(x: -50, y: Screen.height * 0.33)
        addChild(line5SpriteNode)
        line5SpriteNode.run(endlessAction5)
        
        let line6SpriteNode = SKSpriteNode(texture: SKView().texture(from: lineNode6))
        line6SpriteNode.zPosition = -706
        line6SpriteNode.anchorPoint = .init(x: 0, y: 0)
        line6SpriteNode.position = CGPoint(x: -50, y: Screen.height * -0.15)
        addChild(line6SpriteNode)
        line6SpriteNode.run(endlessAction6)
        
    }
    
    func addLogo() {
        let logoNode = SKSpriteNode(imageNamed: "plinko-blaster-logo3")
        let logoAspectRatio = logoNode.size.width/logoNode.size.height
        if DeviceType.isiPad || DeviceType.isiPadPro {
            logoNode.size = CGSize(width: Screen.width * 0.6, height: Screen.width * 0.6 / logoAspectRatio)
        } else {
            //            print("is not iPad")
            logoNode.size = CGSize(width: Screen.width * 1.0, height: Screen.width * 1.0 / logoAspectRatio)
        }
        
        logoNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        logoNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.83)
        logoNode.name = "logo"
        //        logoNode.run(endlessAction3) für Logo eine eigene Action erstellen
        
        addChild(logoNode)
    }
    
    func addWelcomeLabel() {
        
        let welcome = SKLabelNode(text: "WELCOME \(playerName)")
        welcome.fontColor = UIColor.yellow
        welcome.fontName = "LCD14"
        welcome.fontSize = 28
        welcome.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.65)
        welcome.alpha = 1
        welcome.removeAllChildren()
        welcome.addGlow(radius: 7)
        welcome.children.first?.position = CGPoint(x: 0, y: welcome.frame.size.height / 2)
        self.addChild(welcome)
        
    }
    
    func addSelections() {
        
        for i in 0...menuItems.count - 1 {
            
            let item = SKLabelNode(text: "\(self.menuItems[i])")
            item.fontName = "LCD14"
            item.name = "\(self.menuItems[i])-Button"
            item.fontColor = .green
            
            if item.text == "PLAY" {
                
                item.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.45 - (CGFloat(i) * (item.frame.size.height + 50)))
                item.fontSize = 60
                item.addGlow(radius: 10)
                item.children.first?.position = CGPoint(x: 0, y: item.frame.size.height / 2)
                
            } else if item.text == "COLLECTIBLES" {
                
                item.position = CGPoint(x: Screen.width / 2, y: 220)
                item.fontSize = 28
                item.fontColor = UIColor(hexFromString: "0099ff")
                item.addGlow(radius: 7)
                item.children.first?.position = CGPoint(x: 0, y: item.frame.size.height / 2)
               
            } else if item.text == "OPTIONS" {
                
                item.position = CGPoint(x: Screen.width / 2, y: 150)
                item.fontSize = 25
                item.addGlow(radius: 7)
                item.children.first?.position = CGPoint(x: 0, y: item.frame.size.height / 2)

            } else if item.text == "OVERVIEW" {
                
                item.position = CGPoint(x: Screen.width / 2, y: 100)
                item.fontSize = 25
                item.addGlow(radius: 7)
                item.children.first?.position = CGPoint(x: 0, y: item.frame.size.height / 2)

            } else if item.text == "MUSIC: ON " {
                item.fontSize = 25
                item.position = CGPoint(x: Screen.width / 2, y: 50)
                item.alpha = 1
                if backgroundMusicPlayerStatus == false {
                    item.text = "MUSIC: OFF "
                    item.fontColor = UIColor.red
                    backgroundMusicPlayer?.stop()
                } else {
                    item.text = "MUSIC: ON "
                    item.fontColor = UIColor.green
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        backgroundMusicPlayer?.play()
                    }
                }
                item.removeAllChildren()
                item.addGlow(radius: 7)
                item.children.first?.position = CGPoint(x: 0, y: item.frame.size.height / 2)
            }
            self.addChild(item)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == touches.first {
                if self.childNode(withName: "logo")!.contains(touch.location(in: self)) {
                    
                    if fxOn {
                        print("PLING!!!")
                        let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                        self.run(pling)
                    }
                    
                } else if self.childNode(withName: "PLAY-Button")!.contains(touch.location(in: self)) {
                    
                    print("-> ab zum Spiel ->")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        if vibrationOn == true {
                            self.generator.impactOccurred()
                        }
                        if fxOn == true {
                            let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                            self.childNode(withName: "PLAY-Button")!.run(pling)
                        }
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.removeAllChildren()
                        self.removeAllActions()
                        SceneManager.shared.transition(self, toScene: .Level1, transition: SKTransition.fade(withDuration: 0.5))
                    })
                    
                    
                    
                } else if self.childNode(withName: "OPTIONS-Button") != nil && self.childNode(withName: "OPTIONS-Button")!.contains(touch.location(in: self)) {
                    
                    print("-> ab zu den Settings ->")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        if vibrationOn == true {
                            self.generator.impactOccurred()
                        }
                        if fxOn == true {
                            let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                            self.childNode(withName: "OPTIONS-Button")!.run(pling)
                        }
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.removeAllChildren()
                        self.removeAllActions()
                        SceneManager.shared.transition(self, toScene: .Options, transition: SKTransition.fade(withDuration: 0.5))
                    })
                    
                    
                    
                } else if self.childNode(withName: "COLLECTIBLES-Button") != nil && self.childNode(withName: "COLLECTIBLES-Button")!.contains(touch.location(in: self)) {
                                   
                    print("-> ab zu den COLLECTIBLES ->")

                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                       if vibrationOn == true {
                           self.generator.impactOccurred()
                       }
                       if fxOn == true {
                           let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                           self.childNode(withName: "COLLECTIBLES-Button")!.run(pling)
                       }
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                       self.removeAllChildren()
                       self.removeAllActions()
                       SceneManager.shared.transition(self, toScene: .CollectiblesScene, transition: SKTransition.fade(withDuration: 0.5))
                    })
                    
                } else if self.childNode(withName: "OVERVIEW-Button") != nil && self.childNode(withName: "OVERVIEW-Button")!.contains(touch.location(in: self)) {
                    
                    print("-> ab zur Spieler-Übersicht ->")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        if vibrationOn == true {
                            self.generator.impactOccurred()
                        }
                        if fxOn == true {
                            let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                            self.childNode(withName: "OVERVIEW-Button")!.run(pling)
                        }
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.removeAllChildren()
                        self.removeAllActions()
                        SceneManager.shared.transition(self, toScene: .OverviewScene, transition: SKTransition.fade(withDuration: 0.5))
                    })
                    
                    
                    
                } else if self.childNode(withName: "MUSIC: ON -Button") != nil && self.childNode(withName: "MUSIC: ON -Button")!.contains(touch.location(in: self)) {
                    
                    if vibrationOn == true {
                        self.generator.impactOccurred()
                    }
                    if fxOn == true {
                        let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                        self.childNode(withName: "MUSIC: ON -Button")!.run(pling)
                    }
                    
                    if backgroundMusicPlayerStatus == true {
                        
                        backgroundMusicPlayer?.stop()
                        let button = self.childNode(withName: "MUSIC: ON -Button") as! SKLabelNode
                        button.text = "MUSIC: OFF "
                        button.fontColor = UIColor.red
                        button.removeAllChildren()
                        button.addGlow(radius: 7)
                        button.children.first?.position = CGPoint(x: 0, y: button.frame.size.height / 2)
                        backgroundMusicPlayerStatus = false
                        UserDefaults.standard.set(false, forKey: "backgroundMusicPlayerStatus")
                        
                    } else {
                        
                        backgroundMusicPlayer?.play()
                        let button = self.childNode(withName: "MUSIC: ON -Button") as! SKLabelNode
                        button.text = "MUSIC: ON "
                        button.fontColor = UIColor.green
                        button.removeAllChildren()
                        button.addGlow(radius: 7)
                        button.children.first?.position = CGPoint(x: 0, y: button.frame.size.height / 2)
                        backgroundMusicPlayerStatus = true
                        UserDefaults.standard.set(true, forKey: "backgroundMusicPlayerStatus")
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}

