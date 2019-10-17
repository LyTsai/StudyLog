//
//  PanelExplain.swift
//  AnnielyticX
//
//  Created by iMac on 2018/7/27.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class PanelExplain: UIView {
    var textColor = UIColor.black
    var explainInfo = [(UIColor, String)]() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    // horizontal blocks
    override func draw(_ rect: CGRect) {
        if explainInfo.isEmpty {
            return
        }
        
        let fontRatio:CGFloat = explainInfo.count > 3 ? 0.65 : 0.75
        
        let number = CGFloat(explainInfo.count)
        let gap = bounds.width * 0.02
        let oneWidth = (bounds.width - gap * (number - 1)) / number
        let boxL = min(bounds.height / 3, oneWidth)
        
        // textPara
        let para = NSMutableParagraphStyle()
        para.alignment = .center
        para.lineBreakMode = .byWordWrapping
        
        for (i, info) in explainInfo.enumerated() {
            // draw box
            let startX = CGFloat(i) * (oneWidth + gap)
            let boxRect = CGRect(x: startX + oneWidth * 0.5 - boxL * 0.5, y: 0, width: boxL, height: boxL)
       
            let path = UIBezierPath(rect: boxRect)
            info.0.setFill()
            path.fill()
            
            // text
            let textRect = CGRect(x: startX, y: boxL, width: oneWidth, height: bounds.height - boxL)
            drawString(NSAttributedString(string: info.1, attributes: [.foregroundColor: textColor, .font: UIFont.systemFont(ofSize: boxL * fontRatio, weight: .medium), .paragraphStyle: para]), inRect: textRect, alignment: .center)
        }
    }
}
