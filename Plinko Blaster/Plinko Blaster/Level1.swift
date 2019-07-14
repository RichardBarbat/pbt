//
//  Level1.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 15.03.19.
//  Copyright © 2019 me. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation


// MARK: Struct für physicsBodys

struct ColliderType {
    static let Ball: UInt32 = 1
    static let NonBall: UInt32 = 5
    static let Invisible: UInt32 = 10
    static let Scene: UInt32 = 30
}


// MARK: - Variablen außerhalb der Klasse

var pointsCount = 0 
let pointsLabelNode = SKLabelNode()
var highscoreLabelNode = SKLabelNode()
var miniMenu = SKShapeNode()
var vibrationOn = UserDefaults.standard.bool(forKey: "vibrationOn")
var fxOn = UserDefaults.standard.bool(forKey: "fxOn")
var scaleActionSequence = SKAction.sequence([])
var pulseActionSequence = SKAction.sequence([])
var rotateActionSequence = SKAction.sequence([])
var scalePlusPointsActionSequence = SKAction.sequence([])
var highscoreLabelIsInFront = false
var lastHighscore = Int()

let generator = UIImpactFeedbackGenerator(style: .medium)

var gameOver = false

// MARK: - Beginn der Klasse

class Level1: SKScene, SKPhysicsContactDelegate {
    
    
    // MARK: - Variablen & Instanzen
    
    var ballCounterNode = SKShapeNode()
    var menuOpen = false
    let starFieldNode = SKShapeNode()
    let settingsButtonNode = SKSpriteNode(imageNamed: "settings-button4")
    let backButtonNode = SKSpriteNode(imageNamed: "back-button3")
    var starNode = SKSpriteNode(imageNamed: "star.png")
    var ballCounterLabelNode = SKLabelNode()
    var boxes = [SKShapeNode()]
    var multipliers = [Int()]
    var ballsAdded = [SKShapeNode]()
    var ball = SKShapeNode()
    var ballCount = 5
    var boxesCollected = [false, false, false, false, false, false]
    var ballsDown = [false, false, false, false, false]
    var controlBallBool = false
    let scaleUpAction = SKAction.scale(to: 2, duration: 0.1)
    let smallScaleUpAction = SKAction.scale(to: 1.1, duration: 0.1)
    let fadeUpAction = SKAction.fadeAlpha(to: 0.75, duration: 1)
    let scaleDownAction = SKAction.scale(to: 1, duration: 0.6)
    let smallScaleDownAction = SKAction.scale(to: 1, duration: 0.1)
    let fadeDownAction = SKAction.fadeAlpha(to: 0, duration: 1)
    let rotateLeftAction = SKAction.rotate(toAngle: .pi / 15, duration: 1)
    let rotateRightAction = SKAction.rotate(toAngle: .pi / -15, duration: 1)
    let wait = SKAction.wait(forDuration: 1)
    let playerName = UserDefaults.standard.string(forKey: "playerName")
    var totalBallsDropped = 0
    var totalPointsCollected = 0
    
    
    // MARK: - Beginn der Funktionen
    
    override func didMove(to view: SKView) {
        
        print("- Level 1 -")
        
        self.backgroundColor = UIColor(hexFromString: "120d27")
        
        highscoreLabelIsInFront = false
        
        vibrationOn = UserDefaults.standard.bool(forKey: "vibrationOn")
        
        ballCounterNode = SKShapeNode(circleOfRadius: ScreenSize.width * 0.035)
        
        scaleActionSequence = SKAction.sequence([smallScaleUpAction, smallScaleDownAction])
        
        pulseActionSequence = SKAction.sequence([fadeDownAction, wait, fadeUpAction])
        
        rotateActionSequence = SKAction.sequence([rotateLeftAction, rotateRightAction])
        
        scalePlusPointsActionSequence = SKAction.sequence([addPoints, scaleUpAction, scaleDownAction])
        
        print("PLAYER = \(String(describing: playerName!))")
        
        lastHighscore = UserDefaults.standard.integer(forKey: "highscore")
        
        print("LAST HIGHSCORE = \(String(describing: lastHighscore))")
        
        if gameOver == false {
            
            addPlayerName(animated: true)
            
            addHighscoreLableNode(delayed: true)
            
            addBallCounterNode(delayed: true)
            
            addPointsLabelNode(delayed: true)
            
        } else {
            
            addPlayerName()
            
            addHighscoreLableNode()
            
            addBallCounterNode()
            
            addPointsLabelNode()
            
            gameOver = false
            
        }
        
        addStarFieldNode()
        
        addBackButtonNode()
        
        addSettingsButtonNode()
        
        addStartGlowLine()
        
        addBoxes(count: 5)
        
        addObstacles()
        
        addSideLines()
        
        addDownArrows(count: 7)
        
        prepareMiniMenu()
        
        prepareBall()
        
        addStar()
        
        if menuOpen == true {
            closeMenu()
        }
        
        let sceneEdgeLoop = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.scene!.physicsBody = sceneEdgeLoop
        self.scene?.physicsBody?.friction = 500
        self.scene!.anchorPoint = CGPoint(x: 0, y: 0)
        self.scene!.physicsBody!.contactTestBitMask = ColliderType.Scene
        self.scene!.physicsBody!.collisionBitMask = ColliderType.Ball | ColliderType.NonBall | ColliderType.Scene
        self.scene!.physicsBody!.categoryBitMask = ColliderType.Ball
        
        physicsWorld.contactDelegate = self
        
    }
    
