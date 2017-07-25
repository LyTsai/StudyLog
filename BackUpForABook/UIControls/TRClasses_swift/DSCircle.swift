//
//  DSCircle.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class DSCircle: NSObject {
    var show: Bool?
    var size: Float?
    var colorHi: UIColor?
    var colorLo: UIColor?
    var outsideColor: UIColor?
    var insideColor: UIColor?
    var handleWidth: Float?
    var handleColor: UIColor?
    var width: Float?
    
    override init() {
        super.init()
        size = 24
        show = true
        width = 5.4
        colorLo = UIColor(red: 0.004, green: 0.004, blue: 0.004, alpha: 0.5)
        colorHi = UIColor(red: 0.004, green: 0.004, blue: 0.004, alpha: 0)
        outsideColor = UIColor(red: 0.902, green: 0.902, blue: 0.898, alpha: 1)
        insideColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        handleWidth = 4
        handleColor = UIColor(red: 0.945, green: 0.361, blue: 0.153, alpha: 1)
    }
    
    // paint the circle 
    func paint(_ ctx: CGContext, origin: CGPoint, handle_pos: CGPoint){
        // outer path
        let bezierOuterPath = UIBezierPath()
        bezierOuterPath.move(to: handle_pos)
        bezierOuterPath.addLine(to: origin)
        
        UIColor.white.setStroke()
        bezierOuterPath.lineWidth = CGFloat(handleWidth!) + 2.0
        bezierOuterPath.stroke()
        
        // inner path
        let bezierInnerPath = UIBezierPath()
        bezierInnerPath.move(to: handle_pos)
        bezierInnerPath.addLine(to: origin)
        
        handleColor!.setStroke()
        bezierInnerPath.lineWidth = CGFloat(handleWidth!)
        bezierInnerPath.stroke()
        
        // then the circle
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let sVGID_Locations: [CGFloat] = [0,1]
        let sVGID = CGGradient(colorsSpace: colorSpace, colors: [colorHi!.cgColor,colorLo!.cgColor] as CFArray, locations: sVGID_Locations)
        
        let circleRect = CGRect(x: origin.x - CGFloat(size! / 2.0), y: origin.y - CGFloat(size! / 2.0), width: CGFloat(size!), height: CGFloat(size!))
        let circleInner = CGRect(x: origin.x - CGFloat((size! - width!) / 2.0), y: origin.y - CGFloat((size! - width!) / 2.0), width: CGFloat(size! - width!), height: CGFloat(size! - width!))
        let oval2Path = UIBezierPath(ovalIn: circleRect)
        insideColor!.setFill()
        oval2Path.fill()
        
        let oval3Path = UIBezierPath(ovalIn: circleRect)
        outsideColor!.setStroke()
        oval3Path.lineWidth = 1.16
        oval3Path.stroke()
        
        let oval4Path = UIBezierPath(ovalIn: circleInner)
        ctx.saveGState()
        oval4Path.addClip()
        ctx.drawLinearGradient(sVGID!, start: CGPoint.init(x: origin.x, y: origin.y), end: CGPoint.init(x: origin.x, y: origin.y - CGFloat(size! - width!) / 2), options: .drawsBeforeStartLocation)
        ctx.restoreGState()
    }

}
