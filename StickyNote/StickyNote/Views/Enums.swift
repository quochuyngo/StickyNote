//
//  Enums.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 5/27/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

enum DisplayType {
    case list
    case grid
    //case details
}

enum NoteOptions: String {
    case lock = "Lock"
    case delete = "Delete"
    case unlock = "Unlock"
}

enum NoteState: String {
    case edit
    case new
}
