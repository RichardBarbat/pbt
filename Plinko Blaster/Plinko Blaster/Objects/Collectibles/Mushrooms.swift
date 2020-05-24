//
//  Mushrooms.swift
//  Plinko Blaster
//
//  Created by Richardius von Barbat-Dos on 16.05.20.
//  Copyright © 2020 me. All rights reserved.
//
import SpriteKit

let mushrooms =  Collectibles(name: "mushrooms", collectibles: [
    
    Collectible(name: "Yellow Mushroom",
                texture: SKTexture(imageNamed: "mushroom_yellow"),
                description: "...",
                points: 0,
                multi: .random(in: 1...3),
                seconds: 0,
                miniLabelText: "...",
                freeAtPrestigeLevel: 1,
                color: .yellow,
                action: SKAction()
    ),

    Collectible(name: "Blue Mushroom",
                texture: SKTexture(imageNamed: "mushroom_blue"),
                description: "...",
                points: 0,
                multi: .random(in: 3...4),
                seconds: 0,
                miniLabelText: "...",
                freeAtPrestigeLevel: 2,
                color: UIColor(hexFromString: "0099ff"),
                action: SKAction()
    ),

    Collectible(name: "Green Mushroom",
                texture: SKTexture(imageNamed: "mushroom_green"),
                description: "...",
                points: 0,
                multi: .random(in: 4...5),
                seconds: 0,
                miniLabelText: "...",
                freeAtPrestigeLevel: 3,
                color: .green,
                action: SKAction()
    ),

    Collectible(name: "Pink Mushroom",
                texture: SKTexture(imageNamed: "mushroom_pink"),
                description: "...",
                points: 0,
                multi: .random(in: 5...7),
                seconds: 0,
                miniLabelText: "...",
                freeAtPrestigeLevel: 4,
                color: UIColor(hexFromString: "d800ff"),
                action: SKAction()
    ),

    Collectible(name: "Original Mushroom",
                texture: SKTexture(imageNamed: "mushroom_original"),
                description: "...",
                points: 0,
                multi: .random(in: 7...10),
                seconds: 0,
                miniLabelText: "...",
                freeAtPrestigeLevel: 5,
                color: .red,
                action: SKAction()
    )

])
