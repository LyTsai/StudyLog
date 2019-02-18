//
//  ANTreeGraphViewController.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/8/26.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// class for no node lines
class ANTreeGraphViewController: UIViewController, ANTreeMapDataSourceProtocal {
    var treeGraph = ANTreeGraphLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()

        treeGraph.dataSoure = self
        prepareGraphView()
        treeGraph.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        treeGraph.setFrame(view.bounds)
        
        for r in 0..<treeGraph.numberOfRows() {
            for c in 0..<treeGraph.rowAtIndex(r)!.numberOfNodes() {
                let nodeView = treeGraph.dataSoure.getNodeView(row: r, column: c)
                // no show for this row, row is not nil, but view is
                if nodeView == nil {
                    continue
                }
                
                if nodeView!.isKindOfClass(UIView) == true {
                    let view = nodeView as! UIView
                    view.frame = treeGraph.getCellRectAtIndexPath(IndexPath(row: r, column: c))
                } else if nodeView!.isKindOfClass(CALayer) == true {
                    let layer = nodeView as! CALayer
                    layer.frame = treeGraph.getCellRectAtIndexPath(IndexPath(row: r, column: c))
                }
            }
        }
    }
    
    func prepareGraphView()  {
        
    }
    
    func getNodeFrame(row row: Int, column: Int) -> CGRect {
        if row >= treeGraph.numberOfRows() || column >= treeGraph.rowAtIndex(row)!.numberOfNodes() {
            return CGRectZero
        }
        
        return treeGraph.getCellRectAtIndexPath(IndexPath(row: row, column: column))
    }
    
    
    // Protocols
    func getNodeView(row row: Int, column: Int) -> AnyObject? {
        return nil
    }
    
    // tree map structure
    /** return number of rows */
    func numberOfRows() -> Int{
        return 10
    }
    /** return gap among rows */
    func getRowGap() -> CGFloat {
        return 22
    }
    // return margins at top and bottom
    func getTopMargin() -> CGFloat {
        return 0
    }
    func getBottomMargin() -> CGFloat {
        return 0
    }
    
    // information for each row
    func numberOfColumns(row: Int) -> Int {
        return 6
    }
    // return layout information for given row
    func getRowSizeType(row: Int) -> SizeType {
        return SizeType.EvenDistributed
    }
    func getRowMaxSize(row: Int) -> CGFloat {
        return 64
    }
    func getRowMinSize(row: Int) -> CGFloat {
        return 22
    }
    func getSize(row: Int) -> CGFloat {
        return 64
    }
    func getRatio(row: Int) -> CGFloat {
        return 0.2
    }
    func getWeight(row: Int) -> CGFloat {
        return 1.0
    }
    func getNodeGap(row: Int) -> CGFloat {
        return 8
    }
    func getLeftEdgeMargin(row: Int) -> CGFloat {
        return 0
    }
    func getRightEdgeMargin(row: Int) -> CGFloat {
        return 0
    }
    
    // archor node in current row
    func getAnchorNodeIndex(row: Int) -> Int {
        return -1
    }
    // parent node (from row above) of archor node for getting archor node position.
    func getAnchorNodeParentIndexPath(row: Int) -> IndexPath {
        return IndexPath(row: -1, column: -1)
    }
    // type of anchor
    func getAlignment(row: Int) -> Alignment{
        return Alignment.Center
    }
    
    // information for each node
    // return layout information for given node at (row, column)
    func getNodeSizeType(row row: Int, column: Int) -> SizeType {
        return SizeType.EvenDistributed
    }
    func getNodeMaxSize(row row: Int, column: Int) -> CGFloat {
        return 64
    }
    func getNodeMinSize(row row: Int, column: Int) -> CGFloat {
        return 22
    }
    func getNodeSize(row row: Int, column: Int) -> CGFloat {
        return 64
    }
    func getNodeRatio(row row: Int, column: Int) -> CGFloat {
        return 1.0
    }
    func getNodeWeight(row row: Int, column: Int) -> CGFloat {
        return 1.0
    }
    
}

