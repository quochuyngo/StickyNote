//
//  CategoryColorView.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 5/28/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

protocol CategoryColorViewDelegate {
    func onColorButtonTap(category: CategoryColor)
}
class CategoryColorView: UIView {

    @IBOutlet weak var withConstraint: NSLayoutConstraint!
    @IBOutlet weak var panelView: UIView!
    @IBOutlet var contentView: UIView!
    let ratio = UIScreen.main.bounds.width/375
    var delegate: CategoryColorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var brownButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    
     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        let nib = UINib(nibName: String(describing: CategoryColorView.self) , bundle: Bundle(for: CategoryColorView.self))
        nib.instantiate(withOwner: self, options: nil)
        panelView.boderAndCorner()
        addSubview(contentView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap( _:)))
        contentView.addGestureRecognizer(gesture)
        setConstraint()
    }

    func setConstraint() {
        withConstraint.constant *= ratio
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: self,attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
    
    func onTap(_ sender: AnyObject) {
        removeFromSuperview()
    }

    @IBAction func onWhiteTap(_ sender: Any) {
        delegate?.onColorButtonTap(category: .white)
        removeFromSuperview()
    }
    @IBAction func onBrownTap(_ sender: Any) {
        delegate?.onColorButtonTap(category: .brown)
        removeFromSuperview()
    }
    @IBAction func onBlackTap(_ sender: Any) {
        delegate?.onColorButtonTap(category: .black)
        removeFromSuperview()
    }
    @IBAction func onPurpleTap(_ sender: Any) {
        delegate?.onColorButtonTap(category: .purple)
        removeFromSuperview()
    }
    @IBAction func onBlueTap(_ sender: Any) {
        delegate?.onColorButtonTap(category: .blue)
        removeFromSuperview()
    }
    @IBAction func onGreenTap(_ sender: Any) {
        delegate?.onColorButtonTap(category: .green)
        removeFromSuperview()
    }
    @IBAction func onYellowTap(_ sender: Any) {
        delegate?.onColorButtonTap(category: .yellow)
        removeFromSuperview()
    }
    
    @IBAction func onOrangeTap(_ sender: Any) {
        delegate?.onColorButtonTap(category: .orange)
        removeFromSuperview()
    }
    @IBAction func onRedTap(_ sender: Any) {
        delegate?.onColorButtonTap(category: .red)
        removeFromSuperview()
    }
    
}
