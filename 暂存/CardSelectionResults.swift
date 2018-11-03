//
//  CardSelectionResults.swift
//  ABook_iPhone_V1
//
//  Created by hui wang on 12/7/16.
//  Copyright © 2016 LyTsai. All rights reserved.
//

import Foundation

// collection of cached card selection of all risk models for all users
class CardSelectionResults {
    // MARK: ---------- singleton
    static let cachedCardProcessingResults = CardSelectionResults()
    
    fileprivate var accessRecord = [String: [String: Bool]]()
    fileprivate var localRecord = [String: [String: Bool]]()
    fileprivate var key2Measurement = [String: MeasurementObjModel]()

    fileprivate var userCardResults = [String: [String: [MeasurementValueObjModel]]]()
    
    // MARK: ----------- record of last play -------------------
    // userkey: [riskKey : ()]]
    fileprivate var lastRecord = [String: [String: String]]()
    fileprivate var lastWhatIfRecord = [String: [String: String]]()
   
    // Load
    func measurementLoadedFromBackendForUser(_ userKey: String, riskKey: String) -> Bool {
        return accessRecord[userKey]?[riskKey] ?? false
    }
    func loadMeasurementFromBackend(_ measurement: MeasurementObjModel) {
        let userKey = measurement.playerKey!
        let riskKey = measurement.riskKey!
        measurement.whatIfFlag = 0
        
        if accessRecord[userKey] == nil {
            accessRecord[userKey] = [riskKey : true]
        }else {
            accessRecord[userKey]![riskKey] = true
        }
        
        for value in measurement.values {
            var metric = collection.getMetric(value.metricKey)
            if metric == nil && value.metricKey != nil {
                if localDB.database.open() {
                    metric = collection.getMetricWithLocalKey(value.metricKey)
                    localDB.database.close()
                }
            }
            
            value.metric = metric
            
            var match = collection.getMatch(value.matchKey)
            if match == nil && value.matchKey != nil {
                if localDB.database.open() {
                    match = collection.getMatchWithLocalKey(value.matchKey)
                    localDB.database.close()
                }
            }
            
            value.match = match
        }
        
        saveAsLastRecord(measurement)
        key2Measurement[measurement.key] = measurement
        
        if localDB.database.open() {
            measurement.saveToLocalDatabase()
            localDB.database.close()
        }
    }
    
    func measurementLoadedFromLocalForUser(_ userKey: String, riskKey: String) -> Bool {
        return localRecord[userKey]?[riskKey] ?? false
    }
    
    func getAllLocalMeasurementsForUser(_ userKey: String, riskKey: String) {
        if !measurementLoadedFromLocalForUser(userKey, riskKey: riskKey) {

            if localRecord[userKey] == nil {
                localRecord[userKey] = [riskKey : true]
            }else {
                localRecord[userKey]![riskKey] = true
            }
            
            let isUser = (userKey == userCenter.loginUserObj.key)
            if localDB.database.open() {
                let userColumn = isUser ? "UserKey" : "PseudoUserKey"
                let condition: [String: Any] = [userColumn: userKey, "RiskKey" : riskKey]
                let measurementDics = localDB.getModelDicsWithCondition(condition, inTable:  MeasurementObjModel.tableName)
                for dic in measurementDics {
                    if let measurement = MeasurementObjModel.fromSqliteDicToModel(dic) {
                        if isUser {
                            measurement.user = userCenter.loginUserObj
                        }else {
                            measurement.pseudoUser = userCenter.getPseudoUser(userKey)
                        }
                        
                        for value in measurement.values {
                            value.metric = collection.getMetricWithLocalKey(value.metricKey)
                            value.match = collection.getMatchWithLocalKey(value.matchKey)
                        }
                        
                        key2Measurement[measurement.key] = measurement
                        saveAsLastRecord(measurement)
                    }
                }
                localDB.database.close()
            }
        }
    }
    
