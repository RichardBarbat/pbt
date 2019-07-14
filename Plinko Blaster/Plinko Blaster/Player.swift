//
//  Player.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 22.05.19.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

class Player: NSObject, NSCoding {
    
    var name: String
    var highscoreList: [Int]
    var creationDate: Date
    var totalBallsDropped: Int
    var totalPointsCollected: Int
    var totalStarsCollected: Int
    
    init(name: String, highscoreList: [Int], creationDate: Date, totalBallsDropped: Int, totalPointsCollected: Int, totalStarsCollected: Int) {
        self.name = name
        self.highscoreList = highscoreList
        self.creationDate = creationDate 
        self.totalBallsDropped = totalBallsDropped
        self.totalPointsCollected = totalPointsCollected
        self.totalStarsCollected = totalStarsCollected
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        highscoreList = aDecoder.decodeObject(forKey: "highscoreList") as? [Int] ?? [0]
        creationDate = aDecoder.decodeObject(forKey: "creationDate") as? Date ?? Date()
        totalBallsDropped = aDecoder.decodeObject(forKey: "totalBallsDropped") as? Int ?? 0
        totalPointsCollected = aDecoder.decodeObject(forKey: "totalPointsCollected") as? Int ?? 0
        totalStarsCollected = aDecoder.decodeObject(forKey: "totalStarsCollected") as? Int ?? 0
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(highscoreList, forKey: "highscoreList")
        aCoder.encode(creationDate, forKey: "creationDate")
        aCoder.encode(totalBallsDropped, forKey: "totalBallsDropped")
        aCoder.encode(totalPointsCollected, forKey: "totalPointsCollected")
        aCoder.encode(totalStarsCollected, forKey: "totalStarsCollected")
    }
    
    
    
}



