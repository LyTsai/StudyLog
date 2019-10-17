//
//  HistoryWhatCompareView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/30.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class HistoryWhatCompareView: ScorecardFirstView {
    let rightOverall = Bundle.main.loadNibNamed("ScorecardOverallView", owner: self, options: nil)?.first as! ScorecardOverallView
    
    fileprivate let leftTime = UILabel()
    fileprivate let rightTime = UILabel()
    fileprivate let sepLine = UILabel()
    override func addView() {
        super.addView()
        
        leftTime.textAlignment = .center
        rightTime.textAlignment = .center
        
        view.addSubview(leftTime)
        view.addSubview(rightTime)
        view.addSubview(rightOverall)
        sepLine.backgroundColor = UIColorGray(151)
        view.addSubview(sepLine)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.width / 345
        
        let wHRatio: CGFloat = 345 / 368
        let remainW = (remainedFrame.width - 6 * one) * 0.5
        
        leftTime.frame = CGRect(x: 0, y: titleView.frame.maxY, width: remainW, height: 30 * one).insetBy(dx: 15 * one, dy: 5 * one)
        rightTime.frame = CGRect(x: bounds.width - remainW, y: titleView.frame.maxY, width: remainW, height: 30 * one).insetBy(dx: 15 * one, dy: 5 * one)
        
        leftTime.layer.borderWidth = one
        rightTime.layer.borderWidth = one
        leftTime.layer.cornerRadius = 10 * one
        rightTime.layer.cornerRadius = 10 * one
        leftTime.font = UIFont.systemFont(ofSize: 12 * one)
        rightTime.font = UIFont.systemFont(ofSize: 12 * one)
        
        let leftH = bounds.height - rightTime.frame.maxY - 5 * one
        let overallWidth = min(remainW, leftH * wHRatio)
        let centerY = 0.5 * (rightTime.frame.maxY + remainedFrame.maxY - 5 * one)
        overall.frame = CGRect(center: CGPoint(x: remainedFrame.midX - remainW * 0.5 - 1.5 * one, y: centerY), width: overallWidth, height: overallWidth / wHRatio)
        rightOverall.frame = CGRect(center: CGPoint(x: remainedFrame.midX + remainW * 0.5 + 1.5 * one, y: centerY), width: overallWidth, height: overallWidth / wHRatio)
        sepLine.frame = CGRect(x: bounds.midX - one * 0.5, y: leftTime.frame.minY, width: one, height: overall.frame.maxY - leftTime.frame.minY)
    }
    
    func setupWithLeft(_ left: MeasurementObjModel, right: MeasurementObjModel) {
        setupWithMeasurement(left)
        
        rightOverall.setupWithMeasurement(right)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        leftTime.text = formatter.string(from: ISO8601DateFormatter().date(from: left.timeString!)!)
        rightTime.text = formatter.string(from: ISO8601DateFormatter().date(from: right.timeString!)!)
    }
}
