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
    var forWhatIf = false
    var totalNumber: Int = 1
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
    var baselineInfo = [(number: CGFloat, color: UIColor)]() {
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
    
    func addFaces(_ faces: [URL?]) {
        if faces.count != dialInfo.count {
            return
        }
    }
    
    // draw rect
    fileprivate let unplayColor = UIColorGray(213)
    override func draw(_ rect: CGRect) {
        if dialInfo.isEmpty {
            return
        }
        
        let innerRadius = radius * innerRatio
        var sAngle = CGFloat(Double.pi)
        var eAngle = sAngle
        
        // main part
        if forPercent {
            var panelRadius = radius
            if forWhatIf {
                panelRadius = radius * 0.8
                let boardPath = UIBezierPath.getFanPath(radius, innerRadius: innerRadius, vertex: vertex, sAngle: CGFloat(Double.pi), eAngle: 0, clockwise: true)
                unplayColor.withAlphaComponent(0.5).setFill()
                boardPath.fill()
                
                var baseTotal: CGFloat = 0
                if totalNumber > 0 {
                    baseTotal = CGFloat(totalNumber)
                }else {
                    for (number, _) in baselineInfo {
                        baseTotal += number
                    }
                }
                
                // background
                for (number, color) in baselineInfo {
                    eAngle = sAngle + CGFloat(Double.pi) * (number / baseTotal)
                    
                    let path = UIBezierPath.getFanPath(radius, innerRadius: panelRadius, vertex: vertex, sAngle: sAngle, eAngle: eAngle, clockwise: true)
                    color.withAlphaComponent(0.5).setFill()
                    path.fill()
                    
                    // endAngle become next's startAngle
                    sAngle = eAngle
                }
                
                // board
                boardPath.lineWidth = lineWidth
                boardPath.setLineDash([5 * fontFactor, 5 * fontFactor], count: 1, phase: 1)
                UIColor.black.setStroke()
                boardPath.stroke()
                
                sAngle = CGFloat(Double.pi)
                eAngle = sAngle
            }
            
            // normal
            // board
            let boardPath = UIBezierPath.getFanPath(panelRadius, innerRadius: innerRadius, vertex: vertex, sAngle: CGFloat(Double.pi), eAngle: 0, clockwise: true)
            // shaodow
            let ctx = UIGraphicsGetCurrentContext()!
            ctx.saveGState()
            ctx.setShadow(offset: CGSize.zero, blur: lineWidth * 3, color: UIColor.black.cgColor)
            unplayColor.setFill()
            boardPath.fill()
            ctx.restoreGState()
            
            // panel
            var eAngles = [CGFloat]()
            var sAngles = [CGFloat]()
            var total: CGFloat = 0
            
            if totalNumber > 0 {
                total = CGFloat(totalNumber)
            }else {
                for (number, _) in dialInfo {
                    total += number
                }
            }
            
            // background
            for (number, color) in dialInfo {
                eAngle = sAngle + CGFloat(Double.pi) * (number / total)
                
                let path = UIBezierPath.getFanPath(panelRadius, innerRadius: innerRadius, vertex: vertex, sAngle: sAngle, eAngle: eAngle, clockwise: true)
                color.setFill()
                path.fill()
               
                // save for draw
                sAngles.append(sAngle)
                eAngles.append(eAngle)
                // endAngle become next's startAngle
                sAngle = eAngle
            }
            
            // boarder line
            boardPath.lineWidth = lineWidth
            (forWhatIf ? UIColorFromHex(0x965FF1): UIColor.black).setStroke()
            boardPath.stroke()
            
            // texts
            // symbol
            let sLength = innerRadius * 2 / sqrt(5)
            drawString(NSAttributedString(string: "%", attributes: [ .font: UIFont.systemFont(ofSize: fontSize * 1.5, weight: .semibold),  .foregroundColor: (forWhatIf ? UIColorFromHex(0x965FF1): UIColor.black)]), inRect: CGRect(x: vertex.x - sLength * 0.5, y: vertex.y - sLength, width: sLength, height: sLength))
            
            // numbers, if the gap is too samll, may cover the other's back
            var addUp = 0
            for i in 0..<sAngles.count {
                var number = Int(nearbyint(dialInfo[i].number / total * 100))
                if i != sAngles.count - 1 {
                    addUp += number
                }else {
                    if addUp + number > 100 {
                        number = 100 - addUp
                    }
                }
                
                let numberRadius = (panelRadius + innerRadius) * 0.5
                
                // percent around, middle
                let bottomAngle = (sAngles[i] + eAngles[i]) * 0.5
                let bottomPoint = CGPoint(x: numberRadius * cos(bottomAngle) + vertex.x, y: vertex.y + numberRadius * sin(bottomAngle))
                drawNumberString("\(number)%", bottomPoint: bottomPoint, left: nil)
            }
        }else {
            // shaodow
            let border = UIBezierPath(arcCenter: vertex, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: false)
            border.close()
            
            let ctx = UIGraphicsGetCurrentContext()!
            ctx.saveGState()
            ctx.setShadow(offset: CGSize.zero, blur: lineWidth * 3, color: UIColor.black.cgColor)
            UIColor.white.setFill()
            border.fill()
            ctx.restoreGState()
            
            // panel
            let drawInfo = dialInfo.sorted(by: {$0.number < $1.number})
            let maxNumber = drawInfo.last!.number
            sAngle = smallLeft ? CGFloat(Double.pi) : 2 * CGFloat(Double.pi)
            
            for (number, color) in drawInfo {
                let angle = (number / maxNumber) * CGFloat(Double.pi)
                eAngle = smallLeft ? (angle + CGFloat(Double.pi)) : (2 * CGFloat(Double.pi) - angle)
                
                // back
                let path = UIBezierPath.getFanPath(radius, innerRadius: innerRadius, vertex: vertex, sAngle: sAngle, eAngle: eAngle, clockwise: smallLeft)
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
    
            border.lineWidth = lineWidth
            (forWhatIf ? UIColorFromHex(0x965FF1): UIColor.black).setStroke()
            border.stroke()
            
            // text
            let ctx1 = UIGraphicsGetCurrentContext()!
            ctx1.saveGState()
            let titleString = NSMutableAttributedString(string: "Overall Scoring Thresholds", attributes: [ .font: UIFont.systemFont(ofSize: fontSize * 1.4, weight: .medium),  .foregroundColor: UIColor.black])
            let circleText = ANCircleText()
            let leftAngle: CGFloat = 180
            let rightAngle: CGFloat = 0
            // draw
            circleText.paintCircleText(ctx1, text: titleString, style: .alignMiddle, radius: radius + 1.8 * fontSize, width: fontSize * 1.4, left: leftAngle, right: rightAngle, center: vertex)
            
            ctx1.restoreGState()
        }
    }
    
    fileprivate func drawPanelWithVertex(_ vertex: CGPoint, radius: CGFloat, innerRadius: CGFloat!, drawInfo: [(gap: CGFloat, color: UIColor)]) {
        
    }
    
    // if left is nil, bottomPoint is at center
    // left means the text is on left
    fileprivate func drawNumberString(_ string: String, bottomPoint: CGPoint, left: Bool!) {
        let font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        
        let numberString = NSAttributedString(string: string, attributes: [ .font: font])
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
