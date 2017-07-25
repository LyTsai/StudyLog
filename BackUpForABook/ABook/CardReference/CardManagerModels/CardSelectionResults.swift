//
//  CardSelectionResults.swift
//  ABook_iPhone_V1
//
//  Created by hui wang on 12/7/16.
//  Copyright © 2016 LyTsai. All rights reserved.
//

import Foundation

// class for saving metric card answers (or measurements)
// each metric may have answer as result of card processing
enum CardState {
    case answered   // user provided an answer
    case predicted  // or we can derive an answer based on machine learning
    case saved      // value has been saved into local core data
    case ignored    // user refuse to answer
}

// single card processing (selection) result.  see comments in MeasurementObjModel for measurement details in general:

// MeasurementObjModel represents one unit of measurement performed by one user (collectUserKey) for one user (userKey).  Each measurement unit may include multiple values collected for various metrics (MeasurementValueObjModel).  This reflects the fact that often people perform multiple tasks as part of one unit of measurement.  one measurement = MeasurementObjModel + [MeasurementValueObjModel]
// On the other hand there maybe more than one person involved in performing the same measurement job: report = [MeasurementObjModel]

// !! measurement is taken (or prodicted) for each Metric
// for each measurement we record three three values: value (if apply), metricKey and matchKey

// one measurement
class MetricMeasurement {
    // indicate state
    var state : CardState = CardState.answered
    
    // measurement was done via this card (or inrernal machine learning prediction card)
    // match
    // cardKey and matchKey stored in CardOptionObjModel
    var selectedOption: CardOptionObjModel?
    // used when the numerical value is inputed for the card
    var optionValue: NSNumber?
}

// collection of cached card selection of all risk models for all users
class CardSelectionResults {
    // MARK: ---------- singleton
    static let cachedCardProcessingResults = CardSelectionResults()

    // MARK: ------------ new dictionary ----------------
    // the card processing data is organized as: [targetUserkey : [riskKey : [cardKey: Measurement] ] ]
    fileprivate var userCardResults = [String: [String: [String: MetricMeasurement]]]()
    
    // the card processing data is organized as: [targetUserkey : [metricKey:[riskKey, Measurement] ] ]
    fileprivate var userCardInputs = [String: [String: [String: MetricMeasurement]]]()
    /*
    // for accessing the REST api backend service
    var measurementAccess: MeasurementAccess?
    var measurements = [MeasurementObjModel]()
    var cursor = 0
    var size = 0
    */
    
    // functions to manipulate userCardInputs
    // add user card processing result:
    // cardTargetUser - for this user (user or pseudoUser)
    // metricKey - input for this metric
    // cardKey - as result of matching this card content (or processing this card options).  not used for now
    // riskKey - as result of palying this risk game
    // selection - matched to this card option
    // value - in case of value card this is the number pothat user inputed
    func addUserCardInput(_ cardTargetUser: CardTargetUser, metricKey: String, cardKey: String, riskKey: String, selection: CardOptionObjModel?, value: NSNumber?) {
        
//        // check if we already have the user collection
//        if userCardInputs[cardTargetUser.Key()] == nil {
//            userCardInputs[cardTargetUser.Key()] = [String: [String: MetricMeasurement]]()
//        }
//        
//        // add card selection
//        if userCardInputs[cardTargetUser.Key()]![metricKey] == nil {
//            userCardInputs[cardTargetUser.Key()]![metricKey] = [String: MetricMeasurement]()
//        }
        
        // add for the risk
        let measurement = MetricMeasurement()
        
        if (selection == nil && value == nil) {
            measurement.state = CardState.ignored
        }else {
            measurement.selectedOption = selection
            measurement.optionValue = value
            measurement.state = CardState.answered
        }
        

        //  if value is nil, also save
        if userCardResults[cardTargetUser.Key()] == nil {
            userCardResults[cardTargetUser.Key()] = [String: [String: MetricMeasurement]]()
        }
        
        if userCardResults[cardTargetUser.Key()]![riskKey] == nil {
            userCardResults[cardTargetUser.Key()]![riskKey] = [String: MetricMeasurement]()
        }
        
        userCardResults[cardTargetUser.Key()]![riskKey]![cardKey] = measurement
     
//        userCardInputs[cardTargetUser.Key()]![metricKey]![riskKey] = measurement
    }
    
