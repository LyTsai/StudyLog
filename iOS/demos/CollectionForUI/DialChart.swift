//
//  DialChart.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/1/22.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
class DialChart: UIView {
    var showSegNumber = false
    var showPercentNumber = false
    var segNumberAsPercent = false
    var startNumber: CGFloat = 0
    var dialInfo = [(max: CGFloat, color: UIColor)]() {
        didSet{
            setNeedsDisplay()
        }
    }
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
    override func draw(_ rect: CGRect) {
        if dialInfo.count == 0 {
            return
        }
        
        // main part
        let total = dialInfo.last!.max
        if total <= 0 {
            return
        }
        
        let vertex = CGPoint(x: bounds.midX, y: bounds.height - lineWidth)
        var radius = min(bounds.height, bounds.width * 0.5) - lineWidth
        if showSegNumber || showPercentNumber {
            let fontHeight = 16 * fontFactor
            radius = min(bounds.height - fontHeight, bounds.width * 0.5 - (1.5 + (showSegNumber ? 0.4: 0)) * fontHeight)
        }
        
        var sAngle = CGFloat(Double.pi)
        var sNumber = startNumber
        for (max, color) in dialInfo {
            let eAngle = CGFloat(Double.pi) * (max / total + 1)
            let path = UIBezierPath()
            path.move(to: vertex)
            path.addLine(to: CGPoint(x: radius * cos(sAngle) + vertex.x, y: vertex.y + radius * sin(sAngle)))
            path.addArc(withCenter: vertex, radius: radius, startAngle: sAngle, endAngle: eAngle, clockwise: true)
            path.close()
            
            color.setFill()
            path.fill()
            
            // number around, till end
            if showSegNumber {
                let point = CGPoint(x: (radius + lineWidth) * cos(eAngle) + vertex.x, y: vertex.y + radius * sin(eAngle))
                var numberString = String(Int(max))
                if segNumberAsPercent {
                    numberString = "\(Int(nearbyint(max * 100)))%"
                }
                drawNumberString(numberString, bottomPoint: point, left: (eAngle < CGFloat(Double.pi) * 1.5))
            }
            
            // percent around, middle
            if showPercentNumber {
                let mAngle = (sAngle + eAngle) * 0.5
                let point = CGPoint(x: (radius + lineWidth) * cos(mAngle) + vertex.x, y: vertex.y + radius * sin(mAngle))
                let percent = (max - sNumber) / total * 100
                
                drawNumberString("\(Int(nearbyint(Float(percent))))%", bottomPoint: point, left: (mAngle < CGFloat(Double.pi) * 1.5))
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
        innerPath.stroke()
        innerPath.fill()
        
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

    fileprivate func drawNumberString(_ string: String, bottomPoint: CGPoint, left: Bool) {
        let font = UIFont.systemFont(ofSize: 10 * fontFactor)
        
        let numberString = NSAttributedString(string: string, attributes: [NSFontAttributeName: font])
        let sSize = numberString.boundingRect(with: bounds.size, options: .usesLineFragmentOrigin, context: nil)
        let drawFrame = CGRect(x: left ? bottomPoint.x - sSize.width : bottomPoint.x, y: bottomPoint.y - sSize.height, width: sSize.width, height: sSize.height)
        numberString.draw(in: drawFrame)
    }
    
}
