//
//  TRSliceGrid.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRSliceGrid: NSObject {
    var cellShowAsLayer: Bool?
    var columnGridLine: TRGridLine?
    var rowGridLine: TRGridLine?
    var rowFocus: Int?
    var columnFocus: Int?
    // even
    var evenRowBackgroundColor: UIColor?
    // odd
    var oddRowBackgroundColor: UIColor?
    
    var highlightedCellBackgroundColor: UIColor?
    var highlightedCellBorderColor: UIColor?
    
    
    override init() {
        cellShowAsLayer = true
        columnGridLine = TRGridLine.init()
        rowGridLine = TRGridLine.init()
        rowFocus = -1
        columnFocus = -1
        
    }
    
    func paint(_ ctx: CGContext, table: TRDataTableSliceView, size: Slice,origin: CGPoint, ringAxis: TRAxis, angleAxis: TRAxis){
        // paint grid background
        ctx.saveGState()
        paintGridRingBackground(ctx, size: size, origin: origin, ringAxis: ringAxis)
        ctx.restoreGState()
        // paint grid lines
        ctx.saveGState()
        paintGridLines(ctx, size: size, origin: origin, ringAxis: ringAxis, angleAxis: angleAxis)
        ctx.restoreGState()
        // paint grid cells
        if cellShowAsLayer == false{
            ctx.saveGState()
            paintCells(ctx, table: table, size: size, origin: origin, ringAxis: ringAxis, angleAxis: angleAxis)
        
        }
    }
    // paint grid background
    func paintGridRingBackground(_ ctx: CGContext, size: Slice, origin : CGPoint, ringAxis: TRAxis){
        let aPath = UIBezierPath()
        if evenRowBackgroundColor != nil && ringAxis.numberOfTicks! > 0{
            for i in 0..<ringAxis.numberOfTicks! - 1{
                if i % 2 == 0{
                    // radius of this ring
                    let radius = (ringAxis.position(i + 1) + ringAxis.position(i)) / 2.0
                    // width of this ring
                    let width = ringAxis.position(i + 1) - ringAxis.position(i)
                    // add arc
                    aPath.addArc(withCenter: origin, radius: CGFloat(radius), startAngle: -(CGFloat)(DEGREETORADIANS(degree: size.right!)), endAngle: -(CGFloat)(DEGREETORADIANS(degree: size.left!)), clockwise: false)
                    ctx.beginPath()
                    ctx.addPath(aPath.cgPath)
                    ctx.setLineWidth(CGFloat(width))
                    ctx.setStrokeColor(evenRowBackgroundColor!.cgColor)
                    ctx.strokePath()
                    aPath.removeAllPoints()
                }
            }
        }
        if oddRowBackgroundColor != nil && ringAxis.numberOfTicks! > 0{
            for i in 0..<ringAxis.numberOfTicks! - 1{
                if i % 2 != 0{
                    // radius of this ring
                    let radius = (ringAxis.position(i + 1) + ringAxis.position(i)) / 2.0
                    // width of this ring
                    let width = ringAxis.position(i + 1) - ringAxis.position(i)
                    // add arc
                    aPath.addArc(withCenter: origin, radius: CGFloat(radius), startAngle: -(CGFloat)(DEGREETORADIANS(degree: size.right!)), endAngle: -(CGFloat)(DEGREETORADIANS(degree: size.left!)), clockwise: false)
                    ctx.beginPath()
                    ctx.addPath(aPath.cgPath)
                    ctx.setLineWidth(CGFloat(width))
                    ctx.setStrokeColor(oddRowBackgroundColor!.cgColor)
                    ctx.strokePath()
                    aPath.removeAllPoints()
                }
            }
        }
    }
    
    // paint grid lines
    func paintGridLines(_ ctx: CGContext, size: Slice, origin: CGPoint, ringAxis: TRAxis, angleAxis: TRAxis){
        // paint row grid lines : circle ring
        paintRowGridLines(ctx, size: size, origin: origin, ringAxis: ringAxis, angleAxis: angleAxis)
        // paint column grid lines : line
        paintColumnGridLines(ctx, size: size, origin: origin, ringAxis: ringAxis, angleAxis: angleAxis)
        // paint focusing row or column
        if rowFocus! >= 0 && rowFocus! < ringAxis.numberOfTicks!{
            paintRowGridLines_Neon(ctx, origin: origin, ringAxis: ringAxis, rowFocus: rowFocus!, beginAngle: size.right!, endAngle: size.left!)
        }
        if columnFocus! >= 0 && columnFocus! < angleAxis.numberOfTicks!{
            paintColumnGridLine_Neon(ctx, origin: origin, angleAxis: angleAxis, columnFocus: columnFocus!, beginRadius: size.bottom!, endRadius: size.top!)
        }
        
    }
    
    // paint row grid line(x axis)
    func paintRowGridLines(_ ctx: CGContext, size: Slice, origin: CGPoint, ringAxis: TRAxis, angleAxis: TRAxis){
        let aPath = UIBezierPath()
        
        // draw row grid start from size.bottom to size.top
        let angle = size.right
        
        for i in 0..<ringAxis.numberOfTicks!{
            // radius fo this ring
            let radius = ringAxis.position(i)
            // move to the beginning angle line 
            let bpt = CGPoint(x: origin.x + CGFloat(radius * cosf(DEGREETORADIANS(degree: angle!))), y: origin.y - CGFloat(radius * sinf(DEGREETORADIANS(degree: angle!))))
            
            aPath.move(to: bpt)
            
            aPath.addArc(withCenter: origin, radius: CGFloat(radius), startAngle: -CGFloat(DEGREETORADIANS(degree: size.right!)), endAngle: -CGFloat(DEGREETORADIANS(degree: size.left!)), clockwise: false)
        }
        if rowGridLine?.style == .dash{
            let dash: [CGFloat] = [2.0, 2.0]
            ctx.setLineDash(phase: 0.0, lengths: dash)
        }
        // draw the path
        ctx.beginPath()
        ctx.addPath(aPath.cgPath)
        ctx.setLineWidth(CGFloat(rowGridLine!.size!))
        ctx.setStrokeColor(rowGridLine!.color!.cgColor)
        ctx.strokePath()
    }
    
    // paint column grid line(y axis)
    func paintColumnGridLines(_ ctx: CGContext, size: Slice, origin: CGPoint, ringAxis: TRAxis, angleAxis: TRAxis){
        let aPath = UIBezierPath()
        
        // draw column grid start from the right to left
        for i in 0..<angleAxis.numberOfTicks!{
            // radius fo this ring
            let angle = angleAxis.position(i)
            // move to the beginning angle line
            let bpt = CGPoint(x: origin.x + CGFloat(size.bottom! * cosf(DEGREETORADIANS(degree: angle))), y: origin.y - CGFloat(size.bottom! * sinf(DEGREETORADIANS(degree: angle))))
            
            let ept = CGPoint(x: origin.x + CGFloat(size.top! * cosf(DEGREETORADIANS(degree: angle))), y: origin.y - CGFloat(size.top! * sinf(DEGREETORADIANS(degree: angle))))
            aPath.move(to: bpt)
            aPath.addLine(to: ept)
        }
        if rowGridLine?.style == .dash{
            let dash: [CGFloat] = [2.0, 2.0]
            ctx.setLineDash(phase: 0.0, lengths: dash)
        }
        // draw the path
        ctx.beginPath()
        ctx.addPath(aPath.cgPath)
        ctx.setLineWidth(CGFloat(columnGridLine!.size!))
        ctx.setStrokeColor(columnGridLine!.color!.cgColor)
        ctx.strokePath()
      
    }
    
    // paint neon light style type of line 
    func paintRowGridLines_Neon(_ ctx: CGContext, origin: CGPoint, ringAxis: TRAxis, rowFocus: Int, beginAngle: Float, endAngle: Float){
        let aPath = UIBezierPath()
        if rowFocus >= ringAxis.numberOfTicks!{return}
        let radius = ringAxis.position(rowFocus)
        let bpt = CGPoint(x: origin.x + CGFloat(radius * cosf(DEGREETORADIANS(degree: beginAngle))), y: origin.y - CGFloat(radius * sinf(DEGREETORADIANS(degree: beginAngle))))
        aPath.move(to: bpt)
        aPath.addArc(withCenter: origin, radius: CGFloat(radius), startAngle: -(CGFloat)(DEGREETORADIANS(degree: beginAngle)), endAngle: -(CGFloat)(DEGREETORADIANS(degree: endAngle)), clockwise: false)
        
        drawNeonPath(ctx, aPath: aPath, lineColor: UIColor.blue.cgColor, neonColor: UIColor.white.cgColor)
    }
    
    func paintColumnGridLine_Neon(_ ctx: CGContext, origin: CGPoint, angleAxis: TRAxis, columnFocus: Int, beginRadius: Float, endRadius: Float){
        let aPath = UIBezierPath()
 
        let angle = angleAxis.position(columnFocus)
        let bpt = CGPoint(x: origin.x + CGFloat(beginRadius * cosf(DEGREETORADIANS(degree: angle))), y: origin.y - CGFloat(beginRadius * sinf(DEGREETORADIANS(degree: angle))))
        let ept = CGPoint(x: origin.x + CGFloat(endRadius * cosf(DEGREETORADIANS(degree: angle))), y: origin.y - CGFloat(endRadius * sinf(DEGREETORADIANS(degree: angle))))
        aPath.move(to: bpt)
        aPath.addLine(to: ept)
        
        drawNeonPath(ctx, aPath: aPath, lineColor: UIColor.blue.cgColor, neonColor: UIColor.white.cgColor)
    }
    
    // draw neon path
    func drawNeonPath(_ ctx: CGContext, aPath: UIBezierPath, lineColor: CGColor, neonColor: CGColor){
        ctx.setLineDash(phase: 0.0, lengths: [2.0, 0])
        ctx.beginPath()
        ctx.addPath(aPath.cgPath)
        ctx.setShadow(offset: CGSize.init(width: 0, height: 0), blur: 20.0, color: neonColor)
        ctx.setLineWidth(5)
        ctx.setStrokeColor(lineColor)
        ctx.strokePath()
        
        ctx.addPath(aPath.cgPath)
        ctx.setShadow(offset: CGSize.init(width: 0, height: 0), blur: 10.0, color: lineColor)
        ctx.setLineWidth(3.0)
        ctx.setStrokeColor(neonColor)
        ctx.strokePath()
    }
    
    // paint grid table cells
    func paintCells(_ ctx: CGContext, table: TRDataTableSliceView, size: Slice, origin: CGPoint, ringAxis: TRAxis, angleAxis: TRAxis){
        for c in 0..<angleAxis.numberOfTicks!{
            let angle = angleAxis.position(c)
            // all row of each column
            for r in 0..<ringAxis.numberOfTicks!{
                // get cell object
                let cell = table.cellOfRowAndCol(r, col: c)
                let radius = ringAxis.position(r)
                let pt = CGPoint(x: origin.x + CGFloat(radius * cosf(DEGREETORADIANS(degree: angle))), y: origin.y - CGFloat(radius * sinf(DEGREETORADIANS(degree: angle))))
                // show cell at position pt
                if cell.image == nil {
                    let cellPath = getCellPath(cell, position: pt)
                    ctx.saveGState()
                    // fill with subtle shadow
                    if cell.withShadow == true{
                        ctx.setShadow(offset: CGSize.init(width: 0, height: 1), blur: 1.0, color: UIColor.gray.cgColor)
                    }
                    ctx.setFillColor(cell.metricColor!.cgColor)
                    ctx.addPath(cellPath!.cgPath)
                    ctx.fillPath()
                    
                    // outline
                    if cell.withOutline == true{
                        ctx.setStrokeColor(UIColor.gray.cgColor)
                        ctx.setLineWidth(0.5)
                        ctx.addPath(cellPath!.cgPath)
                        ctx.strokePath()
                    }
                    ctx.restoreGState()
                }
                // else wo have preload image
                let rect = CGRect(x: pt.x - 0.5 * cell.image!.size.width, y: pt.y - 0.5 * cell.image!.size.height, width: cell.image!.size.width, height: cell.image!.size.height)
                ctx.draw(cell.image!.cgImage!, in: rect)
            }
        }
    }
    
    // get cell path
    func getCellPath(_ cell: TRCell, position: CGPoint) -> UIBezierPath?{
        let radius = cell.displaySize
        if cell.cellShape == .circle || cell.cellShape == .dot{
            let frame = CGRect(x: position.x - CGFloat(radius!), y: position.y - CGFloat(radius!), width: 2 * CGFloat(radius!), height: 2 * CGFloat(radius!))
            let circle = UIBezierPath(roundedRect: frame, cornerRadius: frame.size.height * 1.0 / 2.0 )
            return circle
        }
        return nil
    }

}
