//
//  HistoryWhyCompareView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/30.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class HistoryWhyCompareView: ScorecardSecondView {
    fileprivate let sepLine = UIView()
    fileprivate let leftTime = UILabel()
    fileprivate let rightTime = UILabel()
    fileprivate let rightCardsView = ScorecardCardsTableView.createTable()
    override func addView() {
        super.addView()
        sepLine.backgroundColor = UIColorGray(151)
        view.addSubview(sepLine)
        
        leftTime.textAlignment = .center
        rightTime.textAlignment = .center
        
        view.addSubview(leftTime)
        view.addSubview(rightTime)
        
        view.addSubview(rightCardsView)
    }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.width / 345
        let remainW = (remainedFrame.width - 25 * one) * 0.5
        
        leftTime.frame = CGRect(x: 0, y: cardsView.frame.minY, width: remainW, height: 30 * one).insetBy(dx: 15 * one, dy: 5 * one)
        rightTime.frame = CGRect(x: bounds.width - remainW, y: cardsView.frame.minY, width: remainW, height: 30 * one).insetBy(dx: 15 * one, dy: 5 * one)
        
        leftTime.layer.borderWidth = one
        rightTime.layer.borderWidth = one
        leftTime.layer.cornerRadius = 10 * one
        rightTime.layer.cornerRadius = 10 * one
        leftTime.font = UIFont.systemFont(ofSize: 12 * one)
        rightTime.font = UIFont.systemFont(ofSize: 12 * one)
        
        let collectionY = rightTime.frame.maxY + 5 * one
        cardsView.frame = CGRect(x: 10 * one, y: collectionY, width: remainW, height: remainedFrame.maxY - collectionY)
        rightCardsView.frame = CGRect(x: bounds.width - remainW - 10 * one, y: collectionY, width: remainW, height: remainedFrame.maxY - collectionY)
        sepLine.frame = CGRect(x: bounds.midX - 0.5 * one, y: leftTime.frame.minY, width: one, height: cardsView.frame.maxY - leftTime.frame.minY)
    }
    
    func setupWithLeft(_ left: MeasurementObjModel, right: MeasurementObjModel) {
        setupWithMeasurement(left)
        rightCardsView.loadAllCardsWithMeasurement(right)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        leftTime.text = formatter.string(from: ISO8601DateFormatter().date(from: left.timeString!)!)
        rightTime.text = formatter.string(from: ISO8601DateFormatter().date(from: right.timeString!)!)
    }

}
