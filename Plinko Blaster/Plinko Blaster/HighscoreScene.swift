//
//  HighscoreScene.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 28.04.19.
//  Copyright © 2019 me. All rights reserved.
//

import SpriteKit
import UIKit

class HighscoreScene: SKScene, UITextFieldDelegate {
    
    let backButtonNode = SKSpriteNode(imageNamed: "back-button3")
    let highscoreTableView = HighscoreTableView()
    var sortButtonNode = SKLabelNode(text: "SORTED BY HIGHSCORE")
    var newPlayerScreenIsOpen = false
    var nameTextField: UITextField!
    
    override func didMove(to view: SKView) {
        
        print("HighscoreScene")
        
        self.view?.tintColor = .green
        self.backgroundColor = UIColor(hexFromString: "120d27")
        
        addBackButtonNode()
        
        addTitleNode()
        
        addSortButtonNode()
        
        addHighscoreTableView()
        
        let textFieldFrame = CGRect(origin: CGPoint(x: ScreenSize.width * 0.1, y: ScreenSize.height * 0.21), size: CGSize(width: ScreenSize.width * 0.8, height: 40))
        
        nameTextField = UITextField(frame: textFieldFrame)
        
        view.addSubview(nameTextField)
        
        nameTextField.delegate = self
        
        nameTextField.backgroundColor = .clear
        nameTextField.textAlignment = .center
        nameTextField.adjustsFontSizeToFitWidth = true
        nameTextField.borderStyle = .none
        nameTextField.textColor = .green
        nameTextField.font = UIFont.init(name: "LCD14", size: 30)
        nameTextField.tag = 1
        nameTextField.clearsOnBeginEditing = true
        nameTextField.autocapitalizationType = .allCharacters
        
        self.view?.addSubview(nameTextField)
        nameTextField.isHidden = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.scene?.view!.endEditing(true)
        
        for touch in touches {
            if touch == touches.first {
                if backButtonNode.contains(touch.location(in: self)) {
                    
                    
                    if vibrationOn {
                        generator.impactOccurred()
                    }
                    
                    if self.scene?.view!.subviews.count != 0 {
                        for subView in (self.scene?.view!.subviews)! {
                            subView.removeFromSuperview()
                        }
                    }
                    
                    self.removeAllChildren()
                    self.removeAllActions()
                    
                    if UserDefaults.standard.bool(forKey: "inGamePlayerChange") == true {
                        
                        print("<- zurück zum Spiel <-")
                        SceneManager.shared.transition(self, toScene: .Level1, transition: SKTransition.fade(withDuration: 0.5))
                        
                    } else {
                        
                        print("<- ab zum Hauptmenü <-")
                        SceneManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.fade(withDuration: 0.5))
                        
                    }
                    
                    
                } else if sortButtonNode.contains(touch.location(in: self)) && newPlayerScreenIsOpen == false {
                    
                    print("+++")
                    
                    
                    
                    if vibrationOn {
                        generator.impactOccurred()
                    }
                    
                }
            }
        }
    }
    
    func addBackButtonNode() {
        
        let backButtonAspectRatio = backButtonNode.size.width/backButtonNode.size.height
        if DeviceType.isiPad || DeviceType.isiPadPro {
            backButtonNode.size = CGSize(width: ScreenSize.width * 0.08, height: ScreenSize.width * 0.08 / backButtonAspectRatio)
        } else {
            backButtonNode.size = CGSize(width: ScreenSize.width * 0.1, height: ScreenSize.width * 0.1 / backButtonAspectRatio)
        }
        backButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backButtonNode.position = CGPoint(x: ScreenSize.width * 0.1, y: ScreenSize.height * 0.95)
        backButtonNode.alpha = 1
        addChild(backButtonNode)
    }
    
    func addTitleNode() {
        
        let titleNode = SKLabelNode(text: "HIGHSCORE-LIST")
        titleNode.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height * 0.88)
        titleNode.alpha = 1
        titleNode.fontName = "LCD14"
        titleNode.fontColor = .green
        titleNode.fontSize = 30
        addChild(titleNode)
    }
    
    func addSortButtonNode() {
        
        sortButtonNode.name = "sortButton"
        sortButtonNode.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height * 0.83)
        sortButtonNode.alpha = 1
        sortButtonNode.fontName = "LCD14"
        sortButtonNode.fontColor = .green
        sortButtonNode.fontSize = 22
        
        let border = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0 - ((sortButtonNode.frame.width * 1.1) / 2), y: -6), size: CGSize(width: sortButtonNode.frame.width * 1.1, height: sortButtonNode.frame.height * 1.5)), cornerRadius: 5)
        border.fillColor = .clear
        border.strokeColor = .green
        border.lineWidth = 2
        
        sortButtonNode.addChild(border)
        addChild(sortButtonNode)
    }
    
    func addHighscoreTableView() {
        
        highscoreTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        highscoreTableView.frame = CGRect(x: ScreenSize.width * 0.05, y: ScreenSize.height * 0.2, width: ScreenSize.width * 0.9, height: ScreenSize.height * 0.8)
        highscoreTableView.backgroundColor = .clear
        highscoreTableView.separatorColor = .green
        highscoreTableView.separatorStyle = .none
        self.scene?.view?.addSubview(highscoreTableView)
        highscoreTableView.reloadData()
        
    }
}

