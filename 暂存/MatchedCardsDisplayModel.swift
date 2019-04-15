//
//  MatchedCardsData.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/17.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// display matched cards
// as a help center
class MatchedCardsDisplayModel {
    // card itself
    /** metric.name */
    var headerTitle: String!
    /** match.name */
    var title: String!
    /** match.statement */
    var prompt: String!
    var image: UIImage!
    var imageUrl: URL!
    /** category.name */
    var side: String!
    var buttonOnShow = false
    
    // for more infomation
    var matchKey: String!
    var metricKey: String!
//    var cardInfoKey: String!
    var cardInfo: CardInfoObjModel!
    var categoryKey: String!
    var classificationKey: String!
    var classification: ClassificationObjModel!
    
    // may in which risk
    var risks = [RiskObjModel]()
    var results = [Double]() // the same now
    
    // MARK: ------------------------  methods ---------------------------
//    func changeAnswerToIndex(_ answerIndex: Int) {
//        var value: Int!
//        var option: CardOptionObjModel!
//
//        let cardStyleKey = cardInfo.cardStyleKey
//
//        // judgement
//        if cardStyleKey == JudgementCardTemplateView.styleKey() {
//            value = (answerIndex == 0) ? 1 : -1
//            option = cardInfo.cardOptions.first
//        }
//        
//        // multiple
//        CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser.Key(), cardKey: cardInfo.key, riskKey: RiskMetricCardsCursor.sharedCursor.focusingRiskKey, selection: option, value: value as NSNumber?)
//
//        // data
//        matchKey = option.matchKey
//        imageUrl = option.match?.imageUrl
//        title = option.match?.name
//        prompt = option.match?.statement
//
//        classification = option.match?.classification
//        classificationKey = option.match?.classificationKey
//
//        results = [Double(value)]
//    }
}

// MARK: --------------------- help center -----------------
extension MatchedCardsDisplayModel {
    class func setupMatchedImageForCard(_ card: CardInfoObjModel, on cardImageView: UIImageView) {
        // check answer
        if var result = CardSelectionResults.cachedCardProcessingResults.getCurrentSelectionForCard(card.key) {
            if card.cardStyle?.key == JudgementCardTemplateView.styleKey() {
                // show first option
                result = 0
            }
            
            let match = card.cardOptions[result].match!
            // card image
            cardImageView.sd_setShowActivityIndicatorView(true)
            cardImageView.sd_setIndicatorStyle(.gray)
            cardImageView.sd_setImage(with: match.imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, progress: nil) { (image, error, type, url) in
                if image == nil {
                    // no image, but answered
                    cardImageView.image = ProjectImages.sharedImage.placeHolder
                }
            }
        }else {
            // no choice, not answered
            cardImageView.image = UIImage(named: "summary_noChoice")
        }
    }
    
    class func getMatchedTextOfCard(_ card: CardInfoObjModel) -> String {
        if let result = CardSelectionResults.cachedCardProcessingResults.getCurrentSelectionForCard(card.key) {
            if card.cardStyle?.key == JudgementCardTemplateView.styleKey() {
                let statement = card.cardOptions[0].match!.name ?? ""
                return result == 1 ? "Yes: \(String(describing: statement))" : "No: \(String(describing: statement))"
            }
            
            let match = card.cardOptions[result].match!
            // card image
            return match.name ?? match.statement
        }else {
            // no choice, not answered
            return card.title ?? "Not answered"
        }
    }
    
    // with the seq as category->cards
    class func getSortedAnsweredCardsForRisk(_ riskKey: String) -> [CardInfoObjModel] {
       let collection = AIDMetricCardsCollection.standardCollection
        let sorted = collection.getSortedCardsForRiskKey(riskKey)
        var matched = [CardInfoObjModel]()
        for card in sorted {
            if card.currentSelection() != nil {
                matched.append(card)
            }
        }
        
        return matched
    }
}


// MARK: ---------------------- get data -------------------
// for current
extension MatchedCardsDisplayModel {
    class func getCurrentUserMatchedCard() -> [MatchedCardsDisplayModel] {
        return getMatchedCardOfUser(UserCenter.sharedCenter.currentGameTargetUser.Key())
    }
    
    // [categoryKey: [cards]]
    class func getCurrentCategoryOfCardsPlayed() -> [String : [MatchedCardsDisplayModel]] {
        return getCategoryOfCardsPlayedForUser(UserCenter.sharedCenter.currentGameTargetUser.Key())
    }
    
    // [riskObj: [cards]]
    class func getCurrentRiskOfCardsPlayed() -> [RiskObjModel : [MatchedCardsDisplayModel]] {
        return getRiskOfCardsPlayedForUser(UserCenter.sharedCenter.currentGameTargetUser.Key())
    }
    
    // get all risks played
    class func getCurrentMatchedCardForRisk(_ riskKey: String) -> [MatchedCardsDisplayModel] {
        return getMatchedCardForRisk(riskKey, ofUser: UserCenter.sharedCenter.currentGameTargetUser.Key())
    }
    
    class func getCurrentMatchedCards() -> [MatchedCardsDisplayModel] {
        if let riskKey = RiskMetricCardsCursor.sharedCursor.focusingRiskKey {
            return getCurrentMatchedCardForRisk(riskKey)
        }
        
        return []
    }
}

// MARK: --------- get all played
extension MatchedCardsDisplayModel {
    // all the cards played during this launch for user
    class func getMatchedCardOfUser(_ userKey: String) -> [MatchedCardsDisplayModel] {
        var matchedCards = [MatchedCardsDisplayModel]()
        
