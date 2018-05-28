//
//  ScorecardResultPanel.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/17.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ScorecardResultPanel: UIView {
    // distribution
    var forPercent = true
    
    // score panel
    var scoreAsInt = true
    var smallLeft = true
    
    /*
     1. percent, number is the real number of each part
     2. score, number is the max number of each part, min number is 0 as default
     */
    var dialInfo: [(number: CGFloat, color: UIColor)] = [(40, UIColor.green),(20, UIColor.red), (10, UIColor.yellow)] {
        didSet{
            setNeedsDisplay()
        }
    }
    
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
    
    var lineWidth = fontFactor * 2
    var fontSize = 10 * fontFactor
    var innerRatio: CGFloat = 0.3
    var radius: CGFloat {
        var aRadius = min(bounds.height, bounds.width * 0.5) - lineWidth * 0.5
        
        if !forPercent {
            aRadius = aRadius - fontSize * 2.5
        }
        
        return aRadius
    }
    
    var vertex: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.height - lineWidth * 0.5)
    }
    
    // draw rect
    override func draw(_ rect: CGRect) {
        if dialInfo.count == 0 {
            return
        }
        
        let innerRadius = radius * innerRatio
        var sAngle = CGFloat(Double.pi)
        var eAngle = sAngle
        
        // main part
        if forPercent {
            var eAngles = [CGFloat]()
            var sAngles = [CGFloat]()
            var total: CGFloat = 0
            
            for (number, _) in dialInfo {
                total += number
            }
            
            // background
            for (number, color) in dialInfo {
                eAngle = sAngle + CGFloat(Double.pi) * (number / total)
                
                let path = getFanPath(radius, innerRadius: innerRadius, vertex: vertex, sAngle: sAngle, eAngle: eAngle, clockwise: true)
                color.setFill()
                path.fill()
               
                // save for draw
                sAngles.append(sAngle)
                eAngles.append(eAngle)
                // endAngle become next's startAngle
                sAngle = eAngle
            }
            
            // boarder
            let boardPath = getFanPath(radius, innerRadius: innerRadius, vertex: vertex, sAngle: CGFloat(Double.pi), eAngle: 0, clockwise: true)
            boardPath.lineWidth = lineWidth
            UIColor.black.setStroke()
            boardPath.stroke()
            
            // texts
            // symbol
            let sLength = innerRadius * 2 / sqrt(5)
            drawString(NSAttributedString(string: "%", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize * 1.5, weight: UIFontWeightSemibold)]), inRect: CGRect(x: vertex.x - sLength * 0.5, y: vertex.y - sLength, width: sLength, height: sLength))
            
            // numbers, if the gap is too samll, may cover the other's back
            for i in 0..<sAngles.count {
                let numberString = "\(Int(nearbyint(dialInfo[i].number / total * 100)))%"
                let numberRadius = (radius + innerRadius) * 0.5
                
                // percent around, middle
                let bottomAngle = (sAngles[i] + eAngles[i]) * 0.5
                let bottomPoint = CGPoint(x: numberRadius * cos(bottomAngle) + vertex.x, y: vertex.y + numberRadius * sin(bottomAngle))
                drawNumberString(numberString, bottomPoint: bottomPoint, left: nil)
            }
        }else {
            let drawInfo = dialInfo.sorted(by: {$0.number < $1.number})
            let maxNumber = drawInfo.last!.number
            sAngle = smallLeft ? CGFloat(Double.pi) : 2 * CGFloat(Double.pi)
            
            for (number, color) in drawInfo {
                let angle = (number / maxNumber) * CGFloat(Double.pi)
                eAngle = smallLeft ? (angle + CGFloat(Double.pi)) : (2 * CGFloat(Double.pi) - angle)
                
                // back
                let path = getFanPath(radius, innerRadius: innerRadius, vertex: vertex, sAngle: sAngle, eAngle: eAngle, clockwise: smallLeft)
                color.setFill()
                path.fill()
          
                // text
                let bottomPoint = CGPoint(x: (radius + lineWidth * 0.5) * cos(eAngle) + vertex.x, y: vertex.y + (radius + lineWidth * 0.5) * sin(eAngle))
                drawNumberString(scoreAsInt ? "\(Int(number))" : "\(String(format: "%.1f", number))", bottomPoint: bottomPoint, left: (eAngle < CGFloat(Double.pi) * 1.5))

                // be next's startAngle
                sAngle = eAngle
            }
            
            // the "0"
            drawNumberString(String(0), bottomPoint: CGPoint(x: smallLeft ? (bounds.midX - radius - lineWidth) : (bounds.midX + radius + lineWidth), y: bounds.height), left: smallLeft)
            
            // lines
            let innerPath = UIBezierPath(arcCenter: vertex, radius: innerRadius, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: false)
            innerPath.close()
            UIColor.white.setFill()
            UIColor.black.setStroke()
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
            UIColor.black.setStroke()
            border.stroke()
        }
    }
    
    // if left is nil, bottomPoint is at center
    // left means the text is on left
    fileprivate func drawNumberString(_ string: String, bottomPoint: CGPoint, left: Bool!) {
        let font = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
        
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
