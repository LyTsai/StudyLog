//
//  ScorecardHowView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/14.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardHowView: ScorecardConcertoView {
    fileprivate let howView = ScorecardHowMainView()
    override func addView() {
        super.addView()
        view.addSubview(howView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.width / 353
        let confineFrame = remainedFrame.insetBy(dx: 5 * one, dy: 5 * one)
        howView.layoutWithFrame(confineFrame)
    }
    
    override func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        super.setupWithMeasurement(measurement)
        
        setupWithSubTitle("Action Planning Accessories", concertoType: .how)
        howView.setupWithMeasurement(measurement)
    }
}
