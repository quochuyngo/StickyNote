//
//  PassCodeManager.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 6/9/18.
//  Copyright © 2018 Quoc Huy Ngo. All rights reserved.
//

import Foundation

class PassCodeManager {
    static var passCode: String? {
        get {
            return UserDefaults.standard.object(forKey: "passcode") as? String
        }
        set (value) {
            UserDefaults.standard.set(value, forKey: "passcode")
            UserDefaults.standard.synchronize()
        }
    }
}
