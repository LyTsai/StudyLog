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
    
    var instanceKey: String?
    
    // {userKey, {riskKey, bool}} indicates if riksKey for userKey is loaded from backend or not
    fileprivate var accessRecord = [String: [String: Bool]]()
    // {userKey, {riskKey, bool}} indicates if we have risk data for user loaded currently
    fileprivate var localRecord = [String: [String: Bool]]()
    
    // all measurement {key, Measurement}
    fileprivate var key2Measurement = [String: MeasurementObjModel]()
    // [userKey: [cardKey: MeasurementValue]]]
    fileprivate var userCardResults = [String: [String: MeasurementValueObjModel]]()
    // [userKey: [riskKey: fulfillments]]
    fileprivate var userFulfillments = [String: [String: [FulfilledActionMatchObjModel]]]()
    
    // MARK: ----------- record of last play -------------------
    // {userKey, {riskKey, measurementKey}}
    fileprivate var lastRecord = [String: [String: String]]()
    // {userKey, {riskKey, MeasurementObjModelKey}}
    fileprivate var lastWhatIfRecord = [String: [String: String]]()
   
    // Load
    func measurementLoadedFromBackendForUser(_ userKey: String, riskKey: String) -> Bool {
        return accessRecord[userKey]?[riskKey] ?? false
    }
    func loadMeasurementFromBackend(_ measurement: MeasurementObjModel) {
        if !validMeasurement(measurement) {
            return
        }
        
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
        
        if localDB.database.open() {
            measurement.saveToLocalDatabase()
            localDB.database.close()
        }
    }

    // get data for treeRingMap
    func getAllBaselineMeasuremes() -> [MeasurementObjModel] {
        var baseline = [MeasurementObjModel]()
        for measurement in Array(key2Measurement.values) {
            // in case of multiple accounts
            if measurement.whatIfFlag == 0 && measurement.collectUserKey == userCenter.loginKey {
                baseline.append(measurement)
            }
        }
        
        return baseline
    }
    
    // select tables
    func getPlayersInMeasurements(_ measurements: [MeasurementObjModel]) -> [String] {
        var players = Set<String>()
        for measurement in measurements {
            players.insert(measurement.playerKey)
        }
        return players.sorted()
    }
    
    func getRisksInMeasurements(_ measurements: [MeasurementObjModel]) -> [String] {
        var allRiskKeys = Set<String>()
        for measurement in measurements {
            allRiskKeys.insert(measurement.riskKey!)
        }
        
        return allRiskKeys.sorted()
    }
    
    func getDayTimeStringsInMeasurements(_ measurements: [MeasurementObjModel]) -> [String] {
        var times = Set<String>()
        for measurement in measurements {
            times.insert(measurement.timeString[0..<10])
        }
        
        return times.sorted()
    }
    
    /* filtering by players with ordering
    // remained measurements
    func filterWithPlayers(_ players: [String], inMeasurements measurements: [MeasurementObjModel]) -> [MeasurementObjModel] {
        var remained = [MeasurementObjModel]()
        for measurement in measurements {
            if players.contains(measurement.playerKey) {
                remained.append(measurement)
            }
        }
        
        return remained
    }
    */
    
    func filterWithPlayers(_ players: [String], inMeasurements measurements: [MeasurementObjModel]) -> [MeasurementObjModel] {
        var remained = [MeasurementObjModel]()
        for player in players {
            for measurement in measurements {
                if player == measurement.playerKey {
                    remained.append(measurement)
                }
            }
        }
        return remained
    }
    
    func filterWithRisks(_ risks: [String], inMeasurements measurements: [MeasurementObjModel]) -> [MeasurementObjModel] {
        var remained = [MeasurementObjModel]()
        for measurement in measurements {
            if risks.contains(measurement.riskKey!) {
                remained.append(measurement)
            }
        }
        
        return remained
    }
    
    func filterWithDayTimes(_ times: [String], inMeasurements measurements: [MeasurementObjModel]) -> [MeasurementObjModel] {
        var remained = [MeasurementObjModel]()
        for measurement in measurements {
            if times.contains(measurement.timeString[0..<10]) {
                remained.append(measurement)
            }
        }
        
        return remained
    }
    
    // For History Map
    // get all measurements for given user
    func getAllBaselineMeasurementsForUser(_ userKey: String) -> [MeasurementObjModel] {
        var all = [MeasurementObjModel]()
        for measurement in Array(key2Measurement.values) {
            if measurement.whatIfFlag == 0 && measurement.playerKey == userKey {
                all.append(measurement)
            }
        }
        
        return all
    }
    
    func getAllBaselineMeasurementsOfRiskTypeForUser(_ userKey: String, riskType: String) -> [MeasurementObjModel]  {
        var all = [MeasurementObjModel]()
        for measurement in Array(key2Measurement.values) {
            if measurement.whatIfFlag == 0 && measurement.playerKey == userKey {
                if let typeKey = collection.getRisk(measurement.riskKey).riskTypeKey {
                    if typeKey == riskType {
                        all.append(measurement)
                    }
                }
            }
        }
        
        return all
    }
    
    func getAllBaselineMeasurementsOfRiskClassForUser(_ userKey: String, riskClass: String) -> [MeasurementObjModel]  {
        var all = [MeasurementObjModel]()
        for measurement in Array(key2Measurement.values) {
            if measurement.whatIfFlag == 0 && measurement.playerKey == userKey {
                if let metricKey = collection.getRisk(measurement.riskKey)?.metricKey {
                    if metricKey == riskClass {
                        all.append(measurement)
                    }
                }
            }
        }
        
        return all
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
                        
                        saveAsLastRecord(measurement)
                    }
                }
                localDB.database.close()
            }
        }
    }
    
    func getAllLocalFulfillsForUser(_ userKey: String, metricKey: String) -> [FulfilledActionMatchObjModel] {
        var fulfills = [FulfilledActionMatchObjModel]()
        if localDB.database.open() {
            let isUser = (userKey == userCenter.loginKey)
            let fulfillDics = localDB.getModelDicsWithCondition(["MetricKey" : metricKey, (isUser ? "UserKey" : "PseudoUserKey") : userKey], inTable: FulfilledActionMatchObjModel.tableName)
            for one in fulfillDics {
                if let fulfill = FulfilledActionMatchObjModel.fromSqliteDicToModel(one) {
                    fulfills.append(fulfill)
                }
            }
            
            localDB.database.close()
        }
        
        return fulfills
    }
    
    // treeRingMap
    // select all risk measurements from key2Measurement collection
    func getLoadedMeasurementsOfUser(_ userKey: String, riskKey: String) -> [MeasurementObjModel] {
        var measurements = [MeasurementObjModel]()
        for measurement in key2Measurement.values {
            if measurement.playerKey == userKey && measurement.riskKey == riskKey  && measurement.whatIfFlag == 0 {
                measurements.append(measurement)
            }
        }
        return measurements
    }
    
    
    func getMeasurementsOfRisk(_ riskKey: String) -> [MeasurementObjModel] {
        var measurements = [MeasurementObjModel]()
        for measurement in key2Measurement.values {
            if measurement.riskKey == riskKey && measurement.whatIfFlag == 0 {
                measurements.append(measurement)
            }
        }
        return measurements
    }
    
    // by risk type
    func getMeasurmentsWithDateStringByRiskType(_ dateString: String, ofType: String) -> [MeasurementObjModel] {
        var measurements = [MeasurementObjModel]()
        for measurement in key2Measurement.values {
            if measurement.timeString.contains(dateString) && measurement.whatIfFlag == 0 {
                if let riskTypeKey = collection.getRisk(measurement.riskKey!).riskTypeKey {
                    if riskTypeKey == ofType {
                        measurements.append(measurement)
                    }
                }
            }
        }
        return measurements
    }
    
    // by risk class
    func getMeasurmentsWithDateStringByRiskClass(_ dateString: String, ofClass: String) -> [MeasurementObjModel] {
        var measurements = [MeasurementObjModel]()
        for measurement in key2Measurement.values {
            if measurement.timeString.contains(dateString) && measurement.whatIfFlag == 0 {
                if let riskClassKey = collection.getRisk(measurement.riskKey!)?.metricKey {
                    if riskClassKey == ofClass {
                        measurements.append(measurement)
                    }
                }
            }
        }
        return measurements
    }
    
    func getMeasurmentsWithDateString(_ dateString: String, ofRisk riskKey: String) -> [MeasurementObjModel] {
        var measurements = [MeasurementObjModel]()
        for measurement in key2Measurement.values {
            if measurement.timeString.contains(dateString) && measurement.riskKey == riskKey && measurement.whatIfFlag == 0 {
                measurements.append(measurement)
            }
        }
        return measurements
    }
    
    func getMeasurementByKey(_ key: String!) -> MeasurementObjModel! {
        if key == nil {
            return nil
        }
        
        return key2Measurement[key.lowercased()]
    }
    
    // Last record
    func saveAsLastRecord(_ measurement: MeasurementObjModel) {
        // expired or not
        // check expired measurment
        if !validMeasurement(measurement) {
            // delete if necessary
            
            print("expired measurement: \(measurement.key!)")
            return
        }
        
        key2Measurement[measurement.key.lowercased()] = measurement
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
    
    func validMeasurement(_ measurement: MeasurementObjModel) -> Bool {
        if let risk = collection.getRisk(measurement.riskKey!) {
            for value in measurement.values {
                for factor in risk.riskFactors {
                    if let card = factor.card {
                        if card.metricKey == value.metricKey {
                            if collection.matchExistInCard(card.key, matchKey: value.matchKey) {
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        // all the value is wrong
        
        return false
    }
    
    func getLastMeasurementOfUser(_ userKey: String, riskKey: String, whatIf: Bool) -> MeasurementObjModel? {
        if whatIf {
            return getMeasurementByKey(lastWhatIfRecord[userKey]?[riskKey])
        }
        return getMeasurementByKey(lastRecord[userKey]?[riskKey])
    }
    
    // cacheData
    func useMeasurementForDisplay(_ measurement: MeasurementObjModel!)  {
        if measurement != nil {
            let userKey = measurement.playerKey!
            for value in measurement.values {
                if let vCard = collection.getCardOfMetric(value.metricKey, matchKey: value.matchKey, inRisk: measurement.riskKey!) {
                    addUserCardInput(userKey, cardKey: vCard.key, metricKey: vCard.metricKey, selectedMatchKey: value.matchKey, input: value.value, refValue: value.refValue)
                }else {
                    print("Data is changed, card does not exist in this risk")
                }
            }
        }
    }

    func useLastMeasurementForUser(_ userKey: String, riskKey: String, whatIf: Bool) {
        if let measurement = getLastMeasurementOfUser(userKey, riskKey: riskKey, whatIf: whatIf) {
            useMeasurementForDisplay(measurement)
        }
    }

    // functions to manipulate userCardInputs
    // add user card processing result:
    // userKey - for this user (user or pseudoUser)
    // cardKey - as result of matching this card content (or processing this card options).  not used for now
    // metricKey - matched card metric (card.metric)
    // selectedMatchKey - matched to this card option
    // value - in case of value card this is the number user inputed
    // MARK: ------------------ adding -------------------------------
    func addUserCardInput(_ userKey: String, cardKey: String, metricKey: String?, selectedMatchKey: String?, input: Float?, refValue: Float?) {
        // no answer
        if (selectedMatchKey == nil) {
            return
        }
    
        // add for the risk
        let measurementValue = MeasurementValueObjModel()
        measurementValue.metricKey = metricKey
        measurementValue.matchKey = selectedMatchKey
        measurementValue.value = input
        measurementValue.refValue = refValue
        
        //  not saved before
        // for the unique answer, [targetUserkey: [cardKey: Measurement]]
        if userCardResults[userKey] == nil {
            userCardResults[userKey] = [cardKey: measurementValue]
        }else {
            userCardResults[userKey]![cardKey] = measurementValue
        }
    }
    
    // MARK: ------------------ deleting -------------------------------
    func deleteInputForUser(_ userKey: String, cardKey: String) {
        userCardResults[userKey]?[cardKey] = nil
    }
    
    // remove user's matches saved in the memory
    func clearAnswerForUser(_ userKey: String, riskKey: String) {
        let cards = collection.getAllDisplayCardsOfRisk(riskKey)
        for card in cards {
            deleteInputForUser(userKey, cardKey: card.key)
        }
    }
    
    // remove user's matches saved in the memory
    func clearAnswerForUser(_ userKey: String, riskKey: String, categoryKey: String) {
        if let cards = collection.getCategoryToCardsOfRiskKeyEx(riskKey)[categoryKey] {
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
        if let cards = collection.getCategoryToCardsOfRiskKeyEx(riskKey)[categoryKey] {
            for card in cards {
                if userCardResults[userKey]![card.key] != nil {
                    played.append(card)
                }
            }
        }
        
        return played
    }
    
    // get cardKey for given metricKey
    func getCardKeyOf(_ userKey: String, metricKey: String) -> String? {
        if let result = userCardResults[userKey] {
            for (cardKey, value) in result {
                if value.metricKey == metricKey {
                return cardKey
                }
            }
        }
        
        return nil
    }
    
    // numbers
    func getNumberOfCardsPlayedForUser(_ userKey: String, riskKey: String, categoryKey: String) -> Int {
        return getCardsPlayedForUser(userKey, riskKey: riskKey, categoryKey: categoryKey).count
    }
    

    // selections and inputs
    func getMatchChosenByUser(_ userKey: String, cardKey: String) -> MatchObjModel! {
        if let value = userCardResults[userKey]?[cardKey] {
            if let card = collection.getCard(cardKey) {
                if !card.isInputCard() {
                    return collection.getMatch(value.matchKey)
                }else {
                    let displayOptions = card.getDisplayOptionsForUser(userKey)
                    return displayOptions.first!.match
                }
            }
        }
        
        return nil
    }
    func getValueInputByUser(_ userKey: String, cardKey: String) -> Float? {
        if let value = userCardResults[userKey]?[cardKey] {
            return value.value
        }
        
        return nil
    }
    func getRefValueInputByUser(_ userKey: String, cardKey: String) -> Float? {
        if let value = userCardResults[userKey]?[cardKey] {
            return value.refValue
        }
        
        return nil
    }
    
    // chosen index, if not fit for current selection(display options), take as un chosen
    func getChosenIndexByUser(_ userKey: String, cardKey: String) -> Int! {
        if let value = userCardResults[userKey]?[cardKey] {
            if let card = collection.getCard(cardKey) {
                if card.isInputCard() {
                    return 0
                }
                
                let displayOptions = card.getDisplayOptionsForUser(userKey)
                // normal
                for (i, option) in displayOptions.enumerated() {
                    if value.matchKey == option.matchKey {
                        return i
                    }
                }
                
                // chained
                for (i, option) in displayOptions.enumerated() {
                    if let chainedKey = option.match?.classification?.chainedCardKey {
                        if let chained = collection.getCard(chainedKey) {
                            for option in chained.getDisplayOptionsForUser(userKey){
                                if option.matchKey == value.matchKey {
                                    return i
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return nil
    }

    func getChosenChainCardIndexByUser(_ userKey: String, cardKey: String) -> Int! {
        if let value = userCardResults[userKey]?[cardKey] {
            if let card = collection.getCard(cardKey) {
               // chained
                for option in card.getDisplayOptionsForUser(userKey) {
                    if let classification = option.match?.classification {
                        if let chainedKey = classification.chainedCardKey {
                            if let chained = collection.getCard(chainedKey) {
                                for (i, option) in chained.getDisplayOptionsForUser(userKey).enumerated() {
                                    if option.matchKey == value.matchKey {
                                        return i
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return nil
    }

    func getSavedMatchByUser(_ userKey: String, cardKey: String) -> String? {
        return userCardResults[userKey]?[cardKey]?.matchKey
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
        let cards = collection.getAllDisplayCardsOfRisk(riskKey)
        let cardList = userCardResults[userKey]!
        
        // only keys are saved, others(objModels) are nil
        riskMeasurement.key = UUID().uuidString.lowercased()
        
        if riskKey == facialRejuvennationKey {
            if selectionResults.instanceKey != nil {
                riskMeasurement.instanceKey = selectionResults.instanceKey
            }else {
                riskMeasurement.instanceKey = UUID().uuidString.lowercased()
            }
        }
        
        riskMeasurement.name = risk?.name
        riskMeasurement.note = "NA"
        riskMeasurement.time = date
        riskMeasurement.timeString = dataZStr
        riskMeasurement.collectUserKey = loginUser.key
                
        // check if userKey is registered user or pseudoUser
        if userCenter.getPseudoUser(userKey) != nil {
            riskMeasurement.pseudoUserKey = userKey
        }else {
            riskMeasurement.userKey = userKey
        }
                
        riskMeasurement.riskKey = riskKey
                
        // [cardKey: Measurement]
        for card in cards {
            if let measure = cardList[card.key] {
                measure.metric = collection.getMetric(measure.metricKey)
                measure.match = collection.getMatch(measure.matchKey)
                riskMeasurement.values.append(measure)
            }
        }
        
        return riskMeasurement
    }
    
    // ifa 
    func getFulfillFromMeasurement(_ measurement: MeasurementObjModel) -> [FulfilledActionMatchObjModel] {
        var fulfills = [FulfilledActionMatchObjModel]()
        if let risk = collection.getRisk(measurement.riskKey) {
            if RiskTypeType.getTypeOfRiskType(risk.riskTypeKey!) == .iAa {
                for value in measurement.values {
                    if let match = collection.getMatch(value.matchKey!) {
                        // Plan to do now
                        if match.classificationKey == iAaPlanToDoClassificationKey {
                            let fulfill = FulfilledActionMatchObjModel()
                            fulfill.metricKey = risk.metricKey
                            fulfill.matchKey = value.matchKey
                            fulfill.userKey = measurement.userKey // nil for pseudoUser
                            fulfill.pseudoUserKey = measurement.pseudoUserKey
                            
                            // time
                            let formatter = ISO8601DateFormatter()
                            fulfill.time = Date()
                            fulfill.timeString = formatter.string(from: fulfill.time)
                            
                            fulfills.append(fulfill)
                        }
                    }
                }
            }
        }
        return fulfills
    }
    
    // save for each time iAa is played
    func saveFulfillments(_ fulfillments: [FulfilledActionMatchObjModel], forUser userKey: String) {
        if let loginUserKey = userCenter.loginKey {
            let isUser = (userKey == loginUserKey)
            for fulfillment in fulfillments {
                if (isUser && fulfillment.userKey != nil && fulfillment.userKey == userKey) || (!isUser && fulfillment.pseudoUserKey != nil && fulfillment.pseudoUserKey == userKey) {
                    // save for the
                }
            }
        }

    }
    
    func changeForUpload(_ measurement: MeasurementObjModel) -> MeasurementObjModel {
        let upload = MeasurementObjModel()
        upload.key = measurement.key
        upload.info = measurement.info
        upload.name = measurement.name
        upload.note = measurement.note
        upload.time = measurement.time
        upload.timeString = measurement.timeString
        upload.collectUserKey = measurement.collectUserKey
        
        upload.userKey = measurement.userKey
        upload.pseudoUserKey = measurement.pseudoUserKey
        upload.riskKey = measurement.riskKey
        
        // values
        var values = [MeasurementValueObjModel]()
        for value in measurement.values {
            let oneValue = MeasurementValueObjModel()
            oneValue.matchKey = value.matchKey
            oneValue.metricKey = value.metricKey
            oneValue.value = value.value
            oneValue.refValue = value.refValue
            values.append(oneValue)
        }
        upload.values = values
        
        return upload
    }
}
