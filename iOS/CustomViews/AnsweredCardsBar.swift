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
        let lineWidth = fontFactor
        let lineGap = lineWidth * 0.5
        UIColor.black.setStroke()
        
        let borderPath = UIBezierPath(roundedRect: bounds.insetBy(dx: lineGap, dy: lineGap), cornerRadius: bounds.height * 0.5 - lineGap)
        borderPath.lineWidth = lineWidth * 2
        UIColorGray(230).setFill()
        borderPath.fill()
        borderPath.addClip()
        
        var startX = lineGap
//        var focusFrame = CGRect.zero
        for (offset: i, element: (number: number, color: color)) in drawInfo.enumerated() {
            let length = CGFloat(number) / CGFloat(total) * (bounds.width - lineWidth)
    
            let drawFrame = CGRect(x: startX, y: lineGap, width: length, height: bounds.height - lineWidth)
            startX += length
 
            // draw
            let path = UIBezierPath(rect:drawFrame)
            path.lineWidth = lineWidth

            (i == focusIndex ? color : color.withAlphaComponent(0.3)).setFill()
            
            path.fill()
            path.stroke()
            
            // pattern
            if i == focusIndex {
                if let decoImage = UIImage(named: "right_arrow") {
                    let whRatio = decoImage.size.width / decoImage.size.height
                    let expectHeight = drawFrame.height
                    decoImage.changeImageSizeTo(CGSize(width: expectHeight * whRatio, height: expectHeight), alpha: 1).drawAsPattern(in: drawFrame)
                }
            }
        }
   
        borderPath.stroke()
    }
}
