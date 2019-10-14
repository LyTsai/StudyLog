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
 
    /* riskClass */
    var selectedRiskClassKey: String! {
        didSet{
            if selectedRiskClassKey != oldValue {
                // when risk class is changed, the risk should be changed too
                focusingRiskKey = nil
                chosenRiskClass = collection.getMetric(selectedRiskClassKey)
            }
        }
    }
    /** read only, changed by key */
    var selectedRiskClass: MetricObjModel! {
        return chosenRiskClass
    }
    fileprivate var chosenRiskClass: MetricObjModel!
    /*
     2. current card, be set when view shows(0 or -1 for default), user answers
     */
    // collection of risk factor cards currently attached for navigation ()
    fileprivate var riskDeckOfCards = [CardInfoObjModel]()
 
    // cursor of focusing metric index (within) metric cards by risk factors
    var focusingRiskCardIndex:Int = 0
    
    // risk model cursor position
    var focusingRiskKey: String! 
    
    // riskTypeKey
    var riskTypeKey: String!
    var focusingCategoryKey: String!
    
    var focusingRisk: RiskObjModel! {
        return collection.getRisk(focusingRiskKey)
    }

    ////////////////////////////////////////////////////////////
    // current selected specific model for each risk class
    // {riskMetricKey, riskKey}:
    // each risk is a metric by itself, there maybe more than one risk models for the same risk metric, for example, multiple versions of models for the same "Low Vitamin D risk" risk metric
    // this attribute keeps current selection of risk model for each risk metric.  the default is "System"
    var riskClass2Model:[String:String] = [String:String]()
    
    ////////////////////////////////////////////////////////////

    // call to set RiskObjModel for given riskClass
    // !!! if caller didn't set specific model for a given risk class then a default (out of box) model object will be used later in calls for focusing on risk class.  see selectedRisk function...
    func setRiskClassModel(_ riskModelKey: String) {
        // get riskModel object first
        if let risk = collection.getRisk(riskModelKey) {
            riskClass2Model[risk.metricKey!] = risk.key
        }
    }
    
    // get selected risk model for selected risk class.  return default selection if currently no model selected
    func selectedRisk(_ riskClassKey:String) -> String? {
        if focusingRisk == nil || focusingRisk.metricKey == nil {
            return focusingRiskKey
        }
        
        if focusingRisk.metricKey != riskClassKey {
            let allRisks = collection.getRiskModelKeys(riskClassKey, riskType: riskTypeKey)
            if allRisks.count != 0 {
                 focusingRiskKey = allRisks.first
            }
        }
        
        return focusingRiskKey
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
    
    
    // historyMap
    var comparisonRiskKey: String!
}

