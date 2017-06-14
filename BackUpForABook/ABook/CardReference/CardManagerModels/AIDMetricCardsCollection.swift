//
//  AIDMetricCardsCollection.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/10/20.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import ABookData

// AIDMetricCardsCollection - collection of all models (risk, metrics etc)
// MARK: ------------ Singleton Class --------------
// holding application data (i.e vcard for risk) -> update data to CoreData (i.e “Measurement”)
// 5.5.2017 - migrate to REST api backend access
class AIDMetricCardsCollection {
    // MARK: ---------- singleton
    static let standardCollection = AIDMetricCardsCollection()
    
    // indicate if need to reload base objects (such as Risks)
    var bNeed2ReloadModels : Bool = true
    
    // MARK: ---------- readonly public dictionaries -----------
    // collection of all cards loaded by risk model: cards are presentation of metrics by related risk domain
    fileprivate var metric2Cards = [String: [String: CardInfoObjModel]]()  // {metric key, {risk.key, VCardModel}}

    // collection of all match options
    fileprivate var key2Match = [String: MatchObjModel]()
    // collection of all MetricObjModels: {key, MetricObjModel}
    fileprivate var key2Metric = [String: MetricObjModel]()
    // metric to all risk models it is part of: {metric key, array(RiskObjModel)}
    fileprivate var metric2Risks = [String: [RiskObjModel]]()
    
    // mapping of risk models: {risk key, array(RiskFactorObjModel)}
    // risk model and its risk factors
    fileprivate var risk2Factors = [String: [RiskFactorObjModel]]()

    // MARK: ----------- risks --------------
    // each risk object represents certain assessment.  risks are also groupped by class (or category such as vtD deficient etc).  risk.metricClass = category

    // riks models mapped by risk model key: {risk key, RiskObjModel} of ALL risks.  here is all risk models regardless their classes
    fileprivate var key2Risk = [String: RiskObjModel]()
    fileprivate var fallThroughMetricKeys = [String]()          // Array of “Fall through” metrics
    fileprivate var cursor: Int!                                // Cursor that points to next unprocessed metric
    
    // !!! map risk metric (or category) to list of avialible models: {riskMetricKey, [riskKey]}
    // organize risk by their class (risk metric).  For example, there are more than one risk for the same Skin Age etc
    // the riskKey is the same key used in key2Risk for accessing risks by their key
    // risk.metricClass = category
    fileprivate var riskMetricKey2Risks = [String: Set<String>]()
    
    // risk class (or catergory) collection - define various risk catergories.  each category may have multiple risks (models).  to find all models of a given risk class use riskMetricKey2Risks[riskClasses[i].key]
    fileprivate var riskClasses = [MetricObjModel]()
    
    // update riskMetricKey2Risks and riskClasses
    func updateRiskMap(_ riskIndexes: [RiskObjModel]) {
        
        riskMetricKey2Risks.removeAll()
        riskClasses.removeAll()
        key2Risk.removeAll()
        
        for riskIndex in riskIndexes {
            
            // fill riskMetricKey2Risks
            if !riskMetricKey2Risks.keys.contains(riskIndex.metricKey!){
                riskMetricKey2Risks[riskIndex.metricKey!] = Set<String>()
                // Hui To Do <- for now the index doesn't include metric object

                riskIndex.metric?.key = riskIndex.metricKey
                // set metric if the key is set
                if riskIndex.metric != nil {
                    riskClasses.append(riskIndex.metric!)
                }
            }
            
            // add risk.key to risk list of the same type (risk metric)
            riskMetricKey2Risks[riskIndex.metricKey!]?.insert(riskIndex.key!)
            
            // add to key2Risk
            key2Risk[riskIndex.key] = riskIndex
        }
    }
    
    // load metics (!!! to be removed)
    func updateMetricObjects(_ metrics: [MetricObjModel]) {
        key2Metric.removeAll()
        for metric in metrics {
            key2Metric[metric.key] = metric
        }
        
        // !!! Hui To Do to be removed once Risk Index returns metric object
        riskClasses.removeAll()
        for (key, _) in riskMetricKey2Risks {
            if let metric = key2Metric[key] {
                riskClasses.append(metric)
            }
        }
    }
    
