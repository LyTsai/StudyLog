//
//  ThickCircleView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/7.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class ThickCircleView: UIView {
    var borderColor = UIColor.black
    var circleColor = UIColorFromRGB(126, green: 211, blue: 33)
    var innerColor = UIColor.white
    var outerWidth: CGFloat = 10
    var circleWidth: CGFloat = 39
  
    override func draw(_ rect: CGRect) {
        let viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.midX, bounds.midY)
        
        // color part
        let path = UIBezierPath(arcCenter: viewCenter, radius: radius - outerWidth * 0.5, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
        path.lineWidth = outerWidth
        circleColor.setFill()
        borderColor.setStroke()
        path.stroke()
        path.fill()
        
        // inner background
        // with shadow
        let innerPath = UIBezierPath(arcCenter: viewCenter, radius: radius - outerWidth - circleWidth, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)

        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()

        context?.setShadow(offset: CGSize.zero, blur: circleWidth * 0.8, color: UIColor.black.cgColor)

        innerColor.setFill()
        innerPath.fill()

        context?.restoreGState()
    }
}


