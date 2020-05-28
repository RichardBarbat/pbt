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
                description: "Gives \(ballPointValue * 10) points.",
                points: 10,
                multi: 0,
                seconds: 0,
                miniLabelText: "+\(ballPointValue * 10) POINTS",
                freeAtPrestigeLevel: 2,
                color: .yellow,
                action: SKAction()
    ),

    Collectible(name: "Blue Star",
                texture: SKTexture(imageNamed: "star_blue"),
                description: "Gives \(ballPointValue * 20) points.",
                points: 20,
                multi: 0,
                seconds: 0,
                miniLabelText: "+\(ballPointValue * 20) POINTS",
                freeAtPrestigeLevel: 2,
                color: UIColor(hexFromString: "0099ff"),
                action: SKAction()
    ),

    Collectible(name: "Green Star",
                texture: SKTexture(imageNamed: "star_green"),
                description: "Gives \(ballPointValue * 40) points.",
                points: 40,
                multi: 0,
                seconds: 0,
                miniLabelText: "+\(ballPointValue * 40) POINTS",
                freeAtPrestigeLevel: 3,
                color: .green,
                action: SKAction()
    ),

    Collectible(name: "Pink Star",
                texture: SKTexture(imageNamed: "star_pink"),
                description: "Gives \(ballPointValue * 70) points.",
                points: 70,
                multi: 0,
                seconds: 0,
                miniLabelText: "+\(ballPointValue * 70) POINTS",
                freeAtPrestigeLevel: 3,
                color: UIColor(hexFromString: "d800ff"),
                action: SKAction()
    ),

    Collectible(name: "Rainbow Star",
                texture: SKTexture(imageNamed: "star_original"),
                description: "Gives 100 points !!! INCREDIBLE!!!",
                points: 100,
                multi: 0,
                seconds: 0,
                miniLabelText: "+\(ballPointValue * 100) POINTS",
                freeAtPrestigeLevel: 3,
                color: .green,
                action: SKAction()
    )

])
