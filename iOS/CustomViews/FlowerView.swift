//
//  FlowerView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/3/5.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class FlowerView: UIView {
    var number: Int = 6
    
    var lineColor = UIColor.purple
    var petalColor = UIColor.white
    var lineWidth: CGFloat = 4
    
    fileprivate var buttons = [CustomButton]()
    func loadWithFrame(_ frame: CGRect, customButtons: [CustomButton], lineColor: UIColor, lineWidth: CGFloat) {
        self.backgroundColor = UIColor.clear
        
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons.removeAll()
        
        buttons = customButtons
        
        self.frame = frame
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        
        for button in customButtons {
            addSubview(button)
        }
        number = buttons.count
        setNeedsDisplay()
    }
    
    // drawRect
    override func draw(_ rect: CGRect) {
        var first: CGFloat = 0
        if number != 0 {
            let half = CGFloat(Double.pi) / CGFloat(number)
            if number % 2 == 0 {
                first = -half
            }else {
                first = -CGFloat(Double.pi) / 2 - half
            }
        }
        drawFlower(first, lineColor: lineColor, petalColor: petalColor, lineWidth: lineWidth, length: min(bounds.midX, bounds.midY) - lineWidth * 0.5, center: CGPoint(x: bounds.midX, y: bounds.midY))
    }
    
    fileprivate func getPoint(_ offset: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: offset.x + radius * cos(angle), y: offset.y + radius * sin(angle))
    }
    
    fileprivate func drawFlower(_ sAngle: CGFloat, lineColor: UIColor, petalColor: UIColor, lineWidth: CGFloat, length: CGFloat, center: CGPoint) {
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
            let arcCenter = getPoint(center, radius: R / cos(alpha * 0.5), angle: start + alpha * 0.5)
            petalPath.addArc(withCenter: arcCenter, radius: r, startAngle: arcStart, endAngle: arcStart + CGFloat(Double.pi) + alpha , clockwise: true)
            
            petalPath.close()
            
            if buttons.count == number {
                // button is added
                buttons[i].frame = CGRect(center: arcCenter, length: r * sqrt(2))
                buttons[i].verticalWithRatio(0.5, fontRatio: 0.25)
            }
        }
        
        petalPath.lineJoinStyle = .round
        
        petalPath.lineWidth = lineWidth
        lineColor.setStroke()
        petalColor.setFill()
        
        // seq
        petalPath.fill()
        petalPath.stroke()
    }
}
