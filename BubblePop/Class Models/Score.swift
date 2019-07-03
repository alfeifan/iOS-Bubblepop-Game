//
//  Score.swift
//  BubblePop
//
//  Created by Alan Li on 5/5/19.
//  Copyright © 2019 Alan Li. All rights reserved.
//

/* Score is used to create objects that associate a player to a game score. Though a dictionary could have been used,
 this version is easily extensible so information such as a date/time can easily be added in future */

import Foundation

class Score: Codable {
    
    var playerName: String
    var score: Int
    
    init(playerName: String, score: Int) {
        self.playerName = playerName
        self.score = score
    }
    
}
