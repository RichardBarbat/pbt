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
struct Collectable {
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

struct Collectables {
    let name: String
    let collectibles: [Collectable]
}

//MARK: CLASS
class CollectiblesData {
    
    
    //MARK: COLLECTIBLES
    
    let triangles =  Collectables(name: "triangles", collectibles: [
        
        Collectable(name: "Yellow Triangle",
                    texture: SKTexture(imageNamed: "triangle_yellow"),
                    description: "Gives 100 points.",
                    points: 100,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 1)00 POINTS",
                    freeAtPrestigeLevel: 0,
                    color: .yellow,
                    action: SKAction()
        ),
    
        Collectable(name: "Blue Triangle",
                    texture: SKTexture(imageNamed: "triangle_blue"),
                    description: "Gives 200 points.",
                    points: 200,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 2)00 POINTS",
                    freeAtPrestigeLevel: 2,
                    color: UIColor(hexFromString: "0099ff"),
                    action: SKAction()
        ),
    
        Collectable(name: "Green Triangle",
                    texture: SKTexture(imageNamed: "triangle_green"),
                    description: "Gives 400 points.",
                    points: 400,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 4)00 POINTS",
                    freeAtPrestigeLevel: 4,
                    color: .green,
                    action: SKAction()
        ),
    
        Collectable(name: "Pink Triangle",
                    texture: SKTexture(imageNamed: "triangle_pink"),
                    description: "Gives 700 points.",
                    points: 700,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 7)00 POINTS",
                    freeAtPrestigeLevel: 6,
                    color: UIColor(hexFromString: "d800ff"),
                    action: SKAction()
        ),
    
        Collectable(name: "Orange Triangle",
                    texture: SKTexture(imageNamed: "triangle_original"),
                    description: "Gives 1000 points !!!",
                    points: 1000,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 10)00 POINTS",
                    freeAtPrestigeLevel: 8,
                    color: .white,
                    action: SKAction()
        )
    
    ])
    
    let stars =  Collectables(name: "stars", collectibles: [
        
        Collectable(name: "Yellow Star",
                    texture: SKTexture(imageNamed: "star_yellow"),
                    description: "Gives 100 points.",
                    points: 100,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 1)00 POINTS",
                    freeAtPrestigeLevel: 0,
                    color: .yellow,
                    action: SKAction()
        ),
    
        Collectable(name: "Blue Star",
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
    
        Collectable(name: "Green Star",
                    texture: SKTexture(imageNamed: "star_green"),
                    description: "Gives 400 points.",
                    points: 400,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 4)00 POINTS",
                    freeAtPrestigeLevel: 4,
                    color: .green,
                    action: SKAction()
        ),
    
        Collectable(name: "Pink Star",
                    texture: SKTexture(imageNamed: "star_pink"),
                    description: "Gives 700 points.",
                    points: 700,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 7)00 POINTS",
                    freeAtPrestigeLevel: 6,
                    color: UIColor(hexFromString: "d800ff"),
                    action: SKAction()
        ),
    
        Collectable(name: "Rainbow Star",
                    texture: SKTexture(imageNamed: "star_original"),
                    description: "Gives 1000 points !!!",
                    points: 1000,
                    multi: 0,
                    seconds: 0,
                    miniLabelText: "+\(ballPointValue * 10)00 POINTS",
                    freeAtPrestigeLevel: 8,
                    color: .white,
                    action: SKAction()
        )
    
    ])
    
    let ghosts =  Collectables(name: "ghosts", collectibles: [
        
        Collectable(name: "Yellow Ghost",
                    texture: SKTexture(imageNamed: "ghost_yellow"),
                    description: "BUUH! Hides all balls for 1 second. Balls give double points.",
                    points: 0,
                    multi: 2,
                    seconds: 1,
                    miniLabelText: "BUUH",
                    freeAtPrestigeLevel: 5,
                    color: .yellow,
                    action: SKAction()
        ),
    
        Collectable(name: "Blue Ghost",
                    texture: SKTexture(imageNamed: "ghost_blue"),
                    description: "BUUUH! Hides all balls for 2 second. Balls give double points.",
                    points: 0,
                    multi: 2,
                    seconds: 2,
                    miniLabelText: "BUUUH",
                    freeAtPrestigeLevel: 6,
                    color: UIColor(hexFromString: "0099ff"),
                    action: SKAction()
        ),
    
        Collectable(name: "Green Ghost",
                    texture: SKTexture(imageNamed: "ghost_green"),
                    description: "BUUUUH! Hides all balls for 3 second. Balls give double points.",
                    points: 0,
                    multi: 2,
                    seconds: 3,
                    miniLabelText: "BUUUUH",
                    freeAtPrestigeLevel: 7,
                    color: .green,
                    action: SKAction()
        ),
    
        Collectable(name: "Pink Ghost",
                    texture: SKTexture(imageNamed: "ghost_pink"),
                    description: "BUUUUUH! Hides all balls for 4 second. Balls give double points.",
                    points: 0,
                    multi: 2,
                    seconds: 4,
                    miniLabelText: "BUUUUUH",
                    freeAtPrestigeLevel: 8,
                    color: UIColor(hexFromString: "d800ff"),
                    action: SKAction()
        ),
    
        Collectable(name: "White Ghost",
                    texture: SKTexture(imageNamed: "ghost_original"),
                    description: "BUUUUUUH! Hides all balls for 5 second. Balls give double points.",
                    points: 0,
                    multi: 2,
                    seconds: 5,
                    miniLabelText: "BUUUUUUH",
                    freeAtPrestigeLevel: 9,
                    color: .white,
                    action: SKAction()
        )
    
    ])
    
    
    
    //MARK: CLASS FUNCTIONS
    func allCollectibles() -> [Collectables] {
        
        let arrayOfAllCollectibles = [  Collectables(name: "triangles", collectibles: triangles.collectibles),
                                        Collectables(name: "stars", collectibles: stars.collectibles),
                                        Collectables(name: "ghosts", collectibles: ghosts.collectibles)]
        
        return arrayOfAllCollectibles
    }

}
