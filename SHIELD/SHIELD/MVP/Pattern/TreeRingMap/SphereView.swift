//
//  SphereView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/22.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class SphereView: UIView {
    var sphereColor = UIColor.red {
        didSet{
            setNeedsDisplay()
        }
    }
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let radius = 0.5 * min(bounds.width, bounds.height)
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: radius, startAngle: 0, endAngle: 2 * CGFloatPi, clockwise: true)
        sphereColor.setFill()
        circlePath.fill()
        
        // draw
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        ctx.addPath(circlePath.cgPath)
        ctx.clip()

        // shadow
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [UIColor.black.withAlphaComponent(0.1).cgColor, UIColor.black.withAlphaComponent(0.35).cgColor] as CFArray, locations: [0, 1])
        let radialCenter = CGPoint(x: bounds.midX, y: bounds.midY * 0.8)
        ctx.drawRadialGradient(gradient!, startCenter: radialCenter, startRadius: radius * 0.2, endCenter: radialCenter, endRadius: radius, options: .drawsBeforeStartLocation)
        
        ctx.restoreGState()
    }
}
