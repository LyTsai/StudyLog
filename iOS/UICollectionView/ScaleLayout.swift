//
//  ScaleLayout.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/10/23.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation
import UIKit

class ScaleLayout: UICollectionViewFlowLayout {
    var minRatio: CGFloat = 0.6
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        minimumInteritemSpacing = 1000
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let orginalArray = super.layoutAttributesForElements(in: rect)
        let curArray = orginalArray ?? []
        let centerX = collectionView!.contentOffset.x + collectionView!.bounds.width * 0.5
        
        for attrs in curArray {
            let space = abs(attrs.center.x - centerX)
            let scale = max(minRatio, min(1 - space / collectionView!.bounds.width,1))
            attrs.transform = CGAffineTransform(scaleX: scale, y: scale)
            attrs.zIndex = -Int(space)
        }
        
        return curArray
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat(MAXFLOAT)
        let horizontalCenter = proposedContentOffset.x + collectionView!.bounds.width * 0.5
        let proposedRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: collectionView!.bounds.size)
        let array = layoutAttributesForElements(in: proposedRect)!
        
        for layoutAttributes in array {
            // skip supplementary views
            if layoutAttributes.representedElementCategory != UICollectionView.ElementCategory.cell { continue }
            let itemHorizontalCenter = layoutAttributes.center.x
            if fabs(itemHorizontalCenter - horizontalCenter) < fabs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
