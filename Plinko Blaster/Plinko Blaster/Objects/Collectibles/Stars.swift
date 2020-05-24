//
//  Stars.swift
//  Plinko Blaster
//
//  Created by Richardius von Barbat-Dos on 04.05.20.
//  Copyright © 2020 me. All rights reserved.
//
import SpriteKit

let stars =  Collectibles(name: "stars", collectibles: [
    
    Collectible(name: "Yellow Star",
                texture: SKTexture(imageNamed: "star_yellow"),
                description: "Gives 100 points.",
                points: 100,
                multi: 0,
                seconds: 0,
                miniLabelText: "+\(ballPointValue * 1)00 POINTS",
                freeAtPrestigeLevel: 1,
                color: .yellow,
                action: SKAction()
    ),

    Collectible(name: "Blue Star",
                texture: SKTexture(imageNamed: "star_blue"),
                description: "Gives 200 points.",
                points: 200,
                multi: 0,
                seconds: 0,
                miniLabelText: "+\(ballPointValue * 2)00 POINTS",
                freeAtPrestigeLevel: 2,
                color: UIColor(hexFromString: "0099ff"),
                action: SKAction()
    ),

    Collectible(name: "Green Star",
                texture: SKTexture(imageNamed: "star_green"),
                description: "Gives 400 points.",
                points: 400,
                multi: 0,
                seconds: 0,
                miniLabelText: "+\(ballPointValue * 4)00 POINTS",
                freeAtPrestigeLevel: 3,
                color: .green,
                action: SKAction()
    ),

    Collectible(name: "Pink Star",
                texture: SKTexture(imageNamed: "star_pink"),
                description: "Gives 700 points.",
                points: 700,
                multi: 0,
                seconds: 0,
                miniLabelText: "+\(ballPointValue * 7)00 POINTS",
                freeAtPrestigeLevel: 4,
                color: UIColor(hexFromString: "d800ff"),
                action: SKAction()
    ),

    Collectible(name: "Rainbow Star",
                texture: SKTexture(imageNamed: "star_original"),
                description: "Gives 1000 points !!!",
                points: 1000,
                multi: 0,
                seconds: 0,
                miniLabelText: "+\(ballPointValue * 10)00 POINTS",
                freeAtPrestigeLevel: 5,
                color: .green,
                action: SKAction()
    )

])
