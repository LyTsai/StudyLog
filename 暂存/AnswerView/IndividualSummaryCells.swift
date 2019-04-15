//
//  IndividualSummaryCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/27.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
// row == 0
// use SummaryHeaderCell

// row == 2
let individualOverallCellID = "individual Overall Cell Identifier"

class IndividualOverallCell: UITableViewCell {
    class func cellWithTableView(_ tableView: UITableView) -> IndividualOverallCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: individualOverallCellID) as? IndividualOverallCell
        if cell == nil {
            cell = IndividualOverallCell(style: .default, reuseIdentifier: individualOverallCellID)
            cell!.selectionStyle = .none
            cell!.isUserInteractionEnabled = false
        }
        
        return cell!
    }
    
    var graph = TwoLevelsGraphView()
    override func layoutSubviews() {
        super.layoutSubviews()
    
        graph.removeFromSuperview()
        
        let riskClass = RiskMetricCardsCursor.sharedCursor.selectedRiskClass
        graph.setupWithRiskClass(riskClass!, frame: CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height))
        graph.backgroundColor = UIColor.clear
        addSubview(graph)
    }
}

/*
class RiskClassTreeMap: UIView {
    
    fileprivate let backImageView = UIImageView(image: UIImage(named: "hexBack"))
    fileprivate func addSubs() {
        let hexRatio: CGFloat = 97 / 88
        
    }
    
    func setupWithRiskClass(_ riskClass: MetricObjModel) {
        
    }
}
*/
// row >=3
// use MetricInfoCell
