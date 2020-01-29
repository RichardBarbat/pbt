//
//  GameViewController.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 15.03.19.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer?
var backgroundMusicPlayerStatus = Bool()
let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")


class GameViewController: UIViewController {

    let skView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(skView)
        
        skView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        skView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        skView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        
        
        if launchedBefore == true {
            
            print("Not first launch.")
            
            if UserDefaults.standard.string(forKey: "launchScene") == nil || UserDefaults.standard.string(forKey: "launchScene") == "welcome" {
                UserDefaults.standard.set("main", forKey: "launchScene")
            }
            
            
        } else {
            
            print("First launch, setting UserDefaults.")
            
            UserDefaults.standard.set("welcome", forKey: "launchScene")
            UserDefaults.standard.set(true, forKey: "fxOn")
            UserDefaults.standard.set(true, forKey: "vibrationOn")
            UserDefaults.standard.set(true, forKey: "backgroundMusicPlayerStatus")
            UserDefaults.standard.set(false, forKey: "tutorialShown")
            
            if UserDefaults.standard.stringArray(forKey: "PLAYER") == nil {
                UserDefaults.standard.set(["PLAYER 1"], forKey: "PLAYER")
            }
            
            UserDefaults.standard.synchronize()
            
        }
        
        var scene = SKScene()
        
        if UserDefaults.standard.string(forKey: "launchScene") == "welcome" {
            scene = WelcomeScene(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        } else if UserDefaults.standard.string(forKey: "launchScene") == "main" {
            scene = MainMenu(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        }
        
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
        backgroundMusicPlayerStatus = UserDefaults.standard.bool(forKey: "backgroundMusicPlayerStatus")
        
        playBackgroundMusicInLoop()
        
    }
    
}

func playBackgroundMusicInLoop() {
    guard let url = Bundle.main.url(forResource: "background-music2", withExtension: "mp3") else { return }
    
    do {
        try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
        
        /* The following line is required for the player to work on iOS 11. */
        backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        
        guard let player = backgroundMusicPlayer else { return }
        
        
        player.volume = 0.2
        player.numberOfLoops = -1
        
        if backgroundMusicPlayerStatus == true {
            player.play()
            print("BG MUSIC PLAYS")
        }
        
    } catch let error {
        print(error.localizedDescription)
    }
}

