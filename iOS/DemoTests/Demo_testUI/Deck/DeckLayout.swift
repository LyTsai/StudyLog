//
//  DeckLayout.swift
//  WholeSHIELD
//
//  Created by L on 2020/7/16.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation

class DeckLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        self.scrollDirection = .horizontal
        self.minimumInteritemSpacing = 1000
        self.minimumLineSpacing = -itemSize.width
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var attris = [UICollectionViewLayoutAttributes]()
        for i in 0..<collectionView!.numberOfItems(inSection: 0) {
            if let attri = layoutAttributesForItem(at: IndexPath(item: i, section: 0)) {
                attris.append(attri)
            }
        }
        
        return attris
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes

        let itemSize = attributes?.size
//        attributes?.center = CGPoint(x: itemSize?.width ?? 0, y: itemSize?.height ?? 0)
        attributes?.transform3D = CATransform3DRotate(CATransform3DIdentity, CGFloat(indexPath.item) * CGFloatPi / 10, 0, 0, 1)
        attributes?.zIndex = -indexPath.item
        return attributes
    }
}
