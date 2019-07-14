//
//  PlayerScene.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 14.04.19.
//  Copyright © 2019 me. All rights reserved.
//

import SpriteKit
import UIKit

class PlayerScene: SKScene, UITextFieldDelegate {
    
    let backButtonNode = SKSpriteNode(imageNamed: "back-button3")
    let playerTableView = PlayerTableView()
    let addButtonNode = SKLabelNode(text: "+ ADD NEW PLAYER +")
    var newPlayerScreen = SKShapeNode()
    var newPlayerScreenIsOpen = false
    var nameTextField: UITextField!

    override func didMove(to view: SKView) {
        
        print("PlayerScene")
        
        self.view?.tintColor = .green
        self.backgroundColor = UIColor(hexFromString: "120d27")
        
        addBackButtonNode()
        
        addTitleNode()
        
        addAddButtonNode()
        
        addPlayerTableView()
        
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
        
        print("nameTextField.delegate = \(String(describing: nameTextField.delegate))")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.scene?.view!.endEditing(true)
        
        for touch in touches {
            if touch == touches.first {
                if backButtonNode.contains(touch.location(in: self)) {
                    
                    print("<- ab zum Hauptmenü <-")
                    
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
                        
                        SceneManager.shared.transition(self, toScene: .Level1, transition: SKTransition.fade(withDuration: 0.5))
                        
                    } else {
                        
                        SceneManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.fade(withDuration: 0.5))
                        
                    }
                    
                    
                } else if addButtonNode.contains(touch.location(in: self)) && newPlayerScreenIsOpen == false {
                    
                    print("+++")
                    
                    showNewPlayerScreen()
                    
                    if vibrationOn {
                        generator.impactOccurred()
                    }
                    
                } else if newPlayerScreen.contains(touch.location(in: self)) && newPlayerScreenIsOpen == true {
                    
                    
                    closeNewPlayerScreen()
                    
                    if vibrationOn {
                        generator.impactOccurred()
                    }
                }
            }
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.view?.viewWithTag(1) && textField.text != "" {
            print("RETURN \(String(describing: textField.text!))")
            closeNewPlayerScreen()
            self.view?.endEditing(true)
            
            let newPlayer = Player(name: textField.text!, highscoreList: [0], creationDate: Date(), totalBallsDropped: 0, totalPointsCollected: 0, totalStarsCollected: 0)
            
            playerTableView.playerList.insert(newPlayer, at: 0)
            
            
            if let loadedPlayerListData = UserDefaults.standard.object(forKey: "PLAYER-LIST") as? Data {
                if var decodedPlayerList = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedPlayerListData) as? [Player] {
                    
                    decodedPlayerList.insert(newPlayer, at: 0)
                    
                    if let playerListDataToSave = try? NSKeyedArchiver.archivedData(withRootObject: decodedPlayerList, requiringSecureCoding: false) {
                        UserDefaults.standard.set(playerListDataToSave, forKey: "PLAYER-LIST")
                    }
                }
            }
            
            UserDefaults.standard.set(String(describing: newPlayer.name), forKey: "selectedPlayerName")
            
            playerTableView.reloadData()
        }
        
        return true
    }
    
    
    func showNewPlayerScreen() {
        
        newPlayerScreen = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: ScreenSize.width, height: ScreenSize.height)))
        newPlayerScreen.fillColor = UIColor.black.withAlphaComponent(0.9)
        newPlayerScreen.strokeColor = UIColor.black.withAlphaComponent(0.9)
        newPlayerScreen.name = "newPlayerScreen"
        
        self.view!.allowsTransparency = true
        
        newPlayerScreen.alpha = 0
        addChild(newPlayerScreen)
        newPlayerScreen.run(SKAction.fadeIn(withDuration: 0.3))
        newPlayerScreenIsOpen = true
        playerTableView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.playerTableView.alpha = 0.1
            self.nameTextField.isHidden = false
            self.nameTextField.becomeFirstResponder()
        })
        
    }
    
    func closeNewPlayerScreen() {
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.playerTableView.alpha = 1
        })
        newPlayerScreen.run(SKAction.fadeOut(withDuration: 0.3), completion: {
            for child in self.children {
                if child.name == "newPlayerScreen" {
                    
                    self.playerTableView.isUserInteractionEnabled = true
                    
                    
                    self.view?.endEditing(true)
                    child.removeFromParent()
                    self.nameTextField.isHidden = true
                    
                    
                    self.newPlayerScreenIsOpen = false
                }
            }
        })
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
        
        let titleNode = SKLabelNode(text: "PLAYER-LIST")
        titleNode.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height * 0.9)
        titleNode.alpha = 1
        titleNode.fontName = "LCD14"
        titleNode.fontColor = .green
        titleNode.fontSize = 30
        addChild(titleNode)
    }
    
    func addAddButtonNode() {
        
        addButtonNode.name = "addButton"
        addButtonNode.position = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height * 0.83)
        addButtonNode.alpha = 1
        addButtonNode.fontName = "LCD14"
        addButtonNode.fontColor = .green
        addButtonNode.fontSize = 22
        
        let border = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0 - ((addButtonNode.frame.width * 1.1) / 2), y: -6), size: CGSize(width: addButtonNode.frame.width * 1.1, height: addButtonNode.frame.height * 1.5)), cornerRadius: 5)
        border.fillColor = .clear
        border.strokeColor = .green
        border.lineWidth = 2
        
        addButtonNode.addChild(border)
        addChild(addButtonNode)
    }
    
    func addPlayerTableView() {
        
        playerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        playerTableView.frame = CGRect(x: ScreenSize.width * 0.05, y: ScreenSize.height * 0.2, width: ScreenSize.width * 0.9, height: ScreenSize.height * 0.8)
        playerTableView.backgroundColor = .clear
        playerTableView.separatorColor = .green
        playerTableView.separatorStyle = .none
        self.scene?.view?.addSubview(playerTableView)
        playerTableView.reloadData()
        
        for section in 0..<playerTableView.numberOfSections {
            for row in 0..<playerTableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                
                if indexPath.row == UserDefaults.standard.integer(forKey: "selectedPlayer") {
                    _ = playerTableView.delegate?.tableView?(playerTableView, willSelectRowAt: indexPath)
                    playerTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    playerTableView.delegate?.tableView?(playerTableView, didSelectRowAt: indexPath)
                }
            }
        }
    }
    
    
}
