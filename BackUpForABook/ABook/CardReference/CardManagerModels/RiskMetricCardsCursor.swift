//
//  RiskMetricCardsCursor.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/28.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

// navigation cursor over risk model object collection: cursor = {riskClass, RiskObjModel}
// where riskClass position is against riskClass collection in attached AIDMetricCardsCollection.standardCollection and RiskObjModel is set via setRiskClassModel for each risk class
// to use this class: 
// (1) build GUI on top of attached riskClasses (by calling numberOfRiskClasses)
// (2) display algorithm options for each riskClass via AIDMetricCardsCollection.standardCollection.getModelsOfRiskClass
// (3) call setRiskClassModel once user select a specific risk model
// (4) call focusOnRiskClass on user's risk class selection
//  !!! the above logics implies following flow:
// (1) show user list of riskClasses
// (2) user selects a riskClass
// (3) show all RiskObjModel objects for selected riskClass
// (4) user select a risk model object
// (5) setRiskClassModel is called to set RiskObjModel for riskClass in cursor
// (6) move cursor position to {riskClass, RiskObjModel} for attaching all risk factors
class RiskMetricCardsCursor {
    // singleton to keep data
    static let sharedCursor = RiskMetricCardsCursor()
    
    // reference to data source
    fileprivate var collection = AIDMetricCardsCollection.standardCollection
    
    /* riskClass  */
    var selectedRiskClassKey: String! {
        didSet{
            if selectedRiskClassKey != oldValue {
                var exist = false
                
                for riskClass in collection.getRiskClasses() {
                    if riskClass.key == selectedRiskClassKey {
                        selectedRiskClass = riskClass
                        exist = true
                        break
                    }
                }
                
                if !exist {
                    selectedRiskClass = nil
                }
            }
        }
    }
    /** please set key !!!!*/
    var selectedRiskClass: MetricObjModel!
    
    /*
     2. current card, be set when view shows(0 or -1 for default), user answers
     */
    // collection of risk factor cards currently attached for navigation ()
    var riskDeckOfCards = [CardInfoObjModel]()
    // cursor of focusing metric index (within) metric cards by risk factors
    var focusingRiskCardIndex:Int = 0
    
    // risk model cursor position
    var focusingRiskKey: String! {
        didSet{
            if focusingRiskKey != oldValue {
                // setup focusing risk
                focusingRisk = collection.getRisk(focusingRiskKey)
            }
        }
    }
    
    var focusingRisk: RiskObjModel!
    
    ////////////////////////////////////////////////////////////
    // current selected specific model for each risk class
    // {riskMetricKey, riskKey}:
    // each risk is a metric by itself, there maybe more than one risk models for the same risk metric, for example, multiple versions of models for the same "Low Vitamin D risk" risk metric
    // this attribute keeps current selection of risk model for each risk metric.  the default is "System"
    var riskClass2Model:[String:String] = [String:String]()
    
    ////////////////////////////////////////////////////////////
    
    // returns number of
    var numberOfRiskClasses: Int {
        return collection.getRiskClasses().count
    }
    
    // map of cards type for each risk class (!!! not specific rsik model)
    // Here to set your default view map for each risk class
    var cardsViewTypeDictionary: [String: CardsViewType]{
        let allRiskClassKeys = collection.getRiskClasseKeys()
        var dictionary = [String: CardsViewType]()
        
        // special system Risk class keys
        let lifeStyleKey = "b63aef88-9c76-11e6-80f5-76304dec7eb7"
        let lowVitDKey = "2d7523b2-b96d-11e6-a4a6-cec0c932ce01"
        let brainAgeKey = "58b0b3c0-9c76-11e6-80f5-76304dec7eb7"
        
        for riskClassKey in allRiskClassKeys {
            if riskClassKey == lifeStyleKey {
                //dictionary[riskClassKey] = CardsViewType.VerticalFlow
                //dictionary[riskClassKey] = CardsViewType.WheelOfCards
                dictionary[riskClassKey] = CardsViewType.StackView
            }else if riskClassKey == lowVitDKey {
                dictionary[riskClassKey] = CardsViewType.StackView
            }else if riskClassKey == brainAgeKey{
                dictionary[riskClassKey] = CardsViewType.StackView
            }else {
                dictionary[riskClassKey] = CardsViewType.StackView
            }
        }
        return dictionary
    }
    
