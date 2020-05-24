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
                description: "BUUH! Hides all balls for 1 second. Balls give double points.",
                points: 0,
                multi: 2,
                seconds: 1,
                miniLabelText: "BUUH",
                freeAtPrestigeLevel: 1,
                color: .yellow,
                action: SKAction()
    ),

    Collectible(name: "Blue Ghost",
                texture: SKTexture(imageNamed: "ghost_blue"),
                description: "BUUUH! Hides all balls for 2 second. Balls give double points.",
                points: 0,
                multi: 2,
                seconds: 2,
                miniLabelText: "BUUUH",
                freeAtPrestigeLevel: 2,
                color: UIColor(hexFromString: "0099ff"),
                action: SKAction()
    ),

    Collectible(name: "Green Ghost",
                texture: SKTexture(imageNamed: "ghost_green"),
                description: "BUUUUH! Hides all balls for 3 second. Balls give double points.",
                points: 0,
                multi: 2,
                seconds: 3,
                miniLabelText: "BUUUUH",
                freeAtPrestigeLevel: 3,
                color: .green,
                action: SKAction()
    ),

    Collectible(name: "Pink Ghost",
                texture: SKTexture(imageNamed: "ghost_pink"),
                description: "BUUUUUH! Hides all balls for 4 second. Balls give double points.",
                points: 0,
                multi: 2,
                seconds: 4,
                miniLabelText: "BUUUUUH",
                freeAtPrestigeLevel: 4,
                color: UIColor(hexFromString: "d800ff"),
                action: SKAction()
    ),

    Collectible(name: "White Ghost",
                texture: SKTexture(imageNamed: "ghost_original"),
                description: "BUUUUUUH! Hides all balls for 5 second. Balls give double points.",
                points: 0,
                multi: 2,
                seconds: 5,
                miniLabelText: "BUUUUUUH",
                freeAtPrestigeLevel: 5,
                color: .white,
                action: SKAction()
    )

])
