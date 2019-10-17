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

    var cardsPlayed = [CardInfoObjModel]()
    var cards = [CardInfoObjModel]()

    // all categories, ignore the play state
    class func loadCurrentCategories() -> [CategoryDisplayModel] {
        var categories = [CategoryDisplayModel]()
        let riskKey = cardsCursor.focusingRiskKey!
        let sortedCards = collection.getCategoryToCardsOfRiskKeyEx(riskKey)
        for (key, value) in sortedCards {
            let category = getModelWithKey(key)
            if category == nil {
                continue
            }
            
            category!.cards = value
            let _ = category!.updateCurrentPlayStateData()
            
            categories.append(category!)
        }
        
        // sort        
        categories.sort(by: {$0.seqNumber ?? 0 < $1.seqNumber ?? 0})
        
        return categories
    }
    
    class func getModelWithKey(_ key: String) -> CategoryDisplayModel? {
        var category: CategoryDisplayModel!
        if key == UnGroupedCategoryKey {
            category = CategoryDisplayModel()
            category.key = UnGroupedCategoryKey
            category.name = UnGroupedCategoryKey
            return category
        }else if key == ComplementaryCategoryKey {
            category = CategoryDisplayModel()
            category.key = ComplementaryCategoryKey
            category.name = ComplementaryCategoryKey
            category.seqNumber = ComplementaryCategorySeqNumber
            return category
        }else if key == BonusCategoryKey {
            category = CategoryDisplayModel()
            category.key = BonusCategoryKey
            category.name = BonusCategoryKey
            category.seqNumber = BonusCategorySeqNumber
            return category
        }else if let categoryObj = collection.getMetricGroupByKey(key) {
            category = CategoryDisplayModel()
            category.key = key
            category.name = categoryObj.name ?? UnGroupedCategoryKey
            category.imageUrl = categoryObj.imageUrl
            category.seqNumber = categoryObj.seqNumber
        }
        
        // may nil
        return category
    }
    
    // update category's played cards
    // if changed, return true
    func updateCurrentPlayStateData() -> Bool {
        let oldPlayed = cardsPlayed
        var played = [CardInfoObjModel]()
        for card in cards {
            if card.currentPlayed() {
                played.append(card)
            }
        }
        self.cardsPlayed = played
        
        // compare
        if oldPlayed.count != cardsPlayed.count {
            // changed
            return true
        }else {
            for old in oldPlayed {
                if !cardsPlayed.contains(old) {
                    // changed
                    return true
                }
                
                // selection is changed...
                
            }
        }
        
        return false
    }
}
