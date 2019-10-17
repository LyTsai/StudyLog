//
//  ScorecardReferenceView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/25.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ScorecardReferenceView: ScorecardConcertoView {
    let scoreRef = ScoreReferenceView()
    override func addView() {
        super.addView()
        view.addSubview(scoreRef)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scoreRef.frame = remainedFrame
    }
    
    override func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        super.setupWithMeasurement(measurement)
        
        let subTitle = "Action Planning Accessories"
        setupWithSubTitle(subTitle, concertoType: .how)
        scoreRef.setupWithMeasurement(measurement)
    }
}


