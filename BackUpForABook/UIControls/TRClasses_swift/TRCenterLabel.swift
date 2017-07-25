//
//  TRCenterLabel.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/24.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRCenterLabel: NSObject {
    var metricInfo: ANText?
    var metricValue: ANText?
    var title: ANText?
    var bkgColorHi: UIColor?
    var bkgColorLo: UIColor?
    
    
    
    override init() {
        super.init()
        metricInfo = ANText.init("Helvetica", size: 12, shadow: false, underline: false)
        metricValue = ANText.init("Helvetica", size: 20, shadow: true, underline: false)
        title = ANText.init("Helvetica-Bold", size: 12, shadow: false, underline: false)
        
        bkgColorHi = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        bkgColorLo = UIColor(red: 255/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1.0)
    }
    
    // paint
    func paint(_ ctx: CGContext, radius: Float, origin: CGPoint,borderWidth: Float){
        paintBorder(ctx, radius: radius + borderWidth / 2.0, origin: origin,width: borderWidth)
        // 1. background
        paintGradient2(ctx, radius: radius, origin: origin)
        
        // 2. title
        let titleSize = title?.attributedText.size()
        var rect = CGRect(x: origin.x - 0.5 * titleSize!.width, y: origin.y + titleSize!.height, width: titleSize!.width, height: titleSize!.height + 2)
        title?.paint(ctx, rect: rect)
        
        // 3. metric value
        let metricValueSize = metricValue?.attributedText.size()
        rect = CGRect(x: origin.x - 0.5 * metricValueSize!.width, y: origin.y - 0.5 * metricValueSize!.height, width: metricValueSize!.width, height: metricValueSize!.height + 2)
        metricValue?.paint(ctx, rect: rect)
        
        // 4. metric
        let metricSize = metricInfo?.attributedText.size()
        rect = CGRect(x: origin.x - 0.5 * metricSize!.width, y: origin.y - metricValueSize!.height - 0.5 * metricSize!.height, width: metricSize!.width, height: metricSize!.height + 2)
        metricInfo?.paint(ctx, rect: rect)

    }
    
    // color border of center label
    fileprivate func paintBorder(_ ctx: CGContext,radius: Float, origin: CGPoint,width: Float){

        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.setLineWidth(CGFloat(width))
        ctx.addArc(center: origin, radius: CGFloat(radius), startAngle: CGFloat(DEGREETORADIANS(degree: 0.0)), endAngle:  (CGFloat(DEGREETORADIANS(degree: 180))), clockwise: true)
        ctx.drawPath(using: CGPathDrawingMode.stroke)
      
    }
    
    fileprivate func paintGradient2(_ ctx: CGContext,radius: Float, origin: CGPoint){
        // gradient color
        let num_locations = 2
        let locations: [CGFloat] = [0.0, 1.0]
        
        // gradient color
        var gradientColors: [CGFloat] = [0.0, 0.0, 1.0, 0.7, 1.0, 1.0, 1.0, 0.8]
        
        // edge
        var colorref = bkgColorLo?.cgColor
        var numComponents = colorref?.numberOfComponents
        if numComponents == 4{
            let components = colorref?.components
            let red = components?[0]
            let green = components?[1]
            let blue = components?[2]
            let alpha = components?[3]
            
            gradientColors[4] = red!
            gradientColors[5] = green!
            gradientColors[6] = blue!
            gradientColors[7] = alpha!
        }
        // center
        colorref = bkgColorHi?.cgColor
        numComponents = colorref?.numberOfComponents
        if numComponents == 4{
            let components = colorref?.components
            let red = components?[0]
            let green = components?[1]
            let blue = components?[2]
            let alpha = components?[3]
            
            gradientColors[0] = red!
            gradientColors[1] = green!
            gradientColors[2] = blue!
            gradientColors[3] = alpha!
        }
        
        let space = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient.init(colorSpace: space, colorComponents: gradientColors, locations: locations, count: num_locations)
        
        let aPath = UIBezierPath()
        aPath.addArc(withCenter: origin, radius: CGFloat(radius), startAngle: -CGFloat(DEGREETORADIANS(degree: 0.0)), endAngle: -(CGFloat(DEGREETORADIANS(degree: 180))), clockwise: false)
        aPath.close()
        
        ctx.saveGState()
        ctx.beginPath()
        ctx.addPath(aPath.cgPath)
        ctx.clip()
        ctx.setShadow(offset: CGSize.init(width: 0, height: 3.0), blur: 3.0, color: UIColor.gray.cgColor)
        ctx.drawRadialGradient(gradient!, startCenter: origin, startRadius: 0.0, endCenter: origin, endRadius: CGFloat(radius), options: .drawsBeforeStartLocation)
        ctx.restoreGState()
    }

}
