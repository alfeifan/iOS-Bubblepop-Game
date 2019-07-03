//
//  TableViewController.swift
//  BubblePop
//
//  Created by Alan Li on 5/5/19.
//  Copyright © 2019 Alan Li. All rights reserved.
//

import Foundation
import UIKit

class VCHighScores: UITableViewController {                 //The table view controller that displays game high scores
    
    let highScores = HighScores().highScoreBoard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "High Scores"   //status bar title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //The below methods determine the highScore UITableView properties
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1                                                        //it has 1 single section
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count                                         //with number of rows equal to the number of high scores
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let firstCell = tableView.dequeueReusableCell(withIdentifier: "FirstScore", for: indexPath)     //FirstScore cell prototype has '1st place' medal
        let normalCell = tableView.dequeueReusableCell(withIdentifier: "HighScoreCell", for: indexPath) //HighScoreCell is the standard cell type
        let highScore = highScores[indexPath.row]
        let commonContents = "\(highScore.playerName) - Score: \(highScore.score) Points"               //display e.g. 'Peter - Score: 64 Points'
        
        firstCell.textLabel?.text = commonContents                      //first place doesn't need a rank number as the medal says '1st' on it
        normalCell.textLabel?.text = "\(indexPath.row+1)\(getRankSuffix(rank: indexPath.row+1)) - " + commonContents    //the rest have a rank prefix in front
        
        if indexPath.row == 0 {                 //Return custom cell for first to display '1st' medal
            return firstCell
        } else {
            return normalCell
        }
    }
    
    func getRankSuffix(rank: Int) -> String {   //there is a suffix (e.g. 'st', 'nd') on the the rank prefix (e.g. '1', '2') to add the correct wording i.e. '1st, 2nd, 3rd, 4th... '
        
        switch rank {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false                            // False ensures the tableView is not editable by the user
    }
}
