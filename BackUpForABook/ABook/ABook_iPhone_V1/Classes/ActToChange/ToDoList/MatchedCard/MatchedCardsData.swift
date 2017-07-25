//
//  MatchedCardsData.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/17.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
// model for view
class MatchedCardModel {
    var title: String!
    var prompt: String!
    var image: UIImage!
    var side: String!
    
    var matchedResult: String! // if yes/no, string has value, if not, nil
    var risks = [RiskObjModel]()

    // MARK: --------- get all played data -------------
    class func getMatchedData() -> [MatchedCardModel] {
        let cards = getAllMathedCards()
        
        var allData = [MatchedCardModel]()
        for (match, result) in cards {
            let matchedCard = MatchedCardModel()
            matchedCard.title = match.info ?? "result"
            matchedCard.prompt = match.statement
            matchedCard.side = match.name ?? "match"
            matchedCard.image = match.imageObj
            
            // result
            for (i, obj) in result.enumerated() {
                if i == 0 {
                    let deckOfCards = AIDMetricCardsCollection.standardCollection.getMetricCardOfRisk(obj.0.key)
                    if deckOfCards.first?.cardStyleKey == JudgementCardTemplateView.styleKey() {
                        matchedCard.matchedResult = (obj.1 == 1 ? "Yes" : "No")
                    }
                }
                
                matchedCard.risks.append(obj.0)
            }
            
            allData.append(matchedCard)
        }
        
        return allData
    }
    
        
    // or use key??
    class func getAllMathedCards() -> [MatchObjModel: [(RiskObjModel, Double)]] {
        var result = [MatchObjModel: [(RiskObjModel, Double)]]()
        
        let allRisks = getAllRisksPlayed()
        for risk in allRisks {
            let measurement = getMeasurementsForCurrentUserOfRisk(risk.key)
            if measurement == nil {
                continue
            }
            
            let values = measurement!.values
            for value in values {
                let match =  AIDMetricCardsCollection.standardCollection.getMatch(value.matchKey)
                if match == nil {
                    continue
                }else {
                    if result[match!] != nil {
                        result[match!]?.append((risk, value.value))
                    }else {
                        result[match!] = [(risk, value.value)]
                    }
                }
            }
        }

        return result
    }
    
    class func allMatches() -> [MatchObjModel] {
        var matches = [MatchObjModel]()
        let allRisks = getAllRisksPlayed()
        for risk in allRisks {
            let measurement = getMeasurementsForCurrentUserOfRisk(risk.key)
            if measurement == nil {
                continue
            }
            
            let values = measurement!.values
            for value in values {
                let match =  AIDMetricCardsCollection.standardCollection.getMatch(value.matchKey)
                if match == nil {
                    continue
                }else {
                    matches.append(match!)
                }
            }
        }
        
        return matches
    }
    
    class func getAllRisksPlayed() -> [RiskObjModel] {
        let userKey = UserCenter.sharedCenter.currentGameTargetUser.Key()
        let allMeasurements = CardSelectionResults.cachedCardProcessingResults.getAllUserRiskMeasurementsByCard()
        let current = allMeasurements[userKey]
        
        var risks = [RiskObjModel]()
        if current != nil {
            for (key, value) in current! {
                let risk = AIDMetricCardsCollection.standardCollection.getRisk(key)
                if risk != nil && value.values.count != 0 {
                    risks.append(risk!)
                }
            }
        }
        
        return risks
    }
    
    class func getMeasurementsOfUser(_ userKey: String, forRisk riskKey: String) -> MeasurementObjModel? {
        let allMeasurements = CardSelectionResults.cachedCardProcessingResults.getAllUserRiskMeasurementsByCard()
        return allMeasurements[userKey]?[riskKey]
    }
    
    class func getMeasurementsForCurrentUserOfRisk(_ riskKey: String) -> MeasurementObjModel? {
        let userKey = UserCenter.sharedCenter.currentGameTargetUser.Key()
        return getMeasurementsOfUser(userKey, forRisk: riskKey)
    }
}

