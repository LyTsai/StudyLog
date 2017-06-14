//
//  LandingPage.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/1/10.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// if only the images are used, save the names
// if use text + image + shadow, etc, use a view
class LandingModel {
    // tire two has fixed sequence
    var tireTwo: [(imageName: String, metricKey: String)] = [("HeartAge", ""), ("BrainAge", ""), ("FacialAge", ""), ("MuscleAge", "")]
    var tireThree = [String: UIImage?]()
    var surroundings = [String: UIImage?]()

    // get tire's detail with Models
    func reloadDataForLanding() {
        tireThree.removeAll()
        surroundings.removeAll()
        
        let collection = AIDMetricCardsCollection.standardCollection
        for riskClass in collection.getRiskClasses() {
        
            if riskClass.name.localizedCaseInsensitiveContains("age") {
                // tireTwo
                if riskClass.name.localizedCaseInsensitiveContains("skin") {
                    tireTwo[2].metricKey = riskClass.key
                }else if riskClass.name.localizedCaseInsensitiveContains("brain") {
                    tireTwo[1].metricKey = riskClass.key
                }else if riskClass.name.localizedCaseInsensitiveContains("muscle") {
                    tireTwo[3].metricKey = riskClass.key
                }else {
                    // 10-year, it is called
                    tireTwo[0].metricKey = riskClass.key
                }
            } else {
                tireThree[riskClass.key] = riskClass.imageObj
            }
        }
        
        // TODO: ----------- no data for keys -----------
//        for key in collection.getMetrics() {
//            let metric = collection.getMetric(key)
//            if metric == nil {
//                continue
//            }
//            surroundings[key] = metric!.imageObj
//        }
    }
}

// to keep key as a property, not use tag any more
class RiskClassButton: UIButton {
    var riskClassKey: String!
    var riskClassImage: UIImage! {
        didSet{
            setBackgroundImage(riskClassImage, for: .normal)
            imageView?.contentMode = .scaleAspectFit
        }
    }
}
