//
//  VisualMapData.swift
//  AnnielyticX
//
//  Created by iMac on 2018/3/29.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VisualMapData {
    // getNodes
    class func createISaNodes(_ keys: [String]) -> [VisualMapNode] {
        var iSaCategoryNodes = [VisualMapNode]()
        
        for key in keys {
            if let category = collection.getMetricGroupByKey(key) {
                let node = VisualMapNode()
                node.key = category.key
                node.imageUrl = category.imageUrl
                node.text = category.name
                node.borderShape = .round
                node.mainColor = UIColorFromRGB(255, green: 200, blue: 0)
                
                iSaCategoryNodes.append(node)
            }
        }
        
        return iSaCategoryNodes
    }
    
    class func createMetricNodes(_ keys: [String]) -> [VisualMapNode] {
        var metricNodes = [VisualMapNode]()
        
        for key in keys {
            if let metric = collection.getMetric(key) {
                let node = VisualMapNode()
                node.key = metric.key
                node.imageUrl = metric.imageUrl
                node.text = metric.name
                node.textAtTop = false
                node.borderShape = .round
                node.mainColor = UIColorFromRGB(255, green: 85, blue: 0)
                metricNodes.append(node)
            }
        }
        return metricNodes
    }
    
    class func createIRANodes(_ keys: [String]) -> [VisualMapNode] {
        var iRaCategoryNodes = [VisualMapNode]()
        
        for key in keys {
            if let category = collection.getMetricGroupByKey(key) {
                let node = VisualMapNode()
                node.key = category.key
                node.imageUrl = category.imageUrl
                node.text = category.name
                node.showText = true
                node.borderShape = .oct
                node.mainColor = UIColorFromRGB(2, green: 136, blue: 209)
                
                iRaCategoryNodes.append(node)
            }
        }
        
        return iRaCategoryNodes
    }
    
    // getAllNodes
    class func createAllISaNodes() -> [VisualMapNode] {
        var keys = [String]()
        for category in collection.getCategoriesOfRiskType(iSaKey) {
            keys.append(category)
        }
        
        return createISaNodes(keys)
    }
    
    class func createAllMetricNodes() -> [VisualMapNode] {
        var keys = [String]()
        for (_ ,metrics) in LandingModel.getAllTierRiskClasses() {
            for metric in metrics {
                keys.append(metric.key)
            }
        }
        
        return createMetricNodes(keys)
    }
    
    class func createAllIRANodes() -> [VisualMapNode] {
        var keys = [String]()
        for category in collection.getCategoriesOfRiskType(iRaKey) {
            keys.append(category)
        }
        
        return createIRANodes(keys)
    }

}
