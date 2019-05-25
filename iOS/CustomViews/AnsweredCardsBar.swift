//
//  AnsweredCardsBar.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/20.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
class AnsweredCardsBar: UIView {
    fileprivate var drawInfo = [(number: Int, color: UIColor)]()
    fileprivate var total: Int = 0
    fileprivate var focusIndex: Int = 0
    var name = "Match rate"
    
    func setupWithDrawInfo(_ drawInfo: [(number: Int, color: UIColor)], totalNumber: Int, focusIndex: Int) {
        backgroundColor = UIColor.clear
        
        if focusIndex < 0 || focusIndex >= drawInfo.count {
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
        let left = bounds.height * 5
        let right = bounds.height * 2
        // texts
        drawString(NSAttributedString(string: name, attributes: [NSForegroundColorAttributeName: UIColorGray(132), NSFontAttributeName: UIFont.systemFont(ofSize: bounds.height * 0.8, weight: UIFontWeightMedium)]), inRect: CGRect(x: 0, y: 0, width: left, height: bounds.height), alignment: .left)
        let percent = drawInfo.count == 0 ? 0 : CGFloat(drawInfo[focusIndex].number) / CGFloat(total) * 100
        drawString(NSAttributedString(string: "\(Int(nearbyint(percent)))%", attributes: [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: bounds.height * 0.8, weight: UIFontWeightMedium)]), inRect: CGRect(x: bounds.width - right, y: 0, width: right, height: bounds.height), alignment: .right)
        
        // bars
        let shadowY = fontFactor
        let barRect = CGRect(x: left, y: shadowY * 0.5, width: bounds.width - left - right, height: bounds.height - shadowY * 4)
        let backPath = UIBezierPath(rect: barRect)
        UIColorGray(230).setFill()
        backPath.fill()
        
        var startX = barRect.minX
        var focusFrame = CGRect.zero
        for (offset: i, element: (number: number, color: color)) in drawInfo.enumerated() {
            let length = CGFloat(number) / CGFloat(total) * barRect.width
            let drawFrame = CGRect(x: startX, y: barRect.minY, width: length, height: barRect.height)
            startX += length
            
            if i == focusIndex {
                focusFrame = drawFrame
                continue
            }
            
            // draw
            color.setFill()
            UIBezierPath(rect:drawFrame).fill()
        }
   
        // shadow
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        ctx?.setShadow(offset: CGSize(width: 0, height: shadowY), blur: shadowY * 1.5, color: UIColor.black.withAlphaComponent(0.6).cgColor)
        ctx?.setFillColor(drawInfo[focusIndex].color.cgColor)
        ctx?.fill(focusFrame)
        ctx?.restoreGState()
        
        UIColor.black.setStroke()
        let focusPath = UIBezierPath(rect: focusFrame)
        focusPath.lineWidth = shadowY * 0.5
        focusPath.stroke()
    }
}
