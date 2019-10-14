//
//  GameTintApplication.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/2.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

enum AppTopic {
    case SlowAgingByDesign
    case AssessmentAppsBySubjectAreas
    case AssessmentAppsByThirdParty
    case VisualizerAppsBySubjectAreas
    case VisualizerAppsByThirdParty
    
    func getTopicKey() -> String? {
        let dataCenter = ApplicationDataCenter.sharedCenter
        switch self {
        case .SlowAgingByDesign:            return dataCenter.riskCategoryKey
        case .AssessmentAppsBySubjectAreas: return dataCenter.iaaasStandaloneKey
        case .AssessmentAppsByThirdParty:   return dataCenter.iaaaSThirdPartKey
        case .VisualizerAppsBySubjectAreas: return dataCenter.visualizerStandAloneKey
        case .VisualizerAppsByThirdParty:   return dataCenter.visualizerThirdPartyCategoryKey
        }
    }
}


class GameTintApplication {
    static let sharedTint = GameTintApplication()
    
    var appTopic = AppTopic.SlowAgingByDesign
    var focusingTierIndex = -1
    
    // riskTypeKeys
    var iCaKey = ""
    var iPaKey = ""
    var iAaKey = ""
    var iRaKey = ""
}


enum RiskTypeType: String {
    case undefined
    case iCa
    case iPa
    case iKa
    case iRa
    case iSa
    case iIa
    case iAa
    case iFa
    
    static func getTypeOfRiskType(_ riskTypeKey: String) -> RiskTypeType {
        if let riskType = collection.getRiskTypeByKey(riskTypeKey) {
            if let name = riskType.name?.lowercased() {
                if name.contains("ica comparsion") {
                    return RiskTypeType.iCa
                }else if name.contains("ipa prediction") {
                    return RiskTypeType.iPa
                }else if name.contains("ika knowledge") {
                    return RiskTypeType.iKa
                }else if name.contains("ira risk") {
                    return RiskTypeType.iRa
                }else if name.contains("isa symptoms") {
                    return RiskTypeType.iSa
                }else if name.contains("iia impact") {
                    return RiskTypeType.iIa
                }else if name.contains("iaa actions") {
                    return RiskTypeType.iAa
                }else if name.contains("ifa fulfillment"){
                    return .iFa
                }else {
                    return RiskTypeType.undefined
                }
            }
        }
        return RiskTypeType.undefined
    }
}


class CardViewImagesCenter {
    static let sharedCenter = CardViewImagesCenter()
    
    var symbol: String = "ira"

    var launchHintImage: UIImage! {
        return UIImage(named: "\(symbol)_launchHint")
    } // _launchHint
    

    var hintImage: UIImage! {
        return UIImage(named: "\(symbol)_hint")
    } // _hint
    

    var mainColor = tabTintGreen
    
    func setupImagesWithRiskType(_ Key: String) {
        symbol = "ira"
        
        if let riskType = collection.getRiskTypeByKey(Key) {
            if riskType.name != nil {
                if riskType.name!.localizedCaseInsensitiveContains("isa") {
                    symbol = "isa"
                }else if riskType.name!.localizedCaseInsensitiveContains("iia") {
                    symbol = "iia"
                }else if riskType.name!.localizedCaseInsensitiveContains("iaa") {
                    symbol = "iaa"
                }else if riskType.name!.localizedCaseInsensitiveContains("ika"){
                    symbol = "ika"
                }
                
                mainColor = riskType.realColor ?? tabTintGreen
            }
        }
    }
}
