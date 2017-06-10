//
//  TextEditorCell.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 6/10/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class TextEditorCell: UITableViewCell {

    @IBOutlet weak var timeCreatedLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var textView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
