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
                description: "Gives a X4 Multi and all active balls are getting the shape of a square for 3 seconds.",
                points: 0,
                multi: 4,
                seconds: 3,
                miniLabelText: "X4 + square balls",
                freeAtPrestigeLevel: 6,
                color: .yellow,
                action: SKAction()
    ),

    Collectible(name: "Blue Square",
                texture: SKTexture(imageNamed: "square_blue"),
                description: "Gives a X4 Multi and all active balls are getting the shape of a square for 5 seconds.",
                points: 0,
                multi: 4,
                seconds: 5,
                miniLabelText: "X4 + square balls",
                freeAtPrestigeLevel: 6,
                color: UIColor(hexFromString: "0099ff"),
                action: SKAction()
    ),

    Collectible(name: "Green Square",
                texture: SKTexture(imageNamed: "square_green"),
                description: "Gives a X4 Multi and all active balls are getting the shape of a square for 7 seconds.",
                points: 0,
                multi: 4,
                seconds: 7,
                miniLabelText: "X4 + square balls",
                freeAtPrestigeLevel: 7,
                color: .green,
                action: SKAction()
    ),

    Collectible(name: "Pink Square",
                texture: SKTexture(imageNamed: "square_pink"),
                description: "Gives a X4 Multi and all active balls are getting the shape of a square for 10 seconds.",
                points: 0,
                multi: 4,
                seconds: 10,
                miniLabelText: "X4 + square balls",
                freeAtPrestigeLevel: 7,
                color: UIColor(hexFromString: "d800ff"),
                action: SKAction()
    ),

    Collectible(name: "4-Color Square",
                texture: SKTexture(imageNamed: "square_original"),
                description: "Gives a X4 Multi and all active balls are getting the shape of a square for 15 seconds.",
                points: 0,
                multi: 4,
                seconds: 15,
                miniLabelText: "X4 + square balls",
                freeAtPrestigeLevel: 7,
                color: .green,
                action: SKAction()
    )

])
