//
//  CoverFlowLayout.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/10/27.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class CoverFlowLayout: UICollectionViewFlowLayout {
    // prepre layout
    override func prepare() {
        super.prepare()
        
        minimumLineSpacing = -5
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // layout
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attriArray = super.layoutAttributesForElements(in: rect)
        
        for attri in attriArray! {
             applyLayoutAttributes(attri, forVisibleRect: rect)
        }
   
        return attriArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attri = super.layoutAttributesForItem(at: indexPath)!
        
        let visibleRect = CGRect(x: collectionView!.contentOffset.x, y: collectionView!.contentOffset.y, width: collectionView!.bounds.width, height: collectionView!.bounds.height)
        applyLayoutAttributes(attri, forVisibleRect: visibleRect)
        
        return attri
    }
    
    fileprivate func applyLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes, forVisibleRect visibleRect: CGRect) {
        var activeDistance: CGFloat = itemSize.width * 1.5
        var translateDistance: CGFloat = 100
        var zoomFactor: CGFloat = 0.2
        var flowOffset: CGFloat = 10
//
        let middleShift = visibleRect.midX - attributes.center.x
        let normalizedDistance = middleShift / activeDistance
        let isLeft = middleShift > 0
        var transform = CATransform3DIdentity
//
        if fabs(middleShift) < activeDistance {
            transform = CATransform3DTranslate(CATransform3DIdentity, (-flowOffset * middleShift / translateDistance), 0,  (1 - fabs(normalizedDistance)) * 40000 + (isLeft ? 200 : 0))
            let zoom = 1 + zoomFactor * (1 - abs(normalizedDistance))
            transform = CATransform3DRotate(transform, normalizedDistance * CGFloat(Double.pi) / 4, 0, 1, 0)
            transform = CATransform3DScale(transform, zoom, zoom, 1)
            attributes.zIndex = 1
        }else {
            transform.m34 = -1 / (4.6777 * itemSize.width)
            transform = CATransform3DTranslate(transform, isLeft ? -flowOffset : flowOffset, 0, 0)
            transform = CATransform3DRotate(transform, (isLeft ? 1 : -1) * CGFloat(Double.pi) / 4, 0, 1, 0)
            attributes.zIndex = 0
        }
        attributes.transform3D = transform
    }
    
    
    // keep one in center
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat(MAXFLOAT)
        let horizontalCenter = proposedContentOffset.x + collectionView!.bounds.midX
        let proposedRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: collectionView!.bounds.size)
        let array = layoutAttributesForElements(in: proposedRect)!
        
        for layoutAttributes in array {
            let itemHorizontalCenter = layoutAttributes.center.x
            if fabs(itemHorizontalCenter - horizontalCenter) < fabs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
