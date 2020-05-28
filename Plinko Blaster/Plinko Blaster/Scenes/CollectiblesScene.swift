//
//  CollectiblesOverviewScene.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 19.03.20.
//  Copyright © 2020 me. All rights reserved.
//

import GameKit

class CollectiblesScene: SKScene, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    

    var collectiblesTableView = UITableView()
    
    let backButtonNode = SKSpriteNode(imageNamed: "back-button4")
    let prestigeButtonLabelNode = SKLabelNode(text: "")
    let prestigeLabelNode = SKLabelNode(text: "PRESTIGE LEVEL: \(prestigeCount + 1)")

    override func didMove(to view: SKView) {
        
        print("CollectiblesOverviewScene")
        
        self.backgroundColor = UIColor.init(hexFromString: "242d24")
        
        
        addBackButtonNode()
        
        addTitleNode()
        
        addPrestigeBar()
        
        collectiblesTableView = UITableView(frame: CGRect(x: 0, y: Screen.height * 0.21, width: Screen.width, height: Screen.height * 0.79))
        collectiblesTableView.alpha = 0
        
        addTableView()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.scene?.view!.endEditing(true)
        
        for touch in touches {
            if touch == touches.first {
                if backButtonNode.contains(touch.location(in: self)) {
                    
                    print("<- ab zum Hauptmenü <-")
                    
                    background {
                        if vibrationOn {
                            runHaptic()
                        }
                        if fxOn == true {
                            self.run(backButtonSound)
                        }
                    }
                    
                    if self.scene?.view!.subviews.count != 0 {
                        for subView in (self.scene?.view!.subviews)! {
                            subView.removeFromSuperview()
                        }
                    }
//
//                    self.removeAllChildren()
//                    self.removeAllActions()
                    
                    SceneManager.shared.transition(self, toScene: .MainScene, transition: SKTransition.fade(withDuration: 0.5))
                    
                }
                
                if prestigeButtonLabelNode.contains(touch.location(in: self)) {
                    if ballsToCollectForNextPrestige <= 0 {
                        
                        prestigeCount = prestigeCount + 1
                        UserDefaults.standard.set(prestigeCount, forKey: "prestigeCount")
                                            
                        UserDefaults.standard.set(ballPointValue + prestigeValue, forKey: "ballPointValue")
                        
                        UserDefaults.standard.set(0, forKey: "ballsDroppedSincePrestige")
                        
                        ballPointValue = ballPointValue + prestigeValue
                        ballsDroppedSincePrestige = 0
                        
                        prestigeButtonLabelNode.removeFromParent()
                        prestigeLabelNode.removeFromParent()
                        
                        addPrestigeBar()
                        
                        UserDefaults.standard.synchronize()
                        
                        if fxOn == true {
                            self.run(pling)
                        }
                        runHaptic()
                        
                        
                    }
                }
            }
        }
    }
    
    
    func addBackButtonNode() {
        
        let backButtonAspectRatio = backButtonNode.size.width/backButtonNode.size.height
        backButtonNode.size = CGSize(width: Screen.width * 0.1, height: Screen.width * 0.1 / backButtonAspectRatio)
        backButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backButtonNode.position = CGPoint(x: Screen.width * 0.1, y: Screen.height * 0.95)
        backButtonNode.alpha = 0.7
        addChild(backButtonNode)
    }
    
    func addTitleNode() {
        
        let collectiblesLableNode = SKLabelNode(text: "COLLECTIBLES")
        collectiblesLableNode.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.9)
        collectiblesLableNode.fontName = "PixelSplitter"
        collectiblesLableNode.fontColor = .green
        collectiblesLableNode.fontSize = 28
        collectiblesLableNode.horizontalAlignmentMode = .center
        addChild(collectiblesLableNode)
        
        let overviewLableNode = SKLabelNode(text: "-OVERVIEW-")
        overviewLableNode.position = CGPoint(x: Screen.width / 2, y: Screen.height * 0.85)
        overviewLableNode.fontName = "PixelSplitter"
        overviewLableNode.fontColor = .green
        overviewLableNode.fontSize = 28
        overviewLableNode.horizontalAlignmentMode = .center
        addChild(overviewLableNode)
    }
    
    func addPrestigeBar() {
        
        prestigeLabelNode.position = CGPoint(x: 10, y: Screen.height * 0.8)
        prestigeLabelNode.fontName = "PixelSplitter"
        prestigeLabelNode.fontColor = .red
        prestigeLabelNode.fontSize = 16
        prestigeLabelNode.horizontalAlignmentMode = .left
        addChild(prestigeLabelNode)
        
        prestigeButtonLabelNode.position = CGPoint(x: Screen.width - 10, y: Screen.height * 0.8)
        prestigeButtonLabelNode.fontName = "PixelSplitter"
        prestigeButtonLabelNode.fontColor = .green
        prestigeButtonLabelNode.fontSize = 18
        prestigeButtonLabelNode.horizontalAlignmentMode = .right
        if ballsToCollectForNextPrestige <= 0 {
            prestigeButtonLabelNode.text = "PRESTIGE NOW!"
        } else {
            prestigeButtonLabelNode.text = "DROP \(ballsToCollectForNextPrestige) BALLS"
            prestigeButtonLabelNode.fontColor = .yellow
            prestigeButtonLabelNode.fontSize = 14
        }

        addChild(prestigeButtonLabelNode)
        
    }
    
    func addTableView() {
        
        collectiblesTableView.backgroundColor = UIColor.red.withAlphaComponent(0)
        collectiblesTableView.separatorColor = UIColor.green.withAlphaComponent(0.5)
        collectiblesTableView.delegate = self
        collectiblesTableView.dataSource = self
        collectiblesTableView.allowsSelection = false
        
        collectiblesTableView.layer.borderWidth = 5
        collectiblesTableView.layer.borderColor = UIColor.green.cgColor
        collectiblesTableView.sectionHeaderHeight = 50
        
        collectiblesTableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.collectiblesTableView.alpha = 1
        }
        
        self.view?.addSubview(collectiblesTableView)
        
    }
    
    let allCollectibles = CollectiblesData().allCollectibles()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allCollectibles.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Screen.width - 30, height: 50))
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.green.cgColor
        view.backgroundColor = UIColor.init(hexFromString: "242d24")
        
        let titleLable = UILabel(frame: view.frame)
        titleLable.font = UIFont(name: "PixelSplitter", size: 30)
        titleLable.textColor = .green
        
        titleLable.text = "???"
        titleLable.layer.position = CGPoint(x: Screen.width / 2 + 10, y: 23)
        
        for collectible in allCollectibles[section].collectibles {
            if collectible.freeAtPrestigeLevel <= prestigeCount + 1 || DEBUGMODE == 1 {
                titleLable.text = allCollectibles[section].name.uppercased()
            }
        }
        
        view.addSubview(titleLable)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allCollectibles[section].collectibles.count > 0 {
            return allCollectibles[section].collectibles.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "collectibleCell")
        
        cell.backgroundView?.alpha = 0
        cell.backgroundColor = UIColor.white.withAlphaComponent(0)
        cell.contentView.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        
        let noImage = UIImage(named: "?")
        cell.imageView?.image = noImage
        
        cell.textLabel?.text = "???"
        cell.textLabel?.textColor = .red
        cell.textLabel?.font = UIFont(name: "PixelSplitter", size: 20)
        
        cell.detailTextLabel?.text = "Free at prestige level: \(allCollectibles[indexPath.section].collectibles[indexPath.row].freeAtPrestigeLevel)".uppercased()
        cell.detailTextLabel?.textColor = .red
        cell.detailTextLabel?.numberOfLines = 3
        cell.detailTextLabel?.font = UIFont(name: "PixelSplitter", size: 10)
        
        if allCollectibles[indexPath.section].collectibles[indexPath.row].freeAtPrestigeLevel <= prestigeCount + 1 || DEBUGMODE == 1 {
            cell.imageView?.image = UIImage(cgImage: allCollectibles[indexPath.section].collectibles[indexPath.row].texture.cgImage())
            
            cell.textLabel?.text = allCollectibles[indexPath.section].collectibles[indexPath.row].name.uppercased()
            cell.textLabel?.textColor = allCollectibles[indexPath.section].collectibles[indexPath.row].color
            
            cell.detailTextLabel?.text = allCollectibles[indexPath.section].collectibles[indexPath.row].description.uppercased()
            cell.detailTextLabel?.textColor = .white
            
            if allCollectibles[indexPath.section].name.lowercased().contains("aliens") {
                cell.textLabel?.textColor = .random()
                cell.detailTextLabel?.textColor = .random()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath = \(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}