    func getLastRiskMeasurementForUser(_ userKey: String, riskKey: String) -> MeasurementObjModel? {
        var latestMeasurement: MeasurementObjModel? = nil
        let isUser = (userKey == userCenter.loginUserObj.key)
        if localDB.database.open() {
            let userColumn = isUser ? "UserKey" : "PseudoUserKey"
            let condition: [String: Any] = [userColumn: userKey, "RiskKey" : riskKey]
            let measurementDics = localDB.getModelDicsWithCondition(condition, inTable:  MeasurementObjModel.tableName)
            for dic in measurementDics {
                if let measurement = MeasurementObjModel.fromSqliteDicToModel(dic) {
                    if isUser {
                        measurement.user = userCenter.loginUserObj
                    }else {
                        measurement.pseudoUser = userCenter.getPseudoUser(userKey)
                    }
                    
                    for value in measurement.values {
                        value.metric = collection.getMetricWithLocalKey(value.metricKey)
                        value.match = collection.getMatchWithLocalKey(value.matchKey)
                    }
                    
                    if latestMeasurement == nil || measurement.timeString > latestMeasurement!.timeString {
                        latestMeasurement = measurement
                    }
                }
            }
            localDB.database.close()
        }
        return latestMeasurement
    }
    
    // select all risk measurements from key2Measurement collection
    func getLoadedMeasurementsOfUser(_ userKey: String, riskKey: String) -> [MeasurementObjModel] {
        var measurements = [MeasurementObjModel]()
        for measurement in key2Measurement.values {
            if measurement.playerKey == userKey && measurement.riskKey == riskKey {
                measurements.append(measurement)
            }
        }
        return measurements
    }
    
    // select either baseline or whatif test drive risk measurements from key2Measurement collection
    func getLoadedBaselineMeasurementsOfUser(_ userKey: String, riskKey: String) -> [MeasurementObjModel] {
        var measurements = [MeasurementObjModel]()
        for measurement in key2Measurement.values {
            if measurement.whatIfFlag == 0 && measurement.playerKey == userKey && measurement.riskKey == riskKey {
                measurements.append(measurement)
            }
        }
        return measurements
    }
    
    func getLoadedWhatifMeasurementsOfUser(_ userKey: String, riskKey: String) -> [MeasurementObjModel] {
        var measurements = [MeasurementObjModel]()
        for measurement in key2Measurement.values {
            if measurement.whatIfFlag == 1 && measurement.playerKey == userKey && measurement.riskKey == riskKey {
                measurements.append(measurement)
            }
        }
        return measurements
    }

    func getMeasurementByKey(_ key: String!) -> MeasurementObjModel! {
        if key == nil {
            return nil
        }
        
        return key2Measurement[key]
    }
    
    
    // Last and display
    func saveAsLastRecord(_ measurement: MeasurementObjModel) {
        key2Measurement[measurement.key] = measurement
        let userKey = measurement.playerKey!
        let riskKey = measurement.riskKey!
        let whatIf = (measurement.whatIfFlag == 1)
        
        // real
        if !whatIf {
            if lastRecord[userKey] == nil {
                lastRecord[userKey] = [riskKey : measurement.key]
            }else {
                // compare and save
                if let lastKey = lastRecord[userKey]![riskKey] {
                    if let last = key2Measurement[lastKey] {
                        if last.timeString < measurement.timeString {
                            lastRecord[userKey]![riskKey] = measurement.key
                        }
                    }
                }else {
                    lastRecord[userKey]![riskKey] = measurement.key
                }
            }
        }else {
            // what if
            if lastWhatIfRecord[userKey] == nil {
                lastWhatIfRecord[userKey] = [riskKey : measurement.key]
            }else {
                // compare and save
                if let lastKey = lastWhatIfRecord[userKey]![riskKey] {
                    if let last = key2Measurement[lastKey] {
                        if last.timeString < measurement.timeString {
                            lastWhatIfRecord[userKey]![riskKey] = measurement.key
                        }
                    }
                }else {
                    lastWhatIfRecord[userKey]![riskKey] = measurement.key
                }
            }
        }
    }
    
