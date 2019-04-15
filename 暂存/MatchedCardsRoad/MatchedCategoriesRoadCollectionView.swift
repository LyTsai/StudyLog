//
//  MatchedCategoriesRoadCollectionView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/9/14.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class MatchedCategoriesRoadCollectionView: WindingCategoryCollectionView {
    var matchedCards = [String: [MatchedCardsDisplayModel]]()
    var items = [RoadItemDisplayModel]()
    
    fileprivate var standW: CGFloat {
        return bounds.width / 375
    }
    fileprivate var standH: CGFloat {
        return bounds.height / (667 - 49 - 64)
    }
    
    override class func createWithFrame(_ frame: CGRect, categories: [CategoryDisplayModel]) -> MatchedCategoriesRoadCollectionView {
        let layout = BlockFlowLayout()
        let categoryView = MatchedCategoriesRoadCollectionView(frame: frame, collectionViewLayout: layout)
        categoryView.backgroundColor = UIColor.clear
        categoryView.categories = categories
        
        // backImages
        categoryView.setupBackgroundImages()
        categoryView.roadEndImageView.removeFromSuperview()
        
        // data
        categoryView.items = categoryView.getAllItems()
        categoryView.register(WindingRoadCollectionViewCell.self, forCellWithReuseIdentifier: windingRoadCellID)
        
        // delegate
        layout.dataSource = categoryView
        categoryView.dataSource = categoryView
        categoryView.delegate = categoryView
        
        return categoryView
    }

    fileprivate let anchorPositions: [PositionOfAnchor] = [.left, .left, .right, .right, .bottom, .left]
    func getAllItems() -> [RoadItemDisplayModel] {
        // sort
        var items = [RoadItemDisplayModel]()
        
        // set frames
        // (87, 134, 119, 115)
        for i in 0..<categories.count {
            let item = RoadItemDisplayModel()
            
            let colorPair = colorPairs[i % colorPairs.count]
            item.fillColor = colorPair.fill
            item.borderColor = colorPair.border
            
            item.anchorPosition = anchorPositions[i % 6]
            
            var backOrigin = CGPoint(x: 39 * standW, y: 0)
            switch item.anchorPosition {
            case .right, .bottom: backOrigin = CGPoint.zero
            default: // TODO: ------------ top, left, should with cell's bounds
                break
            }
            
            // fixed back size
            let backSize = CGSize(width: 84 * standW, height: 115 * standH)
            item.backFrame = CGRect(origin: backOrigin, size: backSize)
            item.indexWidth = roadWidth * 0.9
            
            items.append(item)
        }
        
        return items
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: windingRoadCellID, for: indexPath) as! WindingRoadCollectionViewCell
        cell.setupMatchedWithItem(items[indexPath.item], category: categories[indexPath.item])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chosenCategory = categories[indexPath.item]
        let cards = matchedCards[chosenCategory.key]!
        
        let display = MatchedCardsDisplayViewController()
        display.cards = cards
        display.mainColor = items[indexPath.item].fillColor
        display.roadTitle = chosenCategory.name ?? UnGroupedCategoryKey
            
        hostVC.navigationController?.pushViewController(display, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        anchorInfo.removeLast()
    }
}
