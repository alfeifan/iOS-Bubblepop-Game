//
//  GameAnimation.swift
//  BubblePop
//
//  Created by Alan Li on 5/5/19.
//  Copyright © 2019 Alan Li. All rights reserved.
//

import Foundation
import UIKit

class GameAnimation {                                           //is responsible for in-game bubble UIImageView animations
    
    let game: VCGame
    
    init(game: VCGame) {
        self.game = game
    }
    
    func popBubble(bubble: Bubble) {                            //This function handles the bubble's pop animation when a user touches an in-game bubble
        
        let bubblePopping = UIImageView(frame: bubble.frame)    //create a frame for the animation equal to the bubble size
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer: Timer) in  //apply the bubble velocity to the pop animations
            let velocity = bubble.velocity
            if UIDevice.current.orientation.isLandscape {       //move to the right if device is in landscape mode, or up if in portrait
                bubblePopping.center = CGPoint(x: bubblePopping.center.x + CGFloat(velocity), y: bubblePopping.center.y)
            } else {
                bubblePopping.center = CGPoint(x: bubblePopping.center.x, y: bubblePopping.center.y - CGFloat(velocity))
            }
        })
        
        bubblePopping.animationImages = [                       //create the array of images for the animation
            UIImage(named: "Splat1.png"),
            UIImage(named: "Splat2.png"),
            UIImage(named: "Splat3.png"),
            UIImage(named: "Splat4.png"),
            UIImage(named: "Splat5.png")
            ] as? [UIImage]
        
        bubblePopping.animationDuration = 0.35                  //setup the animation properties
        bubblePopping.animationRepeatCount = 1
        game.bubbleGenerationArea.addSubview(bubblePopping)     //add the animation to the game area and start animating
        bubblePopping.startAnimating()
    }
    
    /* UIImageView animation does not appear to have a completion closure (unlike UIView animation blocks), therefore in Bubble Pop the below method is used by the VCGame instance to delete the stray bubbles animations that are complete */
    
    func removeStrayAnimations(view: UIView) {
        var hiddenAnimations: [UIImageView] = []
        for index in 0..<view.subviews.count {
            if view.subviews[index] is UIImageView {
                hiddenAnimations.append(view.subviews[index] as! UIImageView)
            }
        }
        for index in 0..<hiddenAnimations.count {
            if !hiddenAnimations[index].isAnimating {
                hiddenAnimations[index].removeFromSuperview()
            }
        }
    }
    
}
