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
var scaleToActionSequence = SKAction.sequence([])
var scaleByActionSequence = SKAction.sequence([])
var pulseActionSequence = SKAction.sequence([])
var rotateActionSequence = SKAction.sequence([])
var scalePlusPointsActionSequence = SKAction.sequence([])
var highscoreLabelIsInFront = false
var lastHighscore = Int()
var tutorialShown = UserDefaults.standard.bool(forKey: "tutorialShown")
var multiplyerCount = 0
var multiplyerLabelNode = SKLabelNode()
var starNode = SKSpriteNode()

let generator = UIImpactFeedbackGenerator(style: .medium)

var gameOver = false

// MARK: - Beginn der Klasse

class Level1: SKScene, SKPhysicsContactDelegate {
    
    
    // MARK: - Variablen & Instanzen

    let effectNode = SKEffectNode()
    var menuOpen = false
    let starFieldNode = SKShapeNode()
    let settingsButtonNode = SKSpriteNode(imageNamed: "settings-button5")
    let backButtonNode = SKSpriteNode(imageNamed: "back-button4")
    var ballCounterLabelNode = SKLabelNode()
    var boxes = [SKShapeNode()]
    var multiplyers = [Int()]
    var ballsAdded = [SKShapeNode]()
    var ball = SKShapeNode()
    var ballCount = 5
    var boxesCollected = [false, false, false, false, false, false]
    var ballsDown = [false, false, false, false, false]
    var controlBallBool = false
    let scaleUpAction = SKAction.scale(to: 1.5, duration: 0.1)
    let scaleDownAction = SKAction.scale(to: 1, duration: 0.6)
    let smallScaleUpToAction = SKAction.scale(to: 1.1, duration: 0.1)
    let smallScaleUpByAction = SKAction.scale(by: 1.2, duration: 0.1)
    let smallScaleDownToAction = SKAction.scale(to: 1, duration: 0.1)
    let smallScaleDownByAction = SKAction.scale(by: 0.8, duration: 0.1)
    let fadeUpAction = SKAction.fadeAlpha(to: 0.75, duration: 1)
    let fadeDownAction = SKAction.fadeAlpha(to: 0, duration: 1)
    let fadeDownDoubleSpeedAction = SKAction.fadeAlpha(to: 0, duration: 0.5)
    let rotateLeftAction = SKAction.rotate(toAngle: .pi / 15, duration: 1)
    let rotateRightAction = SKAction.rotate(toAngle: .pi / -15, duration: 1)
    let wait = SKAction.wait(forDuration: 1)
    let playerName = UserDefaults.standard.string(forKey: "playerName")
    var totalBallsDropped = 0
    var totalPointsCollected = 0
    var starNodeTexture = SKTexture()
    
    
    // MARK: - Beginn der Funktionen
    
    
    func createVector(_ point:CGPoint) -> CIVector {
        return CIVector(x: point.x, y: Screen.height - point.y)
    }
    
    
    
