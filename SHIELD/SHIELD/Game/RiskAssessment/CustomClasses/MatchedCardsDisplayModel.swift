//
//  MatchedCardsData.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/17.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// all the information for one single card, is put into "extension CardInfoObjModel"
// MARK: ---------------- Used for cards ---------------------------
class MatchedCardsDisplayModel {
    // MARK: for deck of cards
    // [iden: [card]]
    // iden is the key of classification or the "ME/NOT ME" or "chosenIndex" for void classification
    class func getColorOfIden(_ iden: String!) -> UIColor {
        if iden == nil {
            return UIColorGray(180)
        }
        
        if let classification = collection.getClassificationByKey(iden) {
            return classification.realColor!
        }else {
            if iden == "Medium" {
            return UIColorFromRGB(253, green: 213, blue: 5)
            }else if iden == UnClassifiedIden {
                return UIColorFromRGB(201, green: 97, blue: 55)
            }else {
                return UIColorFromRGB(128, green: 128, blue: 128)
            }
        }
    }
    
    class func getNameOfIden(_ iden: String!) -> String {
        if iden == nil {
            return "Data Loss"
        }
        if let classification = collection.getClassificationByKey(iden) {
            return classification.name
        }else {
            return iden
        }
    }
    
    class func getDisplayNameOfIden(_ iden: String) -> String {
        if let classification = collection.getClassificationByKey(iden) {
            return classification.displayName
        }else {
            return iden
        }
    }
    
    class func getRecomendataionOfIden(_ iden: String) -> String {
        if let classification = collection.getClassificationByKey(iden) {
            return classification.recommendation ?? "NULL"
        }else {
            return iden
        }
    }
    
    class func getValueOfIden(_ iden: String) -> Float {
        if let classification = collection.getClassificationByKey(iden) {
            return classification.score ?? -1
        }else {
            return -1
        }
    }
    
    // sorted with number of cards
    class func getNumberSortedClassifiedCards(_ cards: [CardInfoObjModel]) -> [(iden: String, cards: [CardInfoObjModel])] {
        var sorted = [String: [CardInfoObjModel]]()
        for card in cards {
            if let iden = card.currentIdentification() {
                if sorted[iden] == nil {
                    sorted[iden] = [card]
                }else {
                    sorted[iden]!.append(card)
                }
            }
        }
        var array = [(iden: String, cards: [CardInfoObjModel])]()
        for (key, value) in sorted {
            array.append((key, value))
        }
        array.sort(by: { $0.cards.count > $1.cards.count })
        
        return array
    }
    
    class func getHighLowClassifiedCards(_ cards: [CardInfoObjModel]) -> [(iden: String, cards: [CardInfoObjModel])] {
        var sorted = [String: [CardInfoObjModel]]()
        for card in cards {
            if let iden = card.currentIdentification() {
                if sorted[iden] == nil {
                    sorted[iden] = [card]
                }else {
                    sorted[iden]!.append(card)
                }
            }
        }
        var array = [(iden: String, cards: [CardInfoObjModel])]()
        for (key, value) in sorted {
            array.append((key, value))
        }
        array.sort(by: { getValueOfIden($0.iden) > getValueOfIden($1.iden)})
        
        return array
    }
    
    
    // Low high score rule
    // score: little is good, say no to high score
    class func checkLowHighOfRisk(_ riskKey: String) -> Bool {
        let tier = collection.getTierOfRisk(riskKey)
        // tier 0
        if tier == 0 {
            return false
        }
        
        // tier 1
        if riskKey == brainAgeKey || riskKey == sleepQuestionkey {
            return false
        }
        
        // tier 2
        let risk = collection.getRisk(riskKey)!
        let riskTypeType = RiskTypeType.getTypeOfRiskType(risk.riskTypeKey!)
        if riskTypeType == .iAa {
            return false 
        }
        
