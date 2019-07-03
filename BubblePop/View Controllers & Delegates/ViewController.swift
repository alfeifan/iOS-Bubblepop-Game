//
//  ViewController.swift
//  BubblePop
//
//  Created by Alan Li on 5/5/19.
//  Copyright © 2019 Alan Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {       //the main ViewController for the home screen
    
    @IBOutlet weak var nameTextField: UITextField!                  //outlet for the name text field to get user input
    
    @IBAction func playButton(_ sender: UIButton) {                 //launches a new game provided the user has entered their name
        if nameTextField!.text! != "" {
            if let vcGame = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VCGame") as? VCGame {
                vcGame.playerName = nameTextField.text!
                if let navigator = navigationController {
                    let backButton = UIBarButtonItem()
                    backButton.title = "Quit"                       //applying the segue programatically allows for custom property values
                    navigationItem.backBarButtonItem = backButton
                    navigator.pushViewController(vcGame, animated: true)
                }
            }
        } else {                                                    //if no name is entered, an animation has shown to direct the user's attention to the nameTextField
            UIView.animate(withDuration: 0.1, animations: {
                self.nameTextField.center = CGPoint(x: self.nameTextField.center.x + 10, y: self.nameTextField.center.y)
                self.nameTextField.backgroundColor = .yellow
                self.nameTextField.alpha = 0.25
            }) { (_: Bool) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.nameTextField.center = CGPoint(x: self.nameTextField.center.x - 10, y: self.nameTextField.center.y)
                    self.nameTextField.backgroundColor = .white
                    self.nameTextField.alpha = 1.0
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.title = "Home"   //Status bar title
        self.nameTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {      //allows pop-up keyboard to close when pressing enter
        self.view.endEditing(true)
        return false
    }
    
}
