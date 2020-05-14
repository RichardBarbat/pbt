//
//  Extension.swift
//  Plinko Blaster
//
//  Created by Richard Barbat on 15.03.19.
//  Copyright © 2019 me. All rights reserved.
//
import GameKit
import CoreHaptics

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

func prepareHaptics() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

    do {
        hapticEngine = try CHHapticEngine()
        try hapticEngine?.start()
    } catch {
        print("There was an error creating the engine: \(error.localizedDescription)")
    }
}

func runHaptic(intensity: Float = 1, sharpness: Float = 1) {
    
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
    var events = [CHHapticEvent]()

    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
    let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
    events.append(event)

    do {
        let pattern = try CHHapticPattern(events: events, parameters: [])
        let player = try hapticEngine?.makePlayer(with: pattern)
        try player?.start(atTime: 0)
    } catch {
        print("Failed to play pattern: \(error.localizedDescription).")
    }
}

func runCountHaptic() {
    
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
    var events = [CHHapticEvent]()

    for i in stride(from: 0, to: 1.5, by: 0.05) {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i / 1.5) + 0.4)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
        events.append(event)
    }

    for i in stride(from: 0, to: 1.5, by: 0.05) {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1.5 - i / 1.5) - 0.4)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1.5 + i)
        events.append(event)
    }

    do {
        let pattern = try CHHapticPattern(events: events, parameters: [])
        let player = try hapticEngine?.makePlayer(with: pattern)
        try player?.start(atTime: 0)
    } catch {
        print("Failed to play pattern: \(error.localizedDescription).")
    }
}


extension UIColor {
    
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt64 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt64(&rgbValue)
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

extension String {
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
}

extension SKNode {
    
    func addGlow(radius:CGFloat = 30, alpha:CGFloat = 1) {
        let view = SKView()
        let effectNode = SKEffectNode()
        
        var texture = view.texture(from: self)
        let alphaCache = self.alpha
        if self.alpha < 1 || alpha != 1 {
            self.alpha = alpha
            texture = view.texture(from: self)
            self.alpha = alphaCache
        }
        
        effectNode.filter = CIFilter(name: "CIGaussianBlur",parameters: ["inputRadius":radius])
//        effectNode.blendMode = .add
        effectNode.position = CGPoint(x: self.position.x, y: self.position.y)
        effectNode.shouldCenterFilter = true
        effectNode.shouldEnableEffects = true
        effectNode.shouldRasterize = true
        effectNode.name = "glow"
        effectNode.zPosition =  -5
        addChild(effectNode)
        
        if parent != nil && parent?.position == CGPoint(x: 0, y: 0) {

            effectNode.position = CGPoint(x: 0, y: 0)
        }
        
//        print("effectNode.zPosition = \(effectNode.zPosition)")
//        print("self.zPosition = \(self.zPosition)")
//        
//        print("parent = \(String(describing: parent))")
        
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
    
    func toUIColor() -> UIColor {
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toCGColor() -> CGColor {
        return self.toUIColor().cgColor
    }
    
}

extension UInt {
    
    func toUIColor() -> UIColor {
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toCGColor() -> CGColor {
        return self.toUIColor().cgColor
    }
}

public extension DispatchTimeInterval {
    var fromNow: DispatchTime {
        return DispatchTime.now() + self
    }
}


extension UIAlertController {
    
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
    func setCustomTitleFont(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],
                                          range: NSMakeRange(0, title.utf8.count))
        }
        
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")
    }
    
    func setCustomMessageFont(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }
    
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}