    /*
    // save all for given target user.
    // steps: prepare measurementToSave first and then call REST api
    func saveTargetUserCardInputs(_ forUser: CardTargetUser) {
        
        if UserCenter.sharedCenter.userState != .login || UserCenter.sharedCenter.loginUserBackendAccess?.userKey == nil {
            // we only save the resutl for registered user
            return
        }
        
        // date and time
        let formatter = ISO8601DateFormatter()
        let date = Date()
        let dataZStr = formatter.string(from: date)
        let loginUser = UserCenter.sharedCenter.loginUserObj
        
        // data prepared for saving to the backend.  one MeasurementObjModel object per risk key, per user
        var risk2Values = [String: MeasurementObjModel]()
        
        // get answers for the given user
        if let metricList = userCardInputs[forUser.Key()] {
            // metricCardList has card of all metrics
            for (metricKey, metricMatches) in metricList {
                
                // metricCards has all cards for the given metric
                for (riskKey, measurement) in metricMatches {
                    if measurement.state == .saved || measurement.state == .ignored {
                        // no new value for this metric
                        continue
                    }
                    
                    // check to see if we have collection for this riskKey
                    let risk = AIDMetricCardsCollection.standardCollection.getRisk(riskKey)
                    
                    if risk2Values[riskKey] == nil {
                        let riskMeasurement = MeasurementObjModel()
                        riskMeasurement.key = UUID().uuidString
                        riskMeasurement.info = risk?.info
                        riskMeasurement.name = risk?.name
                        riskMeasurement.note = "NA"
                        riskMeasurement.time = date
                        riskMeasurement.timeZ = dataZStr
                        riskMeasurement.collectUserKey = loginUser.key
                        riskMeasurement.userKey = forUser.registertedUser?.key
                        riskMeasurement.pseudoUserKey = forUser.pseudoUser?.key
                        riskMeasurement.riskKey = riskKey
                        
                        risk2Values[riskKey] = riskMeasurement
                    }
                    
                    let oneValue = MeasurementValueObjModel()
                    
                    oneValue.value = measurement.optionValue?.doubleValue
                    oneValue.metricKey = metricKey
                    oneValue.matchKey = measurement.selectedOption?.matchKey
                    
                    risk2Values[riskKey]?.values.append(oneValue)
                }
            }
            // get it for given user.  save it
            
            // put into outgoing buffer
            measurements = Array(risk2Values.values)
            cursor = 0
            size = measurements.count
            
            if measurementAccess == nil {
                measurementAccess = MeasurementAccess(callback: self)
            }
            
            if size > 0 {
                measurementAccess?.beginApi(nil)
                measurementAccess?.addOne(oneData: measurements[cursor])
            }
        }
    }
    
    */
    // convert data in userCardInputs into MeasurementObjModel collections:
    // [userKey: [riskKey: MeasurementObjModel]]
    func getAllUserRiskMeasurements()->[String: [String: MeasurementObjModel]] {
        var allMeasuremnts = [String: [String: MeasurementObjModel]]()
        
        // date and time
        let formatter = ISO8601DateFormatter()
        let date = Date()
        let dataZStr = formatter.string(from: date)
        let loginUser = UserCenter.sharedCenter.loginUserObj
        
        // get answers for the given user
        for (userKey, metricList) in userCardInputs {
            // data prepared for saving to the backend.  one MeasurementObjModel object per risk key, per user
            var risk2Values = [String: MeasurementObjModel]()
            
            // metricCardList has card of all metrics
            for (metricKey, metricMatches) in metricList {
                
                // metricCards has all cards for the given metric
                for (riskKey, measurement) in metricMatches {
                    if measurement.state == CardState.ignored {
                        // no new value for this metric
                        continue
                    }
                    
                    // check to see if we have collection for this riskKey
                    let risk = AIDMetricCardsCollection.standardCollection.getRisk(riskKey)
                    if risk2Values[riskKey] == nil {
                        risk2Values[riskKey] = MeasurementObjModel()
                    }
                    
                    let riskMeasurement = risk2Values[riskKey]
                    
                    riskMeasurement!.key = UUID().uuidString
                    riskMeasurement!.info = risk?.info
                    riskMeasurement!.name = risk?.name
                    riskMeasurement!.note = "NA"
                    riskMeasurement!.time = date
                    riskMeasurement!.timeZ = dataZStr
                    riskMeasurement!.collectUserKey = loginUser.key
                    
                    // check if userKey is registered user or pseudoUser
                    if UserCenter.sharedCenter.pseudoUserList[userKey] != nil {
                        riskMeasurement!.pseudoUserKey = userKey
                        riskMeasurement!.pseudoUser = UserCenter.sharedCenter.pseudoUserList[userKey]
                    }else {
                        riskMeasurement!.userKey = userKey
                        riskMeasurement!.user = UserCenter.sharedCenter.registeredUserList[userKey]
                    }
                    
                    riskMeasurement!.riskKey = riskKey
                    riskMeasurement!.risk = risk
                    
                    riskMeasurement!.collectUser = loginUser
                
                    let oneValue = MeasurementValueObjModel()
                    
                    oneValue.value = measurement.optionValue?.doubleValue
                    
                    oneValue.metricKey = metricKey
                    oneValue.metric = AIDMetricCardsCollection.standardCollection.getMetric(metricKey)
                    
                    // MARK: ---------- may crash here, accidently.......
                    oneValue.matchKey = measurement.selectedOption?.matchKey
                    oneValue.match = AIDMetricCardsCollection.standardCollection.getMatch(oneValue.matchKey)
                    
                    risk2Values[riskKey]?.values.append(oneValue)
                }
            }
            // get it for given user.  save it
            
            // put into outgoing buffer
            allMeasuremnts[userKey] = risk2Values
        }
        
        return allMeasuremnts
    }
    
