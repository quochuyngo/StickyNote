//
//  GridLayout.swift
//  StickyNote
//
//  Created by Quoc Huy Ngo on 6/12/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    var width:CGFloat {
        return  collectionView!.frame.width/3
    }
    
    var height: CGFloat {
        return width + width/9
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
    }
    
    override var itemSize: CGSize{
        set{
            self.itemSize = CGSize(width: width, height: height)
        }
        get{
            return CGSize(width: width, height: height)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return (collectionView?.contentOffset)!
    }

}
