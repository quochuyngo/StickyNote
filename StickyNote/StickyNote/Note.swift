//
//  Note.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 5/27/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import Foundation
import RealmSwift

class Note: Object {
    dynamic let id: String =  UUID().uuidString
    dynamic var title: String = ""
    dynamic var content: String = ""
    dynamic var createdTime: Date = Date()
    dynamic var isLocked: Bool = false
    dynamic var category: Category? = Category()
    
    func formatFullDateTime() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "dd/MM/yyy HH:mm"
        return formater.string(from: createdTime)
    }
    
    func formatDate() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "MMM dd"
        return formater.string(from: createdTime)
    }
}