    override func didMove(to view: SKView) {
        
        //print("- Level 1 -")
        
        let pixelFilter = CIFilter(name: "CIPixellate")
        pixelFilter!.setValue(10.0, forKey: "inputScale")
                
//        let blurFilter = CIFilter(name: "CIComicEffect")
//        blurFilter!.setValue(5.0, forKey: "inputRadius")
        
//        let bloomFilter = CIFilter(name: "CIBloom")
        
//        let hatchedFilter = CIFilter(name: "CIHatchedScreen")
        
//        let dotScreenFilter = CIFilter(name: "CIDotScreen")
        
//        effectNode.filter = bloomFilter
        
        self.addChild(effectNode)
        
//        let cloudsEffectNode = SKEffectNode()
//        cloudsEffectNode.filter = pixelFilter!
//
//        let cloud = SKSpriteNode(imageNamed: "cloud")
//        cloud.size = CGSize(width: 300, height: 150)
//        cloud.position = Screen.center
//
//        cloudsEffectNode.addChild(cloud)
//        addChild(cloudsEffectNode)
        
        
//        self.backgroundColor = UIColor(hexFromString: "120d27")
        
        highscoreLabelIsInFront = false
        
        vibrationOn = UserDefaults.standard.bool(forKey: "vibrationOn")
        
        scaleToActionSequence = SKAction.sequence([smallScaleUpToAction, smallScaleDownToAction])
        
        scaleByActionSequence = SKAction.sequence([smallScaleUpByAction, smallScaleDownByAction])
        
        pulseActionSequence = SKAction.sequence([fadeDownAction, wait, fadeUpAction])
        
        rotateActionSequence = SKAction.sequence([rotateLeftAction, rotateRightAction])
        
        scalePlusPointsActionSequence = SKAction.sequence([addPoints, scaleUpAction, scaleDownAction])
        
        //print("PLAYER = \(String(describing: playerName!))")
        
        lastHighscore = UserDefaults.standard.integer(forKey: "highscore")
        
        //print("LAST HIGHSCORE = \(String(describing: lastHighscore))")
        
        addHighscoreLableNode()
        
        addBallCounterNode()
        
        addMultiplyerNode()
        
        addPointsLabelNode()
        
        gameOver = false
        
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
        
        if tutorialShown == false {
            
            self.view?.isUserInteractionEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                
                let backgroundNode = SKShapeNode(rectOf: CGSize(width: Screen.width, height: Screen.height))
                backgroundNode.zPosition = 299
                backgroundNode.fillColor = UIColor.black.withAlphaComponent(0.7)
                backgroundNode.strokeColor = UIColor.black.withAlphaComponent(0.0)
                backgroundNode.position = CGPoint(x: Screen.width/2, y: Screen.height/2)
                backgroundNode.alpha = 0
                self.effectNode.addChild(backgroundNode)
                backgroundNode.run(SKAction.fadeAlpha(to: 0.75, duration: 0.25))
                
                let fingerNode = SKSpriteNode(texture: SKTexture(imageNamed: "tutorial-finger-tap-off"))
                fingerNode.scale(to: CGSize(width: Screen.width * 0.4, height: Screen.width * 0.4))
                fingerNode.zPosition = 300
                fingerNode.position = CGPoint(x: Screen.width * 2, y: Screen.height * 0.4)
                self.effectNode.addChild(fingerNode)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
                    let rushInAction = SKAction.move(to: CGPoint(x: Screen.width * 0.575, y: Screen.height * 0.4), duration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2)
                    fingerNode.run(rushInAction)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.45, execute: {
                        let tapAction = SKAction.setTexture(SKTexture(imageNamed: "tutorial-finger-tap-on"))
                        fingerNode.run(tapAction)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            let moveLeftAction = SKAction.move(by: CGVector(dx: Screen.width * -0.25, dy: 0), duration: 0.5)
                            self.ball.run(moveLeftAction)
                            fingerNode.run(moveLeftAction)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                                let moveRightAction = SKAction.move(by: CGVector(dx: Screen.width * 0.5, dy: 0), duration: 0.75)
                                self.ball.run(moveRightAction)
                                fingerNode.run(moveRightAction)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.85, execute: {
                                    let moveBackAction = SKAction.move(by: CGVector(dx: Screen.width * -0.25, dy: 0), duration: 0.5)
                                    self.ball.run(moveBackAction)
                                    fingerNode.run(moveBackAction)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
                                        
                                        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
                                        backgroundNode.run(fadeOutAction)
                                        fingerNode.run(fadeOutAction)
                                        
                                        UserDefaults.standard.set(true, forKey: "tutorialShown")
                                        tutorialShown = true
                                        self.view?.isUserInteractionEnabled = true
                                    })
                                })
                            })
                        })
                    })
                })
            })
            
        } else {
            //print("TUTORIAL WURDE SCHON MAL GEZEIGT ... ABER WENN DU WILLST ZEIG ICH ES DIR NOCHMAL ... KLICK EINFACH OBEN LINKS ... BLA BLA")
        }
        
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
    
    func prepareMiniMenu() {
        
        miniMenu = SKShapeNode(rect: CGRect(x: Screen.width * 0.05, y: Screen.height * 0.825, width: Screen.width * 0.9, height: Screen.height * 0.09), cornerRadius: 8)
        miniMenu.strokeColor = UIColor(hexFromString: "0099ff")
//        miniMenu.glowWidth = 3
        
        let miniMenuGlow = miniMenu.copy() as! SKShapeNode
        miniMenuGlow.glowWidth = 10
        miniMenuGlow.lineWidth = 1
        miniMenuGlow.alpha = 0.5
        
        let miniMenuBackground = miniMenu.copy() as! SKShapeNode
//        miniMenuBackground.fillColor = UIColor(hexFromString: "120d27")
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
        buttonBackgroundMusic.size = CGSize(width: miniMenuBackground.frame.size.height * 0.8, height: miniMenuBackground.frame.size.height * 0.8)
        buttonBackgroundMusic.position = CGPoint(x: ((Screen.width * 0.9) / 3) * 0.75, y: Screen.height * 0.88)
        buttonBackgroundMusic.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let buttonBackgroundMusicLabelNode = SKLabelNode()
        buttonBackgroundMusicLabelNode.name = "musicButtonLabel"
        buttonBackgroundMusicLabelNode.fontName = "LCD14"
        buttonBackgroundMusicLabelNode.fontSize = 10
        if backgroundMusicPlayerStatus == true {
            buttonBackgroundMusicLabelNode.text = "MUSIC: ON"
            buttonBackgroundMusicLabelNode.fontColor = UIColor.green
            
        } else {
            buttonBackgroundMusicLabelNode.text = "MUSIC: OFF"
            buttonBackgroundMusicLabelNode.fontColor = UIColor.red
        }
        buttonBackgroundMusicLabelNode.position = CGPoint(x: buttonBackgroundMusic.position.x, y: buttonBackgroundMusic.position.y - 35)
        
        
        var buttonFX = SKSpriteNode()
        if fxOn == true {
            buttonFX = SKSpriteNode(imageNamed: "fx-button-on")
        } else {
            buttonFX = SKSpriteNode(imageNamed: "fx-button-off")
        }
        
        buttonFX.name = "fxButton"
        buttonFX.size = CGSize(width: miniMenuBackground.frame.size.height * 0.8, height: miniMenuBackground.frame.size.height * 0.8)
        buttonFX.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.88)
        buttonFX.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let buttonFXLabelNode = SKLabelNode()
        buttonFXLabelNode.name = "fxButtonLabel"
        buttonFXLabelNode.fontName = "LCD14"
        buttonFXLabelNode.fontSize = 10
        if fxOn == true {
            buttonFXLabelNode.text = "SOUND-FX: ON"
            buttonFXLabelNode.fontColor = UIColor.green
            
        } else {
            buttonFXLabelNode.text = "SOUND-FX: OFF"
            buttonFXLabelNode.fontColor = UIColor.red
        }
        buttonFXLabelNode.position = CGPoint(x: buttonFX.position.x, y: buttonFX.position.y - 35)
        
        
        
        var buttonVibration = SKSpriteNode()
        if vibrationOn == true {
            buttonVibration = SKSpriteNode(imageNamed: "vibration-button-on")
        } else {
            buttonVibration = SKSpriteNode(imageNamed: "vibration-button-off")
        }
        buttonVibration.name = "vibrationButton"
        buttonVibration.size = CGSize(width: miniMenuBackground.frame.size.height * 0.8, height: miniMenuBackground.frame.size.height * 0.8)
        buttonVibration.position = CGPoint(x: ((Screen.width * 0.9) / 3) * 2.6, y: Screen.height * 0.88)
        buttonVibration.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let buttonVibrationLabelNode = SKLabelNode()
        buttonVibrationLabelNode.name = "vibrationButtonLabel"
        buttonVibrationLabelNode.fontName = "LCD14"
        buttonVibrationLabelNode.fontSize = 10
        if vibrationOn == true {
            buttonVibrationLabelNode.text = "VIBRATION: ON"
            buttonVibrationLabelNode.fontColor = UIColor.green
            
        } else {
            buttonVibrationLabelNode.text = "VIBRATION: OFF"
            buttonVibrationLabelNode.fontColor = UIColor.red
        }
        buttonVibrationLabelNode.position = CGPoint(x: buttonVibration.position.x, y: buttonVibration.position.y - 35)
        
        miniMenu.addChild(miniMenuGlow)
        miniMenu.addChild(miniMenuBackground)
        miniMenu.addChild(buttonBackgroundMusic)
        miniMenu.addChild(buttonBackgroundMusicLabelNode)
        miniMenu.addChild(buttonFX)
        miniMenu.addChild(buttonFXLabelNode)
        miniMenu.addChild(buttonVibration)
        miniMenu.addChild(buttonVibrationLabelNode)
        miniMenu.isHidden = true
        miniMenu.isUserInteractionEnabled = false
       effectNode.addChild(miniMenu)
    }
    
    func addStarFieldNode() {
        
        let fieldNode = SKNode()
        
        for _ in 0...350 {
            
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.05...0.15))
            star.fillColor = .white
            star.glowWidth = CGFloat.random(in: 0.01...0.8)
            star.alpha = CGFloat.random(in: 0.1...0.25)
            
            star.position = CGPoint(x: CGFloat.random(in: 0...Screen.width), y: CGFloat.random(in: 0...Screen.height))
            fieldNode.addChild(star)
        }
        
        let fieldNodeSpriteNode = SKSpriteNode(texture: SKView().texture(from: fieldNode))
        fieldNodeSpriteNode.anchorPoint = .init(x: 0, y: 1)
        fieldNodeSpriteNode.position = CGPoint(x: 0, y: Screen.height)
        fieldNodeSpriteNode.zPosition = -1000
        effectNode.addChild(fieldNodeSpriteNode)
        
    }
    
    func addPointsLabelNode(delayed: Bool = false) {
        
        pointsCount = 0
        pointsLabelNode.text = "POINTS: \(pointsCount)"
        pointsLabelNode.fontSize = 28
        pointsLabelNode.alpha = 1
        pointsLabelNode.fontName = "LCD14"
        pointsLabelNode.horizontalAlignmentMode = .center
        pointsLabelNode.preferredMaxLayoutWidth = Screen.width * 0.7
        pointsLabelNode.fontColor = UIColor(hexFromString: "0099ff")
        pointsLabelNode.position = CGPoint(x: (Screen.width * 0.5) + (pointsLabelNode.frame.size.width * 0), y: Screen.height * 0.87)
        
        if delayed == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.effectNode.addChild(pointsLabelNode)
            })
        } else {
            effectNode.addChild(pointsLabelNode)
        }
        
    }
    
    func addBackButtonNode() {
        
        let backButtonAspectRatio = backButtonNode.size.width/backButtonNode.size.height
        if DeviceType.isiPad || DeviceType.isiPadPro {
            backButtonNode.size = CGSize(width: Screen.width * 0.08, height: Screen.width * 0.08 / backButtonAspectRatio)
        } else {
            //            //print("is not iPad")
            backButtonNode.size = CGSize(width: Screen.width * 0.1, height: Screen.width * 0.1 / backButtonAspectRatio)
        }
        backButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backButtonNode.position = CGPoint(x: Screen.width * 0.1, y: Screen.height * 0.95)
        backButtonNode.alpha = 0.7
        effectNode.addChild(backButtonNode)
    }
    
    func addSettingsButtonNode() {
        
        let settingsButtonAspectRatio = settingsButtonNode.size.width/settingsButtonNode.size.height
        if DeviceType.isiPad || DeviceType.isiPadPro {
            settingsButtonNode.size = CGSize(width: Screen.width * 0.08, height: Screen.width * 0.08 / settingsButtonAspectRatio)
        } else {
            //            //print("is not iPad")
            settingsButtonNode.size = CGSize(width: Screen.width * 0.10, height: Screen.width * 0.10 / settingsButtonAspectRatio)
        }
        settingsButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        settingsButtonNode.position = CGPoint(x: Screen.width * 0.9, y: Screen.height * 0.95)
        settingsButtonNode.alpha = 0.7
        effectNode.addChild(settingsButtonNode)
    }
    
    func addBallCounterNode(delayed: Bool = false) {
                
        ballCounterLabelNode = SKLabelNode(text: "BALLS: X\(ballCount)")
        if ballCount == 0 {
            ballCounterLabelNode.fontColor = .red
        }
        ballCounterLabelNode.fontName = "LCD14"
        ballCounterLabelNode.setScale(0.35)
        ballCounterLabelNode.position = CGPoint(x: Screen.width * 0.02, y: Screen.height * 0.83)
        ballCounterLabelNode.horizontalAlignmentMode = .left
        
        ballCounterLabelNode.fontColor = Color.yellow
        
        effectNode.addChild(ballCounterLabelNode)
        
        
        
    }
    
    func addMultiplyerNode() {
        multiplyerLabelNode = SKLabelNode()
        multiplyerCount = 0
        multiplyerLabelNode.text = "MULTI: X\(multiplyerCount)"
        multiplyerLabelNode.fontName = "LCD14"
        multiplyerLabelNode.setScale(0.35)
        multiplyerLabelNode.horizontalAlignmentMode = .right
        
        multiplyerLabelNode.position = CGPoint(x: Screen.width * 0.979, y: Screen.height * 0.83)
        multiplyerLabelNode.fontColor = Color.yellow
        multiplyerLabelNode.alpha = 1
        //print("multiplyerLabelNode = \(multiplyerLabelNode)")
        effectNode.addChild(multiplyerLabelNode)
    }
    
    func addStartGlowLine() {
        
        let startGlowLinePath = CGMutablePath()
        startGlowLinePath.move(to: CGPoint(x: -50, y: Screen.height * 0.78))
        startGlowLinePath.addLine(to: CGPoint(x: Screen.width + 50, y: Screen.height * 0.78))
        let startGlowLineNode = SKShapeNode()
        startGlowLineNode.path = startGlowLinePath
        startGlowLineNode.strokeColor = UIColor(hexFromString: "0099ff")
        startGlowLineNode.lineWidth = 0.1
        startGlowLineNode.glowWidth = 40
        startGlowLineNode.alpha = 0.35
        startGlowLineNode.blendMode = .add
        
        let startGlowLinePath2 = CGMutablePath()
        startGlowLinePath2.move(to: CGPoint(x: -50, y: Screen.height * 0.78))
        startGlowLinePath2.addLine(to: CGPoint(x: Screen.width + 50, y: Screen.height * 0.78))
        let startGlowLineNode2 = SKShapeNode()
        startGlowLineNode2.path = startGlowLinePath2
        startGlowLineNode2.strokeColor = UIColor(hexFromString: "0099ff")
        startGlowLineNode2.lineWidth = 3.5
        startGlowLineNode2.glowWidth = 0
        startGlowLineNode2.alpha = 1
        startGlowLineNode2.blendMode = .add
        startGlowLineNode.addChild(startGlowLineNode2)
        
        let startGlowLineSpriteNode = SKSpriteNode(texture: SKView().texture(from: startGlowLineNode))
        startGlowLineSpriteNode.position = CGPoint(x: -50, y: Screen.height * 0.78)
        startGlowLineSpriteNode.anchorPoint = .init(x: 0, y: 0.5)
        effectNode.addChild(startGlowLineSpriteNode)
    }
    
    func addObstacles() {
        
        for doubleRow in 0...3 {
            
            for number in 1...7 {
                
                let obstacleNode = SKShapeNode(circleOfRadius: Screen.width * 0.015)
                obstacleNode.strokeColor = UIColor(hexFromString: "d800ff").withAlphaComponent(0.82)
                obstacleNode.lineWidth = 3
                obstacleNode.position = CGPoint(x: Screen.width / 8 * CGFloat(number), y: Screen.height * (0.65 - CGFloat(CGFloat(doubleRow) / 7)))
                
                obstacleNode.physicsBody = SKPhysicsBody(edgeLoopFrom: obstacleNode.path!)
                obstacleNode.physicsBody?.isDynamic = false
                obstacleNode.physicsBody?.friction = 0
                obstacleNode.physicsBody?.restitution = 1
                obstacleNode.physicsBody?.categoryBitMask = ColliderType.NonBall
                obstacleNode.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.NonBall
                obstacleNode.physicsBody?.contactTestBitMask = ColliderType.NonBall
                obstacleNode.name = "obstacle\(doubleRow)-\(number)"
                
                let glowNode = SKShapeNode(circleOfRadius: obstacleNode.frame.size.width / 2)
                glowNode.glowWidth = 7
                glowNode.alpha = 0.7
                glowNode.strokeColor = UIColor(hexFromString: "0099ff")
                let glowSpriteNode = SKSpriteNode(texture: SKView().texture(from: glowNode))
                glowSpriteNode.name = "obstacleGlow"
                glowSpriteNode.zPosition = obstacleNode.zPosition - 1
                
                obstacleNode.addChild(glowSpriteNode)
                
                effectNode.addChild(obstacleNode)
                
            }
            
            if doubleRow <= 2 {
                
                for number in 2...7 {
                    
                    let obstacleNode = SKShapeNode(circleOfRadius: Screen.width * 0.015)
                    obstacleNode.strokeColor = UIColor(hexFromString: "d800ff").withAlphaComponent(0.82)
                    obstacleNode.lineWidth = 3
                    obstacleNode.position = CGPoint(x: (Screen.width / 8) * (CGFloat(number) - 0.5), y: Screen.height * (0.58 - CGFloat(CGFloat(doubleRow) / 7)))
                    
                    obstacleNode.physicsBody = SKPhysicsBody(edgeLoopFrom: obstacleNode.path!)
                    obstacleNode.physicsBody?.isDynamic = false
                    obstacleNode.physicsBody?.friction = 0
                    obstacleNode.physicsBody?.restitution = 1
                    obstacleNode.physicsBody?.categoryBitMask = ColliderType.NonBall
                    obstacleNode.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.NonBall
                    obstacleNode.physicsBody?.contactTestBitMask = ColliderType.NonBall
                    obstacleNode.name = "obstacle\(doubleRow)-\(number + 8)"
                    
                    let glowNode = SKShapeNode(circleOfRadius: obstacleNode.frame.size.width / 2)
                    glowNode.glowWidth = 7
                    glowNode.alpha = 0.7
                    glowNode.strokeColor = UIColor(hexFromString: "0099ff")
                    let glowSpriteNode = SKSpriteNode(texture: SKView().texture(from: glowNode))
                    glowSpriteNode.name = "obstacleGlow"
                    glowSpriteNode.zPosition = obstacleNode.zPosition - 1
                    
                    obstacleNode.addChild(glowSpriteNode)
                    
                    effectNode.addChild(obstacleNode)
                    
                }
            }
        }
    }
    
    func addBoxes(count: Int) {
        
        let holeWidth = Screen.width / CGFloat(count)
        
        for boxNumber in 1...count {
            
            let box = SKShapeNode(rectOf: CGSize(width: holeWidth, height: Screen.height * 0.1))
            box.position = CGPoint(x: holeWidth * (CGFloat(boxNumber) - 0.5), y: Screen.height * 0.05)
            box.fillColor = UIColor(hexFromString: "0099ff").withAlphaComponent(0.3)
            box.strokeColor = UIColor(hexFromString: "0099ff").withAlphaComponent(0.3)
            box.glowWidth = 5
            box.lineWidth = 0.1
            box.zPosition = ball.zPosition + 10
            box.name = "box\(boxNumber)"
            box.physicsBody?.isDynamic = false
            box.physicsBody?.categoryBitMask = ColliderType.Invisible
            box.physicsBody?.collisionBitMask = ColliderType.Ball
            box.physicsBody?.contactTestBitMask = ColliderType.Invisible | ColliderType.Ball
            
            effectNode.addChild(box)
            
            boxes.append(box)
            
            multiplyers = [1,2,3,2,1]
            
            let multiplierLabelNode = SKLabelNode(text: "X\(multiplyers[boxNumber-1])")
            
            multiplierLabelNode.fontName = "LCD14"
            multiplierLabelNode.fontSize = 24
            multiplierLabelNode.fontColor = Color.yellow
            
            box.addChild(multiplierLabelNode)

            
        }
        
        for line in 1...count - 1 {
            
            let linePath = CGMutablePath()
            linePath.move(to: CGPoint(x: holeWidth * CGFloat(line), y: 0))
            linePath.addLine(to: CGPoint(x: holeWidth * CGFloat(line), y: Screen.height * 0.1))
            let lineNode = SKShapeNode(path: linePath)
            lineNode.name = "line\(line)"
            lineNode.strokeColor = UIColor(hexFromString: "0099ff")
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
            lineGlow.strokeColor = UIColor(hexFromString: "0099ff")
            lineGlow.lineWidth = 1
            lineGlow.glowWidth = 16
            lineGlow.alpha = 0.4
            
            let lineGlowSpriteNode = SKSpriteNode(texture: SKView().texture(from: lineGlow))
            lineGlowSpriteNode.position = CGPoint(x: holeWidth * CGFloat(line), y: 0 - 18)
            lineGlowSpriteNode.anchorPoint = .init(x: 0.5, y: 0)
            
            lineNode.addChild(lineGlowSpriteNode)
            
            effectNode.addChild(lineNode)
        }
        
        let bottomLinePath = CGMutablePath()
        bottomLinePath.move(to: CGPoint(x: 0, y: 0))
        bottomLinePath.addLine(to: CGPoint(x: Screen.width, y: 0))
        let bottomLineNode = SKShapeNode(path: bottomLinePath)
        bottomLineNode.name = "bottomLine"
        bottomLineNode.strokeColor = UIColor(hexFromString: "d800ff")
        bottomLineNode.lineWidth = 1
        bottomLineNode.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomLinePath)
        bottomLineNode.physicsBody?.isDynamic = false
        bottomLineNode.physicsBody?.categoryBitMask = ColliderType.NonBall
        bottomLineNode.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.NonBall
        bottomLineNode.physicsBody?.contactTestBitMask = ColliderType.NonBall
        effectNode.addChild(bottomLineNode)
    }
    
    func addSideLines() {
        
        let sideLineLeftPath = CGMutablePath()
        sideLineLeftPath.move(to: CGPoint(x: 0, y: (self.effectNode.childNode(withName: "obstacle0-1")?.position.y)!))
        sideLineLeftPath.addLine(to: CGPoint(x: Screen.width * 0.05, y: (self.effectNode.childNode(withName: "obstacle0-10")?.position.y)!))
        sideLineLeftPath.addLine(to: CGPoint(x: 0, y: (self.effectNode.childNode(withName: "obstacle1-1")?.position.y)!))
        sideLineLeftPath.addLine(to: CGPoint(x: Screen.width * 0.05, y: (self.effectNode.childNode(withName: "obstacle1-10")?.position.y)!))
        sideLineLeftPath.addLine(to: CGPoint(x: 0, y: (self.effectNode.childNode(withName: "obstacle2-1")?.position.y)!))
        sideLineLeftPath.addLine(to: CGPoint(x: Screen.width * 0.05, y: (self.effectNode.childNode(withName: "obstacle2-10")?.position.y)!))
        sideLineLeftPath.addLine(to: CGPoint(x: 0, y: (self.effectNode.childNode(withName: "obstacle3-1")?.position.y)!))
        
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
        sideLineLeftSpriteNodeGlow.position = CGPoint(x: -10, y: (self.effectNode.childNode(withName: "obstacle3-1")?.position.y)! - 12)
        
        
        sideLineLeftNode.addChild(sideLineLeftSpriteNodeGlow)
        effectNode.addChild(sideLineLeftNode)
        
        
        
        let sideLineRightPath = CGMutablePath()
        sideLineRightPath.move(to: CGPoint(x: Screen.width, y: (self.effectNode.childNode(withName: "obstacle0-1")?.position.y)!))
        sideLineRightPath.addLine(to: CGPoint(x: (Screen.width * 0.95), y: (self.effectNode.childNode(withName: "obstacle0-10")?.position.y)!))
        sideLineRightPath.addLine(to: CGPoint(x: Screen.width, y: (self.effectNode.childNode(withName: "obstacle1-1")?.position.y)!))
        sideLineRightPath.addLine(to: CGPoint(x: (Screen.width * 0.95), y: (self.effectNode.childNode(withName: "obstacle1-10")?.position.y)!))
        sideLineRightPath.addLine(to: CGPoint(x: Screen.width, y: (self.effectNode.childNode(withName: "obstacle2-1")?.position.y)!))
        sideLineRightPath.addLine(to: CGPoint(x: (Screen.width * 0.95), y: (self.effectNode.childNode(withName: "obstacle2-10")?.position.y)!))
        sideLineRightPath.addLine(to: CGPoint(x: Screen.width, y: (self.effectNode.childNode(withName: "obstacle3-1")?.position.y)!))
        
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
        sideLineRightSpriteNodeGlow.position = CGPoint(x: Screen.width + 10, y: (self.effectNode.childNode(withName: "obstacle3-1")?.position.y)! - 12)
        
        sideLineRightNode.addChild(sideLineRightSpriteNodeGlow)
        effectNode.addChild(sideLineRightNode)
    }
    
    func addHighscoreLableNode(delayed: Bool = false) {
        
        highscoreLabelNode.fontColor = Color.yellow
        highscoreLabelNode.text = "HIGHSCORE: \(lastHighscore)"
        highscoreLabelNode.fontSize = 13
        highscoreLabelNode.fontName = "LCD14"
        highscoreLabelNode.alpha = 1
        highscoreLabelNode.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.935)
        
        if delayed == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.75, execute: {
                self.effectNode.addChild(highscoreLabelNode)
            })
        } else {
            effectNode.addChild(highscoreLabelNode)
        }
        
        
    }
    
    func prepareBall() {
        
        
//        let lable = UILabel(frame: CGRect(x: ball.position.x, y: ball.position.y, width: ball.frame.width, height: ball.frame.height))
//        lable.tag = 12345
//        let lableView = SKView()
//        lableView.addSubview(lable)
//        ball.addChild(lableView)
        
        ball = Ball().create()
        
        ball.position = CGPoint(x: Screen.width / 2 + 0.1, y: Screen.height * 0.78)
        ballsAdded.append(ball)
        ball.name = "ball\(ballsAdded.count)"
        ball.strokeColor = UIColor.yellow
        ball.lineWidth = Screen.width * 0.008
        
        let ballGlow = SKShapeNode(circleOfRadius: ball.frame.size.width / 2.5)
        ballGlow.strokeColor = Color.yellow.withAlphaComponent(0.6)
        ballGlow.lineWidth = 0.1
        ballGlow.glowWidth = 12
//        ballGlow.zPosition = 290
        ballGlow.name = "glow\(ballsAdded.count)"
        
        
        ball.addChild(ballGlow)
        for child in ball.children {
            //print("Child found: \(String(describing: child.name))")
            if let name = child.name {
                if name.lowercased().contains("glow") {
                    child.zPosition = -10
                }
            }
        }
        ball.setScale(0)
        
        effectNode.addChild(ball)
        
        if (ball.name?.contains("ball"))! {

            ball.run(SKAction.scale(to: 1, duration: 0.4))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                
                self.controlBallBool = true
            })
        }
        
    }
    
    func addStar() {
        
        
        starNode.size = CGSize(width: 30, height: 30)
        
        let starTypes = ["pointsStar", "multiStar"]
        
        let starType = starTypes.randomElement()
        
        if starType == starTypes.first {
            
            starNodeTexture = SKTexture(imageNamed: "star_blue")
        } else {
            
            starNodeTexture = SKTexture(imageNamed: "star_yellow")
        }
        
        starNode = SKSpriteNode(texture: starNodeTexture, size: starNode.size)
        starNode.addGlow(radius: 10)
        
        starNode.name = starType
        
        let heights = [Screen.height/2 - 195,
                       Screen.height/2 - 136,
                       Screen.height/2 - 80,
                       Screen.height/2 - 23,
                       Screen.height/2 + 35,
                       Screen.height/2 + 93]
        
        
        starNode.position = CGPoint(x: CGFloat.random(in: 60...Screen.width-60), y: heights.randomElement()!)
        
        
        starNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: -10, duration: 0.3)))
        starNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: 10, duration: 0.3)))
        
        starNode.run(SKAction.repeatForever(SKAction.sequence([rotateActionSequence])))
        
        effectNode.addChild(starNode)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            starNode.physicsBody = nil
            starNode.physicsBody = SKPhysicsBody(circleOfRadius: 25)
            starNode.physicsBody?.isDynamic = false
            starNode.physicsBody?.categoryBitMask = ColliderType.Invisible
            starNode.physicsBody?.collisionBitMask = ColliderType.Ball
            starNode.physicsBody?.contactTestBitMask = ColliderType.Invisible | ColliderType.Ball
            
            
        })
        
        
        
        
    }
    
    func animateStar(star: SKSpriteNode) {
        
        star.physicsBody = nil
        
        let inflate = SKAction.resize(toWidth: 200, height: 200, duration: 0.2)
        let explode = SKAction.resize(toWidth: 300, height: 300, duration: 0.4)
        
        let moveToCenter = SKAction.move(to: CGPoint(x: Screen.width / 2, y: Screen.height / 2), duration: 1)
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        
        let animationSequence = SKAction.sequence([inflate, explode])
        
        star.run(moveToCenter)
        star.run(animationSequence)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            star.run(fadeOut)
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            star.physicsBody = nil
            self.effectNode.childNode(withName: "pointsStar")?.removeFromParent()
            self.effectNode.childNode(withName: "star_blue")?.removeFromParent()
        })
        
        
    }
    
    let addPoints = SKAction.run {
        
//        if var points = ballsAdded.last.childNode(withName: "lable") as! SKLabelNode {
//            
//        }
        
        pointsCount = pointsCount + 1
        pointsLabelNode.text = "POINTS: \(pointsCount)"
        pointsLabelNode.run(scaleToActionSequence)
        
        if fxOn == true {
            
            let plingAudioAction = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
            let changeVolumeAction = SKAction.changeVolume(to: 0.1, duration: 0.01)
            let plingAudioGroup = SKAction.group([plingAudioAction, changeVolumeAction])
            pointsLabelNode.run(plingAudioGroup)
        }
        
        if pointsCount >= lastHighscore {
            
            lastHighscore = pointsCount
            
            highscoreLabelNode.text = "HIGHSCORE: \(lastHighscore)"
            highscoreLabelNode.run(scaleToActionSequence)
            
            if !highscoreLabelIsInFront {
                
                highscoreLabelNode.run(SKAction.moveBy(x: 0, y: Screen.height * -0.05, duration: 0.5))
                highscoreLabelIsInFront = true
                highscoreLabelNode.fontSize = 26
                highscoreLabelNode.fontName = "LCD14"
                highscoreLabelNode.alpha = 1
                
                pointsLabelNode.alpha = 0
            }
            
            
            
        } else {
            
            highscoreLabelNode.fontSize = 13
            highscoreLabelNode.fontName = "LCD14"
            pointsLabelNode.alpha = 1
        }
    }
    
    let addStarPoints = SKAction.run {
        
        let starTypes = ["pointsStar", "multiStar"]
        
        let ownType = starTypes.randomElement()
        
        if starNode.name == starTypes.first {
            
            pointsCount = pointsCount + 1000
            pointsLabelNode.text = "POINTS: \(pointsCount)"
            
        } else {
            
            multiplyerCount = multiplyerCount + 3
            multiplyerLabelNode.text = "MULTI: \(multiplyerCount)"
        }
        
        
        
        if fxOn == true {
            
            let plingAudioAction = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
            let changeVolumeAction = SKAction.changeVolume(to: 0.1, duration: 0.01)
            let plingAudioGroup = SKAction.group([plingAudioAction, changeVolumeAction])
            pointsLabelNode.run(plingAudioGroup)
        }
        
        if pointsCount >= lastHighscore {
            
            lastHighscore = pointsCount
            highscoreLabelNode.text = "HIGHSCORE: \(lastHighscore)"
            highscoreLabelNode.run(scaleToActionSequence)
            
            if !highscoreLabelIsInFront {
                
                highscoreLabelNode.run(SKAction.moveBy(x: 0, y: Screen.height * -0.05, duration: 0.5))
                highscoreLabelIsInFront = true
            }
            
            highscoreLabelNode.fontSize = 26
            highscoreLabelNode.fontName = "LCD14"
            highscoreLabelNode.alpha = 1
            
            pointsLabelNode.alpha = 0
            
        } else {
            
            highscoreLabelNode.fontSize = 13
            highscoreLabelNode.fontName = "LCD14"
            pointsLabelNode.alpha = 1
        }
    }
    
    func addDownArrows(count: Int) {
        
        let gap = Screen.width / CGFloat(count)
        
        for row in 1...Int(count - 1) {
            
            let arrowPath = CGMutablePath()
            arrowPath.move(to: CGPoint(x: CGFloat(-5) + (CGFloat(row) * gap), y: Screen.height * 0.77))
            arrowPath.addLine(to: CGPoint(x: CGFloat(0) + (CGFloat(row) * gap), y: Screen.height * 0.76))
            arrowPath.addLine(to: CGPoint(x: CGFloat(5) + (CGFloat(row) * gap), y: Screen.height * 0.77))
            
            let arrow = SKShapeNode(path: arrowPath)
            arrow.strokeColor = UIColor.yellow
            arrow.lineWidth = 2
            arrow.alpha = 0.5
            
            let arrow2 = arrow.copy() as! SKShapeNode
            arrow2.position = CGPoint(x: arrow.position.x, y: arrow.position.y - 7.5)
            
            let arrow3 = arrow.copy() as! SKShapeNode
            arrow3.position = CGPoint(x: arrow.position.x, y: arrow.position.y - 15)
            
            
            let arrow1SpriteNode = SKSpriteNode(texture: SKView().texture(from: arrow))
            arrow1SpriteNode.position = CGPoint(x: CGFloat(0) + (CGFloat(row) * gap), y: Screen.height * 0.77)
            
            let arrow2SpriteNode = SKSpriteNode(texture: SKView().texture(from: arrow2))
            arrow2SpriteNode.position = CGPoint(x: CGFloat(0) + (CGFloat(row) * gap), y: Screen.height * 0.77 - 7.5)
            
            let arrow3SpriteNode = SKSpriteNode(texture: SKView().texture(from: arrow3))
            arrow3SpriteNode.position = CGPoint(x: CGFloat(0) + (CGFloat(row) * gap), y: Screen.height * 0.77 - 15)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(CGFloat(row) * 0.0), execute: {
                self.effectNode.addChild(arrow1SpriteNode)
                self.effectNode.addChild(arrow2SpriteNode)
                self.effectNode.addChild(arrow3SpriteNode)
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
                
//                //print("TAP")
                
//                if vibrationOn {
//                    generator.impactOccurred()
//                }
                
                if backButtonNode.contains(touch.location(in: self)) {
                    
                    //print("<- ab zum Hauptmenü <-")
                    
                    if fxOn {
                        DispatchQueue.main.async {
                            print("PLING!!!")
                            let pling = SKAction.playSoundFileNamed("boing2.mp3", waitForCompletion: false)
                            self.backButtonNode.run(pling)
                        }
                    }
                    
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
                                        if let musicButtonLabel = miniMenu.childNode(withName: "musicButtonLabel") as? SKLabelNode {
                                            musicButtonLabel.text = "MUSIC: OFF"
                                            musicButtonLabel.fontColor = UIColor.red
                                        }
                                    }
                                    backgroundMusicPlayerStatus = false
                                    UserDefaults.standard.set(false, forKey: "backgroundMusicPlayerStatus")
                                } else {
                                    
                                    backgroundMusicPlayer?.play()
                                    if let musicButton = miniMenu.childNode(withName: "musicButton") as? SKSpriteNode {
                                        musicButton.texture = SKTexture(imageNamed: "music-button-on5")
                                        if let musicButtonLabel = miniMenu.childNode(withName: "musicButtonLabel") as? SKLabelNode {
                                            musicButtonLabel.text = "MUSIC: ON"
                                            musicButtonLabel.fontColor = UIColor.green
                                        }
                                    }
                                    backgroundMusicPlayerStatus = true
                                    UserDefaults.standard.set(true, forKey: "backgroundMusicPlayerStatus")
                                }
                                
                            } else if button.name == "fxButton" && button.contains(touch.location(in: self)) {
                                
                                if fxOn == true {
                                    if let fxButton = miniMenu.childNode(withName: "fxButton") as? SKSpriteNode {
                                        fxButton.texture = SKTexture(imageNamed: "fx-button-off")
                                        if let fxButtonLabel = miniMenu.childNode(withName: "fxButtonLabel") as? SKLabelNode {
                                            fxButtonLabel.text = "SOUND-FX: OFF"
                                            fxButtonLabel.fontColor = UIColor.red
                                        }
                                    }
                                    fxOn = false
                                    UserDefaults.standard.set(false, forKey: "fxOn")
                                } else {
                                    if let fxButton = miniMenu.childNode(withName: "fxButton") as? SKSpriteNode {
                                        fxButton.texture = SKTexture(imageNamed: "fx-button-on")
                                        if let fxButtonLabel = miniMenu.childNode(withName: "fxButtonLabel") as? SKLabelNode {
                                            fxButtonLabel.text = "SOUND-FX: ON"
                                            fxButtonLabel.fontColor = UIColor.green
                                        }
                                    }
                                    fxOn = true
                                    UserDefaults.standard.set(true, forKey: "fxOn")
                                }
                                
                            } else if button.name == "vibrationButton" && button.contains(touch.location(in: self)) {
                                
                                if vibrationOn == true {
                                    if let vibrationButton = miniMenu.childNode(withName: "vibrationButton") as? SKSpriteNode {
                                        vibrationButton.texture = SKTexture(imageNamed: "vibration-button-off")
                                        if let vibrationButtonLabel = miniMenu.childNode(withName: "vibrationButtonLabel") as? SKLabelNode {
                                            vibrationButtonLabel.text = "VIBRATION: OFF"
                                            vibrationButtonLabel.fontColor = UIColor.red
                                        }
                                    }
                                    vibrationOn = false
                                    UserDefaults.standard.set(false, forKey: "vibrationOn")
                                    
                                } else {
                                    if let fxButton = miniMenu.childNode(withName: "vibrationButton") as? SKSpriteNode {
                                        fxButton.texture = SKTexture(imageNamed: "vibration-button-on")
                                        if let vibrationButtonLabel = miniMenu.childNode(withName: "vibrationButtonLabel") as? SKLabelNode {
                                            vibrationButtonLabel.text = "VIBRATION: ON"
                                            vibrationButtonLabel.fontColor = UIColor.green
                                        }
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
                    
                } else if controlBallBool && touch.location(in: self).y <= Screen.height * 0.8 {
                    ball.position.x = touch.location(in: self).x
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            if controlBallBool && !settingsButtonNode.contains(touches.first!.location(in: self)) && !miniMenu.contains(touch.location(in: self)) && touch.location(in: self).y <= Screen.height * 0.8 {
                ball.position.x = touch.location(in: self).x
            } else if touch.location(in: self).y > Screen.height * 0.8 {
                ball.position.x = Screen.width / 2
            }

        }
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        //print("TOUCH UP ---")
    }
    
    func openMenu() {
        
        let nodesToBlendOut = [pointsLabelNode, highscoreLabelNode, ballCounterLabelNode, multiplyerLabelNode]
        for node in nodesToBlendOut {
            node.isHidden = true
        }
        
        let nodesToBlendIn = [miniMenu]
        for node in nodesToBlendIn {
            
            node.isHidden = false
        }
        
        settingsButtonNode.texture = SKTexture(imageNamed: "settings-button-close")
        
        menuOpen = true
    }
    
    func closeMenu() {
        
        let nodesToBlendOut = [miniMenu]
        for node in nodesToBlendOut {
            node.isHidden = true
        }
        
        let nodesToBlendIn = [pointsLabelNode, highscoreLabelNode, ballCounterLabelNode, multiplyerLabelNode]
        for node in nodesToBlendIn {
            
            node.isHidden = false
            
        }
        
        settingsButtonNode.texture = SKTexture(imageNamed: "settings-button5")
        
        menuOpen = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        
//        //print("TOUCH ENDED ---")
        
        if settingsButtonNode.contains(touches.first!.location(in: self)) || miniMenu.contains(touches.first!.location(in: self)) {
            
            
        } else if touches.first!.location(in: self).y <= Screen.height * 0.8 {
            
            if controlBallBool && ballCount > 0 {
                controlBallBool = false
                ballsAdded.last!.physicsBody!.isDynamic = true
//                for child in ballsAdded.last!.children {
//                    child.physicsBody!.isDynamic = true
//                }
                ballCount = ballCount - 1
                ballCounterLabelNode.text = "BALLS: X\(ballCount)"
                if ballCount == 0 {
                    ballCounterLabelNode.fontColor = .red
                }
                if ballCount >= 1 {
                    self.controlBallBool = false
                    self.prepareBall()
                }
                
            }
            
        }
        
        if gameOver {
            self.effectNode.removeAllChildren()
            self.effectNode.removeAllActions()
            self.removeAllChildren()
            self.removeAllActions()
            SceneManager.shared.transition(self, toScene: .Level1, transition: SKTransition.fade(withDuration: 0.5))
            
        }
    }
    
    func showEndScreen() {
        
        self.view?.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = false
        
        let backgroundLayer = SKShapeNode(rectOf: CGSize(width: Screen.width, height: Screen.height))
        backgroundLayer.fillColor = UIColor(hexFromString: "323232")
        backgroundLayer.strokeColor = UIColor(hexFromString: "323232")
        backgroundLayer.position = CGPoint(x: Screen.width / 2, y: Screen.height / 2)
        backgroundLayer.alpha = 0
        backgroundLayer.zPosition = 10000
        
        let gameLabelNode = SKLabelNode(text: "GAME")
        gameLabelNode.fontSize = 100
        gameLabelNode.fontName = "LCD14"
        gameLabelNode.fontColor = UIColor(hexFromString: "d800ff")
        gameLabelNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.72)
        gameLabelNode.alpha = 0
        gameLabelNode.zPosition = 10100
        
        let overLabelNode = SKLabelNode(text: "OVER")
        overLabelNode.fontSize = 100
        overLabelNode.fontName = "LCD14"
        overLabelNode.fontColor = UIColor(hexFromString: "d800ff")
        overLabelNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.6)
        overLabelNode.alpha = 0
        overLabelNode.zPosition = 10100
        
        let highscoreLabelNode = SKLabelNode(text: "NEW HIGHSCORE")
        highscoreLabelNode.fontSize = 30
        highscoreLabelNode.fontName = "LCD14"
        highscoreLabelNode.fontColor = Color.yellow
        highscoreLabelNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.45)
        highscoreLabelNode.alpha = 0
        highscoreLabelNode.zPosition = 10100
        
        let highscorePointsLabelNode = SKLabelNode(text: "\(lastHighscore)")
        highscorePointsLabelNode.fontSize = 60
        highscorePointsLabelNode.fontName = "LCD14"
        highscorePointsLabelNode.fontColor = Color.yellow
        highscorePointsLabelNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.35)
        highscorePointsLabelNode.alpha = 0
        highscorePointsLabelNode.zPosition = 10100
        
        let pointsLabelNode = SKLabelNode(text: "POINTS: ")
        pointsLabelNode.horizontalAlignmentMode = .center
        pointsLabelNode.fontSize = 40
        pointsLabelNode.fontName = "LCD14"
        pointsLabelNode.fontColor = UIColor(hexFromString: "0099ff")
        pointsLabelNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.45)
        pointsLabelNode.alpha = 0
        pointsLabelNode.zPosition = 10100
        
        let pointsPointsLabelNode = SKLabelNode(text: "\(pointsCount)")
        pointsPointsLabelNode.horizontalAlignmentMode = .center
        pointsPointsLabelNode.fontSize = 50
        pointsPointsLabelNode.fontName = "LCD14"
        pointsPointsLabelNode.fontColor = UIColor(hexFromString: "0099ff")
        pointsPointsLabelNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.365)
        pointsPointsLabelNode.alpha = 0
        pointsPointsLabelNode.zPosition = 10100
        
        let multiplyerLabelNode = SKLabelNode(text: "X\(multiplyerCount)")
        multiplyerLabelNode.horizontalAlignmentMode = .center
        multiplyerLabelNode.fontSize = 30
        multiplyerLabelNode.fontName = "LCD14"
        multiplyerLabelNode.fontColor = Color.yellow
        multiplyerLabelNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.29)
        multiplyerLabelNode.alpha = 0
        multiplyerLabelNode.zPosition = 10100
        
        let restartLabelNode = SKLabelNode(text: "TAP ANYWHERE TO RESTART")
        restartLabelNode.preferredMaxLayoutWidth = Screen.width * 0.9
        restartLabelNode.fontSize = 20
        restartLabelNode.fontName = "LCD14"
        restartLabelNode.fontColor = UIColor.green
        restartLabelNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.14)
        restartLabelNode.alpha = 0
        restartLabelNode.zPosition = 10100
        
        effectNode.addChild(backgroundLayer)
        effectNode.addChild(gameLabelNode)
        effectNode.addChild(overLabelNode)
        effectNode.addChild(pointsLabelNode)
        effectNode.addChild(pointsPointsLabelNode)
        effectNode.addChild(restartLabelNode)
        effectNode.addChild(highscoreLabelNode)
        effectNode.addChild(highscorePointsLabelNode)
        effectNode.addChild(multiplyerLabelNode)
        
        backgroundLayer.run(SKAction.fadeAlpha(to: 0.9, duration: 0.35))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            gameLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
            overLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
        })

        let scaleUpAction = SKAction.scale(to: 0.9, duration: 0.4)
        let scaleDownAction = SKAction.scale(to: 1.05, duration: 0.4)
        let scaleSequenze = SKAction.sequence([scaleUpAction, scaleDownAction])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if highscoreLabelIsInFront {
                highscoreLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                highscorePointsLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                highscorePointsLabelNode.run(SKAction.repeatForever(scaleSequenze))
                multiplyerLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                multiplyerLabelNode.run(SKAction.repeatForever(scaleSequenze))
                
            } else {
                pointsLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                pointsPointsLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                multiplyerLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                multiplyerLabelNode.run(SKAction.repeatForever(scaleSequenze))
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.75, execute: {
            
                
            let duration: Double = 2.0 //seconds
            let endValue = pointsCount * multiplyerCount
            
//            self.saveStats()
            
            if highscoreLabelIsInFront == true {
                
                DispatchQueue.global().async {
                    
                    for i in pointsCount ... endValue {
                        
                        pointsCount = i
                        
                        let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                        usleep(sleepTime)
                        DispatchQueue.main.async {
                            highscorePointsLabelNode.text = "\(i)"
                            
                        }
                        if i == endValue {
                            
                            self.saveStats()
                        }
                    }
                    
                    pointsPointsLabelNode.run(SKAction.repeatForever(scaleSequenze))
                    multiplyerLabelNode.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
                    
                }
                
            } else {
                
                DispatchQueue.global().async {
                    
                    for i in pointsCount ... endValue {
                        
                        pointsCount = i
                        
                        var sleepTime = Double(0)
                        
                        if endValue != 0 {
                            sleepTime = Double(duration/Double(endValue) * 1000000.0)
                            usleep(UInt32(sleepTime))
                        } else if sleepTime.isNaN || sleepTime.isInfinite || sleepTime.isSignalingNaN {
                            usleep(0)
                        }
                        
                        
                        DispatchQueue.main.async {
                            
                            if (i >= lastHighscore) {
                                
                                if !highscoreLabelIsInFront {
                                    highscoreLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                                    highscorePointsLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                                    highscorePointsLabelNode.run(SKAction.repeatForever(scaleSequenze))
                                    pointsLabelNode.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
                                    pointsPointsLabelNode.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
                                    multiplyerLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
                                    multiplyerLabelNode.run(SKAction.repeatForever(scaleSequenze))
                                    highscoreLabelIsInFront = true
                                }
                                
                                highscorePointsLabelNode.text = "\(i)"
                                
                            }
                            
                            if i == endValue {
                                
                                self.saveStats()
                            }
                            
                        }
                        
                        pointsPointsLabelNode.text = "\(i)"
                        
                    }
                    
                    multiplyerLabelNode.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
                    
                }
                
                
            }
            
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.view?.isUserInteractionEnabled = true
                self.isUserInteractionEnabled = true
            })
            
            restartLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
