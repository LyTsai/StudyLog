//
//  PanelExplain.swift
//  AnnielyticX
//
//  Created by iMac on 2018/7/27.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class PanelExplain: UIView {
    var horizontal = true
    var textColor = UIColorGray(155)
    var fontRatio: CGFloat = 0.9
    var explainInfo = [(UIColor, String)]() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if explainInfo.count == 0 {
            return
        }

        let number = CGFloat(explainInfo.count)
        let boxL = bounds.height / 3
        let gap = horizontal ? boxL * 0.4 : (explainInfo.count == 1 ? 0 : (bounds.height - boxL * number) / (number - 1))
        let spaceW = (bounds.width + gap) / number - gap
        
        let para = NSMutableParagraphStyle()
        para.alignment = .center
        para.lineBreakMode = .byWordWrapping
        
        let textAttributes = [NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: boxL * fontRatio, weight: UIFont.Weight.medium), NSAttributedStringKey.paragraphStyle: para]
        for (i, info) in explainInfo.enumerated() {
            let startX = CGFloat(i) * (spaceW + gap)
            let startY = CGFloat(i) * (boxL + gap)
            
            // draw box
            let boxX = horizontal ? startX + spaceW * 0.5 - boxL * 0.5 : 0
            let boxY = horizontal ? 0 : startY
            let boxRect = CGRect(x: boxX, y: boxY, width: boxL, height: boxL)
       
            let path = UIBezierPath(rect: boxRect)
            info.0.setFill()
            path.fill()
            
            // text
            let textX = horizontal ? startX : boxL * 1.5
            let textY = horizontal ? boxL + gap : startY
            let textRect = CGRect(x: textX, y: textY, width: horizontal ? spaceW : bounds.width - textX, height: horizontal ? (bounds.height - textY) : boxL)
            drawString(NSAttributedString(string: info.1, attributes: textAttributes), inRect: textRect, alignment: horizontal ? .center : .left)
        }
    }
}
