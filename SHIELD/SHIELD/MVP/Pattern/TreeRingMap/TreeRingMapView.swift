//
//  TreeRingMapView.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/11.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TreeRingMapView: UIView {
    // closure
    var bottomCenterIsTouched: (()->Void)?
    
    // define
    var rowMaxDisplayNumber: Int = 6
    
    // colors
    var mapBorderColor = UIColorFromHex(0xBBC0C9)
    var mapBackColor = UIColorFromHex(0xD9DDE3)
    var rowLineColor = UIColorFromHex(0x635887)
    var columnLineColor = UIColor.white
    var gapColors = [UIColorFromHex(0x28233B), UIColorFromHex(0x403D4B)]
    var bottomColor = UIColor.black
    
    // lines
    var mapBorderWidth = 5 * fontFactor
    var rowLineWidth = 2 * fontFactor
    var columnLineWidth = fontFactor

    // top and bottom sizes
    var mapTitleHeight = 38 * fontFactor
    var mapCenterHeight = 42 * fontFactor
    
    // axis
    var rowHeight = 55 * fontFactor
    var columnHeight = 55 * fontFactor // radiusHeight
    var indexGap = 4 * fontFactor
    
    // displayBubble
    var arrowLength = 10 * fontFactor
    var arrowLineWidth = fontFactor
    
    // calculated
    var mapCenter: CGPoint {
        return _mapCenter
    }
    
    // attached data table object
    fileprivate var dataTables = [TreeRingMapDataTable]()
    fileprivate var rightAngles = [CGFloat]()
    
    // fileprivate
    fileprivate var _mapCenter = CGPoint.zero
    fileprivate var mapRadius: CGFloat = 0
    fileprivate var rowRadii = [CGFloat]()
    fileprivate var columnAngles = [CGFloat]()

    fileprivate var focusRowIndex = -1 {
        didSet{
            setupRowsDisplay()
        }
    }
    fileprivate var focusColumnIndex = -1
    fileprivate var bubble: BubbleView!
    
    func resizeWithStandardPoint() {
        let mapFactor = min(bounds.width * 0.5, bounds.height) / 520
        mapBorderWidth = 5 * mapFactor
        rowLineWidth = 2 * mapFactor
        columnLineWidth = mapFactor
       
        // sizes
        mapTitleHeight = 38 * mapFactor
        mapCenterHeight = 42 * mapFactor

        // axis
        rowHeight = 55 * mapFactor
        columnHeight = 55 * mapFactor // radiusHeight
        
        indexGap = 4 * mapFactor
        
        // displayBubble
        arrowLength = 10 * mapFactor
        arrowLineWidth = mapFactor
        
        // reload
        reloadAxisAndCells()
    }
    
    // load
    func loadMapWithDataTable(_ dataTables: [TreeRingMapDataTable]) {
        backgroundColor = UIColor.clear
        self.dataTables = dataTables
        // data
        reloadAxisAndCells()
    }
    
    // load subviews and sublayers
    // axis
    fileprivate var columnViews = [TreeRingMapAxisView]()
    fileprivate var leftRowViews = [TreeRingMapAxisView]()
    fileprivate var rightRowViews = [TreeRingMapAxisView]()
    // cells
    fileprivate var cells = [Int: [Int: SphereView]]()
    
    // data
    fileprivate func reloadAxisAndCells() {
        focusRowIndex = -1
        focusColumnIndex = -1
        
        // clear all
        if bubble != nil {
            bubble.removeFromSuperview()
            bubble = nil
        }
        
        // axis
        for view in leftRowViews {
            view.removeFromSuperview()
        }
        for view in rightRowViews {
            view.removeFromSuperview()
        }
        for view in columnViews {
            view.removeFromSuperview()
        }
        columnViews.removeAll()
        leftRowViews.removeAll()
        rightRowViews.removeAll()
        
        // cells
        for (_, dic)in cells {
            for (_, view) in dic {
                view.removeFromSuperview()
            }
        }
        cells.removeAll()
        
        // area
        mapRadius = min(bounds.height - rowHeight - columnHeight, 0.5 * (bounds.width -  2 * columnHeight))
        let useH = mapRadius + rowHeight + columnHeight
        _mapCenter = CGPoint(x: bounds.width * 0.5 , y: bounds.midY + useH * 0.5 - rowHeight)
        
        columnHeight = min(min(_mapCenter.x - mapRadius, bounds.height - rowHeight - mapRadius), bounds.width - _mapCenter.x - mapRadius)
        
        // row data
        // total gap space for the rows
        rowRadii.removeAll()
        // fill rowRadii
        // total number of rows to be hosted
        let rowNumber = dataTables.first?.numberOfRows() ?? 0
        let rowLength = mapRadius - mapTitleHeight - mapCenterHeight
        // proposed gap between rows
        let rowGap = rowLength / max(CGFloat(rowNumber), 2)
        let rowWidth = rowNumber > rowMaxDisplayNumber ? rowLength / 4 : rowGap * 0.95
        
        // from center to outer
        for rowIndex in 0..<rowNumber {
            let rowRadius = mapCenterHeight + CGFloat(rowIndex + 1) * rowGap
            rowRadii.append(rowRadius)
            
            // add axis
            if let rowModel = dataTables.first?.rowModel(rowIndex) {
                // right
                let rowH = rowHeight - rowLineWidth * 3
                let rigthRowView = TreeRingMapAxisView.createWithAxis(rowModel)
                rigthRowView.frame = CGRect(x: rowRadius - 0.5 * rowWidth + _mapCenter.x, y: _mapCenter.y, width: rowWidth, height: rowH).insetBy(dx: 0, dy: indexGap)
                addSubview(rigthRowView)
                
                rightRowViews.append(rigthRowView)
                
                // left
                let leftRowView = TreeRingMapAxisView.createWithAxis(rowModel)
                leftRowView.frame = CGRect(x: _mapCenter.x - rowRadius - 0.5 * rowWidth, y: _mapCenter.y, width: rowWidth, height: rowH).insetBy(dx: 0, dy: indexGap)
                addSubview(leftRowView)
                
                leftRowViews.append(leftRowView)
            }
        }
        setupRowsDisplay()
        
        // column data. arrange from left to right
        columnAngles.removeAll()
        rightAngles.removeAll()
        
        var columnNumber = 0
        for dataTable in dataTables {
            columnNumber += dataTable.numberOfColumns()
        }
        let columnGap = CGFloatPi / CGFloat(columnNumber + dataTables.count)
        let columnLength = getColumnLength(columnGap)
        var cursor: Int = 0
        for (i, dataTable) in dataTables.enumerated() {
            for columnIndex in cursor..<cursor + dataTable.numberOfColumns() {
                let angle = CGFloatPi + CGFloat(i + columnIndex + 1) * columnGap
                columnAngles.append(angle)
                
                // column
                if let columnModel = dataTable.columnModel(columnIndex - cursor) {
                    let column = TreeRingMapAxisView.createWithAxis(columnModel)
                    column.frame = CGRect(center: Calculation.getPositionByAngle(angle, radius: mapRadius + columnHeight * 0.5, origin: _mapCenter), length: columnLength)
                    addSubview(column)
                    columnViews.append(column)
                }
            }
            
            // not draw for the last
            if i != dataTables.count - 1 {
                rightAngles.append(columnAngles.last! + columnGap)
            }
            cursor += dataTable.numberOfColumns()
        }
        
        // cells
        let maxLength = min(Calculation.inscribeSqureLength(columnGap, radius: rowRadii.last ?? mapRadius * 0.5), rowGap) * 0.8
        let layerLength = max(min(maxLength, rowHeight * 0.5), rowLineWidth * 5)
        for (rowIndex, radius) in rowRadii.enumerated() {
            for (columnIndex, angle) in columnAngles.enumerated() {
                if let cellData = getCellDataAtRow(rowIndex, columnIndex: columnIndex) {
                    let layerCenter = Calculation.getPositionByAngle(angle, radius: radius, origin: _mapCenter)
                    let cell = SphereView(frame: CGRect(center: layerCenter, length: layerLength))
                    cell.sphereColor = cellData.color ?? UIColor.cyan
                    addSubview(cell)
                    
                    if cells[rowIndex] == nil {
                        cells[rowIndex] = [columnIndex: cell]
                    }else {
                        cells[rowIndex]![columnIndex] = cell
                    }
                }
            }
        }
        
        setNeedsDisplay()
    }
    
    // node data
    fileprivate func getCellDataAtRow(_ rowIndex: Int, columnIndex: Int) -> ANDataTableCell? {
        var cursor = 0
        for dataTable in dataTables {
            if (cursor + dataTable.numberOfColumns()) > columnIndex {
                return dataTable.cellAt(columnIndex - cursor, rowIndex: rowIndex)
            }
            cursor += dataTable.numberOfColumns()
        }
        
        return nil
    }
    
    fileprivate func setupRowsDisplay() {
        if rightRowViews.count > rowMaxDisplayNumber {
            let maxIndex = rightRowViews.count - 1
            for (i, row) in rightRowViews.enumerated() {
                var rowIsHidden = (i != focusRowIndex)
                if focusRowIndex == -1 {
                    // normal
                    rowIsHidden = (i != 0 && i != maxIndex && i != maxIndex / 2)
                }
                
                row.isHidden = rowIsHidden
                leftRowViews[i].isHidden = rowIsHidden
            }
        }
    }
    
    fileprivate func getColumnLength(_ columnGap: CGFloat)-> CGFloat {
        let maxLength = columnHeight * 0.85
        var columnLength = maxLength
        if columnAngles.count != 1 {
            columnLength = min(Calculation.inscribeSqureLength(columnGap, radius: mapRadius + columnHeight), maxLength)
        }
        return columnLength
    }
   
    // relayout if necessary
    fileprivate func reLayoutAxis() {
        var cursor: Int = 0
        var lastAngle = CGFloatPi
        columnAngles.removeAll()
        
        for (i, dataTable) in dataTables.enumerated() {
            let columnGap = ((i == dataTables.count - 1 ? 2 * CGFloatPi : rightAngles[i]) - lastAngle) / CGFloat(dataTable.numberOfColumns() + 1)
            let columnLength = getColumnLength(columnGap)
            for columnIndex in cursor..<cursor + dataTable.numberOfColumns() {
                let angle = lastAngle + columnGap
                columnAngles.append(angle)

                let column = columnViews[columnIndex]
                let columnRadius = mapRadius + columnHeight * 0.5
                column.transform = CGAffineTransform.identity
                column.frame = CGRect(center: Calculation.getPositionByAngle(angle, radius: columnRadius, origin: _mapCenter), length: columnLength)
                if focusColumnIndex == columnIndex {
                    column.focused(true)
                }
                
                lastAngle += columnGap
            }
            lastAngle += columnGap
            cursor += dataTable.numberOfColumns()
        }
    }

    // row: column
    fileprivate func reLayoutCells() {
        if bubble != nil {
            bubble.isHidden = true
        }
        
        // add nodes
        for (rowIndex, radius) in rowRadii.enumerated() {
            for (columnIndex, angle) in columnAngles.enumerated() {
                if let cell = cells[rowIndex]![columnIndex] {
                    cell.center = Calculation.getPositionByAngle(angle, radius: radius, origin: _mapCenter)
                }
            }
        }
    }
    
    
    // draw map
    override func draw(_ rect: CGRect) {
        // draw back
        drawSemiCircle(_mapCenter, radius: mapRadius, fillColor: mapBackColor, lineColor: mapBorderColor, lineWidth: mapBorderWidth)
      
        // draw row lines
        // border
        drawRowLine(mapRadius - mapTitleHeight, fillColor: gapColors[0], focused: false)
        
        // radius
        for (i, rowRadius) in rowRadii.reversed().enumerated() {
            drawRowLine(rowRadius, fillColor: gapColors[(i + 1) % 2], focused: ((rowRadii.count - i - 1) == focusRowIndex))
        }

        // draw column lines
        for (i, angle) in columnAngles.enumerated() {
            drawColumnLine(angle, focused: i == focusColumnIndex)
        }
        
        // extra
        // draw title
        for (i, dataTable) in dataTables.enumerated() {
            let titleString = NSMutableAttributedString(string: dataTable.title, attributes: [.font: UIFont.systemFont(ofSize: mapTitleHeight * 0.45, weight: .bold)])
            let left = 360 - (i == 0 ? 180 : rightAngles[i - 1] * 180 / CGFloatPi)
            let right = 360 - (i == rightAngles.count ? 360 : rightAngles[i] * 180 / CGFloatPi)
            ANCircleText().paintCircleText(UIGraphicsGetCurrentContext()!, text: titleString, style: .alignMiddle, radius: mapRadius - mapTitleHeight, width: mapTitleHeight, left: left, right: right, center: _mapCenter)
        }
        
        for angle in rightAngles {
            let handRadius = columnHeight * 0.22
            let topPoint = Calculation.getPositionByAngle(angle, radius: (mapRadius + columnHeight - handRadius), origin: mapCenter)
            drawLine(mapCenter, point2: topPoint, lineColor: UIColor.red, lineWidth: rowLineWidth * 2, isDash: false)
            let hander = UIBezierPath(ovalIn: CGRect(center: topPoint, length: handRadius * 2))
            UIColor.red.setFill()
            hander.fill()
        }

        // bottom line
        let arrowH = rowLineWidth * 5
        let lineY = _mapCenter.y + rowHeight - arrowH
        let bottomRadius = mapRadius + columnHeight * 0.5
        drawLine(CGPoint(x: _mapCenter.x - bottomRadius, y: lineY), point2: CGPoint(x: _mapCenter.x + bottomRadius, y:lineY), lineColor: bottomColor, lineWidth: rowLineWidth, isDash: false)
        
        let arrow = UIBezierPath()
        
        arrow.move(to: CGPoint(x: _mapCenter.x - bottomRadius - arrowH, y: lineY))
        arrow.addLine(to: CGPoint(x: _mapCenter.x - bottomRadius, y: lineY - arrowH * 0.5))
        arrow.addLine(to: CGPoint(x: _mapCenter.x - bottomRadius, y: lineY + arrowH * 0.5))
        arrow.close()
        
        arrow.move(to: CGPoint(x: _mapCenter.x + bottomRadius + arrowH, y: lineY))
        arrow.addLine(to: CGPoint(x: _mapCenter.x + bottomRadius, y: lineY - arrowH * 0.5))
        arrow.addLine(to: CGPoint(x: _mapCenter.x + bottomRadius, y: lineY + arrowH * 0.5))
        arrow.close()
        
        bottomColor.setFill()
        arrow.fill()
        
        // draw center
        let image = UIImage(named: "treeRingMap_center")!
        image.draw(in: CGRect(x: _mapCenter.x - mapCenterHeight, y: _mapCenter.y - mapCenterHeight + rowLineWidth * 0.5, width: mapCenterHeight * 2, height: mapCenterHeight))
    }
    
    // draw
    fileprivate func drawRowLine(_ radius: CGFloat, fillColor: UIColor, focused: Bool) {
        drawSemiCircle(_mapCenter, radius: radius, fillColor: fillColor, lineColor: focused ? UIColor.white : rowLineColor, lineWidth: (focused ? 2 : 1) * rowLineWidth)
    }
    
    fileprivate func drawColumnLine(_ angle: CGFloat, focused: Bool) {
        drawLine(_mapCenter, radius: mapRadius - mapTitleHeight, angle: angle, lineColor: columnLineColor, lineWidth: (focused ? 2 : 1) * columnLineWidth, isDash: !focused)
    }
    
    // touch
    fileprivate var needRelayout: Int!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        needRelayout = nil
        
        // cell check
        for (row, dic) in cells {
            for (column, cell) in dic {
                if cell.frame.contains(point) {
                     cellIsTappedAt(row, column: column)
                    break
                }
            }
        }
        
        // axis
        for (rowIndex, row) in leftRowViews.enumerated() {
            if row.frame.contains(point) {
                rowIsTappedAt(rowIndex)
                break
            }
        }
        
        for (rowIndex, row) in rightRowViews.enumerated() {
            if row.frame.contains(point)  {
                rowIsTappedAt(rowIndex)
                break
            }
        }
        
        for (columnIndex, column) in columnViews.enumerated() {
           if column.frame.contains(point) {
                columnIsTappedAt(columnIndex)
                break
            }
        }
        
        if Calculation.distanceOfPointA(point, pointB: _mapCenter) < mapCenterHeight && point.y < _mapCenter.y {
            bottomCenterIsTouched?()
        }
        
        for (i, angle) in rightAngles.enumerated() {
            let handRadius = columnHeight * 0.22
            let topPoint = Calculation.getPositionByAngle(angle, radius: (mapRadius + columnHeight - handRadius), origin: mapCenter)
            if Calculation.distanceOfPointA(point, pointB: topPoint) < handRadius {
                needRelayout = i
                break
            }
        }
    }
    
    
    // move
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if needRelayout != nil {
            let currentPoint = touches.first!.location(in: self)
            let lastPoint = touches.first!.previousLocation(in: self)
            let angle = Calculation.angleOfPoint(currentPoint, center: mapCenter) - Calculation.angleOfPoint(lastPoint, center: mapCenter)
            
            let leftMax = (needRelayout == 0 ? CGFloatPi : rightAngles[needRelayout - 1]) + 0.02
            let rightMax = (needRelayout == rightAngles.count - 1 ?  CGFloatPi * 2 : rightAngles[needRelayout + 1]) - 0.02
            if rightAngles[needRelayout] + angle >= rightMax || rightAngles[needRelayout]  + angle <= leftMax {
                return
            }
            
            // change
            rightAngles[needRelayout] += angle
        
            reLayoutAxis()
            reLayoutCells()
            setNeedsDisplay()
        }
    }
}

