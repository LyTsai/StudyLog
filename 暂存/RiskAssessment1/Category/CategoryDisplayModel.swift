//
//  CategoryDisplayModel.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/15.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MARK: ----------- category display model ----------------------
class CategoryDisplayModel {
    var key: String!
    var name: String!
    var image: UIImage!
    var imageUrl: URL!
    var seqNumber: Int!

    var cardsPlayed = [String]()
    var cards = [CardInfoObjModel]()

    // all categories, ignore the play state
    class func loadCurrentCategories() -> [CategoryDisplayModel] {
        var categories = [CategoryDisplayModel]()
        
        let sortedCards = RiskMetricCardsCursor.sharedCursor.getSortedCards()
        for (key, value) in sortedCards {
            let category = getModelWithKey(key)
            if category == nil {
                continue
            }
            
            category!.cards = value
            category!.updateCurrentPlayStateData()
            
            categories.append(category!)
        }
        
        // sort
        categories.sort { (cate1, cate2) -> Bool in
            if cate1.seqNumber != nil && cate2.seqNumber != nil {
                return cate1.seqNumber <= cate2.seqNumber
            }else {
                return true
            }
        }
        
        return categories
    }
    
    class func getModelWithKey(_ key: String) -> CategoryDisplayModel? {
        if let categoryObj = AIDMetricCardsCollection.standardCollection.getMetricGroupByKey(key) {
            let category = CategoryDisplayModel()
            category.key = key
            category.name = categoryObj.name ?? "Others"
            category.imageUrl = categoryObj.imageUrl
            category.seqNumber = categoryObj.seqNumber
            
            return category
        }
        
        return nil
    }
    
    // update
    func updateCurrentPlayStateData() {
        let cachedResult = CardSelectionResults.cachedCardProcessingResults
        let riskKey = RiskMetricCardsCursor.sharedCursor.focusingRiskKey
        
        // [riskKey: [categoryKey: keysOfCardsPlayed]]
        cachedResult.updateCurrentPlayState()
        self.cardsPlayed = cachedResult.riskPlayState[riskKey!]?[self.key] ?? []
    }
}
