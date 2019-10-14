//
//  StampView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/7/31.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class StampView: UIView {
    var mainColor = UIColor.cyan {
        didSet{
            setNeedsDisplay()
        }
    }
    var text = "iRa" {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override var frame: CGRect {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
   
        let one = min(bounds.height, bounds.width) / 35
        let offset: CGFloat = 0.01
        var points = [CGPoint]()
        for i in 0..<8 {
            let rand = (arc4random() % 2 == 0)
            let angle = CGFloat(i) * CGFloat(Double.pi) * 2 / 8 + (rand ? offset : -offset)
            let point = Calculation.getPositionByAngle(angle, radius: min(bounds.midX, bounds.midY) - one * 0.5, origin: CGPoint(x: bounds.midX, y: bounds.midY))
            points.append(point)
        }
        
        let stampPath = UIBezierPath()
        stampPath.lineCapStyle = .round
        stampPath.lineCapStyle = .round
        
        stampPath.move(to: points[0])
        for (i, point) in points.enumerated() {
            var next = points.first!
            if i != points.count - 1 {
                next = points[i + 1]
            }
            
            var cx = (next.x + point.x) * 0.55
            if next.x > bounds.midX {
                cx = (next.x + point.x) * 0.48
            }
            
            let control = CGPoint(x: cx, y: (next.y + point.y) * 0.5)
            stampPath.addCurve(to: next, controlPoint1: control, controlPoint2: control)
        }
        
        stampPath.close()
       
        
        UIColor.white.setFill()
        stampPath.fill()
        
        mainColor.withAlphaComponent(0.4).setFill()
        stampPath.fill()
        mainColor.setStroke()
        stampPath.lineWidth = one
        stampPath.stroke()
        
        // text
        let length = min(bounds.height, bounds.width) / sqrt(2)
        let textRect = CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY), width: length, height: length)
        let attributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor : UIColor.white, .font: UIFont.systemFont(ofSize: 12 * one, weight: .bold), .strokeColor: mainColor, .strokeWidth: NSNumber(value: 10)])
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 20 * one, weight: .bold)], range: NSMakeRange(1, 1))
        drawString(attributedString, inRect: textRect, alignment: .center)
        
        attributedString.removeAttribute(.strokeColor, range: NSMakeRange(0, text.count))
        attributedString.removeAttribute(.strokeWidth, range: NSMakeRange(0, text.count))
        drawString(attributedString, inRect: textRect, alignment: .center)
    }
}
