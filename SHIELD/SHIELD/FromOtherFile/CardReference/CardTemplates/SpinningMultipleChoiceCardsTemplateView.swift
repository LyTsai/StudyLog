//
//  SpinningCardTemplateView.swift
//  ABook_iPhone_V1
//
//  Created by hui wang on 12/5/16.
//  Copyright © 2016 LyTsai. All rights reserved.
//

import Foundation

// spinning card view for multiple choice selection cards of same risk factor
class SpinningMultipleChoiceCardsTemplateView : CardTemplateView {
    override func key() -> String {
        return SpinningMultipleChoiceCardsTemplateView.styleKey()
    }
    
    class func styleKey()->String {
        return spinningMultipleChoiceCardsTemplateStyleTypeKey
    }
    
    // called within init
    var multipleChoiceCards: MultipleChoiceCardsView!
    override var withDeco: Bool {
        didSet{
            if multipleChoiceCards != nil {
                multipleChoiceCards.withDeco = withDeco
            }
        }
    }
    
    override func addBackAndUpdateUI() {
        multipleChoiceCards = MultipleChoiceCardsView.createMultipleChoiceCardsView(self.bounds, hostView: self)
        self.addSubview(multipleChoiceCards)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        multipleChoiceCards.resetFrame(bounds)
    }
    
    override func setUIForSelection(_ answer: Int?) {
        if answer == nil {
            return
        }
        if multipleChoiceCards != nil {
            multipleChoiceCards.chosenItem = answer!
        }
    }
    
    override func setForBaselineChoice(_ choice: Int?) {
        if choice == nil {
            return
        }
        if multipleChoiceCards != nil {
            multipleChoiceCards.baselineItem = choice!
            multipleChoiceCards.reloadItems(at: [IndexPath(item: choice!, section: 0)])
        }
    }
    
    override func beginToShow() {
        if multipleChoiceCards != nil{
            multipleChoiceCards.showCard()
        }
    }

    override func endShow() {
        if multipleChoiceCards != nil {
            multipleChoiceCards.endCard()
        }
    }
}
