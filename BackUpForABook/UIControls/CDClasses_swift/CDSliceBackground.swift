//
//  CDSliceBackground.swift
//  ANBookPad
//
//  Created by dingf on 16/12/12.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

class CDSliceBackground: NSObject {
    // highlight state
    var highlight :Bool!
    // fill color
    var bkgColor :UIColor!
    // stroke edge color
    var edgeColor :UIColor!
    // region highlight color
    var highlightColor :UIColor!
    // highlight state background drawing style
    var highlightStyle :HighLightStyle!
    // normal state background drawing style
    var style :BackgroundStyle!
    
    override init() {
        super.init()
        highlight = false
        highlightStyle = HighLightStyle.fill
        style = BackgroundStyle.colorFill
        bkgColor = UIColor.blue
        edgeColor = UIColor.lightGray
        highlightColor = UIColor.white
    }
    
    // background paint ring slice background
    func paint(_ ctx: CGContext,
                size: RingSlice,
              center: CGPoint){
        
        // highlight state
        if highlight == true{
            if highlightStyle == HighLightStyle.fill{
                drawHighLightFilled(ctx, size: size, center: center)
            }else if highlightStyle == HighLightStyle.gradient{
                drawHighlightGradient(ctx, size: size, center: center)
            }
            return
        }
        
        // normal state
        if style == BackgroundStyle.colorFill{
            drawColorFilled(ctx, size: size, center: center)
        }else if style == BackgroundStyle.colorGradient{
            drawGradientFilled(ctx, size: size, center: center)
        }
    }
    func drawHighLightFilled(_ ctx:CGContext,size:RingSlice,center:CGPoint){
        ctx.saveGState()
        ctx.setFillColor(bkgColor.cgColor)
        ctx.setStrokeColor(edgeColor.cgColor)
        ctx.setLineWidth(0.5)
        ctx.beginPath()
        addPath(ctx, size: size, center: center)
        ctx.drawPath(using: .fillStroke)
        ctx.saveGState()
    }
    func drawHighlightGradient(_ ctx:CGContext,size:RingSlice,center:CGPoint){
        
        let num_locations: size_t = 3
        let locations: [CGFloat] = [0.0, 0.5, 1.0]
        var gradientColors: [CGFloat] = [0.0,0.0,1.0,0.7, 1.0,1.0,1.0,0.8, 0.0,0.0,1.0,0.7]
        
        // edge
        var colorref = edgeColor.cgColor
        var numComponents = colorref.numberOfComponents
        if numComponents >= 3{
            let components = colorref.components
            let red = components![0]
            let green = components![1]
            let blue = components![2]
            
            gradientColors[0] = red
            gradientColors[1] = green
            gradientColors[2] = blue
            gradientColors[3] = 0.6
            
            gradientColors[8] = red
            gradientColors[9] = green
            gradientColors[10] = blue
            gradientColors[11] = 0.6
        }
        
        // middle
        colorref = bkgColor.cgColor
        numComponents = colorref.numberOfComponents
        if numComponents >= 3{
            let components = colorref.components
            let red = components![0]
            let green = components![1]
            let blue = components![2]
            
            gradientColors[4] = red
            gradientColors[5] = green
            gradientColors[6] = blue
            gradientColors[7] = 0.2
            
        }
        
        let space = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient.init(colorSpace: space, colorComponents: gradientColors, locations: locations, count: num_locations)
        ctx.saveGState()
        ctx.beginPath()
        addPath(ctx, size: size, center: center)
        ctx.clip()
        let startRadius = size.bottom
        let endRadius = size.top
        ctx.drawRadialGradient(gradient!, startCenter: center, startRadius: startRadius!, endCenter: center, endRadius: endRadius!, options: .drawsBeforeStartLocation)
        ctx.restoreGState()
        
    }
    func drawColorFilled(_ ctx:CGContext,size:RingSlice, center:CGPoint){
        ctx.saveGState()
        ctx.setFillColor(bkgColor.cgColor)
        ctx.setStrokeColor(edgeColor.cgColor)
        ctx.setLineWidth(0.5)
        ctx.beginPath()
        addPath(ctx, size: size, center: center)
        ctx.drawPath(using: .fillStroke)
        ctx.saveGState()
    }
    
    // test draw gradient color
    func drawGradientFilled(_ ctx:CGContext, size:RingSlice, center:CGPoint){
        
        // gradient color numbers
        let num_locations: size_t = 3
        let locations: [CGFloat] = [0.0,0.5,1.0]
        // gradient color real value
        var gradientColors: [CGFloat] = [0.0,0.0,1.0,0.7,1.0,1.0,1.0,0.8,0.0,0.0,1.0,0.7]
        
        // edge
        var colorref = edgeColor.cgColor
        var numComponents = colorref.numberOfComponents
        if numComponents == 4{
            
            let components = colorref.components
            let red = components![0]
            let green = components![1]
            let blue = components![2]
            let alpha = components![3]
            
            gradientColors[0] = red
            gradientColors[1] = green
            gradientColors[2] = blue
            gradientColors[3] = alpha
            
            gradientColors[8] = red
            gradientColors[9] = green
            gradientColors[10] = blue
            gradientColors[11] = alpha
        }
        
        // middle
        colorref = bkgColor.cgColor
        numComponents = colorref.numberOfComponents
        if numComponents == 4{
            
            let components = colorref.components
            let red = components![0]
            let green = components![1]
            let blue = components![2]
            let alpha = components![3]
            
            gradientColors[4] = red
            gradientColors[5] = green
            gradientColors[6] = blue
            gradientColors[7] = alpha
            
        }
        
        let space = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient.init(colorSpace: space, colorComponents: gradientColors, locations: locations, count: num_locations)
        ctx.saveGState()
        ctx.beginPath()
        addPath(ctx, size: size, center: center)
        ctx.clip()
        let startRadius = size.bottom
        let endRadius = size.top
        ctx.drawRadialGradient(gradient!, startCenter: center, startRadius: startRadius!, endCenter: center, endRadius: endRadius!, options: .drawsBeforeStartLocation)
        ctx.restoreGState()
    }
    func addPath(_ ctx:CGContext,size:RingSlice,center:CGPoint){
        let aPath = UIBezierPath()
        // get path
        let minRadiusStart = CGPoint.init(x: center.x + size.bottom * CGFloat(cosf(Float(DEGREE_TO_RADIANS(size.right)))), y: center.y - size.bottom * CGFloat(sinf(Float(DEGREE_TO_RADIANS(size.right)))))
        let maxRadiusEnd = CGPoint.init(x: center.x + size.top * CGFloat(cosf(Float(DEGREE_TO_RADIANS(size.left)))), y: center.y - size.top * CGFloat(sinf(Float(DEGREE_TO_RADIANS(size.left)))))
        aPath.move(to: minRadiusStart)
        aPath.addArc(withCenter: center, radius: size.bottom, startAngle: -DEGREE_TO_RADIANS(size.right), endAngle: -DEGREE_TO_RADIANS(size.left), clockwise: false)
        aPath.addLine(to: maxRadiusEnd)
        aPath.addArc(withCenter: center, radius: size.top, startAngle: -DEGREE_TO_RADIANS(size.left), endAngle: -DEGREE_TO_RADIANS(size.right), clockwise: true)
        aPath.close()
        ctx.addPath(aPath.cgPath)
    }
}
