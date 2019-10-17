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
    static let defaultCardStyleKey = judgementCardTemplateStyleTypeKey
    
    // MARK: ---------------- no singleton, factory method, so can be added as many views
    func createCardTemplateWithKey(_ key: String!, frame: CGRect) -> CardTemplateView{
        if key == nil {
            return JudgementCardTemplateView(frame: frame)
        }
        
        // try with embeded card templates first
        // "match card"
        if key == JudgementCardTemplateView.styleKey() {
            return JudgementCardTemplateView(frame: frame)
        }
        
        if key == PromptJudgementCardTemplateView.styleKey() {
            return PromptJudgementCardTemplateView(frame: frame)
        }
        
        // input cards
        if key == UserSelectCardTemplateView.styleKey() {
            return UserSelectCardTemplateView(frame: frame)
        }
        
        if key == TimeSelectCardTemplateView.styleKey() {
            return TimeSelectCardTemplateView(frame: frame)
        }
        
        if key == StrengthInputCardTemplateView.styleKey() {
            return StrengthInputCardTemplateView(frame: frame)
        }
        
        // "select spinning wheel"
        // MARK:--------- use key for test
        if key == SpinningMultipleChoiceCardsTemplateView.styleKey(){
            return SpinningMultipleChoiceCardsTemplateView(frame: frame)
        }
        
        // prompt
        if key == PromptMultipleChoiceTemplateView.styleKey() {
            return PromptMultipleChoiceTemplateView(frame: frame)
        }

        if key == IIAMultipleChoiceTemplateView.styleKey() {
            return IIAMultipleChoiceTemplateView(frame: frame)
        }
        
       
        // use JudgementCardTemplateView as default
        return SpinningMultipleChoiceCardsTemplateView(frame: frame)
    }
    
}
