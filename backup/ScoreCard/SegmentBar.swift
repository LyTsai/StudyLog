//
//  SegmentBar.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/1/9.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class SegmentBar: UIView {
    fileprivate var info = [(color: UIColor, number: Int, text: String)]()
    fileprivate var total: Int = 0
    fileprivate var usePercent = true
    fileprivate var withPatter = true
    func setupWithInfo(_ info: [(color: UIColor, number: Int, text: String)], usePercent: Bool) {
        backgroundColor = UIColor.clear
        
        // assign
        self.info = info
        self.usePercent = usePercent
 
        total = 0
        for i in info {
            total += i.number
        }
        
        // layout
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if total == 0 {
            return
        }
        
        // frames
        let barHeight = bounds.height * 0.18
        let barMinY = (bounds.height - barHeight) * 0.5
        let textHeight = bounds.height * 0.15
        let numberHeight = barMinY - textHeight
        let gap = bounds.width * 0.01
        let lineWidth = fontFactor
        
        var processX: CGFloat = lineWidth
        var upX: CGFloat = 0
        var downX: CGFloat = 0
        
        // attributes
        let numberAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: numberHeight * 0.8), NSForegroundColorAttributeName: UIColor.black]
        let textAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: textHeight * 0.9), NSForegroundColorAttributeName: UIColor.black.withAlphaComponent(0.6)]
        
        // draw
        UIColor.black.setStroke()
        
        var adjustT: Int = 100
        for (i, a) in info.enumerated() {
            let ratio = CGFloat(a.number) / CGFloat(total)
            var barWidth = ratio * bounds.width
            // bar and line
            var roundingCorners: UIRectCorner = []
            if info.count == 1 {
                roundingCorners = [.allCorners]
                barWidth -= 2 * lineWidth
            }else if i == 0 {
                roundingCorners = [.topLeft, .bottomLeft]
                barWidth -= lineWidth
            }else if i == info.count - 1 {
                roundingCorners = [.bottomRight, .topRight]
                barWidth -= lineWidth
            }
            
            let path = UIBezierPath(roundedRect: CGRect(x: processX, y: barMinY, width: barWidth, height: barHeight), byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: barHeight * 0.5, height: barHeight * 0.5))
            
            a.color.setFill()
            
            path.lineWidth = lineWidth
            path.fill()
            
            // pattern image on bars
            let image = UIImage(named: "indi_left")!
            let whRatio = image.size.width / image.size.height
            image.changeImageSizeTo(CGSize(width: whRatio * barHeight, height: barHeight), alpha: 0.5).drawAsPattern(in: CGRect(x: processX, y: barMinY, width: barWidth, height: barHeight))
        
            path.stroke()


            // line
            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: processX + barWidth, y: i % 2 == 0 ? 0 : bounds.height))
            linePath.addLine(to: CGPoint(x: processX + barWidth, y: i % 2 == 0 ? barMinY + barHeight: barMinY))
            linePath.setLineDash([2 * fontFactor, fontFactor], count: 1, phase: 1)
            linePath.lineWidth = lineWidth * 0.5
            linePath.stroke()
            
            // texts
            let startX = i % 2 == 0 ? upX : downX
            let space = processX + barWidth - gap - startX
            
            let number = (i == info.count - 1)  ? adjustT : Int(roundf(Float(ratio * 100)))
            
            drawString(NSAttributedString(string: usePercent ? "\(number)%" : "\(a.number)", attributes: numberAttributes), inRect: CGRect(x: startX, y: i % 2 == 0 ? textHeight : barMinY + barHeight, width: space, height: numberHeight), alignment: .right)
            drawString(NSAttributedString(string: a.text, attributes: textAttributes), inRect: CGRect(x: startX, y: i % 2 == 0 ? 0 : barMinY + barHeight + numberHeight, width: space, height: textHeight), alignment: .right)
            
            // process
            processX += barWidth
            if i % 2 == 0 {
                upX += barWidth
            }else {
                downX += barWidth
            }
            
            adjustT -= number
        }
    }
}
