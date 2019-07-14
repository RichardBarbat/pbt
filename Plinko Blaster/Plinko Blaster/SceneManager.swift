//
//  SceneManager.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 15.03.19.
//  Copyright © 2019 me. All rights reserved.
//

import Foundation
import SpriteKit

class SceneManager {
    
    enum SceneType {
        case MainMenu, Settings, Level1, PlayerScene, WelcomeScene, HighscoreScene
    }
    
    private init() {}
    static let shared = SceneManager()
    
    
    func transition(_ fromScene: SKScene, toScene: SceneType, transition: SKTransition? = nil) {
        guard let scene = getScene(toScene) else { return }
        
        if let transition = transition {
            scene.scaleMode = .resizeFill
            transition.pausesOutgoingScene = false
            fromScene.view?.presentScene(scene, transition: transition)
            fromScene.removeFromParent()
        } else {
            scene.scaleMode = .resizeFill
            fromScene.view?.presentScene(scene)
            fromScene.removeFromParent()
        }
        
        
    }
    
    func getScene(_ sceneType: SceneType) -> SKScene? {
        switch sceneType {
            
        case SceneType.WelcomeScene:
            return WelcomeScene(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
            
        case SceneType.MainMenu:
            return MainMenu(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
            
        case SceneType.Settings:
            return Settings(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
            
        case SceneType.Level1:
            return Level1(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
            
        case SceneType.PlayerScene:
            return PlayerScene(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        
        case SceneType.HighscoreScene:
            return HighscoreScene(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
            
        }
    }
}
