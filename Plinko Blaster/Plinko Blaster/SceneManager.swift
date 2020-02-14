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
        case StartScene, MainMenu, Options, Level1, OverviewScene, WelcomeScene
    }
    
    private init() {}
    static let shared = SceneManager()
    
    
    func transition(_ fromScene: SKScene, toScene: SceneType, transition: SKTransition? = nil) {
        guard let scene = getScene(toScene) else { return }
        
        if let transition = transition {
            scene.scaleMode = .resizeFill
            transition.pausesOutgoingScene = true
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
                return WelcomeScene(size: CGSize(width: Screen.width, height: Screen.height))
                
            case SceneType.MainMenu:
                return MainMenu(size: CGSize(width: Screen.width, height: Screen.height))
                
            case SceneType.Options:
                return OptionsScene(size: CGSize(width: Screen.width, height: Screen.height))
                
            case SceneType.Level1:
                return Level1(size: CGSize(width: Screen.width, height: Screen.height))
                
            case SceneType.OverviewScene:
                return OverviewScene(size: CGSize(width: Screen.width, height: Screen.height))
                
            case SceneType.StartScene:
                return StartScene(size: CGSize(width: Screen.width, height: Screen.height))
                
            }
    }
}
