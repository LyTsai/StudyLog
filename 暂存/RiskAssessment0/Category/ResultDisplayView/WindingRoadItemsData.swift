//
//  WindingRoadItemsData.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/22.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
extension RoadItemDisplayModel {
    // without frame info
    class func getAllItemsForCategories(_ categories: [CategoryDisplayModel]) -> [RoadItemDisplayModel] {
        var items = [RoadItemDisplayModel]()
        
        // normal set, except from frames
        for (i, category) in categories.enumerated() {
            let item = RoadItemDisplayModel()
            
            item.index = i
            item.text = category.name
            item.imageUrl = category.imageUrl
            
            let colorPair = colorPairs[i % colorPairs.count]
            item.fillColor = colorPair.fill
            item.borderColor = colorPair.border
            
            items.append(item)
        }
        
        return items
    }
}
