//
//  CustomSwitch.swift
//  AnnielyticX
//
//  Created by iMac on 2018/7/27.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class CustomSwitch: UIControl {
    var onColor = UIColor(red: 0.341, green: 0.914, blue: 0.506, alpha: 1)
    var offColor = UIColor(white: 0.9, alpha: 1) {
        didSet{
            if !isOn {
                changeValueAnimation(isOn, duration: 0.01)
            }
            
        }
    }
    var borderColor = UIColor(white: 0.8, alpha: 1)
    var thumbColor = UIColor.white
    
    var isOn: Bool {
        return on
    }
    
    fileprivate var on = true
    fileprivate func fillColor(_ isOn: Bool) -> CGColor {
        return isOn ? onColor.cgColor: offColor.cgColor
    }
    
    fileprivate var switchControl = CAShapeLayer()
    fileprivate var backgroundLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

        
    // init
    fileprivate func setUpView() {
        backgroundColor = UIColor.clear
        
        // backLayer
        backgroundLayer.fillColor = fillColor(isOn)
        backgroundLayer.strokeColor = borderColor.cgColor
        layer.addSublayer(backgroundLayer)

        // top
        switchControl.lineCap = .round
       
        switchControl.strokeColor = thumbColor.cgColor
        switchControl.fillColor = UIColor.clear.cgColor
        switchControl.strokeEnd = 0.0001
        layer.addSublayer(switchControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineWidth: CGFloat = bounds.height / 25
   
        let radius = bounds.height * 0.5 - lineWidth
        let roundedRectPath = UIBezierPath(roundedRect: bounds.insetBy(dx: lineWidth, dy: lineWidth), cornerRadius: radius)
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.path = roundedRectPath.cgPath
        
        let innerLineWidth = bounds.height - lineWidth * 3 + 1
        let switchControlPath = UIBezierPath()
        switchControlPath.move(to: CGPoint(x: lineWidth, y: 0))
        switchControlPath.addLine(to: CGPoint(x: bounds.width - 2 * lineWidth - innerLineWidth + 1, y: 0))
        
        var point = backgroundLayer.position
        point.y += (radius + lineWidth)
        point.x += radius
        switchControl.position = point
        switchControl.path = switchControlPath.cgPath
        switchControl.lineWidth = innerLineWidth
    }
    
    // tap
    func changeValue() {
        sendActions(for: .valueChanged)
        on = !on
        
        changeValueAnimation(isOn, duration: 0.3)
    }
    
    // animation
    func changeValueAnimation(_ turnOn: Bool, duration: TimeInterval) {
        
        // thumb, move as tapped
        let times = [0,0.49,0.51,1]
        
        let switchControlStrokeStart = CAKeyframeAnimation(keyPath: "strokeStart")
        switchControlStrokeStart.values = turnOn ? [1, 0, 0 , 0] : [0, 0, 0, 1]
        switchControlStrokeStart.keyTimes = times as [NSNumber]?
        switchControlStrokeStart.duration = duration
        switchControlStrokeStart.isRemovedOnCompletion = true // if not set, will not influent the result
        
        let switchControlStrokeEnd = CAKeyframeAnimation(keyPath: "strokeEnd")
        switchControlStrokeEnd.values = turnOn ? [1, 1, 1, 0] : [0, 1, 1, 1]
        switchControlStrokeEnd.keyTimes = times as [NSNumber]?
        switchControlStrokeEnd.duration = duration
        switchControlStrokeEnd.isRemovedOnCompletion = true
        
        // color, change as tapped
        let backgroundFillColor = CAKeyframeAnimation(keyPath: "fillColor")
        backgroundFillColor.values = [fillColor(!turnOn), fillColor(!turnOn), fillColor(turnOn), fillColor(turnOn)]
        backgroundFillColor.keyTimes = [0, 0.5, 0.51, 1]
        backgroundFillColor.duration = duration
        backgroundFillColor.fillMode = .forwards
        backgroundFillColor.isRemovedOnCompletion = false
        
        // animationGroup
        let switchControlAnimation : CAAnimationGroup = CAAnimationGroup()
        switchControlAnimation.animations = [switchControlStrokeStart,switchControlStrokeEnd]
        switchControlAnimation.fillMode = .forwards
        switchControlAnimation.isRemovedOnCompletion = false
        switchControlAnimation.duration = duration
        
        let animationKey = turnOn ? "TurnOn" : "TurnOff"
        switchControl.add(switchControlAnimation, forKey: animationKey)
        backgroundLayer.add(backgroundFillColor, forKey: "Color")
    }
}
