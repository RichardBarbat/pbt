//
//  CollectiblesScene.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 19.03.20.
//  Copyright © 2020 me. All rights reserved.
//

import SpriteKit
import UIKit

class CollectiblesScene: SKScene, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    let collectiblesTableView = UITableView(frame: CGRect(x: 0, y: Screen.height * 0.2, width: Screen.width, height: Screen.height * 0.8))
    
    let backButtonNode = SKSpriteNode(imageNamed: "back-button4")

    override func didMove(to view: SKView) {
        
        print("CollectiblesScene")
        
        self.view?.tintColor = .green
        
        addBackButtonNode()
        
        addTitleNode()
        
        addTableView()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.scene?.view!.endEditing(true)
        
        for touch in touches {
            if touch == touches.first {
                if backButtonNode.contains(touch.location(in: self)) {
                    
                    print("<- ab zum Hauptmenü <-")
                    
                    if vibrationOn {
                        mediumVibration.impactOccurred()
                    }
                    
                    if self.scene?.view!.subviews.count != 0 {
                        for subView in (self.scene?.view!.subviews)! {
                            subView.removeFromSuperview()
                        }
                    }
                    
                    self.removeAllChildren()
                    self.removeAllActions()
                    
                    SceneManager.shared.transition(self, toScene: .MainMenu, transition: SKTransition.fade(withDuration: 0.5))
                    
                }
            }
        }
    }
    
    
    func addBackButtonNode() {
        
        let backButtonAspectRatio = backButtonNode.size.width/backButtonNode.size.height
        if DeviceType.isiPad || DeviceType.isiPadPro {
            backButtonNode.size = CGSize(width: Screen.width * 0.08, height: Screen.width * 0.08 / backButtonAspectRatio)
        } else {
            backButtonNode.size = CGSize(width: Screen.width * 0.1, height: Screen.width * 0.1 / backButtonAspectRatio)
        }
        backButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backButtonNode.position = CGPoint(x: Screen.width * 0.1, y: Screen.height * 0.95)
        backButtonNode.alpha = 0.7
        addChild(backButtonNode)
    }
    
    func addTitleNode() {
        
        let collectiblesLableNode = SKLabelNode(text: "COLLECTIBLES")
        collectiblesLableNode.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.9)
        collectiblesLableNode.fontName = "LCD14"
        collectiblesLableNode.fontColor = .green
        collectiblesLableNode.fontSize = 28
        collectiblesLableNode.horizontalAlignmentMode = .center
        addChild(collectiblesLableNode)
        
        let overviewLableNode = SKLabelNode(text: "-OVERVIEW-")
        overviewLableNode.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.85)
        overviewLableNode.fontName = "LCD14"
        overviewLableNode.fontColor = .green
        overviewLableNode.fontSize = 28
        overviewLableNode.horizontalAlignmentMode = .center
        addChild(overviewLableNode)
    }
    
    func addTableView() {
        
        collectiblesTableView.backgroundColor = UIColor.red.withAlphaComponent(0)
        collectiblesTableView.separatorColor = UIColor.green.withAlphaComponent(0.5)
        collectiblesTableView.delegate = self
        collectiblesTableView.dataSource = self
        collectiblesTableView.allowsSelection = false
        
        collectiblesTableView.layer.borderWidth = 5
        collectiblesTableView.layer.borderColor = UIColor.green.withAlphaComponent(0.5).cgColor
        collectiblesTableView.sectionHeaderHeight = 50
        
        collectiblesTableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        self.view?.addSubview(collectiblesTableView)
        
    }
    
    let allCollectables = CollectiblesData().allCollectibles()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allCollectables.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Screen.width - 30, height: 50))
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.green.withAlphaComponent(0.5).cgColor
        view.backgroundColor = UIColor.green.withAlphaComponent(0.1)
        
        let titleLable = UILabel(frame: view.frame)
        titleLable.font = UIFont(name: "LCD14", size: 30)
        titleLable.textColor = .green
        titleLable.text = allCollectables[section].name.uppercased()
        titleLable.layer.position = CGPoint(x: Screen.width / 2 + 10, y: 23)
        
        view.addSubview(titleLable)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allCollectables[section].collectibles.count > 0 {
            return allCollectables[section].collectibles.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "collectibleCell")
        
        if (cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,
                        reuseIdentifier: "collectibleCell")
        }
        
        cell!.backgroundView?.alpha = 0
        cell!.backgroundColor = UIColor.white.withAlphaComponent(0)
        cell!.contentView.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        cell!.imageView?.image = UIImage.init(named: allCollectables[indexPath.section].collectibles[indexPath.row].name)
        cell!.textLabel?.text = allCollectables[indexPath.section].collectibles[indexPath.row].name
        cell!.detailTextLabel?.text = allCollectables[indexPath.section].collectibles[indexPath.row].description
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath = \(indexPath)")
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}