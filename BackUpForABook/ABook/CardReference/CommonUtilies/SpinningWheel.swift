//
//  SpinningWheel.swift
//  UIDesignCollection
//
//  Created by iMac on 16/11/3.
//  Copyright © 2016年 LyTsai. All rights reserved.
//
//

import Foundation

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    var angle: CGFloat = 0 {
        didSet {
            zIndex = 10000 - Int(abs(10 * angle))
            transform = CGAffineTransform.identity
            transform = transform.rotated(by: angle)
            transform = transform.scaledBy(x: 1.0 - 0.08 * abs(angle), y: 1.0 - 0.08 * abs(angle))
        }
    }
    
    override func copy(with zone: NSZone?) -> Any {
        let copiedAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
}

// default card size
let defaultItemSize = CGSize(width: 350, height: 350)

class CircularCollectionViewLayout: UICollectionViewLayout {
    // atual card size
    var itemSize: CGSize = CardTemplateView.defaultSize
    
    // fading factor when the card is away from the center.  use smaller value for making card behind less visible
    var fading: CGFloat = 0.2
    // zooming factor
    var zoom: CGFloat = 1.0
    // overlap ratio between items
    var overlap : CGFloat = 0.0
    
    // index and angle offset of current item closest tot the center
    var minIndex = -1
    var minAngle = CGFloat(MAXFLOAT)
    
    // last content offset
    var lastOffset: CGFloat = 0.0
    
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ?
            -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
    }
    // angle of the very first item
    var angle: CGFloat {
        return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize.width -
            collectionView!.bounds.width)
    }
    var radius: CGFloat = 1600 {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return atan(itemSize.width * (1.0 - overlap) / radius)
    }
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width, height: collectionView!.bounds.height)
    }
    
    override class var layoutAttributesClass : AnyClass {
        return CircularCollectionViewLayoutAttributes.self
    }
    
    var attributesList = [CircularCollectionViewLayoutAttributes]()
    override func prepare() {
        super.prepare()
        
        let centerX = collectionView!.contentOffset.x + (collectionView!.bounds.width / 2.0)
        let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
        
        // compute the "visible" card index range
        // 1 the half angle width of collection view
        let theta = atan2(collectionView!.bounds.width/2.0, radius + (itemSize.height/2.0) - (collectionView!.bounds.height/2.0)) //1
        //2 for getting the visible cards that falls within this index range
        var startIndex = 0
        var endIndex = collectionView!.numberOfItems(inSection: 0) - 1
        //3 find the true visible
        if (angle < -theta) {
            startIndex = Int(floor((-theta - angle)/anglePerItem))
        }
        //4
        endIndex = min(endIndex, Int(ceil((theta - angle)/anglePerItem)))
        //5
        if (endIndex < startIndex) {
            endIndex = 0
            startIndex = 0
        }
        // find the card colosest to the center position
        minIndex = -1
        minAngle = CGFloat(MAXFLOAT)
        
        attributesList = (0..<collectionView!.numberOfItems(inSection: 0)).map { (i)
            -> CircularCollectionViewLayoutAttributes in
            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: Foundation.IndexPath(item: i, section: 0))
            // default setting
            attributes.size = itemSize
            attributes.center = CGPoint(x: centerX, y: self.collectionView!.bounds.midY)
            attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            
            // special settings
            // show or hide?
            if (i < startIndex || i > endIndex) {
                attributes.alpha = 0.0
            }else {
                attributes.alpha = 1.0 - fading * abs(attributes.angle) / theta
            }
            
            if minIndex == -1 || abs(attributes.angle) < minAngle {
                minIndex = i
                minAngle = abs(attributes.angle)
            }
            
            return attributes
        }
        
        if minIndex >= 0 {
            // the card at center shows all
            attributesList[minIndex].alpha = 1.0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes {
            return attributesList[indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // proposed angle of item 0
        let angle0 = angleAtExtreme * proposedContentOffset.x / (collectionViewContentSize.width -
            collectionView!.bounds.width)
        var minAngle = CGFloat(MAXFLOAT)
        var angle: CGFloat = 0
        
        for i in 0 ..< attributesList.count {
            angle = angle0 + CGFloat(i) * self.anglePerItem
            if abs(angle) < abs(minAngle) {
                minAngle = angle
            }
        }
        
        if (proposedContentOffset.x > lastOffset) {
            minAngle += anglePerItem
        }else if (proposedContentOffset.x < lastOffset) {
            minAngle -= anglePerItem
        }else {
            minAngle = 0
        }
        
        let offset = minAngle * (collectionViewContentSize.width - collectionView!.bounds.width) / angleAtExtreme
        
        let changedCenter = CGPoint(x: proposedContentOffset.x - offset, y: proposedContentOffset.y)
        lastOffset = proposedContentOffset.x - offset
        
        return changedCenter
    }
}
