//
//  TRColumnAxis.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRColumnAxis: TRAxis {
    var ring: TRSliceRing?
    var title: TRSliceTitle?
    
    var beginArrow: DSArrow?
    var endArrow: DSArrow?
    var circleBar: DSCircle?
    var showBar: Bool?
    var slider: DSSlider?
    var showTickLabels: Bool?
    
    // dynamic properties: average char width and height
    var averageCharWidth: Int?
    var averageCharHeight: Int?
    
    override init() {
        super.init()
        ring = TRSliceRing.init()
        title = TRSliceTitle.init()
        ring?.size = 26
        spaceBetweenAxisAndLabel = 12
        beginArrow = DSArrow.init()
        endArrow = DSArrow.init()
        circleBar = DSCircle.init()
        showBar = true
        slider = DSSlider.init()
        showTickLabels = true
        
        eyeRadius = 25
        eyeTicks = 5
        eyePosition = (lastTickValue! + firstTickValue!) * 0.5
        fishyEye = true
        
    }
    
    func paint(_ ctx: CGContext, start: Float, end: Float, radius: Float,size: Float, origin: CGPoint, height: Int, circleBarOnRight: Bool){
        // 1.backgroud: paint bar background
        ring?.paint(ctx, start: start, end: end, radius: radius, size: size, origin: origin)
        
        // 2.slice title: paint title
        title?.paintSliceTitle(ctx, radius: radius, left: end, right: start, center: origin, height: height)
        
        // 3.arrow: paint resize arrows on the edges
        let position = radius + ring!.outerDecorationRingOffset! + ring!.outerDecorationRingSize! / 2.0
        paintAngleResizeBar(ctx, start: start, end: end, radius: position, size: size, origin: origin)
        
        // 4.circle point: paint resize circle on the edge
        if circleBarOnRight == true{
            paintAngleResizeCircleBarWithHandle(ctx, start: start, handle_pos: radius, radius: position, size: size, origin: origin)
        }
        
        // 5.paint middle slider bar
        if showBar == true && fishEyeNeeded == true{
        
        }
        
        // 6. paint column tick labels
        if showTickLabels == true{
            if tickLabelDirection == TickLabelOrientation.zero{
                paintTickLabels_0(ctx: ctx, start: start, end: end, radius: radius, size: size, origin: origin, height: height)
            
            }else if tickLabelDirection == TickLabelOrientation.radius{
                paintTickLabels_radius(ctx, start: start, end: end, radius: radius, size: size, origin: origin, height: height)
            }
        
        }
    }
    
    // paint axis tick labels
    func paintTickLabels_0(ctx: CGContext, start: Float, end: Float, radius: Float, size: Float, origin: CGPoint, height: Int){
        let rPosition = radius + size
        var aPosition = start
        var labelPosition = CGPoint()
        var labelHeight: Float
        var labelWidth: Float
        var deltaAngle: Float = 0
        var deltaRadius: Float = 0
        var midlabelAngle: Float = 0
        var labelSpace: Float = 0
        
        // alignment
        let paragarphStyle = NSMutableParagraphStyle()
        paragarphStyle.alignment = .left
        
        // save current context
        ctx.saveGState()
        
        labelHeight = 40.0
        labelWidth = 100.0
        
        // go over all axis tick text
        for i in 0..<numberOfTicks!{
            let tick = ticks[i]
            
            // draw this tick label at aPosition angle position
            aPosition = tick.viewOffset!
            
            // create attributed string for drawing 
            let attString = NSMutableAttributedString.init(string: tick.label!.shortString!, attributes: tick.label!.attrDictionary)
            
            // check to see if we have enough space for displaying the label : get string label size
            let txtSize = attString.boundingRect(with: CGSize.init(width: CGFloat(FLT_MAX), height: CGFloat(FLT_MAX)), options: NSStringDrawingOptions.init(rawValue: 0), context: nil)
            labelWidth = Float(txtSize.size.width)
            labelHeight = Float(txtSize.size.height)
            
            // adjust the label length based on what we have at this position
            labelSpace = labelWidth
            
            // average char display size
            if attString.length > 0 {
                averageCharWidth = Int(Float(txtSize.size.width) / Float(attString.length))
            }
            averageCharHeight = Int(txtSize.size.height)
            
            // shift the head position by half character height
            deltaAngle = 180.0 * labelHeight * cosf(DEGREETORADIANS(degree: aPosition)) / (2 * 3.14 * rPosition)
            
            // adjust to the mid string position 
            midlabelAngle = 180.0 * atan((rPosition * sinf(DEGREETORADIANS(degree: aPosition))) / (rPosition * cosf(DEGREETORADIANS(degree: aPosition)) + labelSpace * 0.5)) / 3.14
            
            // we need to move the label along radius direction for the second half(180 - 360) of the circle
            deltaRadius = tick.viewSpace!
            if -aPosition > 180.0 || -aPosition < 0.0{
                deltaRadius += labelHeight * sin(DEGREETORADIANS(degree: aPosition))
            }
            
            // label head position
            labelPosition.x = origin.x + CGFloat((rPosition + deltaRadius) * cosf(DEGREETORADIANS(degree: aPosition + deltaAngle)))
            labelPosition.y = origin.y - CGFloat((rPosition + deltaRadius) * sinf(DEGREETORADIANS(degree: aPosition + deltaAngle)))
            
            if (fabs(aPosition) > 90 && fabs(aPosition) < 270){
                labelPosition.x -= CGFloat(labelSpace)
                paragarphStyle.alignment = .right
            
            }else{
                paragarphStyle.alignment = .left
            }
            
            attString.addAttributes([NSParagraphStyleAttributeName : paragarphStyle], range: NSRange.init(location: 0, length: 1))
            
            let rect = CGRect(x: labelPosition.x, y: labelPosition.y, width: CGFloat(labelSpace), height: CGFloat(labelHeight + 2))
            paintLabel_0(ctx, label: tick.label!, attString: attString, rect: rect)
        }
        
        ctx.restoreGState()
    }
    
    func paintTickLabels_radius(_ ctx: CGContext, start: Float, end: Float, radius: Float, size: Float, origin : CGPoint, height: Int){
        let rPosition = radius + size
        var aPosition = start
        var labelPosition = CGPoint()
        var labelHeight: Float
        var labelWidth: Float
        var deltaRadius: Float = 0
        var labelSpace: Float = 0
        
        // alignment
        let paragarphStyle = NSMutableParagraphStyle()
        paragarphStyle.alignment = .left
        
        // save current context
        ctx.saveGState()
        ctx.textMatrix = CGAffineTransform.identity
        ctx.translateBy(x: 0, y: CGFloat(height))
        ctx.scaleBy(x: 1.0, y: -1.0)
        
        labelHeight = 40.0
        labelWidth = 100.0
        
        // go over all axis tick text
        for i in 0..<numberOfTicks!{
            let tick = ticks[i]
            
            // draw this tick label at aPosition angle position
            aPosition = -tick.viewOffset!
            
            // create attributed string for drawing
            let attString = NSMutableAttributedString.init(string: tick.label!.shortString!, attributes: tick.label!.attrDictionary)
            
            // check to see if we have enough space for displaying the label : get string label size
            let txtSize = attString.boundingRect(with: CGSize.init(width: CGFloat(FLT_MAX), height: CGFloat(FLT_MAX)), options: NSStringDrawingOptions.init(rawValue: 0), context: nil)
            labelWidth = Float(txtSize.size.width)
            labelHeight = Float(txtSize.size.height)
            
            // adjust the label length based on what we have at this position
            labelSpace = labelWidth
            
            // average char display size
            if attString.length > 0 {
                averageCharWidth = Int(Float(txtSize.size.width) / Float(attString.length))
            }
            averageCharHeight = Int(txtSize.size.height)
            
           
            // we need to move the label along radius direction for the second half(180 - 360) of the circle
            deltaRadius = tick.viewSpace!
          
            
            // label head position
            labelPosition.x = origin.x + CGFloat((rPosition + deltaRadius) * cosf(DEGREETORADIANS(degree: aPosition)))
            labelPosition.y = origin.y - CGFloat((rPosition + deltaRadius) * sinf(DEGREETORADIANS(degree: aPosition)))
            
            attString.addAttributes([NSParagraphStyleAttributeName : paragarphStyle], range: NSRange.init(location: 0, length: 1))
            
            let rect = CGRect(x: 0.0, y: CGFloat(-labelHeight * 0.5), width: CGFloat(labelSpace), height: CGFloat(labelHeight + 2))
            
            ctx.translateBy(x: labelPosition.x, y: labelPosition.y)
            ctx.rotate(by: -(CGFloat)(DEGREETORADIANS(degree: aPosition)))
        
            paintLabel_0(ctx, label: tick.label!, attString: attString, rect: rect)
            
            ctx.rotate(by: CGFloat(DEGREETORADIANS(degree: aPosition)))
            ctx.translateBy(x: -labelPosition.x, y: -labelPosition.y)
        }
        
        //
        ctx.restoreGState()
    }
    
    // paint label
    func paintLabel_0(_ ctx: CGContext, label: TRLabel, attString: NSMutableAttributedString,rect: CGRect){
        // 1. under line for the first letter?
        if label.underLine == true{
            attString.addAttributes([NSUnderlineStyleAttributeName: NSNumber.init(value: 2)], range: NSRange.init(location: 0, length: 1))
        }
        
        // 2. exceeds the maximum number of letters ?
        if attString.length >= label.maxNumberOfFullSizeLetters! && label.attrRemainderDictionary != nil {
            attString.addAttributes(label.attrRemainderDictionary!, range: NSRange.init(location: label.maxNumberOfFullSizeLetters!, length: attString.length - label.maxNumberOfFullSizeLetters!))
        
        }
        
        // 3. draw at label position 
        let path = CGMutablePath()
        path.addRect(rect)
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attString)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange.init(location: 0, length: attString.length), path, nil)
        
        if label.blurRadius! > 0{
            ctx.setShadow(offset: label.blurSize!, blur: CGFloat(label.blurRadius!), color: label.blurColor!.cgColor)
        }
        
        ctx.saveGState()
        ctx.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
        CTFrameDraw(frame, ctx)
        ctx.restoreGState()
    }
    
    // paint angle resize bar 
    func paintAngleResizeBar(_ ctx: CGContext, start:Float, end: Float, radius: Float,size: Float,origin: CGPoint){
        let rPosition = radius + size
        
        let minEdgeStart = CGPoint(x: origin.x + CGFloat(rPosition * cosf(DEGREETORADIANS(degree: start))), y: origin.y - CGFloat(rPosition * sinf(DEGREETORADIANS(degree: start))))
        
        let maxEdgeEnd = CGPoint(x: origin.x + CGFloat(rPosition * cosf(DEGREETORADIANS(degree: end))), y: origin.y - CGFloat(rPosition * sinf(DEGREETORADIANS(degree: end))))
        if beginArrow?.showArrow == true{
            paintBeginArrow(ctx, angle: start, position: minEdgeStart)
        }
        if endArrow?.showArrow == true{
            paintEndArrow(ctx, angle: end, position: maxEdgeEnd)
        }
    
    }
    
    // paint begin arrow
    func paintBeginArrow(_ ctx: CGContext, angle: Float, position: CGPoint){
        let arrowPointDirection = angle + 90.0
        
        // save current context
        ctx.saveGState()
        ctx.translateBy(x: position.x, y: position.y)
        ctx.rotate(by: CGFloat(DEGREETORADIANS(degree: -arrowPointDirection)))
        
        // draw the arrow
        beginArrow?.paint(ctx)
        
        // restore the context
        ctx.restoreGState()
    }
    
    // paint end arrow
    func paintEndArrow(_ ctx: CGContext, angle: Float, position: CGPoint){
        let arrowPointDirection = angle - 90.0
        
        // save current context
        ctx.saveGState()
        ctx.translateBy(x: position.x, y: position.y)
        ctx.rotate(by: CGFloat(DEGREETORADIANS(degree: -arrowPointDirection)))
        // draw the arrow
        beginArrow?.paint(ctx)
        
        // restore the context
        ctx.restoreGState()
    }
    
    // paint angle resize circle bar with handle
    func paintAngleResizeCircleBarWithHandle(_ ctx: CGContext,start: Float,handle_pos: Float,radius: Float,size: Float,origin: CGPoint){
        let rPosition = radius + size
        let rHandlePosition = handle_pos
        let circlePosition = CGPoint(x: origin.x + CGFloat(rPosition * cosf(DEGREETORADIANS(degree: start))), y:origin.y - CGFloat(rPosition * sinf(DEGREETORADIANS(degree: start))))
        let handlePosition = CGPoint(x: origin.x + CGFloat(rHandlePosition * cosf(DEGREETORADIANS(degree: start))), y:origin.y - CGFloat(rHandlePosition * sinf(DEGREETORADIANS(degree: start))))
        circleBar?.paint(ctx, origin: circlePosition, handle_pos: handlePosition)
    
    }
    
    // paint middle slider bar 
    func paintMiddleSliderBar(_ ctx: CGContext,start: Float,end: Float,radius: Float,size: Float,origin: CGPoint){
        let rPosition = radius + size
        let edgeStartPosition = CGPoint(x: origin.x + CGFloat(rPosition * cosf(DEGREETORADIANS(degree: eyePosition!))), y: origin.y - CGFloat(rPosition * sinf(DEGREETORADIANS(degree: eyePosition!))))
        
        let arrowPointDirection = eyePosition! + 90.0
        ctx.saveGState()
        ctx.ctm.translatedBy(x: edgeStartPosition.x, y: edgeStartPosition.y)
        ctx.ctm.rotated(by: CGFloat(DEGREETORADIANS(degree: -arrowPointDirection)))
        slider?.paint(ctx)
        ctx.restoreGState()
    }
    
    
    // hit
    func hitTest(_ atPoint: CGPoint, radius: Float, size: Float, origin: CGPoint) -> HitObj{
        var hit = HitObj()
        hit.hitObject = TRObjs.none
        
        // convert atPoint to position in (angle , radius) coordinate position first
        let r = hypotf(Float(atPoint.x - origin.x), Float(atPoint.y - origin.y))
        var a = 180.0 * atan(Float(-(atPoint.y - origin.y) / (atPoint.x - origin.x))) / 3.14
        
        if (atPoint.x - origin.x) < 0{
            a += 180
        }
        
        // in case of drawing slider bars on outer decoration ring 
        let barRingOffset = ring!.outerDecorationRingOffset! + ring!.outerDecorationRingSize! * 0.5
        
        // 1. hit slider bar?
        let visibleBar = (showBar == true && fishEyeNeeded == true)
        let barHalfWidthAngle = 180.0 * slider!.length! / (3.14 * (radius + size + barRingOffset))
        if (visibleBar == true) && ((fabs(a - eyePosition!) <= barHalfWidthAngle) || (fabs(a - eyePosition! - 360.0) <= barHalfWidthAngle)) && (fabsf(radius + size + barRingOffset - r) <= slider!.height! * 0.5){
            hit.hitObject = TRObjs.columnBar
            return hit
        }
        
        // 2. hit begin arrow?
        var arrowHalfWidthAngle = 180.0 * Float(beginArrow!.width) / (3.14 * (radius + size + barRingOffset))
        var arrowPointDirection = min
        if beginArrow!.showArrow == true && ((fabs(a - arrowPointDirection!) <= arrowHalfWidthAngle) || (fabs(a - arrowPointDirection! - 360.0) <= arrowHalfWidthAngle)) && (fabsf(radius + size + barRingOffset - r) <= (Float(beginArrow!.height) * 0.5)){
            hit.hitObject = TRObjs.arrows_begin
            return hit
        }
        
        // 3. hit end arrow?
        arrowHalfWidthAngle = 180.0 * Float(endArrow!.width) / (3.14 * (radius + size + barRingOffset))
        arrowPointDirection = max
        if endArrow!.showArrow! == true && ((fabs(a - arrowPointDirection!) <= arrowHalfWidthAngle) || fabs(a - arrowPointDirection! - 360.0) <= arrowHalfWidthAngle) && fabsf(radius + size + barRingOffset - r) <= Float(endArrow!.height) * 0.5{
            hit.hitObject = TRObjs.arrows_end
            return hit
        }
        
        // 4. hit outside bar ring?
        if (a >= firstTickValue! && a <= lastTickValue! && r > radius && r < (radius + size)){
            hit.hitObject = TRObjs.column_axis
            return hit
        }
        
        // 5. hit label text
        let height = averageCharHeight
        for i in 0..<numberOfTicks!{
            let tick = ticks[i]
            let labelAnglePosition = tick.viewOffset
            var length: Float = Float(tick.label!.shortString!.characters.count * averageCharWidth!)
            if length > labelMargin! * pointsPerFontSize!{
                length = labelMargin! * pointsPerFontSize!
            }
            var labelCenter = radius + size + tick.viewSpace!
            var labelHalfWidthAngle: Float
            var labelHeight: Float
            if tickLabelDirection! == TickLabelOrientation.zero{
                // horizantal direction 
                labelHalfWidthAngle = 180.0 * length / (3.14 * (radius + size))
                labelHeight = Float(averageCharHeight!)
            }else if tickLabelDirection == TickLabelOrientation.radius{
                labelHalfWidthAngle = 180.0 * Float(height!) / (3.14 * (radius + size))
                labelHeight = length
            }else{
                labelHalfWidthAngle = 0.0
                labelHeight = 0.0
            }
            labelCenter += labelHeight * 0.5
            if ((fabs(a - labelAnglePosition!) <= barHalfWidthAngle || fabs(a - labelAnglePosition! - 360.0) <= labelHalfWidthAngle) &&
                fabsf(labelCenter - r) <= labelHeight * 0.5){
                hit.hitObject = TRObjs.column_axis_label
                hit.col = i
                return hit
            }
        }
        
        return hit
    }
}
