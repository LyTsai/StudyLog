//
//  AnimationSample.swift
//  Demo_testUI
//
//  Created by iMac on 2018/3/16.
//  Copyright © 2018年 LyTsai. All rights reserved.
//

import Foundation

class WelcomeAnimation: UIView {
    let circleLayer = CircleLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addCircleLayer() {
        backgroundColor = UIColor.clear
        layer.addSublayer(circleLayer)
        circleLayer.expand()
    }
    
    // step1
    
}

class CircleLayer: CAShapeLayer {
    func expand() {
        let expandAnimation = CABasicAnimation(keyPath: "path")
//        expandAnimation.fromValue =
//        expandAnimation.toValue =
//        expandAnimation.duration =
        expandAnimation.fillMode = kCAFillModeForwards
        expandAnimation.isRemovedOnCompletion = false
        add(expandAnimation, forKey: nil)
    }
}
