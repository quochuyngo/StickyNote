//
//  CustomTextView.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 5/26/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    var categoryColor: CategoryColor = .yellow
    let width = UIScreen.main.bounds.width
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(Color.yellowBG.cgColor)
        context?.setLineWidth(1.0)
        
        context?.beginPath()
        let numberOfLines = (contentSize.height + bounds.height)/(font?.lineHeight)!
        let baselineOffset:CGFloat = 5.0
        for i in 0...Int(numberOfLines) {
            let y:CGFloat = (font?.lineHeight)!*CGFloat(i) + baselineOffset
            context?.move(to: CGPoint(x: bounds.origin.x, y: y))
            context?.addLine(to: CGPoint(x: bounds.width, y: y))
        }
        context?.closePath()
        context?.strokePath()
    }

}
