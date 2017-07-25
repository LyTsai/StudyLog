//
//  CDTitleRing.swift
//  ANBookPad
//
//  Created by dingf on 16/12/12.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

class CDTitleRing: NSObject {
    var style:RingTextStyle!
    var size :CGFloat!
    var textAttributes :[String:AnyObject]!
    var textPainter :ANCircleText!
    fileprivate var runtimeSize_title:CGFloat!
    
    override init() {
        super.init()
        textPainter = ANCircleText.init()
        size = 18
        textAttributes = [String : AnyObject]()
        //dingf.mark
        style = RingTextStyle.alignMiddle
        let lbFont  = CTFontCreateWithName("Helvetica-Bold" as CFString, 12.0, nil)
        textAttributes[NSFontAttributeName] = lbFont
        runtimeSize_title = 1
        
    }
    
    func translateChildernFontSize(_ pointsPerFontSize:CGFloat){
        runtimeSize_title = size * pointsPerFontSize
    }
    
    func takeOutRuntimeSize() -> CGFloat{
        return runtimeSize_title
    }
    
    func paint(_ ctx: CGContext,
          archorRing: CDRing,
              radius: CGFloat,
              center: CGPoint,
         frameHeight: CGFloat){
        
        // go over all slices and paint the title labels
        for i in 0..<archorRing.numberOfSlice(){
            if let oneSlice = archorRing.getSlice(i){
                
                // draw title string in the center of given range
                paintSliceTitle(ctx, title: oneSlice.label, radius: radius, left: oneSlice.left, right: oneSlice.right, center: center, frameHeight: frameHeight)
            }
        }
    }
    
    // paint title at given position
    func paintSliceTitle(_ ctx: CGContext,
                         title: String?,
                        radius: CGFloat,
                          left: CGFloat,
                         right: CGFloat,
                        center: CGPoint,
                   frameHeight: CGFloat){
        
        if title == nil{
            return
        }
        let attrString = NSMutableAttributedString.init(string: title!, attributes: textAttributes)
        textPainter.paintCircleText(ctx, text: attrString, style: style, radius: radius, width: takeOutRuntimeSize(), left: left, right: right, center: center)
    }
    
    // hit test 
    func hitTest(atPoint: CGPoint,
              archorRing: CDRing,
                  radius: CGFloat,
                  center: CGPoint) -> HitCDObj{
        var hitObj = HitCDObj()
        hitObj.hitObject = CDObjs.none
        let width = takeOutRuntimeSize()
        var left: CGFloat
        var right: CGFloat
        var r1: CGFloat
        var r2: CGFloat
        var alen: CGFloat
        var within: Bool
        
        
        let r: CGFloat = CGFloat(hypotf(Float(atPoint.x - center.x), Float(atPoint.y - center.y)))
        var a = 180.0 * atan(-(atPoint.y - center.y) / (atPoint.x - center.x)) / 3.14
        if (atPoint.x - center.x) < 0{
            a += 180
        }
        if a < 0{
            a += 360.0
        }
        
        // go over all slices and paint title labels
        for i in 0..<archorRing.numberOfSlice(){
            let oneSlice = archorRing.getSlice(i)
            if oneSlice == nil{
                return hitObj
            }
            
            // hit test on this one 
            let text = NSMutableAttributedString.init(string: oneSlice!.label, attributes: textAttributes)
            
            // label range: radius, aLeft and aRight 
            if (style.rawValue & RingTextStyle.alignBottom.rawValue) != 0x00{
                r1 = radius + (text.size().height - width * 0.5)
            }else if (style.rawValue & RingTextStyle.alignMiddle.rawValue) != 0x00{
                r1 = radius + width * 0.5
            }else if (style.rawValue & RingTextStyle.alignTop.rawValue) != 0x00{
                r1 = radius + width
            }else {
                r1 = radius
            }
            r2 = r1
            r1 -= text.size().height * 0.5
            r2 += text.size().height * 0.5
            
            // left and right angle range
            alen = text.size().width * 180.0 / (CGFloat(M_PI) * radius)
            left = (oneSlice!.left + oneSlice!.right) * 0.5 + alen * 0.5
            right = left - alen
            within = (a >= right && a <= left ) || ((a + 360) >= right && (a + 360) <= left)
            if CGFloat(r) >= r1 && CGFloat(r) <= r2 && within == true{
                hitObj.hitObject = CDObjs.title
                hitObj.sliceIndex = i
                return hitObj
            }
        }
        return hitObj
    }
}
