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
    
    fileprivate let floatPi = CGFloat(Double.pi)
    fileprivate var leftAngle: CGFloat = 1.57
    fileprivate var rightAngle: CGFloat = 0
    fileprivate var midRadius: CGFloat {
        return (minRadius + maxRadius) * 0.5
    }
    fileprivate var minRadius: CGFloat = 0
    
    // set up and add
    func setupWithFrame(_ frame: CGRect, buttons: [CustomButton], minRadius: CGFloat, buttonGap: CGFloat, buttonScale: CGFloat) {
        if buttons.count == 0 {
            return
        }
        
        // assgin
        self.frame = frame
        self.minRadius = minRadius
        
        backgroundColor = UIColor.clear
        let maxAngle = sinh(frame.width * 0.5 / maxRadius) * 2
       
        // calculate
        var buttonLength = (maxRadius - minRadius) * buttonScale
        var buttonAngle = sinh(buttonLength * 0.5 / midRadius) * 2
        
        // angle
        var totalAngle = (buttonAngle + buttonGap) * CGFloat(buttons.count) - buttonGap
        if totalAngle > maxAngle {
            print("too many")
            
            totalAngle = maxAngle
            buttonAngle = (totalAngle - (CGFloat(buttons.count) - 1) * buttonGap) / CGFloat(buttons.count)

            buttonLength = 2 * sin(buttonAngle * 0.5) * maxRadius / (1 + sin(buttonAngle * 0.5))
//            self.minRadius = maxRadius - buttonLength
        }
        
        totalAngle -= buttonAngle
        rightAngle = -(floatPi - totalAngle) * 0.5
        leftAngle = rightAngle - totalAngle
        
        // buttons
        var centerAngle = leftAngle
        for button in buttons {
            let center = Calculation().getPositionByAngle(centerAngle, radius: self.midRadius, origin: vertex)
            button.frame = CGRect(center: center, length: buttonLength)

            // font adjust
            let labelAdjust = (1 - 1 / sqrt(2)) * buttonLength * 0.5
            button.labelFrame = button.bounds.insetBy(dx: labelAdjust, dy: labelAdjust)
            button.textFont = UIFont.systemFont(ofSize: buttonLength * 0.18, weight: UIFontWeightSemibold)
            
            // add and move to next
            addSubview(button)
            button.layer.addBlackShadow(4)
            centerAngle += (buttonAngle + buttonGap)
        }
        
        // draw lines
        setNeedsDisplay()
    }
    
    // true is hide
    func setDisplayState(_ hide: Bool) {
        if hide {
            transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            transform = transform.translatedBy(x: 0, y: midRadius * 0.5)
        }else {
            transform = CGAffineTransform.identity
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(arcCenter: vertex, radius: midRadius, startAngle: leftAngle, endAngle: rightAngle, clockwise: true)
      
        path.move(to: CGPoint(x: vertex.x, y: vertex.y - minRadius))
        path.addLine(to: CGPoint(x: vertex.x, y: vertex.y - midRadius))
        
        path.lineWidth = 2.5
        UIColor.white.setStroke()
        path.stroke()
    }
}
