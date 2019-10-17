//
//  LandingModel.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/18.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class LandingModel {
    // array of tier three groups
    var tierThree = [(MetricGroupObjModel, [MetricObjModel])]()
    var tierTwo = [(MetricGroupObjModel, [MetricObjModel])]()
    var tierOne = [(MetricGroupObjModel, [MetricObjModel])]()
    
    func reloadLandingData() {
        // clear all
        var tierOneSet = Set<String>()
        var tierTwoSet = Set<String>()
        var tierThreeSet = Set<String>()

        let risks = collection.getLoadedRisks()
        for risk in risks {
            if let typeKey = risk.riskTypeKey {
                // riskClass
                if let metricKey = risk.metricKey {
                    // sort
                    let riskTypeType = RiskTypeType.getTypeOfRiskType(typeKey)
                    if riskTypeType == .iCa {
                        tierOneSet.insert(metricKey)
                    }else if riskTypeType == .iPa {
                        tierTwoSet.insert(metricKey)
                    }else {
                        tierThreeSet.insert(metricKey)
                    }
                }
            }
        }

        // assign
        tierOne = sortMetrics(Array(tierOneSet))
        tierTwo = sortMetrics(Array(tierTwoSet))
        tierThree = sortMetrics(Array(tierThreeSet))
    }
    
    fileprivate func sortMetrics(_ metricKeys: [String]) -> [(MetricGroupObjModel, [MetricObjModel])] {
        var dic = [MetricGroupObjModel: [MetricObjModel]]()
        for metricKey in metricKeys {
            if let group = collection.getSlowAgingMetricGroupOfMetric(metricKey) {
                if let metric = collection.getMetric(metricKey) {
                    if dic[group] == nil {
                        dic[group] = [metric]
                    }else {
                        dic[group]!.append(metric)
                    }
                }
            }else {
                print("no group, wrong")
            }
        }
        
        var sort = [( MetricGroupObjModel, [MetricObjModel])]()
        for (key, value) in dic {
            let sortedMetrics = value.sorted(by: {$0.seqNumber ?? 0 < $1.seqNumber ?? 0})
            sort.append((key, sortedMetrics))
        }
        sort.sort(by: {$0.0.seqNumber ?? 0 < $1.0.seqNumber ?? 0})
        
        return sort
    }
    

}

// act to change
extension LandingModel {
    class func getAllTierRiskClasses() -> [Int: [MetricObjModel]] {
        let landing = LandingModel()
        landing.reloadLandingData()
        
        var all = [Int: [MetricObjModel]]()
        var riskClasses = [MetricObjModel]()
        // tier one
        for (_ , oneClasses) in landing.tierOne {
            riskClasses.append(contentsOf: oneClasses)
        }
        all[0] = riskClasses
        
        // tier two
        riskClasses.removeAll()
        for (_ , oneClasses) in landing.tierTwo {
            riskClasses.append(contentsOf: oneClasses)
        }
        all[1] = riskClasses
        
        // tier three
        riskClasses.removeAll()
        for (_ , oneClasses) in landing.tierThree {
            riskClasses.append(contentsOf: oneClasses)
        }
        all[2] = riskClasses
        
        return all
    }
    
}
