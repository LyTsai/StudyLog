//
//  CloudTopView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/27.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class CloudTopView: UIView {
//    var xRatio: [CGFloat] = [0.2, 0.6, 0.8]
    var bottomY: CGFloat = 0.1
    var shadowColor = UIColor.orange
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bottomY * bounds.height * 0.8))
        path.addCurve(to: CGPoint(x: 0.2 * bounds.width, y: bottomY * bounds.height), controlPoint1: CGPoint(x: 0.06 * bounds.width, y: bottomY * bounds.height * 0.5), controlPoint2: CGPoint(x: 0.14 * bounds.width, y: bottomY * bounds.height * 0.5))
        path.addCurve(to: CGPoint(x: 0.6 * bounds.width, y: bottomY * bounds.height * 0.95), controlPoint1: CGPoint(x: 0.35 * bounds.width, y: bottomY * bounds.height * 0.2), controlPoint2: CGPoint(x: 0.45 * bounds.width, y: bottomY * bounds.height * 0.2))
        path.addCurve(to: CGPoint(x: 0.8 * bounds.width, y: bottomY * bounds.height), controlPoint1: CGPoint(x: 0.65 * bounds.width, y: bottomY * bounds.height * 0.5), controlPoint2: CGPoint(x: 0.75 * bounds.width, y: bottomY * bounds.height * 0.5))
        path.addCurve(to: CGPoint(x: bounds.width, y: bottomY * bounds.height), controlPoint1: CGPoint(x: 0.85 * bounds.width, y: bottomY * bounds.height * 0.5), controlPoint2: CGPoint(x: 0.95 * bounds.width, y: bottomY * bounds.height * 0.5))
        
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: 0, y: bounds.maxY))
        path.close()
        
        UIColor.white.setFill()

        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        
        ctx?.setShadow(offset: CGSize(width: 0, height: -4), blur: 12, color: shadowColor.cgColor)
        path.fill()
        
        ctx?.restoreGState()
        
    }
    
}
