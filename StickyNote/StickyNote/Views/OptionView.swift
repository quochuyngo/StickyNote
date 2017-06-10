//
//  OptionView.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 5/29/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

protocol OptionViewDelegate {
    func onSelectOption(option: NoteOptions)
}

class OptionView: UIView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var panelView: UIView!
    var delegate: OptionViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        let nib = UINib(nibName: String(describing: OptionView.self) , bundle: Bundle(for: OptionView.self))
        nib.instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        
        setConstraint()
        initCells()
        tableView.dataSource = self
        tableView.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap( _:)))
        contentView.addGestureRecognizer(gesture)
    }
    
    func initCells() {
        tableView.register(UINib(nibName: String(describing: ItemOptionCell.self), bundle: Bundle(for: ItemOptionCell.self)), forCellReuseIdentifier: "itemOptionCell")
    }
    
    func setConstraint() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: self,attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }

    func onTap(_ sender: AnyObject) {
        //removeFromSuperview()
    }
}

extension OptionView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemOptionCell") as! ItemOptionCell
        switch indexPath.row {
        case 0:
            cell.optionNameLabel.text = "Lock"
            
            break
        case 1:
            cell.optionNameLabel.text = "Delete"
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.onSelectOption(option: .lock)
            removeFromSuperview()
            break
        case 1:
            delegate?.onSelectOption(option: .delete)
            removeFromSuperview()
            break
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
