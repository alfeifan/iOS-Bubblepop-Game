//
//  VCGame.swift
//  BubblePop
//
//  Created by Alan Li on 5/5/19.
//  Copyright © 2019 Alan Li. All rights reserved.
//

import UIKit
import CoreGraphics
import AVFoundation

class VCGame: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!                    //setup IB Outlets for programmatically altering view objects
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var topScoreLabel: UILabel!
    @IBOutlet weak var topHighScoreImage: UIImageView!
    @IBOutlet weak var highScoreImage: UIImageView!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var bubbleGenerationArea: UIView!
    
    @IBAction func bubbleTapped(_ sender: Bubble) {             //this IBAction responds to bubble touches
        let bubble = sender
        updateScore(bubblePopped: bubble)                       //updates the game score
        bubble.removeFromSuperview()                            //removes the bubble from the bubbleGenerationArea
        
        let bubblePop = GameAnimation(game: self)               //plays the bubblePop animation
        bubblePop.popBubble(bubble: bubble)
    }
    
    var timer = Timer()                                         //timer:            the game timer
    let gameDuration = VCOptions.durationSetting                //gameDuration:     imports initial game duration from settings
    public var secondsLeft: Int = VCOptions.durationSetting     //secondsLeft:      seconds left in the game (initially equal to the game duration)

    var highScores = HighScores()                               //highScores:       game high scores are managed by HighScores() class
    var playerName = ""                                         //playerName:       the player name is passed in via a segue
    var topHighScore = 0                                        //topHighScore:     variable that initialises with the maximum scoreboard score as of the start of the game and as the game progresses
    var bottomHighScore = 0                                     //bottomhighScore:  variable that initialises with the minimum scoreboard score as of the start of the game
    var score: Int = 0                                          //score:            the player's accumulated score for the game
    
    var currentBubbleBatch: BubbleBatch? = nil                  //currentBubbleBatch:   the on-screen array of bubbles shown to the player
    let maxBubblesVol: Int = VCOptions.maxBubblesSetting        //maxBubblesVol:    maximum number of bubbles allowed on screen (adjusted in user settings)
    var newBubblesVol: Int = VCOptions.maxBubblesSetting        //newBubblesVol:    number of new bubbles to be added each gameplay second (same as maxBubblesVol for the initial BubbleBatch)
    let streakMultiplier: Double = 1.5                          //streakMultiplier: multiplier applied to points from consecutive popping streaks of the same bubble colour
    var lastPoppedBubble: Bubble? = nil                         //lastPoppedBubble: Used to implement the streak multiplier
    
    override func viewDidLoad() {                               //this function runs immediately when the game starts
        super.viewDidLoad()
        self.title = "Bubble Pop"                               //custom status bar title
        
        playAgainButton.isHidden = true                         //hides the end of game views during game play
        homeButton.isHidden = true
        topHighScoreImage.isHidden = true
        highScoreImage.isHidden = true
        
        if highScores.highScoreBoard.count > 0 {                //retrieves high score information
            topHighScore = highScores.highScoreBoard[0].score
            bottomHighScore = highScores.highScoreBoard[highScores.highScoreBoard.count-1].score
            topScoreLabel.text = String(topHighScore)
        }
        
        /* The below time delay prevents bubbles being created before view boundaries are properly initialised.
         This fixes an issue where bubbles would generate partially off-screen in the initial batch only */
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.startGame()        //game is started after a short time delay
        }
    }

    func startGame() {
        playerLabel.text = playerName                   //setup playerName label
        timerLabel.text = "\(secondsLeft)"              //setup secondsLeft Timer
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)    //add game timer increments each game second
        currentBubbleBatch = BubbleBatch(newBubblesVol: newBubblesVol, game: self)    //creates a new Batch of bubbles to start gameplay
    }
    
    @objc func updateTimer() {                          //the timer is used to increment game play each game second, and update numbr of game secondsLeft
        if(secondsLeft >= 1) {
            secondsLeft -= 1
            timerLabel.text = String(secondsLeft)
            incrementGameplay()
        } else {
            secondsLeft = 0                             //when there are 0 seconds left the timer is invalidated and the game ends
            timer.invalidate()
            endGame()
        }
    }
    
    func incrementGameplay() {                                                      //GamePlay is incremented each second whereby:
        currentBubbleBatch!.removeBubbles()                                         //1. removeBubbles() routine is called to clear some bubbles
        let currentAnimation = GameAnimation(game: self)                            //2. stray bubble animations are removed (refer to animation class for details)
        currentAnimation.removeStrayAnimations(view: bubbleGenerationArea)
        newBubblesVol = maxBubblesVol - currentBubbleBatch!.bubbleBatch.count       //3. new bubbles are added back into the game . Note 'currentBubbleBatch' cannot be nil at this point
        currentBubbleBatch?.refreshBatch(newBubblesVol: newBubblesVol, game: self)
    }
    
    func endGame() {                                    //At the end of the game:
        
        if let batchStillExists = currentBubbleBatch {  //1. Any remaining bubbles are clearedfrom screen
            batchStillExists.removeAllBubbles()
        }
        
        playAgainButton.isHidden = false                //2. End of game views are shown
        homeButton.isHidden = false
        
        if scoreLabel.text == topScoreLabel.text {      //3. A medal is shown if player's score is the top score
            topHighScoreImage.isHidden = false
        }
        
        if score >= bottomHighScore {                   //4. A 'High Score' image is shown if the score is a high score (unless they are a new bottom entry)
            highScoreImage.isHidden = false
        }
                                                        //5. The highScoreBoard is updated and stored
        highScores.rankAndPlaceScore(score: Score(playerName: playerName, score: score))
        highScores.encodeAndStore()
                                                        //6. The high Score board is shown
        if let vcHighScores = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VCHighScores") as? VCHighScores {
            if let navigator = navigationController {
                navigator.pushViewController(vcHighScores, animated: true)
            }
        }
    }
    
    func updateScore(bubblePopped: Bubble) {            //updateScore handles score updates after the user pops a bubble
        var pointsToAdd: Int = bubblePopped.points
        if let lastBubbleColour = lastPoppedBubble?.colour {    //if a previous bubble has been popped in the game the colour is checked to see if it's the same as the previous bubble
            if lastBubbleColour == bubblePopped.colour {        //if it is, the streakMultiplier is applied to the points value
                pointsToAdd = Int(Double(pointsToAdd) * streakMultiplier)
            }
        }
        score += pointsToAdd                            //the score and scoreLabel are updated with the points value
        scoreLabel.text = String(score)
        if(score > topHighScore) {                      //and if the overall score is now the top score that and its label are updated too
            topHighScore = score
            topScoreLabel.text = String(score)
        }
        lastPoppedBubble = bubblePopped                 //the popped bubble is stored as the lastBubble popped for next time
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if let batch = currentBubbleBatch {
            batch.removeAllBubbles()                    //remove all bubbles if the memory warning is received
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let bubbleBatch = currentBubbleBatch {
              bubbleBatch.refreshVelocity()             //refresh velocity when there is a change from portrait to landscape or vice versa
        }                                               //this allows them to move upwards in portrait and sideways in landscape
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is VCGame                  //used in conjunction with OneForwardTwoBackSegue.swift custom segue to ensure user can 'Quit' back to the homescreen after 'Play Again'
        {
            let newGame = segue.destination as? VCGame
            newGame?.playerName = playerName
            let backButton = UIBarButtonItem()
            backButton.title = "Quit"                   //adds custom title to the next VCGame Navigation Controller
            navigationItem.backBarButtonItem = backButton
        }
    }
}
