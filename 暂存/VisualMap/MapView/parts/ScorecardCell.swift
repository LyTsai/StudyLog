//
//  ScorecardCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/17.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

let scorecardCellID = "score card cell identifier"
class ScorecardCell: UICollectionViewCell {
    var riskKey: String! {
        didSet{
            let measurement = selectionResults.getLastMeasurementOfUser(userCenter.currentGameTargetUser.Key(), riskKey: riskKey, whatIf: WHATIF)!
            scorecard.setupWithMeasurement(measurement)
            scorecard.layoutSubviews()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addView()
    }
    
    fileprivate let scorecard = ScorecardDisplayAllView()
    fileprivate func addView() {
        scorecard.indicatorView.isHidden = true
        contentView.addSubview(scorecard)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scorecard.frame = bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
}
