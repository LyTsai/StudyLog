//
//  HistoryRiskDisplayCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/21.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

let historyMeasurementDisplayCellID = "History Measurement Display Cell identifier"
class HistoryMeasurementDisplayCell: UICollectionViewCell {
    fileprivate let timeLabel = UILabel()
    fileprivate let riskItem = RiskDisplayItem()
    fileprivate let check = UIImageView()
    fileprivate let multipleIndi = CAShapeLayer()
    var isChosen: Bool! {
        didSet{
            check.image = isChosen ? #imageLiteral(resourceName: "history_check") : #imageLiteral(resourceName: "history_uncheck")
        }
    }
    
    fileprivate let cellMask = UIView()
    var allowSelection = true {
        didSet{
            if allowSelection != oldValue {
                cellMask.isHidden = allowSelection
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBasic()
    }
    
    // reuse
    fileprivate func addBasic() {
        timeLabel.textColor = UIColorGray(136)
        timeLabel.textAlignment = .center
        
        multipleIndi.fillColor = UIColor.white.cgColor
        riskItem.layer.addBlackShadow(2 * fontFactor)
        
        contentView.layer.addSublayer(multipleIndi)
        contentView.addSubview(timeLabel)
        contentView.addSubview(riskItem)
        contentView.addSubview(check)
        
        cellMask.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        contentView.addSubview(cellMask)
        multipleIndi.isHidden = true
        cellMask.isHidden = true
    }
    
    func setupWithMeasurement(_ measurement: MeasurementObjModel, multiple: Bool, timelineType: TimelineType) {
        riskItem.setupWithRisk(measurement.riskKey!)
        timeLabel.isHidden = multiple
        multipleIndi.isHidden = !multiple
        
        if !multiple {
            let formatter = DateFormatter()
            switch timelineType {
            case .dayline: formatter.dateFormat = "HH:mm"
            case .monthline: formatter.dateFormat = "dd"
            }
            
            let date = ISO8601DateFormatter().date(from: measurement.timeString)!
            timeLabel.text = formatter.string(from: date)
        }else {
            let riskTypeKey = collection.getRisk(measurement.riskKey!).riskTypeKey!
            let riskType = collection.getRiskTypeByKey(riskTypeKey)!
            let color = riskType.realColor ?? tabTintGreen
            multipleIndi.strokeColor = color.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellMask.frame = bounds
        
        let labelH = bounds.height / 7
        let gap = labelH * 0.3
        let itemH = bounds.height - (gap + labelH) * 2
        let offsetX = bounds.width * 0.14
        
        timeLabel.frame = CGRect(x: 0, y: 0, width: bounds.width - offsetX, height: labelH)
        timeLabel.font = UIFont.systemFont(ofSize: labelH * 0.9)
        riskItem.frame = CGRect(x: 0, y: labelH + gap, width: bounds.width - offsetX, height: itemH)
        check.frame = CGRect(center: CGPoint(x: riskItem.frame.midX, y: bounds.height - labelH * 0.5), length: labelH)
        
        // backPath
        let lineWidth = itemH / 41
        var topRect = CGRect(x: 0, y: riskItem.frame.minY, width: bounds.width, height: itemH - itemH * 0.25 * 0.5)
        topRect = topRect.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        multipleIndi.lineWidth = lineWidth
        multipleIndi.path = UIBezierPath(roundedRect: topRect, cornerRadius: lineWidth * 2).cgPath
    }
}
