//
//  ThickCircleView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/7.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation
import UIKit
func UIColorFromRGB(_ red: Int, green: Int, blue: Int) -> UIColor {
    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
}

class ThickCircleView: UIView {
    var borderColor = UIColor.black
    var circleColor = UIColorFromRGB(126, green: 211, blue: 33)
    var innerColor = UIColor.white
    var outerWidth: CGFloat = 2
    var circleWidth: CGFloat = 6
  
    override func draw(_ rect: CGRect) {
        let viewCenter = CGPoint(x: bounds.midX, y: bounds.height)
        let radius = min(bounds.midX, bounds.midY)
        
        // color part
        let path = UIBezierPath(arcCenter: viewCenter, radius: radius - outerWidth * 0.5, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: true)
        circleColor.setFill()
        borderColor.setStroke()
        path.stroke()
        path.fill()
        
        // inner background
        // with shadow
        let innerPath = UIBezierPath(arcCenter: viewCenter, radius: radius - outerWidth - circleWidth, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: true)
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        context?.setShadow(offset: CGSize.zero, blur: circleWidth * 0.6, color: UIColor.black.cgColor)
       
        innerColor.setFill()
        innerPath.fill()
        
        context?.restoreGState()
    }
}


