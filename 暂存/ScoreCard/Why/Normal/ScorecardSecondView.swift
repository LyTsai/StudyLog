//
//  ScorecardSecondView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/25.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
class ScorecardSecondView: ScorecardConcertoView {
    let titleLabel = UILabel()
    let cardsView = AnsweredCardsCollectionView.createWithFrame(CGRect.zero)
    override func addView() {
        super.addView()
        
        titleLabel.numberOfLines = 0
        titleLabel.text = "You can find out how each of your card selection choice impact the overall score calculation"
        view.addSubview(titleLabel)
        view.addSubview(cardsView)
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        let one = bounds.width / 345
        
        let useFrame = remainedFrame.insetBy(dx: 15 * one, dy: 5 * one)
        titleLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: UIFont.Weight.medium)
        let gap = one * 5
        titleLabel.frame = CGRect(x: useFrame.minX, y: useFrame.minY, width: useFrame.width, height: 1000)
        titleLabel.adjustWithWidthKept()

        let collectionY = titleLabel.frame.maxY + gap
        cardsView.frame = CGRect(x: useFrame.minX, y: collectionY, width: useFrame.width, height: useFrame.maxY - collectionY)
    }
    
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        let subTitle = "Card Contributions to Overall Score"
        let riskKey = measurement.riskKey!
        
        setupWithRisk(riskKey, subTitle: subTitle, concertoType: .why)
        
        let cardsInfo = MatchedCardsDisplayModel.getScoreSortedCardsInMeasurement(measurement, lowToHigh: false)
        
        cardsView.totalNumber = collection.getScoreCardsOfRisk(riskKey).count
        cardsView.cardsInfo = cardsInfo
        cardsView.reloadData()
    }
}