// action method
extension TreeRingMapView {
    fileprivate func cellIsTappedAt(_ row: Int, column: Int) {
        if row != focusRowIndex || focusColumnIndex != column {
            // update
            if let oldCell = cells[focusRowIndex]?[focusColumnIndex] {
                oldCell.transform = CGAffineTransform.identity
                leftRowViews[focusRowIndex].focused(false)
                rightRowViews[focusRowIndex].focused(false)
                columnViews[focusColumnIndex].focused(false)
                
                if bubble != nil {
                    bubble.isHidden = true
                }
            }
            
            focusColumnIndex = column
            focusRowIndex = row
            
            // current focus cell and axis
            let cell = cells[row]![column]!
            cell.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            leftRowViews[focusRowIndex].focused(true)
            rightRowViews[focusRowIndex].focused(true)
            columnViews[focusColumnIndex].focused(true)
            
            if let cellData = getCellDataAtRow(row, columnIndex: column) {
                columnViews[focusColumnIndex].setImage(cellData.imageUrl)
            }
            
            bringSubviewToFront(columnViews[focusColumnIndex])
            
            // touch detail
            if let cellData = getCellDataAtRow(row, columnIndex: column) {
                if let cellDetail = cellData.tip {
                    if bubble == nil {
                        bubble = BubbleView()
                        bubble.displayLabel.textAlignment = .center
                        addSubview(bubble)
                    }
                    
                    bubble.isHidden = false
                    bringSubviewToFront(bubble)
                    
                    // text
                    let fontSize = 1.6 * arrowLength
                    let displayS = NSMutableAttributedString(string: cellDetail, attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .medium)])
                    if let detail = cellData.title {
                        displayS.append(NSAttributedString(string: ": \(detail)", attributes: [.font: UIFont.systemFont(ofSize: fontSize)]))
                    }
                    
                    bubble.displayText(displayS)
                    
                    // size
                    let textSize = displayS.boundingRect(with: CGSize(width: mapRadius * 1.2, height: bounds.height - arrowLength), options: .usesLineFragmentOrigin, context: nil)
                    
                    let bubbleWidth = textSize.width + arrowLength * 1.2
                    let bubbleHeight = textSize.height + arrowLength * 2
                    let arrowTop = bubbleHeight < (bounds.height - cell.frame.maxY)
                    let bubbleX = min(max(0, cell.center.x - bubbleWidth * 0.5), bounds.width - bubbleWidth)
                    let bubbleY = arrowTop ? cell.frame.maxY : cell.frame.minY - bubbleHeight
                    let bubbleFrame = CGRect(x: bubbleX, y: bubbleY, width: bubbleWidth, height: bubbleHeight)
                    bubble.layoutWithFrame(bubbleFrame, focusX: cell.center.x - bubbleFrame.minX, arrowH: arrowLength, lineWidth: arrowLineWidth, arrowTop: arrowTop)
                }
            }
  
