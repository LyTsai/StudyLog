//
//  VitaminDChooseView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/18.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VitaminDLevelChooseView: UIView {
    fileprivate var ballColor = UIColor.red
    fileprivate var fillColor = UIColor.white
    fileprivate var blankRatio: CGFloat = 0
    
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
        self.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.numberOfLines = 0
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let lineWidth = min(bounds.height / 35, bounds.width / 259)
        let textRect = CGRect(x: bounds.height * 0.9, y: 0, width: bounds.width - bounds.height * 0.9 - 20 * lineWidth, height: bounds.height).insetBy(dx: 0, dy: lineWidth)
        label.frame = textRect
        label.font = UIFont.systemFont(ofSize: 12 * lineWidth, weight: .medium)
        
        setNeedsDisplay()
    }
    
    func setupWithFillColor(_ fillColor: UIColor, ballColor: UIColor, text: String, blankRatio: CGFloat, chosen: Bool) {
        self.fillColor = fillColor
        self.ballColor = ballColor
        self.blankRatio = blankRatio
        
        label.text = text
        label.backgroundColor = chosen ? UIColor.clear : UIColor.white
    }

    override func draw(_ rect: CGRect) {
        let radius = bounds.midY * 25 / 35
        let ballCenter = CGPoint(x: radius, y: bounds.midY)
        let lineWidth = min(bounds.height / 35, bounds.width / 259)
        
        // back
        let backRect = CGRect(x: bounds.height - radius, y: 0, width: bounds.width - bounds.height + radius, height: bounds.height)
        let backPath = UIBezierPath(roundedRect: backRect, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 4 * lineWidth, height: 4 * lineWidth))
        backPath.move(to: backRect.origin)
        let controlP = CGPoint(x:0, y: backRect.midY)
        backPath.addCurve(to: backRect.bottomLeftPoint, controlPoint1: controlP, controlPoint2: controlP)
        
        fillColor.setFill()
        backPath.fill()
        
        let ball = UIBezierPath(arcCenter: ballCenter, radius: radius, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
        ballColor.setFill()
        ball.fill()

        // white blank
        if abs(blankRatio) > 1e-6 {
            let tAngle = 2 * CGFloat(Double.pi) * blankRatio * 0.5
            let leftA = 1.5 * CGFloat(Double.pi) - tAngle
            let rightA = 1.5 * CGFloat(Double.pi) + tAngle
            let unFill = UIBezierPath(arcCenter: ballCenter, radius: radius - lineWidth, startAngle: leftA, endAngle: rightA, clockwise: true)
            unFill.close()
  
            UIColor.white.setFill()
            unFill.fill()
        }
        
        if abs(1 - blankRatio) < 1e-6 {
            drawString(NSAttributedString(string: "?", attributes: [ .font: UIFont.systemFont(ofSize: 14 * lineWidth, weight: .medium)]), inRect: CGRect(center: ballCenter, length: 2 * radius))
        }
    }
}
