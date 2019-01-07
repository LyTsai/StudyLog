//
//  VitaminDChooseView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/18.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VitaminDLevelChooseView: UIView {
    var mainColor = UIColor.red
    var fillColor = UIColor.white
    var text = "" {
        didSet{
            label.text = text
        }
    }
    var blankRatio: CGFloat = 0
    
    fileprivate let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate func setupBasic() {
        label.textAlignment = .center
        label.numberOfLines = 0
        backgroundColor = UIColor.clear
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = bounds.midY * 25 / 35
        let lineWidth = bounds.height / 35
        
        let textRect = CGRect(x: radius * 2 + bounds.height , y: 0, width: bounds.width - 2 * radius - 2 * bounds.height, height: bounds.height).insetBy(dx: lineWidth, dy: lineWidth)
        label.frame = textRect
        label.font = UIFont.systemFont(ofSize: bounds.height * 0.28, weight: UIFontWeightMedium)
        
        setNeedsDisplay()
    }
    
    func setupWithColor(_ color: UIColor, text: String, blankRatio: CGFloat) {
        mainColor = color
        self.text = text
        self.blankRatio = blankRatio
    }

    override func draw(_ rect: CGRect) {
        let radius = bounds.midY * 25 / 35
        let ballCenter = CGPoint(x: radius + bounds.height, y: bounds.midY)
        let lineWidth = bounds.height / 35
        
        mainColor.setStroke()
        
        let backRect = UIBezierPath(roundedRect: CGRect(x: ballCenter.x, y: lineWidth * 0.5, width: bounds.width - lineWidth * 0.5 - ballCenter.x - bounds.height, height: bounds.height - lineWidth), cornerRadius: lineWidth * 4)
        backRect.lineWidth = lineWidth
        fillColor.setFill()
        backRect.fill()
        backRect.stroke()
        
        let ball = UIBezierPath(arcCenter: ballCenter, radius: radius, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
        mainColor.setFill()
        ball.fill()
        
        // shadow
//        let ctx = UIGraphicsGetCurrentContext()
//        ctx?.saveGState()
//        
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let gradient = CGGradient(colorsSpace: colorSpace, colors: [UIColor.white.withAlphaComponent(0.4).cgColor, UIColor.black.withAlphaComponent(0.3).cgColor] as CFArray, locations: [0, 1])
//        let radialC = CGPoint(x: ballCenter.x, y: ballCenter.y * 0.8)
//        ctx?.drawRadialGradient(gradient!, startCenter: radialC, startRadius: radius * 0.2, endCenter: radialC, endRadius: radius * 0.8, options: .drawsBeforeStartLocation)
//        
//        ctx?.restoreGState()
        
        // white blank
        if abs(blankRatio) > 1e-6 {
            let tAngle = 2 * CGFloat(Double.pi) * blankRatio * 0.5
            let leftA = 1.5 * CGFloat(Double.pi) - tAngle
            let rightA = 1.5 * CGFloat(Double.pi) + tAngle
            let unFill = UIBezierPath(arcCenter: ballCenter, radius: radius - lineWidth, startAngle: leftA, endAngle: rightA, clockwise: true)
            unFill.close()
            //        unFill.addCurve(to: Calculation().getPositionByAngle(leftA, radius: radius - lineWidth, origin: ballCenter), controlPoint1: <#T##CGPoint#>, controlPoint2: <#T##CGPoint#>)
            fillColor.setFill()
            unFill.fill()
        }
        
        if abs(1 - blankRatio) < 1e-6 {
            drawString(NSAttributedString(string: "?", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: bounds.height * 0.5, weight: UIFontWeightMedium)]), inRect: CGRect(center: ballCenter, length: 2 * radius))
        }
    }
}