    func getLastMeasurementOfUser(_ userKey: String, riskKey: String, whatIf: Bool) -> MeasurementObjModel? {
        if whatIf {
            return getMeasurementByKey(lastWhatIfRecord[userKey]?[riskKey])
        }
        return getMeasurementByKey(lastRecord[userKey]?[riskKey])
    }
    
    
    func useMeasurementForDisplay(_ measurement: MeasurementObjModel!)  {
        if measurement != nil {
            let userKey = measurement.playerKey!
            clearAnswerForUser(userKey, riskKey: measurement.riskKey!)

            for value in measurement.values {
                if let vCard = collection.getCardOfMetric(value.metricKey, inRisk: measurement.riskKey!) {
                    addUserCardInput(userKey, cardKey: vCard.key, selectedMatchKey: value.matchKey, input: value.value)
                }else {
                    print("no card, data is wrong")
                }
            }
        }
    }

    func useLastMeasurementForUser(_ userKey: String, riskKey: String, whatIf: Bool) {
        if let measurement = getLastMeasurementOfUser(userKey, riskKey: riskKey, whatIf: whatIf) {
            useMeasurementForDisplay(measurement)
        }else {
            clearAnswerForUser(userKey, riskKey: riskKey)
        }
    }

    // functions to manipulate userCardInputs
    // add user card processing result:
    // cardTargetUser - for this user (user or pseudoUser)
    // cardKey - as result of matching this card content (or processing this card options).  not used for now
    // riskKey - as result of palying this risk game
    // selection - matched to this card option
    // value - in case of value card this is the number user inputed
    // MARK: ------------------ adding -------------------------------
    func addUserCardInput(_ userKey: String, cardKey: String, selectedMatchKey: String?, input: Float?, refValue: Float?) {
        // no answer
        if (selectedMatchKey == nil) {
            return
        }
    
        // add for the risk
        let measurement = MeasurementValueObjModel()
        measurement.matchKey = selectedMatchKey
        measurement.value = input
        measurement.refValue = refValue
        
        //  not saved before
        // for the unique answer, [targetUserkey: [cardKey: Measurement]]
        if userCardResults[userKey] == nil {
            userCardResults[userKey] = [cardKey: [measurement]]
        }else {
            if userCardResults[userKey]![cardKey] == nil {
                userCardResults[userKey]![cardKey] = [measurement]
            }else {
                if let card = collection.getCard(cardKey) {
                    if card.isInputCard() {
                        var values = userCardResults[userKey]![cardKey]!
                        var index: Int!
                        for (i, value) in values.enumerated() {
                            if value.matchKey == selectedMatchKey {
                                index = i
                                break
                            }
                        }
                        if index == nil {
                            values.append(measurement)
                        }else {
                            values[index] = measurement
                        }
                        
                        userCardResults[userKey]![cardKey]! = values
                     }else {
                        userCardResults[userKey]![cardKey] = [measurement]
                    }
                }
            }
            
//            userCardResults[userKey]![cardKey] = measurement
        }
    }
    
    // MARK: ------------------ deleting -------------------------------
    func deleteInputForUser(_ userKey: String, cardKey: String) {
        userCardResults[userKey]?[cardKey] = nil
    }
    
    func clearAnswerForUser(_ userKey: String, riskKey: String) {
        let cards = collection.getAllCardsOfRisk(riskKey)
        for card in cards {
            deleteInputForUser(userKey, cardKey: card.key)
        }
    }
    
    func clearAnswerForUser(_ userKey: String, riskKey: String, categoryKey: String) {
        if let cards = collection.getCategoryToCardsOfRiskKey(riskKey)[categoryKey] {
            for card in cards {
                deleteInputForUser(userKey, cardKey: card.key)
            }
        }
    }
    
