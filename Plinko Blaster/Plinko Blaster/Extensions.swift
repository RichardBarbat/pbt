//
//  Extension.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 15.03.19.
//  Copyright © 2019 me. All rights reserved.
//
import GameKit

enum UIUserInterfaceIdiom: Int {
    case undefined
    case phone
    case pad
}

struct Screen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let center = CGPoint(x: Screen.width / 2, y: Screen.height / 2)
    static let maxWidth = max(Screen.width, Screen.height)
    static let maxHeight = max(Screen.width, Screen.height)
}

struct Color {
    static let yellow = UIColor(hexFromString: "edff25")
}

struct DeviceType {
    static let isiPhone4OrLess = UIDevice.current.userInterfaceIdiom == .phone && Screen.maxHeight < 568.0
    static let isiPhone5 = UIDevice.current.userInterfaceIdiom == .phone && Screen.maxHeight == 568.0
    static let isiPhone6 = UIDevice.current.userInterfaceIdiom == .phone && Screen.maxHeight == 667.0
    static let isiPhone6Plus = UIDevice.current.userInterfaceIdiom == .phone && Screen.maxHeight == 736.0
    static let isiPhoneX = UIDevice.current.userInterfaceIdiom == .phone && Screen.maxHeight == 812.0
    
    static let isiPad = UIDevice.current.userInterfaceIdiom == .pad && Screen.maxHeight == 1024.0
    static let isiPadPro = UIDevice.current.userInterfaceIdiom == .pad && Screen.maxHeight == 1366.0
}

extension UIColor {
    
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static func random() -> UIColor {
        return UIColor(rgb: Int(CGFloat(arc4random()) / CGFloat(UINT32_MAX) * 0xFFFFFF))
    }
}

extension SKNode {
    
    func addGlow(radius:CGFloat=30) {
        let view = SKView()
        let effectNode = SKEffectNode()
        let texture = view.texture(from: self)
        effectNode.filter = CIFilter(name: "CIGaussianBlur",parameters: ["inputRadius":radius])
        effectNode.blendMode = .add
        effectNode.position = CGPoint(x: self.position.x, y: self.position.y )
        effectNode.shouldCenterFilter = true
        effectNode.shouldEnableEffects = true
        effectNode.shouldRasterize = true
        effectNode.name = "glow"
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
    }
    
    func run(action: SKAction!, withKey: String!, optionalCompletion:(() -> Void)?) {
        if let completion = optionalCompletion
        {
            let completionAction = SKAction.run(completion)
            let compositeAction = SKAction.sequence([ action, completionAction ])
            run(compositeAction, withKey: withKey )
        } else {
            run( action, withKey: withKey )
        }
    }
    
    func actionForKeyIsRunning(key: String) -> Bool {
        return self.action(forKey: key) != nil ? true : false
    }
}


func background(work: @escaping () -> ()) {
    DispatchQueue.global(qos: .userInitiated).async {
        work()
    }
}


func main(work: @escaping () -> ()) {
    DispatchQueue.main.async {
        work()
    }
}

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}

public extension Int {
    
    var seconds: DispatchTimeInterval {
        return DispatchTimeInterval.seconds(self)
    }
    
    var second: DispatchTimeInterval {
        return seconds
    }
    
    var milliseconds: DispatchTimeInterval {
        return DispatchTimeInterval.milliseconds(self)
    }
    
    var millisecond: DispatchTimeInterval {
        return milliseconds
    }
    
}

public extension DispatchTimeInterval {
    var fromNow: DispatchTime {
        return DispatchTime.now() + self
    }
}
