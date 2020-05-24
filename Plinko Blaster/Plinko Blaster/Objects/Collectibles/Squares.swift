//
//  Squares.swift
//  Plinko Blaster
//
//  Created by Richardius von Barbat-Dos on 04.05.20.
//  Copyright © 2020 me. All rights reserved.
//
import SpriteKit

let squares =  Collectibles(name: "squares", collectibles: [
    
    Collectible(name: "Yellow Square",
                texture: SKTexture(imageNamed: "square_yellow"),
                description: "All balls are getting the shape of a square for 1 second.",
                points: 0,
                multi: 1,
                seconds: 1,
                miniLabelText: "1 sec. square",
                freeAtPrestigeLevel: 1,
                color: .yellow,
                action: SKAction()
    ),

    Collectible(name: "Blue Square",
                texture: SKTexture(imageNamed: "square_blue"),
                description: "All balls are getting the shape of a square for 2 seconds.",
                points: 0,
                multi: 2,
                seconds: 2,
                miniLabelText: "2 sec. square",
                freeAtPrestigeLevel: 2,
                color: UIColor(hexFromString: "0099ff"),
                action: SKAction()
    ),

    Collectible(name: "Green Square",
                texture: SKTexture(imageNamed: "square_green"),
                description: "All balls are getting the shape of a square for 3 seconds.",
                points: 0,
                multi: 3,
                seconds: 3,
                miniLabelText: "3 sec. square",
                freeAtPrestigeLevel: 3,
                color: .green,
                action: SKAction()
    ),

    Collectible(name: "Pink Square",
                texture: SKTexture(imageNamed: "square_pink"),
                description: "All balls are getting the shape of a square for 4 seconds.",
                points: 0,
                multi: 4,
                seconds: 4,
                miniLabelText: "4 sec. square",
                freeAtPrestigeLevel: 4,
                color: UIColor(hexFromString: "d800ff"),
                action: SKAction()
    ),

    Collectible(name: "4-Color Square",
                texture: SKTexture(imageNamed: "square_original"),
                description: "All balls are getting the shape of a square for 5 seconds.",
                points: 0,
                multi: 5,
                seconds: 5,
                miniLabelText: "5 sec. square",
                freeAtPrestigeLevel: 5,
                color: .green,
                action: SKAction()
    )

])
