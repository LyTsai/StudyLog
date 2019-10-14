//
//  ApplicationDataCenter.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/17.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class ApplicationDataCenter: DataAccessProtocal {
    static let sharedCenter = ApplicationDataCenter()
    
    // all riskClasses, readOnly
    var riskClassKey: String! {
        return applictionDic[annieLyticxRiskClassKey]
    }

    // riskfactors - category
    var riskFactorCategoryKey: String! {
        return applictionDic[annielyticxRiskFactorCategoryKey]
    }
    // metricGroup of riskClasses
    var riskCategoryKey: String! {
        return applictionDic[annieLyticxRiskCategoryKey]
    }
    
    // riskType
    var riskTypeKey: String! {
        return applictionDic[annieLyticxRiskTypeKey]
    }
    
    //- used for getting all “standalone” subject metric groups for “Individualized Assessment” (IaaaS)
    var iaaasStandaloneKey: String! {
        return applictionDic[annieLyticxIaaaSStandAloneCategory]
    }
    
    // - used for getting all “third party” subject metric groups for “Individualized Assessment” (IaaaS)
    var iaaaSThirdPartKey: String! {
        return applictionDic[annieLyticxIaaaSThirdPartyCategory]
    }
    
    // - used for getting all subject metric groups for “Visualizers”
    var visualizerStandAloneKey: String! {
        return applictionDic[annieLyticxVisualizerStandAloneCategory]
    }
    
    // - used for getting all subject metric groups for “Visualizers”
    var visualizerThirdPartyCategoryKey: String! {
        return applictionDic[annieLyticxVisualizerStandAloneCategory]
    }

    
    // get data
    var loadedFromNet = false
    fileprivate var applictionDic = [String: String]()
    func updateDictionary(_ dic: [String: String]) {
        applictionDic = dic
    }
}
