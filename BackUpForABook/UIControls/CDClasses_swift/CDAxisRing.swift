//
//  CDAxisRing.swift
//  ANBookPad
//
//  Created by dingf on 16/12/12.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

class CDAxisRing: NSObject {
    var size :CGFloat!
    fileprivate var runtimeSize_axis:CGFloat!
    override init() {
        super.init()
        size = 0
        runtimeSize_axis = 1.0
    }
    func translateChildernFontSize(_ pointsPerFontSize:CGFloat){
        runtimeSize_axis = size * pointsPerFontSize
    }
    func takeOutRuntimeSize() -> CGFloat{
        return runtimeSize_axis
    }
    // hit test
    func hitTest(atPoint: CGPoint, radius: CGFloat, center: CGPoint) -> HitCDObj{
        var hitObj = HitCDObj()
        hitObj.hitObject = CDObjs.none
        let width = takeOutRuntimeSize()
        var r1 :CGFloat
        var r2 :CGFloat
        let r = hypotf(Float(atPoint.x - center.x), Float(atPoint.y - center.y))
        var a = 180.0 * atan(-(atPoint.y - center.y) / (atPoint.x - center.y)) / 3.14
        if (atPoint.x - center.x) < 0{
            a += 180
        }
        if a < 0{
            a += 360.0
        }
        r1 = radius
        r2 = r1 + width
        if (CGFloat(r) < r1 || CGFloat(r) > r2){
            return hitObj
        }
        return hitObj
    }

}
