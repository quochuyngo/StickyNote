//
//  ListLayout.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 6/13/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class ListLayout: UICollectionViewFlowLayout {
    let ratio = UIScreen.main.bounds.width/375
    var height:CGFloat {
        return 60//92*ratio
    }
    var width: CGFloat {
        return collectionView!.frame.width
    }
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        setupLayout()
    }
    func setupLayout() {
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        //scrollDirection = .Vertical
    }
    
    override var itemSize: CGSize{
        set{
            self.itemSize = CGSize(width: width, height: height)
        }
        get{
            return CGSize(width: width, height:height)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return (collectionView?.contentOffset)!
    }
}