            setNeedsDisplay()
        }
    }
    
    fileprivate func rowIsTappedAt(_ row: Int) {
        noneChosenState()
        focusRowIndex = row
        
        leftRowViews[focusRowIndex].focused(true)
        rightRowViews[focusRowIndex].focused(true)
        
        setNeedsDisplay()
    }
   
    fileprivate func columnIsTappedAt(_ column: Int) {
        noneChosenState()
        focusColumnIndex = column
        columnViews[focusColumnIndex].focused(true)
        
        setNeedsDisplay()
    }
    
    fileprivate func noneChosenState() {
        if let oldCell = cells[focusRowIndex]?[focusColumnIndex] {
            oldCell.transform = CGAffineTransform.identity
            if bubble != nil {
                bubble.isHidden = true
            }
        }
        
        if focusRowIndex != -1 {
            leftRowViews[focusRowIndex].focused(false)
            rightRowViews[focusRowIndex].focused(false)
            focusRowIndex = -1
        }

        if focusColumnIndex != -1 {
            columnViews[focusColumnIndex].focused(false)
            focusColumnIndex = -1
        }
    }
}


// draw method
extension TreeRingMapView {
    // draw semi circle
    fileprivate func drawSemiCircle(_ arcCenter: CGPoint, radius: CGFloat, fillColor: UIColor, lineColor: UIColor, lineWidth: CGFloat) {
        let linePath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: CGFloatPi, clockwise: false)
        // fill
        let fillPath = linePath.copy() as! UIBezierPath
        fillPath.close()
        fillColor.setFill()
        fillPath.fill()
        
        // stroke
        linePath.lineWidth = lineWidth
        lineColor.setStroke()
        linePath.stroke()
    }
    
    fileprivate func drawLine(_ point1: CGPoint, point2: CGPoint, lineColor: UIColor, lineWidth: CGFloat, isDash: Bool) {
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.lineWidth = lineWidth
        
        if isDash {
            path.setLineDash([5 * lineWidth, 4 * lineWidth], count: 1, phase: 1)
        }
        
        lineColor.setStroke()
        path.stroke()
    }
    
    fileprivate func drawLine(_ center: CGPoint, radius: CGFloat, angle: CGFloat, lineColor: UIColor, lineWidth: CGFloat, isDash: Bool) {
        let point = Calculation.getPositionByAngle(angle, radius: radius, origin: center)
        drawLine(center, point2: point, lineColor: lineColor, lineWidth: lineWidth, isDash: isDash)
    }
}
