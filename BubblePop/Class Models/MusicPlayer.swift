//
//  MusicPlayer.swift
//  BubblePop
//
//  Created by Alan Li on 5/5/19.
//  Copyright © 2019 Alan Li. All rights reserved.
//
//

import AVFoundation

class MusicPlayer {                             //this class manages the in-game music player
    
    static let sharedPlayer = MusicPlayer()
    
    var audioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "BubblePopOriginalMusic", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            audioPlayer!.numberOfLoops = -1     //play on an infinite loop
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play background music file")
        }
    }
    
    func stopBackgroundMusic() {                //these methods are accessed via in-game options
        audioPlayer!.stop()
    }
    
    func restartBackgroundMusic() {
        audioPlayer!.play()
    }
    
}
