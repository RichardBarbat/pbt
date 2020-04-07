//
//  CollectiblesData.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 22.03.20.
//  Copyright © 2020 me. All rights reserved.
//

import Foundation
import SpriteKit

//MARK: STRUCTS
struct Collectible {
    let name: String
    let texture: SKTexture
    let description: String
    let points: Int
    let multi: Int
    let seconds: Int
    let miniLabelText: String
    let freeAtPrestigeLevel: Int
    let color: UIColor
    let action: SKAction
}

struct Collectibles {
    let name: String
    let collectibles: [Collectible]
}

//MARK: CLASS
class CollectiblesData {
    
    
    //MARK: COLLECTIBLES
    let stars =  Collectibles(name: "stars", collectibles: [
        
        Collectible(name: "Star Yellow",
                    texture: SKTexture(imageNamed: "star_yellow"),
                    description: "Sammle diesen Stern ein und bekomme 100 Punkte!",
                    points: 100,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 1)00 POINTS",
                    freeAtPrestigeLevel: 0,
                    color: .yellow,
                    action: SKAction()
        ),
    
        Collectible(name: "star_blue",
                    texture: SKTexture(imageNamed: "star_blue"),
                    description: "This is a test destcription of star_blue.",
                    points: 200,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 2)00 POINTS",
                    freeAtPrestigeLevel: 0,
                    color: UIColor(hexFromString: "0099ff"),
                    action: SKAction()
        ),
    
        Collectible(name: "star_green",
                    texture: SKTexture(imageNamed: "star_green"),
                    description: "This is a test destcription of star_green.",
                    points: 400,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 4)00 POINTS",
                    freeAtPrestigeLevel: 0,
                    color: .green,
                    action: SKAction()
        ),
    
        Collectible(name: "star_pink",
                    texture: SKTexture(imageNamed: "star_pink"),
                    description: "This is a test destcription of star_pink.",
                    points: 700,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 7)00 POINTS",
                    freeAtPrestigeLevel: 0,
                    color: UIColor(hexFromString: "d800ff"),
                    action: SKAction()
        ),
    
        Collectible(name: "star_original",
                    texture: SKTexture(imageNamed: "star_original"),
                    description: "This is a test destcription of star_original.",
                    points: 1000,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 10)00 POINTS",
                    freeAtPrestigeLevel: 0,
                    color: .white,
                    action: SKAction()
        )
    
    ])
    
    let ghosts =  Collectibles(name: "ghosts", collectibles: [
        
        Collectible(name: "ghost_yellow",
                    texture: SKTexture(imageNamed: "ghost_yellow"),
                    description: "This is a test destcription of ghost_yellow.",
                    points: 0,
                    multi: 2,
                    seconds: 1,
                    miniLabelText: "BUUH",
                    freeAtPrestigeLevel: 0,
                    color: .yellow,
                    action: SKAction()
        ),
    
        Collectible(name: "ghost_blue",
                    texture: SKTexture(imageNamed: "ghost_blue"),
                    description: "This is a test destcription of ghost_blue.",
                    points: 0,
                    multi: 2,
                    seconds: 2,
                    miniLabelText: "BUUUH",
                    freeAtPrestigeLevel: 0,
                    color: UIColor(hexFromString: "0099ff"),
                    action: SKAction()
        ),
    
        Collectible(name: "ghost_green",
                    texture: SKTexture(imageNamed: "ghost_green"),
                    description: "This is a test destcription of ghost_green.",
                    points: 0,
                    multi: 2,
                    seconds: 3,
                    miniLabelText: "BUUUUH",
                    freeAtPrestigeLevel: 0,
                    color: .green,
                    action: SKAction()
        ),
    
        Collectible(name: "ghost_pink",
                    texture: SKTexture(imageNamed: "ghost_pink"),
                    description: "This is a test destcription of ghost_pink.",
                    points: 0,
                    multi: 2,
                    seconds: 4,
                    miniLabelText: "BUUUUUH",
                    freeAtPrestigeLevel: 0,
                    color: UIColor(hexFromString: "d800ff"),
                    action: SKAction()
        ),
    
        Collectible(name: "ghost_original",
                    texture: SKTexture(imageNamed: "ghost_original"),
                    description: "This is a test destcription of ghost_original.",
                    points: 0,
                    multi: 2,
                    seconds: 5,
                    miniLabelText: "BUUUUUUH",
                    freeAtPrestigeLevel: 0,
                    color: .white,
                    action: SKAction()
        )
    
    ])
    
    
    
    //MARK: CLASS FUNCTIONS
    func allCollectibles() -> [Collectibles] {
        
        let arrayOfAllCollectibles = [Collectibles(name: "stars", collectibles: stars.collectibles),
                                      Collectibles(name: "ghosts", collectibles: ghosts.collectibles)]
        
        return arrayOfAllCollectibles
    }

}
