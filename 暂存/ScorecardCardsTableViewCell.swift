//
//  ScorecardCardsTableViewCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/29.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

let scorecardCardsTableViewCellID = "Scorecard Cards TableView Cell Identifier"
class ScorecardCardsTableViewCell: UITableViewCell {
    var estimatedHeight: CGFloat {
        return cardsView.contentSize.height
    }
    
    fileprivate let cardsView = AnsweredCardsCollectionView.createWithFrame(CGRect.zero)
    class func cellWithTableView(_ table: UITableView, measurment: MeasurementObjModel, factorType: FactorType) -> ScorecardCardsTableViewCell {
        var cell = table.dequeueReusableCell(withIdentifier: scorecardCardsTableViewCellID) as? ScorecardCardsTableViewCell
        if cell == nil {
            cell = ScorecardCardsTableViewCell(style: .default, reuseIdentifier: scorecardCardsTableViewCellID)
            cell?.setupBasic()
        }
        cell?.setupWithMeasurment(measurment, factorType: factorType)
        
        return cell!
    }
    
    fileprivate func setupBasic() {
        contentView.addSubview(cardsView)
    }
    
    fileprivate func setupWithMeasurment(_ measurement: MeasurementObjModel, factorType: FactorType) {
        cardsView.frame = bounds.insetBy(dx: 0.07 * bounds.width, dy: 0)
        cardsView.loadAllCardsWithMeasurement(measurement, factorType: factorType)
        cardsView.layoutIfNeeded()
      
        cardsView.frame.size.height = cardsView.contentSize.height
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        cardsView.frame = bounds.insetBy(dx: 0.07 * bounds.width, dy: 0)
//        cardsView.frame.size.height = cardsView.contentSize.height
//    }
}
