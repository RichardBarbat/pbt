//
//  Alien.swift
//  Plinko Blaster
//
//  Created by Richardius von Barbat-Dos on 14.05.20.
//  Copyright © 2020 me. All rights reserved.
//
import SpriteKit

let aliens =  Collectibles(name: "aliens", collectibles: [
    
    Collectible(name: "Yellow Alien",
                texture: SKTexture(imageNamed: "alien_yellow"),
                description: "ß§Ö",
                points: .random(in: 100...200),
                multi: 0,
                seconds: 0,
                miniLabelText: "%-#&",
                freeAtPrestigeLevel: 0,
                color: .yellow,
                action: SKAction()
    ),

    Collectible(name: "Blue Alien",
                texture: SKTexture(imageNamed: "alien_blue"),
                description: "ß§Ö*&/#%",
                points: .random(in: 200...300),
                multi: 0,
                seconds: 0,
                miniLabelText: "ß§Ö*&/#%",
                freeAtPrestigeLevel: 1,
                color: UIColor(hexFromString: "0099ff"),
                action: SKAction()
    ),

    Collectible(name: "Green Alien",
                texture: SKTexture(imageNamed: "alien_green"),
                description: "ß§.*&%§&/ä*/",
                points: .random(in: 300...400),
                multi: 0,
                seconds: 0,
                miniLabelText: "§Ö*ß§&/#.*&%",
                freeAtPrestigeLevel: 2,
                color: .green,
                action: SKAction()
    ),

    Collectible(name: "Pink Alien",
                texture: SKTexture(imageNamed: "alien_pink"),
                description: "*_*",
                points: .random(in: 400...500),
                multi: 0,
                seconds: 0,
                miniLabelText: "*_*",
                freeAtPrestigeLevel: 3,
                color: UIColor(hexFromString: "d800ff"),
                action: SKAction()
    ),

    Collectible(name: "%#)<%§/#<&§)-(§",
                texture: SKTexture(imageNamed: "alien_original"),
                description: "%#§.*&/*&§Ö*&§#§.*&§.*&§.*&%/§",
                points: .random(in: 500...600),
                multi: 0,
                seconds: 0,
                miniLabelText: "§/#<&§<%§/#<&&%/-(§",
                freeAtPrestigeLevel: 4,
                color: .green,
                action: SKAction()
    )

])