// MARK: -------- viewController with lines by points
class ANTreeGraphLineViewController: ANTreeGraphViewController, ANTreeMapLineDataProtocal {
    /** the view that has all the lines, add to viewController as needed*/
    var linesView = ANLinesView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        linesView.lineData = self
        linesView.nodeData = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.setNeedsDisplay()
    }
    
    // MARK: lines
    func getLineOverallInformation(row row: Int, column: Int) -> [(beginPoint: CGPoint, connectionType: LineConnectionType)]{
        let frame = treeGraph.getCellRectAtIndexPath(IndexPath(row: row, column: column))
        return [(beginPoint: CGPoint(x: frame.midX, y: frame.minY), connectionType: LineConnectionType.TwoPoints)]
    }
    
    
    // About the lines
    func getLineDrawStyle(row row: Int, column: Int, lineIndex: Int) -> ANLineDrawStyle{
        return ANLineDrawStyle(lineWidth: 3, lineColor: UIColor.yellowColor(), lineCap: .Butt, lineJoin: .Bevel)
    }
    
    func getLineConnectionType(row row: Int, column: Int) -> LineConnectionType{
        if  row == 1 || row == 3 {
            return .None
        }
        else {
            return .TwoPoints
        }
    }
    
    // About the lines
    func getLinePathType(row row: Int, column: Int, lineIndex: Int) -> LinePathType{
        
        return LinePathType.Straight
    }
    
    func getLinebeginPoint(row row: Int, column: Int) -> CGPoint{
        let frame = treeGraph.getCellRectAtIndexPath(IndexPath(row: row, column: column))
        return CGPoint(x: frame.midX, y: frame.minY)
    }
    func getLineEndPoint(row row: Int, column: Int, lineIndex: Int) -> CGPoint{
        let frame = treeGraph.getCellRectAtIndexPath(IndexPath(row: row, column: column))
        return CGPoint(x: frame.midX, y: frame.minY - 20)
    }
    
    func getLineBreakPoints(row row: Int, column: Int, lineIndex: Int) -> [CGPoint]{
        return [CGPointZero]
    }
    func getLineControlPoints(row row: Int, column: Int, lineIndex: Int) -> [CGPoint]{
        return [CGPointZero]
    }
    
    // breakHanged, all the below views are connectd for default
    func getLineHangingPoint(row row: Int, column: Int, lineIndex: Int) -> CGPoint{
        let frame = treeGraph.getCellRectAtIndexPath(IndexPath(row: row, column: column))
        let gap = getRowGap()
        
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


// MARK: -------- viewController with lines by nodes
class ANTreeGraphNodeLineViewController: ANTreeGraphViewController, ANTreeMapNodeLineDataProtocal {
    var graphLines = ANTreeGraphLineProjector()
    /** the view that has all the lines, add to viewController as needed*/
    var linesView = ANLineCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphLines.dataSoure = self
        linesView.lines = graphLines
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
 
    // if placed in viewDidLoad, the data of nodes is not updated -- the update of nodes' frames are in viewDidLayoutSubviews
        self.updateLineCollection()
        graphLines.reloadData()
        
        linesView.setNeedsDisplay()
    }
    
    // MARK: lines

    func attachedNodeMap() -> ANTreeMap {
        return treeGraph
    }
    
    // used to define lines here,as a package
    func updateLineCollection()-> [ABSLine] {
        var lineGraph = [ABSLine]()
        lineGraph.removeAll()
        
        // add lines
        lineGraph.append(ABSLine.createABSLineWithBeginRow(0, beginColumn: 0, beginAnchorRef: AnchorPosition.Bottom_Center, endRow: 2, endColumn: 1, endAnchorRef: .Top_Center, type: LinePathType.Straight))
        
        for i in 0..<3 {
        lineGraph.append(ABSLine.createABSLineWithBeginRow(2, beginColumn: i, beginAnchorRef: .Bottom_Center, endRow: 4, endColumn: 0, endAnchorRef: .Top_Center, type: .Straight))
        }

        let gap: CGFloat = treeGraph.rowGap * 2 + treeGraph.getCellRectAtIndexPath(IndexPath(row: 1, column: 0)).height
        let offset = UIOffset(horizontal: 0, vertical: -gap * 0.6)
        
        lineGraph.append(ABSLine.createOffsetABSLineWithBeginRow(2, beginColumn: 0, beginAnchorRef: .Top_Center, beginOffset: offset, endRow: 2, endColumn: 2, endAnchorRef: .Top_Center, endOffset: offset, type: .Straight))
        
        for i in 0..<3 {
            lineGraph.append(ABSLine.createOffsetABSLineWithBeginRow(2, beginColumn: i, beginAnchorRef: .Top_Center, beginOffset: UIOffsetZero, endRow: 2, endColumn: i, endAnchorRef: .Top_Center, endOffset: offset, type: .Straight))
        }
        
        return lineGraph
    }

    // the line styles
    func getLineDrawingStyle(index : NSInteger) -> ANLineDrawStyle {
        if index <= 7 {
            return ANLineDrawStyle(lineWidth: 2, lineColor: UIColor.redColor(), lineCap: .Round, lineJoin: .Bevel)
        }else {
            return ANLineDrawStyle(lineWidth: 4, lineColor: UIColor.cyanColor(), lineCap: .Round, lineJoin: .Bevel)
        }
    }
    
    func getLineEndType(index: Int) -> LineEndType {
        return LineEndType.Normal
    }
    func getEndInfo(index: Int) -> (includedAngle: CGFloat, edgeLength: CGFloat){
        return (CGFloat(M_PI / 3), 40)
    }
    
    func getLineColorType(index: Int) -> LineColorType {
        return LineColorType.Single
    }
    
    func getGradientColors(index: Int) -> [CGColor] {
        return []
    }
}
