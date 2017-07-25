//
//  VDeckOfCardsFactory.swift
//  ABook_iPhone_V1
//
//  Created by hui wang on 11/12/16.
//  Copyright © 2016 LyTsai. All rights reserved.
//

import Foundation

// expected from metric deck of card host view such as WheelOfCardsCollectionView, CardsContainerView and VerticalFlowView etc.  These views are wthe direct hosts of CardTemplateView
protocol MetricDeckOfCardsViewProtocol {
    // attach deck of cards for showing the cards within hosting views
    func showDeckOfCards()
}

// MARK: ------------------ defination of class ----------------------------
// VDeckOfCardsFactory - class for generating deck of card content used for creating data input cards

// class for cards factory based on currently attached metrics card array [VCardModel]
// used for navigating through deck of data input cards for attached or selected metric array
class VDeckOfCardsFactory {
    // MARK: ---------- singleton
    static let metricDeckOfCards = VDeckOfCardsFactory()
    
    // currentyl attached risk
    var riskKey = String()
    // all cards attached as risk factors
    var allCards = [CardInfoObjModel]()
    
    // attach to risk model and all its risk factor metric cards
    // riskKey - risk model
    // metricsCards - cards as risk factors
    func attachToRiskFactorMetricCards(_ riskModelKey: String, metricsCards: [CardInfoObjModel]) {
        riskKey = riskModelKey
        allCards = metricsCards
    }
    
    // get total number of items for collection view
    func totalNumberOfItems()->Int {
        return allCards.count
    }
    
    // return VCardModel for the given index position.  index - 0 to totalNumberOfItems
    func getVCard(_ index: Int)->CardInfoObjModel?{
        return allCards[index]
    }
    
    // return VOptionModel for the given index position in collection view.  index - 0 to totalNumberOfItems
    // return the first card option
    func getCardOption(_ index: Int)->CardOptionObjModel?{
//        print("option number is \(allCards[index].cardOptions.count)")
        return allCards[index].cardOptions[0]
    }
    
}