        return true
    }

    
    // MARK: ---------- Measurment -----------------------------
    class func showEncoreForMeasurement(_ measurement: MeasurementObjModel) -> Bool {
        if let risk = collection.getRisk(measurement.riskKey) {
            if RiskTypeType.getTypeOfRiskType(risk.riskTypeKey!) == .iRa {
                let mainCardString = "Gene Polymorphism"
                var subCardStrings = [String]()
                let threshold: Float = 0.8
                if let metricKey = risk.metricKey {
                    if metricKey == vitaminDMetricKey {
                        subCardStrings = ["Age"]
                    }else if metricKey == alzheimerMetricKey {
                        subCardStrings = ["Diabetes","Head Trauma"]
                    }else {
                        return false
                    }
                }
                
                // the main card
                var judgeCards = [CardInfoObjModel]()
                let allCards = collection.getScoreCardsOfRisk(risk.key)
                for card in allCards {
                    if card.title!.contains(mainCardString) {
                        judgeCards.append(card)
                    }
                }
                
                var matchIndexes = [Int]()
                for judgeCard in judgeCards {
                    if let index = judgeCard.getIndexChosenInMeasurement(measurement) {
                        matchIndexes.append(index)
                    }
                }
                
                if matchIndexes.contains(0) {
                    // get encore
                    return true
                }else if matchIndexes.contains(1) {
                    var subCards = [CardInfoObjModel]()
                    var subIndexes = [Int]()
                    for card in allCards {
                        for sub in subCardStrings {
                            if card.title!.contains(sub) {
                                subCards.append(card)
                                break
                            }
                        }
                    }
                    for card in subCards {
                        if let index = card.getIndexChosenInMeasurement(measurement) {
                            subIndexes.append(index)
                        }
                    }
                    
                    if subIndexes.contains(0) {
                        return true
                    }
                }
                
                // use ratio
                let classified = MatchedCardsDisplayModel.getSortedScoreCardsInMeasurement(measurement, lowToHigh: true)
                if let last = classified.last {
                    if Float(last.cards.count) > threshold * Float(allCards.count) {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    class func getMatchedComplementaryCardsInMeaurement(_ measurement: MeasurementObjModel) -> [CardInfoObjModel] {
        var cards = [CardInfoObjModel]()
        
        if let risk = collection.getRisk(measurement.riskKey!) {
            for value in measurement.values {
                for factor in risk.riskFactors {
                    if factor.card?.metricKey! == value.metricKey {
                        if factor.isComplementary {
                            cards.append(factor.card!)
                            break
                        }
                    }
                }
            }
        }
        
        return cards
    }
    
    class func getMatchedScoreCardsInMeaurement(_ measurement: MeasurementObjModel) -> [CardInfoObjModel] {
        var cards = [CardInfoObjModel]()
        
        if let risk = collection.getRisk(measurement.riskKey!) {
            for value in measurement.values {
                for factor in risk.riskFactors {
                    if factor.card?.metricKey == value.metricKey && factor.isScore {
                        // the right card
                        let card = factor.card!
                        var flag = false
                        let displayOptions = card.getDisplayOptionsForUser(measurement.playerKey)
                        for option in displayOptions {
                            if option.matchKey! == value.matchKey {
                                cards.append(card)
                                flag = true
                                break
                            }
                        }
                        
                        // not answered, check chained
                        if !flag {
                            for option in displayOptions {
                                if let chainedKey = option.match?.classification?.chainedCardKey {
                                    if let chainedCard = collection.getCard(chainedKey) {
                                        for option in chainedCard.getDisplayOptionsForUser(measurement.playerKey) {
                                            if option.matchKey == value.matchKey {
                                                cards.append(card)
                                                flag = true
                                                break
                                            }
                                        }
                                    }
                                }
                                
                                if flag {
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return cards
    }
    
    class func getSortedComplementaryCardsInMeasurement(_ measurement: MeasurementObjModel, lowToHigh: Bool) -> [(iden: String, cards: [CardInfoObjModel])] {
        var sortedDic = [String: [CardInfoObjModel]]()
        for card in getMatchedComplementaryCardsInMeaurement(measurement) {
            if let iden = card.getIdenInMeasurement(measurement) {
                if sortedDic[iden] == nil {
                    sortedDic[iden] = [card]
                }else {
                    sortedDic[iden]!.append(card)
                }
            }
        }
        
        var array = [(iden: String, cards: [CardInfoObjModel])]()
        for (key, value) in sortedDic {
            array.append((key, value))
        }
        
        if lowToHigh {
            array.sort(by: {getValueOfIden($0.iden) < getValueOfIden($1.iden)})
        }else {
            array.sort(by: {getValueOfIden($0.iden) > getValueOfIden($1.iden)})
        }
        
        return array
    }
    
    
    class func getSortedScoreCardsInMeasurement(_ measurement: MeasurementObjModel, lowToHigh: Bool) -> [(iden: String, cards: [CardInfoObjModel])] {
        var sortedDic = [String: [CardInfoObjModel]]()
        for card in getMatchedScoreCardsInMeaurement(measurement) {
            if let iden = card.getIdenInMeasurement(measurement) {
                if sortedDic[iden] == nil {
                    sortedDic[iden] = [card]
                }else {
                    sortedDic[iden]!.append(card)
                }
            }else {
                print("can not get iden for card: \(String(describing: card.key))")
            }
        }
        
        var array = [(iden: String, cards: [CardInfoObjModel])]()
        for (key, value) in sortedDic {
            array.append((key, value))
        }
        
        if lowToHigh {
            array.sort(by: {getValueOfIden($0.iden) < getValueOfIden($1.iden)})
        }else {
            // from high score to low score
            array.sort(by: {getValueOfIden($0.iden) > getValueOfIden($1.iden)})
        }
        
        return array
    }
    
    
    class func getScoredClassifiedCardsInMeasurement(_ measurement: MeasurementObjModel, badToGood: Bool) -> [(iden: String, cards: [CardInfoObjModel])] {
        var sortedDic = [String: [CardInfoObjModel]]()
        for card in getMatchedScoreCardsInMeaurement(measurement) {
            if let iden = card.getIdenInMeasurement(measurement) {
                if sortedDic[iden] == nil {
                    sortedDic[iden] = [card]
                }else {
                    sortedDic[iden]!.append(card)
                }
            }else {
                print("can not get iden for card: \(card.key!)")
            }
        }
        
        var array = [(iden: String, cards: [CardInfoObjModel])]()
        for (key, value) in sortedDic {
            array.append((key, value))
        }
        
        let lowHigh = checkLowHighOfRisk(measurement.riskKey!) // low score is better

        if (badToGood && lowHigh) || (!badToGood && !lowHigh) {
            // from high score to low score
            array.sort(by: {getValueOfIden($0.iden) > getValueOfIden($1.iden)})
        }else {
            array.sort(by: {getValueOfIden($0.iden) < getValueOfIden($1.iden)})
        }

        return array
    }
    
    class func getAllClassifiedCardsInMeasurement(_ measurement: MeasurementObjModel, badToGood: Bool) -> [(iden: String, cards: [CardInfoObjModel])] {
        var sortedDic = [String: [CardInfoObjModel]]()
        if let risk = collection.getRisk(measurement.riskKey!) {
            for value in measurement.values {
                for factor in risk.riskFactors {
                    if factor.card?.metricKey! == value.metricKey {
                        let card = factor.card!
                        if let iden = card.getIdenInMeasurement(measurement) {
                            if sortedDic[iden] == nil {
                                sortedDic[iden] = [card]
                            }else {
                                sortedDic[iden]!.append(card)
                            }
                        }else {
                            print("can not get iden for card: \(card.key ?? "")")
                        }
                        break
                    }
                }
            }
        }
        
        var array = [(iden: String, cards: [CardInfoObjModel])]()
        for (key, value) in sortedDic {
            array.append((key, value))
        }
        
        let lowHigh = checkLowHighOfRisk(measurement.riskKey!) // low score is better
        
        if (badToGood && lowHigh) || (!badToGood && !lowHigh) {
            // from high score to low score
            array.sort(by: {getValueOfIden($0.iden) > getValueOfIden($1.iden)})
        }else {
            array.sort(by: {getValueOfIden($0.iden) < getValueOfIden($1.iden)})
        }
        
        return array
    }
    
    // results
    class func getTotalScoreOfMeasurement(_ measurement: MeasurementObjModel) -> Float {
        var score: Float = 0
        let riskKey = measurement.riskKey!
        if riskKey == sleepQualityKey {
            let sorted = collection.getCategoryToCardsOfRiskKeyEx(riskKey)
            
            for (categoryKey, cards) in sorted {
                var sub: Float = 0
                
                // input card
                if categoryKey == category_UserInput {
                    var total: Float = 1
                    var gap: Float = 1
                    for card in cards {
                        if card.isBonusCardInRisk(riskKey) {
                            continue
                        }
                        
                        if let a = card.getScoreInMeasurement(measurement) {
                            if card.cardStyleKey == UserSelectCardTemplateView.styleKey() {
                                total = a
                            }else {
                                gap = a / 60
                            }
                        }
                    }
                    
                    let result = total / gap
                    if result >= 0.85 {
                        sub = 0
                    }else if result >= 0.75 {
                        sub = 1
                    }else if result >= 0.65 {
                        sub = 2
                    }else {
                        sub = 3
                    }
              
                }else {
                    // selection
                    for card in cards {
                        if card.isBonusCardInRisk(riskKey) {
                            continue
                        }

                        if let a = card.getScoreInMeasurement(measurement) {
                            sub += a
                        }
                    }
                    
                    let intSub = Int(sub)
                    if categoryKey == category_Sleep_Latency ||  categoryKey == category_Daytime {
                        if intSub == 0 {
                            sub = 0
                        }else if intSub <= 2 {
                            sub = 1
                        }else if intSub <= 4 {
                            sub = 2
                        }else {
                            sub = 3
                        }
                    }else if categoryKey == category_sleep_Disturbance {
                        if intSub == 0 {
                            sub = 0
                        }else if intSub <= 9 {
                            sub = 1
                        }else if intSub <= 18 {
                            sub = 2
                        }else {
                            sub = 3
                        }
                    }
                }
                score += sub
            }
        }else {
            let cards = collection.getScoreCardsOfRisk(riskKey)
            for card in cards {
                if let a = card.getScoreInMeasurement(measurement) {
                    score += a
                }
            }
        }

        return score
    }
    
    // full mark
    class func getMaxScoreOfRisk(_ riskKey: String) -> Float {
        let classifiers = collection.getRisk(riskKey).classifiers
        if classifiers.isEmpty {
            return Float(collection.getScoreCardsOfRisk(riskKey).count)
        }
        return classifiers.last!.rangeGroup?.groupRanges.first!.max ?? 0
    }
    
    class func getResultClassifierOfMeasurement(_ measurement: MeasurementObjModel) -> ClassifierObjModel! {
        let result = getTotalScoreOfMeasurement(measurement)
        if let risk = collection.getRisk(measurement.riskKey) {
            for classifier in risk.classifiers {
                if let group = classifier.rangeGroup {
                    for range in group.groupRanges {
                        if range.numberIsInThisRange(result){
                            return classifier
                        }
                    }
                }
            }
        }
        
        return nil
    }
 
    class func getResultClassificationKeyOfMeasurement(_ measurement: MeasurementObjModel) -> String? {
        if collection.getTierOfRisk(measurement.riskKey!) == 2 {
            var most = getSortedScoreCardsInMeasurement(measurement, lowToHigh: true)
            if most.isEmpty {
                // expired data
                return nil
            }
            most.sort(by: {$0.cards.count > $1.cards.count})
            return most.first!.0
        }else {
            return getResultClassifierOfMeasurement(measurement).classificationKey
        }
    }
    
    // MARK: --------------------------- Get cards ---------------------------
    // with the seq as category->cards
    // current
    class func getCurrentMatchedCardsFromCards(_ cards: [CardInfoObjModel]) -> [CardInfoObjModel] {
        var matched = [CardInfoObjModel]()
        for card in cards {
            if card.currentPlayed() {
                matched.append(card)
            }
        }
        
        return matched
    }
    
    
    class func getCurrentAllMatchedCardsOfRisk(_ riskKey: String) -> [CardInfoObjModel] {
        return getCurrentMatchedCardsFromCards(collection.getAllDisplayCardsOfRisk(riskKey))
    }
    
    class func riskIsCurrentPlayed() -> Bool {
        if let riskKey = cardsCursor.focusingRiskKey {
            let cards = collection.getScoreCardsOfRisk(riskKey)
            for card in cards {
                if card.currentPlayed() {
                    return true
                }
            }
        }
        return false
    }
    
    class func currentAllScoreCardsPlayed() -> Bool {
        if let riskKey = cardsCursor.focusingRiskKey {
            let cards = collection.getScoreCardsOfRisk(riskKey)
            let played = getCurrentMatchedCardsFromCards(cards)
            
            return cards.count == played.count
        }
        
        return false
    }
    
    class func currentAllCardsPlayed() -> Bool {
        if let riskKey = cardsCursor.focusingRiskKey {
            let cards = collection.getScoreCardsOfRisk(riskKey)
            let played = getCurrentMatchedCardsFromCards(cards)
            
            return cards.count == played.count
        }
        return false
    }
    
    class func getAllMatchedScoreCardsOfRiskClass(_ riskClassKey: String, riskTypeKey: String) -> [CardInfoObjModel] {
        var matchedCards = Set<CardInfoObjModel>()
        let allRisks = collection.getRiskModelKeys(riskClassKey, riskType: riskTypeKey)
        
        // userkey: riskKey: measurement
        for riskKey in allRisks {
            let cards = collection.getScoreCardsOfRisk(riskKey)
            let matched = getCurrentMatchedCardsFromCards(cards)
            for card in matched {
                matchedCards.insert(card)
            }
        }

        return Array(matchedCards)
    }
    
    class func getAllMatchedScoreCardsOfRiskType(_ riskTypeKey: String, forUser userKey: String) -> [CardInfoObjModel] {
        var matchedCards = Set<CardInfoObjModel>()
        let sort = LandingModel.getAllTierRiskClasses()
        var riskClasses = [MetricObjModel]()
        let riskTypeType = RiskTypeType.getTypeOfRiskType(riskTypeKey)
        if riskTypeType == .iCa {
            riskClasses = sort[0]!
        }else if riskTypeType == .iPa {
            riskClasses = sort[1]!
        }else {
            riskClasses = sort[2]!
        }
        
        for riskClass in riskClasses {
            let cards = getAllMatchedScoreCardsOfRiskClass(riskClass.key, riskTypeKey: riskTypeKey)
            for card in cards {
                matchedCards.insert(card)
            }
        }
        
        return Array(matchedCards)
    }


    // conclusion
    class func checkPlayStateOfTier(_ tier: Int) -> Bool {
        let landingModel = LandingModel.getAllTierRiskClasses()
        if let riskClasses = landingModel[tier] {
            if tier != 2 {
                var typeKey = ""
                if tier == 0 {
                    typeKey = GameTintApplication.sharedTint.iCaKey
                }else if tier == 1 {
                    typeKey = GameTintApplication.sharedTint.iPaKey
                }
                
                for riskClass in riskClasses {
                    let played = getAllMatchedScoreCardsOfRiskClass(riskClass.key, riskTypeKey: typeKey)
                    if played.count != 0 {
                        return true
                    }
                }
            }else {
                for type in collection.getAllRiskTypes() {
                    let typeKey = type.key!
                    if typeKey == GameTintApplication.sharedTint.iCaKey || typeKey == GameTintApplication.sharedTint.iPaKey {
                        continue
                    }
                    for riskClass in riskClasses {
                        let played = getAllMatchedScoreCardsOfRiskClass(riskClass.key, riskTypeKey: typeKey)
                        if played.count != 0 {
                            return true
                        }
                    }
                }
            }
           
        }
        
        return false
    }
    
    // ------------------- get classification of CARD ---------------------
    class func getMostPlayedOfRiskType(_ riskTypeKey: String) -> String! {
        let userKey = userCenter.currentGameTargetUser.Key()
        let cards = getAllMatchedScoreCardsOfRiskType(riskTypeKey, forUser: userKey)
        if let most = getNumberSortedClassifiedCards(cards).first {
        return most.iden
        }
        
        return nil
    }
    class func getMostPlayedOfRiskClass(_ riskClassKey: String) -> String! {
        var cards = [CardInfoObjModel]()
        for riskType in collection.getAllRiskTypes() {
            // different types, no same cards
            cards.append(contentsOf: getAllMatchedScoreCardsOfRiskClass(riskClassKey, riskTypeKey: riskType.key))
        }
        
        if let most = getNumberSortedClassifiedCards(cards).first {
            return most.iden
        }
        
        return nil
    }
    
    class func getRisksPlayedForRiskClass(_ riskClassKey: String, ofTier tierIndex:Int) -> [String] {
        let all = collection.getAllRisksOfRiskClass(riskClassKey)
        let iCaKey = GameTintApplication.sharedTint.iCaKey
        let iPaKey = GameTintApplication.sharedTint.iPaKey
        
        // filter
        var riskKeys = [String]()
        for riskKey in all {
            let riskTypeKey = collection.getRisk(riskKey).riskTypeKey ?? ""
            if tierIndex == 0 {
                if riskTypeKey != iCaKey {
                    continue
                }
            }else if tierIndex == 1 {
                if riskTypeKey != iPaKey {
                    continue
                }
            }else {
                if riskTypeKey == iCaKey || riskTypeKey == iPaKey {
                    continue
                }
            }
            
            let cards = collection.getScoreCardsOfRisk(riskKey)
            for card in cards {
                if card.currentPlayed() {
                    riskKeys.append(riskKey)
                    break
                }
            }
        }
        
        return riskKeys
    }
}



// MARK: ------------ cardInfo obj model, for result check
extension CardInfoObjModel {
    func getDisplayOptions() -> [CardOptionObjModel]{
        return getDisplayOptionsForUser(userCenter.currentGameTargetUser.Key())
    }
    
    func getDisplayOptionsForUser(_ userKey: String) -> [CardOptionObjModel]{
        if self.parentCardMetricKey != nil {
            // parent card, played in record
            if let cardKey = selectionResults.getCardKeyOf(userKey, metricKey: parentCardMetricKey!) {
                // !!! To Do, make sure card cardInfo.parentCardMetricKey has been played
                let match = selectionResults.getMatchChosenByUser(userKey, cardKey: cardKey)
                // use match as selection mask to select match options from card cardInfo
                var displayOptions = [CardOptionObjModel]()
                
                for option in cardOptions {
                    if option.match?.mask == match?.key {
                        displayOptions.append(option)        // found one
                    }
                }
                
                if !displayOptions.isEmpty {
                    return displayOptions
                }
            }
        }
        
        return cardOptions
    }
    
    // card style
    func isBonusCardInRisk(_ riskKey: String) -> Bool {
        if let factorKey = collection.getRiskFactorOfCard(key, inRisk: riskKey) {
            if let factor = collection.getRiskFactorByKey(factorKey) {
                return factor.isBonus
            }
        }
        
        return false
    }
    
    func isComplementaryCardInRisk(_ riskKey: String) -> Bool {
        if let factorKey = collection.getRiskFactorOfCard(key, inRisk: riskKey) {
            if let factor = collection.getRiskFactorByKey(factorKey) {
                return factor.isComplementary
            }
        }
        
        return false
    }
    
    func isScorecardInRisk(_ riskKey: String) -> Bool {
        if let factorKey = collection.getRiskFactorOfCard(key, inRisk: riskKey) {
            if let factor = collection.getRiskFactorByKey(factorKey) {
                return factor.isScore
            }
        }
        
        return false
    }
    
    func isInputCard() -> Bool {
        return (cardStyleKey == UserSelectCardTemplateView.styleKey() || cardStyleKey == TimeSelectCardTemplateView.styleKey() || cardStyleKey == StrengthInputCardTemplateView.styleKey())
    }
    
    func isJudgementCard() -> Bool {
        return (cardStyleKey == JudgementCardTemplateView.styleKey() || cardStyleKey == PromptJudgementCardTemplateView.styleKey())
    }
    
    // MARK: ------------------- with measuremnt
    func getMeasurementValueInMeasurement(_ measurement: MeasurementObjModel) -> MeasurementValueObjModel! {
        for value in measurement.values {
            if value.metricKey == metricKey {
                return value
            }
        }
        
        return nil
    }
    
    func getIndexChosenInMeasurement(_ measurement: MeasurementObjModel) -> Int? {
        if let value = getMeasurementValueInMeasurement(measurement) {
            if cardOptions.count <= 1 {
                return Int(value.value)
            }else {
                for (i, option) in getDisplayOptionsForUser(measurement.playerKey).enumerated() {
                    if value.matchKey == option.matchKey {
                        return i
                    }
                }
            }
        }
        return nil
    }
    
    func getScoreInMeasurement(_ measurement: MeasurementObjModel) -> Float? {
        // input
        if isInputCard() {
            return getMeasurementValueInMeasurement(measurement).value
        }
        
        // selection
        if let index = getIndexChosenInMeasurement(measurement) {
            let displayOptions = getDisplayOptionsForUser(measurement.playerKey)
            if displayOptions.count == 1 {
                return Float(index == 1 ? 0 : 1)
            } else if let chosenMatch = displayOptions[index].match {
                if let score = chosenMatch.score {
                    return score
                }
                print("score is not added")
                return Float(index)
            }
        }
        
        return nil
    }
    
    // original
    func getOriginalMatchInMeasurement(_ measurement: MeasurementObjModel) -> MatchObjModel! {
        if let value = getMeasurementValueInMeasurement(measurement) {
            let matchKey = value.matchKey
            let displayOptions = getDisplayOptionsForUser(measurement.playerKey)
            for option in displayOptions {
                if option.matchKey == matchKey {
                    return collection.getMatch(matchKey)
                }
            }
            
            for option in displayOptions {
                if let chain = option.match?.classification?.chainedCardKey {
                    if let card = collection.getCard(chain) {
                        for chainOption in card.getDisplayOptionsForUser(measurement.playerKey) {
                            if chainOption.matchKey == matchKey {
                                return collection.getMatch(option.matchKey)
                            }
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    func getIdenInMeasurement(_ measurement: MeasurementObjModel) -> String! {
        if let match = getOriginalMatchInMeasurement(measurement) {
            // inputCard
            if isInputCard() {
                print("There is a input card:\(key!)")
                return "Medium"
            }
            // multiple choice
            return match.classificationKey ?? UnClassifiedIden
        }
        
        return nil
    }
    
    
    // MARK: ------ current answer
    func getIndexChosenByUser(_ userKey: String) -> Int? {
        if key == nil {
            return nil
        }
        
        // multiple
        return selectionResults.getChosenIndexByUser(userKey, cardKey: key)
    }
    
    func chosenClassification(_ userKey: String) -> ClassificationObjModel! {
        if key == nil {
            return nil
        }
        
        // multiple
        if let chosenMatch = selectionResults.getMatchChosenByUser(userKey, cardKey: key) {
            return chosenMatch.classification
        }
        return nil
    }
    
    func chosenIdentification(_ userKey: String) -> String! {
        if key == nil {
            return nil
        }
        
        // TODO: --------- judgement card...
        if isJudgementCard() && cardOptions.count == 1 {
            if let value = selectionResults.getValueInputByUser(userKey, cardKey: key) {
                return Int(value) == 0 ? "ME" : "NOT ME"
            }
            return nil
        }
        
        // multiple
        if let chosenMatch = selectionResults.getMatchChosenByUser(userKey, cardKey: key) {
            return chosenMatch.classificationKey ?? UnClassifiedIden
        }
        
        return nil
    }
    
    // current user
    // index
    // all use functions not calculated values because of local database
    func currentPlayed() -> Bool {
        return currentOption() != nil
    }
    
    func currentSelection() -> Int! {
        return getIndexChosenByUser(userCenter.currentGameTargetUser.Key())
    }
    
    
    func currentIdentification() -> String! {
        return chosenIdentification(userCenter.currentGameTargetUser.Key())
    }
    
    func currentOption() -> CardOptionObjModel! {
        if let result = currentSelection() {
            if isJudgementCard() {
                return getDisplayOptions().first
            }else {
                return getDisplayOptions()[result]
            }
        }else if isInputCard() {
            if let _ = currentInput() {
                return getDisplayOptions().first
            }else {
                return nil
            }
        }
        
        return nil
    }
    
    func currentMatch() -> MatchObjModel! {
        return currentOption()?.match
    }
    
    func judgementChoose() -> Bool! {
        if isJudgementCard() {
            if let result = currentSelection() {
                return result == 0
            }
        }
        
        return nil
    }
    
    func showBaseline() -> Bool {
        if WHATIF {
            let baselineM = selectionResults.getLastMeasurementOfUser(userCenter.currentGameTargetUser.Key(), riskKey: cardsCursor.focusingRiskKey, whatIf: false)!
            if let current = currentSelection() {
                if let index = getIndexChosenInMeasurement(baselineM) {
                    return (index != current)
                }
            }
        }
        return false
    }
    
    func currentMatchedText() -> String {
        if isInputCard() {
            return "\(title ?? "") : \(currentInput() ?? 0)"
        }
        
        if let result = currentSelection() {
            let match = currentMatch()!
            
            // ME/NOT ME
            if isJudgementCard() {
                var statement = match.statement ?? "Check Image"
                if statement.count < 2 {
                    statement = title!
                }
                return result == 0 ? "ME: \(statement)" : "NOT ME: \(statement)"
            }
            
            return "\(title ?? "") (\(String(describing: match.name ?? "")))"
            
        }else {
            // no choice, not answered
            return "Not Answered"
        }
    }
    
    func currentMatchedChoice() -> String {
        if let savedMatch = getSavedMatch() {
            if isInputCard() {
                return "Input: \(String(format: "%.2f", currentInput() ?? 0))"
            }
            
            if let result = currentSelection() {
                // ME/NOT ME
                if isJudgementCard() {
                    return result == 0 ? "ME" : "NOT ME"
                }
                if let match = currentMatch() {
                    if match.key != savedMatch {
                        let saved = collection.getMatch(savedMatch)!
                        return "\(match.name ?? ""): \(saved.name ?? "")"
                    }else {
                        return match.name ?? ""
                    }
                }
            }
        }
        
        // no choice, not answered
        return "Not Answered"
        
    }
    
    func cardTitle() -> String {
        return title ?? ""
    }
    
    func currentImageUrl() ->  URL! {
        if currentMatch() == nil {
            return nil
        }
        
        return isJudgementCard() ? getDisplayOptions().first?.match?.imageUrl : currentMatch().imageUrl
    }
    
    func connectedRisks() -> [RiskObjModel] {
        var risks = [RiskObjModel]()
        for risk in collection.getLoadedRisks() {
            let cards = collection.getAllDisplayCardsOfRisk(risk.key)
            for vCard in cards {
                if key == vCard.key {
                    risks.append(risk)
                    break
                }
            }
        }
        
        return risks
    }
    
    // MARK: -------- set ---------------
    // cache
    func saveResult(_ matchKey: String?, answerIndex: Int) {
        var resultMatchKey = matchKey
        let displayOptions = getDisplayOptions()
        if matchKey == nil {
            // for some normal card's benifit
            if displayOptions.count == 1 {
                resultMatchKey = displayOptions.first!.matchKey
            }else {
                if answerIndex >= 0 && answerIndex < displayOptions.count {
                    resultMatchKey = displayOptions[answerIndex].matchKey
                }
            }
        }
        
        // data cached
        selectionResults.addUserCardInput(userCenter.currentGameTargetUser.Key(), cardKey: key, metricKey: metricKey, selectedMatchKey: resultMatchKey, input: Float(answerIndex), refValue: nil)
    }
    
    // set image
    func addMatchedImageOnImageView(_ imageView: UIImageView) {
        // check answer
        if currentPlayed() {
            imageView.sd_setImage(with: currentImageUrl(), placeholderImage: ProjectImages.sharedImage.imagePlaceHolder, options: .refreshCached, progress: nil) { (image, error, type, url) in
            }
        }else {
            // no choice, not answered
            imageView.image = UIImage(named: "card_noChoice")
        }
    }
    
    // Input
    func saveInput(_ inputValue: Float, matchKey: String!, refValue: Float!) {
        // data cached
        selectionResults.addUserCardInput(userCenter.currentGameTargetUser.Key(), cardKey: key, metricKey: metricKey, selectedMatchKey: matchKey, input: inputValue, refValue: refValue)
    }
    
    func currentInput() -> Float? {
        return selectionResults.getValueInputByUser(UserCenter.sharedCenter.currentGameTargetUser.Key(), cardKey: key)
    }
    
    func currentRefValue() -> Float? {
        return selectionResults.getRefValueInputByUser(UserCenter.sharedCenter.currentGameTargetUser.Key(), cardKey: key)
    }
    
    // chain
    func getChainedAnswerIndex() -> Int? {
        return selectionResults.getChosenChainCardIndexByUser(UserCenter.sharedCenter.currentGameTargetUser.Key(), cardKey: key)
    }
    
    func getSavedMatch() -> String? {
        return selectionResults.getSavedMatchByUser(UserCenter.sharedCenter.currentGameTargetUser.Key(), cardKey: key)
    }
}