//            self.saveStats()
        })
        
        
    }
    
    
    var obstacleStrikeCount = 0
    
    func didBegin(_ contact: SKPhysicsContact) {
        //        //print("KONTAKT")
        

        print(contact.bodyA.node?.name as Any)
        print(contact.bodyB.node?.name as Any)
        
        if (contact.bodyA.node != nil) && (contact.bodyB.node != nil) {
            //            //print("KONTAKT1")
            if ((contact.bodyA.node?.name) != nil) && ((contact.bodyB.node?.name) != nil) {
                //                //print("KONTAKT2")
                if (contact.bodyA.node?.name?.contains("ball"))! || (contact.bodyB.node?.name?.contains("ball"))! {
                    //                    //print("KONTAKT3")
                    
                    if contact.collisionImpulse >= 1.5 {
                        if vibrationOn {
                            generator.impactOccurred()
                        }
                        
                    }
                    
                    for box in 0...boxes.count - 1 {
                        if boxes[box].contains(contact.bodyB.node!.position) {
                            if boxesCollected.contains(false) {
                                let multiplier = multiplyers[box - 1]
                                
                                if boxesCollected[box] == false {
                                    multiplyerCount = multiplyerCount + multiplier
                                    multiplyerLabelNode.text = "MULTI: X\(multiplyerCount)"
                                    
                                    multiplyerLabelNode.run(scaleByActionSequence)
                                    
                                    if boxes[box].children.count >= 1 {
                                        boxes[box].children.last?.run(fadeDownDoubleSpeedAction)
                                    }
                                }
                                
                                
                                if pointsCount >= lastHighscore {
                                    
                                    lastHighscore = pointsCount
                                    highscoreLabelNode.text = "HIGHSCORE: \(lastHighscore)"
                                    
                                    if !highscoreLabelIsInFront {
                                        highscoreLabelNode.run(SKAction.moveBy(x: 0, y: Screen.height * -0.05, duration: 0.5))
                                        highscoreLabelNode.fontSize = 26
                                        highscoreLabelNode.fontName = "LCD14"
                                        highscoreLabelNode.alpha = 1
                                        highscoreLabelIsInFront = true
                                        pointsLabelNode.alpha = 0
                                        
                                    }
                                    
                                } else {
                                    highscoreLabelNode.fontSize = 13
                                    highscoreLabelNode.fontName = "LCD14"
                                    pointsLabelNode.alpha = 1

//                                        pointsLabelNode.text = "POINTS: \(pointsCount)"
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
                                    if ballsAdded[ball].position.y <= Screen.height * 0.09 {
                                        
                                        ballsDown[ball] = true
                                        if !ballsDown.contains(false) {
                                            
                                            if gameOver == false {
                                                
                                                if menuOpen == true {
                                                    closeMenu()
                                                    self.settingsButtonNode.isUserInteractionEnabled = false
                                                }
                                                
                                                self.view?.isUserInteractionEnabled = false
                                                self.isUserInteractionEnabled = false
                                                gameOver = true
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                                    
                                                    self.showEndScreen()
                                                })

//                                                self.saveStats()
                                                
                                                
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
                    pointsLabelNode.run(scaleToActionSequence)
                    
                    let miniPointsLabelNode = SKLabelNode(text: "+1")
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
                    effectNode.addChild(miniPointsLabelSpriteNode)
                    miniPointsLabelSpriteNode.run(actionSequence)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                        miniPointsLabelSpriteNode.removeFromParent()
                    })
                    
                    
                }
                
                
                if (contact.bodyA.node?.name?.contains("pointsStar"))! || (contact.bodyA.node?.name?.contains("multiStar"))! || (contact.bodyB.node?.name?.contains("pointsStar"))! || (contact.bodyB.node?.name?.contains("multiStar"))! {
                    contact.bodyA.node?.run(scalePlusPointsActionSequence)
                    pointsLabelNode.run(scaleToActionSequence)
                    
                    let miniPointsLabelNode = SKLabelNode(text: "")
                    if (starNode.name?.contains("points"))! {
                        miniPointsLabelNode.text = "+1000 POINTS"
                        miniPointsLabelNode.fontColor = UIColor.init(hexFromString: "0099ff")
                    } else if (starNode.name?.contains("multi"))! {
                        miniPointsLabelNode.text = "X3 MULTI"
                        miniPointsLabelNode.fontColor = UIColor.yellow
                    }
                    
                    
                    miniPointsLabelNode.fontSize = 30
                    miniPointsLabelNode.alpha = 1
                    miniPointsLabelNode.fontName = "LCD14"
                    miniPointsLabelNode.horizontalAlignmentMode = .center
                    
                    let scaleAction = SKAction.scale(to: 1.2, duration: 0.5)
                    let moveAction = SKAction.moveBy(x: 0, y: 100, duration: 0.5)
                    let actionSequence = SKAction.sequence([scaleAction, moveAction])
                    
                    let miniPointsLabelSpriteNode = SKSpriteNode(texture: SKView().texture(from: miniPointsLabelNode))
                    miniPointsLabelSpriteNode.position = CGPoint(x: contact.bodyA.node!.position.x, y: contact.bodyA.node!.position.y + 50)
                    miniPointsLabelSpriteNode.setScale(0.1)
                    effectNode.addChild(miniPointsLabelSpriteNode)
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
    
    func saveStats() {
        
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "totalPointsCollected") + pointsCount, forKey: "totalPointsCollected")
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "totalBallsDropped") + 5, forKey: "totalBallsDropped")
        if pointsCount > lastHighscore {
            lastHighscore = pointsCount
        }
        UserDefaults.standard.set(lastHighscore, forKey: "highscore")
        //print("-STATS SAVED!")
        //print("---totalPointsCollected = \(UserDefaults.standard.integer(forKey: "totalPointsCollected"))")
        //print("---totalBallsDropped = \(UserDefaults.standard.integer(forKey: "totalBallsDropped"))")
        //print("---highscore = \(UserDefaults.standard.integer(forKey: "highscore"))")
    }
    
    func saveHighScore() {
        
        let newHighscore = lastHighscore
        
        UserDefaults.standard.set(newHighscore, forKey: "highscore")
        
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
