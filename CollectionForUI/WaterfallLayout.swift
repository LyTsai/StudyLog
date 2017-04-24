//
//  WaterfallLayout.swift
//  Demo_testUI
//
//  Created by iMac on 17/4/24.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// flow方便一些
// 瀑布流（理论：寻找最短的一列然后添加cell），目前：按照顺序从左往右，自上而下添加
// 方法的执行顺序：1. prepare， 2. 每个indexPath手动调用（那个attributes写在prepare里面，不然，会出现一堆空白的在前面）3. contentSize， 4. rect的attri， 5. contentSize，6. 每个rect。刷新（下拉）的时候，先是invalidate，然后上面的再来一遍
class WaterfallLayout: UICollectionViewFlowLayout {
    // 该方法每次刷新都会调用，而init方法中只会在创建布局对象的时候只执行一次
    var maxYs = [Int: CGFloat]() // colNumber: colHeight(maxY)
    var attriArray = [UICollectionViewLayoutAttributes]()
    override func prepare() {
        super.prepare()
        
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        for i in 0..<3 {
            maxYs[i] = sectionInset.top
//            maxYs[0] = 20
//            maxYs[1] = 5
//            maxYs[2] = 20
        }
        
        // MUST HERE
        let itemCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        for i in 0..<itemCount {
            let attributes = layoutAttributesForItem(at: IndexPath(item: i, section: 0))
            attriArray.append(attributes!)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    //  设置collectionView的contentSize，它才会滚动
    override var collectionViewContentSize: CGSize {
        var maxYItem = 0
        for (key, value) in maxYs {
            if maxYs[maxYItem]! < value {
                maxYItem = key
            }
        }
        return CGSize(width: 0, height: maxYs[maxYItem]! + sectionInset.bottom)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let collectionWidth = collectionView!.frame.size.width
        let itemWidth = (collectionWidth - sectionInset.left - sectionInset.right) / 3
        
        // 这个是瀑布流的
//        var minYItem = 0
//        for (key, value) in maxYs {
//            if maxYs[minYItem]! > value {
//                minYItem = key
//            }
//        }

        let colNumber = indexPath.item % 3
        let itemX = sectionInset.left + itemWidth * CGFloat(colNumber)
        let itemY = maxYs[colNumber]!
        
        
//        let itemX = sectionInset.left + itemWidth * CGFloat(minYItem)
//        let itemY = maxYs[minYItem]!
        
        var itemHeight: CGFloat = 0
        
        switch indexPath.item {
        case 0 , 2: itemHeight = itemWidth * 0.2
        case 1: itemHeight = itemWidth * 0.1
        default: itemHeight = itemWidth * 1.1
        }

        
        let attributes = super.layoutAttributesForItem(at: indexPath)
        attributes?.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
//        maxYs[minYItem] = attributes?.frame.maxY
        maxYs[colNumber] = attributes?.frame.maxY
        
        return attributes
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attriArray
    }
    
}
