//
//  MatchedCardsData.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/17.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import ABookData
import CoreData

// extension of model
extension MeasurementModel {
    // number
    class func getNumberOfRiskClass(_ metricKey: String, ofPersonId: String) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ANMEASUREMENT)
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "withRiskCalculator.ofMetric.key = %@ && ofPerson.id = %@", metricKey,ofPersonId)
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .countResultType
        
        let context = DbUtil.manager.context
        
        var resultArray = [AnyObject]()
        do {
            resultArray = try context.fetch(fetchRequest)
        } catch let error as NSError{
            print("Error is \(error)")
        }
        let number = resultArray.first as! NSNumber
        
        return number.intValue
    }

    class func getNumberOfRiskClass(_ metricKey: String, ofPseudoUserName: String) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ANMEASUREMENT)
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "withRiskCalculator.ofMetric.key = %@ && ofPseudoUser.name = %@", metricKey,ofPseudoUserName)
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .countResultType
        
        let context = DbUtil.manager.context
        
        var resultArray = [AnyObject]()
        do {
            resultArray = try context.fetch(fetchRequest)
        } catch let error as NSError{
            print("Error is \(error)")
        }
        let number = resultArray.first as! NSNumber
        
        return number.intValue
    }
    
    
    // existence
    class func checkExistenceOfRiskClass(_ metricKey: String, ofPersonId: String) -> Bool {
        
        let number = MeasurementModel.getNumberOfRiskClass(metricKey, ofPersonId: ofPersonId)
        
        if number != 0 {
            return true
        }else{
            return false
        }
    }
    
    class func checkExistenceOfRiskClass(_ metricKey: String, ofPseudoUserName: String) -> Bool {
        
        let number = MeasurementModel.getNumberOfRiskClass(metricKey, ofPseudoUserName: ofPseudoUserName)
        
        if number != 0 {
            return true
        }else{
            return false
        }
    }
}


// Data accesss
class MatchedCardsData {
    class func getAllRisksPlayedOfUser(_ userKey: String) -> [RiskObjModel] {
        let allMeasurements = CardSelectionResults.cachedCardProcessingResults.getAllUserRiskMeasurements()
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
        let allMeasurements = CardSelectionResults.cachedCardProcessingResults.getAllUserRiskMeasurements()
        return allMeasurements[userKey]?[riskKey]
    }
    
    
    class func getAllRisksPlayedOfPseudoUser() {
        
    }
    

}









