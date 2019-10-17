//
//  ArcButtonsView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/3.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
 /*
 1. the bottom-center is the center of arc
 2. the height is the maxRadius, the outer border
 3. angle position is the center angle
 */

class ArcButtonsView: UIView {
    // calculated
    // as center
    fileprivate var vertex: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    fileprivate var maxRadius: CGFloat {
        return bounds.height * 0.5
    }
    
    var buttons = [CustomButton]()
    
    fileprivate let floatPi = CGFloat(Double.pi)
    fileprivate var leftAngle: CGFloat = 1.57
    fileprivate var rightAngle: CGFloat = 0
    fileprivate var midRadius: CGFloat {
        return (minRadius + maxRadius) * 0.5
    }
    fileprivate var minRadius: CGFloat = 0
    func setRectBackWithFrame(_ frame: CGRect, buttons: [CustomButton], minRadius: CGFloat) {
        if buttons.count <= 1  {
            return
        }

        // assgin
        self.frame = frame
        self.minRadius = minRadius
        self.buttons = buttons
        
        backgroundColor = UIColor.clear
        let totalAngle = min(sinh(frame.width * 0.5 / midRadius) * 2, CGFloatPi * 0.6)
        let arcNumber = CGFloat(buttons.count - 1)
        // angle
        let angleGap = totalAngle / arcNumber
        let buttonLength = Calculation.inscribeSqureLength(angleGap, radius: midRadius) * 1.07
        rightAngle = -(floatPi - totalAngle) * 0.5 - angleGap * 0.5
        leftAngle = -floatPi - rightAngle
        
        // buttons
        var centerAngle = leftAngle
        for (i, button) in buttons.enumerated() {
            var buttonCenter = Calculation.getPositionByAngle(centerAngle, radius: midRadius, origin: vertex)
            let buttonSize = CGSize(width: buttonLength, height: buttonLength * 50 / 64)
            if i == buttons.count - 1 {
                let iAaFrame = buttons[i - 1].frame
                buttonCenter = CGPoint(x: iAaFrame.midX, y: iAaFrame.midY - iAaFrame.height - 4 * fontFactor)
            }
            button.adjustRiskTypeButtonWithFrame(CGRect(center: buttonCenter, width: buttonSize.width, height: buttonSize.height))

            // add and move to next
            addSubview(button)
            centerAngle += angleGap
        }
        
        // draw lines
        setNeedsDisplay()
    }

    // true is hide
    func setButtonsHidden(_ hide: Bool) {
        if hide {
            transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            transform = transform.translatedBy(x: 0, y: midRadius * 0.5)
        }else {
            transform = CGAffineTransform.identity
        }
        isUserInteractionEnabled = !hide
    }
    
    var hideLine = false
    override func draw(_ rect: CGRect) {
        if !hideLine {
            let path = UIBezierPath(arcCenter: vertex, radius: midRadius, startAngle: leftAngle, endAngle: rightAngle, clockwise: true)
            
            path.move(to: CGPoint(x: vertex.x, y: vertex.y - minRadius))
            path.addLine(to: CGPoint(x: vertex.x, y: vertex.y - midRadius))
            
            path.lineWidth = 2.5
            UIColor.white.setStroke()
            path.stroke()
        }
    }
}
