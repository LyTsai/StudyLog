//
//  PromptCardTemplateView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/9/15.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

// card.title, match.name, card.title
class PromptMultipleChoiceTemplateView: SpinningMultipleChoiceCardsTemplateView {
    override func key() -> String {
        return PromptMultipleChoiceTemplateView.styleKey()
    }

    override class func styleKey() -> String {
        return promptMultipleChoiceTemplateStyleTypeKey
    }
}


// iIa
class IIAMultipleChoiceTemplateView: PromptMultipleChoiceTemplateView {
    override func key() -> String {
        return IIAMultipleChoiceTemplateView.styleKey()
    }
    
    override class func styleKey() -> String {
        return iIaCardTemplateStyleTypeKey
    }
}


// single
class PromptJudgementCardTemplateView: JudgementCardTemplateView {
    override func key() -> String {
        return PromptJudgementCardTemplateView.styleKey()
    }
    
    override class func styleKey() -> String {
        return promptJudgementCardTemplateStyleTypeKey
    }
    
    override func addBackAndUpdateUI() {
        super.addBackAndUpdateUI()
        withPrompt = true
    }
    
    override func setCardContent(_ card: CardInfoObjModel, defaultSelection: CardOptionObjModel?) {
        super.setCardContent(card, defaultSelection: defaultSelection)
        
        // match.statement
        if let match = defaultSelection?.match {
            if match.name == nil || match.name!.count < 2 {
                descriptionView.title = match.statement
            }
            
            descriptionView.detail = match.statement
        }
    }
}
