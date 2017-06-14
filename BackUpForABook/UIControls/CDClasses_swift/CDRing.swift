//
//  CDRing.swift
//  ANBookPad
//
//  Created by dingf on 16/12/12.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

class CDRing: NSObject {
    var slices: NSMutableArray!
    // gap between slices of one ring
    var gap: CGFloat!
    // ring size along radius direction .size is in font unit 
    var size: CGFloat!
    var showTop: Bool!
    var topEdgeColor: UIColor!
    var showBottom: Bool!
    var bottomEdgeColor: UIColor!
    
    fileprivate var runtimeSize_title : CGFloat!
    fileprivate var runtimeSize : CGFloat!
    
    override init() {
        super.init()
        slices = NSMutableArray()
        gap = 1.0
        size = 16
        showTop = true
        topEdgeColor = UIColor.darkGray
        showBottom = false
        bottomEdgeColor = UIColor.darkGray
        runtimeSize = 1
    }
    // create n slices and save into slices
    func createSlice(_ nSlice:Int){
        if slices == nil{
            slices = NSMutableArray()
        }else{
            slices.removeAllObjects()
        }
        for _ in 0..<nSlice{
            slices.add(CDRingSlice.init())
        }
    }
    // get ring slice in slices
    func getSlice(_ position: Int) -> CDRingSlice!{
        if slices == nil || position >= slices.count{
            return nil
        }else{
            return slices.object(at: position) as! CDRingSlice
        }
    }
    // num
    func numberOfSlice() -> Int{
        return slices.count
    }

    func translateChildernFontSize(_ pointsPerFontSize:CGFloat){
        runtimeSize_title = size * pointsPerFontSize
    }
    
    func takeOutRuntimeSize() -> CGFloat{
        return runtimeSize_title
    }
    
    // paint ring slice
    func paint(ctx:CGContext,radius:CGFloat,size:CGFloat,center:CGPoint){
        // save current context
        ctx.saveGState()
        ctx.setLineWidth(0.5)
        
        if showTop == true{
            ctx.setStrokeColor(topEdgeColor.cgColor)
            let circle = UIBezierPath.init(arcCenter: center, radius: (radius + size), startAngle: 0, endAngle: 2 * CGFloat(M_PI), clockwise: true)
            ctx.beginPath()
            ctx.addPath(circle.cgPath)
            ctx.drawPath(using: .stroke)
        }
        if showBottom == true{
            let circle = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat(M_PI), clockwise: true)
            ctx.beginPath()
            ctx.addPath(circle.cgPath)
            ctx.drawPath(using: .stroke)
        }
        ctx.restoreGState()
    }
    
    // hit test for ring cell
    func hitTest(atPoint: CGPoint,
                    ring: Int,
                  radius: CGFloat,
                  center: CGPoint) -> HitCDObj{
        
        var hitObj = HitCDObj()
        hitObj.hitObject = CDObjs.none
        if slices == nil{
            return hitObj
        }
        let width = takeOutRuntimeSize()
        var r1: CGFloat
        var r2: CGFloat
        // convert atPoint to position in coordinate position first
        let r = hypotf(Float(atPoint.x - center.x), Float(atPoint.y - center.y))
        var a = 180.0 * atan(-(atPoint.y - center.y) / (atPoint.x - center.x)) / 3.14
        if (atPoint.x - center.x) < 0{
            a += 180.0
        }
        if a < 0{
            a += 360.0
        }
        r1 = radius
        r2 = r1 + width
        // out of ring range
        if (CGFloat(r) < r1 || CGFloat(r) > r2){
            return hitObj
        }
        // within the ring range 
        hitObj.hitObject = CDObjs.ring
        hitObj.ringIndex = ring
        // go over all slices
        var within: Bool
        for i in 0..<slices.count{
//            let slice = slices.object(at: i) as AnyObject
//            if slice.isKind(of: CDRingSlice.self) == false{
//                continue
//            }
            let oneSlice = slices.object(at: i) as! CDRingSlice
            // hit test this slice
            within = (a >= oneSlice.right && a <= oneSlice.left) || ((a + 360) >= oneSlice.right && (a + 360) <= oneSlice.left)
            // out of slice range
            if within == false{
                continue
            }
            hitObj.hitObject = CDObjs.slice
            hitObj.sliceIndex = i
        
        // hit test all slice cells
            for j in 0..<oneSlice.cells.count{
                let cell = oneSlice.cells.object(at: j) as AnyObject
                if cell.isKind(of: CDCell.self) == false{
                    continue
                }
                let oneCell = oneSlice.cells.object(at: j) as! CDCell
                
                // hit test this cell
                within = (a >= oneCell.right && a <= oneCell.left || (a + 360) >= oneCell.right && (a + 360) <= oneCell.left)
                if within == true{
                    hitObj.hitObject = CDObjs.cell
                    hitObj.cellIndex = j
                    return hitObj
                }
            }
        }
        return hitObj
    }
    
    

}
