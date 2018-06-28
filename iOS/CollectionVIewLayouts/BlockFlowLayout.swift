//
//  BlockFlowLayout.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/23.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// protocol for flow
@objc protocol BlockFlowDataSource {
    // default as 2
    @objc optional func numberOfColsForLayout(_ layout: BlockFlowLayout) -> Int
    
    // diffferent cols
//    @objc optional func numberOfCellsForLayout(_ layout: BlockFlowLayout, atRow: Int) -> Int
    
    // default as 0
    @objc optional func topMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat
    
    // default as 0
    @objc optional func leftMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat
    
    // default as itemSize
    @objc optional func itemSizeForLayout(_ layout: BlockFlowLayout, at indexPath: IndexPath) -> CGSize
    
    // edgeInset
    @objc optional func sectionEdgeInsetsForLayout(_ layout: BlockFlowLayout) -> UIEdgeInsets
    
    // for draw
    @objc optional func anchorPointAt(_ indexPath: IndexPath) -> CGPoint
//    @objc optional func anchorPositonAt(_ indexPath: IndexPath) -> PositionOfAnchor
}

class BlockFlowLayout: UICollectionViewFlowLayout {
    var dataSource: BlockFlowDataSource!
    
    var maxYs = [Int : CGFloat]()
    var attriArray = [UICollectionViewLayoutAttributes]()
    override func prepare() {
        super.prepare()
        
        scrollDirection = .vertical
        sectionInset = dataSource.sectionEdgeInsetsForLayout?(self) ?? UIEdgeInsets.zero
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        // maxYs
        let numberOfCols = dataSource.numberOfColsForLayout?(self) ?? 2
        for i in 0..<numberOfCols {
            maxYs[i] = dataSource.sectionEdgeInsetsForLayout?(self).top ?? 0
        }
        
        // for rect
        let numberOfItems = collectionView!.numberOfItems(inSection: 0)
        attriArray.removeAll()
        for i in 0..<numberOfItems {
            attriArray.append(layoutAttributesForItem(at: IndexPath(item: i, section: 0))!)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        var maxYItem = 0
        for (col, value) in maxYs {
            if maxYs[maxYItem]! < value {
                maxYItem = col
            }
        }
        
        return CGSize(width: 0, height: maxYs[maxYItem]! + sectionInset.bottom)
    }
    
    // attributes
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let originalAttributes = super.layoutAttributesForItem(at: indexPath)
        let attributes = originalAttributes
        
        let colNumber = indexPath.item % (dataSource.numberOfColsForLayout?(self) ?? 2)
        let sizeOfItem = dataSource.itemSizeForLayout?(self, at: indexPath) ?? itemSize
        let top = dataSource.topMarginOfItemAt?(indexPath) ?? 0
        let left = dataSource.leftMarginOfItemAt?(indexPath) ?? 0
        
        var itemX = sectionInset.left + left
        if colNumber != 0 {
            for i in 1...colNumber {
                let lastIndexPath = IndexPath(item: indexPath.item - i, section: indexPath.section)
                let lastLeft = dataSource.leftMarginOfItemAt?(lastIndexPath)  ?? 0
                let lastWidth = dataSource.itemSizeForLayout?(self, at: lastIndexPath).width ?? 0
                itemX += lastLeft + lastWidth
            }
        }
        
        let itemY = maxYs[colNumber]! + top
        attributes?.frame = CGRect(x: itemX, y: itemY, width: sizeOfItem.width, height: sizeOfItem.height)
        attributes?.zIndex = indexPath.item // the next is higher, first is zero
        maxYs[colNumber] = attributes?.frame.maxY
        
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attriArray
    }
    
}

