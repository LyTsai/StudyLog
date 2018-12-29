//
//  ComplementaryWhyView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/10/10.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ComplementaryWhyView: ScorecardConcertoView {
    
    fileprivate let complementary = ComplementaryTableView.createWithFrame(CGRect.zero)
    fileprivate let titleLabel = UILabel()
    override func addView() {
        super.addView()
        
        titleLabel.text = "You can tap the card to get the detailed information."
        titleLabel.numberOfLines = 0
        
        view.addSubview(titleLabel)
        view.addSubview(complementary)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let oneP = bounds.width / 345
        let xMargin = 15 * oneP
        
        titleLabel.frame = CGRect(x: 0, y: remainedFrame.minY + 5 * oneP, width: remainedFrame.width, height: oneP * 25).insetBy(dx: xMargin, dy: 0)
        titleLabel.font = UIFont.systemFont(ofSize: 12 * oneP, weight: .medium)
        complementary.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: remainedFrame.width, height: remainedFrame.maxY - titleLabel.frame.maxY).insetBy(dx: xMargin, dy: 5 * oneP)
    }
    
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        let subTitle = "Complementary Cards"
        setupWithRisk(measurement.riskKey!, subTitle: subTitle, concertoType: .why)
        complementary.setupWithMeasurement(measurement)
    }
}
