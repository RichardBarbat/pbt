//
//  HighscoreTableView.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 28.04.19.
//  Copyright © 2019 me. All rights reserved.
//


import SpriteKit
import UIKit


class HighscoreTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var playerList = [Player]()
    var alreadyAnimated = false
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        
        if let loadedPlayerListData = UserDefaults.standard.object(forKey: "PLAYER-LIST") as? Data {
            if let decodedPlayerList = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedPlayerListData) as? [Player] {
                playerList = decodedPlayerList
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = self.playerList[indexPath.row].name
        
        cell.textLabel?.font = UIFont(name: "LCD14", size: 20)
        cell.textLabel?.textColor = .green
        cell.backgroundColor = .clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let highscoreTextLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: cell.frame.size))
        highscoreTextLabel.text = String(describing: playerList[indexPath.row].highscoreList.last!)
        highscoreTextLabel.font = UIFont(name: "LCD14", size: 20)
        highscoreTextLabel.textColor = .green
        highscoreTextLabel.adjustsFontSizeToFitWidth = true
        highscoreTextLabel.textAlignment = .right
        
        
        print("cell.subviews.first = \(cell.subviews.first!)")
        print("cell.subviews = \(cell.subviews.count)")
        
        for cellSubview in cell.subviews {
            if cellSubview == cell.subviews.first {
                
            } else {
                cellSubview.removeFromSuperview()
            }
        }
        
        cell.addSubview(highscoreTextLabel)
        
        
        print("cell.subviews.first = \(cell.subviews.first!)")
        print("cell.subviews = \(cell.subviews.count)")
        
        
        tableView.separatorColor = .clear
        tableView.sectionIndexBackgroundColor? = .clear
        tableHeaderView?.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellToDeSelect:UITableViewCell = tableView.cellForRow(at: indexPath)!
        cellToDeSelect.contentView.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = .clear
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = .clear
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.2, delay: 0.2 * Double(indexPath.row + 1), animations: {
            cell.alpha = 1
        })
        
        if indexPath.row == playerList.count - 1 {
            alreadyAnimated = true
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        generator.impactOccurred()
        return true
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

