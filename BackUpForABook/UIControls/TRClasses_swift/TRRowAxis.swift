//
//  TRRowAxis.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRRowAxis: TRAxis {
    var showBar: Bool?
    var slider: DSSlider?

    override init() {
        super.init()
        tickLabelDirection = .angle
        showTicks = true
        showLabel = true
        showBar = true
        slider = DSSlider.init()
        
        eyeRadius = 50
        eyeTicks = 3
        eyePosition = (lastTickValue! + firstTickValue!) * 0.5
        fishyEye = true
    }
    
    
    // paint 
    func paint(_ ctx: CGContext,start: Float,end: Float,angle: Float,offset: Float,origin: CGPoint,height: Int){
        if showLabel == true{
            if tickLabelDirection == .angle{
                // automatic angle orientation

                
            }else{
                // 0 degree or shifting up and down
                paintTickLabels_Level(ctx, start: start, end: end, angle: angle, origin: origin, height: height)
            }
            
            if showLabel == true && showTicks == true{
                paintTicks(ctx, offset: offset, angle: angle, origin: origin)
            }
        }
    }
    
    // paint ticks : small lines
    func paintTicks(_ ctx: CGContext, offset: Float, angle: Float, origin: CGPoint){
        ctx.saveGState()
        
        ctx.setStrokeColor(tickColor!.cgColor)
        ctx.setLineWidth(CGFloat(tickSize!))
        
        // go over all axis tick text
        ctx.beginPath()
        
        for i in 0..<numberOfTicks!{
            let tick = ticks[i]
            let rPosition = tick.viewOffset
            
            // axis position 
            let axisPosition = CGPoint(x: origin.x + CGFloat(rPosition! * cosf(DEGREETORADIANS(degree: angle))), y: origin.y - CGFloat(rPosition! * sinf(DEGREETORADIANS(degree: angle))) + CGFloat(offset))
            
            // label head position 
            var labelPosition = CGPoint(x: axisPosition.x, y: axisPosition.y + CGFloat(height! * pointsPerFontSize!))
            
            // make adjustment along y direction 
            if i % 2 != 0 {
                labelPosition.y = axisPosition.y + CGFloat((height! + 3.0) * pointsPerFontSize!)
            }
            
            ctx.move(to: axisPosition)
            ctx.addLine(to: labelPosition)
            ctx.strokePath()
        }
        ctx.restoreGState()
    }
    
    func paintTickLabels_Level(_ ctx: CGContext, start: Float, end: Float, angle: Float, origin: CGPoint, height: Int){
        var rPosition :Float
        var labelPosition = CGPoint()
        var labelHeight: Float
        var labelWidth: Float
        
        var labelSpace: Float = 0
        var labelShift: Float = 0
        var txtSize: CGRect
        
        if numberOfTicks == 0 {return}
        
        // alignment
        let paragarphStyle = NSMutableParagraphStyle()
        paragarphStyle.alignment = .left
        
        // save current context
        ctx.saveGState()
        
        labelHeight = 40.0
        labelWidth = 100.0
        
        let sampleString = NSMutableAttributedString.init(string: ticks[0].label!.shortString!, attributes: ticks[0].label!.attrDictionary)
        txtSize = sampleString.boundingRect(with: CGSize.init(width: CGFloat(FLT_MAX), height: CGFloat(FLT_MAX)), options: NSStringDrawingOptions.init(rawValue: 0), context: nil)
        
        if numberOfTicks == 1{
            labelShift = 0
        }else{
            labelShift = Float(txtSize.size.height) + 2
        }
        
        // go over all axis tick text
        for i in 0..<numberOfTicks!{
            let tick = ticks[i]
            
            // draw this tick label at aPosition angle position
            rPosition = tick.viewOffset!
            
            // create attributed string for drawing
            let attString = NSMutableAttributedString.init(string: tick.label!.shortString!, attributes: tick.label!.attrDictionary)
            
            // check to see if we have enough space for displaying the label : get string label size
            txtSize = attString.boundingRect(with: CGSize.init(width: CGFloat(FLT_MAX), height: CGFloat(FLT_MAX)), options: NSStringDrawingOptions.init(rawValue: 0), context: nil)
            labelWidth = Float(txtSize.size.width)
            labelHeight = Float(txtSize.size.height)
            
            // adjust the label length based on what we have at this position
            labelSpace = labelWidth
            
            // label head position
            labelPosition.x = origin.x + CGFloat(rPosition * cosf(DEGREETORADIANS(degree: angle)))
            labelPosition.y = origin.y - CGFloat(rPosition * sinf(DEGREETORADIANS(degree: angle))) + CGFloat(tick.viewSpace!)
            
            
            labelPosition.x -= CGFloat(0.5 * labelWidth)
            
            if (i % 2) != 0{
                labelPosition.y += CGFloat(labelShift)
            }
            
            
            let rect = CGRect(x: 0, y: CGFloat(labelHeight), width: CGFloat(labelSpace), height: CGFloat(labelHeight + 2))
            
            ctx.translateBy(x: labelPosition.x, y: labelPosition.y)
            paintLabel_0(ctx, label: tick.label!, attString: attString, rect: rect)
            ctx.translateBy(x: -labelPosition.x, y: -labelPosition.y)
        }
        
        //
        ctx.restoreGState()
    }
    
    
    // hit test. Potential hit objects: slider and axis label
    func hitTest(_ atPoint: CGPoint, angle: Float, size: Float, origin: CGPoint) -> HitObj{
        var hit = HitObj()
        hit.hitObject = TRObjs.none
        
        // convert atPoint to position in coordinate
        let r = hypotf(Float(atPoint.x - origin.x), Float(atPoint.y - origin.y))
        var a = 180.0 * atan(Float(-(atPoint.y - origin.y) / (atPoint.x - origin.x))) / 3.14
        if (atPoint.x - origin.x) < 0{
            a += 180
        }
        
        // 1. hit slider bar?
        let visibleBar = (showBar == true && fishEyeNeeded == true)
        let barHalfWidthAngle = 180.0 * slider!.length! / (3.14 * eyePosition!)
        if (visibleBar == true) && (fabs(a - angle) <= barHalfWidthAngle) || (fabs(a - angle - 360.0) <= barHalfWidthAngle) && (fabsf(eyePosition! - r) <= slider!.height! * 0.5){
            hit.hitObject = TRObjs.rowBar
            return hit
        }
        
        // 2. hit axis area?
        if r > firstTickValue! && r < lastTickValue!{
            let angleHalfRange = 180.0 * size / (3.14 * r)
            if (fabs(a - angle) <= angleHalfRange || fabs(a - angle - 360.0) <= angleHalfRange){
                hit.hitObject = TRObjs.row_axis
                return hit
            }
        }
        
        // 3. hit axis labels?
        
        return hit
    }
    
    
    func paintTickLabels_Angle(_ ctx: CGContext,start: Float,end: Float,angle: Float,origin:CGPoint,height: Int){
        if numberOfTicks == 0{return}
        //  alignment
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        ctx.saveGState()
        
        let sampleString = NSMutableAttributedString(string:ticks[0].label!.shortString!, attributes: ticks[0].label!.attrDictionary)
        let txtSize = sampleString.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.init(rawValue: 0), context: nil)
        var labelAngle: Float
        // labelangle based on visual between labels
        if numberOfTicks == 1{
            labelAngle = 0.0
        }else{
            let tick1 = ticks[1]
            let tick0 = ticks[0]
            labelAngle = 180 * atan(Float(txtSize.size.height) / (tick1.viewOffset!) - tick0.viewOffset! / 3.14)
        }
        // go over all axis tick text
        for i in 0..<numberOfTicks!{
            let tick = ticks[i]
            // radius position of this label
            let rPosition = tick.viewOffset
            // create attributed string for drawing
            let attString = NSMutableAttributedString.init(string: tick.label!.shortString!, attributes: tick.label!.attrDictionary)
            let txtSize = attString.boundingRect(with: CGSize.init(width: CGFloat(FLT_MAX), height: CGFloat(FLT_MAX)), options: NSStringDrawingOptions.init(rawValue: 0), context: nil)
            let labelWidth = txtSize.size.width
            let labelHeight = txtSize.size.height
            let labelSpace = labelWidth
            let labelPosition = CGPoint(x: origin.x + CGFloat(rPosition! * cosf(DEGREETORADIANS(degree: angle))), y: origin.y - CGFloat(rPosition! * sinf(DEGREETORADIANS(degree: angle)) + tick.viewSpace!))
            // draw this label
            let rect = CGRect(x: 0.0, y: labelHeight, width: labelSpace, height: labelHeight + 2)
            ctx.ctm.translatedBy(x: labelPosition.x, y: labelPosition.y)
            ctx.ctm.rotated(by: -(CGFloat)(DEGREETORADIANS(degree: labelAngle)))
            paintLabel_0(ctx, label: tick.label!, attString: attString, rect: rect)
            ctx.ctm.rotated(by: CGFloat(DEGREETORADIANS(degree: labelAngle)))
            ctx.ctm.translatedBy(x: -labelPosition.x, y: -labelPosition.y)
        }
        ctx.restoreGState()
    }
    
    func paintLabel_0(_ ctx: CGContext, label: TRLabel, attString: NSMutableAttributedString, rect: CGRect){
        // under line for the first letter
        if label.underLine == true{
            attString.addAttributes([NSUnderlineStyleAttributeName : NSNumber.init(value: 2)], range: NSRange.init(location: 0, length: 1))
        }
        // exceed the maximum number of letters?
        if attString.length >= label.maxNumberOfFullSizeLetters! && label.attrRemainderDictionary != nil {
            attString.addAttributes(label.attrRemainderDictionary!, range: NSRange.init(location: label.maxNumberOfFullSizeLetters!, length: attString.length - label.maxNumberOfFullSizeLetters!))
        }
        // draw at label position
        let path = CGMutablePath()
        path.addRect(rect)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attString.length), path, nil)
        if label.blurRadius! > Float(0.0){
            ctx.setShadow(offset: label.blurSize!, blur: CGFloat(label.blurRadius!), color: label.blurColor!.cgColor)
        }
        ctx.saveGState()
        ctx.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
        CTFrameDraw(frame, ctx)
        ctx.restoreGState()
    }
}