        if let allMeasurements = CardSelectionResults.cachedCardProcessingResults.getAllUserRiskMeasurementsByCard()[userKey] {
            
            let collection = AIDMetricCardsCollection.standardCollection
            // get the match and risks, values
            var sortedValues = [MeasurementValueObjModel: [(RiskObjModel, Double)]]()
            var metricValues = [String: MeasurementValueObjModel]()
            for (riskKey, measurement) in allMeasurements {
                let risk = collection.getRisk(riskKey)!
                for value in measurement.values {
                    if metricValues.keys.contains(value.metricKey) {
                        // just for metric and match
                        let replacedValue = metricValues[value.metricKey]!
                        sortedValues[replacedValue]!.append((risk, value.value))
                    }else {
                        metricValues[value.metricKey] = value
                        sortedValues[value] = [(risk, value.value)]
                    }
                }
            }
            
            // create data
            for (measurementValue, values) in sortedValues {
                let matchedCard = MatchedCardsDisplayModel()
                
                // assign match
                let match = measurementValue.match
                matchedCard.title = match?.name
                matchedCard.prompt = match?.statement
                matchedCard.image = match?.imageObj
                matchedCard.imageUrl = match?.imageUrl
                
                // match
                matchedCard.matchKey = measurementValue.matchKey
                
                // metric
                matchedCard.headerTitle = measurementValue.metric?.name
                matchedCard.metricKey = measurementValue.metricKey

                // classification
                matchedCard.classificationKey = match?.classificationKey
                matchedCard.classification = match?.classification
                
                // results
                for value in Array(values) {
                    matchedCard.risks.append(value.0)
                    matchedCard.results.append(value.1)
                }
                
                // category
                let cards = collection.getMetricCardOfRisk(matchedCard.risks.first!.key)
                for card in cards {
                    if card.metricKey == matchedCard.metricKey {
                        matchedCard.cardInfo = card
                        break
                    }
                }
                
                matchedCard.categoryKey = matchedCard.cardInfo.metricGroupKey ?? UnGroupedCategoryKey
                matchedCard.side = collection.getCategoryNameOfCard(matchedCard.cardInfo)
                matchedCard.buttonOnShow = (matchedCard.cardInfo.cardStyleKey == JudgementCardTemplateView.styleKey())
                
                // append
                matchedCards.append(matchedCard)
            }
        }
        
        return matchedCards
    }
    
    // [categoryKey: [cards]]
    class func getCategoryOfCardsPlayedForUser(_ userKey: String) -> [String : [MatchedCardsDisplayModel]] {
        let allCards = getMatchedCardOfUser(userKey)
        var sorted = [String : [MatchedCardsDisplayModel]]()
        
        for card in allCards {
            if sorted[card.categoryKey] == nil {
                sorted[card.categoryKey] = [card]
            }else {
                sorted[card.categoryKey]!.append(card)
            }
        }
        
        return sorted
    }
    
    // [riskObj: [cards]]
    class func getRiskOfCardsPlayedForUser(_ userKey: String) -> [RiskObjModel : [MatchedCardsDisplayModel]] {
        let risks = getRisksPlayedByUser(userKey)
        var sorted = [RiskObjModel : [MatchedCardsDisplayModel]]()
        for risk in risks {
            sorted[risk] = getCurrentMatchedCardForRisk(risk.key)
        }
        
        return sorted
    }
    
    // get all risks played
    class func getRisksPlayedByUser(_ userKey: String) -> [RiskObjModel] {
        return CardSelectionResults.cachedCardProcessingResults.getAllGamesPlayed(userKey)
    }
    
    class func getMatchedCardForRisk(_ riskKey: String, ofUser userKey: String) -> [MatchedCardsDisplayModel] {
        let allCards = getMatchedCardOfUser(userKey)
        var cards = [MatchedCardsDisplayModel]()
        if let risk = AIDMetricCardsCollection.standardCollection.getRisk(riskKey) {
            for card in allCards {
                if card.risks.contains(risk) {
                    cards.append(card)
                }
            }
        }
        return cards
    }
}

// MARK: ------------------- arrange cards ---------------
extension MatchedCardsDisplayModel {
    // sort: high to low
    class func arrangeWithColors(_ cards: [MatchedCardsDisplayModel]) -> [(color: UIColor, cards: [MatchedCardsDisplayModel])] {
        // colors
        var sorted = [(UIColor, [MatchedCardsDisplayModel])] ()
        
        // grouped
        var unClassified = [MatchedCardsDisplayModel]()
        var sortDic = [UIColor: [MatchedCardsDisplayModel]]()
        for card in cards {
            if let classification = card.classification {
                if let color = classification.realColor {
                    if sortDic[color] == nil {
                        sortDic[color] = [card]
                    }else {
                        sortDic[color]!.append(card)
                    }
                }else {
                    unClassified.append(card)
                }
            }else {
                unClassified.append(card)
            }
        }
        
        // sort
        var redDic = [CGFloat: UIColor]()
        for color in Array(sortDic.keys) {
            if color.cgColor.numberOfComponents >= 3 {
                let red = color.cgColor.components![0]
                redDic[red] = color
            }
        }
        
        for red in Array(redDic.keys).sorted(by: >) {
            let color = redDic[red]!
            sorted.append((color, sortDic[color]!))
        }
        
        if unClassified.count != 0 {
            print("no classification or no color")
            sorted.append((tabTintGreen, unClassified))
        }
        
        return sorted
    }
}
