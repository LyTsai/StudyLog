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
    weak var table: ScorecardCardsTableView!
    var indexPath: IndexPath!
    fileprivate let cardsView = AnsweredCardsCollectionView.createWithFrame(CGRect.zero)
    class func cellWithTableView(_ table: UITableView, measurment: MeasurementObjModel, factorType: FactorType) -> ScorecardCardsTableViewCell {
        var cell = table.dequeueReusableCell(withIdentifier: scorecardCardsTableViewCellID) as? ScorecardCardsTableViewCell
        if cell == nil {
            cell = ScorecardCardsTableViewCell(style: .default, reuseIdentifier: scorecardCardsTableViewCellID)
            cell?.selectionStyle = .none
            cell!.contentView.addSubview(cell!.cardsView)
            cell?.cardsView.isScrollEnabled = false
        }
        cell?.setupWithMeasurment(measurment, factorType: factorType)
        
        return cell!
    }
    
    fileprivate func setupWithMeasurment(_ measurement: MeasurementObjModel, factorType: FactorType) {
        cardsView.loadAllCardsWithMeasurement(measurement, factorType: factorType)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cardsView.frame = bounds.insetBy(dx: 0.05 * bounds.width, dy: 0)
        cardsView.layoutIfNeeded()
        cardsView.frame.size.height = cardsView.contentSize.height
        
        table.cellHeightIsCalculatedFor(indexPath, cellHeight: cardsView.frame.height)
    }
}
