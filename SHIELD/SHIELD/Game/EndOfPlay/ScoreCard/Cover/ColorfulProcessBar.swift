//
//  ColorfulProcessBar.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/27.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class ColorfulProcessBar: UIView {
    fileprivate var drawInfo = [(UIColor, CGFloat)]()
    fileprivate var current: CGFloat = 0
    fileprivate var currentColor = UIColor.white
    func setWithDrawInfo(_ drawInfo: [(UIColor, CGFloat)], current: CGFloat, currentColor: UIColor) {
        self.backgroundColor = UIColor.clear
        
        self.drawInfo = drawInfo
        self.current = current
        self.currentColor = currentColor
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if drawInfo.isEmpty {
            return
        }
        
        let lineWidth = bounds.height / 16
        let barFrame = bounds.insetBy(dx: lineWidth * 0.5, dy: bounds.height * 0.24)

        // bar
        let maxNumber = drawInfo.last!.1
        for (i, (color, number)) in drawInfo.reversed().enumerated() {
            let barWidth = number / maxNumber * barFrame.maxX + barFrame.minX
            let barRect = CGRect(x: barFrame.minX, y: barFrame.minY, width: barWidth, height: barFrame.height)
            let path = UIBezierPath(roundedRect: barRect, byRoundingCorners: i == 0 ? [.topRight, .bottomRight] : (i == drawInfo.count - 1 ? [.topLeft, .bottomLeft] : []), cornerRadii: CGSize(width: barRect.height * 0.5, height: barRect.height * 0.5))
            color.setFill()
            path.fill()
        }
        
        // border
        let border = UIBezierPath(roundedRect: barFrame, cornerRadius: barFrame.height * 0.5)
        border.lineWidth = lineWidth
        UIColor.black.setStroke()
        border.stroke()
        
        // current
        let currentRatio = min(1, current / maxNumber)
        let currentWidth = bounds.height * 0.4
        let currentX = max(barFrame.minX, min(barFrame.maxX - currentWidth , currentRatio * barFrame.width + barFrame.minX))
        let currentFrame = CGRect(x: currentX, y: 0, width: currentWidth, height: bounds.height).insetBy(dx: 0, dy: lineWidth * 0.5)
        let currentPath = UIBezierPath(rect: currentFrame)
        currentPath.lineWidth = lineWidth
        
        currentColor.setFill()
        currentPath.fill()
        currentPath.stroke()
    }
}
