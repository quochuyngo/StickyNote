//
//  Category.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 5/27/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import RealmSwift

class Category: Object{
    dynamic var name: String = ""
    dynamic var colorString = CategoryColor.yellow.rawValue
    var color: CategoryColor {
        get {
            return CategoryColor(rawValue: colorString)!
        }
        set {
            colorString = newValue.rawValue
        }
    }
    
    convenience init (name: String = "no tile", color: CategoryColor = CategoryColor.yellow) {
        self.init()
        self.name = name
        self.color = color
    }
}

enum CategoryColor: String {
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
    case white
    case brown
    case black
}

