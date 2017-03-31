//
//  Switch.swift
//  UIDesignCollection
//
//  Created by iMac on 16/9/21.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// 视图缩放比例
extension UIView {
    var sizeScale: CGFloat {
        return min(bounds.width, bounds.height) / 100
    }
    
}

typealias ValueChangeHook = (_ value: Bool) -> Void
func CGPointScaleMaker(_ scale: CGFloat) -> ((CGFloat, CGFloat) -> CGPoint) {
    return {
        (x, y) in return CGPoint(x: x * scale, y: y * scale)
    }
} // 按照比例改变point的值

class BaseSwitch: UIControl {
    
    var valueChange: ValueChangeHook? // TODO: -----
    var on = true
    var animationDuration: TimeInterval = 0.3
    
    // MARK： － getter，这个用法不错哎，以前没用过…………不过必要性待定
    var isOn: Bool {
        return on
    }
    
    func setUpView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeValue))
        addGestureRecognizer(tap)
    }
    
    func changeValue()  { // TODO: -----
        if valueChange != nil {
            valueChange!(isOn)
        }
        sendActions(for: .valueChanged)
        on = !on
    }
    
}

// MARK: -------- a simple switch
class SimpleSwitch: BaseSwitch {
    
    var switchControl = CAShapeLayer()
    var backgroundLayer = CAShapeLayer()
    
    var onColor = UIColor(red: 0.341, green: 0.914, blue: 0.506, alpha: 1)
    var offColor = UIColor(white: 0.9, alpha: 1)
    var borderColor = UIColor(white: 0.8, alpha: 1)
    var thumbColor = UIColor.white
    
    func stateToFillColor(_ isOn: Bool) -> CGColor {
        return isOn ? onColor.cgColor: offColor.cgColor
    }
    
    var lineSize: CGFloat = 5 // TODO: ----- 原来用的Double
    var lineWidth: CGFloat  {
        return lineSize * sizeScale
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    // init
    override func setUpView() {
        super.setUpView()
        
        backgroundColor = UIColor.clear
        let frame = bounds
//        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let radius = bounds.height * 0.5 - lineWidth
        let roundedRectPath = UIBezierPath(roundedRect: frame.insetBy(dx: lineWidth, dy: lineWidth), cornerRadius: radius)// Inset `rect' by `(dx, dy)'，这样和边框的距离是一半的lineWidth
        
        backgroundLayer.fillColor = stateToFillColor(isOn)
        backgroundLayer.strokeColor = borderColor.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.path = roundedRectPath.cgPath
        layer.addSublayer(backgroundLayer)
        
        let innerLineWidth = bounds.height - lineWidth * 3 + 1
        let switchControlPath = UIBezierPath()
        switchControlPath.move(to: CGPoint(x: lineWidth, y: 0))
        switchControlPath.addLine(to: CGPoint(x: bounds.width - 2 * lineWidth - innerLineWidth + 1, y: 0))
        /* 下面这段可以不用，但是上面的点的位置需要重新计算下，按照原坐标系 */
        var point = backgroundLayer.position // The position in the superlayer that the anchor point of the layer's bounds rect is aligned to. Defaults to the zero point. Animatable.
        point.y += (radius + lineWidth)
        point.x += radius
        switchControl.position = point
        
        switchControl.path = switchControlPath.cgPath
        switchControl.lineCap = kCALineCapRound
        switchControl.lineWidth = innerLineWidth
        switchControl.strokeColor = thumbColor.cgColor
        switchControl.fillColor = UIColor.clear.cgColor
        switchControl.strokeEnd = 0.0001
        layer.addSublayer(switchControl)
    }
    
    // tap
    override func changeValue() {
        super.changeValue()
        changeValueAnimation(isOn, duration: animationDuration)
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
        backgroundFillColor.values = [stateToFillColor(!turnOn), stateToFillColor(!turnOn), stateToFillColor(turnOn), stateToFillColor(turnOn)]
        backgroundFillColor.keyTimes = [0, 0.5, 0.51, 1]
        backgroundFillColor.duration = duration
        backgroundFillColor.fillMode = kCAFillModeForwards
        backgroundFillColor.isRemovedOnCompletion = false
        
        // animationGroup
        let switchControlAnimation : CAAnimationGroup = CAAnimationGroup()
        switchControlAnimation.animations = [switchControlStrokeStart,switchControlStrokeEnd]
        switchControlAnimation.fillMode = kCAFillModeForwards
        switchControlAnimation.isRemovedOnCompletion = false
        switchControlAnimation.duration = duration
        
        let animationKey = turnOn ? "TurnOn" : "TurnOff"
        switchControl.add(switchControlAnimation, forKey: animationKey)
        backgroundLayer.add(backgroundFillColor, forKey: "Color")
    }
}

// MARK: -------------- a smile switch
class SmileSwitch: BaseSwitch {
    
}