    // call to set RiskObjModel for given riskClass
    // !!! if caller didn't set specific model for a given risk class then a default (out of box) model object will be used later in calls for focusing on risk class.  see selectedRisk function...
    func setRiskClassModel(_ riskModelKey: String) {
        // get riskModel object first
        if let risk = collection.getRisk(riskModelKey) {
            riskClass2Model[risk.metricKey!] = risk.key
        }
    }
    
    // check risk model object for given class
    func checkRiskObject(_ riskKey: String) -> Bool {
        let risk = AIDMetricCardsCollection.standardCollection.getRisk(riskKey)
        if risk == nil || (risk?.riskFactors.isEmpty)! {
            return false
        }
        
        return true
    }
    
    // get selected risk model for selected risk class.  return default selection if currently no model selected
    func selectedRisk(_ riskClassKey:String)->String? {
        if focusingRisk.metricKey != riskClassKey {
            focusingRiskKey = collection.getRiskModelKeys(riskClassKey)?.first
        }
        
        return focusingRiskKey
    }
    
    // move cursor position to {riskClass, RiskObjModel}
    // riskMetricKey - riskMetric class to be focused on
    // returns: risk model key of focusing risk model
    func focusOnRiskClass(_ riskMetricKey: String)-> String {
        if selectedRisk(riskMetricKey) != nil {
            // attache to card collection of riskKey
            riskDeckOfCards = collection.getMetricCardOfRisk(focusingRiskKey)
            
            // set focusingRiskCardIndex: metric index of first metric whose value is not set
            focusingRiskCardIndex = 0
            
            // [metricKey, [risk, measurement]]
            let metricMeasurements = CardSelectionResults.cachedCardProcessingResults.getCurrentUserSelections(UserCenter.sharedCenter.currentGameTargetUser)
            
            // stop at the very first unprocessed card
            for card in riskDeckOfCards {
                // over all cards
                let measurements = metricMeasurements?[card.metricKey!]
                if measurements != nil {
                    // processed already
                    focusingRiskCardIndex += 1
                }
            }
            if focusingRiskCardIndex == riskDeckOfCards.count {
                // this deck of cards has been all processed already.  point to the last on
                focusingRiskCardIndex = riskDeckOfCards.count - 1
            }
        }
        
        return focusingRiskKey
    }
    
    // return current focusing risk model key
    func currentFocusingRisk()->String? {
        return focusingRiskKey
    }
    
    // cards related
    // check to see if we are at end of the list of risk factor metrics
    func atTheEnd()->Bool {
        return focusingRiskCardIndex == (riskDeckOfCards.count - 1)
    }

    
    // move metric cursor focusingRiskCardIndex forward.  return true if is valid move
    func moveMetricCursorForward()->Bool {
        if (focusingRiskCardIndex == (riskDeckOfCards.count - 1)) {
            return false
        }
        focusingRiskCardIndex += 1
        
        return true
    }
    
    // move metric cursor focusingRiskCardIndex backward.  return true if is valid move
    func moveMetricCursorBackward()->Bool {
        if (focusingRiskCardIndex == 0) {
            return false
        }
        focusingRiskCardIndex -= 1
        return true
    }
    
    // return current risk model card collection
    func getFocusingRiskMetricDeckOfCardsCollection()->[CardInfoObjModel]{
        return riskDeckOfCards
    }
    
    func getRiskClassCardsViewType(_ riskClass: String) -> CardsViewType {
        return cardsViewTypeDictionary[riskClass] ?? .WheelOfCards
    }
}

