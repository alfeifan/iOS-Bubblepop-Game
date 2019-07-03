//
//  HighScores.swift
//  BubblePop
//
//  Created by Alan Li on 5/5/19.
//  Copyright © 2019 Alan Li. All rights reserved.
//

import Foundation

class HighScores {                                       //HighScores manages the persistent storage of High Score information
    
    var highScoreBoard: [Score] = []
    let archiveURL = AppDelegate.documentsDirectory.appendingPathComponent("high_scores").appendingPathExtension("plist")
    let boardPositions = 10                              //this number can be adjusted to extend the number of highscore positions
    
    init() {
        highScoreBoard = retrieveAndDecode()
    }
    
    func retrieveAndDecode() -> [Score] {                //retrieves the highScoreBoard from persistent storage
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedScoreData = try? Data(contentsOf: archiveURL),
            let decodedScores = try? propertyListDecoder.decode(Array<Score>.self,
                                                                from: retrievedScoreData) {
            return decodedScores
        }
        return []
    }
    
    func encodeAndStore() {                              //stores the highScoreBoard into persistent storage
        let propertyListEncoder = PropertyListEncoder()
        if let encodedScores = try? propertyListEncoder.encode(highScoreBoard) {
            try? encodedScores.write(to: archiveURL,
                                     options: .noFileProtection)
        }
    }
    
    func rankAndPlaceScore(score: Score) {              //ranks a score against the existing high scores and places in the list if it qualifies
        var scoreToCheck = score                        //also manages the refactoring of existing scores if a new highscore has been achieved
        
        for index in 0..<highScoreBoard.count {
            scoreToCheck = compareAndSwap(score: scoreToCheck, index: index)
        }
        
        if highScoreBoard.count < boardPositions {
            highScoreBoard.append(scoreToCheck)
        }
    }
    
    func compareAndSwap(score: Score, index: Int) -> Score {    //this function manages the individual comparison of 2 scores, and passes back the lower score
        var scoreToCheck = score
        
        if scoreToCheck.score >= highScoreBoard[index].score {
            let temp = highScoreBoard[index]
            highScoreBoard[index] = scoreToCheck
            scoreToCheck = temp
            return scoreToCheck
        }
        return scoreToCheck
    }
    
}
