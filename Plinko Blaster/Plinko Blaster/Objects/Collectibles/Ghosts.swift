//
//  Ghosts.swift
//  Plinko Blaster
//
//  Created by Richardius von Barbat-Dos on 04.05.20.
//  Copyright © 2020 me. All rights reserved.
//
import SpriteKit

let ghosts =  Collectibles(name: "ghosts", collectibles: [
    
    Collectible(name: "Yellow Ghost",
                texture: SKTexture(imageNamed: "ghost_yellow"),
                description: "BUUH! Hides all active balls for 3 seconds. Hidden balls give double points.",
                points: 0,
                multi: 2,
                seconds: 3,
                miniLabelText: "BUUH",
                freeAtPrestigeLevel: 4,
                color: .yellow,
                action: SKAction()
    ),

    Collectible(name: "Blue Ghost",
                texture: SKTexture(imageNamed: "ghost_blue"),
                description: "BUUUH! Hides all active balls for 5 seconds. Hidden balls give double points.",
                points: 0,
                multi: 2,
                seconds: 5,
                miniLabelText: "BUUUH",
                freeAtPrestigeLevel: 4,
                color: UIColor(hexFromString: "0099ff"),
                action: SKAction()
    ),

    Collectible(name: "Green Ghost",
                texture: SKTexture(imageNamed: "ghost_green"),
                description: "BUUUUH! Hides all active balls for 7 seconds. Hidden balls give double points.",
                points: 0,
                multi: 2,
                seconds: 7,
                miniLabelText: "BUUUUH",
                freeAtPrestigeLevel: 5,
                color: .green,
                action: SKAction()
    ),

    Collectible(name: "Pink Ghost",
                texture: SKTexture(imageNamed: "ghost_pink"),
                description: "BUUUUUH! Hides all active balls for 10 seconds. Hidden balls give double points.",
                points: 0,
                multi: 2,
                seconds: 10,
                miniLabelText: "BUUUUUH",
                freeAtPrestigeLevel: 5,
                color: UIColor(hexFromString: "d800ff"),
                action: SKAction()
    ),

    Collectible(name: "White Ghost",
                texture: SKTexture(imageNamed: "ghost_original"),
                description: "BUUUUUUH! Hides all active balls for 15 seconds. Hidden balls give double points.",
                points: 0,
                multi: 2,
                seconds: 15,
                miniLabelText: "BUUUUUUH",
                freeAtPrestigeLevel: 5,
                color: .white,
                action: SKAction()
    )

])