    // MARK: --------- get data by using userCardResults
    // userkey: riskKey: measurement
    func getAllUserRiskMeasurementsByCard()->[String: [String: MeasurementObjModel]] {
        var allMeasuremnts = [String: [String: MeasurementObjModel]]()
        
        // date and time
        let formatter = ISO8601DateFormatter()
        let date = Date()
        let dataZStr = formatter.string(from: date)
        let loginUser = UserCenter.sharedCenter.loginUserObj
    
        // get answers for the given user
        //  [targetUserkey : [riskKey : [cardKey: Measurement] ] ]
        for (userKey, cardList) in userCardResults {
            // data prepared for saving to the backend.  one MeasurementObjModel object per risk key, per user
            var risk2Values = [String: MeasurementObjModel]()
            
            // [riskKey : [cardKey: Measurement] ]
            for (riskKey, metricMatches) in cardList {
                let risk = AIDMetricCardsCollection.standardCollection.getRisk(riskKey)
                
                // check to see if we have collection for this riskKey
                if risk2Values[riskKey] == nil {
                    risk2Values[riskKey] = MeasurementObjModel()
                }
                
                let riskMeasurement = risk2Values[riskKey]
                riskMeasurement!.key = UUID().uuidString
                riskMeasurement!.info = risk?.info
                riskMeasurement!.name = risk?.name
                riskMeasurement!.note = "NA"
                riskMeasurement!.time = date
                riskMeasurement!.timeZ = dataZStr
                riskMeasurement!.collectUserKey = loginUser.key
                
                // check if userKey is registered user or pseudoUser
                if UserCenter.sharedCenter.pseudoUserList[userKey] != nil {
                    riskMeasurement!.pseudoUserKey = userKey
                    riskMeasurement!.pseudoUser = UserCenter.sharedCenter.pseudoUserList[userKey]
                }else {
                    riskMeasurement!.userKey = userKey
                    riskMeasurement!.user = UserCenter.sharedCenter.registeredUserList[userKey]
                }
                
                riskMeasurement!.riskKey = riskKey
                riskMeasurement!.risk = risk
                riskMeasurement!.collectUser = loginUser
                
                // [cardKey: Measurement]
                for (_, measurement) in metricMatches {
                    if measurement.state == CardState.answered {
                    
                        let oneValue = MeasurementValueObjModel()
                        oneValue.value = measurement.optionValue?.doubleValue
                        
                        oneValue.metricKey = AIDMetricCardsCollection.standardCollection.getRisk(riskKey)?.metricKey
                        oneValue.metric = AIDMetricCardsCollection.standardCollection.getMetric(oneValue.metricKey)
                        
                        if measurement.optionValue == nil {
                            print("wrong set up")
                            continue
                        }
                        
                        oneValue.matchKey = measurement.selectedOption?.matchKey
                        oneValue.match = AIDMetricCardsCollection.standardCollection.getMatch(oneValue.matchKey)
                        
                        risk2Values[riskKey]!.values.append(oneValue)
                    }
                }
            }
            
            // put into outgoing buffer
            allMeasuremnts[userKey] = risk2Values
        }
        
        return allMeasuremnts
    }
    /*
    // by results
    func saveTargetUserCardResults(_ forUser: CardTargetUser) {
        
        if UserCenter.sharedCenter.userState != .login || UserCenter.sharedCenter.loginUserBackendAccess?.userKey == nil {
            // we only save the resutl for registered user
            return
        }
        
        let allMeasurements = getAllUserRiskMeasurementsByCard()[forUser.Key()]
        
        if allMeasurements != nil {
            // put into outgoing buffer
            measurements = Array(allMeasurements!.values)
            cursor = 0
            size = measurements.count
            
            if measurementAccess == nil {
                measurementAccess = MeasurementAccess(callback: self)
            }
            
            if size > 0 {
                measurementAccess?.beginApi(nil)
                measurementAccess?.addOne(oneData: measurements[cursor])
            }
        }
     
    }
 */ 
    
