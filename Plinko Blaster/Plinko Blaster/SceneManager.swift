//
//  SceneManager.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 15.03.19.
//  Copyright © 2019 me. All rights reserved.
//

import GameKit

class SceneManager {
    
    enum SceneType {
        case StartScene, MainScene, OptionsScene, GameScene, StatsScene, WelcomeScene, CollectiblesOverviewScene
    }
    
    private init() {}
    static let shared = SceneManager()
    
    
    func transition(_ fromScene: SKScene, toScene: SceneType, transition: SKTransition? = nil) {
        guard let scene = getScene(toScene) else { return }
        
        if let transition = transition {
            transition.pausesOutgoingScene = true
            fromScene.view?.presentScene(scene, transition: transition)
            fromScene.removeFromParent()
        } else {
            fromScene.view?.presentScene(scene)
            fromScene.removeFromParent()
        }

        scene.scaleMode = .resizeFill
        
    }
    
    func getScene(_ sceneType: SceneType) -> SKScene? {
        switch sceneType {
            
            case SceneType.WelcomeScene:
                return WelcomeScene(size: CGSize(width: Screen.width, height: Screen.height))
                
            case SceneType.MainScene:
                return MainMenu(size: CGSize(width: Screen.width, height: Screen.height))
                
            case SceneType.OptionsScene:
                return OptionsScene(size: CGSize(width: Screen.width, height: Screen.height))
                
            case SceneType.GameScene:
                return GameLevel(size: CGSize(width: Screen.width, height: Screen.height))
                
            case SceneType.StatsScene:
                return StatsScene(size: CGSize(width: Screen.width, height: Screen.height))
                    
            case SceneType.StartScene:
                return StartScene(size: CGSize(width: Screen.width, height: Screen.height))
                        
            case SceneType.CollectiblesOverviewScene:
                return CollectiblesScene(size: CGSize(width: Screen.width, height: Screen.height))
                
            }
    }
}
