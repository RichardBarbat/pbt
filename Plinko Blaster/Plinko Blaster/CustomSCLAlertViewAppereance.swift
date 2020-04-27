//
//  CustomSCLAlertViewAppereance.swift
//  Plinko Blaster
//
//  Created by Richardius von Barbat-Dos on 26.04.20.
//  Copyright © 2020 me. All rights reserved.
//

import GameKit
import SCLAlertView


let myCustomAlertAppereance = SCLAlertView.SCLAppearance(
    kDefaultShadowOpacity: 0.7,
    kCircleTopPosition: 0.0,
    kCircleBackgroundTopPosition: -30.0,
    kCircleHeight: 100.0,
    kCircleIconHeight: 100.0,
    kTitleTop: 25.0,
    kTitleHeight: 50.0,
    kWindowWidth: Screen.width * 0.8,
    kWindowHeight: 200.0,
    kTextHeight: 200.0,
    kTextFieldHeight: 200.0,
    kTextViewdHeight: 200.0,
    kButtonHeight: 50.0,
    kTitleFont: UIFont(name: "PixelSplitter", size: 26)!,
    kTitleMinimumScaleFactor: 1.0,
    kTextFont: UIFont(name: "PixelSplitter", size: 14)!,
    kButtonFont: UIFont(name: "PixelSplitter", size: 20)!,
    showCloseButton: false,
    showCircularIcon: true,
    shouldAutoDismiss: false,
    contentViewCornerRadius: 10.0,
    fieldCornerRadius: 5.0,
    buttonCornerRadius: 5.0,
    hideWhenBackgroundViewIsTapped: false,
    circleBackgroundColor: .green,
    contentViewColor: UIColor(hexFromString: "242d24"),
    contentViewBorderColor: .green,
    titleColor: .green,
    dynamicAnimatorActive: false,
    disableTapGesture: false,
    buttonsLayout: .vertical,
    activityIndicatorStyle: .medium)


func showMessage(title:String = "No Title",
                 text:String = "No Text",
                 icon:UIImage = UIImage(named: "mr_robo")!,
                 closeButton:String = "CLOSE") {
    
    let alertView = SCLAlertView(appearance: myCustomAlertAppereance)
    let alertViewResponder = SCLAlertViewResponder(alertview: alertView)
    // set borderwidth
    alertView.view.subviews[0].subviews[0].layer.borderWidth = Screen.width * 0.01
    //set alignment to left for text
    for view in alertView.view.subviews[0].subviews[0].subviews {
        if view.isKind(of: UITextView.self) {
            (view as! UITextView).textAlignment = .left
            (view as! UITextView).textContainerInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
            
        }
    }
    
    alertView.addButton(closeButton.uppercased()) {
        
//        print("\(closeButton.uppercased()) button tapped")
        
        runHaptic(intensity: 1, sharpness: 0)
        alertViewResponder.close()
    }
    
    
    alertView.showCustom(title.uppercased(),
                         subTitle: text.uppercased(),
                         color: UIColor(hexFromString: "242d24"),
                         icon: icon,
                         closeButtonTitle: nil,
                         timeout: nil,
                         colorStyle: 0x123456, // ???
                         colorTextButton: 0xFFFF00,
                         circleIconImage: UIImage(named: "mr_robo")!,
                         animationStyle: .topToBottom)
    
}
