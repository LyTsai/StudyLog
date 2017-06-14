//
//  DSArrow.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit
// drawing shape type of class for arrow drawing
//
//      |\
//   |  | \
//  ----   \
//  _2d_   /
//   |  | /
//      |/
// the arrow is represented by following parameters:
// (1) d - the width  of hand
// (2) e - width of head
// (3) l - the length of hand
// (4) h - the length of head
// the path of the arrow edges are defined by: (0, -d), (l, -d), (l, -d-e), (l+h, 0), (l, d + e), (l,d), (0,d)

class DSArrow: NSObject {
    var d: Float?
    var e: Float?
    var l: Float?
    var h: Float?
    var showArrow: Bool?
    var shadow: Bool?
    var faceColor: UIColor?
    
    // arrow size information 
    var width: Int {
        get{
            return Int(1.5 * (self.l! + self.h!))
        }
    }
    var height: Int {
        get{
            return Int(4 * max(self.d!, self.e!))
        }
    }
    
    override init() {
        super.init()
        showArrow = true
        shadow = false
        faceColor = UIColor(red: 0.0, green: 0.3, blue: 0.9, alpha: 0.8)
        d = 2.0
        e = 4.0
        l = 6.0
        h = 6.0
    }
    
    func paint(_ ctx: CGContext){
        if showArrow != true{return}
        // add arrowPath onto given context
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x: 0.0, y: CGFloat(-d!)))
        aPath.addLine(to: CGPoint(x: CGFloat(l!), y: CGFloat(-d!)))
        aPath.addLine(to: CGPoint(x: CGFloat(l!), y: CGFloat(-d! - e!)))
        aPath.addLine(to: CGPoint(x: CGFloat(l! + h!), y: CGFloat(0.0)))
        aPath.addLine(to: CGPoint(x: CGFloat(l!), y: CGFloat(d! + e!)))
        aPath.addLine(to: CGPoint(x: CGFloat(l!), y: CGFloat(d!)))
        aPath.addLine(to: CGPoint(x: CGFloat(0.0), y: CGFloat(d!)))
        aPath.close()
        ctx.addPath(aPath.cgPath)
        ctx.saveGState()
        
        if shadow == true{
            ctx.setShadow(offset: CGSize.init(width: 0, height: 2.0), blur: 3.0, color: UIColor.gray.cgColor)
        }
        
        ctx.setFillColor(faceColor!.cgColor)
        ctx.drawPath(using: .fill)
        ctx.restoreGState()
    }
}
