//
//  BlockFlowLayout.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/23.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// protocol for flow
@objc protocol BlockFlowDelegate {
    // top and left gaps
    @objc optional func originVectorForLayout(_ layout: BlockFlowLayout, at indexPath: IndexPath) -> CGPoint
    
    // item size
    @objc optional func itemSizeForLayout(_ layout: BlockFlowLayout, at indexPath: IndexPath) -> CGSize
}

class BlockFlowLayout: UICollectionViewFlowLayout {
    var delegate: BlockFlowDelegate?
//    var numberOfFlow: Int = 2
 
    fileprivate var _attriArray = [UICollectionViewLayoutAttributes]()
    fileprivate var _itemMarginGuide = [Int: CGFloat]()
    override func prepare() {
        super.prepare()
        
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0

        // for rect
        _attriArray.removeAll()
        if let numberOfItems = collectionView?.numberOfItems(inSection: 0) {
            for i in 0..<numberOfItems {
                if let attri = layoutAttributesForItem(at: IndexPath(item: i, section: 0)) {
                    _attriArray.append(attri)
                }
            }
        }
    }
    
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
    
    override var collectionViewContentSize: CGSize {
        var maxX: CGFloat = 0
        var maxY: CGFloat = 0
        for attri in _attriArray {
            maxX = max(attri.frame.maxX, maxX)
            maxY = max(attri.frame.maxY, maxY)
        }
        if scrollDirection == .horizontal {
            return CGSize(width: maxX + sectionInset.right, height: 0)
        }else {
            return CGSize(width: 0, height: maxY + sectionInset.bottom)
        }
    }
    
    // attributes
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let originalAttributes = super.layoutAttributesForItem(at: indexPath)
        let attributes = originalAttributes?.copy() as? UICollectionViewLayoutAttributes
        attributes?.frame = getFrameForItem(at: indexPath)
        attributes?.zIndex = indexPath.item // maybe overlap
   
        return attributes
    }
    
    fileprivate func getFrameForItem(at indexPath: IndexPath) -> CGRect {
        let sizeOfItem = delegate?.itemSizeForLayout?(self, at: indexPath) ?? itemSize
        let originVector = delegate?.originVectorForLayout?(self, at: indexPath) ?? CGPoint.zero
        
//        let flowIndex = indexPath.item % numberOfFlow
        
        var calcultedFrame = CGRect(origin: CGPoint(x: sectionInset.left + originVector.x, y: sectionInset.top + originVector.y), size: sizeOfItem)
        if indexPath.item != 0 {
            let collectionSize = collectionView?.frame.size ?? CGSize.zero
            let lastIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
            let lastFrame = getFrameForItem(at: lastIndexPath)
            
//            var calcultedFrame = CGRect(origin: originVector, size: <#T##CGSize#>
//                x: lastFrame.maxX + originVector.x, y: lastFrame.maxY + originVector.y, width: sizeOfItem.width, height: sizeOfItem.height)
//
            if scrollDirection == .horizontal {
                calcultedFrame.origin = CGPoint(x: lastFrame.minX + originVector.x, y: lastFrame.maxY + originVector.y)
                if calcultedFrame.maxY > collectionSize.height - sectionInset.bottom {
                    // next column
                    calcultedFrame.origin = CGPoint(x: lastFrame.maxX + originVector.x, y: sectionInset.top + originVector.y)
                }
            }else {
                calcultedFrame.origin = CGPoint(x: lastFrame.maxX + originVector.x, y: lastFrame.minY + originVector.y)
                if calcultedFrame.maxX > collectionSize.width - sectionInset.right {
                    // next row
                    calcultedFrame.origin = CGPoint(x: sectionInset.left + originVector.x, y: lastFrame.maxY + originVector.y)
                }
            }
        }
        
//        if scrollDirection == .horizontal {
//            _itemMarginGuide[flowIndex] = calcultedFrame.maxX
//        }else {
//            _itemMarginGuide[flowIndex] = calcultedFrame.maxY
//        }
        
        return calcultedFrame
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return _attriArray
    }
    
}

