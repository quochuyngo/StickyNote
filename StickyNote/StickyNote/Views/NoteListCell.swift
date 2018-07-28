//
//  NoteListCell.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 5/27/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class NoteListCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var boderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!
    
    var data: Note? {
        didSet {
            guard let note = data else { return }
            if let color = note.category?.color {
                setColor(color: color)
            }
            titleLabel.text = note.title
            createdTimeLabel.text = note.formatDate()
            lockImageView.isHidden = !note.isLocked
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setColor(color:CategoryColor) {
        let color = ColorManager.shared.getColor(with: color)
        cellView.backgroundColor = color.bgColor
        boderView.backgroundColor = color.color
    }

}
