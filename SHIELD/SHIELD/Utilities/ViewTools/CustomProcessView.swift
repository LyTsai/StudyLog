//
//  CustomProcessView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/28.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CustomProcessView: UIView {
    var withBorder = true
    var processVaule: CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override var frame: CGRect {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var processColor = UIColor.blue {
        didSet{
            setNeedsLayout()
        }
    }
    class func setupWithProcessColor(_ processColor: UIColor) -> CustomProcessView {
        let process = CustomProcessView()
        process.backgroundColor = UIColorGray(216)
        process.processColor = processColor
        return process
    }
    
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.clear
        
        let lineWidth = bounds.height / 8
        // background
        let barRect = withBorder ?  bounds.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5): bounds
        let backPath = UIBezierPath(roundedRect: barRect, cornerRadius: bounds.height * 0.5 - (withBorder ? lineWidth * 0.5 : 0))
        UIColorGray(216).setFill()
        backPath.fill()
        
        // processValue
        let value = min(1, max(0, processVaule))
        if value == 0 {
            return
        }
        let processPath = UIBezierPath()
        let processH =  bounds.height - (withBorder ? lineWidth : 0)
        processPath.move(to: CGPoint(x: processH * 0.5, y: bounds.midY))
        processPath.addLine(to: CGPoint(x: (barRect.width - processH) * value + processH * 0.5, y: bounds.midY))
        processPath.lineWidth = processH
        processPath.lineCapStyle = .round
        processColor.setStroke()
        processPath.stroke()
        
        if withBorder {
            backPath.lineWidth = lineWidth
            UIColor.black.setStroke()
            backPath.stroke()
        }
    }
}
