//
//  SeeHowCardsView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/30.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
class SeeHowCardsView: UIView {
    fileprivate var cardsDisplayView = MatchedCardsDisplayView()
    fileprivate var seeHowRiskView = SeeHowRiskView()
    func setupWithFrame(_ frame: CGRect, cardEdgeInsets: UIEdgeInsets, cards:[MatchedCardsDisplayModel]) {
        self.frame = frame
        
        // cards
        cardsDisplayView.setupWithFrame(bounds, cardEdgeInsets: cardEdgeInsets, cards: cards, withAssess: true)
        cardsDisplayView.seeHowHost = self
        cardsDisplayView.adjustForSeeHow()
        addSubview(cardsDisplayView)
        
        // risk
        seeHowRiskView = Bundle.main.loadNibNamed("SeeHowRiskView", owner: self, options: nil)?.first as! SeeHowRiskView
        seeHowRiskView.setupWithCard(cards.first!)
        seeHowRiskView.frame = CGRect(x: cardEdgeInsets.left, y: bounds.height - cardEdgeInsets.bottom, width: bounds.width - cardEdgeInsets.left - cardEdgeInsets.right, height: cardEdgeInsets.bottom * 0.9)
        addSubview(seeHowRiskView)
    }
    
    func updateWithCard(_ card: MatchedCardsDisplayModel) {
        seeHowRiskView.setupWithCard(card)
    }
}

