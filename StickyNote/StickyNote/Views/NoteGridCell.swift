//
//  NoteGridCell.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 6/12/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class NoteGridCell: UICollectionViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var boderView: UIView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var lockImageView: UIImageView!
    
    var data: Note? {
        didSet {
            guard let note = data else { return }
            if let color = note.category?.color {
                setColor(color: color)
            }
            titleLabel.text = note.title
            contentLabel.text = note.content
            lockImageView.isHidden = !note.isLocked
            contentLabel.isHidden = note.isLocked
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLabel.sizeToFit()
    }

    func setColor(color:CategoryColor) {
        let color = ColorManager.shared.getColor(with: color)
        cellView.backgroundColor = color.bgColor
        boderView.backgroundColor = color.color
    }

}
