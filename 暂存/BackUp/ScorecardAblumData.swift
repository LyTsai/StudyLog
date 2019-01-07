//
//  ScorecardAblumData.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/11.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

//class ScorecardAlbumData {
//    class func getRiskClasses(_ tierPosition: Int, sortRule: AlbumSortRule) -> [String] {
//        // model array
//        var riskClasses = [String]()
//
//        for (group, value) in collection.getAllGroupedRiskClasses() {
//            if group.tierPosition == tierPosition {
//                for metric in value {
//                    if collection.getAllRisksOfRiskClass(metric.key).count != 0 {
//                        riskClasses.append(metric.key)
//                    }
//                }
//            }
//        }
//
//        sortRiskClasses(&riskClasses, sortRule: sortRule)
//
//        return riskClasses
//    }
//
//    class func sortRiskClasses(_ riskClasses: inout [String], sortRule: AlbumSortRule) {
////        switch sortRule {
////        case .name:
////            riskClasses.sort(by: { collection.getMetric($0)!.name.first! < collection.getMetric($1)!.name.first! })
////        case .played:
////             riskClasses.sort(by: { MatchedCardsDisplayModel.getRisksPlayedForRiskClass($0).count > MatchedCardsDisplayModel.getRisksPlayedForRiskClass($1).count })
////        default:
////            break
////        }
//    }
//
//    class func getSortedRisksInfoOfRiskClass(_ riskClassKey: String, sortRule: AlbumSortRule, playState: AlbumPlayState) -> [(type: String, risks: [String])] {
//        var sortedInfo = [(type: String, risks: [String])]()
//        // sort
//        let played = MatchedCardsDisplayModel.getRisksPlayedForRiskClass(riskClassKey)
//        var risks = collection.getAllRisksOfRiskClass(riskClassKey)
//        if playState == .played {
//            risks = played
//        }else if playState == .unplayed {
//            var unplayed = [String]()
//            for risk in risks {
//                if !played.contains(risk) {
//                    unplayed.append(risk)
//                }
//            }
//            risks = unplayed
//        }
//
//        var sortDic = [String: [String]]()
//        for riskKey in risks {
//            if let risk = collection.getRisk(riskKey) {
//                if let riskTypeKey = risk.riskTypeKey {
//                    if sortDic[riskTypeKey] == nil {
//                        sortDic[riskTypeKey] = [riskKey]
//                    }else {
//                        sortDic[riskTypeKey]!.append(riskKey)
//                    }
//                }
//            }
//        }
//
//        // sort
//        for (key, value) in sortDic {
//            sortedInfo.append((key, value))
//        }
//
//        // sort by rule
//        return sortedInfo
//    }
//}
