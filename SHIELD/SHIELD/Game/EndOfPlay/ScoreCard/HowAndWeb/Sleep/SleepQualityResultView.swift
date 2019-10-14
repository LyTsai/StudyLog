//
//  SleepQualityResultView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/7/12.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class SleepQualityResultView: UIView {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var stack: UIStackView!
    @IBOutlet var qualityImages: [UIImageView]!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        let classifiers = collection.getRisk(measurement.riskKey!).classifiers
        if let classifier = MatchedCardsDisplayModel.getResultClassifierOfMeasurement(measurement) {
            for (i, c) in classifiers.enumerated() {
                if c.key == classifier.key {
                    levelIndex = i
                    bottomLabel.text = classifier.name
                }
            }
        }

    }
    var levelIndex: Int = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.font = UIFont.systemFont(ofSize: 16 * bounds.width / 345, weight: .semibold)
        bottomLabel.font = UIFont.systemFont(ofSize: 18 * bounds.width / 345, weight: .semibold)
        // transform
        for (i, image) in qualityImages.enumerated() {
            image.transform = CGAffineTransform.identity
            if i == levelIndex {
                let offset = image.frame.width * 0.5
                image.transform = CGAffineTransform(translationX: 0, y: -offset)
            }
        }
    }
}
