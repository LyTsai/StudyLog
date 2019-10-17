//
//  AnsweredCardsBar.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/20.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class AnsweredCardsBar: UIView {
    
    /** the percent for each segmenet */
    var showPercent = false
    /** a triangle and the border for current segment */
    fileprivate var focusIndex: Int!
    
    fileprivate var drawInfo = [(number: Int, color: UIColor)]()
    fileprivate var total: Int = 0
    fileprivate let arrowShape = CAShapeLayer()
    func setupWithDrawInfo(_ drawInfo: [(number: Int, color: UIColor)], totalNumber: Int, focusIndex: Int!) {
        backgroundColor = UIColor.clear
        
        if focusIndex != nil && (focusIndex < 0 || focusIndex >= drawInfo.count) {
            return
        }
        // assign
        self.drawInfo = drawInfo
        self.total = totalNumber
        self.focusIndex = focusIndex
    
        // layout
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let left = fontFactor * 0.5
        let right = fontFactor * 0.5
        let top = showPercent ? bounds.height / 3 : bounds.height * 0.4
        let bottom = showPercent ? bounds.height / 3 : bounds.height * 0.4
        
        // bars
        let barRect = CGRect(x: left, y: top, width: bounds.width - left - right, height: bounds.height - bottom - top)
        
        if !showPercent {
            let textH = top * 0.6
            let topFont = UIFont.systemFont(ofSize: textH * 0.85, weight: .medium)
            let textW = barRect.width * 0.5
            drawString(NSAttributedString(string: drawInfo.count < 3 ? "Higher" : "Highest", attributes: [ .font: topFont]), inRect: CGRect(x: fontFactor, y: 0 ,width: textW, height: textH), alignment: .left)
            drawString(NSAttributedString(string: drawInfo.count < 3 ? "Lower" : "Lowest", attributes: [ .font: topFont]), inRect: CGRect(x: barRect.maxX - textW - fontFactor, y: 0, width: textW, height: textH), alignment: .right)
            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: left, y: 0))
            linePath.addLine(to: CGPoint(x: left, y: top))
            linePath.move(to: CGPoint(x: barRect.maxX, y: 0))
            linePath.addLine(to: CGPoint(x: barRect.maxX, y: top))
            linePath.lineWidth = fontFactor
            
            UIColor.black.setStroke()
            linePath.setLineDash([fontFactor * 2, fontFactor], count: 1, phase: 1)
            linePath.stroke()
        }
        
        // bar
        let backPath = UIBezierPath(rect: barRect)
        UIColorGray(230).setFill()
        backPath.fill()

        var startX = barRect.minX
        var focusFrame = CGRect.zero
        var topX = startX
        var bottomX = startX
        var addUp: Int = 0
        var sum: Int = 0
        for (offset: i, element: (number: number, color: color)) in drawInfo.enumerated() {
            let ratio =  CGFloat(number) / CGFloat(total)
            let length = ratio * barRect.width
            let drawFrame = CGRect(x: startX, y: barRect.minY, width: length, height: barRect.height)
            startX += length
            
            if focusIndex != nil && i == focusIndex {
                focusFrame = drawFrame
                continue
            }
            
            // draw
            color.setFill()
            UIBezierPath(rect:drawFrame).fill()

            if showPercent {
                var rectRemained = CGRect.zero
                if i % 2 == 0 {
                    // bottom
                    rectRemained = CGRect(x: bottomX, y: drawFrame.maxY, width: startX - bottomX, height: bounds.height - drawFrame.maxY)
                    bottomX = startX
                }else {
                    rectRemained = CGRect(x: topX, y: 0, width: startX - topX, height: drawFrame.minY)
                    topX = startX
                }
                
                var display = Int(nearbyint(ratio * 100))
                if i != drawInfo.count - 1 {
                    addUp += display
                    sum += number
                }else {
                    // last one
                    if sum + number  == total {
                        display = 100 - addUp
                    }
                }
                
                drawString(NSAttributedString(string: "\(display)%", attributes: [.foregroundColor: UIColorFromRGB(88, green: 89, blue: 91), .font: UIFont.systemFont(ofSize: rectRemained.height * 0.8, weight: .medium)]), inRect: rectRemained, alignment: .right)
            }
        }
   
        if showPercent {
            backPath.lineWidth = fontFactor
            UIColor.black.setStroke()
            backPath.stroke()
        }
        
        // focusedIndex
        if focusIndex != nil {
            let mask = backPath.copy() as! UIBezierPath
            UIColor.black.withAlphaComponent(0.3).setFill()
            mask.fill()
            
            let ctx = UIGraphicsGetCurrentContext()
            ctx?.saveGState()
            ctx?.setShadow(offset: CGSize.zero, blur: fontFactor * 3, color: UIColor.black.withAlphaComponent(0.8).cgColor)
            ctx?.setFillColor(drawInfo[focusIndex].color.cgColor)
            ctx?.fill(focusFrame)
            ctx?.restoreGState()
            
            UIColor.black.setStroke()
            let focusPath = UIBezierPath(rect: focusFrame.insetBy(dx: fontFactor * 0.5, dy: fontFactor * 0.5))
            focusPath.lineWidth = fontFactor
            focusPath.stroke()
            
            // triangle
            let triH = bottom * 0.26
            let bottomTextH = bottom - triH - fontFactor
            let arrowPath = UIBezierPath()
            arrowPath.move(to: CGPoint(x: focusFrame.midX, y: focusFrame.maxY + fontFactor))
            arrowPath.addLine(to: CGPoint(x: focusFrame.midX - triH * 0.5, y: bounds.height - bottomTextH))
            arrowPath.addLine(to: CGPoint(x: focusFrame.midX + triH * 0.5, y: bounds.height - bottomTextH))
            arrowPath.close()
            UIColor.black.setFill()
            arrowPath.fill()
            
            // match string
            let percent = drawInfo.isEmpty ? 0 : CGFloat(drawInfo[focusIndex].number) / CGFloat(total) * 100
            let resultText = "\(Int(nearbyint(percent)))% Card Match Rate"
            let resultS = NSAttributedString(string: resultText, attributes: [ .font: UIFont.systemFont(ofSize: bottomTextH * 0.8, weight: .medium)])
            let textW = resultS.boundingRect(with: CGSize(width: barRect.width, height: bottomTextH), options: .usesLineFragmentOrigin, context: nil).width
            var textX = max(focusFrame.midX - textW * 0.5, left)
            if focusFrame.midX + textW * 0.5 > barRect.maxX {
                textX = barRect.maxX - textW
            }

            resultS.draw(at: CGPoint(x: textX, y: bounds.height - bottomTextH))
        }
    }
}
