//
//  TimelineCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/21.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

let timelineCellID = "timeline cell identifier"
class TimelineCell: UITableViewCell {

    fileprivate let timeLabel = UILabel()
    fileprivate let sepLine = UIView()
    fileprivate let anchorLayer = CAShapeLayer()
    fileprivate let detail = HistoryDetailCollectionView.createCollectionView()
    class func cellWithTableView(_ table: TimelineTableView, collectionData: [[MeasurementObjModel]], timelineType: TimelineType, chosenInfo: Set<IndexPath>) -> TimelineCell {
        var cell = table.dequeueReusableCell(withIdentifier: timelineCellID) as? TimelineCell
        if cell == nil {
            cell = TimelineCell(style: .default, reuseIdentifier: timelineCellID)
            cell?.addBasic()
        }
        cell?.setupWithCollectionData(collectionData, timelineType: timelineType, chosenInfo: chosenInfo)
       
        return cell!
    }
    
    func addBasic() {
        self.backgroundColor = UIColor.clear
      
        timeLabel.textAlignment = .right
        
        addSubview(sepLine)
        addSubview(detail)

        addSubview(timeLabel)
        layer.addSublayer(anchorLayer)
    }
    
    fileprivate func setAnchorColors(_ current: Bool) {
        if current {
            anchorLayer.fillColor = UIColorFromHex(0xFF9E9C).cgColor
            anchorLayer.strokeColor = UIColorFromHex(0xEE6D6B).cgColor
        }else {
            anchorLayer.fillColor = UIColorFromHex(0xD6DEE9).cgColor
            anchorLayer.strokeColor = UIColorFromHex(0xABB2BC).cgColor
        }
    }
    
    func setupWithCollectionData(_ collectionData: [[MeasurementObjModel]], timelineType: TimelineType, chosenInfo: Set<IndexPath>) {
        sepLine.backgroundColor = UIColor.red
        
        let timeString = collectionData.first?.first?.timeString
        let date = ISO8601DateFormatter().date(from: timeString!)
        let formatter = DateFormatter()
        
        switch timelineType {
        case .dayline: formatter.dateFormat = "dd"
        case .monthline: formatter.dateFormat = "MMM"
        }
        timeLabel.text = formatter.string(from: date!)
        setAnchorColors(false)
        detail.setupWithDataArray(collectionData, timelineType: timelineType, chosenInfo: chosenInfo)
      
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let firstX = 0.15 * bounds.width
        let anchorL = bounds.height * 0.1
        
        timeLabel.frame = CGRect(x: 0, y: 0, width: firstX - anchorL, height: bounds.height)
        timeLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.17, weight: .medium)
        sepLine.frame = CGRect(x: firstX, y: bounds.midY - 1, width: bounds.width - firstX, height: 2)
        anchorLayer.path = UIBezierPath(ovalIn: CGRect(center: CGPoint(x: firstX, y: bounds.midY), length: anchorL)).cgPath
        anchorLayer.lineWidth = 2
        detail.frame = CGRect(x: firstX * 1.2, y: 0, width: bounds.width - firstX * 1.2, height: bounds.height).insetBy(dx: 0, dy: bounds.height / 16)
    }
}
