//
//  GameLevel.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 15.03.19.
//  Copyright © 2019 me. All rights reserved.
//

import GameKit
import EFCountingLabel

//MARK:--- STRUCT FOR PHYSICSBODYS ---
struct ColliderType {
    static let Ball: UInt32             = 0x1 << 0 // 1
    static let Obstacle: UInt32         = 0x1 << 1 // 2
    static let Line: UInt32             = 0x1 << 2 // 4
    static let Box: UInt32              = 0x1 << 3 // 8
    static let BottomLine: UInt32       = 0x1 << 4 // 16
    static let Collectible: UInt32      = 0x1 << 5 // 32
    static let Scene: UInt32            = 0x1 << 6 // 64
}




//MARK:--- CLASS ---
class GameLevel: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate {
    
    
    
    
//MARK:--- VARS & INSTANCES ---
    
    //MARK: __ LEVEL __
    let playerName = UserDefaults.standard.string(forKey: "playerName")
    let effectNode = SKEffectNode()
    let starFieldNode = SKShapeNode()
    let miniMenuButtonNode = SKSpriteNode(imageNamed: "settings-button5")
    var menuOpen = false
    let backButtonNode = SKSpriteNode(imageNamed: "back-button4")
    var boxes = [SKShapeNode()]
    var boxesCollected = [false, false, false, false, false, false] // TODO: WTF? WHY 6 ?
    
    //MARK: __ COUNTER __
    var ballCounterLabelNode = SKLabelNode()
    var multiplyers = [Int()]
    var totalPointsCollected = 0
    
    //MARK: __ BALLS __
    var ballsAdded = [SKShapeNode]()
    var ball = SKShapeNode()
    var ballCount = 5
    var ballsDown:[Bool] = []
    var controlBallBool = false
    var totalBallsDropped = 0
    var ballsAreGhosted = false
//    var ballPrepared = false
    
    //MARK: __ COLLECTIBLES __
    let allCollectibles = CollectiblesData().allCollectibles()
    var currentCollectible = Collectible(name: "", texture: SKTexture(), description: "", points: 0, multi: 0, seconds: 0, miniLabelText: "", freeAtPrestigeLevel: 0, color: .clear, action: SKAction())
    var collectibleNode = SKSpriteNode()
    
    //MARK: __ ACTIONS __
    let fadeoutAction05s = SKAction.fadeAlpha(to: 0, duration: 0.5)
    var endscreenIsCounting = false
    let restartLabelNode = SKLabelNode(text: "TAP ANYWHERE TO RESTART")
    var endscreenPointsCountingLabel = EFCountingLabel(frame: CGRect(x: 0, y: Screen.height * 0.56, width: Screen.width, height: 50))
    var endscreenMultiplyerLabelNode = EFCountingLabel(frame: CGRect(x: 0, y: Screen.height * 0.71, width: Screen.width, height: 50))
    
    
    
    
    //MARK:--- INIT ---
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        self.backgroundColor = UIColor(hexFromString: "140032")
        
        self.addChild(effectNode)
        
        highscoreLabelIsInFront = false
        
        gameOver = false
        
        vibrationOn = UserDefaults.standard.bool(forKey: "vibrationOn")
        
        scalePlusPointsActionSequence = SKAction.sequence([addPoints, SKAction.scale(to: 1.5, duration: 0.1), SKAction.scale(to: 1, duration: 0.6)])
        
        prepareLevel()
        
        prepareBall()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 2...15)) {
            self.addRandomCollectible()
        }
        Bool.random() ? nil : DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 30...250)) {
            self.addExtraBallCollectible()
        }
        
        if tutorialShown == false {
            showTutorial()
        }
        
        if menuOpen == true {
            closeMenu()
        }
        
        let sceneEdgeLoop = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.scene!.physicsBody = sceneEdgeLoop
        self.scene?.physicsBody?.friction = 500
        self.scene!.anchorPoint = CGPoint(x: 0, y: 0)
        self.scene!.physicsBody!.categoryBitMask = ColliderType.Scene       // Who am i ?
        self.scene!.physicsBody!.collisionBitMask = ColliderType.Ball       // Who do i want to collide with?
        self.scene!.physicsBody!.contactTestBitMask = ColliderType.Ball   // Test and tell "didBeginContact()" that "ColliderType.Scene" has contact with "ColliderType.Ball"                                             // !!! BUT BE AWARE !!! THIS TEST COSTS PERFORMANCE !!!
    }
    
