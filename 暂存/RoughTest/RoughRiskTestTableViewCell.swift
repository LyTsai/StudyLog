//
//  RoughRiskTestTableViewCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/26.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// MARK: ------------------ for section 0
class RiskTestTableViewCell: UITableViewCell {
    // two parts
    var leftTextLabel = UILabel()
    var rightControl = UIView()
  
    class func cellWithTableView(_ tableView: UITableView, reuseIdentifier: String, leftText: String, rightView: UIView)-> RiskTestTableViewCell {
        var riskTestCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? RiskTestTableViewCell
        if riskTestCell == nil {
            riskTestCell = RiskTestTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
            
            // leftTextLabel
            let leftTextLabel = UILabel()

            leftTextLabel.textColor = heavyGreenColor
            leftTextLabel.backgroundColor = darkGreenColor
            leftTextLabel.textAlignment = .center
            leftTextLabel.numberOfLines = 0
            leftTextLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
            riskTestCell!.contentView.addSubview(leftTextLabel)
            riskTestCell!.leftTextLabel = leftTextLabel
            
            // rightControlView
            riskTestCell!.selectionStyle = .none
        }
        
        riskTestCell!.leftTextLabel.text = leftText
        riskTestCell!.rightControl = rightView        
        riskTestCell!.contentView.addSubview(rightView)
        
        return riskTestCell!
    }
    
    
    fileprivate var cellWidth: CGFloat {
        return bounds.width
    }
    
    fileprivate var cellHeight: CGFloat {
        return bounds.height
    }
    
    fileprivate var proportion: CGFloat = 0
    func setLayoutWithProportion(_ proportion: CGFloat) {
        self.proportion = max(0, min(proportion, 1))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        leftTextLabel.frame = CGRect(x: 0, y: 0, width: cellWidth * proportion, height: cellHeight - 0.5)
        rightControl.frame = CGRect(x: leftTextLabel.frame.maxX, y: 0, width: cellWidth * (1 - proportion), height: cellHeight)
        
        setNeedsDisplay()
        
        if rightControl.isKind(of: GenderSwitch.self) {
            let genderView = rightControl as! GenderSwitch
            rightControl.layer.sublayers = nil
            genderView.addSwitchBar()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let separatorPath = UIBezierPath()
        separatorPath.move(to: CGPoint(x: 0, y: bounds.maxY))
        separatorPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        UIColor.darkGray.setStroke()
        separatorPath.lineWidth = 1
        separatorPath.stroke()
    }
}

// MARK: ------------------ for section 1
class ResultChartViewCell: UITableViewCell {
    fileprivate var chartView = UIView()
    class func cellWithTableView(_ tableView: UITableView, reuseIdentifier: String, chartView: UIView) -> ResultChartViewCell {
        var chartViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? ResultChartViewCell
        if chartViewCell == nil {
            chartViewCell = ResultChartViewCell(style: .default, reuseIdentifier: reuseIdentifier)
            chartViewCell!.selectionStyle = .none
            chartViewCell!.contentView.addSubview(chartView)
        }

        chartViewCell!.chartView = chartView
        return chartViewCell!
    }
    
    override func layoutSubviews() {
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let separatorPath = UIBezierPath()
        separatorPath.move(to: CGPoint(x: 0, y: bounds.maxY))
        separatorPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        UIColor.darkGray.setStroke()
        separatorPath.lineWidth = 1
        separatorPath.stroke()
    }
    
}