    // mark risk data input as "saved" for the given user
    func markSavedUserRisk(_ targetUserKey: String, savedRiskKey: String) {
        if let metricList = userCardResults[targetUserKey] {
            for (_, metricMatches) in metricList {
                // metricCards has all cards for the given metric
                for (riskKey, measurement) in metricMatches {
                    if riskKey == savedRiskKey {
                        measurement.state = CardState.saved
                    }
                }
            }
        }
    }
 
    // return "game played" for given user
    func gamePlayed(_ userKey: String)->[RiskObjModel] {
        // go over userCardInputs list for given user and record all risk classes (as MetricObjModel)
        var playedRisks = [String : RiskObjModel]()
        
        if let metricList = userCardInputs[userKey] {
            // metricCardList has card of all metrics
            for (_, metricMatches) in metricList {
                // metricCards has all cards for the given metric
                for (riskKey, _) in metricMatches {
                    if playedRisks[riskKey] == nil {
                        playedRisks[riskKey] = AIDMetricCardsCollection.standardCollection.getRisk(riskKey)
                    }
                }
            }
        }
        
        return Array(playedRisks.values)
    }
    
    // remove user's meadurement from the list
    func removeUserCardInputs(_ targetUserKey: String) {
        userCardInputs[targetUserKey]?.removeAll()
    }
    
    // remove risk cards
    func removeRiskmodelCards(_ riskKey: String) {
        for userKey in userCardInputs.keys {
            userCardInputs[userKey]?[riskKey] = nil
        }
    }
    
    // !!! To Do, this one needs to be reworked later, use matchedCardsByGame for example
    // get all data of old selection
    func resultsOfCurrentPlay(_ forUser: CardTargetUser) -> [Int?] {
        var results = [Int?]()
        
        let cardsFactory = VDeckOfCardsFactory.metricDeckOfCards
        let riskKey = cardsFactory.riskKey
        let riskCardList = userCardResults[forUser.Key()]![riskKey]!
        
        for i in 0..<cardsFactory.totalNumberOfItems(){
            let cardKey = cardsFactory.getVCard(i)?.key
            if cardKey == nil {
                continue
            }
            let measurement = riskCardList[cardKey!]
            results.append(measurement?.optionValue as Int?)
        }
        
        return results
    }
    
    // return collection of [metricKey, MeasurementValue] match collection for the given risk game key
    func matchedCardsByGame(_ forUser: CardTargetUser, riskKey: String) -> [String : MetricMeasurement] {
        var results = [String : MetricMeasurement]()
        
        let metricList = userCardInputs[forUser.Key()]!
        
        // metricCardList has card of all metrics
        for (metricKey, metricMatches) in metricList {
            
            // metricCards has all cards for the given metric
            if let match = metricMatches[riskKey] {
                if match.state != CardState.ignored {
                    results[metricKey] = match
                }
            }
        }
        
        return results
    }
    
    // get full list of given target user
    func getCurrentUserSelections(_ forUser: CardTargetUser)->[String: [String: MetricMeasurement]]? {
        return userCardInputs[forUser.Key()]
    }
}

/*
// REST api access event handler
extension CardSelectionResults: DataAccessProtocal {
    
    func didFinishGetGraphByKey(_ obj: AnyObject) {
        
    }
    
    func failedGetDataByKey(_ error: String) {
        
        // show error messages.  !!! to do
        
    }
    
    func didFinishAddDataByKey(_ obj: AnyObject) {
        // MARK: ------- may break here ----------
        var userKey = measurements[cursor].userKey
        if userKey == nil {
            userKey = measurements[cursor].pseudoUserKey
        }
        
        markSavedUserRisk(userKey!, savedRiskKey: measurements[cursor].riskKey!)
        
        cursor = cursor + 1
        if cursor < measurements.count {
            measurementAccess?.addOne(oneData: measurements[cursor])
        }
    }
    
    func failedAddDataByKey(_ error: String) {
        
    }
}

 */