    func addPlayerName(animated: Bool = false) {

        let hiLabelNode = SKLabelNode(text: "PLAYER: \(playerName ?? "???")")
        hiLabelNode.name = "playerNameLabelNode"
        hiLabelNode.fontSize = 30
        hiLabelNode.alpha = 1
        hiLabelNode.fontName = "LCD14"
        hiLabelNode.horizontalAlignmentMode = .center
        hiLabelNode.preferredMaxLayoutWidth = ScreenSize.width * 0.7
        hiLabelNode.fontColor = .green
        hiLabelNode.position = CGPoint(x: (ScreenSize.width * 0.5), y: ScreenSize.height * 0.88)
        hiLabelNode.addGlow(radius: 2)
        hiLabelNode.isHidden = true
        addChild(hiLabelNode)

        if animated == true {

            hiLabelNode.isHidden = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {

                let nameScaleDownAction = SKAction.scale(to: 0.4, duration: 0.5)
                let nameMoveUpAction = SKAction.move(to: CGPoint(x: (ScreenSize.width * 0.5), y: ScreenSize.height * 0.935), duration: 0.5)

                hiLabelNode.run(nameScaleDownAction)
                hiLabelNode.run(nameMoveUpAction)

            })
        } else {

            let nameScaleDownAction = SKAction.scale(to: 0.4, duration: 0)
            let nameMoveUpAction = SKAction.move(to: CGPoint(x: (ScreenSize.width * 0.5), y: ScreenSize.height * 0.935), duration: 0)

            hiLabelNode.run(nameScaleDownAction)
            hiLabelNode.run(nameMoveUpAction)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {

                hiLabelNode.isHidden = false

            })

        }

    }
    
    func prepareMiniMenu() {
        
        miniMenu = SKShapeNode(rect: CGRect(x: ScreenSize.width * 0.05, y: ScreenSize.height * 0.825, width: ScreenSize.width * 0.9, height: ScreenSize.height * 0.09), cornerRadius: 8)
        miniMenu.strokeColor = UIColor(hexFromString: "0099ff")
        miniMenu.glowWidth = 3
        
        let miniMenuGlow = miniMenu.copy() as! SKShapeNode
        miniMenuGlow.glowWidth = 30
        miniMenuGlow.lineWidth = 1
        miniMenuGlow.alpha = 0.5
        
        let miniMenuBackground = miniMenu.copy() as! SKShapeNode
        miniMenuBackground.fillColor = UIColor(hexFromString: "120d27")
        miniMenuBackground.glowWidth = 0
        miniMenuBackground.lineWidth = 1
        miniMenuBackground.alpha = 1
        
        let buttonBackgroundMusic = SKSpriteNode()
        if backgroundMusicPlayerStatus == true {
            buttonBackgroundMusic.texture = SKTexture(imageNamed: "music-button-on5")
        } else {
            buttonBackgroundMusic.texture = SKTexture(imageNamed: "music-button-off5")
        }
        buttonBackgroundMusic.name = "musicButton"
        buttonBackgroundMusic.size = CGSize(width: miniMenuBackground.frame.size.height, height: miniMenuBackground.frame.size.height)
        buttonBackgroundMusic.position = CGPoint(x: ((ScreenSize.width * 0.9) / 3) * 0.75, y: ScreenSize.height * 0.87)
        buttonBackgroundMusic.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        var buttonFX = SKSpriteNode()
        if fxOn == true {
            buttonFX = SKSpriteNode(imageNamed: "fx-button-on")
        } else {
            buttonFX = SKSpriteNode(imageNamed: "fx-button-off")
        }
        
        buttonFX.name = "fxButton"
        buttonFX.size = CGSize(width: miniMenuBackground.frame.size.height, height: miniMenuBackground.frame.size.height)
        buttonFX.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.87)
        buttonFX.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        var buttonVibration = SKSpriteNode()
        if vibrationOn == true {
            buttonVibration = SKSpriteNode(imageNamed: "vibration-button-on")
        } else {
            buttonVibration = SKSpriteNode(imageNamed: "vibration-button-off")
        }
        buttonVibration.name = "vibrationButton"
        buttonVibration.size = CGSize(width: miniMenuBackground.frame.size.height, height: miniMenuBackground.frame.size.height)
        buttonVibration.position = CGPoint(x: ((ScreenSize.width * 0.9) / 3) * 2.6, y: ScreenSize.height * 0.87)
        buttonVibration.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        miniMenu.addChild(miniMenuGlow)
        miniMenu.addChild(miniMenuBackground)
        miniMenu.addChild(buttonBackgroundMusic)
        miniMenu.addChild(buttonFX)
        miniMenu.addChild(buttonVibration)
        miniMenu.isHidden = true
        miniMenu.isUserInteractionEnabled = false
        addChild(miniMenu)
    }
    
    func addStarFieldNode() {
        
        let fieldNode = SKNode()
        
        for _ in 0...350 {
            
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.05...0.15))
            star.fillColor = .white
            star.glowWidth = CGFloat.random(in: 0.01...0.8)
            star.alpha = CGFloat.random(in: 0.05...0.2)
            
            star.position = CGPoint(x: CGFloat.random(in: 0...ScreenSize.width), y: CGFloat.random(in: 0...ScreenSize.height))
            fieldNode.addChild(star)
        }
        
        let fieldNodeSpriteNode = SKSpriteNode(texture: SKView().texture(from: fieldNode))
        fieldNodeSpriteNode.anchorPoint = .init(x: 0, y: 1)
        fieldNodeSpriteNode.position = CGPoint(x: 0, y: ScreenSize.height)
        fieldNodeSpriteNode.zPosition = -1000
        addChild(fieldNodeSpriteNode)
        
        
        
    }
    
    func addShootingStar() {
        
        
//        let moveAction = SKAction.moveBy(x: 0, y: 10, duration: 0.5)
        
        let shootingStar = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.25...0.35))
        shootingStar.fillColor = .white
        shootingStar.glowWidth = CGFloat.random(in: 0.4...0.8)
        shootingStar.alpha = CGFloat.random(in: 0.5...0.6)
        
        //        shootingStar.position = CGPoint(x: CGFloat.random(in: 0...ScreenSize.width), y: CGFloat.random(in: 0...ScreenSize.height))
        shootingStar.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height * 0.7)
        
        addChild(shootingStar)
    }
    
    func addPointsLabelNode(delayed: Bool = false) {
        
        pointsCount = 0
        pointsLabelNode.text = String("POINTS:0")
        pointsLabelNode.fontSize = 28
        pointsLabelNode.alpha = 1
        pointsLabelNode.fontName = "LCD14"
        pointsLabelNode.horizontalAlignmentMode = .center
        pointsLabelNode.preferredMaxLayoutWidth = ScreenSize.width * 0.7
        pointsLabelNode.fontColor = UIColor(hexFromString: "0099ff")
        pointsLabelNode.position = CGPoint(x: (ScreenSize.width * 0.5) + (pointsLabelNode.frame.size.width * 0), y: ScreenSize.height * 0.89)
        
        if delayed == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.addChild(pointsLabelNode)
            })
        } else {
            self.addChild(pointsLabelNode)
        }
        
        
        
        
    }
    
    func addBackButtonNode() {
        
        let backButtonAspectRatio = backButtonNode.size.width/backButtonNode.size.height
        if DeviceType.isiPad || DeviceType.isiPadPro {
            backButtonNode.size = CGSize(width: ScreenSize.width * 0.08, height: ScreenSize.width * 0.08 / backButtonAspectRatio)
        } else {
            //            print("is not iPad")
            backButtonNode.size = CGSize(width: ScreenSize.width * 0.1, height: ScreenSize.width * 0.1 / backButtonAspectRatio)
        }
        backButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backButtonNode.position = CGPoint(x: ScreenSize.width * 0.1, y: ScreenSize.height * 0.95)
        backButtonNode.alpha = 1
        addChild(backButtonNode)
    }
    
    func addSettingsButtonNode() {
        
        let settingsButtonAspectRatio = settingsButtonNode.size.width/settingsButtonNode.size.height
        if DeviceType.isiPad || DeviceType.isiPadPro {
            settingsButtonNode.size = CGSize(width: ScreenSize.width * 0.08, height: ScreenSize.width * 0.08 / settingsButtonAspectRatio)
        } else {
            //            print("is not iPad")
            settingsButtonNode.size = CGSize(width: ScreenSize.width * 0.19, height: ScreenSize.width * 0.19 / settingsButtonAspectRatio)
        }
        settingsButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        settingsButtonNode.position = CGPoint(x: ScreenSize.width * 0.9, y: ScreenSize.height * 0.95)
        settingsButtonNode.alpha = 0.8
        addChild(settingsButtonNode)
    }
    
    func addBallCounterNode(delayed: Bool = false) {
        
        ballCounterNode.position = CGPoint(x: ScreenSize.width * 0.08, y: ScreenSize.height * 0.84)
        ballCounterNode.physicsBody?.isDynamic = false
        ballCounterNode.setScale(0.5)
        ballCounterNode.name = "ballCounterNode"
        
        ballCounterNode.lineWidth = 3
        ballCounterNode.strokeColor = UIColor(hexFromString: "edff25")
        ballCounterNode.glowWidth = 0
        
        let ballCounterNodeGlow = SKShapeNode(circleOfRadius: ballCounterNode.frame.size.width * 0.8)
        ballCounterNodeGlow.strokeColor = UIColor(hexFromString: "edff25").withAlphaComponent(0.6)
        ballCounterNodeGlow.lineWidth = 0.1
        ballCounterNodeGlow.glowWidth = 10
        
        ballCounterLabelNode = SKLabelNode(text: "X\(ballCount)")
        ballCounterLabelNode.fontName = "LCD14"
        ballCounterLabelNode.position = CGPoint(x: ballCounterLabelNode.position.x + ballCounterNodeGlow.frame.size.width, y: (ballCounterLabelNode.position.y) - (ballCounterLabelNode.frame.size.height / 2))
        ballCounterLabelNode.fontColor = UIColor(hexFromString: "edff25")
        
        ballCounterNode.addChild(ballCounterLabelNode)
        ballCounterNode.addChild(ballCounterNodeGlow)
        
        if delayed == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.addChild(self.ballCounterNode)
            })
        } else {
            self.addChild(self.ballCounterNode)
        }
        
        
    }
    
    func addStartGlowLine() {
        
        let startGlowLinePath = CGMutablePath()
        startGlowLinePath.move(to: CGPoint(x: -50, y: ScreenSize.height * 0.78))
        startGlowLinePath.addLine(to: CGPoint(x: ScreenSize.width + 50, y: ScreenSize.height * 0.78))
        let startGlowLineNode = SKShapeNode()
        startGlowLineNode.path = startGlowLinePath
        startGlowLineNode.strokeColor = UIColor(hexFromString: "d800ff")
        startGlowLineNode.lineWidth = 0.1
        startGlowLineNode.glowWidth = 40
        startGlowLineNode.alpha = 0.35
        startGlowLineNode.blendMode = .add
        
        let startGlowLinePath2 = CGMutablePath()
        startGlowLinePath2.move(to: CGPoint(x: -50, y: ScreenSize.height * 0.78))
        startGlowLinePath2.addLine(to: CGPoint(x: ScreenSize.width + 50, y: ScreenSize.height * 0.78))
        let startGlowLineNode2 = SKShapeNode()
        startGlowLineNode2.path = startGlowLinePath2
        startGlowLineNode2.strokeColor = UIColor(hexFromString: "d800ff")
        startGlowLineNode2.lineWidth = 3.5
        startGlowLineNode2.glowWidth = 0
        startGlowLineNode2.alpha = 1
        startGlowLineNode2.blendMode = .add
        startGlowLineNode.addChild(startGlowLineNode2)
        
        let startGlowLineSpriteNode = SKSpriteNode(texture: SKView().texture(from: startGlowLineNode))
        startGlowLineSpriteNode.position = CGPoint(x: -50, y: ScreenSize.height * 0.78)
        startGlowLineSpriteNode.anchorPoint = .init(x: 0, y: 0.5)
        addChild(startGlowLineSpriteNode)
    }
    
    func addObstacles() {
        
        for doubleRow in 0...3 {
            
            for number in 1...7 {
                
                let obstacleNode = SKShapeNode(circleOfRadius: ScreenSize.width * 0.015)
                obstacleNode.strokeColor = UIColor(hexFromString: "0099ff")
                obstacleNode.lineWidth = 3
                obstacleNode.position = CGPoint(x: ScreenSize.width / 8 * CGFloat(number), y: ScreenSize.height * (0.65 - CGFloat(CGFloat(doubleRow) / 7)))
                
                obstacleNode.physicsBody = SKPhysicsBody(edgeLoopFrom: obstacleNode.path!)
                obstacleNode.physicsBody?.isDynamic = false
                obstacleNode.physicsBody?.friction = 0
                obstacleNode.physicsBody?.restitution = 1
                obstacleNode.physicsBody?.categoryBitMask = ColliderType.NonBall
                obstacleNode.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.NonBall
                obstacleNode.physicsBody?.contactTestBitMask = ColliderType.NonBall
                obstacleNode.name = "obstacle\(doubleRow)-\(number)"
//                print("obstacle\(doubleRow)-\(number)")
                
                let glowNode = SKShapeNode(circleOfRadius: obstacleNode.frame.size.width / 2)
                glowNode.glowWidth = 7
                glowNode.alpha = 0.7
                glowNode.strokeColor = UIColor(hexFromString: "d800ff")
                let glowSpriteNode = SKSpriteNode(texture: SKView().texture(from: glowNode))
                glowSpriteNode.name = "obstacleGlow"
                glowSpriteNode.zPosition = obstacleNode.zPosition - 1
                
                obstacleNode.addChild(glowSpriteNode)
                
                addChild(obstacleNode)
                
            }
            
            if doubleRow <= 2 {
                
                for number in 2...7 {
                    
                    let obstacleNode = SKShapeNode(circleOfRadius: ScreenSize.width * 0.015)
                    obstacleNode.strokeColor = UIColor(hexFromString: "0099ff")
                    obstacleNode.lineWidth = 3
                    obstacleNode.position = CGPoint(x: (ScreenSize.width / 8) * (CGFloat(number) - 0.5), y: ScreenSize.height * (0.58 - CGFloat(CGFloat(doubleRow) / 7)))
                    
                    obstacleNode.physicsBody = SKPhysicsBody(edgeLoopFrom: obstacleNode.path!)
                    obstacleNode.physicsBody?.isDynamic = false
                    obstacleNode.physicsBody?.friction = 0
                    obstacleNode.physicsBody?.restitution = 1
                    obstacleNode.physicsBody?.categoryBitMask = ColliderType.NonBall
                    obstacleNode.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.NonBall
                    obstacleNode.physicsBody?.contactTestBitMask = ColliderType.NonBall
                    obstacleNode.name = "obstacle\(doubleRow)-\(number + 8)"
//                    print("obstacle\(doubleRow)-\(number + 8)")
                    
                    let glowNode = SKShapeNode(circleOfRadius: obstacleNode.frame.size.width / 2)
                    glowNode.glowWidth = 7
                    glowNode.alpha = 0.7
                    glowNode.strokeColor = UIColor(hexFromString: "d800ff")
                    let glowSpriteNode = SKSpriteNode(texture: SKView().texture(from: glowNode))
                    glowSpriteNode.name = "obstacleGlow"
                    glowSpriteNode.zPosition = obstacleNode.zPosition - 1
                    
                    obstacleNode.addChild(glowSpriteNode)
                    
                    addChild(obstacleNode)
                    
                }
            }
        }
    }
    
    func addBoxes(count: Int) {
        
        let holeWidth = ScreenSize.width / CGFloat(count)
        
        for boxNumber in 1...count {
            
            let box = SKShapeNode(rectOf: CGSize(width: holeWidth, height: ScreenSize.height * 0.1))
            box.position = CGPoint(x: holeWidth * (CGFloat(boxNumber) - 0.5), y: ScreenSize.height * 0.05)
            box.fillColor = UIColor(hexFromString: "0099ff").withAlphaComponent(0.3)
            box.strokeColor = UIColor(hexFromString: "d800ff").withAlphaComponent(0.5)
            box.glowWidth = 5
            box.lineWidth = 0.1
            box.zPosition = ball.zPosition + 10
            box.name = "box\(boxNumber)"
            box.physicsBody?.isDynamic = false
            box.physicsBody?.categoryBitMask = ColliderType.Invisible
            box.physicsBody?.collisionBitMask = ColliderType.Ball
            box.physicsBody?.contactTestBitMask = ColliderType.Invisible | ColliderType.Ball
            
            addChild(box)
            
            boxes.append(box)
            
            
//            let randomMultiplier = Int.random(in: 1...5)
//            print("randomMultiplier = \(randomMultiplier)")
//            multipliers.append(randomMultiplier)
            
            multipliers = [2,3,5,3,2]
            
            let multiplierLabelNode = SKLabelNode(text: "X\(multipliers[boxNumber-1])")
            
            multiplierLabelNode.fontName = "LCD14"
            multiplierLabelNode.fontSize = 26
            multiplierLabelNode.fontColor = UIColor(hexFromString: "d800ff")
            
            box.addChild(multiplierLabelNode)

            
        }
        
        for line in 1...count - 1 {
            
            let linePath = CGMutablePath()
            linePath.move(to: CGPoint(x: holeWidth * CGFloat(line), y: 0))
            linePath.addLine(to: CGPoint(x: holeWidth * CGFloat(line), y: ScreenSize.height * 0.1))
            let lineNode = SKShapeNode(path: linePath)
            lineNode.name = "line\(line)"
            lineNode.strokeColor = UIColor(hexFromString: "d800ff")
            lineNode.lineCap = .round
            lineNode.lineWidth = 6
            lineNode.glowWidth = 0
            lineNode.zPosition = ball.zPosition + 20
            lineNode.physicsBody = SKPhysicsBody(edgeLoopFrom: linePath)
            lineNode.physicsBody?.isDynamic = false
            lineNode.physicsBody?.categoryBitMask = ColliderType.NonBall
            lineNode.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.NonBall
            lineNode.physicsBody?.contactTestBitMask = ColliderType.NonBall
            
            let lineGlow = lineNode.copy() as! SKShapeNode
            lineGlow.strokeColor = UIColor(hexFromString: "d800ff")
            lineGlow.lineWidth = 1
            lineGlow.glowWidth = 16
            lineGlow.alpha = 0.4
            
            let lineGlowSpriteNode = SKSpriteNode(texture: SKView().texture(from: lineGlow))
            lineGlowSpriteNode.position = CGPoint(x: holeWidth * CGFloat(line), y: 0 - 18)
            lineGlowSpriteNode.anchorPoint = .init(x: 0.5, y: 0)
            
            lineNode.addChild(lineGlowSpriteNode)
            
            addChild(lineNode)
        }
        
        let bottomLinePath = CGMutablePath()
        bottomLinePath.move(to: CGPoint(x: 0, y: 0))
        bottomLinePath.addLine(to: CGPoint(x: ScreenSize.width, y: 0))
        let bottomLineNode = SKShapeNode(path: bottomLinePath)
        bottomLineNode.name = "bottomLine"
        bottomLineNode.strokeColor = UIColor(hexFromString: "d800ff")
        bottomLineNode.lineWidth = 1
        bottomLineNode.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomLinePath)
        bottomLineNode.physicsBody?.isDynamic = false
        bottomLineNode.physicsBody?.categoryBitMask = ColliderType.NonBall
        bottomLineNode.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.NonBall
        bottomLineNode.physicsBody?.contactTestBitMask = ColliderType.NonBall
        addChild(bottomLineNode)
    }
    
    func addSideLines() {
        
        let sideLineLeftPath = CGMutablePath()
        sideLineLeftPath.move(to: CGPoint(x: 0, y: (self.childNode(withName: "obstacle0-1")?.position.y)!))
        sideLineLeftPath.addLine(to: CGPoint(x: ScreenSize.width * 0.05, y: (self.childNode(withName: "obstacle0-10")?.position.y)!))
        sideLineLeftPath.addLine(to: CGPoint(x: 0, y: (self.childNode(withName: "obstacle1-1")?.position.y)!))
        sideLineLeftPath.addLine(to: CGPoint(x: ScreenSize.width * 0.05, y: (self.childNode(withName: "obstacle1-10")?.position.y)!))
        sideLineLeftPath.addLine(to: CGPoint(x: 0, y: (self.childNode(withName: "obstacle2-1")?.position.y)!))
        sideLineLeftPath.addLine(to: CGPoint(x: ScreenSize.width * 0.05, y: (self.childNode(withName: "obstacle2-10")?.position.y)!))
        sideLineLeftPath.addLine(to: CGPoint(x: 0, y: (self.childNode(withName: "obstacle3-1")?.position.y)!))
        
        let sideLineLeftNode = SKShapeNode(path: sideLineLeftPath)
        sideLineLeftNode.name = "sideLineLeftNode"
        sideLineLeftNode.strokeColor = UIColor(hexFromString: "d800ff")
        sideLineLeftNode.fillColor = UIColor(hexFromString: "d800ff").withAlphaComponent(0.25)
        sideLineLeftNode.lineWidth = 5
        sideLineLeftNode.alpha = 0.6
        sideLineLeftNode.lineCap = .round
        sideLineLeftNode.physicsBody = SKPhysicsBody(edgeLoopFrom: sideLineLeftPath)
        sideLineLeftNode.physicsBody?.isDynamic = false
        sideLineLeftNode.physicsBody?.friction = 0
        sideLineLeftNode.physicsBody?.restitution = 1
        sideLineLeftNode.physicsBody?.categoryBitMask = ColliderType.NonBall
        sideLineLeftNode.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.NonBall
        sideLineLeftNode.physicsBody?.contactTestBitMask = ColliderType.NonBall
        
        let sideLineLeftNodeGlow = SKShapeNode(path: sideLineLeftPath)
        sideLineLeftNodeGlow.strokeColor = UIColor(hexFromString: "d800ff")
        sideLineLeftNodeGlow.lineWidth = 0.1
        sideLineLeftNodeGlow.glowWidth = 10
        sideLineLeftNodeGlow.alpha = 0.4
        sideLineLeftNodeGlow.lineCap = .round
        
        let sideLineLeftSpriteNodeGlow = SKSpriteNode(texture: SKView().texture(from: sideLineLeftNodeGlow))
        sideLineLeftSpriteNodeGlow.zPosition = sideLineLeftNode.zPosition - 1
        sideLineLeftSpriteNodeGlow.anchorPoint = CGPoint(x: 0, y: 0)
        sideLineLeftSpriteNodeGlow.position = CGPoint(x: -10, y: (self.childNode(withName: "obstacle3-1")?.position.y)! - 12)
        
        
        sideLineLeftNode.addChild(sideLineLeftSpriteNodeGlow)
        addChild(sideLineLeftNode)
        
        
        
        let sideLineRightPath = CGMutablePath()
        sideLineRightPath.move(to: CGPoint(x: ScreenSize.width, y: (self.childNode(withName: "obstacle0-1")?.position.y)!))
        sideLineRightPath.addLine(to: CGPoint(x: (ScreenSize.width * 0.95), y: (self.childNode(withName: "obstacle0-10")?.position.y)!))
        sideLineRightPath.addLine(to: CGPoint(x: ScreenSize.width, y: (self.childNode(withName: "obstacle1-1")?.position.y)!))
        sideLineRightPath.addLine(to: CGPoint(x: (ScreenSize.width * 0.95), y: (self.childNode(withName: "obstacle1-10")?.position.y)!))
        sideLineRightPath.addLine(to: CGPoint(x: ScreenSize.width, y: (self.childNode(withName: "obstacle2-1")?.position.y)!))
        sideLineRightPath.addLine(to: CGPoint(x: (ScreenSize.width * 0.95), y: (self.childNode(withName: "obstacle2-10")?.position.y)!))
        sideLineRightPath.addLine(to: CGPoint(x: ScreenSize.width, y: (self.childNode(withName: "obstacle3-1")?.position.y)!))
        
        let sideLineRightNode = SKShapeNode(path: sideLineRightPath)
        sideLineRightNode.name = "sideLineRightNode"
        sideLineRightNode.strokeColor = UIColor(hexFromString: "d800ff")
        sideLineRightNode.fillColor = UIColor(hexFromString: "d800ff").withAlphaComponent(0.25)
        sideLineRightNode.lineWidth = 5
        sideLineRightNode.alpha = 0.6
        sideLineRightNode.lineCap = .round
        sideLineRightNode.physicsBody = SKPhysicsBody(edgeLoopFrom: sideLineRightPath)
        sideLineRightNode.physicsBody?.isDynamic = false
        sideLineRightNode.physicsBody?.friction = 0
        sideLineRightNode.physicsBody?.restitution = 1
        sideLineRightNode.physicsBody?.categoryBitMask = ColliderType.NonBall
        sideLineRightNode.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.NonBall
        sideLineRightNode.physicsBody?.contactTestBitMask = ColliderType.NonBall
        
        let sideLineRightNodeGlow = SKShapeNode(path: sideLineRightPath)
        sideLineRightNodeGlow.strokeColor = UIColor(hexFromString: "d800ff")
        sideLineRightNodeGlow.lineWidth = 0.1
        sideLineRightNodeGlow.glowWidth = 10
        sideLineRightNodeGlow.alpha = 0.4
        sideLineRightNodeGlow.lineCap = .round
        
        let sideLineRightSpriteNodeGlow = SKSpriteNode(texture: SKView().texture(from: sideLineRightNodeGlow))
        sideLineRightSpriteNodeGlow.zPosition = sideLineRightNode.zPosition - 1
        sideLineRightSpriteNodeGlow.anchorPoint = CGPoint(x: 1, y: 0)
        sideLineRightSpriteNodeGlow.position = CGPoint(x: ScreenSize.width + 10, y: (self.childNode(withName: "obstacle3-1")?.position.y)! - 12)
        
        sideLineRightNode.addChild(sideLineRightSpriteNodeGlow)
        addChild(sideLineRightNode)
    }
    
    func addHighscoreLableNode(delayed: Bool = false) {
        
        highscoreLabelNode.fontColor = UIColor(hexFromString: "edff25")
        highscoreLabelNode.text = "HIGHSCORE:\(String(describing: lastHighscore))"
        highscoreLabelNode.fontSize = 18
        highscoreLabelNode.fontName = "LCD14"
        highscoreLabelNode.alpha = 1
        highscoreLabelNode.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height * 0.85)
        
        if delayed == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.75, execute: {
                self.addChild(highscoreLabelNode)
            })
        } else {
            self.addChild(highscoreLabelNode)
        }
        
        
    }
    
    func prepareBall() {
        
        ball = SKShapeNode(circleOfRadius: ScreenSize.width * 0.035)
        ball.lineWidth = 2
        ball.strokeColor = UIColor(hexFromString: "edff25")
        ball.glowWidth = 0
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width / 2.1 )
        ball.physicsBody?.isDynamic = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 0.45
        ball.physicsBody?.categoryBitMask = ColliderType.Ball
        ball.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.NonBall | ColliderType.Scene
        ball.physicsBody?.contactTestBitMask = ColliderType.Ball
        ball.zPosition = 300
        ball.position = CGPoint(x: ScreenSize.width / 2 + 0.1, y: ScreenSize.height * 0.78)
        ballsAdded.append(ball)
        ball.name = "ball\(ballsAdded.count)"
        
        let ballGlow = SKShapeNode(circleOfRadius: ball.frame.size.width / 2.5)
        ballGlow.strokeColor = UIColor(hexFromString: "edff25").withAlphaComponent(0.5)
        ballGlow.lineWidth = 0.1
        ballGlow.glowWidth = 10
        
        ball.addChild(ballGlow)
        
        ball.setScale(0)
        
        addChild(ball)
        
        if (ball.name?.contains("ball"))! {

            ball.run(SKAction.scale(to: 1, duration: 0.4))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                
                self.controlBallBool = true
            })
        }
        
    }
    
    func addStar() {
        
        
        starNode = SKSpriteNode(imageNamed: "star.png")
        
        starNode.size = CGSize(width: 30, height: 30)
        
        starNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "star.png"), size: starNode.size)
        starNode.physicsBody?.isDynamic = false
        starNode.physicsBody?.categoryBitMask = ColliderType.NonBall
        starNode.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.NonBall
        starNode.physicsBody?.contactTestBitMask = ColliderType.NonBall
        
        starNode.name = "star"
        
        let heights = [ScreenSize.height/2 - 195,
                       ScreenSize.height/2 - 136,
                       ScreenSize.height/2 - 80,
                       ScreenSize.height/2 - 23,
                       ScreenSize.height/2 + 35,
                       ScreenSize.height/2 + 93]
        
        
        starNode.position = CGPoint(x: CGFloat.random(in: 60...ScreenSize.width-60), y: heights.randomElement()!)
        
        let starNodeGlow = SKSpriteNode(imageNamed: "star_glow.png")
        starNodeGlow.size = CGSize(width: 30, height: 30)
        starNodeGlow.anchorPoint = CGPoint(x: -starNode.size.width / 2, y: -starNode.size.height / 2)
        
        starNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: -10, duration: 0.3)))
        starNodeGlow.run(SKAction.repeatForever(SKAction.rotate(byAngle: -10, duration: 0.3)))
        starNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: 10, duration: 0.3)))
        starNodeGlow.run(SKAction.repeatForever(SKAction.rotate(byAngle: 10, duration: 0.3)))
        
        starNode.run(SKAction.repeatForever(SKAction.sequence([rotateActionSequence])))
        
        starNode.addChild(starNodeGlow)
        addChild(starNode)
        
    }
    
    func animateStar(star: SKSpriteNode) {
        
        star.physicsBody = nil
        
        let inflate = SKAction.resize(toWidth: 200, height: 200, duration: 0.2)
        let explode = SKAction.resize(toWidth: 300, height: 300, duration: 0.4)
        
        let moveToCenter = SKAction.move(to: CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2), duration: 1)
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        
        let animationSequence = SKAction.sequence([inflate, explode])
        
        star.run(moveToCenter)
        star.run(animationSequence)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            star.run(fadeOut)
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            star.removeFromParent()
        })
        
        
    }
    
    let addPoints = SKAction.run {
        pointsCount = pointsCount + 5
        pointsLabelNode.text = "POINTS:\(pointsCount)"
        
        if fxOn == true {
            
            let plingAudioAction = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
            let changeVolumeAction = SKAction.changeVolume(to: 0.1, duration: 0.01)
            let plingAudioGroup = SKAction.group([plingAudioAction, changeVolumeAction])
            pointsLabelNode.run(plingAudioGroup)
        }
        
        if pointsCount > lastHighscore {
            
            lastHighscore = pointsCount
            highscoreLabelNode.text = "HIGHSCORE:\(lastHighscore)"
            highscoreLabelNode.run(scaleActionSequence)
            
            if !highscoreLabelIsInFront {
                
                highscoreLabelNode.run(SKAction.moveBy(x: 0, y: ScreenSize.height * 0.03, duration: 0.5))
                highscoreLabelIsInFront = true
            }
            
            highscoreLabelNode.fontSize = 26
            highscoreLabelNode.fontName = "LCD14"
            highscoreLabelNode.alpha = 1
            
            pointsLabelNode.alpha = 0
            
        } else {
            
            highscoreLabelNode.fontSize = 18
            highscoreLabelNode.fontName = "LCD14"
            pointsLabelNode.alpha = 1
        }
    }
    
    let addStarPoints = SKAction.run {
        pointsCount = pointsCount + 5000
        pointsLabelNode.text = "POINTS:\(pointsCount)"
        
        if fxOn == true {
            
            let plingAudioAction = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
            let changeVolumeAction = SKAction.changeVolume(to: 0.1, duration: 0.01)
            let plingAudioGroup = SKAction.group([plingAudioAction, changeVolumeAction])
            pointsLabelNode.run(plingAudioGroup)
        }
        
        if pointsCount > lastHighscore {
            
            lastHighscore = pointsCount
            highscoreLabelNode.text = "HIGHSCORE:\(lastHighscore)"
            highscoreLabelNode.run(scaleActionSequence)
            
            if !highscoreLabelIsInFront {
                
                highscoreLabelNode.run(SKAction.moveBy(x: 0, y: ScreenSize.height * 0.03, duration: 0.5))
                highscoreLabelIsInFront = true
            }
            
            highscoreLabelNode.fontSize = 26
            highscoreLabelNode.fontName = "LCD14"
            highscoreLabelNode.alpha = 1
            
            pointsLabelNode.alpha = 0
            
        } else {
            
            highscoreLabelNode.fontSize = 18
            highscoreLabelNode.fontName = "LCD14"
            pointsLabelNode.alpha = 1
        }
    }
    
    func addDownArrows(count: Int) {
        
        let gap = ScreenSize.width / CGFloat(count)
        
        for row in 1...Int(count - 1) {
            
            let arrowPath = CGMutablePath()
            arrowPath.move(to: CGPoint(x: CGFloat(-5) + (CGFloat(row) * gap), y: ScreenSize.height * 0.77))
            arrowPath.addLine(to: CGPoint(x: CGFloat(0) + (CGFloat(row) * gap), y: ScreenSize.height * 0.76))
            arrowPath.addLine(to: CGPoint(x: CGFloat(5) + (CGFloat(row) * gap), y: ScreenSize.height * 0.77))
            
            let arrow = SKShapeNode(path: arrowPath)
            arrow.strokeColor = UIColor(hexFromString: "d800ff")
            arrow.lineWidth = 2
            arrow.alpha = 0.5
            
            let arrow2 = arrow.copy() as! SKShapeNode
            arrow2.position = CGPoint(x: arrow.position.x, y: arrow.position.y - 7.5)
            
            let arrow3 = arrow.copy() as! SKShapeNode
            arrow3.position = CGPoint(x: arrow.position.x, y: arrow.position.y - 15)
            
            
            let arrow1SpriteNode = SKSpriteNode(texture: SKView().texture(from: arrow))
            arrow1SpriteNode.position = CGPoint(x: CGFloat(0) + (CGFloat(row) * gap), y: ScreenSize.height * 0.77)
            
            let arrow2SpriteNode = SKSpriteNode(texture: SKView().texture(from: arrow2))
            arrow2SpriteNode.position = CGPoint(x: CGFloat(0) + (CGFloat(row) * gap), y: ScreenSize.height * 0.77 - 7.5)
            
            let arrow3SpriteNode = SKSpriteNode(texture: SKView().texture(from: arrow3))
            arrow3SpriteNode.position = CGPoint(x: CGFloat(0) + (CGFloat(row) * gap), y: ScreenSize.height * 0.77 - 15)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(CGFloat(row) * 0.0), execute: {
                self.addChild(arrow1SpriteNode)
                self.addChild(arrow2SpriteNode)
                self.addChild(arrow3SpriteNode)
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                arrow1SpriteNode.run(SKAction.repeatForever(SKAction.sequence([pulseActionSequence])))
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                arrow2SpriteNode.run(SKAction.repeatForever(SKAction.sequence([pulseActionSequence])))
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                arrow3SpriteNode.run(SKAction.repeatForever(SKAction.sequence([pulseActionSequence])))
            })
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            if touch == touches.first {
                
//                print("TAP")
                
//                if vibrationOn {
//                    generator.impactOccurred()
//                }
                
                
                
                
                if backButtonNode.contains(touch.location(in: self)) {
                    
                    print("<- ab zum Hauptmenü <-")
                    
                    if vibrationOn {
                        generator.impactOccurred()
                    }
                    
                    if menuOpen {
                        closeMenu()
                    }
                    
                    self.removeAllChildren()
                    self.removeAllActions()
                    SceneManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.fade(withDuration: 0.5))
                    
                } else if miniMenu.contains(touch.location(in: self)) && menuOpen {
                    
                    if vibrationOn {
                        generator.impactOccurred()
                    }
                    
                    for button in miniMenu.children {
                        if button.name != nil && button.name != "" {
                            if button.name == "musicButton" && button.contains(touch.location(in: self)) {
                                
                                if backgroundMusicPlayerStatus == true {
                                    
                                    backgroundMusicPlayer?.stop()
                                    if let musicButton = miniMenu.childNode(withName: "musicButton") as? SKSpriteNode {
                                        musicButton.texture = SKTexture(imageNamed: "music-button-off5")
                                    }
                                    backgroundMusicPlayerStatus = false
                                    UserDefaults.standard.set(false, forKey: "backgroundMusicPlayerStatus")
                                } else {
                                    
                                    backgroundMusicPlayer?.play()
                                    if let musicButton = miniMenu.childNode(withName: "musicButton") as? SKSpriteNode {
                                        musicButton.texture = SKTexture(imageNamed: "music-button-on5")
                                    }
                                    backgroundMusicPlayerStatus = true
                                    UserDefaults.standard.set(true, forKey: "backgroundMusicPlayerStatus")
                                }
                                
                            } else if button.name == "fxButton" && button.contains(touch.location(in: self)) {
                                
                                if fxOn == true {
                                    if let fxButton = miniMenu.childNode(withName: "fxButton") as? SKSpriteNode {
                                        fxButton.texture = SKTexture(imageNamed: "fx-button-off")
                                    }
                                    fxOn = false
                                    UserDefaults.standard.set(false, forKey: "fxOn")
                                } else {
                                    if let fxButton = miniMenu.childNode(withName: "fxButton") as? SKSpriteNode {
                                        fxButton.texture = SKTexture(imageNamed: "fx-button-on")
                                    }
                                    fxOn = true
                                    UserDefaults.standard.set(true, forKey: "fxOn")
                                }
                                
                            } else if button.name == "vibrationButton" && button.contains(touch.location(in: self)) {
                                
                                if vibrationOn == true {
                                    if let vibrationButton = miniMenu.childNode(withName: "vibrationButton") as? SKSpriteNode {
                                        vibrationButton.texture = SKTexture(imageNamed: "vibration-button-off")
                                    }
                                    vibrationOn = false
                                    UserDefaults.standard.set(false, forKey: "vibrationOn")
                                    
                                } else {
                                    if let fxButton = miniMenu.childNode(withName: "vibrationButton") as? SKSpriteNode {
                                        fxButton.texture = SKTexture(imageNamed: "vibration-button-on")
                                    }
                                    vibrationOn = true
                                    UserDefaults.standard.set(true, forKey: "vibrationOn")
                                    
                                    if vibrationOn {
                                        generator.impactOccurred()
                                    }
                                }
                            }
                        }
                    }
                } else if settingsButtonNode.contains(touch.location(in: self)) && settingsButtonNode.isUserInteractionEnabled == false {
                    
                    if vibrationOn {
                        generator.impactOccurred()
                    }
                    
                    if menuOpen == false {
                        openMenu()
                    } else {
                        closeMenu()
                    }
                    
                } else if controlBallBool && touch.location(in: self).y <= ScreenSize.height * 0.8 {
                    ball.position.x = touch.location(in: self).x
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            if controlBallBool && !settingsButtonNode.contains(touches.first!.location(in: self)) && !miniMenu.contains(touch.location(in: self)) && touch.location(in: self).y <= ScreenSize.height * 0.8 {
                ball.position.x = touch.location(in: self).x
            } else if touch.location(in: self).y > ScreenSize.height * 0.8 {
                ball.position.x = ScreenSize.width / 2
            }

        }
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        print("TOUCH UP ---")
    }
    
    func openMenu() {
        
        let nodesToBlendOut = [pointsLabelNode, highscoreLabelNode, ballCounterNode]
        for node in nodesToBlendOut {
            node.isHidden = true
        }
        
        let nodesToBlendIn = [miniMenu]
        for node in nodesToBlendIn {
            
            node.isHidden = false
        }
        
        menuOpen = true
    }
    
    func closeMenu() {
        
        let nodesToBlendOut = [miniMenu]
        for node in nodesToBlendOut {
            node.isHidden = true
        }
        
        let nodesToBlendIn = [pointsLabelNode, highscoreLabelNode, ballCounterNode]
        for node in nodesToBlendIn {
            
            node.isHidden = false
            
        }
        
        menuOpen = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        
//        print("TOUCH ENDED ---")
        
        if settingsButtonNode.contains(touches.first!.location(in: self)) || miniMenu.contains(touches.first!.location(in: self)) {
            
            
        } else if touches.first!.location(in: self).y <= ScreenSize.height * 0.8 {
            
            if controlBallBool && ballCount > 0 {
                controlBallBool = false
                ball.physicsBody?.isDynamic = true
                ballCount = ballCount - 1
                ballCounterLabelNode.text = "X\(ballCount)"
                if ballCount >= 1 {
                    self.controlBallBool = false
                    self.prepareBall()
                }
                
            }
            
        }
        
        if gameOver {
            
            self.removeAllChildren()
            self.removeAllActions()
            SceneManager.shared.transition(self, toScene: .Level1, transition: SKTransition.fade(withDuration: 0.5))
            
        }
    }
    
    func showEndScreen() {
        
        let backgroundLayer = SKShapeNode(rectOf: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        backgroundLayer.fillColor = UIColor(hexFromString: "120d27")
        backgroundLayer.strokeColor = UIColor(hexFromString: "120d27")
        backgroundLayer.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        backgroundLayer.alpha = 0
        backgroundLayer.zPosition = 10000
        
        let gameLabelNode = SKLabelNode(text: "GAME")
        gameLabelNode.fontSize = 100
        gameLabelNode.fontName = "LCD14"
        gameLabelNode.fontColor = UIColor(hexFromString: "d800ff")
        gameLabelNode.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.72)
        gameLabelNode.alpha = 0
        gameLabelNode.zPosition = 10100
        
        let overLabelNode = SKLabelNode(text: "OVER")
        overLabelNode.fontSize = 100
        overLabelNode.fontName = "LCD14"
        overLabelNode.fontColor = UIColor(hexFromString: "d800ff")
        overLabelNode.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.6)
        overLabelNode.alpha = 0
        overLabelNode.zPosition = 10100
        
        let highscoreLabelNode = SKLabelNode(text: "NEW HIGHSCORE")
        highscoreLabelNode.fontSize = 30
        highscoreLabelNode.fontName = "LCD14"
        highscoreLabelNode.fontColor = UIColor(hexFromString: "edff25")
        highscoreLabelNode.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.45)
        highscoreLabelNode.alpha = 0
        highscoreLabelNode.zPosition = 10100
        
        let highscorePointsLabelNode = SKLabelNode(text: "\(lastHighscore)")
        highscorePointsLabelNode.fontSize = 60
        highscorePointsLabelNode.fontName = "LCD14"
        highscorePointsLabelNode.fontColor = UIColor(hexFromString: "edff25")
        highscorePointsLabelNode.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.35)
        highscorePointsLabelNode.alpha = 0
        highscorePointsLabelNode.zPosition = 10100
        
        let pointsLabelNode = SKLabelNode(text: "POINTS:")
        pointsLabelNode.horizontalAlignmentMode = .center
        pointsLabelNode.fontSize = 40
        pointsLabelNode.fontName = "LCD14"
        pointsLabelNode.fontColor = UIColor(hexFromString: "0099ff")
        pointsLabelNode.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.45)
        pointsLabelNode.alpha = 0
        pointsLabelNode.zPosition = 10100
        
        let pointsPointsLabelNode = SKLabelNode(text: "\(pointsCount)")
        pointsPointsLabelNode.horizontalAlignmentMode = .center
        pointsPointsLabelNode.fontSize = 50
        pointsPointsLabelNode.fontName = "LCD14"
        pointsPointsLabelNode.fontColor = UIColor(hexFromString: "0099ff")
        pointsPointsLabelNode.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.365)
        pointsPointsLabelNode.alpha = 0
        pointsPointsLabelNode.zPosition = 10100
        
        let restartLabelNode = SKLabelNode(text: "TAP ANYWHERE TO RESTART")
        restartLabelNode.preferredMaxLayoutWidth = ScreenSize.width * 0.9
        restartLabelNode.fontSize = 20
        restartLabelNode.fontName = "LCD14"
        restartLabelNode.fontColor = UIColor.green
        restartLabelNode.position = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.14)
        restartLabelNode.alpha = 0
        restartLabelNode.zPosition = 10100
        
        self.addChild(backgroundLayer)
        self.addChild(gameLabelNode)
        self.addChild(overLabelNode)
        self.addChild(pointsLabelNode)
        self.addChild(pointsPointsLabelNode)
        self.addChild(restartLabelNode)
        self.addChild(highscoreLabelNode)
        self.addChild(highscorePointsLabelNode)
        
        backgroundLayer.run(SKAction.fadeAlpha(to: 0.9, duration: 0.35))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            gameLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
            overLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if highscoreLabelIsInFront {
                highscoreLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                highscorePointsLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                let scaleUpAction = SKAction.scale(to: 0.9, duration: 0.4)
                let scaleDownAction = SKAction.scale(to: 1.05, duration: 0.4)
                let scaleSequenze = SKAction.sequence([scaleUpAction, scaleDownAction])
                highscorePointsLabelNode.run(SKAction.repeatForever(scaleSequenze))
                
            } else {
                pointsLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                pointsPointsLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            
            restartLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
            
        })
        
