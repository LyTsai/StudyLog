//
//  FlowerView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/3/5.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class FlowerView: UIView {
    var attaches = [UIView]()
    
    var lineColor = UIColor.purple
    var lineWidth: CGFloat = 4

 
    func drawFlower(_ sAngle: CGFloat, number: Int, lineColor: UIColor, petalColor: UIColor, lineWidth: CGFloat, length: CGFloat, center: CGPoint) {
        if number <= 0 {
            return
        }
        
        let alpha = 2 * CGFloat(Double.pi) / CGFloat(number)
        let R = length / (1 / cos(alpha * 0.5) + tan(alpha * 0.5))
        let r = R * tan(alpha * 0.5)
        
        let petalPath = UIBezierPath()
        for i in 0..<number {
            let start = sAngle + CGFloat(i) * alpha
           
            petalPath.move(to: center)
            petalPath.addLine(to: getPoint(center, radius: R, angle: start))
    
            let arcStart = -CGFloat(Double.pi) * 0.5 + start
            petalPath.addArc(withCenter: getPoint(center, radius: R / cos(alpha * 0.5), angle: start + alpha * 0.5), radius: r, startAngle: arcStart, endAngle: arcStart + CGFloat(Double.pi) + alpha , clockwise: true)
            
            petalPath.close()
        }
        
        petalPath.lineJoinStyle = .round

        petalPath.lineWidth = lineWidth
        lineColor.setStroke()
        petalColor.setFill()
        
        // seq
        petalPath.fill()
        petalPath.stroke()
    }
    
    fileprivate func getPoint(_ offset: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: offset.x + radius * cos(angle), y: offset.y + radius * sin(angle))
    }
    
    override func draw(_ rect: CGRect) {
        drawFlower(0, number: 6, lineColor: lineColor, petalColor: UIColor.white, lineWidth: lineWidth, length: min(bounds.midX, bounds.midY) - lineWidth * 0.5, center: CGPoint(x: bounds.midX, y: bounds.midY))
    }
}

