//
//  AppDelegate.swift
//  BubblePop
//
//  Created by Alan Li on 5/5/19.
//  Copyright © 2019 Alan Li. All rights reserved.
//

import Foundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //setup folder directory for app data persistence
    public static let documentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent         //setup custom navigation controller colours
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = .white
        
        MusicPlayer.sharedPlayer.playBackgroundMusic()              //plays game music
        
        return true
    }
    
}

