//
//  TRSliceBackground.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRSliceBackground: NSObject {
    var highlight: Bool?
    var highlightStyle: HighLightStyle?
    var style: BackgroundStyle?
    var bkgColor: UIColor?
    var edgeColor: UIColor?
    var highlightColor: UIColor?
    override init() {
        super.init()
        highlight = false
        highlightStyle = .fill
        style = .colorFill
        bkgColor = UIColor.black
        edgeColor = UIColor.darkText
    }
    
    func paint(_ ctx: CGContext, size:Slice, center: CGPoint){
        if highlight == true{
            if highlightStyle == .fill{
                drawHighlightFilled(ctx, size: size, center: center)
                print("TRSliceBackground.paint - highlightStyle == .fill")
            }
            return
        }
        
        if style == .colorFill{
            drawColorFilled(ctx, size: size, center: center)
        }
    }
    
    func drawHighlightFilled(_ ctx: CGContext, size: Slice,center: CGPoint){
        ctx.saveGState()
        ctx.setFillColor(bkgColor!.cgColor)
        ctx.setStrokeColor(edgeColor!.cgColor)
        ctx.setLineWidth(0.5)
        ctx.beginPath()
        
        // add path
        addPath(ctx, size: size, origin: center)
        
        // 
        ctx.drawPath(using: .fillStroke)
        ctx.restoreGState()
        
    }
    
    func drawColorFilled(_ ctx: CGContext, size: Slice, center: CGPoint){
        ctx.saveGState()
        ctx.setFillColor(bkgColor!.cgColor)
        ctx.setStrokeColor(edgeColor!.cgColor)
        ctx.setLineWidth(0.5)
        ctx.beginPath()
        addPath(ctx, size: size, origin: center)
        ctx.drawPath(using: .fillStroke)
        ctx.restoreGState()
    }
    
    func addPath(_ ctx: CGContext, size: Slice, origin: CGPoint){
        let aPath = UIBezierPath.init()
        let minRadiusStart = CGPoint(x: origin.x + CGFloat(size.bottom!) * CGFloat(cosf(DEGREETORADIANS(degree: size.right!))), y: origin.y - CGFloat(size.bottom!) * CGFloat(sinf(DEGREETORADIANS(degree: size.right!))))
        
        let maxRadiusEnd = CGPoint(x: origin.x + CGFloat(size.top!) * CGFloat(cosf(DEGREETORADIANS(degree: size.left!))), y: origin.y - CGFloat(size.top!) * CGFloat(sinf(DEGREETORADIANS(degree: size.left!))))
        aPath.move(to: minRadiusStart)
        aPath.addArc(withCenter: origin, radius: CGFloat(size.bottom!), startAngle: -(CGFloat)(DEGREETORADIANS(degree: size.right!)), endAngle: -(CGFloat)(DEGREETORADIANS(degree: size.left!)), clockwise: false)
        aPath.addLine(to: maxRadiusEnd)
        aPath.addArc(withCenter: origin, radius: CGFloat(size.top!), startAngle: -(CGFloat)(DEGREETORADIANS(degree: size.left!)), endAngle: -CGFloat(DEGREETORADIANS(degree: size.right!)), clockwise: true)
        aPath.close()
        ctx.addPath(aPath.cgPath)
    }
    
    

    

}
