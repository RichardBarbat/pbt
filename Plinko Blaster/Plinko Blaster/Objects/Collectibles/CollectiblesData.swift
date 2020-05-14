//
//  CollectiblesData.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 22.03.20.
//  Copyright © 2020 me. All rights reserved.
//

import GameKit

//MARK: STRUCTS
struct Collectible {
    let name: String
    let texture: SKTexture
    let description: String
    let points: Int
    let multi: Int
    let seconds: Double
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
    
    //MARK: CLASS FUNCTIONS
    func allCollectibles() -> [Collectibles] {
        
        return [
                squares,
                triangles,
                stars,
                ghosts,
                aliens,
        ]
    }
    
}
