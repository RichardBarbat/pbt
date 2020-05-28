//
//  Triangles.swift
//  Plinko Blaster
//
//  Created by Richardius von Barbat-Dos on 04.05.20.
//  Copyright © 2020 me. All rights reserved.
//
import SpriteKit

let triangles =  Collectibles(name: "triangles", collectibles: [ // TODO: Turn Triangel by 180° 
    
    Collectible(name: "Yellow Triangle",
                texture: SKTexture(imageNamed: "triangle_yellow"),
                description: "Gives a X4 Multi and all active balls are getting the shape of a triangle for 3 seconds.",
                points: 0,
                multi: 4,
                seconds: 3,
                miniLabelText: "X4 + triangle balls",
                freeAtPrestigeLevel: 6,
                color: .yellow,
                action: SKAction()
    ),

    Collectible(name: "Blue Triangle",
                texture: SKTexture(imageNamed: "triangle_blue"),
                description: "Gives a X4 Multi and all active balls are getting the shape of a triangle for 5 seconds.",
                points: 0,
                multi: 4,
                seconds: 5,
                miniLabelText: "X4 + triangle balls",
                freeAtPrestigeLevel: 6,
                color: UIColor(hexFromString: "0099ff"),
                action: SKAction()
    ),

    Collectible(name: "Green Triangle",
                texture: SKTexture(imageNamed: "triangle_green"),
                description: "Gives a X4 Multi and all active balls are getting the shape of a triangle for 7 seconds.",
                points: 0,
                multi: 4,
                seconds: 7,
                miniLabelText: "X4 + triangle balls",
                freeAtPrestigeLevel: 7,
                color: .green,
                action: SKAction()
    ),

    Collectible(name: "Pink Triangle",
                texture: SKTexture(imageNamed: "triangle_pink"),
                description: "Gives a X4 Multi and all active balls are getting the shape of a triangle for 10 seconds.",
                points: 0,
                multi: 4,
                seconds: 10,
                miniLabelText: "X4 + triangle balls",
                freeAtPrestigeLevel: 7,
                color: UIColor(hexFromString: "d800ff"),
                action: SKAction()
    ),

    Collectible(name: "Orange Triangle",
                texture: SKTexture(imageNamed: "triangle_original"),
                description: "Gives a X4 Multi and all active balls are getting the shape of a triangle for 15 seconds.",
                points: 0,
                multi: 4,
                seconds: 15,
                miniLabelText: "X4 + triangle balls",
                freeAtPrestigeLevel: 7,
                color: .orange,
                action: SKAction()
    )

])
