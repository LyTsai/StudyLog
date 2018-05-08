//
//  CoreGraphicsAndDrawRect.swift
//  UIDesignCollection
//
//  Created by Lydire on 16/9/7.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import UIKit

class GradientArc: UIView {
    
    func setupWithColors(_ colors: [CGColor], locations: [NSNumber], lineWidth: CGFloat) {
        maskLayer.lineWidth = lineWidth
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        
        layoutSubviews()
    }
    
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let maskLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addBacicLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBacicLayers()
    }
    
    
    fileprivate func addBacicLayers() {
        gradientLayer.locations = [0.2, 0.5, 0.8]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)

        maskLayer.strokeColor = UIColor.red.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(gradientLayer)
        layer.mask = maskLayer
    
        // setups
        maskLayer.lineWidth = 5
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        
        // draw half-circle
        let path = UIBezierPath()
        let lineGap = maskLayer.lineWidth * 0.5
        if bounds.height >= bounds.width * 0.5 {
            let radius = bounds.width * 0.5 - lineGap
            path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.height), radius: radius, startAngle: 0, endAngle: -CGFloat(Double.pi), clockwise: false)
        }else {
            let radius = (pow(bounds.height, 2) + pow(bounds.midX, 2)) / (2 * bounds.height)
            let startAngle = -acos(bounds.midX / radius)
            path.addArc(withCenter: CGPoint(x: bounds.midX, y: radius + lineGap), radius: radius, startAngle: startAngle, endAngle: -CGFloat(Double.pi) - startAngle, clockwise: false)
        }
        
        maskLayer.path = path.cgPath
    }
}
