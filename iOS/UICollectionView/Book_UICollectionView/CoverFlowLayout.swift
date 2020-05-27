//
//  CoverFlowLayout.swift
//  Book_UICollectionView
//
//  Created by iMac on 16/11/28.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class CoverFlowFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        setupInit()
    }
    
    func setupInit() {
        scrollDirection = .horizontal
        itemSize = CGSize(width: 180, height: 180)
        
        minimumLineSpacing = -60  // Gets items up close to one another
        minimumInteritemSpacing = 700 // only one row
    }
    
    // now, the attributes is custom
    override class var layoutAttributesClass : AnyClass{
        return CoverFlowLayoutAttributes.self
    }
    
    //  re-layout the cells when scrolling
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesArray = super.layoutAttributesForElements(in: rect)!
        let visibleRect = CGRect(x: collectionView!.contentOffset.x, y: collectionView!.contentOffset.y, width: collectionView!.bounds.width, height: collectionView!.bounds.height)
        
        for attributes in layoutAttributesArray {
            if attributes.frame.intersects(rect) {
                applyLayoutAttributes(attributes, forVisibleRect: visibleRect)
            }
        }
        
        return layoutAttributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)!
        let visibleRect = CGRect(x: collectionView!.contentOffset.x, y: collectionView!.contentOffset.y, width: collectionView!.bounds.width, height: collectionView!.bounds.height)
        applyLayoutAttributes(attributes, forVisibleRect: visibleRect)
        
        return attributes
    }
    
    var activeDistance: CGFloat = 100
    var translateDistance: CGFloat = 100
    var zoomFactor: CGFloat = 0.2
    var flowOffset: CGFloat = 40
    var inactiveGrayValue: CGFloat = 0.6
    func applyLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes, forVisibleRect visibleRect: CGRect)  {
        // skip supplementary views
        if (attributes.representedElementKind != nil) { return }
        
        let distanceFromVisibleRectToItem = visibleRect.midX - attributes.center.x
        let normalizedDistance = distanceFromVisibleRectToItem / activeDistance
        let isLeft = distanceFromVisibleRectToItem > 0
        var transform = CATransform3DIdentity
        var maskAlpha: CGFloat = 0
        
        if abs(distanceFromVisibleRectToItem) < activeDistance {
            // We're close enough to apply the transform in relation to how far away from the center we are.
            transform = CATransform3DTranslate(CATransform3DIdentity, (-flowOffset * distanceFromVisibleRectToItem / translateDistance), 0,  (1 - abs(normalizedDistance)) * 40000 + (isLeft ? 200 : 0))
            let zoom = 1 + zoomFactor * (1 - abs(normalizedDistance))
            transform = CATransform3DRotate(transform, normalizedDistance * CGFloat(M_PI_4), 0, 1, 0)
            transform = CATransform3DScale(transform, zoom, zoom, 1)
            attributes.zIndex = 1
            
            maskAlpha = inactiveGrayValue * abs(normalizedDistance)
        }else {
            // We're too far away - just apply a standard perspective transform.
            transform.m34 = -1 / (4.6777 * itemSize.width)
            transform = CATransform3DTranslate(transform, isLeft ? -flowOffset : flowOffset, 0, 0)
            transform = CATransform3DRotate(transform, (isLeft ? 1 : -1) * CGFloat(M_PI_4), 0, 1, 0)
            attributes.zIndex = 0
            maskAlpha = inactiveGrayValue
        }
        attributes.transform3D = transform
        
        // Rasterize the cells for smoother edges.
        let attribute = attributes as! CoverFlowLayoutAttributes
        attribute.shouldRasterize = true
        attribute.maskingValue = maskAlpha
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat(MAXFLOAT)
        let horizontalCenter = proposedContentOffset.x + collectionView!.bounds.width * 0.5
        
        let proposedRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: collectionView!.bounds.size)
        let array = layoutAttributesForElements(in: proposedRect)!
        
        for layoutAttributes in array {
            // skip supplementary views
            if layoutAttributes.representedElementCategory != UICollectionView.ElementCategory.cell {
                continue
            }
            
            let itemHorizontalCenter = layoutAttributes.center.x
            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}

class CoverFlowLayoutAttributes: UICollectionViewLayoutAttributes {
    var shouldRasterize = true
    var maskingValue: CGFloat = 1.0
    
    override func copy(with zone: NSZone?) -> Any {
        let attributes = super.copy(with: zone) as! CoverFlowLayoutAttributes
        attributes.shouldRasterize = shouldRasterize
        attributes.maskingValue = maskingValue
        
        return attributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if (object! as AnyObject).isKind(of: CoverFlowLayoutAttributes.self){
            let other = object as! CoverFlowLayoutAttributes
            return super.isEqual(other) && (shouldRasterize == other.shouldRasterize) && (maskingValue == other.maskingValue)
        }
        return super.isEqual(object)
    }
}
