//
//  TRSlice.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRSlice: NSObject {
    // reference to host view layer
    var parent: CALayer?
    // unit font size
    var pointsPerFontSize: Float?
    // 
    var background: TRSliceBackground?
    // 
    var grid: TRSliceGrid?
    //
    var ringAxis: TRRowAxis?
    var angleAxis: TRColumnAxis?
    var table: TRDataTableSliceView?
    
    var rowBarStyle: BarPosition?
    var rowLabelOnLeft: Bool?
    var rowLabelOnRight: Bool?
    
    var leftBorderStyle: SliceBorder?
    var leftBorderSize: Int?
    var showRightBorderShadow: Bool?
    var showLeftBorderShadow: Bool?
    var rightBorderStyle: SliceBorder?
    var rightBorderSize: Int?
    var leftAngleMargin: Float?
    var rightAngleMargin: Float?
    var topEdgeMargin: Float?
    var bottomEdgeMargin: Float?
    
    var borderColor: UIColor?
    var borderInnerColor: UIColor?
    var borderShadowColor: UIColor?
    var cellTip: TRCellTip?
    
    var size = Slice()
    var origin: CGPoint?
    var hostFrame: CGRect?


    override init() {
        super.init()
        parent = nil
        pointsPerFontSize = 1.0
        
        // create background object
        background = TRSliceBackground.init()
        
        // create grid object
        grid = TRSliceGrid.init()
        grid?.evenRowBackgroundColor = UIColor(red: 0.5, green: 0.9, blue: 0.9, alpha: 0.4)
        grid?.oddRowBackgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.4)
        grid?.highlightedCellBorderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.4)
        grid?.columnGridLine?.size = 1.0
        grid?.columnGridLine?.style = .solid
        grid?.columnGridLine?.color = UIColor.white
        grid?.rowGridLine?.size = 0.6
        grid?.rowGridLine?.style = .dash
        grid?.rowGridLine?.color = UIColor.lightGray
        
        // create axis objects
        ringAxis = TRRowAxis.init()
        angleAxis = TRColumnAxis.init()
        
        // create data table object
        table = TRDataTableSliceView.init()
        
        rowBarStyle = .leftOrTop
        rowLabelOnLeft = true
        rowLabelOnRight = true
        
        leftBorderStyle = .solid
        rightBorderStyle = .solid
        leftAngleMargin = 5
        rightAngleMargin = 5
        topEdgeMargin = 12
        bottomEdgeMargin = 12
        leftBorderSize = 8
        rightBorderSize = 8
        showLeftBorderShadow = true
        showRightBorderShadow = true
        
        borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
        borderInnerColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        borderShadowColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 0.3)
        
        cellTip = TRCellTip.init()
         
    }
    
    func setStyle(_ style: SliceViewStyle){
        if style == .style_1{
            setStyle_1()
        }else if style == .style_2{
        
        }
    }
    
    func setStyle_1(){
        background?.style = .colorFill
        background?.bkgColor = UIColor.black//UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        background?.edgeColor = UIColor.lightGray
        background?.highlightColor = UIColor(red: 0, green: 1.0, blue: 1.0, alpha: 0.4)
        background?.highlightStyle = .gradient
        
        // grid line background
        grid?.evenRowBackgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        grid?.oddRowBackgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.2)
        
        grid?.columnGridLine?.size = 1.0;
        grid?.columnGridLine?.style = .solid
        grid?.columnGridLine?.color = UIColor.white
        grid?.rowGridLine?.size = 0.6
        grid?.rowGridLine?.style = .dash
        grid?.rowGridLine?.color = UIColor.lightGray
        
        // border (seperator)
        borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5)
        borderInnerColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
        borderShadowColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 0.3)
        
        // margin on left and right sides
        leftAngleMargin = 5
        rightAngleMargin = 5
        
        leftAngleMargin = 5
        leftBorderSize = 8
        showLeftBorderShadow = true
        
        rightAngleMargin = 5
        rightBorderSize = 8
        showRightBorderShadow = true
        
        // ring axis
        ringAxis?.tickLabelDirection = .zero
        ringAxis?.spaceBetweenAxisAndLabel = 12
        ringAxis?.labelMargin = 60
        ringAxis?.maxNumberOfFullSizeLetters = 28;
        
        // fonts
        ringAxis?.setTickLabelFonts(true, large: 12.0, small: 8.0)
        ringAxis?.tickColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        ringAxis?.tickSize = 1.0
        ringAxis?.height = 3.0
        
        // angle axis
        // ring on the outside edge 
        angleAxis?.ring?.size = 18
        angleAxis?.ring?.backgroundShadow = false
        angleAxis?.ring?.bkgColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        angleAxis?.ring?.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        angleAxis?.ring?.lineWidth = 1.0
        angleAxis?.showTickLabels = true
        angleAxis?.labelMargin = 80
        angleAxis?.tickLabelDirection = TickLabelOrientation.zero
    
        // arrows
        angleAxis?.beginArrow?.shadow = false
        angleAxis?.beginArrow?.faceColor = UIColor(red: 0, green: 0.3, blue: 0.9, alpha: 0.8)
        angleAxis?.endArrow?.shadow = false
        angleAxis?.endArrow?.faceColor = UIColor(red: 0, green: 0.3, blue: 0.9, alpha: 0.8)
        
        // fonts
        angleAxis?.maxNumberOfFullSizeLetters = 28
        angleAxis?.setTickLabelFonts(true, large: 12.0, small: 8.0)
        
        // title
        angleAxis?.title?.size = Float(angleAxis!.ring!.size!)
        angleAxis?.title?.style = RingTextStyle.alignMiddle
        angleAxis?.title?.setStringAttributes("Helvetica-Bold", size: 10, foregroundColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8), strokeColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 4.0), strokeWidth: -3.0)

    }
    
    func showMetricDataTable(_ dataTable: TRMetricDataTable){
        detachFromTable()
        table?.loadMetricDataTable(dataTable)
        angleAxis?.title?.title = dataTable.title
        attachToTable()
     
    }
    
    func detachFromTable(){
        if table == nil {return}
        for row in 0..<table!.numberOfRows(){
            for col in 0..<table!.numberOfColumns(){
                let oneCell = table!.cellOfRowAndCol(row, col: col)
                if oneCell.layer == nil {continue}
                oneCell.layer!.removeFromSuperlayer()
                oneCell.layer = nil
            }
        }
    }
    
    func attachToTable(){
        if table == nil {return}
        for row in 0..<table!.numberOfRows(){
            for col in 0..<table!.numberOfColumns(){
                let oneCell = table!.cellOfRowAndCol(row, col: col)
                //if oneCell.image == nil {continue}
                oneCell.layer = CALayer()
                oneCell.layer?.drawsAsynchronously = true
                oneCell.layer?.contents = oneCell.image?.cgImage
                oneCell.layer?.frame = CGRect(x: 0, y: 0, width: oneCell.displaySize!, height: oneCell.displaySize!)
                oneCell.layer?.backgroundColor = UIColor.clear.cgColor
                oneCell.layer?.zPosition = 10
                if parent != nil{
                    parent?.addSublayer(oneCell.layer!)
                }
            
                // do not do this!!!.  it will invaldates the contents
                //[oneCell.layer setNeedsDisplay];
            }
        }
    }
    
    // MARK: paint slice
    func paint(_ ctx: CGContext){
        // 1. paint background first
        background?.paint(ctx, size: size, center: origin!)
        
        // 2. paint column axis
        let bCircleBarOnRight = rightBorderStyle == SliceBorder.line
        
        // 3. outer ring
        angleAxis?.paint(ctx, start: size.right!, end: size.left!, radius: size.top!, size: Float(angleAxis!.ring!.size!) * pointsPerFontSize!, origin: origin!, height:Int(hostFrame!.size.height), circleBarOnRight: bCircleBarOnRight)
        
        // 4. paint row axis
        if rowLabelOnLeft == true{
            ringAxis?.paint(ctx, start: size.bottom!, end: size.top!, angle: size.left!, offset: Float(leftBorderSize!) * pointsPerFontSize! * 0.5, origin: origin!, height: Int(hostFrame!.size.height))
        
        }
        if rowLabelOnRight == true{
            
            ringAxis?.paint(ctx, start: size.bottom!, end: size.top!, angle: size.right!, offset: Float(rightBorderSize!) * pointsPerFontSize! * 0.5, origin: origin!, height: Int(hostFrame!.size.height))
        }
        // 5. paint slice grid
        grid?.paint(ctx, table: table!, size: size, origin: origin!, ringAxis: ringAxis!, angleAxis: angleAxis!)
        
        // 6. paint slice border
        paintSliceBorders(ctx)
        
        // paint left and right slice borders(left and right edges)
        
        
        // paint row axis slider bars
        
        
        // 7. paint the tip which will displayed after clicked
        paintTip(ctx)
       
    }
    
    // paint clicked tip
    func paintTip(_ ctx: CGContext){
        
        // judge if nil
        if cellTip == nil  {
            return
        }else if cellTip!.show! == false || cellTip!.rowIndex! < 0 || cellTip!.columnIndex! < 0{
            return
        }
        
        print("-----note: begin paint tip-----")
        
        // 1. get TRCell object
        let cell = table?.cellOfRowAndCol(cellTip!.rowIndex!, col: cellTip!.columnIndex!)
        
        // 2. ger cell location 
        let position = getCellPosition(cellTip!.rowIndex!, column: cellTip!.columnIndex!)
        
        // 3. show tip
        cellTip!.paint(ctx, cell: cell!, position: position)
        
    }
    
    
    // paint slice borders
    func paintSliceBorders(_ ctx: CGContext){

        // left
        if leftBorderStyle == SliceBorder.none && rightBorderStyle == SliceBorder.none{
            return
        }
        var angle = size.left
        var cellSize: Float
        var beginRadius: Float
        var endRadius: Float
        if table!.numberOfColumns() >= 1 && table!.numberOfRows() >= 1{
            cellSize = Float(table!.cellOfRowAndCol(0, col: table!.numberOfColumns() - 1).displaySize!)
        }else{
            cellSize = 0
        }
        cellSize *= pointsPerFontSize!
        beginRadius = size.bottom! + cellSize
        if angleAxis?.ring != nil && leftBorderStyle != .line{
            endRadius = Float(size.top!) + Float(angleAxis!.ring!.size!) * pointsPerFontSize!
        }else{
            endRadius = size.top!
        }
        
        if leftBorderStyle == .line{
            paintSliceBorderLine(ctx, angle: angle!, beginRadius: beginRadius, endRadius: endRadius, width: 6, borderColor: borderColor!.cgColor)
            
        
        }else if leftBorderStyle == .solid{
            paintSliceBorderSimple(ctx, angle: angle!, beginRadius: beginRadius, endRadius: endRadius, width: Float(leftBorderSize!) * pointsPerFontSize!, borderColor: borderColor!.cgColor, shadowColor: borderShadowColor!.cgColor, bShadow: showLeftBorderShadow!)
        }else if leftBorderStyle == .metal{
            paintSliceBorderMetal(ctx, angle: angle!, beginRadius: beginRadius, endRadius: endRadius, width: Float(leftBorderSize!) * pointsPerFontSize!, borderColor: borderColor!.cgColor)
        }
        
        // right
        
        angle = size.right
        if table!.numberOfColumns() >= 1 && table!.numberOfRows() >= 1{
            cellSize = Float(table!.cellOfRowAndCol(0, col: 0).displaySize!)
        }else{
            cellSize = 0
        }
        cellSize *= pointsPerFontSize!
        beginRadius = size.bottom! + cellSize
        if angleAxis?.ring != nil && rightBorderStyle != .line{
            endRadius = Float(size.top!) + Float(angleAxis!.ring!.size!) * pointsPerFontSize!
        }else{
            endRadius = size.top!
        }
        
        if rightBorderStyle == .line{
            paintSliceBorderLine(ctx, angle: angle!, beginRadius: beginRadius, endRadius: endRadius, width: 4, borderColor: borderColor!.cgColor)
            
            
        }else if rightBorderStyle == .solid{
            paintSliceBorderSimple(ctx, angle: angle!, beginRadius: beginRadius, endRadius: endRadius, width: Float(rightBorderSize!) * pointsPerFontSize!, borderColor: borderColor!.cgColor, shadowColor: borderShadowColor!.cgColor, bShadow: showRightBorderShadow!)
        }else if rightBorderStyle == .metal{
            paintSliceBorderMetal(ctx, angle: angle!, beginRadius: beginRadius, endRadius: endRadius, width: Float(rightBorderSize!) * pointsPerFontSize!, borderColor: borderColor!.cgColor)
        }
        
    }
    
    
    // two style of border
    func paintSliceBorderLine(_ ctx: CGContext, angle: Float, beginRadius: Float, endRadius: Float, width: Float, borderColor: CGColor){
        let bPt = CGPoint(x: origin!.x + CGFloat(beginRadius * cosf(DEGREETORADIANS(degree: angle))), y: origin!.y - CGFloat(beginRadius * sinf(DEGREETORADIANS(degree: angle))))
        let ePt = CGPoint(x: origin!.x + CGFloat(endRadius * cosf(DEGREETORADIANS(degree: angle))), y: origin!.y - CGFloat(endRadius * sinf(DEGREETORADIANS(degree: angle))))
        ctx.saveGState()
        ctx.beginPath()
        ctx.move(to: bPt)
        ctx.addLine(to: ePt)
        ctx.setLineWidth(CGFloat(width))
        if angleAxis?.ring?.innerDecorationStyle == InnerDecoration.blackGray{
            ctx.setStrokeColor(UIColor.black.cgColor)
        }else if angleAxis?.ring?.innerDecorationStyle == InnerDecoration.whiteBlack{
            ctx.setStrokeColor(UIColor.white.cgColor)
        }else{
            ctx.setStrokeColor(borderColor)
        }
        ctx.strokePath()
        ctx.restoreGState()
    }
    
    func paintSliceBorderMetal(_ ctx: CGContext, angle: Float, beginRadius: Float, endRadius: Float, width: Float, borderColor: CGColor){
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradientColor38 = UIColor(red: 0.718, green: 0.706, blue: 0.698, alpha: 1)
        let gradientColor39 = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let gradientColor40 = UIColor(red: 0.702, green: 0.69, blue: 0.686, alpha: 1)
        let gradientColor41 = UIColor(red: 0.737, green: 0.722, blue: 0.722, alpha: 1)
        
        let sVGID_4_Locations :[CGFloat] = [0.1, 0.45, 0.72, 1]
        let sVGID_4 = CGGradient.init(colorsSpace: colorSpace, colors: [gradientColor38.cgColor, gradientColor39.cgColor, gradientColor40.cgColor, gradientColor41.cgColor] as CFArray, locations: sVGID_4_Locations)
        let bPt = CGPoint(x: origin!.x + CGFloat(beginRadius * cosf(DEGREETORADIANS(degree: angle))), y: origin!.y - CGFloat(beginRadius * sinf(DEGREETORADIANS(degree: angle))))
        let ePt = CGPoint(x: origin!.x + CGFloat(endRadius * cosf(DEGREETORADIANS(degree: angle))), y: origin!.y - CGFloat(endRadius * sinf(DEGREETORADIANS(degree: angle))))
        let dx = CGFloat(0.5 * width * sinf(DEGREETORADIANS(degree: angle)))
        let dy = CGFloat(0.5 * width * cosf(DEGREETORADIANS(degree: angle)))
        let rectanglePath = UIBezierPath()
        rectanglePath.move(to: CGPoint.init(x: bPt.x - dx, y: bPt.y - dy))
        rectanglePath.addLine(to: CGPoint.init(x: bPt.x + dx, y: bPt.y + dy))
        rectanglePath.addLine(to: CGPoint.init(x: ePt.x + dx, y: ePt.y + dy))
        rectanglePath.addLine(to: CGPoint.init(x: ePt.x - dx, y: ePt.y - dy))
        rectanglePath.close()
        ctx.saveGState()
        rectanglePath.addClip()
        ctx.drawLinearGradient(sVGID_4!, start: bPt, end: ePt, options: .drawsBeforeStartLocation)
        ctx.restoreGState()
    }
    
    func paintSliceBorderSimple(_ ctx: CGContext,angle: Float, beginRadius: Float, endRadius: Float, width: Float,borderColor: CGColor,shadowColor: CGColor,bShadow:Bool){
        let bPt = CGPoint(x: origin!.x + CGFloat(beginRadius * cosf(DEGREETORADIANS(degree: angle))), y: origin!.y - CGFloat(beginRadius * sinf(DEGREETORADIANS(degree: angle))))
        let ePt = CGPoint(x: origin!.x + CGFloat(endRadius * cosf(DEGREETORADIANS(degree: angle))), y: origin!.y - CGFloat(endRadius * sinf(DEGREETORADIANS(degree: angle))))
        
        ctx.saveGState()
        ctx.beginPath()
        ctx.move(to: bPt)
        ctx.addLine(to: ePt)
        
        ctx.setLineWidth(CGFloat(width))
        ctx.setStrokeColor(borderColor)
        ctx.strokePath()
        ctx.move(to: bPt)
        ctx.addLine(to: ePt)
        
        if bShadow == true{
            ctx.setShadow(offset: CGSize.init(width: 0, height: 3.0), blur: 3.0, color: shadowColor)
        }
        ctx.setLineWidth(CGFloat(width) - 2.0)
        ctx.setStrokeColor(borderColor)
        ctx.strokePath()
        ctx.restoreGState()
    }
    
    func onDirtyView(){
        // set ring axis size.
        ringAxis?.setAxisTicks(size.bottom!, axMax: size.top!, tickLabels: table!.rowTexts!, firstTick: size.bottom! + bottomEdgeMargin!, lastTick: size.top! - topEdgeMargin!)
        // set angle axis size
        angleAxis?.setAxisTicks(size.right!, axMax: size.left!, tickLabels: table!.colTickLabels(), firstTick: size.right! + rightAngleMargin!, lastTick: size.left! - leftAngleMargin!)
    }
    
    func onSize(){
        if table == nil || ringAxis == nil || angleAxis == nil {return}
        
        // all columns
        for c in 0..<angleAxis!.numberOfTicks!{
            for r in 0..<ringAxis!.numberOfTicks!{
                let cell = table?.cellOfRowAndCol(r, col: c)
                let pt = getCellPosition(r, column: c)
                if fabs(cell!.layer!.position.x - pt.x) > 1.0 || fabs(cell!.layer!.position.y - pt.y) > 1.0{
                    let animation = CABasicAnimation()
                    animation.keyPath = "position"
                    animation.fromValue = NSValue.init(cgPoint: pt)
                    animation.toValue = NSValue.init(cgPoint: pt)
                    cell?.layer?.setValue(animation.toValue, forKey: animation.keyPath!)
                    cell?.layer?.add(animation, forKey: animation.keyPath)
                }
            }
        }
    }
    
    func getCellPosition(_ row: Int, column: Int) -> CGPoint{
        let radius = ringAxis?.position(row)
        let angle = angleAxis?.position(column)
        let cellPt = CGPoint(x: origin!.x + CGFloat(radius! * cosf(DEGREETORADIANS(degree: angle!))), y: origin!.y - CGFloat(radius! * sinf(DEGREETORADIANS(degree: angle!))))
        return cellPt
    }
    
    func hitTest(_ atPoint: CGPoint) -> HitObj{
        var hit = HitObj()
        hit.hitObject = TRObjs.none
        
        // 1. try angle axis, did we hit anything?return
        hit = angleAxis!.hitTest(atPoint, radius: size.top!, size: Float(angleAxis!.ring!.size!) * pointsPerFontSize!, origin: origin!)
        
        if hit.hitObject != TRObjs.none{
            print("return angle axis")
            return hit
        }
        
        // 2. try ring axis
        if rowBarStyle == BarPosition.leftOrTop{
            hit = ringAxis!.hitTest(atPoint, angle: size.left!, size: Float(angleAxis!.ring!.size!) * Float(pointsPerFontSize!), origin: origin!)
        }else if rowBarStyle == BarPosition.rightOrBottom{
            hit = ringAxis!.hitTest(atPoint, angle: size.right!, size: Float(angleAxis!.ring!.size!) * Float(pointsPerFontSize!), origin: origin!)
        }
        
        if hit.hitObject != TRObjs.none{
            print("return ring axis")
            return hit
        }
        
        // 3. try slice grid table cells
        hit = cellTableHitTest(atPoint)
        if hit.hitObject != TRObjs.none{
            print("set real index ")
            cellTip?.rowIndex = hit.row
            cellTip?.columnIndex = hit.col
            grid?.rowFocus = hit.row
            grid?.columnFocus = hit.col
            return hit
        }
        
        // add other hit test if any
        return hit
    }
    
    // table cell hit test 
    func cellTableHitTest(_ atPoint: CGPoint) -> HitObj{
        var hit = HitObj()
        print("cell table hit\(atPoint)")
        hit.hitObject = TRObjs.none
        
        // center position 
        let center = origin
        
        // {angle, radius} point position 
        //let r = hypotf(Float(atPoint.x - center!.x), Float(atPoint.y - center!.y))
        
      
        
        var endAngle: Float = 180.0 * atan(-Float(atPoint.y - center!.y) / Float(atPoint.x - center!.x)) / Float(3.14)
        if (atPoint.x - center!.x) < 0 {
            endAngle += 180
        }
        print(size)

        // is endAngle with slice size range?
        if endAngle < size.right! || endAngle > size.left!{
            print("1")
            return hit
        }
        
        // is within this slice. find if we hit any grid cell
        var colMin = -1
        var minAngleDelta: Float = 360.0
        for col in 0..<angleAxis!.numberOfTicks!{
            let angle = angleAxis?.position(col)
            if abs(angle! - endAngle) < minAngleDelta{
                minAngleDelta = abs(angle! - endAngle)
                colMin = col
            }
        }
        
        // found valid column?
        if colMin < 0{
            print("2")
            return hit
        }
        
        // which row?
        var rowMin = -1
        var minDistance = abs(size.top! - size.bottom!)
        for row in 0..<ringAxis!.numberOfTicks!{
            let cellPt = getCellPosition(row, column: colMin)
            let dis = hypotf(Float(cellPt.x - atPoint.x), Float(cellPt.y - atPoint.y))
            if dis < minDistance{
                minDistance = dis
                rowMin = row
            }
        }
        
        // did we find anything?
        if rowMin < 0{
            print("3")
            return hit
        }
        
        // get cell object
        let cell = table!.cellOfRowAndCol(rowMin, col: colMin)
        if cell.displayStyle == CellValueShow.none{
            print("4")
            return hit
        }
        
        if minDistance > Float(cell.displaySize!){
            print("5")
            return hit
        }
        
        hit.hitObject = TRObjs.cell
        hit.row = rowMin
        hit.col = colMin
        return hit
    }
    
    // reset axis slider bar position
    func setColumnAxisSliderBarPosition(_ barPosition: Float){
        angleAxis?.eyePosition = barPosition
        angleAxis?.reSize()
    }
    
    func setRowAxisSliderBarPosition(_ barPosition: Float){
        ringAxis?.eyePosition = barPosition
        ringAxis?.reSize()
    }
    
}
