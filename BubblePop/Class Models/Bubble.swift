//
//  Bubble.swift
//  BubblePop
//
//  Created by Alan Li on 5/5/19.
//  Copyright © 2019 Alan Li. All rights reserved.
//

import Foundation
import UIKit

class Bubble: UIButton {
    
    var colour: BubbleType
    var image: UIImage?
    var points: Int
    var velocity: Double = 0.0      //bubble's speed on-screen
    let game: VCGame                //the bubble's game instance
    var timer: Timer?               //timer is used to implement bubble velocity
    
    init(frame: CGRect, game: VCGame) {
        
        let probability = randomNoZeroToOne()  //Apply bubble types and images based on random probability between 0 and 1
        switch probability {
            case 0...0.4:     colour = .red;    if let checkImage = UIImage.init(named: "RedBubble")    { image = checkImage }
            case 0.4...0.7:   colour = .pink;   if let checkImage = UIImage.init(named: "PinkBubble")   { image = checkImage }
            case 0.7...0.85:  colour = .green;  if let checkImage = UIImage.init(named: "GreenBubble")  { image = checkImage }
            case 0.85...0.95: colour = .blue;   if let checkImage = UIImage.init(named: "BlueBubble")   { image = checkImage }
            case 0.95...1:    colour = .black;  if let checkImage = UIImage.init(named: "BlackBubble")  { image = checkImage }
            default:          colour = .none;   image = nil
        }
        timer = nil
        self.game = game
        points = colour.rawValue
        super.init(frame: frame)                            //initialise bubble frame (per UIButton inherited propertyu)
        self.setImage(image, for: UIControlState.normal)    //display bubble image
        self.setVelocity()
    }
    
    func setVelocity() {                                    //set velocity is called regularly by VCGame to update bubble velocity in response to game time remaining
        self.velocity = 2.2 * (1.0 - (Double(self.game.secondsLeft)/60.0))
        if let existingTimer = timer {                      //invalidate existing bubble timer (if its not the initial call) to ensure velocities don't stack
            existingTimer.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer: Timer) in  //apply velocity to the bubble
            if UIDevice.current.orientation.isLandscape {
                self.center = CGPoint(x: self.center.x + CGFloat(self.velocity), y: self.center.y)      //send them to the right if it's landscape to maximise screen real-estate
            } else {
                self.center = CGPoint(x: self.center.x, y: self.center.y - CGFloat(self.velocity))      //send them upwards if it's portrait
            }
        })
        timer!.fire()   //set the timer off for the bubble (which with the above gets it to move at the above velocity)
    }
    
    required init?(coder aDecoder: NSCoder) {               //required init per UIButton (per UIButton inheritence)
        fatalError("init(coder:) has not been implemented")
    }
    
}
