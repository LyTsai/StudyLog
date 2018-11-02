//
//  AnsweredCardsBar.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/20.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
class AnsweredCardsBar: UIView {
    var showPercent = false
    fileprivate var drawInfo = [(number: Int, color: UIColor)]()
    fileprivate var total: Int = 0
    fileprivate var focusIndex: Int!
    var name = "Match rate"
    
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
    
    // draw
    override func draw(_ rect: CGRect) {
        let left = focusIndex != nil ? bounds.height * 4.8 : fontFactor * 0.5
        let right = focusIndex != nil ?  bounds.height * 2 : fontFactor * 0.5
        let top = showPercent ? bounds.height / 3: fontFactor * 0.5
        let bottom = showPercent ? bounds.height / 3 : fontFactor * 6
        
        // bars
        let barRect = CGRect(x: left, y: top, width: bounds.width - left - right, height: bounds.height - bottom - top)
        
        // bar
        let backPath = UIBezierPath(rect: barRect)
        UIColorGray(230).setFill()
        backPath.fill()

        
        var startX = barRect.minX
        var focusFrame = CGRect.zero
        var topX = startX
        var bottomX = startX
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
            
//            if showPercent {
//                drawString(NSAttributedString(string: "\(Int(nearbyint(ratio * 100)))%", attributes: [NSForegroundColorAttributeName: UIColorFromRGB(88, green: 89, blue: 91), NSFontAttributeName: UIFont.systemFont(ofSize: bounds.height * 0.24, weight: UIFontWeightMedium)]), inRect: CGRect(x: drawFrame.minX, y: drawFrame.maxY, width: drawFrame.width, height: bounds.height - drawFrame.maxY), alignment: .center)
//            }
            
            if showPercent {
//                CGRect(x: drawFrame.minX, y: drawFrame.maxY, width: drawFrame.width, height: bounds.height - drawFrame.maxY)
                var rectRemained = CGRect.zero
                if i % 2 == 0 {
                    // bottom
                    rectRemained = CGRect(x: bottomX, y: drawFrame.maxY, width: startX - bottomX, height: bounds.height - drawFrame.maxY)
                    bottomX = startX
                }else {
                     rectRemained = CGRect(x: topX, y: 0, width: startX - topX, height: drawFrame.minY)
                    topX = startX
                }
                
                drawString(NSAttributedString(string: "\(Int(nearbyint(ratio * 100)))%", attributes: [NSForegroundColorAttributeName: UIColorFromRGB(88, green: 89, blue: 91), NSFontAttributeName: UIFont.systemFont(ofSize: bounds.height * 0.3, weight: UIFontWeightMedium)]), inRect: rectRemained, alignment: .right)
            }
        }
   
        if showPercent {
            backPath.lineWidth = fontFactor
            UIColor.black.setStroke()
            backPath.stroke()
        }
        
        // focusedIndex
        if focusIndex != nil {
            let ctx = UIGraphicsGetCurrentContext()
            ctx?.saveGState()
            ctx?.setShadow(offset: CGSize(width: 0, height: top * 2), blur: top * 4, color: UIColor.black.withAlphaComponent(0.6).cgColor)
            ctx?.setFillColor(drawInfo[focusIndex].color.cgColor)
            ctx?.fill(focusFrame)
            ctx?.restoreGState()
            
            UIColor.black.setStroke()
            let focusPath = UIBezierPath(rect: focusFrame.insetBy(dx: top * 0.5, dy: top * 0.5))
            focusPath.lineWidth = top
            focusPath.stroke()
            
            let arrowPath = UIBezierPath()
            arrowPath.move(to: CGPoint(x: focusFrame.midX, y: focusFrame.maxY + top))
            arrowPath.addLine(to: CGPoint(x: focusFrame.midX - bottom * 0.5, y: bounds.height))
            arrowPath.addLine(to: CGPoint(x: focusFrame.midX + bottom * 0.5, y: bounds.height))
            arrowPath.close()
            UIColor.black.setFill()
            arrowPath.fill()
        
            // texts
            drawString(NSAttributedString(string: name, attributes: [NSForegroundColorAttributeName: UIColorGray(132), NSFontAttributeName: UIFont.systemFont(ofSize: bounds.height * 0.8, weight: UIFontWeightMedium)]), inRect: CGRect(x: 0, y: 0, width: left, height: bounds.height), alignment: .left)
            let percent = drawInfo.count == 0 ? 0 : CGFloat(drawInfo[focusIndex].number) / CGFloat(total) * 100
            drawString(NSAttributedString(string: "\(Int(nearbyint(percent)))%", attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: bounds.height * 0.8, weight: UIFontWeightMedium)]), inRect: CGRect(x: bounds.width - right, y: 0, width: right, height: bounds.height), alignment: .right)
        }
    }
}
