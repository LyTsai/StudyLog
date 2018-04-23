//
//  DialChart.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/1/22.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
class DialChart: UIView {
    var numberInside = false
    
    /** end of chart */
    var showSegNumber = false
    var startNumber: CGFloat = 0
    
    /** percent of chart */
    var showPercentNumber = false
    var segNumberAsPercent = false
    
    var dialInfo = [(max: CGFloat, color: UIColor)]() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var fontHeight = 16 * fontFactor
    
    var borderColor = UIColor.black
    var lineWidth = fontFactor * 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    // draw rect
    var radius: CGFloat {
        var aRadius = min(bounds.height, bounds.width * 0.5) - lineWidth
        
        if (showSegNumber || showPercentNumber) && !numberInside {
            aRadius = min(bounds.height - fontHeight, bounds.width * 0.5 - (1.5 + (showSegNumber ? 0.4: 0)) * fontHeight)
        }
        
        return aRadius
    }
    
    var eAngles: [CGFloat] {
        return _eAngles
    }
    fileprivate var _eAngles = [CGFloat]() // π ~ 2 * π
    
    var vertex: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.height - lineWidth * 0.5)
    }
    
    override func draw(_ rect: CGRect) {
        if dialInfo.count == 0 {
            return
        }
        
        _eAngles.removeAll()
        
        // main part
        let total = dialInfo.last!.max
        if total <= 0 {
            return
        }
        
        var sAngle = CGFloat(Double.pi)
        var sNumber = startNumber
        for (max, color) in dialInfo {
            let eAngle = CGFloat(Double.pi) * (max / total + 1)
            _eAngles.append(eAngle)
            
            let path = UIBezierPath()
            path.move(to: vertex)
            path.addLine(to: CGPoint(x: radius * cos(sAngle) + vertex.x, y: vertex.y + radius * sin(sAngle)))
            path.addArc(withCenter: vertex, radius: radius, startAngle: sAngle, endAngle: eAngle, clockwise: true)
            path.close()
            
            color.setFill()
            path.fill()
            
            // texts
            if showSegNumber || showPercentNumber {
                var numberRadius = radius + lineWidth
                var bottomAngle = eAngle
                var numberString = String(Int(max))
                
                if segNumberAsPercent {
                    numberString = "\(Int(nearbyint(max * 100)))%"
                }
            
                // percent around, middle
                if showPercentNumber {
                    bottomAngle = (sAngle + eAngle) * 0.5
                    numberString = "\(Int(nearbyint(Float((max - sNumber) / total * 100))))%"
                }
                
                if numberInside {
                    numberRadius *= 0.65
                }
                
                let bottomPoint = CGPoint(x: numberRadius * cos(bottomAngle) + vertex.x, y: vertex.y + numberRadius * sin(bottomAngle))
                drawNumberString(numberString, bottomPoint: bottomPoint, left: numberInside ? nil : (bottomAngle < CGFloat(Double.pi) * 1.5))
            }
            
            // be next's startAngle
            sAngle = eAngle
            sNumber = max
        }
        
        // lines
        let innerPath = UIBezierPath(arcCenter: vertex, radius: radius * 0.22, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: false)
        innerPath.close()
        UIColor.white.setFill()
        borderColor.setStroke()
        innerPath.lineWidth = 0.5 * lineWidth
        innerPath.fill()
        innerPath.stroke()
        
        let middlePath = UIBezierPath(arcCenter: vertex, radius: radius * 0.85, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: false)
        UIColor.white.setStroke()
        middlePath.lineWidth = lineWidth
        middlePath.stroke()
        
        let border = UIBezierPath(arcCenter: vertex, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: false)
        border.close()
        border.lineWidth = lineWidth
        borderColor.setStroke()
        border.stroke()
        
        if showSegNumber {
            drawNumberString(String(Int(startNumber)), bottomPoint: CGPoint(x: bounds.midX - radius - lineWidth,y: bounds.height), left: true)
        }
    }

    // if left is nil, bottomPoint is at center
    fileprivate func drawNumberString(_ string: String, bottomPoint: CGPoint, left: Bool!) {
        let font = UIFont.systemFont(ofSize: 10 * fontFactor)
        
        let numberString = NSAttributedString(string: string, attributes: [NSFontAttributeName: font])
        let sSize = numberString.boundingRect(with: bounds.size, options: .usesLineFragmentOrigin, context: nil)
        var drawFrame = CGRect.zero
        if left == nil {
            // at center
            drawFrame = CGRect(center: bottomPoint, width: sSize.width, height: sSize.height)
        } else {
           drawFrame = CGRect(x: left ? bottomPoint.x - sSize.width : bottomPoint.x, y: bottomPoint.y - sSize.height, width: sSize.width, height: sSize.height)
        }
        
        numberString.draw(in: drawFrame)
    }
}