//    func addFilterToScreen() {
//
////        let pixelFilter = CIFilter(name: "CIPixellate")
////        pixelFilter!.setValue(10.0, forKey: "inputScale")
////
////        let blurFilter = CIFilter(name: "CIComicEffect")
////        blurFilter!.setValue(5.0, forKey: "inputRadius")
////
////        let bloomFilter = CIFilter(name: "CIBloom")
////
////        let hatchedFilter = CIFilter(name: "CIHatchedScreen")
////
////        let dotScreenFilter = CIFilter(name: "CIDotScreen")
////
////        let motionBlurFilter = CIFilter(name: "CIMotionBlur")
////
////        effectNode.filter = motionBlurFilter
//    }
    
    
    
    
    //MARK:--- TUTORIAL ---
    func showTutorial() {
        self.view?.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = false
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                let rushInAction = SKAction.move(to: CGPoint(x: Screen.width * 0.575, y: Screen.height * 0.4), duration: 0.4)
                fingerNode.run(rushInAction)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
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
                                    self.isUserInteractionEnabled = true
                                })
                            })
                        })
                    })
                })
            })
        })
    }
    
    
    
    
    //MARK:--- PREPARE LEVEL FUNCTIONS ---
    func prepareLevel() {
        
        addHighscoreLableNode()
        
        addBallCounterNode()
        
        addMultiplyerCounterNode()
        
        addPointsLabelNode()
        
        addStarFieldNode()
        
        addBackButtonNode()
        
        addMenuButtonNode()
        
        addStartGlowLine()
        
        addBoxes(count: 5)
        
        addObstacles()

        addSideLines()
        
        addDownArrows(count: 7)
        
        prepareMiniMenu()
        
    }
    
    func addStarFieldNode() {
        DispatchQueue.main.async {
            let fieldNode = SKNode()
            for _ in 0...250 {
                let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.05...0.12))
                star.fillColor = .white
                star.glowWidth = CGFloat.random(in: 0.02...0.8)
                star.alpha = CGFloat.random(in: 0.1...0.3)
                
                star.position = CGPoint(x: CGFloat.random(in: 0...Screen.width), y: CGFloat.random(in: 0...Screen.height))
                fieldNode.addChild(star)
            }
            let fieldNodeSpriteNode = SKSpriteNode(texture: SKView().texture(from: fieldNode))
            fieldNodeSpriteNode.anchorPoint = .init(x: 0, y: 1)
            fieldNodeSpriteNode.position = CGPoint(x: 0, y: Screen.height)
            fieldNodeSpriteNode.zPosition = -1000
            self.addChild(fieldNodeSpriteNode)
        }
    }
    
    func addBackButtonNode() {
        let backButtonAspectRatio = backButtonNode.size.width/backButtonNode.size.height
        backButtonNode.size = CGSize(width: Screen.width * 0.1, height: Screen.width * 0.1 / backButtonAspectRatio)
        backButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backButtonNode.position = CGPoint(x: Screen.width * 0.1, y: Screen.height * 0.95)
        backButtonNode.alpha = 0.9
        effectNode.addChild(backButtonNode)
    }
    
    func addMenuButtonNode() {
        let menuButtonAspectRatio = miniMenuButtonNode.size.width/miniMenuButtonNode.size.height
        miniMenuButtonNode.size = CGSize(width: Screen.width * 0.1, height: Screen.width * 0.1 / menuButtonAspectRatio)
        miniMenuButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        miniMenuButtonNode.position = CGPoint(x: Screen.width * 0.9, y: Screen.height * 0.95)
        miniMenuButtonNode.alpha = 0.9
        effectNode.addChild(miniMenuButtonNode)
    }
    
    func addPointsLabelNode(delayed: Bool = false) {
        pointsCount = 0
        pointsLabelNode.text = "POINTS: \(pointsCount)"
        pointsLabelNode.fontSize = 28
        pointsLabelNode.alpha = 1
        pointsLabelNode.fontName = "PixelSplitter"
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
    
    func addBallCounterNode(delayed: Bool = false) {
        ballCounterLabelNode = SKLabelNode(text: "BALLS: \(ballCount)")
        if ballCount == 0 {
            ballCounterLabelNode.fontColor = .red
        }
        ballCounterLabelNode.fontName = "PixelSplitter"
        ballCounterLabelNode.setScale(0.35)
        ballCounterLabelNode.position = CGPoint(x: Screen.width * 0.02, y: Screen.height * 0.83)
        ballCounterLabelNode.horizontalAlignmentMode = .left
        ballCounterLabelNode.fontColor = Color.yellow
        effectNode.addChild(ballCounterLabelNode)
    }
    
    func addMultiplyerCounterNode() {
        multiplyerLabelNode = SKLabelNode()
        multiplyerCount = 0
        multiplyerLabelNode.text = "MULTI: X\(multiplyerCount)"
        multiplyerLabelNode.fontName = "PixelSplitter"
        multiplyerLabelNode.setScale(0.35)
        multiplyerLabelNode.horizontalAlignmentMode = .right
        multiplyerLabelNode.position = CGPoint(x: Screen.width * 0.979, y: Screen.height * 0.83)
        multiplyerLabelNode.fontColor = UIColor(hexFromString: "d800ff")
        multiplyerLabelNode.alpha = 1
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
                obstacleNode.physicsBody?.categoryBitMask = ColliderType.Obstacle   // Who am i ?
                obstacleNode.physicsBody?.collisionBitMask = ColliderType.Ball      // Who do i want to collide with?
                obstacleNode.physicsBody?.contactTestBitMask = ColliderType.Ball    // Test and tell "didBeginContact()" that "ColliderType.Obstacle" has contact with "ColliderType.Ball"
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
                    obstacleNode.physicsBody?.categoryBitMask = ColliderType.Obstacle   // Who am i ?
                    obstacleNode.physicsBody?.collisionBitMask = ColliderType.Ball      // Who do i want to collide with?
                    obstacleNode.physicsBody?.contactTestBitMask = ColliderType.Ball    // Test and tell "didBeginContact()" that "ColliderType.NonBall" has contact with "ColliderType.Ball"
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
        let boxWidth = Screen.width / CGFloat(count)
        for boxNumber in 0...count - 1 {
            if boxNumber == 0 {
                boxes.removeAll()
            }
            let box = SKShapeNode(rectOf: CGSize(width: boxWidth, height: Screen.height * 0.1))
            box.position = CGPoint(x: boxWidth * (CGFloat(boxNumber + 1) - 0.5), y: Screen.height * 0.05)
            box.fillColor = UIColor(hexFromString: "0099ff").withAlphaComponent(0.3)
            box.strokeColor = UIColor(hexFromString: "0099ff").withAlphaComponent(0.3)
            box.glowWidth = 5
            box.lineWidth = 0.1
            box.zPosition = ball.zPosition + 10
            box.name = "box\(boxNumber)"
            box.physicsBody = SKPhysicsBody(edgeLoopFrom: box.path!)
            box.physicsBody?.isDynamic = false
            box.physicsBody!.categoryBitMask = ColliderType.Box             // Who am i ?
            box.physicsBody!.collisionBitMask = ColliderType.Box         // Who do i want to collide with?
            box.physicsBody!.contactTestBitMask = ColliderType.Ball         // Test and tell "didBeginContact()" that "ColliderType.Box" has contact with "ColliderType.Ball"
            multiplyers = [1,2,3,2,1]
            let multiplierLabelNode = SKLabelNode(text: "X\(multiplyers[boxNumber])")
            multiplierLabelNode.fontName = "PixelSplitter"
            multiplierLabelNode.fontSize = 24
            multiplierLabelNode.fontColor = Color.yellow
            multiplierLabelNode.name = "multiplierLabelNode"
            box.addChild(multiplierLabelNode)
            
            boxes.append(box)
            effectNode.addChild(box)
        }
        for line in 1...count - 1 {
            let linePath = CGMutablePath()
            linePath.move(to: CGPoint(x: boxWidth * CGFloat(line), y: 0))
            linePath.addLine(to: CGPoint(x: boxWidth * CGFloat(line), y: Screen.height * 0.1))
            let lineNode = SKShapeNode(path: linePath)
            lineNode.name = "line\(line)"
            lineNode.strokeColor = UIColor(hexFromString: "0099ff")
            lineNode.lineCap = .round
            lineNode.lineWidth = 6
            lineNode.glowWidth = 0
            lineNode.zPosition = ball.zPosition + 20
            lineNode.physicsBody = SKPhysicsBody(edgeLoopFrom: linePath)
            lineNode.physicsBody?.isDynamic = false
            lineNode.physicsBody?.categoryBitMask = ColliderType.Line           // Who am i ?
            lineNode.physicsBody?.collisionBitMask = ColliderType.Ball          // Who do i want to collide with?
            lineNode.physicsBody?.contactTestBitMask = ColliderType.Ball      // Test and tell "didBeginContact()" that "ColliderType.Line" has contact with "ColliderType.Ball"
            let lineGlow = lineNode.copy() as! SKShapeNode
            lineGlow.strokeColor = UIColor(hexFromString: "0099ff")
            lineGlow.lineWidth = 1
            lineGlow.glowWidth = 16
            lineGlow.alpha = 0.4
            let lineGlowSpriteNode = SKSpriteNode(texture: SKView().texture(from: lineGlow))
            lineGlowSpriteNode.position = CGPoint(x: boxWidth * CGFloat(line), y: 0 - 18)
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
        bottomLineNode.physicsBody?.categoryBitMask = ColliderType.BottomLine   // Who am i ?
        bottomLineNode.physicsBody?.collisionBitMask = ColliderType.Ball        // Who do i want to collide with?
        bottomLineNode.physicsBody?.contactTestBitMask = ColliderType.Ball      // Test and tell "didBeginContact()" that "ColliderType.BottomLine" has contact with "ColliderType.Ball"
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
        sideLineLeftNode.physicsBody?.categoryBitMask = ColliderType.Line           // Who am i ?
        sideLineLeftNode.physicsBody?.collisionBitMask = ColliderType.Ball          // Who do i want to collide with?
        //sideLineLeftNode.physicsBody?.contactTestBitMask = ColliderType.Ball      // Test and tell "didBeginContact()" that "ColliderType.Line" has contact with "ColliderType.Ball"
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
        sideLineRightNode.physicsBody?.categoryBitMask = ColliderType.Line          // Who am i ?
        sideLineRightNode.physicsBody?.collisionBitMask = ColliderType.Ball         // Who do i want to collide with?
        //sideLineRightNode.physicsBody?.contactTestBitMask = ColliderType.Ball  // Test and tell "didBeginContact()" that "ColliderType.Line" has contact with "ColliderType.Ball"
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
        highscoreLabelNode.fontName = "PixelSplitter"
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
    
    func prepareBall(duration:Double = 5) {
        var totalDuration = duration
        ball = Ball().create()
        ball.zPosition = 10
        ball.alpha = 0.65
        ball.position = CGPoint(x: Screen.width / 2 + 0.1, y: Screen.height * 0.78)
        ball.name = "ball\(ballsAdded.count)"
        ball.strokeColor = .red
        (ball.children.first as! SKLabelNode).fontColor = .red
        
        ball.setScale(0.01)
        effectNode.addChild(ball)
        if ballsAdded.count == 0 {
            totalDuration = 0
        }
        
        ball.run(SKAction.scale(to: 1, duration: TimeInterval(totalDuration)))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration + 0.01, execute: {
            print("self.ballsAdded.count = \(self.ballsAdded.count)")
            
            self.ball.zPosition = 300
            self.ball.alpha = 1
            self.ball.strokeColor = .yellow
            (self.ball.children.first as! SKLabelNode).fontColor = .yellow
            self.ball.addGlow(radius: 5)
            self.ball.addGlow(radius: 10, alpha: 0.25)
            self.ball.addGlow(radius: 15, alpha: 0.25)

            self.ball.physicsBody = SKPhysicsBody(circleOfRadius: Screen.width * 0.038 )
            self.ball.physicsBody?.isDynamic = false
            self.ball.physicsBody?.friction = 0
            self.ball.physicsBody?.restitution = 0.45
            self.ball.physicsBody?.categoryBitMask = ColliderType.Ball
            self.ball.physicsBody?.collisionBitMask = ColliderType.Ball | ColliderType.Obstacle | ColliderType.Scene | ColliderType.Line | ColliderType.BottomLine
            self.ball.physicsBody?.contactTestBitMask = ColliderType.Ball | ColliderType.Obstacle | ColliderType.BottomLine | ColliderType.Box | ColliderType.Collectible
            
            self.ballsAdded.append(self.ball)
            self.ballsDown.append(false)
            
            self.controlBallBool = true
        })
        

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
    
    
    
    
    //MARK:--- COLLECTIBLE FUNCTIONS ---
    func addExtraBallCollectible() {
        let availableRows = [   Screen.height/2 - 195,
                                Screen.height/2 - 136,
                                Screen.height/2 - 80,
                                Screen.height/2 - 23,
                                Screen.height/2 + 35,
                                Screen.height/2 + 93
        ]
        let extraBallNode = SKSpriteNode(imageNamed: "heart")
        extraBallNode.size = CGSize(width: 29, height: 29)
        extraBallNode.name = "heart"
        extraBallNode.addGlow()
        extraBallNode.position = CGPoint(x: CGFloat.random(in: 60...Screen.width-60), y: availableRows.randomElement()!)
        extraBallNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: -10, duration: 0.3)))
        extraBallNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: 10, duration: 0.3)))
        extraBallNode.run(SKAction.repeatForever(SKAction.sequence([rotateActionSequence])))
        
        extraBallNode.physicsBody = nil
        extraBallNode.physicsBody = SKPhysicsBody(circleOfRadius: 28)
        extraBallNode.physicsBody?.isDynamic = false
        extraBallNode.physicsBody?.categoryBitMask = ColliderType.Collectible             // Who am i ?
        //extraBallNode.physicsBody?.collisionBitMask = ColliderType.Ball           // Who do i want to collide with?
        extraBallNode.physicsBody?.contactTestBitMask = ColliderType.Ball           // Test and tell "didBeginContact()" that "ColliderType.Extra" has contact with "ColliderType.Ball"
        
        effectNode.addChild(extraBallNode)
    }
    
    func addRandomCollectible() {
        
        var availableCollectibles: [Collectible] = []
        for collectibles in allCollectibles {
            let cacheCollectibles = collectibles.collectibles
            for posiblyFreeCollectible in cacheCollectibles {
                if posiblyFreeCollectible.freeAtPrestigeLevel <= prestigeCount + 1 {
                    availableCollectibles.append(posiblyFreeCollectible)
                }
            }
        }
        
        currentCollectible = availableCollectibles.randomElement()!
        
        collectibleNode = SKSpriteNode(texture: currentCollectible.texture)
        collectibleNode.size = CGSize(width: 29, height: 29)
        collectibleNode.name = currentCollectible.name
        collectibleNode.addGlow()
        
        print("newCollectibleNode.name = \(String(describing: currentCollectible.name))")
        
        let availableRows = [   Screen.height/2 - 195,
                                Screen.height/2 - 136,
                                Screen.height/2 - 80,
                                Screen.height/2 - 23,
                                Screen.height/2 + 35,
                                Screen.height/2 + 93
        ]
        collectibleNode.position = CGPoint(x: CGFloat.random(in: 60...Screen.width-60), y: availableRows.randomElement()!)
        collectibleNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: -10, duration: 0.3)))
        collectibleNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: 10, duration: 0.3)))
        collectibleNode.run(SKAction.repeatForever(SKAction.sequence([rotateActionSequence])))
        
        effectNode.addChild(collectibleNode)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.collectibleNode.physicsBody = nil
            self.collectibleNode.physicsBody = SKPhysicsBody(circleOfRadius: 28)
            self.collectibleNode.physicsBody?.isDynamic = false
            self.collectibleNode.physicsBody?.categoryBitMask = ColliderType.Collectible             // Who am i ?
            //self.extraNode.physicsBody?.collisionBitMask = ColliderType.Ball           // Who do i want to collide with?
            self.collectibleNode.physicsBody?.contactTestBitMask = ColliderType.Ball           // Test and tell "didBeginContact()" that "ColliderType.Extra" has contact with "ColliderType.Ball"
        })
    }
    
    func ghostAllBalls(seconds: Int) {
        ballsAreGhosted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            ballPointValue = ballPointValue * 2
            for ball in self.ballsAdded {
                if let label = ball.children.first as! SKLabelNode? {
                    if ball.physicsBody?.isDynamic == true {
                        label.text = "X\(ballPointValue)"
                    }
                }
            }
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(seconds) + 0.5, execute: {
            ballPointValue = ballPointValue / 2
            for ball in self.ballsAdded {
                if let label = ball.children.first as! SKLabelNode? {
                    label.text = "X\(ballPointValue)"
                }
            }
        })
        
        let fadeOutAction = SKAction.fadeAlpha(to: 0.1, duration: 0.5)
        let waitAction = SKAction.wait(forDuration: TimeInterval(seconds))
        let turnAllBallsOn = SKAction.fadeIn(withDuration: 0.5)
        
        let ghostSequence = SKAction.sequence([fadeOutAction, waitAction, turnAllBallsOn])
        
        for ball in ballsAdded {
            if ball.alpha == 1 {
                ball.run(ghostSequence)
            }
        }
        
    }
    
    func animateCollectibleOnCollision(collidedSpriteNode: SKNode) {
        
        collidedSpriteNode.physicsBody = nil
        collidedSpriteNode.zPosition = 1000000
        for child in collidedSpriteNode.children {
            let childName = child.name
            if (childName?.contains("glow"))! {
                child.removeFromParent()
            }
        }
        
        let miniPointsLabelNode = SKLabelNode(text: currentCollectible.miniLabelText)
        miniPointsLabelNode.fontColor = currentCollectible.color
        miniPointsLabelNode.fontSize = 30
        miniPointsLabelNode.fontName = "PixelSplitter"
        miniPointsLabelNode.horizontalAlignmentMode = .center
        miniPointsLabelNode.zPosition = 1000000
        
        if ((collidedSpriteNode.name != nil) &&  (collidedSpriteNode.name!.contains("heart"))) {
            miniPointsLabelNode.text = "EXTRA BALL"
            miniPointsLabelNode.fontColor = .red
        }
        
        let miniPointsLabelSpriteNode = SKSpriteNode(texture: SKView().texture(from: miniPointsLabelNode))
        miniPointsLabelSpriteNode.position = CGPoint(x: collidedSpriteNode.position.x, y: collidedSpriteNode.position.y + 50)
        miniPointsLabelSpriteNode.setScale(0.1)
        effectNode.addChild(miniPointsLabelSpriteNode)
        
        miniPointsLabelSpriteNode.run(SKAction.scale(to: 1.4, duration: 0.4))
        miniPointsLabelSpriteNode.run(SKAction.move(to: CGPoint(x: Screen.width / 2, y: Screen.height * 0.71), duration: 0.2))
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8, execute: {
            miniPointsLabelSpriteNode.removeFromParent()
        })
        
        let inflate = SKAction.resize(toWidth: 150, height: 150, duration: 0.2)
        let explode = SKAction.resize(toWidth: 250, height: 250, duration: 0.2)
        let moveToCenter = SKAction.move(to: CGPoint(x: Screen.width / 2, y: Screen.height / 2), duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let animationSequence = SKAction.sequence([inflate, explode])
        collidedSpriteNode.run(moveToCenter)
        collidedSpriteNode.run(animationSequence)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4, execute: {
            collidedSpriteNode.run(fadeOut)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            collidedSpriteNode.physicsBody = nil
            collidedSpriteNode.removeFromParent()
        })
    }
    
    
    
    
    //MARK:--- DISPLAY TOUCHES ---
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == touches.first {
                if backButtonNode.contains(touch.location(in: self)) && !gameOver {
                    if fxOn {
                        self.run(pling)
                    }
                    if vibrationOn {
                        runHaptic()
                    }
                    if menuOpen {
                        closeMenu()
                    }
                    self.effectNode.removeAllChildren()
                    self.removeAllChildren()
                    SceneManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.fade(withDuration: 0.5))
                } else if miniMenu.contains(touch.location(in: self)) && menuOpen {
                    if vibrationOn {
                        runHaptic()
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
                                        runHaptic()
                                    }
                                }
                            }
                        }
                    }
                } else if miniMenuButtonNode.contains(touch.location(in: self)) && !gameOver {
                    if vibrationOn {
                        runHaptic()
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
            if controlBallBool && !miniMenuButtonNode.contains(touches.first!.location(in: self)) && !miniMenu.contains(touch.location(in: self)) && touch.location(in: self).y <= Screen.height * 0.8 {
                ball.position.x = touch.location(in: self).x
            } else if touch.location(in: self).y > Screen.height * 0.8 {
                ball.position.x = Screen.width / 2
            }

        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first!.location(in: self).y <= Screen.height * 0.8 {
            if controlBallBool && ballCount > 0 {
                controlBallBool = false
//                ballPrepared = false
                ballsAdded.last!.physicsBody!.isDynamic = true
                
                if let label = ball.children.first as! SKLabelNode? {
                    label.text = "X\(ballPointValue)"
                }
                ballCount = ballCount - 1
                ballCounterLabelNode.text = "BALLS: \(ballCount)"
                if ballCount == 0 {
                    ballCounterLabelNode.fontColor = .red
                }
                if ballCount >= 1 {
                    self.controlBallBool = false
                    self.prepareBall()
                }
            }
        }
        
        if gameOver && !endscreenIsCounting {
            self.effectNode.removeAllChildren()
            self.effectNode.removeAllActions()
            
            self.removeAllChildren()
            
            let restartingLabelNode = SKLabelNode(text: "RESTARTING")
            restartingLabelNode.fontSize = 40
            restartingLabelNode.fontName = "PixelSplitter"
            restartingLabelNode.fontColor = .green
            restartingLabelNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.65)
            restartingLabelNode.alpha = 1
            restartingLabelNode.zPosition = 10100
            self.addChild(restartingLabelNode)
            
            for subview in self.view!.subviews {
                if subview.tag == 1 || subview.tag == 2 {
                    subview.removeFromSuperview()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                SceneManager.shared.transition(self, toScene: .GameLevel, transition: SKTransition.fade(withDuration: 0.01))
            }
        } else if gameOver && endscreenIsCounting {
            
            
            self.endscreenPointsCountingLabel.counter.stopCountAtCurrentValue()
            self.endscreenPointsCountingLabel.counter.countFromCurrentValueTo(CGFloat(pointsCount * multiplyerCount), withDuration: 0.1)
            self.endscreenMultiplyerLabelNode.counter.stopCountAtCurrentValue()
            self.endscreenMultiplyerLabelNode.counter.countFromCurrentValueTo(0, withDuration: 0.1)
            self.restartLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {

                hapticEngine?.stop()
                prepareHaptics()
                
                self.endscreenIsCounting = false
            }
        }
    }
    
    
    
    
    //MARK:--- MENU ---
    func prepareMiniMenu() {
        miniMenu = SKShapeNode(rect: CGRect(x: Screen.width * 0.05, y: Screen.height * 0.825, width: Screen.width * 0.9, height: Screen.height * 0.09), cornerRadius: 8)
        miniMenu.strokeColor = UIColor(hexFromString: "0099ff")
        miniMenu.glowWidth = 3
        
        let miniMenuGlow = miniMenu.copy() as! SKShapeNode
        miniMenuGlow.glowWidth = 10
        miniMenuGlow.lineWidth = 1
        miniMenuGlow.alpha = 0.5
        
        let miniMenuBackground = miniMenu.copy() as! SKShapeNode
        miniMenuBackground.fillColor = UIColor.init(hexFromString: "140032") //UIColor(hexFromString: "120d27")
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
        buttonBackgroundMusicLabelNode.fontName = "PixelSplitter"
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
        buttonFXLabelNode.fontName = "PixelSplitter"
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
        buttonVibrationLabelNode.fontName = "PixelSplitter"
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
    
    func openMenu() {
        let nodesToBlendOut = [pointsLabelNode, highscoreLabelNode, ballCounterLabelNode, multiplyerLabelNode]
        for node in nodesToBlendOut {
            node.isHidden = true
        }
        let nodesToBlendIn = [miniMenu]
        for node in nodesToBlendIn {
            node.isHidden = false
        }
        miniMenuButtonNode.texture = SKTexture(imageNamed: "settings-button-close")
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
        miniMenuButtonNode.texture = SKTexture(imageNamed: "settings-button5")
        menuOpen = false
    }
    
    
    
    
    //MARK:--- POINTS MANAGEMENT ---
    let addPoints = SKAction.run {
                
        pointsCount = pointsCount + ballPointValue
        
        pointsLabelNode.text = "POINTS: \(pointsCount)"
        pointsLabelNode.run(scaleToActionSequence)
        
        if pointsCount >= lastHighscore {
            lastHighscore = pointsCount
            highscoreLabelNode.text = "HIGHSCORE: \(lastHighscore)"
            highscoreLabelNode.run(scaleToActionSequence)
            if !highscoreLabelIsInFront {
                highscoreLabelNode.run(SKAction.moveBy(x: 0, y: Screen.height * -0.05, duration: 0.5))
                highscoreLabelIsInFront = true
                highscoreLabelNode.fontSize = 26
                highscoreLabelNode.fontName = "PixelSplitter"
                highscoreLabelNode.alpha = 1
                pointsLabelNode.alpha = 0
            }
        } else {
            highscoreLabelNode.fontSize = 13
            highscoreLabelNode.fontName = "PixelSplitter"
            pointsLabelNode.alpha = 1
        }
    }
    
    func saveStats() {
        
        if pointsCount * multiplyerCount >= lastHighscore {
            lastHighscore = pointsCount * multiplyerCount
        }
        
        if GKLocalPlayer.local.isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "highscore")
            scoreReporter.value = Int64(lastHighscore)
            let scoreArray:[GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
        
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "totalPointsCollected") + (pointsCount * multiplyerCount), forKey: "totalPointsCollected")
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "totalBallsDropped") + ballsDown.count, forKey: "totalBallsDropped")
        UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "ballsDroppedSincePrestige") + ballsDown.count, forKey: "ballsDroppedSincePrestige")
        ballsDroppedSincePrestige = UserDefaults.standard.integer(forKey: "ballsDroppedSincePrestige")
        
        UserDefaults.standard.set(lastHighscore, forKey: "highscore")

        print("SAVED!!!!!!!!")
    }
    
    
    
    
    //MARK:--- NODE CONTACTS ---
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactBetween: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        
        if contactBetween == ColliderType.Ball | ColliderType.Ball {
            
            var ball1Node: SKShapeNode
            var ball2Node: SKShapeNode
            
            if (contact.bodyA.node?.name!.lowercased().contains("ball"))! {
                ball1Node = contact.bodyB.node! as! SKShapeNode
                ball2Node = contact.bodyA.node! as! SKShapeNode
            } else {
                ball1Node = contact.bodyA.node! as! SKShapeNode
                ball2Node = contact.bodyB.node! as! SKShapeNode
            }
            
            if ball1Node.strokeColor == .yellow && ball2Node.strokeColor == .yellow {
                if vibrationOn {
                    runHaptic(intensity: Float(contact.collisionImpulse), sharpness: 0)
                }
                
            } else {
                
                if vibrationOn {
                    runHaptic(intensity: Float(contact.collisionImpulse), sharpness: 1)
                }
            }
            
            if fxOn == true && contact.collisionImpulse > 5 {
                self.run(pling) //MARK: TODO: CHANGE SOUND!!!
            }
            
            
            
            if ball1Node.strokeColor == .red {
                ball2Node.removeAllChildren()
                ball2Node.removeAllActions()
                ball2Node.strokeColor = .red
                ball2Node.alpha = 0.3
            } else if ball2Node.strokeColor == .red {
                ball1Node.removeAllChildren()
                ball1Node.removeAllActions()
                ball1Node.strokeColor = .red
                ball1Node.alpha = 0.3
            }
            
            
            
            
            
        } else if contactBetween == ColliderType.Ball | ColliderType.Obstacle {
            
            var obstacleNode: SKNode

            if fxOn == true && contact.collisionImpulse > 5 {
                self.run(pling) //MARK: TODO: CHANGE SOUND!!!
            }
            if vibrationOn {
                runHaptic(intensity: Float(contact.collisionImpulse), sharpness: 0)
            }
            
            if (contact.bodyA.node?.name!.lowercased().contains("ball"))! {
                obstacleNode = contact.bodyB.node!
            } else {
                obstacleNode = contact.bodyA.node!
            }
            
            obstacleNode.children.first!.run(scalePlusPointsActionSequence)
            pointsLabelNode.run(scaleToActionSequence)
            
            let miniPointsLabelNode = SKLabelNode(text: "+\(ballPointValue)")
            miniPointsLabelNode.fontSize = 13
            miniPointsLabelNode.alpha = 1
            miniPointsLabelNode.fontName = "PixelSplitter"
            miniPointsLabelNode.horizontalAlignmentMode = .center
            miniPointsLabelNode.fontColor = UIColor(hexFromString: "0099ff")
            
            let scaleAction = SKAction.scale(to: 1, duration: 0.4)
            let moveAction = SKAction.moveBy(x: 0, y: 30, duration: 0.59)
            let actionSequence = SKAction.sequence([scaleAction, moveAction])
            
            let miniPointsLabelSpriteNode = SKSpriteNode(texture: SKView().texture(from: miniPointsLabelNode))
            miniPointsLabelSpriteNode.position = CGPoint(x: obstacleNode.position.x, y: obstacleNode.position.y + 16)
            miniPointsLabelSpriteNode.setScale(0.1)
            effectNode.addChild(miniPointsLabelSpriteNode)
            miniPointsLabelSpriteNode.run(actionSequence)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                miniPointsLabelSpriteNode.removeFromParent()
            })
            
            
            
            
            
            
        } else if contactBetween == ColliderType.Ball | ColliderType.Collectible {
            
            if vibrationOn {
                runHaptic(intensity: 1, sharpness: 0)
            }
            if fxOn == true {
                self.run(pling) //MARK: TODO: CHANGE SOUND!!! MAYBE COLLECTIBLES OWN SOUND?
            }
            
            let collidedCollectible = contact.bodyA.categoryBitMask == ColliderType.Collectible ? contact.bodyA.node! : contact.bodyB.node!
            //MARK: TODO: REPLACE THIS CODEPART vvvvvvvvv WITH SOMETHING LIKE: collectibleNode.run(currentCollectible.action(with: XY some: YX parameters:YX))
            
            if (collectibleNode.name?.lowercased().contains("triangle"))! {
                
                pointsCount = pointsCount + ballPointValue * currentCollectible.points
                pointsLabelNode.text = "POINTS: \(pointsCount)"
                
            } else if (collectibleNode.name?.lowercased().contains("star"))! {
                
                pointsCount = pointsCount + ballPointValue * currentCollectible.points
                pointsLabelNode.text = "POINTS: \(pointsCount)"
                
            } else if (collectibleNode.name?.lowercased().contains("ghost"))! {

                ghostAllBalls(seconds: currentCollectible.seconds)
            }
            
            if pointsCount >= lastHighscore {
                lastHighscore = pointsCount
                highscoreLabelNode.text = "HIGHSCORE: \(lastHighscore)"
                highscoreLabelNode.run(scaleToActionSequence)
                
                if !highscoreLabelIsInFront {
                    
                    highscoreLabelNode.run(SKAction.moveBy(x: 0, y: Screen.height * -0.05, duration: 0.5))
                    highscoreLabelIsInFront = true
                    highscoreLabelNode.fontSize = 26
                    highscoreLabelNode.fontName = "PixelSplitter"
                    highscoreLabelNode.alpha = 1
                    pointsLabelNode.alpha = 0
                }
                
            } else {
                
                highscoreLabelNode.fontSize = 13
                highscoreLabelNode.fontName = "PixelSplitter"
                pointsLabelNode.alpha = 1
            }
            
            if ((collidedCollectible.name != nil) && (collidedCollectible.name!.contains("heart"))) {
                
                ballCount = ballCount + 1
                ballCounterLabelNode.text = "BALLS: \(ballCount)"
                ballCounterLabelNode.fontColor = .yellow
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    if self.ballsAdded.last!.physicsBody!.isDynamic == true {
                        self.prepareBall()
                    }
                }
                
                if (contact.bodyA.node?.name?.contains("heart"))! {
                    animateCollectibleOnCollision(collidedSpriteNode: contact.bodyA.node!)
                } else if (contact.bodyB.node?.name?.contains("heart"))! {
                    animateCollectibleOnCollision(collidedSpriteNode: contact.bodyB.node!)
                }
                
                Bool.random() ? nil : DispatchQueue.main.async {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 60...250)) {
                        if Bool.random() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 45...250)) {
                                self.addExtraBallCollectible()
                            }
                        } else if Bool.random() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 30...250)) {
                                self.addExtraBallCollectible()
                            }
                        } else if Bool.random() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 30...250)) {
                                self.addExtraBallCollectible()
                            }
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 15...250)) {
                                self.addExtraBallCollectible()
                            }
                        }
                    }
                    
                }
                
            } else {
                
                animateCollectibleOnCollision(collidedSpriteNode: collectibleNode)
                DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 6...20)) {
                    self.addRandomCollectible()
                }
                
            }
            
            
            
            
            
        } else if   contactBetween ==  ColliderType.Ball | ColliderType.Line ||
                    contactBetween ==  ColliderType.Ball | ColliderType.BottomLine ||
                    contactBetween ==  ColliderType.Ball | ColliderType.Scene {
            
            var ballNode: SKShapeNode = SKShapeNode()
            var sharpness: Float = 0

            if contact.bodyA.node?.name?.lowercased().contains("ball") ?? false {
                ballNode = contact.bodyA.node! as! SKShapeNode
            } else if contact.bodyB.node?.name?.lowercased().contains("ball") ?? false {
                ballNode = contact.bodyB.node! as! SKShapeNode
            }
            
            if fxOn == true && contact.collisionImpulse > 5 {
                self.run(pling) //MARK: TODO: CHANGE SOUND!!!
            }
            
            
            if ballNode.strokeColor == .red {
                sharpness = 1
            }
            
            if vibrationOn {
               runHaptic(intensity: Float(contact.collisionImpulse), sharpness: sharpness)
            }
            
            
            
            
            
        } else if contactBetween == ColliderType.Ball | ColliderType.Box  {
            
            var ballNode: SKShapeNode = SKShapeNode()
            var boxNode: SKNode = SKNode()
            
            if (contact.bodyA.node?.name!.lowercased().contains("ball"))! {
                ballNode = contact.bodyA.node! as! SKShapeNode
            } else if (contact.bodyB.node?.name!.lowercased().contains("ball"))! {
                ballNode = contact.bodyB.node! as! SKShapeNode
            }
            
            for box in boxes {
                if box.contains(ballNode.position) && (ballNode ).strokeColor != UIColor.red {
                    
                    boxNode = box
                    ballNode.removeAllChildren()
                    ballNode.removeAllActions()
                    ballNode.strokeColor = .red
                    ballNode.alpha = 0.3
                }
            }
            
            if fxOn == true && contact.collisionImpulse > 5 && ballNode.strokeColor != .red {
                self.run(pling) //MARK: TODO: CHANGE SOUND!!!
            }
            
            if vibrationOn {
                runHaptic(intensity: Float(contact.collisionImpulse), sharpness: 1)
            }
            
            for (index, box) in boxes.enumerated() {
                if box.name == boxNode.name && boxesCollected.contains(false) {
                    let multiplier = multiplyers[index]
                        
                    if boxesCollected[index] == false {
                        multiplyerCount = multiplyerCount + multiplier
                        multiplyerLabelNode.text = "MULTI: X\(multiplyerCount)"
                        multiplyerLabelNode.run(scaleByActionSequence)
                        
                        if pointsCount >= lastHighscore {
                            lastHighscore = pointsCount
                            highscoreLabelNode.text = "HIGHSCORE: \(lastHighscore)"
                            if !highscoreLabelIsInFront {
                                
                                highscoreLabelNode.run(SKAction.moveBy(x: 0, y: Screen.height * -0.05, duration: 0.5))
                                highscoreLabelIsInFront = true
                                highscoreLabelNode.fontSize = 26
                                highscoreLabelNode.fontName = "PixelSplitter"
                                highscoreLabelNode.alpha = 1
                                pointsLabelNode.alpha = 0
                                
                            }
                        } else {
                            highscoreLabelNode.fontSize = 13
                            highscoreLabelNode.fontName = "PixelSplitter"
                            pointsLabelNode.alpha = 1
                        }
                        boxesCollected[index] = true
                        let resizeAction = SKAction.resize(toWidth: 0.01, height: 0.01, duration: 0.25)
                        let alphaAction = SKAction.fadeAlpha(to: 0, duration: 0.25)
                        let removeSequence = SKAction.sequence([resizeAction, alphaAction])
                        boxes[index].run(SKAction.fadeAlpha(to: 0.6, duration: 0.25))
                        boxes[index].children.first!.run(removeSequence)
                        
                    }
                    
                }
            }
            
            if ballCount == 0 {
                for index in 0...ballsAdded.count - 1 {
                    if ballsAdded[index].position.y <= Screen.height * 0.09 {
                        ballsDown[index] = true
                        if !ballsDown.contains(false) && gameOver == false {
                            if menuOpen == true {
                                closeMenu()
                                self.miniMenuButtonNode.isUserInteractionEnabled = false
                            }
                            self.view?.isUserInteractionEnabled = false
                            self.isUserInteractionEnabled = false
                            gameOver = true
                            
                            for i in stride(from: 0, to: 1, by: 0.01) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + i) {
                                    runHaptic(intensity: Float(1 - i), sharpness: 0)
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                self.showEndScreen()
                            })
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    //MARK:--- ENDSCREEN ---
    func showEndScreen() {
        
        let backgroundLayer = SKShapeNode(rectOf: CGSize(width: Screen.width, height: Screen.height))
        backgroundLayer.fillColor = UIColor(hexFromString: "140032")
        backgroundLayer.strokeColor = UIColor(hexFromString: "140032")
        backgroundLayer.position = CGPoint(x: Screen.width / 2, y: Screen.height / 2)
        backgroundLayer.alpha = 1
        backgroundLayer.zPosition = 10000
        
        let gameLabelNode = SKLabelNode(text: "GAME")
        gameLabelNode.fontSize = 100
        gameLabelNode.fontName = "PixelSplitter"
        gameLabelNode.fontColor = UIColor(hexFromString: "d800ff")
        gameLabelNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.80)
        gameLabelNode.alpha = 1
        gameLabelNode.zPosition = 10100
        
        let overLabelNode = SKLabelNode(text: "OVER")
        overLabelNode.fontSize = 100
        overLabelNode.fontName = "PixelSplitter"
        overLabelNode.fontColor = UIColor(hexFromString: "d800ff")
        overLabelNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.68)
        overLabelNode.alpha = 1
        overLabelNode.zPosition = 10100
                
        let pointsTitleLabelNode = SKLabelNode(text: "POINTS: ")
        pointsTitleLabelNode.horizontalAlignmentMode = .center
        pointsTitleLabelNode.fontSize = 40
        pointsTitleLabelNode.fontName = "PixelSplitter"
        pointsTitleLabelNode.fontColor = UIColor(hexFromString: "0099ff")
        pointsTitleLabelNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.45)
        pointsTitleLabelNode.alpha = 1
        pointsTitleLabelNode.zPosition = 10100
        
        endscreenPointsCountingLabel.counter.timingFunction = EFTimingFunction.easeInOut(easingRate: 3)
        endscreenPointsCountingLabel.font = UIFont(name: "PixelSplitter", size: 50)
        endscreenPointsCountingLabel.textColor = UIColor(hexFromString: "0099ff")
        endscreenPointsCountingLabel.textAlignment = .center
        endscreenPointsCountingLabel.text = "\(pointsCount)"
        endscreenPointsCountingLabel.alpha = 1
        endscreenPointsCountingLabel.tag = 1
        
        endscreenMultiplyerLabelNode.counter.timingFunction = EFTimingFunction.linear
        endscreenMultiplyerLabelNode.font = UIFont(name: "PixelSplitter", size: 30)
        endscreenMultiplyerLabelNode.textColor = UIColor.yellow
        endscreenMultiplyerLabelNode.textAlignment = .center
        endscreenMultiplyerLabelNode.alpha = 1
        endscreenMultiplyerLabelNode.text = "X\(multiplyerCount)"
        endscreenMultiplyerLabelNode.tag = 2
        
        restartLabelNode.preferredMaxLayoutWidth = Screen.width * 0.9
        restartLabelNode.fontSize = 20
        restartLabelNode.fontName = "PixelSplitter"
        restartLabelNode.fontColor = UIColor.green
        restartLabelNode.position = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.14)
        restartLabelNode.alpha = 0
        restartLabelNode.zPosition = 10100
        
        effectNode.addChild(backgroundLayer)
        effectNode.addChild(gameLabelNode)
        effectNode.addChild(overLabelNode)
        effectNode.addChild(pointsTitleLabelNode)
        self.view!.addSubview(endscreenPointsCountingLabel)
        effectNode.addChild(restartLabelNode)
        self.view!.addSubview(endscreenMultiplyerLabelNode)
        
        backgroundLayer.run(SKAction.fadeAlpha(to: 0.9, duration: 0.35))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            gameLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
            overLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
        })
        
        for subview in self.view!.subviews {
            if subview.tag == 1 {
                endscreenPointsCountingLabel = subview.viewWithTag(1) as! EFCountingLabel
            } else if subview.tag == 2 {
                endscreenMultiplyerLabelNode = subview.viewWithTag(2) as! EFCountingLabel
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            
            self.view?.isUserInteractionEnabled = true
            self.isUserInteractionEnabled = true
            self.endscreenIsCounting = true
            self.endscreenPointsCountingLabel.countFrom(CGFloat(pointsCount), to: CGFloat(pointsCount * multiplyerCount), withDuration: 3)
            self.endscreenMultiplyerLabelNode.countFrom(CGFloat(multiplyerCount), to: 1, withDuration: 3)
            
            runCountHaptic()
            
            var currentPointsValue: CGFloat = self.endscreenPointsCountingLabel.counter.currentValue.rounded()
            var currentMultiplyerValue: CGFloat = self.endscreenMultiplyerLabelNode.counter.currentValue.rounded()
            
            self.endscreenPointsCountingLabel.counter.updateBlock = {(value) in
                currentPointsValue = self.endscreenPointsCountingLabel.counter.currentValue
                
                if currentPointsValue >= CGFloat(lastHighscore) {
                    let newHighscoreString = "NEW\nHIGHSCORE"
                    let attrString = NSMutableAttributedString(string: newHighscoreString)
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    let range = NSRange(location: 0, length: newHighscoreString.count)
                    attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
                    attrString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.yellow, NSAttributedString.Key.font : UIFont.init(name: "PixelSplitter", size: 45)!], range: range)
                    pointsTitleLabelNode.attributedText = attrString
                    pointsTitleLabelNode.numberOfLines = 2
                    pointsTitleLabelNode.position.y = Screen.height * 0.47
                    pointsTitleLabelNode.fontColor = .yellow
                    pointsTitleLabelNode.horizontalAlignmentMode = .center
                    self.endscreenPointsCountingLabel.textColor = .yellow
                    highscoreLabelIsInFront = true
                }
                self.endscreenPointsCountingLabel.text = "\(Int(currentPointsValue))"
            }
            
            self.endscreenMultiplyerLabelNode.counter.updateBlock = {(value) in
                currentMultiplyerValue = self.endscreenMultiplyerLabelNode.counter.currentValue
                
                self.endscreenMultiplyerLabelNode.text = "X\(Int(currentMultiplyerValue))"
            }
            
            self.endscreenPointsCountingLabel.completionBlock = { () in
                self.saveStats()
                self.endscreenIsCounting = false
                
                if currentPointsValue >= CGFloat(lastHighscore) {
                    let newHighscoreString = "NEW\nHIGHSCORE"
                    let attrString = NSMutableAttributedString(string: newHighscoreString)
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    let range = NSRange(location: 0, length: newHighscoreString.count)
                    attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
                    attrString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.yellow, NSAttributedString.Key.font : UIFont.init(name: "PixelSplitter", size: 45)!], range: range)
                    pointsTitleLabelNode.attributedText = attrString
                    pointsTitleLabelNode.numberOfLines = 2
                    pointsTitleLabelNode.position.y = Screen.height * 0.47
                    pointsTitleLabelNode.fontColor = .yellow
                    pointsTitleLabelNode.horizontalAlignmentMode = .center
                    self.endscreenPointsCountingLabel.textColor = .yellow
                    highscoreLabelIsInFront = true
                }
                self.endscreenPointsCountingLabel.text = "\(Int(currentPointsValue))"
                
                self.endscreenPointsCountingLabel.counter.invalidate()
            }
            
            self.endscreenMultiplyerLabelNode.completionBlock = { () in
                UIView.animate(withDuration: 0.3) {
                    self.endscreenMultiplyerLabelNode.alpha = 0
                }
                self.endscreenMultiplyerLabelNode.counter.invalidate()
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: {
            
            self.restartLabelNode.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                
                self.view?.isUserInteractionEnabled = true
                self.isUserInteractionEnabled = true
                
            })
        })
    }
    
    
    
    
    //MARK:--- DELEGATE FUNCTIONS ---
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