    // get and check
    func getCardsPlayedForUser(_ userKey: String, riskKey: String, categoryKey: String) -> [CardInfoObjModel] {
        if userCardResults[userKey] == nil {
            return []
        }
        
        var played = [CardInfoObjModel]()
        if let cards = collection.getCategoryToCardsOfRiskKey(riskKey)[categoryKey] {
            for card in cards {
                if userCardResults[userKey]![card.key] != nil {
                    played.append(card)
                }
            }
        }
        
        return played
    }
    
    
    // numbers
    func getNumberOfCardsPlayedForUser(_ userKey: String, riskKey: String, categoryKey: String) -> Int {
        return getCardsPlayedForUser(userKey, riskKey: riskKey, categoryKey: categoryKey).count
    }
    

    // selections and inputs
    func getMatchChosenByUser(_ userKey: String, cardKey: String) -> MatchObjModel! {
        if let values = userCardResults[userKey]?[cardKey] {
            if values.count != 0 {
                if let card = collection.getCard(cardKey) {
                    if !card.isInputCard() {
                        let matchKey = values.first!.matchKey
                        for option in card.cardOptions {
                            if option.matchKey == matchKey {
                                return collection.getMatch(matchKey!)
                            }
                        }
                    }else {
                        return card.cardOptions.first!.match
                    }
                }
            }
            
        }
        return nil
    }
    func getValueInputByUser(_ userKey: String, cardKey: String, matchKey: String) -> Float? {
        if let values = userCardResults[userKey]?[cardKey] {
            for value in values {
                if value.matchKey == matchKey {
                    return value.value
                }
            }
        }
        
        return nil
    }

    // MARK: --------- get data by using userCardResults
    // userkey: riskKey: measurement
    func prepareOneMeasurementForUser(_ userKey: String, ofRisk riskKey: String) -> MeasurementObjModel {
        let riskMeasurement = MeasurementObjModel()
        riskMeasurement.whatIfFlag = WHATIF ? 1 :0
        
        if userCardResults[userKey] == nil {
            print("no card is answered")
            return riskMeasurement
        }
        
        // date and time
        let formatter = ISO8601DateFormatter()
        let date = Date()
        let dataZStr = formatter.string(from: date)
        
        let loginUser = userCenter.loginUserObj
        let risk = collection.getRisk(riskKey)
        let cards = collection.getAllCardsOfRisk(riskKey)
        let cardList = userCardResults[userKey]!
        
        // only keys are saved, others(objModels) are nil
        riskMeasurement.key = UUID().uuidString
        riskMeasurement.info = risk?.info
        riskMeasurement.name = risk?.name
        riskMeasurement.note = "NA"
        riskMeasurement.time = date
        riskMeasurement.timeString = dataZStr
        riskMeasurement.collectUserKey = loginUser.key
                
        // check if userKey is registered user or pseudoUser
        if userCenter.pseudoUserList[userKey] != nil {
            riskMeasurement.pseudoUserKey = userKey
        }else {
            riskMeasurement.userKey = userKey
        }
                
        riskMeasurement.riskKey = riskKey
                
        // [cardKey: Measurement]
        for card in cards {
            if let values = cardList[card.key] {
                for measure in values {
                    measure.metricKey = collection.getMetricKeyForSaveOfCard(card.key, inRisk: riskKey)
                    measure.metric = collection.getMetric(measure.metricKey)
                    measure.match = collection.getMatch(measure.matchKey)
                    riskMeasurement.values.append(measure)
                }
            }
        }
        
        return riskMeasurement
    }
}


// MARK: ------------ cardInfo obj model, for result check
extension CardInfoObjModel {
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
    
    func isInputCard() -> Bool {
        return (cardStyleKey == UserSelectCardTemplateView.styleKey() || cardStyleKey == TimeSelectCardTemplateView.styleKey())
    }
    
    func isJudgementCard() -> Bool {
        return (cardStyleKey == JudgementCardTemplateView.styleKey() || cardStyleKey == PromptJudgementCardTemplateView.styleKey())
    }
    
