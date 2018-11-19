//
//  SunCalendarDrawView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/14.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class SunCalendarDrawView: UIView {
    var latitude: Float! {
        didSet{
            if latitude != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override func draw(_ rect: CGRect) {
        let oneW = bounds.width / 335
        let calendarImage = UIImage(named: "sunCalendar") // 335 * 136
        let backH = bounds.width / 335 * 136
        let dotL = oneW * 8
        let lineWidth = oneW
        if (dotL + 2 * lineWidth + backH) > bounds.height {
            print("height is not enough")
        }
        
        let imageRect = CGRect(x: 0, y: bounds.height - backH, width: bounds.width, height: backH)
        calendarImage?.draw(in: imageRect, blendMode: .normal, alpha: latitude == nil ? 1 : 0.3)
        
        
        let startX = oneW * 77
        let gap = (bounds.width - 2 * startX - dotL) / 11 - dotL
        var textY = bounds.height - backH - dotL - lineWidth
        let levels = VitaminDSunCalendar.getLevelArrayOfLatitude(latitude)
        if levels.count != 0 {
            let centerYs: [CGFloat] = [18, 33, 48, 62, 74, 87, 103, 119]
            let levelY = getRowIndexOfLatitude(latitude)!
            let centerY = centerYs[levelY] * oneW + imageRect.minY
            
            let backY = centerY - dotL * 1.5 - gap
            let backPath = UIBezierPath(rect: CGRect(x: startX, y: backY, width: bounds.width -  2 * (startX), height: dotL * 2 + gap).insetBy(dx: -5 * oneW, dy: -5 * oneW))
            UIColor.black.withAlphaComponent(0.3).setFill()
            backPath.fill()
            for (i, level) in levels.enumerated() {
                let circleR = CGRect(x: startX + (gap + dotL) * CGFloat(i), y: centerY - dotL * 0.5, width: dotL, height: dotL)
                let path = UIBezierPath(ovalIn: circleR)
                VitaminDSunCalendar.getColorOfSunLevel(level).setFill()
                path.lineWidth = lineWidth
                UIColor.black.setStroke()
                path.stroke()
                path.fill()
            }
            textY = backY
        }
        // 10, 14, 15, 15, 12, x: 76
     
        for (i, month) in monthArray.enumerated() {
            let textR = CGRect(x: startX + (gap + dotL) * CGFloat(i), y: textY, width: dotL, height: dotL)
            let path = UIBezierPath(ovalIn: textR.insetBy(dx: -lineWidth * 0.5, dy: -lineWidth * 0.5))
            UIColorGray(100).setStroke()
            path.lineWidth = lineWidth
            UIColor.white.setFill()
            path.fill()
            path.stroke()
            
            drawString(NSAttributedString(string: "\(month.first!)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: dotL * 0.9, weight: UIFontWeightMedium), NSForegroundColorAttributeName: UIColor.black]), inRect: textR, alignment: .center)

        }
    }
    
    
    
    fileprivate func getRowIndexOfLatitude(_ latitude: Float!) -> Int! {
        if latitude == nil {
            return nil
        }
        
        let north = latitude > 0
        switch latitude {
        case 0..<25: return north ? 3 : 4
        case 25..<35: return north ? 2 : 5
        case 35..<50: return north ? 1 : 6
        case 50..<75: return north ? 0 : 7
        default: return nil
        }
    }
}
