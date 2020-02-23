//
//  WelcomeScene.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 19.04.19.
//  Copyright © 2019 me. All rights reserved.
//

import SpriteKit
import UIKit


// MARK: - Beginn der Klasse

class WelcomeScene: SKScene, UITextFieldDelegate {
    
    
    // MARK: - Variablen & Instanzen
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    let starFieldNode = SKShapeNode()
    
    var newNameTextField: UITextField!
    
    
    // MARK: - Beginn der Funktionen
    
    override func didMove(to view: SKView) {
        
        print("- Im Wilkommen Bildschirm -")
        
        self.backgroundColor = UIColor.init(hexFromString: "140032")
        
        backgroundMusicPlayerStatus = UserDefaults.standard.bool(forKey: "backgroundMusicPlayerStatus")
                
        addStarFieldNode()
        addLaserFieldNode()
        addBgGlowLine()
        addBgLaserLines()
        addWelcomeText()
        addLogo()
        addMusicButton()
        addTextField()
        
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
    
    func addWelcomeText() {
        let welcome = SKLabelNode(text: "WELCOME TO")
        welcome.fontColor = UIColor.yellow
        welcome.fontName = "LCD14"
        welcome.fontSize = 40
        welcome.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.875)
        welcome.alpha = 1
        welcome.removeAllChildren()
        welcome.addGlow(radius: 7)
        welcome.children.first?.position = CGPoint(x: 0, y: welcome.frame.size.height / 2)
        self.addChild(welcome)
        
        let newPlayerLabelNode = SKLabelNode(text: "ADD NEW PLAYER")
        newPlayerLabelNode.name = "newPlayerLabelNode"
        newPlayerLabelNode.preferredMaxLayoutWidth = Screen.width * 0.9
        newPlayerLabelNode.fontColor = UIColor.green
        newPlayerLabelNode.fontName = "LCD14"
        newPlayerLabelNode.fontSize = 22
        newPlayerLabelNode.position = CGPoint(x: 0, y: -newPlayerLabelNode.frame.size.height / 2)
        newPlayerLabelNode.alpha = 1
        newPlayerLabelNode.addGlow(radius: 7)
        newPlayerLabelNode.children.first?.position = CGPoint(x: 0, y: newPlayerLabelNode.frame.size.height / 2)
        
        let addPlayerLabelOutlineNode = SKShapeNode(rectOf: CGSize(width: newPlayerLabelNode.frame.size.width * 1.2, height: newPlayerLabelNode.frame.size.height * 2), cornerRadius: 6)
        addPlayerLabelOutlineNode.name = "addPlayerButton"
        addPlayerLabelOutlineNode.fillColor = .clear
        addPlayerLabelOutlineNode.strokeColor = .green
        addPlayerLabelOutlineNode.lineWidth = 3
        addPlayerLabelOutlineNode.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.56)
        addPlayerLabelOutlineNode.addGlow(radius: 7)
        addPlayerLabelOutlineNode.children.first?.position = CGPoint(x: 0, y: 0)
        addPlayerLabelOutlineNode.addChild(newPlayerLabelNode)
        addChild(addPlayerLabelOutlineNode)
        
        
        let pleaseLabelNode = SKLabelNode(text: "PLEASE ADD A NEW PLAYER SO THE GAME CAN SAVE YOUR PROGRESS.")
        pleaseLabelNode.name = "pleaseLabelNode"
        pleaseLabelNode.preferredMaxLayoutWidth = Screen.width * 0.8
        pleaseLabelNode.fontColor = UIColor.init(hexFromString: "0099ff")
        pleaseLabelNode.numberOfLines = 6
        pleaseLabelNode.fontName = "LCD14"
        pleaseLabelNode.fontSize = 17
        pleaseLabelNode.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.2)
        pleaseLabelNode.alpha = 1
        pleaseLabelNode.removeAllChildren()
        pleaseLabelNode.addGlow(radius: 7)
        pleaseLabelNode.children.first?.position = CGPoint(x: 0, y: pleaseLabelNode.frame.size.height / 2)
        self.addChild(pleaseLabelNode)
        
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
        logoNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.74)
        logoNode.name = "logo"
        //        logoNode.run(endlessAction3) für Logo eine eigene Action erstellen
        
        addChild(logoNode)
    }
    
    func addMusicButton() {
        
        let musicButton = SKLabelNode()
        
        musicButton.name = "musicButton"
        musicButton.fontName = "LCD14"
        musicButton.fontSize = 45
        musicButton.fontColor = UIColor(hexFromString: "0099ff")
        
        if backgroundMusicPlayerStatus == false {
            musicButton.text = "MUSIC: OFF "
            musicButton.fontSize = 25
            musicButton.fontColor = UIColor.red
            musicButton.position = CGPoint(x: Screen.width / 2, y: 50)
            musicButton.alpha = 1
            musicButton.removeAllChildren()
            musicButton.addGlow(radius: 7)
            musicButton.children.first?.position = CGPoint(x: 0, y: musicButton.frame.size.height / 2)
            self.addChild(musicButton)
            backgroundMusicPlayer?.stop()
            return
        } else {
            musicButton.text = "MUSIC: ON "
            musicButton.fontSize = 25
            musicButton.fontColor = UIColor.green
            musicButton.position = CGPoint(x: Screen.width / 2, y: 50)
            musicButton.alpha = 1
            musicButton.removeAllChildren()
            musicButton.addGlow(radius: 7)
            musicButton.children.first?.position = CGPoint(x: 0, y: musicButton.frame.size.height / 2)
            self.addChild(musicButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                backgroundMusicPlayer?.play()
            }
            return
        }
    }
    
    func addTextField() {
        
        let textFieldFrame = CGRect(origin: CGPoint(x: Screen.width * 0.1, y: Screen.height * 0.4), size: CGSize(width: Screen.width * 0.8, height: 40))
        
        newNameTextField = UITextField(frame: textFieldFrame)
        self.view!.addSubview(newNameTextField)
        self.view!.tintColor = .green
        newNameTextField.delegate = self
        newNameTextField.backgroundColor = .clear
        newNameTextField.textAlignment = .center
        newNameTextField.adjustsFontSizeToFitWidth = true
        newNameTextField.borderStyle = .none
        newNameTextField.textColor = .green
        newNameTextField.font = UIFont.init(name: "LCD14", size: 40)
        newNameTextField.tag = 3
        newNameTextField.autocapitalizationType = .allCharacters
        self.view?.addSubview(newNameTextField)
        newNameTextField.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == newNameTextField && textField.text != "" {
            childNode(withName: "readyLabelNode")?.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == newNameTextField && textField.text != "" {
//            print("RETURN \(String(describing: textField.text))")
            self.view?.endEditing(true)
            
            let addPlayerButton = self.childNode(withName: "addPlayerButton")
            let nameLabelNode = addPlayerButton!.childNode(withName: "newPlayerLabelNode") as! SKLabelNode
            nameLabelNode.removeAllChildren()
            nameLabelNode.text = textField.text
            nameLabelNode.addGlow(radius: 7)
            nameLabelNode.children.first?.position = CGPoint(x: 0, y: nameLabelNode.frame.size.height / 2)
            addPlayerButton!.isHidden = false
            addPlayerButton!.isUserInteractionEnabled = false
            textField.isHidden = true
            askIfReady()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == newNameTextField && textField.text != "" {
            newNameTextField.text = newNameTextField.text!.replacingOccurrences(of: " ", with: "")
            childNode(withName: "readyLabelNode")?.isHidden = false
        }
    }
    
    func askIfReady() {
        
        self.childNode(withName: "pleaseLabelNode")?.isHidden = true
        
        if childNode(withName: "readyLabelNode") == nil {
            let readyLabelNode = SKLabelNode(text: "SAVE THIS PLAYER?")
            readyLabelNode.name = "readyLabelNode"
            readyLabelNode.preferredMaxLayoutWidth = Screen.width * 0.8
            readyLabelNode.fontColor = UIColor.green
            readyLabelNode.fontName = "LCD14"
            readyLabelNode.fontSize = 26
            readyLabelNode.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.45)
            readyLabelNode.alpha = 1
            readyLabelNode.removeAllChildren()
            readyLabelNode.addGlow(radius: 7)
            readyLabelNode.children.first?.position = CGPoint(x: 0, y: readyLabelNode.frame.size.height / 2)
            self.addChild(readyLabelNode)
            
            let yesButton = SKLabelNode(text: "YES")
            yesButton.name = "yesButtonNode"
            yesButton.fontColor = UIColor.green
            yesButton.fontName = "LCD14"
            yesButton.fontSize = 40
            yesButton.position = CGPoint(x: (Screen.width / 3) - (yesButton.frame.size.width / 2), y: Screen.height * 0.3)
            yesButton.alpha = 1
            yesButton.removeAllChildren()
            yesButton.addGlow(radius: 7)
            yesButton.children.first?.position = CGPoint(x: 0, y: yesButton.frame.size.height / 2)
            addChild(yesButton)
            
            let placeholder = SKLabelNode(text: "/")
            placeholder.fontColor = UIColor.green
            placeholder.fontName = "LCD14"
            placeholder.fontSize = 40
            placeholder.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.3)
            placeholder.alpha = 1
            placeholder.removeAllChildren()
            placeholder.addGlow(radius: 7)
            placeholder.children.first?.position = CGPoint(x: 0, y: yesButton.frame.size.height / 2)
            addChild(placeholder)
            
            let noButton = SKLabelNode(text: "NO")
            noButton.name = "noButtonNode"
            noButton.fontColor = UIColor.green
            noButton.fontName = "LCD14"
            noButton.fontSize = 40
            noButton.position = CGPoint(x: ((Screen.width / 3) * 2) + (noButton.frame.size.width / 2), y: Screen.height * 0.3)
            noButton.alpha = 1
            noButton.removeAllChildren()
            noButton.addGlow(radius: 7)
            noButton.children.first?.position = CGPoint(x: 0, y: noButton.frame.size.height / 2)
            addChild(noButton)
        }
        
    }
    
    func savePlayer() {
        
        UserDefaults.standard.set(String(describing: newNameTextField.text!), forKey: "playerName")
        
        print("SAVED PLAYER = \(String(describing: newNameTextField.text!))")
        
        UserDefaults.standard.set(true, forKey: "launchedBefore")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == touches.first {
                
                if self.childNode(withName: "musicButton") != nil && self.childNode(withName: "musicButton")!.contains(touch.location(in: self)) {
                    
                    generator.impactOccurred()
                    
                    if backgroundMusicPlayerStatus == true {
                        
                        backgroundMusicPlayer?.stop()
                        let button = self.childNode(withName: "musicButton") as! SKLabelNode
                        button.text = "MUSIC: OFF "
                        button.fontColor = UIColor.red
                        button.removeAllChildren()
                        button.addGlow(radius: 7)
                        button.children.first?.position = CGPoint(x: 0, y: button.frame.size.height / 2)
                        backgroundMusicPlayerStatus = false
                        UserDefaults.standard.set(false, forKey: "backgroundMusicPlayerStatus")
                        
                    } else {
                        
                        backgroundMusicPlayer?.play()
                        let button = self.childNode(withName: "musicButton") as! SKLabelNode
                        button.text = "MUSIC: ON "
                        button.fontColor = UIColor.green
                        button.removeAllChildren()
                        button.addGlow(radius: 7)
                        button.children.first?.position = CGPoint(x: 0, y: button.frame.size.height / 2)
                        backgroundMusicPlayerStatus = true
                        UserDefaults.standard.set(true, forKey: "backgroundMusicPlayerStatus")
                        
                    }
                    
                } else if self.childNode(withName: "addPlayerButton") != nil && self.childNode(withName: "addPlayerButton")?.isHidden == false && self.childNode(withName: "addPlayerButton")!.contains(touch.location(in: self)) {
                    print("ADD NEW PLAYER")
                    
                    self.childNode(withName: "addPlayerButton")?.isHidden = true
                    self.childNode(withName: "addPlayerButton")?.isUserInteractionEnabled = true
                    
                    
                    newNameTextField.isHidden = false
                    newNameTextField.becomeFirstResponder()
                    
                    generator.impactOccurred()
                    
                } else if self.childNode(withName: "yesButtonNode") != nil && self.childNode(withName: "yesButtonNode")!.contains(touch.location(in: self)) {
                    print("SAVE PLAYER")
                    savePlayer()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.removeAllChildren()
                        self.removeAllActions()
                        SceneManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.fade(withDuration: 0.5))
                    })
                    generator.impactOccurred()
                    
                } else if self.childNode(withName: "noButtonNode") != nil && self.childNode(withName: "noButtonNode")!.contains(touch.location(in: self)) {
                    print("EDIT PLAYER")
                    
                    newNameTextField.isHidden = false
                    newNameTextField.becomeFirstResponder()
                    
                    self.childNode(withName: "addPlayerButton")?.isHidden = true
                    self.childNode(withName: "addPlayerButton")?.isUserInteractionEnabled = true
                    
                    generator.impactOccurred()
                }
                
            }
            
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}

