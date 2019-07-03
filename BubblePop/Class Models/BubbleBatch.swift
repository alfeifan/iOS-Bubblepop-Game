//
//  BubbleBatch.swift
//  BubblePop
//
//  Created by Alan Li on 5/5/19.
//  Copyright © 2019 Alan Li. All rights reserved.
//

import Foundation
import UIKit

class BubbleBatch {                              //BubbleBatch class handles operations involving producing a 'batch' of bubbles on-screen for the game
    
    var bubbleBatch: [Bubble] = []               //array of Bubbles shown to the player each gameplay second
    var game: VCGame                             //the game instance
    var boundsWidth: CGFloat                     //View bounds in which bubbles are allowed to generate
    var boundsHeight: CGFloat
    var boundsSize: CGSize
    
    init (newBubblesVol: Int, game: VCGame) {
        self.game = game
        self.boundsWidth = game.bubbleGenerationArea.bounds.width       //set view bounds based on the game's bubbleGenerationArea View
        self.boundsHeight = game.bubbleGenerationArea.bounds.height
        self.boundsSize = game.bubbleGenerationArea.bounds.size
        refreshBatch(newBubblesVol: newBubblesVol, game: game)          //create initial batch of bubbles
    }
    
    func refreshBatch(newBubblesVol: Int, game: VCGame) {               //refreshBatch is called by the VCGame instancer to refresh the in-game bubble batch
        self.game = game
        refreshBounds()                                                 //bounds and velocities are refreshed to alleviate bugs introduced when the user changes from portrait to landscape
        refreshVelocity()                                               //the bugs caused bubbles to appear partially off-screen
        for _ in 0..<newBubblesVol {
            initialiseBubble()                                          //creates the number of new bubbles required
        }
    }
    
    func initialiseBubble() {                     //initialiseBubble finds an area for a bubble to generate, and then creates and places in the game instance on-screen
        
        let xPositionMax = Double(boundsWidth)    //these properties are used to generate a random position within a set frame for the bubble
        let xPositionOffset = 0.0
        let yPositionMax = Double(boundsHeight)
        let yPositionOffset = 0.0
        
        var intersecting = true                  //assume the below new bubbleFrame view is intersecting until it's been checked

        while intersecting == true {             //create bubbleFrame to check and only initialise a Bubble if it doesn't intersect with other bubbles or View bounds
            let bubbleFrame = CGRect(origin: randomPosition(xMax: xPositionMax, xOffset: xPositionOffset, yMax: yPositionMax, yOffset: yPositionOffset),
                                     size: randomSize(minSize: CGSize(width: 25.0, height: 25.0), maxSize: CGSize(width: 65.0, height: 65.0)))
            let testPositionView = UIView(frame: bubbleFrame)
            game.bubbleGenerationArea.addSubview(testPositionView)
            if !(checkViewIsIntersecting(view: testPositionView)) { //if it's not intersecting, remove the test frame, then create an actual bubble and add it to the game
                testPositionView.removeFromSuperview()
                let newBubble = Bubble(frame: bubbleFrame, game: game)
                newBubble.addTarget(game, action: #selector(game.bubbleTapped(_:)), for: UIControlEvents.touchUpInside)
                game.bubbleGenerationArea.addSubview(newBubble)
                bubbleBatch.append(newBubble)
                intersecting = false
            }
            testPositionView.removeFromSuperview()  //if the test frame intersected remove it and try again
        }
    }
    
    func checkViewIsIntersecting(view: UIView) -> Bool {                            //Checks if a bubble is intersecting another bubble:
        let allBubbles = bubbleBatch                                                //1. create array of all bubbles that are in the display Area
        for bubble in allBubbles {                                                  //2. loop through each Bubble in the new array
            if(view.frame.intersects(bubble.frame) || checkbounds(view: view)) {    //3. check if it intersects with that bubble or superview
                return true                                                         //4. and return true if it does
            }
        }
        return false                                                                //5. or else return false if it doesn't
    }
    
    func checkbounds(view: UIView) -> Bool {                                        //checks if view intersects with the game boundaries
        if ((game.bubbleGenerationArea.bounds).intersection(view.frame).equalTo(view.frame)) {
            return false
        } else {
            return true
        }
    }
    
    func removeBubbles() {                                                          //removes a random number of bubbles up to the total number in the bubble array
        let numBubblesToRemove = Int(randomNoZeroToOne() * Double(bubbleBatch.count))
        for index in 0..<numBubblesToRemove {
            bubbleBatch[index].removeFromSuperview()
        }
        bubbleBatch = Array(bubbleBatch[numBubblesToRemove..<bubbleBatch.count])
    }
    
    func removeAllBubbles() {                                                       //removes all bubbles from the bubble array
        for index in 0..<bubbleBatch.count {
            bubbleBatch[index].removeFromSuperview()
        }
    }
    
    func refreshBounds() {                                                          //refreshes the game area boundary to constrain bubble placement
        boundsWidth = game.bubbleGenerationArea.bounds.width                        //this is used to manage portrait to landscape transitions and
        boundsHeight = game.bubbleGenerationArea.bounds.height                      //ensure bubbles always generate on screen
        boundsSize = game.bubbleGenerationArea.bounds.size
    }
    
    func refreshVelocity() {                                                        //updates bubble speed
        for index in 0..<bubbleBatch.count {
            bubbleBatch[index].setVelocity()
        }
    }
    
}
