//
//  MessageManager.swift
//  Plinko Blaster
//
//  Created by Richardius von Barbat-Dos on 24.05.20.
//  Copyright © 2020 me. All rights reserved.
//

import Foundation
import SpriteKit

protocol MessageManager { }
extension MessageManager where Self: SKScene {

    func showAlert(withTitle title: String, message: String, okButtonAction:DOAlertAction = DOAlertAction(title: "", style: .default, handler: nil), showCancelButton: Bool = true, showOkButtonOnlyWithoutAction: Bool = false, alternativeTitleForOkButton: String = "", alternativeColorForOkButton: UIColor = UIColor.clear, alternativeTitleForCancelButton: String = "") {
        
        var okButtonTitle: String = "OK".uppercased()
        if alternativeTitleForOkButton != "" {
            okButtonTitle = alternativeTitleForOkButton.uppercased()
        }
        var cancelButtonTitle: String = "CANCEL".uppercased()
        if alternativeTitleForCancelButton != "" {
            cancelButtonTitle = alternativeTitleForCancelButton.uppercased()
        }
        var okButtonColor: UIColor = UIColor.green
        if alternativeColorForOkButton != UIColor.clear {
            okButtonColor = alternativeColorForOkButton
        }
        
        let alertController = DOAlertController(title: title.uppercased(), message: message.uppercased(), preferredStyle: .alert)
        
        alertController.alertViewBgColor = .init(hexFromString: "242d24")
        alertController.titleFont = UIFont(name: "PixelSplitter", size: 30)
        alertController.titleTextColor = .green
        alertController.messageFont = UIFont(name: "PixelSplitter", size: 16)
        alertController.messageTextColor = .green
        
        alertController.buttonFont[.default] = UIFont(name: "PixelSplitter", size: 25)
        alertController.buttonTextColor[.default] = okButtonColor
        alertController.buttonBgColor[.default] = .init(hexFromString: "242d24")
        alertController.buttonBgColorHighlighted[.default] = .init(hexFromString: "242d24")
        
        alertController.buttonFont[.destructive] = UIFont(name: "PixelSplitter", size: 25)
        alertController.buttonTextColor[.destructive] = .red
        alertController.buttonBgColor[.destructive] = .init(hexFromString: "242d24")
        alertController.buttonBgColorHighlighted[.destructive] = .init(hexFromString: "242d24")
        
        alertController.alertView.layer.cornerRadius = 5
        
        if showOkButtonOnlyWithoutAction == true {
            let cancelAction = DOAlertAction(title: okButtonTitle.uppercased(), style: .default, handler: { _ in
                runHaptic()
            })
            alertController.addAction(cancelAction)
        } else if okButtonAction.handler != nil && okButtonAction.title != "" {
            alertController.addAction(okButtonAction)
        }
        
        if showCancelButton == true {
            let cancelAction = DOAlertAction(title: cancelButtonTitle.uppercased(), style: .destructive, handler: { _ in
                runHaptic()
            })
            alertController.addAction(cancelAction)
        }
        
        if alertController.actions.count > 0 {
            
            for button in alertController.buttons {
                button.setTitleColor(.red, for: .selected)
                button.setTitleColor(.red, for: .highlighted)
            }
            
            view?.window?.rootViewController?.present(alertController, animated: true)
        }
        
    }
}
