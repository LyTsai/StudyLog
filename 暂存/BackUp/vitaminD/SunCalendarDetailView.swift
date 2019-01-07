//
//  SunCalendarDetailView.swift
//  AnnielyticX
//
//  Created by Lydire on 2018/5/28.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
enum SunLevel: Int {
    case good = 0
    case moderate
    case low
    case nonExistent
}

struct VitaminDSunCalendar {
    // use 1 to 12 as month, 1 is January
    static func getLevelOfLatitude(_ latitude: Float!, month: Int) -> SunLevel! {
        if month > 12 || month < 1 || latitude == nil {
            return nil
        }
        
        let north = latitude > 0
        switch latitude {
        case 0..<25:
            return (month <= 2 || month >= 11) ? .moderate : .good
        case 25..<35:
            if north {
                return (month <= 5 || month >= 9) ? .moderate : .good
            }else {
                return (month >= 4) ? .moderate : .good
            }
        case 35..<50:
            if north {
                if month >= 10 || month <= 2 {
                    return .nonExistent
                }else if (month >= 6 && month <= 8) {
                    return .good
                }else {
                    return .moderate
                }
            }else {
                if month == 12 || month <= 2 {
                    return .good
                }else if (month >= 5 && month <= 8) {
                    return .nonExistent
                }else {
                    return .moderate
                }
            }
        case 50..<75:
            if north {
                if month >= 10 || month <= 2 {
                    return .nonExistent
                }else if (month >= 6 && month <= 8) {
                    return .moderate
                }else {
                    return .low
                }
            }else {
                if month == 12 || month <= 2 {
                    return .moderate
                }else if (month >= 5 && month <= 8) {
                    return .nonExistent
                }else {
                    return .low
                }
            }
        default:
            return nil
        }
    }
    
    static func getColorOfSunLevel(_ level: SunLevel) -> UIColor {
        switch level {
        case .good: return UIColorFromRGB(255, green: 131, blue: 146)
        case .moderate: return UIColorFromRGB(255, green: 182, blue: 124)
        case .low: return UIColorFromRGB(255, green: 243, blue: 115)
        case .nonExistent: return UIColorFromRGB(252, green: 238, blue: 203)
        }
    }
    
    static func getTitleOfSunLevel(_ level: SunLevel) -> String {
        switch level {
        case .good: return "Intense Sunshine"
        case .moderate: return "Moderate Sunshine"
        case .low: return "Low Sunshine"
        case .nonExistent: return "None"
        }
    }
    static func getExplainOfSunLevel(_ level: SunLevel) -> String {
        switch level {
        case .good: return "Time needed to produce sufficient VitaminD:\n10 minutes(light-skinned),\n45 minutes(dark-skinned)"
        case .moderate: return "Time needed to produce sufficient VitaminD:\n20 minutes(light-skinned),\n60 minutes(dark-skinned)"
        case .low: return "Time needed to produce sufficient VitaminD:\n30 minutes(light-skinned),\n90 minutes(dark-skinned)"
        case .nonExistent: return "Not enough sunshine for adequate amounts of VitaminD"
        }
    }
    static func getMonthsOfSunLevel(_ sunLevel: SunLevel, latitude: Float!) -> [String] {
        if latitude == nil {
            return []
        }
        
        let monthArray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        var months = [String]()
        
        for (i, month) in monthArray.enumerated() {
            let level = getLevelOfLatitude(latitude, month: i + 1)!
            if level == sunLevel {
                months.append(month)
            }
        }
        
        return months
    }
}

class SunCalendarDetailView: UIView {
    fileprivate let iconImageView = UIImageView()
    fileprivate let titleLabel = UILabel() // 14
    fileprivate let explainLabel = UILabel()
        override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate func setupBasic() {
        backgroundColor = UIColor.clear
        explainLabel.numberOfLines = 0
        explainLabel.textColor = UIColorGray(51)
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(explainLabel)
    }
    
    var latitude: Float!
    var level = SunLevel.good
    var onePoint: CGFloat = 0
    func reloadView() {
        let icon = UIImage(named: "sun\(level.rawValue)")
        let title = VitaminDSunCalendar.getTitleOfSunLevel(level)
        let explain = VitaminDSunCalendar.getExplainOfSunLevel(level)
     
        iconImageView.image = icon
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14 * onePoint)
        explainLabel.text = explain
        explainLabel.font = UIFont.systemFont(ofSize: 12 * onePoint)
        
        let iconLength = 21 * onePoint
        iconImageView.frame = CGRect(x: 0, y: 0, width: iconLength, height: iconLength)
        let subX = iconLength + 4 * onePoint
        titleLabel.frame = CGRect(x: subX, y: 0, width: bounds.width - subX, height: iconLength)
        explainLabel.frame = CGRect(x: subX, y: titleLabel.frame.maxY + 2 * onePoint, width: bounds.width - subX, height: bounds.height)
        explainLabel.adjustWithWidthKept()
        
        let cellLength = 35 * onePoint
        let gap = 10 * onePoint
        let maxNumber = Int((bounds.width - iconLength + gap) / (cellLength + gap))
        var line: CGFloat = 0
        let monthsCount = VitaminDSunCalendar.getMonthsOfSunLevel(level, latitude: latitude).count
        if monthsCount != 0 {
            line = CGFloat(monthsCount / maxNumber + 1)
        }
        self.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: explainLabel.frame.maxY + line * (cellLength + gap))
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let cellLength = 35 * onePoint
        let gap = 10 * onePoint

        let drawX = explainLabel.frame.minX
        let drawY = explainLabel.frame.maxY + gap * 0.5
        
        let months = VitaminDSunCalendar.getMonthsOfSunLevel(level, latitude: latitude)
        let mainColor = VitaminDSunCalendar.getColorOfSunLevel(level)
        
        
        let maxNumber = Int((bounds.width - drawX + gap) / (cellLength + gap))
        for (i, month) in months.enumerated() {
            let cellFrame = CGRect(x: drawX + (cellLength + gap) * CGFloat(i % maxNumber), y: (cellLength + gap) * CGFloat(i / maxNumber) + drawY, width: cellLength, height: cellLength)
            let path = UIBezierPath(ovalIn: cellFrame)
            path.lineWidth = onePoint * 2
            mainColor.setStroke()
            path.stroke()
            
            drawString(NSAttributedString(string: month, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12 * onePoint)]), inRect: cellFrame, alignment: .center)
        }
    }
    
}