//        saveStatsForPlayer()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //        print("KONTAKT")
        
        if (contact.bodyA.node != nil) && (contact.bodyB.node != nil) {
            //            print("KONTAKT1")
            if ((contact.bodyA.node?.name) != nil) && ((contact.bodyB.node?.name) != nil) {
                //                print("KONTAKT2")
                if (contact.bodyA.node?.name?.contains("ball"))! || (contact.bodyB.node?.name?.contains("ball"))! {
                    //                    print("KONTAKT3")
                    if contact.collisionImpulse >= 2.5 {
                        if vibrationOn {
                            generator.impactOccurred()
                        }
                        
                    } else {
                        for box in 0...boxes.count - 1 {
                            if boxes[box].contains(contact.bodyB.node!.position) {
                                if boxesCollected[box] == false {
                                    let multiplier = multipliers[box - 1]
                                    pointsCount = pointsCount * multiplier
                                    pointsLabelNode.text = "POINTS:\(pointsCount)"
                                    
                                    if pointsCount > lastHighscore {
                                        lastHighscore = pointsCount
                                        highscoreLabelNode.text = "HIGHSCORE:\(lastHighscore)"
                                        
                                        if !highscoreLabelIsInFront {
                                            highscoreLabelNode.run(SKAction.moveBy(x: 0, y: ScreenSize.height * 0.03, duration: 0.5))
                                            highscoreLabelNode.fontSize = 26
                                            highscoreLabelNode.fontName = "LCD14"
                                            highscoreLabelNode.alpha = 1
                                            highscoreLabelIsInFront = true
                                            pointsLabelNode.alpha = 0
                                            
                                        }
                                        
                                    } else {
                                        highscoreLabelNode.fontSize = 18
                                        highscoreLabelNode.fontName = "LCD14"
                                        pointsLabelNode.alpha = 1
                                    }
                                    
                                    
                                    boxesCollected[box] = true
                                    let resizeAction = SKAction.resize(toWidth: 0.01, height: 0.01, duration: 0.25)
                                    let alphaAction = SKAction.fadeAlpha(to: 0, duration: 0.25)
                                    let removeSequence = SKAction.sequence([resizeAction, alphaAction])
                                    boxes[box].run(SKAction.fadeAlpha(to: 0.6, duration: 0.25))
                                    boxes[box].children.first!.run(removeSequence)
                                }
                                
                                if ballCount == 0 {
                                    for ball in 0...ballsAdded.count - 1 {
                                        if ballsAdded[ball].position.y <= ScreenSize.height * 0.09 {
                                            ballsDown[ball] = true
                                            if !ballsDown.contains(false) {
                                                
                                                if gameOver == false {
                                                    
                                                    if menuOpen == true {
                                                        closeMenu()
                                                        self.settingsButtonNode.isUserInteractionEnabled = true
                                                    }
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                                        
                                                        self.showEndScreen()
                                                        
                                                    })
                                                    
                                                    if highscoreLabelIsInFront == true {
                                                        
                                                        self.saveHighScore()
                                                    }
                                                    gameOver = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                if (contact.bodyA.node?.name?.contains("obstacle"))! || (contact.bodyB.node?.name?.contains("obstacle"))! {
                    contact.bodyA.node?.children.first!.run(scalePlusPointsActionSequence)
                    pointsLabelNode.run(scaleActionSequence)
                    
                    let miniPointsLabelNode = SKLabelNode(text: "+5")
                    miniPointsLabelNode.fontSize = 13
                    miniPointsLabelNode.alpha = 1
                    miniPointsLabelNode.fontName = "LCD14"
                    miniPointsLabelNode.horizontalAlignmentMode = .center
                    miniPointsLabelNode.fontColor = UIColor(hexFromString: "0099ff")
                    
                    let scaleAction = SKAction.scale(to: 1, duration: 0.4)
                    let moveAction = SKAction.moveBy(x: 0, y: 30, duration: 0.59)
                    let actionSequence = SKAction.sequence([scaleAction, moveAction])
                    
                    let miniPointsLabelSpriteNode = SKSpriteNode(texture: SKView().texture(from: miniPointsLabelNode))
                    miniPointsLabelSpriteNode.position = CGPoint(x: contact.bodyA.node!.position.x, y: contact.bodyA.node!.position.y + 16)
                    miniPointsLabelSpriteNode.setScale(0.1)
                    addChild(miniPointsLabelSpriteNode)
                    miniPointsLabelSpriteNode.run(actionSequence)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                        miniPointsLabelSpriteNode.removeFromParent()
                    })
                }
                
                if (contact.bodyA.node?.name?.contains("star"))! || (contact.bodyB.node?.name?.contains("star"))! {
                    contact.bodyA.node?.children.first!.run(scalePlusPointsActionSequence)
                    pointsLabelNode.run(scaleActionSequence)
                    
                    let miniPointsLabelNode = SKLabelNode(text: "+5000")
                    miniPointsLabelNode.fontSize = 30
                    miniPointsLabelNode.alpha = 1
                    miniPointsLabelNode.fontName = "LCD14"
                    miniPointsLabelNode.horizontalAlignmentMode = .center
                    miniPointsLabelNode.fontColor = UIColor(hexFromString: "edff25")
                    
                    let scaleAction = SKAction.scale(to: 1.2, duration: 0.5)
                    let moveAction = SKAction.moveBy(x: 0, y: 100, duration: 0.5)
                    let actionSequence = SKAction.sequence([scaleAction, moveAction])
                    
                    let miniPointsLabelSpriteNode = SKSpriteNode(texture: SKView().texture(from: miniPointsLabelNode))
                    miniPointsLabelSpriteNode.position = CGPoint(x: contact.bodyA.node!.position.x, y: contact.bodyA.node!.position.y + 50)
                    miniPointsLabelSpriteNode.setScale(0.1)
                    addChild(miniPointsLabelSpriteNode)
                    miniPointsLabelSpriteNode.run(actionSequence)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                        miniPointsLabelSpriteNode.removeFromParent()
                    })
                    
                    starNode.run(addStarPoints)
                    animateStar(star: starNode)
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                        self.addStar()
                    })
                }
            }
        }
    }
    
