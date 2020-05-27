//
//  CoverFlowLayout.swift
//  AnnielyticX
//
//  Created by iMac on 2018/3/19.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class CoverFlowLayout: UICollectionViewFlowLayout {
//    var attributes = [UICollectionViewLayoutAttributes]()
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        minimumInteritemSpacing = 1000
        minimumLineSpacing = -itemSize.width * 0.12
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let originAttributes = super.layoutAttributesForElements(in: rect) ?? []
        
        var attributesArray = [UICollectionViewLayoutAttributes]()
        for one in originAttributes {
            attributesArray.append(one.copy() as! UICollectionViewLayoutAttributes)
        }
        
        for attributes in attributesArray {
            let shifting = collectionView!.contentOffset.x + collectionView!.bounds.width * 0.5 - attributes.center.x
            
            // overlap
            attributes.zIndex = -Int(abs(shifting))
            
            // alpha
            attributes.alpha = (abs(shifting) <= itemSize.width * 0.5) ? 1 : 0.6
            
            // transform
            let normalizedDistance = shifting / itemSize.width
            let scale = 1 - 0.1 * abs(normalizedDistance)
            var transform = CATransform3DIdentity
            transform.m34 = -1 / (4.6777 * itemSize.width)
            transform = CATransform3DRotate(transform, normalizedDistance * CGFloat(Double.pi / 5), 0, 1, 0)
            transform = CATransform3DScale(transform, scale, scale, 1)
            attributes.transform3D = transform
        }
        
        return attributesArray
    }
//
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//
//    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let rect = CGRect(x: proposedContentOffset.x, y: proposedContentOffset.y, width: collectionView!.bounds.width, height: collectionView!.bounds.height)
        let attributesArray = layoutAttributesForElements(in: rect) ?? []
        
        var offsetX = collectionView!.bounds.width // max gap
        for (_, attributes) in attributesArray.enumerated()  {
            if attributes.representedElementCategory != UICollectionView.ElementCategory.cell {
                continue
            }
            
            if abs(attributes.center.x - rect.midX) < abs(offsetX) {
                offsetX = attributes.center.x - rect.midX
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetX, y: proposedContentOffset.y)
    }
}
