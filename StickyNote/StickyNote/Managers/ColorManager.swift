//
//  ColorManager.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 5/24/18.
//  Copyright © 2018 Quoc Huy Ngo. All rights reserved.
//

import UIKit

typealias SetColor = (color: UIColor, bgColor: UIColor)
class ColorManager {
    static let shared = ColorManager()
    
    func getColor(with color: CategoryColor) -> SetColor {
        switch color {
        case .black:
            return (UIColor.black, Color.blackBG)
        case .blue:
            return (Color.blue, Color.blueBG)
        case .brown:
            return (UIColor.brown, Color.brownBG)
        case .green:
            return (UIColor.green, Color.greenBG)
        case .orange:
            return (UIColor.orange, Color.orangeBG)
        case .purple:
            return (UIColor.purple, Color.purpleBG)
        case .red:
            return (UIColor.red, Color.redBG)
        case .white:
            return (Color.white, UIColor.white)
        case .yellow:
            return (Color.yellow, Color.yellowBG)
        }
    }
}
