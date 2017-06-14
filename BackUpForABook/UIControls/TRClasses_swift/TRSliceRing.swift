//
//  TRSliceRing.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRSliceRing: NSObject {
    var backgroundShadow: Bool?
    var bkgColor: UIColor?
    var borderColor: UIColor?
    var lineWidth: Float?
    var size: Int?
    var showType: TRSliceRingBkg?
    var outerDecorationRingSize: Float?
    var outerDecorationGradientColorBegin2End: Bool?
    var outerDecorationRingOffset: Float?
    var outerDecorationRingFocus: Bool?
    var innerDecorationStyle: InnerDecoration?
    
    var gradientColor: UIColor?
    var gradientColor2: UIColor?
    var gradientColor3: UIColor?
    var gradientColor4: UIColor?
    var gradientColor5: UIColor?
    var gradientColor6: UIColor?
    var gradientColor7: UIColor?
    var gradientColor8: UIColor?
    var gradientColor9: UIColor?
    var gradientColor10: UIColor?
    var gradientColor11: UIColor?
    var gradientColor12: UIColor?
    var gradientColor13: UIColor?
    var gradientColor14: UIColor?
    var gradientColor15: UIColor?
    var gradientColor16: UIColor?
    var gradientColor17: UIColor?
    var gradientColor18: UIColor?
    var gradientColor19: UIColor?
    var gradientColor20: UIColor?
    var gradientColor21: UIColor?
    var gradientColor22: UIColor?
    var gradientColor23: UIColor?
    var gradientColor24: UIColor?
    var gradientColor25: UIColor?
    var gradientColor26: UIColor?
    var gradientColor27: UIColor?
    var gradientColor28: UIColor?
    var gradientColor29: UIColor?
    var gradientColor30: UIColor?
    var gradientColor31: UIColor?
    var gradientColor32: UIColor?
    var gradientColor33: UIColor?
    var gradientColor34: UIColor?
    var gradientColor35: UIColor?
    var gradientColor36: UIColor?
    var gradientColor37: UIColor?
    var gradientColor38: UIColor?
    var gradientColor39: UIColor?
    var gradientColor40: UIColor?
    var gradientColor41: UIColor?
    var fillColor1: UIColor?
    var fillColor2: UIColor?
    var fillColor3: UIColor?
    var fillColor4: UIColor?
    var strokeColor3: UIColor?
    
    override init() {
        super.init()
        initColor()
        backgroundShadow = true
        bkgColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.6)
        borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        lineWidth = 1.5
        size = 22
        showType = .metal
        outerDecorationRingSize = 8.0
        outerDecorationGradientColorBegin2End = true
        outerDecorationRingOffset = 4
        outerDecorationRingFocus = true
        innerDecorationStyle = .whiteBlack
    }
    
    func initColor(){
        gradientColor = UIColor(red: 0.004, green: 0.004, blue: 0.004, alpha: 0.5)
        gradientColor2 = UIColor(red: 0.004, green: 0.004, blue: 0.004, alpha: 0)
        gradientColor3 = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        gradientColor4 = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        gradientColor5 = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        gradientColor6 = UIColor(red: 0.973, green: 0.973, blue: 0.988, alpha: 1)
        gradientColor7 = UIColor(red: 0.788, green: 0.816, blue: 0.918, alpha: 1)
        gradientColor8 = UIColor(red: 0.639, green: 0.698, blue: 0.859, alpha: 1)
        gradientColor9 = UIColor(red: 0.522, green: 0.608, blue: 0.812, alpha: 1)
        gradientColor10 = UIColor(red: 0.435, green: 0.545, blue: 0.78, alpha: 1)
        gradientColor11 = UIColor(red: 0.365, green: 0.502, blue: 0.753, alpha: 1)
        gradientColor12 = UIColor(red: 0.31, green: 0.471, blue: 0.737, alpha: 1)
        gradientColor13 = UIColor(red: 0.275, green: 0.455, blue: 0.729, alpha: 1)
        gradientColor14 = UIColor(red: 0.267, green: 0.451, blue: 0.725, alpha: 1)
        gradientColor15 = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 0.5)
        gradientColor16 = UIColor(red: 0.231, green: 0.231, blue: 0.231, alpha: 0.5)
        gradientColor17 = UIColor(red: 0.922, green: 0.922, blue: 0.922, alpha: 0.5)
        gradientColor18 = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 0.5)
        gradientColor19 = UIColor(red: 0.659, green: 0.659, blue: 0.659, alpha: 0.5)
        gradientColor20 = UIColor(red: 0.518, green: 0.518, blue: 0.518, alpha: 0.5)
        gradientColor21 = UIColor(red: 0.408, green: 0.408, blue: 0.408, alpha: 0.5)
        gradientColor22 = UIColor(red: 0.318, green: 0.318, blue: 0.318, alpha: 0.5)
        gradientColor23 = UIColor(red: 0.259, green: 0.259, blue: 0.259, alpha: 0.5)
        gradientColor24 = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.5)
        gradientColor25 = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 0.5)
        gradientColor26 = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 0.5)
        gradientColor27 = UIColor(red: 0.384, green: 0.384, blue: 0.384, alpha: 0.5)
        gradientColor28 = UIColor(red: 0.69, green: 0.69, blue: 0.69, alpha: 0.5)
        gradientColor29 = UIColor(red: 0.839, green: 0.839, blue: 0.839, alpha: 0.5)
        gradientColor30 = UIColor(red: 0.749, green: 0.749, blue: 0.749, alpha: 0.5)
        gradientColor31 = UIColor(red: 0.655, green: 0.655, blue: 0.655, alpha: 0.5)
        gradientColor32 = UIColor(red: 0.584, green: 0.584, blue: 0.584, alpha: 0.5)
        gradientColor33 = UIColor(red: 0.545, green: 0.545, blue: 0.545, alpha: 0.5)
        gradientColor34 = UIColor(red: 0.529, green: 0.529, blue: 0.529, alpha: 0.5)
        gradientColor35 = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 0.5)
        gradientColor36 = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1)
        gradientColor37 = UIColor(red: 0.675, green: 0.675, blue: 0.675, alpha: 1)
        gradientColor38 = UIColor(red: 0.718, green: 0.718, blue: 0.718, alpha: 1)
        gradientColor39 = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1)
        gradientColor40 = UIColor(red: 0.686, green: 0.686, blue: 0.686, alpha: 1)
        gradientColor41 = UIColor(red: 0.722, green: 0.722, blue: 0.722, alpha: 1)
        fillColor1 = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        fillColor2 = UIColor(red: 0.506, green: 0.506, blue: 0.506, alpha: 1)
        fillColor3 = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        fillColor4 = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)
        strokeColor3 = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    }
    
    func paint(_ ctx: CGContext, start: Float, end: Float, radius: Float, size: Float, origin: CGPoint){
        
        // the ring
        if showType == .metal{
            paintMetal(ctx, start: start, end: end, radius: radius, size: size, origin: origin)
        }else if showType == .simple{
        
        
        }
        
        // outer decoration : position -> radius + size + outerDecorationRingOffset size -> outerDecorationRingSize
        paint_decorationRing_outer(ctx, start: start, end: end, radius: radius + size + outerDecorationRingOffset!, size: outerDecorationRingSize!, origin: origin)
        
        // inner decoration : position -> radius size -> 12
        paint_decorationRing_inner(ctx, start: start, end: end, radius: radius, size: 12, origin: origin)
      
    }
    
    fileprivate func paint_decorationRing_inner(_ ctx: CGContext, start: Float, end: Float, radius: Float, size: Float, origin: CGPoint){
        // bezier for outside edge
        let bezierLowPath = UIBezierPath()
        var bezierUpPath = UIBezierPath()
        
        // ring width of narrow band
        let rw: Float = 3.0
        let minRadiusStart = CGPoint(x: origin.x + CGFloat((radius - size) * cosf(DEGREETORADIANS(degree: start))), y: origin.y - CGFloat((radius - size) * sinf(DEGREETORADIANS(degree: start))))
        //let minRadiusEnd = CGPoint(x: origin.x + CGFloat((radius - size) * cosf(DEGREETORADIANS(degree: end))), y: origin.y - CGFloat((radius - size) * sinf(DEGREETORADIANS(degree: end))))
        
        let middleRadiusStart = CGPoint(x: origin.x + CGFloat((radius - rw) * cosf(DEGREETORADIANS(degree: start))), y: origin.y - CGFloat((radius - rw) * sinf(DEGREETORADIANS(degree: start))))
        let middleRadiusEnd = CGPoint(x: origin.x + CGFloat((radius - rw) * cosf(DEGREETORADIANS(degree: end))), y: origin.y - CGFloat((radius - rw) * sinf(DEGREETORADIANS(degree: end))))
        
        //let maxRadiusStart = CGPoint(x: origin.x + CGFloat(radius * cosf(DEGREETORADIANS(degree: start))), y: origin.y - CGFloat(radius * sinf(DEGREETORADIANS(degree: end))))
        let maxRadiusEnd = CGPoint(x: origin.x + CGFloat(radius * cosf(DEGREETORADIANS(degree: end))), y: origin.y - CGFloat(radius * sinf(DEGREETORADIANS(degree: end))))
        
        // lower rect
        bezierLowPath.move(to: minRadiusStart)
        bezierLowPath.addArc(withCenter: origin, radius: CGFloat(radius - size), startAngle:-(CGFloat)(DEGREETORADIANS(degree: start)), endAngle:-(CGFloat)(DEGREETORADIANS(degree: end)), clockwise: false)
        bezierLowPath.addLine(to: middleRadiusEnd)
        bezierLowPath.addArc(withCenter: origin, radius: CGFloat(radius - rw), startAngle: -(CGFloat)(DEGREETORADIANS(degree: end)), endAngle: -(CGFloat)(DEGREETORADIANS(degree: start)), clockwise: true)
        bezierLowPath.close()
        
        // upper rect
        bezierUpPath = UIBezierPath()
        bezierUpPath.move(to: middleRadiusStart)
        bezierUpPath.addArc(withCenter: origin, radius: CGFloat(radius - rw), startAngle:-(CGFloat)(DEGREETORADIANS(degree: start)), endAngle:-(CGFloat)(DEGREETORADIANS(degree: end)), clockwise: false)
        bezierUpPath.addLine(to: maxRadiusEnd)
        bezierUpPath.addArc(withCenter: origin, radius: CGFloat(radius), startAngle: -(CGFloat)(DEGREETORADIANS(degree: end)), endAngle: -(CGFloat)(DEGREETORADIANS(degree: start)), clockwise: true)
        bezierUpPath.close()
        
        if innerDecorationStyle == InnerDecoration.blackGray{
            fillColor1?.setFill()
            bezierUpPath.fill()
            fillColor2?.setFill()
            bezierLowPath.fill()
        }else if innerDecorationStyle == InnerDecoration.whiteBlack{
            fillColor3?.setFill()
            bezierUpPath.fill()
            fillColor1?.setFill()
            bezierLowPath.fill()
        }
       
    }
    
    fileprivate func paint_decorationRing_outer(_ ctx: CGContext, start: Float, end: Float, radius: Float, size: Float, origin: CGPoint){
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let minRadiusStart = CGPoint(x: origin.x + CGFloat(radius * cosf(DEGREETORADIANS(degree: start))), y: origin.y - CGFloat(radius * sinf(DEGREETORADIANS(degree: start))))
        //let minRadiusEnd = CGPoint(x: origin.x + CGFloat(radius * cosf(DEGREETORADIANS(degree: end))), y: origin.y - CGFloat(radius * sinf(DEGREETORADIANS(degree: end))))
        
        let maxRadiusStart = CGPoint(x: origin.x + CGFloat((radius + size) * cosf(DEGREETORADIANS(degree: start))), y: origin.y - CGFloat((radius + size) * sinf(DEGREETORADIANS(degree: start))))
        let maxRadiusEnd = CGPoint(x: origin.x + CGFloat((radius + size) * cosf(DEGREETORADIANS(degree: end))), y: origin.y - CGFloat((radius + size) * sinf(DEGREETORADIANS(degree: end))))
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: minRadiusStart)
        bezierPath.addArc(withCenter: origin, radius: CGFloat(radius), startAngle: -(CGFloat)(DEGREETORADIANS(degree: start)), endAngle: -(CGFloat)(DEGREETORADIANS(degree: end)), clockwise: false)
        bezierPath.addLine(to: maxRadiusEnd)
        bezierPath.addArc(withCenter: origin, radius: CGFloat(radius + size), startAngle: -(CGFloat)(DEGREETORADIANS(degree: end)), endAngle: -(CGFloat)(DEGREETORADIANS(degree: start)), clockwise: true)
        bezierPath.close()
        
        if outerDecorationRingFocus == true{
            let sVGID_5_Locations: [CGFloat] = [0, 0.01, 0.09, 0.19, 0.29, 0.39, 0.5, 0.63, 0.78, 1]
            let sVGID_5 = CGGradient.init(colorsSpace: colorSpace, colors: [gradientColor5!.cgColor,gradientColor6!.cgColor,gradientColor7!.cgColor,gradientColor8!.cgColor,gradientColor9!.cgColor,gradientColor10!.cgColor,gradientColor11!.cgColor,gradientColor12!.cgColor,gradientColor13!.cgColor,gradientColor14!.cgColor] as CFArray, locations: sVGID_5_Locations)
            ctx.saveGState()
            bezierPath.addClip()
            
            if outerDecorationGradientColorBegin2End == true{
                ctx.drawLinearGradient(sVGID_5!, start: CGPoint.init(x: maxRadiusEnd.x, y: (maxRadiusStart.y + maxRadiusEnd.y) / 2), end: CGPoint.init(x: maxRadiusStart.x, y: (maxRadiusStart.y + maxRadiusEnd.y ) / 2), options: .drawsBeforeStartLocation)
            }else{
                ctx.drawLinearGradient(sVGID_5!, start: CGPoint.init(x: maxRadiusStart.x, y: (maxRadiusStart.y + maxRadiusEnd.y) / 2), end: CGPoint.init(x: maxRadiusEnd.x, y: (maxRadiusStart.y + maxRadiusEnd.y ) / 2), options: .drawsBeforeStartLocation)
            
            }
            ctx.restoreGState()
           
        }else{
            fillColor4?.setFill()
            bezierPath.fill()
        }
        strokeColor3?.setStroke()
        bezierPath.lineWidth = 3
        bezierPath.stroke()
        
    }
    
    func paintMetal(_ ctx: CGContext,start: Float,end: Float,radius: Float,size: Float,origin: CGPoint){
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //let sVGID_6_Locations: [CGFloat] = [0, 1]
        //let sVGID_6 = CGGradient.init(colorsSpace: colorSpace, colors: [gradientColor?.cgColor,gradientColor2?.cgColor] as CFArray, locations: sVGID_6_Locations)
        
        //let sVGID_3_Locations: [CGFloat] = [0, 1]
        //let sVGID_3 = CGGradient.init(colorsSpace: colorSpace, colors: [gradientColor3?.cgColor,gradientColor4?.cgColor] as CFArray, locations: sVGID_3_Locations)
        
        //let sVGID_5_Locations: [CGFloat] = [0, 0.01, 0.09, 0.19, 0.29, 0.39, 0.5, 0.63, 0.78, 1]
        //let sVGID_5 = CGGradient.init(colorsSpace: colorSpace, colors: [gradientColor5?.cgColor,gradientColor6?.cgColor,gradientColor7?.cgColor,gradientColor8?.cgColor,gradientColor9?.cgColor,gradientColor10?.cgColor,gradientColor11?.cgColor,gradientColor12?.cgColor,gradientColor13?.cgColor,gradientColor14?.cgColor] as CFArray, locations: sVGID_5_Locations)
        
        let sVGID_2_Locations: [CGFloat] = [0, 0.19, 0.41, 0.42, 0.44, 0.46, 0.48, 0.5, 0.53, 0.56, 0.59, 0.62, 0.65, 0.69, 0.72, 0.76, 0.79, 0.81, 0.83, 0.86, 0.89, 0.93, 1]
        let sVGID_2 = CGGradient.init(colorsSpace: colorSpace, colors: [gradientColor15?.cgColor,
                                                                        gradientColor16?.cgColor,
                                                                        gradientColor17?.cgColor,
                                                                        gradientColor18?.cgColor,
                                                                        gradientColor19?.cgColor,gradientColor20?.cgColor,gradientColor21?.cgColor,gradientColor22?.cgColor,gradientColor23?.cgColor,gradientColor24?.cgColor,gradientColor25?.cgColor,gradientColor16?.cgColor,gradientColor26?.cgColor,gradientColor27?.cgColor,gradientColor20?.cgColor,gradientColor28?.cgColor,gradientColor29?.cgColor,gradientColor30?.cgColor,gradientColor31?.cgColor,gradientColor32?.cgColor,gradientColor33?.cgColor,gradientColor34?.cgColor,gradientColor35?.cgColor] as CFArray, locations: sVGID_2_Locations)
        
        //let sVGID_4_Locations: [CGFloat] = [0.11, 0.24, 0.35, 0.54, 0.69, 0.77, 0.85, 1]
        //let sVGID_4 = CGGradient.init(colorsSpace: colorSpace, colors: [gradientColor36?.cgColor,gradientColor5?.cgColor,gradientColor37?.cgColor,gradientColor5?.cgColor,gradientColor38?.cgColor,gradientColor39?.cgColor,gradientColor40?.cgColor,gradientColor41?.cgColor] as CFArray, locations: sVGID_4_Locations)
        
        let minRadiusStart = CGPoint(x: origin.x + CGFloat(radius * cosf(DEGREETORADIANS(degree: start))), y: origin.y - CGFloat(radius * sinf(DEGREETORADIANS(degree: start))))
        let minRadiusEnd = CGPoint(x: origin.x + CGFloat(radius * cosf(DEGREETORADIANS(degree: end))), y: origin.y - CGFloat(radius * sinf(DEGREETORADIANS(degree: end))))
        
        let middleRadiusStart = CGPoint(x: origin.x + CGFloat((radius + size / 2) * cosf(DEGREETORADIANS(degree: start))), y: origin.y - CGFloat((radius + size / 2) * sinf(DEGREETORADIANS(degree: start))))
        let middleRadiusEnd = CGPoint(x: origin.x + CGFloat((radius + size / 2) * cosf(DEGREETORADIANS(degree: end))), y: origin.y - CGFloat((radius + size / 2) * sinf(DEGREETORADIANS(degree: end))))
        
        //let maxRadiusStart = CGPoint(x: origin.x + CGFloat((radius + size) * cosf(DEGREETORADIANS(degree: start))), y: origin.y - CGFloat((radius + size) * sinf(DEGREETORADIANS(degree: start))))
        let maxRadiusEnd = CGPoint(x: origin.x + CGFloat((radius + size) * cosf(DEGREETORADIANS(degree: end))), y: origin.y - CGFloat((radius + size) * sinf(DEGREETORADIANS(degree: end))))
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: minRadiusStart)
        bezierPath.addArc(withCenter: origin, radius: CGFloat(radius), startAngle: -(CGFloat)(DEGREETORADIANS(degree: start)), endAngle: -(CGFloat)(DEGREETORADIANS(degree: end)), clockwise: false)
        bezierPath.addLine(to: maxRadiusEnd)
        bezierPath.addArc(withCenter: origin, radius: CGFloat(radius + size), startAngle: -(CGFloat)(DEGREETORADIANS(degree: end)), endAngle: -(CGFloat)(DEGREETORADIANS(degree: start)), clockwise: true)
        bezierPath.close()
        bezierPath.miterLimit = 4
        fillColor2?.setFill()
        bezierPath.fill()
        
        // bezier for middle edge
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: middleRadiusStart)
        bezier2Path.addArc(withCenter: origin, radius: CGFloat(radius + size / 2), startAngle: -(CGFloat)(DEGREETORADIANS(degree: start)), endAngle: -(CGFloat)(DEGREETORADIANS(degree: end)), clockwise: false)
        bezier2Path.addLine(to: minRadiusEnd)
        bezier2Path.addArc(withCenter: origin, radius: CGFloat(radius), startAngle: -(CGFloat)(DEGREETORADIANS(degree: end)), endAngle: -(CGFloat)(DEGREETORADIANS(degree: start)), clockwise: true)
        bezier2Path.close()
        bezier2Path.miterLimit = 4
        
        ctx.saveGState()
        bezier2Path.addClip()
        ctx.drawLinearGradient(sVGID_2!, start: CGPoint.init(x: middleRadiusEnd.x, y: CGFloat(radius / 2)), end: CGPoint.init(x: middleRadiusStart.x, y: CGFloat(radius / 2)), options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        ctx.restoreGState()
    }

}