    ///////////////////////////////////////////////////////////
    // load one risk model object.  
    ///////////////////////////////////////////////////////////
    // will update the following collection:
    // metric2Risks
    // riskMetricKey2Risks
    // riskClasses
    // metric2Cards
    // key2Metric
    func updateRiskModelObjects(_ riskList: RiskObjListModel) {
        
        let risk = riskList.risk
        var factorArray = [RiskFactorObjModel]()
        
        // fill riskMetricKey2Risks for keeping risk class
        if !riskMetricKey2Risks.keys.contains(risk.metricKey!){
            riskMetricKey2Risks[risk.metricKey!] = Set<String>()
            riskClasses.append(risk.metric!)
        }
        
        // add risk.key to risk list of the same type (risk metric)
        riskMetricKey2Risks[risk.metricKey!]?.insert(risk.key!)
        
        // fill key2Risk
        key2Risk[risk.key!] = risk
        
        for riskFactor in risk.riskFactors {
            
            if riskFactor.card == nil {
                continue
            }
            
            // add into risk factor array
            factorArray.append(riskFactor)
            
            // metricToRisks: [String: [RiskObjModel]], metric key
            let metricKey = (riskFactor.metric?.key)!
            let metricKeys = metric2Risks.keys
            
            // fill metricKeys
            if metricKeys.contains(metricKey) {
                metric2Risks[metricKey]!.append(risk)
            }else {
                metric2Risks[metricKey] = [risk]
            }
            
            // metric card attached to this risk factor
            if metric2Cards[metricKey] == nil {
                metric2Cards[metricKey] = [String: CardInfoObjModel]()
            }
            
            // add this metric
            // {metricKey, metric}
            key2Metric[metricKey] = riskFactor.metric
            
            // add card match options
            for option in (riskFactor.card?.cardOptions)! {
                key2Match[(option.match?.key)!] = option.match
            }
            
            // {metricKey, {riskKey, card}}
            metric2Cards[metricKey]![risk.key!] = riskFactor.card
        }
        // set risk2Factors array
        risk2Factors[risk.key!] = factorArray
    }
    
    ///////////////////////////////////////////////////////////
    // access risks / metrics
    ///////////////////////////////////////////////////////////
    
    // return all risk classes (catergories)
    func getRiskClasses() -> [MetricObjModel] {
        return riskClasses
    }
    
    // return array of metric keys related to the risks
    func getMetrics() -> [String] {
        return metric2Risks.keys.map { String($0)}
    }
    
    // return RiskObjModel for the given risk key
    func getRisk(_ riskKey: String?) -> RiskObjModel? {
        if riskKey == nil {
            return nil
        }
        return key2Risk[riskKey!]
    }
    
    // return RiskFactorModel array for the given risk key
    func getRiskFactors(_ riskKey: String) -> [RiskFactorObjModel]? {
        return risk2Factors[riskKey]
    }
    
    // return array of risk classes (or types such as brain age, CVD risk, low vtD risk etc)
    func getRiskClasseKeys()->[String] {
        return Array(riskMetricKey2Risks.keys)
    }
    
    // return array of risk key for the given risk class (such as CVD risk)
    func getRiskModelKeys(_ riskClasscKey:String)->[String]? {
        return Array(riskMetricKey2Risks[riskClasscKey]!)
    }
    
    // return array of risk model for given risk class (catergory)
    func getModelsOfRiskClass(_ riskClassKey:String)->[RiskObjModel] {
        var riskModels = [RiskObjModel]()
        
        if let riskKeys = getRiskModelKeys(riskClassKey) {
            for riskKey in riskKeys {
                if let risk = getRisk(riskKey) {
                    riskModels.append(risk)
                }
            }
        }
        
        return riskModels
    }
    
    // get all metrics in the collection
    func getMetricObjs() -> [MetricObjModel]? {
        return Array(key2Metric.values)
    }
    
    // get MetricObjModel by given metric key
    func getMetric(_ metricKey: String) -> MetricObjModel? {
        return key2Metric[metricKey]
    }
    
    // return all related risk models for the given metric (key)
    func getMetricRelatedRiskModels(_ metricKey:String)->[RiskObjModel]? {
        return metric2Risks[metricKey]
    }
    
    ///////////////////////////////////////////////////////////
    // access VCard
    ///////////////////////////////////////////////////////////

    func getMetricCardOfRisk(_ risk: String)->[CardInfoObjModel] {
        var riskDeckOfCards = [CardInfoObjModel]()
        
        let risk = getRisk(risk)
        
        if risk != nil {
            let facotrs = risk!.riskFactors
            
            for factor in facotrs {
                if factor.card != nil {
                    riskDeckOfCards.append(factor.card!)
                }
            }
        }
        
//        for (_, metricCards) in metric2Cards {
//            // for each metric look for its card defined by the risk
//            if let card = metricCards[risk] {
//                riskDeckOfCards.append(card)
//            }
//        }
        
        return riskDeckOfCards
    }
    
    // return all cards for given metric key
    func getMetricDeckOfCards(_ metricKey: String)->[String: CardInfoObjModel]? {
        return metric2Cards[metricKey]
    }
    
    // return match object for the given match key
    func getMatch(_ matchKey: String)->MatchObjModel? {
        return key2Match[matchKey]
    }
}
