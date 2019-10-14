//
//  FufullmentCardTemplateView.swift
//  AnnielyticX
//
//  Created by L on 2019/4/28.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class FulfillmentCardTemplateView: JudgementCardTemplateView {
    override func key() -> String {
        return FulfillmentCardTemplateView.styleKey()
    }
    
    override class func styleKey() -> String {
        return "FulfillmentCardKey"
    }
    
    // MARK: ----- init -------
    override func addBackAndUpdateUI() {
        super.addBackAndUpdateUI()
        
        // buttons
        leftButton.setupWithTitle("Fulfilled")
        rightButton.setupWithTitle("Didn't do it")
    }
    
    override func setUIForSelection(_ answer: Int?) {
        super.setUIForSelection(answer)
        
        leftButton.isSelected = false
        rightButton.isSelected = false
//        descriptionView.isChosen = true
        

    }

    func setupWithMatch(_ match: MatchObjModel) {
        
    }
    
    
    // data
    override func setCardContent(_ card: CardInfoObjModel, defaultSelection: CardOptionObjModel?) {
        super.setCardContent(card, defaultSelection: defaultSelection)
  
    }
    
    
    override func rightButtonClicked() {
      
    }
    
    override func leftButtonClicked() {
        
    }
}
