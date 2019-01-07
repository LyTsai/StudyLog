//
//  ANTreeGraphLineView.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/9/2.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ANTreeGraphLineView: UIView, ANTreeMapLineDataProtocal {
    var treeGraph : ANTreeGraphLayout! // get from viewController after init
    var linesView = ANLinesView()

    
    func setUpDelegate() {
        linesView.nodeData = treeGraph.dataSoure
        linesView.lineData = self
        linesView.frame = self.bounds
        self.addSubview(linesView)
        
        linesView.setNeedsDisplay()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        linesView.frame = self.bounds
    }
    
    override func drawRect(rect: CGRect) {
        self.addSubview(linesView)
    }
    
    
    // MARK: lines
    func getLineOverallInformation(row row: Int, column: Int) -> [(startPoint: CGPoint, connectionType: LineConnectionType)]{
        let frame = treeGraph.getCellRectAtIndexPath(IndexPath(row: row, column: column))
        let startPoint = CGPoint(x: frame.midX, y: frame.minY)
        var connectionType =  LineConnectionType.TwoPoints
        
        if row == 0 {
            return [(startPoint, LineConnectionType.TwoPoints),(startPoint, LineConnectionType.BreakHanged)]
        }
        
        if row == 2 {
            return [(startPoint, connectionType), (CGPoint(x:frame.midX, y: frame.maxY), connectionType)]
        }
        
        if  row == 1 || row == 3 || (row == 5 && column != 0) || row == 6{
            connectionType = .None
        }else if row == 4 || (row == 5 && column == 0) {
            connectionType = .BreakHanged
        }
        
        return [(startPoint: startPoint, connectionType: connectionType)]
    }
    
    
    // About the lines
    func getLineDrawStyle(row row: Int, column: Int, lineIndex: Int) -> LineDrawStyle{
        let lineWidth: CGFloat = lineIndex == 1 ? 5 : 3
        var lineColor = UIColor.yellowColor()
        
        if lineIndex == 1 {
            if row == 2 {
                lineColor = UIColor.cyanColor()
            }
            lineColor = UIColor.greenColor()
        }
        
        return LineDrawStyle(lineWidth: lineWidth, lineColor: lineColor, lineCap: .Butt, lineJoin: .Bevel)
    }
    
    func getLineType(row row: Int, column: Int, lineIndex: Int) -> LineType{
        if row == 0 {
            return LineType.Segment
        }else if row == 2 && lineIndex == 0 {
            return LineType.Curve
        }
        
        return LineType.Straight
    }
    
    func getLineStartPoint(row row: Int, column: Int) -> CGPoint{
        let frame = treeGraph.getCellRectAtIndexPath(IndexPath(row: row, column: column))
        
        if row == 4 || (row == 5 && column == 0)  {
            return CGPoint(x: frame.midX, y: frame.maxY)
        }
        
        return CGPoint(x: frame.midX, y: frame.minY)
    }
    
    func getLineEndPoint(row row: Int, column: Int, lineIndex: Int) -> CGPoint{
        if row == 2 && lineIndex == 1 {
            let frame = treeGraph.getCellRectAtIndexPath(IndexPath(row: 4, column: 0))
            return CGPoint(x: frame.midX, y: frame.minY)
        }
        
        let frame = treeGraph.getCellRectAtIndexPath(IndexPath(row: row, column: column))
        return CGPoint(x: frame.midX, y: frame.minY - 40)
    }
    
    func getLineBreakPoints(row row: Int, column: Int, lineIndex: Int) -> [CGPoint]{
        return [ CGPoint(x: 450, y: 60), CGPoint(x: 550, y: 50)]
    }
    
    func getLineControlPoints(row row: Int, column: Int, lineIndex: Int) -> [CGPoint]{
        return [CGPoint(x: 350, y: 170), CGPoint(x: 380, y: 200)]
    }
    

    // breakHanged, all the below views are connectd for default
    func getLineHangingPoint(row row: Int, column: Int, lineIndex: Int) -> CGPoint{
        let frame = treeGraph.getCellRectAtIndexPath(IndexPath(row: row, column: column))
        let gap = treeGraph.rowGap
        
        return CGPoint(x: frame.midX, y: frame.maxY + gap * 0.5)
    }
    
    func getLineConnectionPoints(row row: Int, column: Int, lineIndex: Int) -> [CGPoint]{
        var nextRowIndex : Int
        
        if row == 0 {
            nextRowIndex = 2
        }else {
            nextRowIndex = row + 1 // if out of range, return nil, no need to worry
            
        }
        let nextRow = treeGraph.rowAtIndex(nextRowIndex)
        if nextRow == nil {
            return [CGPointZero]
        }
        
        var points = [CGPoint]()
        
        for c in 0..<nextRow!.numberOfNodes() {
            let frame = treeGraph.getCellRectAtIndexPath(IndexPath(row: nextRowIndex, column: c))
            points.append(CGPoint(x: frame.midX, y: frame.minY))
        }
        
        return points
    }
}