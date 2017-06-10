//
//  NoteListCell.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 5/27/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class NoteListCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var boderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    var data: Note? {
        didSet {
            titleLabel.text = data?.title
            createdTimeLabel.text = data?.formatDate()
            if let color = data?.category?.color {
                setColor(color: color)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setColor(color:CategoryColor) {
        switch color {
        case .black:
            cellView.backgroundColor = Color.blackBG
            boderView.backgroundColor = UIColor.black
            break
        case .blue:
            cellView.backgroundColor = Color.blueBG
            boderView.backgroundColor = Color.blue
            break
        case .green:
            cellView.backgroundColor = Color.greenBG
            boderView.backgroundColor = UIColor.green
            break
        case .brown:
            cellView.backgroundColor = Color.brownBG
            boderView.backgroundColor = UIColor.brown
            break
        case .red:
            cellView.backgroundColor = Color.redBG
            boderView.backgroundColor = UIColor.red
            break
        case .orange:
            cellView.backgroundColor = Color.orangeBG
            boderView.backgroundColor = UIColor.orange
            break
        case .white:
            cellView.backgroundColor = UIColor.white
            boderView.backgroundColor = UIColor.white
            break
        case .purple:
            cellView.backgroundColor = Color.purpleBG
            boderView.backgroundColor = UIColor.purple
            break
        case .yellow:
            cellView.backgroundColor = Color.yellowBG
            boderView.backgroundColor = Color.yellow
        }
    }

}
