//
//  VCardTemplate.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/10/12.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// Actually card factory
class CardTemplateManager {
    // singleton, as single temp
    static let sharedManager = CardTemplateManager()
    
    // key of default card style
    static let defaultCardStyleKey = "3ca72cc2-9aeb-11e6-9f33-a24fc0d9649c"
    
    // MARK: ---------------- no singleton, factory method, so can be added as many views
    func createCardTemplateWithKey(_ key: String!, frame: CGRect) -> CardTemplateView{
        
        // try with embeded card templates first
        // "match card"
        if key == JudgementCardTemplateView.styleKey(){
            return JudgementCardTemplateView(frame: frame)
        }
        
        if key == MeJudgementCardTemplateView.styleKey(){
            return MeJudgementCardTemplateView(frame: frame)
        }

        // "select spinning wheel"
        // MARK:--------- use key for test
//        if key == SetOfCardsCardTemplateView.styleKey(){
//            
//            let random = arc4random() % 2
//            if random == 0 {
//                return SpinningMultipleChoiceCardsTemplateView(frame: frame)
//            }
//            
//            return SetOfCardsCardTemplateView.createWithFrame(frame)
//        }
        
        if key == SpinningMultipleChoiceCardsTemplateView.styleKey(){
            return SpinningMultipleChoiceCardsTemplateView(frame: frame)
        }

        // "select"
        if key == SelectCardTemplateView.styleKey() {
            return SelectCardTemplateView(frame: frame)
        }
        
        /* !!! Hui To Do: get the json document from backend CardStyle entity via REST api
        // then try with external defined card template by json document
        if let jsonDoc = CardStyleModel.getCardStyleInCoreDataByKey(key)?.jsonDoc{
            return JsonCardTemplateView(frame: frame, jsonDoc: jsonDoc)
        }
        */
        
        // try with BasicCardTemplatesView first
        var cardTemplate = BasicCardTemplatesView().createCardTemplateView(key)
        
        if (cardTemplate == nil) {
            //cardTemplate = SpinningMultipleChoicesView()
            cardTemplate = JudgementCardTemplateView(frame: frame)
        }
        
        // use JudgementCardTemplateView as default
        return cardTemplate!
    }
}
