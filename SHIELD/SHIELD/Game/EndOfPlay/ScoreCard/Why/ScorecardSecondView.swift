//
//  ScorecardSecondView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/25.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
class ScorecardSecondView: ScorecardConcertoView {
    let cardsView = ScorecardCardsTableView.createTable()
    override func addView() {
        super.addView()
        
        view.addSubview(cardsView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cardsView.frame = remainedFrame
    }
    
    override func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        super.setupWithMeasurement(measurement)
        
        // data
        let subTitle =  "Card Contributions to Overall Score"
        // forScore ? "Card Contributions to Overall Score" : "Complementary Card"
        setupWithSubTitle(subTitle, concertoType: .why)
        cardsView.loadAllCardsWithMeasurement(measurement)
    }
}