//    func saveStatsForPlayer() {
//
//        if let loadedPlayerData = UserDefaults.standard.object(forKey: "player") as? Data {
//            if let player = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedPlayerData) as? Player {
//
//                print("player.totalPointsCollected = \(player.totalPointsCollected)")
//                print("player.totalBallsDropped = \(player.totalBallsDropped)")
//                player.totalPointsCollected = player.totalPointsCollected + pointsCount
//                player.totalBallsDropped = player.totalBallsDropped + 5
//                print("player.totalPointsCollected = \(player.totalPointsCollected)")
//                print("player.totalBallsDropped = \(player.totalBallsDropped)")
//                print("highscoreList.count = \(player.highscore)")
//
//                if let playerDataToSave = try? NSKeyedArchiver.archivedData(withRootObject: player, requiringSecureCoding: false) {
//                    UserDefaults.standard.set(playerDataToSave, forKey: "player")
//                    print("STATS SAVED!")
//                }
//            }
//        }
//
//    }
    
    func saveHighScore() {
        
        let newHighscore = lastHighscore
        
        UserDefaults.standard.set(newHighscore, forKey: "highscore")
        
//        if let loadedPlayerData = UserDefaults.standard.object(forKey: "player") as? Data {
//            if let player = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedPlayerData) as? Player {
//
//                player.highscore = newHighscore
//                print("highscore = \(player.highscore)")
//
//                if let playerDataToSave = try? NSKeyedArchiver.archivedData(withRootObject: player, requiringSecureCoding: false) {
//                    UserDefaults.standard.set(playerDataToSave, forKey: "player")
//                }
//            }
//        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
