//
//  PlayerList.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 14.04.19.
//  Copyright © 2019 me. All rights reserved.
//

import SpriteKit
import UIKit


class PlayerTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
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
        selectedCell.contentView.backgroundColor = UIColor.green.withAlphaComponent(0.25)
        UserDefaults.standard.set(indexPath.row, forKey: "selectedPlayer")
        UserDefaults.standard.set(selectedCell.textLabel?.text, forKey: "selectedPlayerName")
        print("You selected cell #\(indexPath.row) and the Playername is = \(String(describing: selectedCell.textLabel?.text))!")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellToDeSelect:UITableViewCell = tableView.cellForRow(at: indexPath)!
        cellToDeSelect.contentView.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.green.withAlphaComponent(0.1)
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
        if playerList.count >= 2 {
            return true
        } else {
            return false
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")
            playerList.remove(at: indexPath.row)
            
            if let playerListDataToSave = try? NSKeyedArchiver.archivedData(withRootObject: playerList, requiringSecureCoding: false) {
                UserDefaults.standard.set(playerListDataToSave, forKey: "PLAYER-LIST")
            }
            
            tableView.reloadData()
        }
    }}
