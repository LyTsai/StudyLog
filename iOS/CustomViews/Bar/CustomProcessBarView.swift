//
//  CustomProcessBarView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/28.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class CustomProcessBarView: UIView {
    var unProcessedColor = UIColorFromHex(0xF0F1F3)
    var processedColor = UIColorFromHex(0x8BC34A)
    var barBorderColor = UIColorFromHex(0xCCCCCC)
    
    var currentValue: CGFloat {
        return value
    }
    
    fileprivate var value: CGFloat = 0
    func setupProcessValue(_ value: CGFloat) {
        self.backgroundColor = UIColor.clear
        self.value = value
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let lineWidth = bounds.height / 8
        let mainFrame = bounds.insetBy(dx: lineWidth, dy: lineWidth)
        let mainBarPath = UIBezierPath(roundedRect: mainFrame, cornerRadius: mainFrame.height * 0.5)
        
        // value
        let valueWidth = max(0, min(bounds.width * value, bounds.width))
        let valuePath = UIBezierPath(roundedRect: CGRect(x: mainFrame.minX, y: mainFrame.minY, width: valueWidth, height: mainFrame.height), cornerRadius: mainFrame.height * 0.5)
        
        // fill
        unProcessedColor.setFill()
        mainBarPath.fill()
        processedColor.setFill()
        valuePath.fill()
        
        // stroke
        barBorderColor.setStroke()
        mainBarPath.lineWidth = lineWidth
        mainBarPath.stroke()
    }
}
