//
//  MessageManager.swift
//  Plinko Blaster
//
//  Created by Richardius von Barbat-Dos on 24.05.20.
//  Copyright © 2020 me. All rights reserved.
//

import Foundation
import SpriteKit

protocol Alertable { }
extension Alertable where Self: SKScene {

    func showAlert(withTitle title: String, message: String) {

        let alertController = DOAlertController(title: title.uppercased(), message: message.uppercased(), preferredStyle: .alert)
        
        alertController.alertViewBgColor = .init(hexFromString: "242d24")
        alertController.titleFont = UIFont(name: "PixelSplitter", size: 30)
        alertController.titleTextColor = .green
        alertController.messageFont = UIFont(name: "PixelSplitter", size: 16)
        alertController.messageTextColor = .green
        
        alertController.buttonFont[.default] = UIFont(name: "PixelSplitter", size: 20)
        alertController.buttonTextColor[.default] = .green
        alertController.buttonBgColor[.default] = .init(hexFromString: "242d24")
        alertController.buttonBgColorHighlighted[.default] = .init(hexFromString: "242d24")
        
        alertController.buttonFont[.destructive] = UIFont(name: "PixelSplitter", size: 20)
        alertController.buttonTextColor[.destructive] = .red
        alertController.buttonBgColor[.destructive] = .init(hexFromString: "242d24")
        alertController.buttonBgColorHighlighted[.destructive] = .init(hexFromString: "242d24")
        
        alertController.view.layer.cornerRadius = 5
        
        
        // Create the action.
        let cancelAction = DOAlertAction(title: "Cancel".uppercased(), style: .destructive, handler: nil)
        

        // You can add plural action.
        let okAction = DOAlertAction(title: "OK".uppercased(), style: .default) { action in
            NSLog("OK action occured.")
        }

        // Add the action.
//        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        view?.window?.rootViewController?.present(alertController, animated: true)
    }

//    func showAlertWithSettings(withTitle title: String, message: String) {
//
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
//        alertController.addAction(okAction)
//
//        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
//
//            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
//        alertController.addAction(settingsAction)
//
//        view?.window?.rootViewController?.present(alertController, animated: true)
//    }
    
    
}
