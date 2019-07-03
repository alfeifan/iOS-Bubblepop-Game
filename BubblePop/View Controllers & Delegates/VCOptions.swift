//
//  VCOptions.swift
//  BubblePop
//
//  Created by Alan Li on 5/5/19.
//  Copyright © 2019 Alan Li. All rights reserved.
//

import UIKit

class VCOptions: UIViewController {                 //this view controller enables the user to configure game settings
    
    
    @IBOutlet weak var durationTitle: UILabel!      //outlets for on-screen labels and controls
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var maxTitle: UILabel!
    @IBOutlet weak var maxBubbles: UILabel!
    @IBOutlet weak var soundTitle: UILabel!
    
    public static var maxBubblesSetting = 15                //variable for maximum in-game bubbles with default
    public static var durationSetting = 60                  //variable for game duration in seconds with default
    
    @IBAction func durationSlider(_ sender: UISlider) {     //this control allows user to set a lesser duration
        durationLabel.text = String(Int(sender.value))
        VCOptions.durationSetting = Int(sender.value)
    }
    
    @IBAction func maxBubblesSlider(_ sender: UISlider) {   //this control allows user to set a lesser number of bubbles
        maxBubbles.text = String(Int(sender.value))
        VCOptions.maxBubblesSetting = Int(sender.value)
    }
    
    @IBAction func soundSwitch(_ sender: UISwitch) {        //this control allows the user to turn off in-game music
        if sender.isOn {
            MusicPlayer.sharedPlayer.restartBackgroundMusic()
        } else {
            MusicPlayer.sharedPlayer.stopBackgroundMusic()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Options"                                   //sets status bar title
        
        durationTitle.font = UIFont.boldSystemFont(ofSize: 24)   //sets custom label bold fonts
        maxTitle.font = UIFont.boldSystemFont(ofSize: 24)
        soundTitle.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
}
