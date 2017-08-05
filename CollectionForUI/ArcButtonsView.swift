//
//  ArcButtonsView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/3.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class ArcButtonsView: UIView {
    // calculated
    fileprivate var vertex: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.height)
    }
    fileprivate var maxRadius: CGFloat {
        return bounds.height
    }
    
    fileprivate let floatPi = CGFloat(Double.pi)
    fileprivate var leftAngle: CGFloat = 1.57
    fileprivate var rightAngle: CGFloat = 0
    fileprivate var midRadius: CGFloat = 0
    
    // set up
//    fileprivate let cartoonImageView = UIImageView(image: UIImage(named: "icon_assess"))
//    fileprivate let finishImageView = UIImageView(image: UIImage(named: "landing_finish"))
    func setupWithFrame(_ frame: CGRect, buttons: [UIButton], minRadius: CGFloat, buttonGap: CGFloat, buttonScale: CGFloat) {
        if buttons.count == 0 {
            return
        }
        
        self.frame = frame
        backgroundColor = UIColor.clear
        
        // calculate
        midRadius = (minRadius + maxRadius) * 0.5
        let buttonLength = maxRadius - minRadius

        // angle
        let angleGap = sinh(buttonLength * 0.5 / midRadius) * 2 + buttonGap
        let totalAngle = angleGap * CGFloat(buttons.count - 1)
        if totalAngle > floatPi {
            print("too many")
            return
        }
        rightAngle = -(floatPi - totalAngle) * 0.5
        leftAngle = rightAngle - totalAngle
        
        // buttons
        var centerAngle = leftAngle
        for button in buttons {
            let center = Calculation().getPositionByAngle(centerAngle, radius: midRadius, origin: vertex)
            button.frame = CGRect(center: center, length: buttonLength * buttonScale)
            addSubview(button)
            centerAngle += angleGap
            
            button.layer.addBlackShadow(4)
        }
        
        // cartoon character
//        let cHeight = buttonLength * buttonScale * 0.9
//        cartoonImageView.contentMode = .scaleAspectFit
//        cartoonImageView.frame = CGRect(center: buttons[0].frame.origin, length: cHeight)
//        addSubview(cartoonImageView)
//        
//        finishImageView.contentMode = .scaleAspectFit
//        finishImageView.frame = CGRect(center: CGPoint(x: buttons.last!.frame.midX,y: buttons.last!.frame.minY), width: cHeight * 2, height: cHeight)
//        addSubview(finishImageView)
        
        // draw lines
        setNeedsDisplay()
    }
    
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
        path.move(to: vertex)
        path.addLine(to: CGPoint(x: vertex.x, y: vertex.y - midRadius))
        
        path.lineWidth = 2.5
        UIColor.white.setStroke()
        path.stroke()
    }
}
