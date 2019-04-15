//
//  CloudTopView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/27.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class CloudTopView: UIView {
    var shadowColor = WHATIF ? UIColor.clear : UIColorFromRGB(255, green: 187, blue: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.white.setFill()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.height * 0.8))
        path.addCurve(to: CGPoint(x: 0.2 * bounds.width, y: bounds.height), controlPoint1: CGPoint(x: 0.06 * bounds.width, y: bounds.height * 0.7), controlPoint2: CGPoint(x: 0.14 * bounds.width, y: bounds.height * 0.7))
        path.addCurve(to: CGPoint(x: 0.6 * bounds.width, y:  bounds.height * 0.95), controlPoint1: CGPoint(x: 0.35 * bounds.width, y: bounds.height * 0.5), controlPoint2: CGPoint(x: 0.45 * bounds.width, y: bounds.height * 0.5))
        path.addCurve(to: CGPoint(x: 0.8 * bounds.width, y: bounds.height), controlPoint1: CGPoint(x: 0.65 * bounds.width, y:bounds.height * 0.7), controlPoint2: CGPoint(x: 0.75 * bounds.width, y: bounds.height * 0.7))
        path.addCurve(to: CGPoint(x: bounds.width, y: bounds.height), controlPoint1: CGPoint(x: 0.85 * bounds.width, y: bounds.height * 0.7), controlPoint2: CGPoint(x: 0.95 * bounds.width, y: bounds.height * 0.7))
        
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: 0, y: bounds.maxY))
        path.close()
        
        
        // cloud shadow
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        
        ctx?.setShadow(offset: CGSize(width: 0, height: -4 * standHP), blur: 12 * standHP, color: shadowColor.cgColor)
        path.fill()
        
        ctx?.restoreGState()
    }
}
