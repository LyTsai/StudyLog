//
//  ScorecardFirstView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/25.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ScorecardFirstView: ScorecardConcertoView {
    let titleView = ScorecardWhatTitleView()
    let overall = Bundle.main.loadNibNamed("ScorecardOverallView", owner: self, options: nil)?.first as! ScorecardOverallView
    
    override func addView() {
        super.addView()
        
        view.addSubview(titleView)
        view.addSubview(overall)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.width / 345
        titleView.frame = CGRect(x: 0, y: remainedFrame.minY, width: bounds.width, height: remainedFrame.height * 0.2).insetBy(dx: 5 * one, dy: 0)
        
        let leftH = remainedFrame.height - titleView.frame.height - 5 * one
        let wHRatio: CGFloat = 345 / 431
        let remainW = remainedFrame.width - 8 * one
        let overallWidth = min(remainW, leftH * wHRatio)
        let centerY = 0.5 * (titleView.frame.maxY + remainedFrame.maxY - 5 * one)
        overall.frame = CGRect(center: CGPoint(x: remainedFrame.midX, y: centerY), width: overallWidth, height: overallWidth / wHRatio)
    }
    
    override func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        super.setupWithMeasurement(measurement)
        
        let riskKey = measurement.riskKey!
        let subTitle = "Overall \(collection.getTierOfRisk(riskKey) == 2 ? "Distribution" : "Score") at-a-glance"
        setupWithSubTitle(subTitle, concertoType: .what)
        titleView.setupWithRiskKey(measurement.riskKey!)
        overall.setupWithMeasurement(measurement)
    }
}
