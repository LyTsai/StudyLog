//
//  RoateSliceView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/8/23.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
@objc protocol RoateSliceDelegate {
    @objc optional func rotateSliceView(_ rotateSlice: RoateSliceView, didRotateToSlice index: Int)
    @objc optional func rotateSliceView(_ rotateSlice: RoateSliceView, isRotatingToSlice index: Int)
}

class RoateSliceView: UIView {
    var rotateDelegate: RoateSliceDelegate!
    
    var pointerIndex: Int = -1
    var pointerAngle: CGFloat = -CGFloat(Double.pi) / 2
    var numberOfSlices: Int = 0
    var angleGap: CGFloat {
        if numberOfSlices == 0 {
            return 0
        }
        return CGFloat(Double.pi) * 2 / CGFloat(numberOfSlices)_
    }
    
    var viewCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    // rotation angle
    var rotationAngle: CGFloat {
        return rAngle
    }
    fileprivate var rAngle: CGFloat = 0 {
        didSet{
            if rAngle > CGFloat(2 * Double.pi) {
                rAngle -= CGFloat(2 * Double.pi)
            }else if rAngle < -CGFloat(2 * Double.pi)  {
                rAngle += CGFloat(2 * Double.pi)
            }
        }
    }
    
    // touches
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        
        let lastPoint = touches.first!.previousLocation(in: self)
        let angle = Calculation().angleOfPoint(currentPoint, center: viewCenter) - Calculation().angleOfPoint(lastPoint, center: viewCenter)
        rotateWithGap(angle)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        adjustAngle()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        adjustAngle()
    }
    
    // stop scroll
    func adjustAngle() {
        if numberOfSlices == 0 {
            return
        }
        
        var desA: CGFloat = 0
        if pointerIndex == -1 {
            var index = 0
            let total = rAngle / angleGap
            index = (total > 0 ? Int(total + 0.5) : Int(total - 0.5)) % numberOfSlices
            index = (index > 0 ? (numberOfSlices - index) : -index)
            desA = -CGFloat(index) * angleGap
        }else {
            desA = -CGFloat(pointerIndex) * angleGap
        }
        
        transform = transform.rotated(by: (desA - rAngle))
        rAngle = desA
        
        
        
    }
    
    // angle is changed
    func rotateWithGap(_ angle: CGFloat) {
        
        transform = transform.rotated(by: angle)
        rAngle += angle
        
        var index = 0
        let total = rAngle / angleGap
        index = (total > 0 ? Int(total + 0.5) : Int(total - 0.5)) % numberOfSlices
        index = (index > 0 ? (numberOfSlices - index) : -index)
        
        pointerIndex = index
        
        if rotateDelegate != nil {
            rotateDelegate.rotateSliceView?(self, isRotatingToSlice: pointerIndex)
        }
    }
    
    
    // scroll
    func scrollToSliceIndex(_ index: Int) {
        if pointerIndex == index {
            adjustAngle()
            if self.rotateDelegate != nil {
                rotateDelegate.rotateSliceView?(self, didRotateToSlice: pointIndex)
            }
        }else {
            // animation, go to directly
            var indexGap = abs(index - pointerIndex)
            let half = numberOfSlices / 2
            if half < indexGap {
                indexGap = numberOfSlices - indexGap
            }
            
            rAngle = -CGFloat(pointIndex) * angleGap
            
            UIView.animate(withDuration: min(0.15 * Double(indexGap), 1), delay: 0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(rotationAngle: self.rAngle)
            }) { (true) in
                if self.rotateDelegate != nil {
                    self.rotateDelegate.rotateSliceView?(self, didRotateToSlice: self.pointerIndex)
                }
            }
        }
    }
}