    // MARK: ------------------- with measuremnt
    func getMeasurementValuesInMeasurement(_ measurement: MeasurementObjModel) -> [MeasurementValueObjModel] {
        var values = [MeasurementValueObjModel]()
        if let metricKey = collection.getMetricKeyForSaveOfCard(key, inRisk: measurement.riskKey!) {
            for value in measurement.values {
                if value.metricKey == metricKey {
                    values.append(value)
                }
            }
        }
        
        return values
    }
    
    func getIndexChosenInMeasurement(_ measurement: MeasurementObjModel) -> Int? {
        let values = getMeasurementValuesInMeasurement(measurement)
        if let value = values.first {
            if cardOptions.count <= 1 {
                return Int(value.value)
            }else {
                for (i, option) in cardOptions.enumerated() {
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
            return getMeasurementValuesInMeasurement(measurement).first?.value
        }
        
        // selection
        if let index = getIndexChosenInMeasurement(measurement) {
            if cardOptions.count == 1 {
                return Float(index == 1 ? 0 : 1)
            } else if let chosenMatch = cardOptions[index].match {
                if let score = chosenMatch.score {
                    return score
                }
                print("score is not added")
                return Float(index)
            }
        }
        
        return nil
    }
    
    
    func getMatchInMeasurement(_ measurement: MeasurementObjModel) -> MatchObjModel! {
        if let value = getMeasurementValuesInMeasurement(measurement).first {
            if let matchKey = value.matchKey {
                return collection.getMatch(matchKey)
            }
        }
        return nil
    }
    
    func getIdenInMeasurement(_ measurement: MeasurementObjModel) -> String! {
        if let measurementValue = getMeasurementValuesInMeasurement(measurement).first {
            // inputCard
            if isInputCard() {
                return "Medium"
            }
            
            // unfinished judgementcard
            if cardOptions.count == 1 {
                return Int(measurementValue.value) == 0 ? "ME" : "NOT ME"
            }
            
            // multiple choice
            if let match = collection.getMatch(measurementValue.matchKey) {
                return match.classification?.key
            }
            
            return "NOClassification"
            // no classification
//            if let index = getIndexChosenInMeasurement(measurement) {
//                let number = cardOptions.count
//                var iden = "High"
//                if index == number - 1 {
//                    iden = "Low"
//                }else if index == 0 {
//                    iden = "High"
//                }else {
//                    if number == 3 {
//                        iden = "Medium"
//                    }else {
//                        if index == 2 {
//                            iden = "Medium High"
//                        }else {
//                            iden = "Medium Low"
//                        }
//                    }
//                }
//
//                return iden
//            }
        }
        
        return nil
    }
    
    
    // MARK: ------ current answer
    func getIndexChosenByUser(_ userKey: String) -> Int? {
        if key == nil {
            return nil
        }

        // multiple
        if let chosenMatch = selectionResults.getMatchChosenByUser(userKey, cardKey: key) {
            for (i, option) in cardOptions.enumerated() {
                if chosenMatch.key == option.matchKey {
                    return i
                }
            }
            
            print("not fitted, matchKey: \(chosenMatch.key), cardKey: \(key)")
        }
        
        return nil
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
            if let value = selectionResults.getValueInputByUser(userKey, cardKey: key, matchKey: cardOptions.first!.matchKey!) {
                return Int(value) == 0 ? "ME" : "NOT ME"
            }
            return nil
        }
        
        // multiple
        if let chosenMatch = selectionResults.getMatchChosenByUser(userKey, cardKey: key) {
            if let classification = chosenMatch.classification {
                return classification.key
            }
            
            if let index = getIndexChosenByUser(userKey) {
                let number = cardOptions.count
                var iden = "High"
                if index == number - 1 {
                    iden = "Low"
                }else if index == 0 {
                    iden = "High"
                }else {
                    if number == 3 {
                        iden = "Medium"
                    }else {
                        if index == 2 {
                            iden = "Medium High"
                        }else {
                            iden = "Medium Low"
                        }
                    }
                }
                
                return iden
            }
        }
        
        return nil
    }
    
    // current user
    // index
    // all use functions not calculated values because of local database
    func currentPlayed() -> Bool {
        return (currentSelection() != nil || currentInput(cardOptions.first!.matchKey!) != nil)
    }
    
    func currentSelection() -> Int! {
        return getIndexChosenByUser(userCenter.currentGameTargetUser.Key())
    }

    
    func currentIdentification() ->  String! {
        return chosenIdentification(userCenter.currentGameTargetUser.Key())
    }
    
    func currentOption() ->  CardOptionObjModel! {
        if let result = currentSelection() {
            if cardOptions.count == 1 {
                return cardOptions.first
            }else {
                return cardOptions[result]
            }
        }else if cardStyleKey == UserSelectCardTemplateView.styleKey() {
            return cardOptions.first
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
            var text = ""
            for option in cardOptions {
                text.append("\(title ?? "") : \(currentInput(option.matchKey!) ?? 0)")
            }
            
            return text
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
//        if isInputCard() {
//            return "\(currentInput() ?? 0)"
//        }
        
        if let result = currentSelection() {
            // ME/NOT ME
            if isJudgementCard() {
                return result == 0 ? "ME" : "NOT ME"
            }
            if let match = currentMatch() {
                return match.name ?? ""
            }
        }
        
        // no choice, not answered
        return "Not Answered"
    }
    
    func currentMatchedDetail() -> String {
        return title ?? ""
    }
    
    func currentImageUrl() ->  URL! {
        if currentMatch() == nil {
            return nil
        }
        
        return isJudgementCard() ? cardOptions.first?.match?.imageUrl : currentMatch().imageUrl
    }
    
    func connectedRisks() -> [RiskObjModel] {
        var risks = [RiskObjModel]()
        for risk in collection.getLoadedRisks() {
            let cards = collection.getAllCardsOfRisk(risk.key)
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
    func saveResult(_ answerIndex: Int) {
        var value: Int!
        var option: CardOptionObjModel!
        
        if cardOptions.count == 1 {
            value = answerIndex
            option = cardOptions.first
        }else {
            if answerIndex < 0 || answerIndex >= cardOptions.count {
                return
            }
            
            // different from the UI
            option = cardOptions[answerIndex]
            value = answerIndex
        }
        
        // data cached
        selectionResults.addUserCardInput(userCenter.currentGameTargetUser.Key(), cardKey: key, selectedMatchKey: option.matchKey, input: Float(value))
    }
    
    class func getMatchedImageUrlForCard(_ card: CardInfoObjModel) -> URL? {
        if var result = card.currentSelection() {
            if card.isJudgementCard() {
                result = 0
            }
            
            if let match = card.cardOptions[result].match {
                return match.imageUrl ?? URL(string: "palceholder")
            }
        }
        
        return nil
    }
    
    // set image
    func addMatchedImageOnImageView(_ imageView: UIImageView) {
        // check answer
        if currentPlayed() {
            // MARK: ---------- for judgement, the imageurl is not added for the 2nd option
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setIndicatorStyle(.gray)
            imageView.sd_setImage(with: currentImageUrl(), placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, progress: nil) { (image, error, type, url) in
                if image == nil {
                    imageView.image = ProjectImages.sharedImage.placeHolder
                }
            }
        }else {
            // no choice, not answered
            imageView.image = UIImage(named: "card_noChoice")
        }
    }
    
    // Input
    func saveInput(_ inputValue: Float, matchKey: String!) {
        // data cached
        selectionResults.addUserCardInput(userCenter.currentGameTargetUser.Key(), cardKey: key, selectedMatchKey: matchKey, input: inputValue)
    }
    
    func currentInput(_ matchKey: String) -> Float? {
        return selectionResults.getValueInputByUser(UserCenter.sharedCenter.currentGameTargetUser.Key(), cardKey: key, matchKey: matchKey)
    }
}

