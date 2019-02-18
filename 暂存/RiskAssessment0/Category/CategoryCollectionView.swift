//
//  CategoryCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/15.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CategoryCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var categories = [CategoryDisplayModel]()
    weak var hostView: CategorySelectionView!
    var playState = [String: [String]]() {
        didSet{
            getDisplayModel(playState)
            reloadData()
        }
    }
    
    // fatory
    class func createWithFrame(_ frame: CGRect, playState: [String: [String]]) -> CategoryCollectionView {
        let gap = 5 * frame.width / 335
        
        // layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = gap
        layout.minimumLineSpacing = gap
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = CGSize(width: (frame.width - 2.01 * gap) / 3, height: (frame.height - 1.01 * gap) * 0.5)
        
        // create
        let category = CategoryCollectionView(frame: frame, collectionViewLayout: layout)
        category.backgroundColor = UIColor.clear
        category.playState = playState
        
        // register
        category.register(CategoryDisplayCell.self, forCellWithReuseIdentifier: categoryDisplayCellID)
        
        // delegate
        category.dataSource = category
        category.delegate = category
        
        return category
    }
    
    fileprivate func getDisplayModel(_ playState: [String: [String]]) {
        categories.removeAll()
        
        let sortedCards = RiskMetricCardsCursor.sharedCursor.getSortedCards()
        var genetics: CategoryDisplayModel!
        for (key, value) in sortedCards {
            let categoryObj = AIDMetricCardsCollection.standardCollection.getMetricGroupByKey(key)
            let category = CategoryDisplayModel()
            category.key = key
            category.name = categoryObj?.name ?? "Others"
            category.imageUrl = categoryObj?.imageUrl
            category.cardsPlayed = playState[key] ?? []
            category.cards = value
            
            if category.name.contains("Genetics") && genetics == nil {
                genetics = category
            }else {
                categories.append(category)
            }
        }
        
        // sort
        if genetics != nil {
            categories.append(genetics)
        }
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryDisplayCellID, for: indexPath) as! CategoryDisplayCell
        let category = categories[indexPath.item]
        cell.text = category.name
        cell.imageUrl = category.imageUrl
        cell.answeredNumber = category.cardsPlayed.count
        cell.totalNumber = category.cards.count
        cell.borderColor = colorPairs[indexPath.item % colorPairs.count].border
        cell.fillColor = colorPairs[indexPath.item % colorPairs.count].fill
        
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        VDeckOfCardsFactory.metricDeckOfCards.attachCategoryCards(category.cards)
        
        // push
        if hostView != nil {
            hostView.hostVC.showCategory = false
        }
    }
}
