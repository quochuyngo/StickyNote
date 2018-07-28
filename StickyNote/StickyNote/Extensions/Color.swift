//
//  Colors.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 5/26/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
class Color {
    static var redBG = UIColor("#FFCDD2")
    static var orangeBG = UIColor("#FFD180")
    static var yellowBG = UIColor("#FFFF8D")
    static var yellow = UIColor("#FFEB3B")
    static var greenBG = UIColor("#CCFF90")
    static var blueBG = UIColor("#BBDEFB")
    static var blue = UIColor("#2196F3")
    static var purpleBG = UIColor("#E1BEE7")
    static var brownBG = UIColor("#D7CCC8")
    static var blackBG = UIColor("#9E9E9E")
    static var pinkBG = UIColor("#F8BBD0")
    static var white = UIColor("#95a5a6")
    static var barTint = UIColor("#FFEB3B")//UIColor("#e2e2e2")
    
    static func getColorByCategory(category: CategoryColor, isBackground: Bool = true) -> UIColor {
        switch category {
        case .black:
            if isBackground {
                return blackBG
            } else {
                return UIColor.black
            }
        case .blue:
            if isBackground {
                return blueBG
            } else {
                return Color.blue
            }
        case .brown:
            if isBackground {
                return brownBG
            } else {
                return UIColor.brown
            }
        case .green:
            if isBackground {
                return greenBG
            } else {
                return UIColor.green
            }
        case .orange:
            if isBackground {
                return orangeBG
            } else {
                return UIColor.orange
            }
        case .purple:
            if isBackground {
                return purpleBG
            } else {
                return UIColor.purple
            }
        case .red:
            if isBackground {
                return redBG
            } else {
                return UIColor.red
            }
        case .white:
            if isBackground {
                return UIColor.white
            } else {
                return white
            }
        case .yellow:
            if isBackground {
                return yellowBG
            } else {
                return yellow
            }

        }
    }
}
