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
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        
        treeGraph.dataSoure = self
        prepareGraphView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewWidth = view.bounds.size.width
        viewHeight = view.bounds.size.height
        treeGraph.reloadData()
        treeGraph.setFrame(view.bounds)
        
        for r in 0..<treeGraph.numberOfRows() {
            for c in 0..<treeGraph.rowAtIndex(r)!.numberOfNodes() {
                let nodeView = treeGraph.dataSoure.getNodeView(r, column: c)
                // no show for this row, row is not nil, but view is
                if nodeView == nil {
                    continue
                }
                
                if nodeView!.isKind(of: UIView.self) == true {
                    let view = nodeView as! UIView
                    view.frame = treeGraph.getCellRectAtNodeIndexPath(NodeIndexPath(row: r, column: c))
                } else if nodeView!.isKind(of: CALayer.self) == true {
                    let layer = nodeView as! CALayer
                    layer.frame = treeGraph.getCellRectAtNodeIndexPath(NodeIndexPath(row: r, column: c))
                }
            }
        }
        
        updateFrame()
    }
    
    
    func updateFrame()  {
        // some changes of the frames after all the view's frames are setted.
    }
    
    func prepareGraphView()  {
        
    }
    
    func getNodeFrame(_ row: Int, column: Int) -> CGRect {
        if row >= treeGraph.numberOfRows() || column >= treeGraph.rowAtIndex(row)!.numberOfNodes() {
            return CGRect.zero
        }
        
        let view = getNodeView(row, column: column)
        if view == nil {
            return CGRect.zero
        }else {
            return view!.frame
        }
    }
    

    // Protocols
    func getNodeView(_ row: Int, column: Int) -> AnyObject? {
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
    func numberOfColumns(_ row: Int) -> Int {
        return 6
    }
    // return layout information for given row
    func getRowSizeType(_ row: Int) -> SizeType {
        return SizeType.evenDistributed
    }
    func getRowMaxSize(_ row: Int) -> CGFloat {
        return 64
    }
    func getRowMinSize(_ row: Int) -> CGFloat {
        return 20
    }
    func getSize(_ row: Int) -> CGFloat {
        return 64
    }
    func getRatio(_ row: Int) -> CGFloat {
        return 0.2
    }
    func getWeight(_ row: Int) -> CGFloat {
        return 1.0
    }
    func getNodeGap(_ row: Int) -> CGFloat {
        return 8
    }
    func getLeftEdgeMargin(_ row: Int) -> CGFloat {
        return 0
    }
    func getRightEdgeMargin(_ row: Int) -> CGFloat {
        return 0
    }
    
    // archor node in current row
    func getAnchorNodeIndex(_ row: Int) -> Int {
        return -1
    }
    // parent node (from row above) of archor node for getting archor node position.
    func getAnchorNodeParentIndexPath(_ row: Int) -> NodeIndexPath {
        return NodeIndexPath(row: -1, column: -1)
    }
    // type of anchor
    func getAlignment(_ row: Int) -> Alignment{
        return Alignment.center
    }
    
    // information for each node
    // return layout information for given node at (row, column)
    func getNodeSizeType(_ row: Int, column: Int) -> SizeType {
        return SizeType.evenDistributed
    }
    func getNodeMaxSize(_ row: Int, column: Int) -> CGFloat {
        return 64
    }
    func getNodeMinSize(_ row: Int, column: Int) -> CGFloat {
        return 20
    }
    func getNodeSize(_ row: Int, column: Int) -> CGFloat {
        return 64
    }
    func getNodeRatio(_ row: Int, column: Int) -> CGFloat {
        return 1.0
    }
    func getNodeWeight(_ row: Int, column: Int) -> CGFloat {
        return 1.0
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
        linesView.backgroundColor = UIColor.clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
 
        linesView.frame = view.bounds
       
        graphLines.reloadData()
        let _ = updateLineCollection()
        
        linesView.setNeedsDisplay()
    }
    
    // MARK: lines
    
    func attachedNodeLayout() -> ANTreeGraphLayout {
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

        let gap: CGFloat = treeGraph.rowGap * 2 + treeGraph.getCellRectAtNodeIndexPath(NodeIndexPath(row: 1, column: 0)).height
        let offset = UIOffset(horizontal: 0, vertical: -gap * 0.6)
        
        lineGraph.append(ABSLine.createOffsetABSLineWithBeginRow(2, beginColumn: 0, beginAnchorRef: .Top_Center, beginOffset: offset, endRow: 2, endColumn: 2, endAnchorRef: .Top_Center, endOffset: offset, type: .Straight))
        
        for i in 0..<3 {
            lineGraph.append(ABSLine.createOffsetABSLineWithBeginRow(2, beginColumn: i, beginAnchorRef: .Top_Center, beginOffset: UIOffset.zero, endRow: 2, endColumn: i, endAnchorRef: .Top_Center, endOffset: offset, type: .Straight))
        }
        
        return lineGraph
    }

    // the line styles
    func getLineDrawingStyle(_ index : NSInteger) -> ANLineDrawStyle {
        if index <= 7 {
            return ANLineDrawStyle(lineWidth: 2, lineColor: UIColor.red, lineCap: .round, lineJoin: .bevel)
        }else {
            return ANLineDrawStyle(lineWidth: 4, lineColor: UIColor.cyan, lineCap: .round, lineJoin: .bevel)
        }
    }
    
    func getLineEndType(_ index: Int) -> LineEndType {
        return LineEndType.Normal
    }
    func getEndInfo(_ index: Int) -> (includedAngle: CGFloat, edgeLength: CGFloat){
        return (CGFloat(M_PI / 3), 40)
    }
    
    func getLineColorType(_ index: Int) -> LineColorType {
        return LineColorType.Single
    }
    
    func getGradientColors(_ index: Int) -> [CGColor] {
        return []
    }
}

// MARK: ------------- the most used situation, nodeView with overlapped view on it
class ANTreeGraphOverlapViewController: ANTreeGraphNodeLineViewController, ANTreeGraphOverlapViewProtocol {
    var viewDataSource = ANTreeOverlapViews()
    var nodeViews = [[UIView?]]()
    var attachedViews = [[UIButton?]]()
    
    var offsetProportion: CGFloat = 0.12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDataSource.viewDataSource = self
        viewDataSource.nodeDataSource = self
        
        viewDataSource.setNodeViewDetail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // change the frame of attachedViews
        for r in 0..<numberOfRows() {
            for c in 0..<numberOfColumns(r) {
                if getNodeView(r, column: c) == nil {
                    attachedViews[r][c] = nil
                }else {
                    let frame = nodeViews[r][c]!.frame
                    let offset = UIOffset(horizontal: offsetProportion * frame.height, vertical: offsetProportion * frame.height)
                    
                    let view = attachedViews[r][c]
                    view!.frame = CGRect(x: frame.origin.x + offset.horizontal, y: frame.origin.y + offset.vertical, width: frame.width, height: frame.height)
                }
            }
        }
        
        viewDataSource.adjustEdgeInsets()
    }
    
    override func prepareGraphView() {
        for r in 0..<numberOfRows() {
            var nodes = [UIView?]()
            var attaches = [UIButton?]()
            for _ in 0..<numberOfColumns(r) {
                let nodeView = UIView()
                let attachedView = UIButton()
//                attachedView.tag = r * 100 + c
                
                view.addSubview(nodeView)
                view.addSubview(attachedView)
                
                nodes.append(nodeView)
                attaches.append(attachedView)
            }
            nodeViews.append(nodes)
            attachedViews.append(attaches)
        }
    }


    // protocols
    func getCornerRadius(_ row: Int, column: Int) -> CGFloat {
        return 5
    }
    
    func getNodeBackgroundColor(_ row: Int, column: Int) -> UIColor {
        return UIColor.lightGray
    }
    
    // the overlap - attachedView
    func getNodeAttachedView(_ row: Int, column: Int) -> UIView? {
        return attachedViews[row][column]
    }
    
//    func getAttachedViewContentAlignment(_  row: Int, column: Int) -> (horizontal: UIControlContentHorizontalAlignment,vertical: UIControlContentVerticalAlignment){
//        return (.center, .center)
//    }
//    
//    func getAttachedViewAttributedText(_ row: Int, column: Int) -> NSAttributedString? {
//        return nil
//    }
//    
//    func getAttachedViewTitleEdgeInsets(_ row: Int, column: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
//    
//    func getAttachedViewImage(_ row: Int, column: Int) -> UIImage? {
//        return nil
//    }
//    
//    func getAttachedViewImageEdgeInsets(_ row: Int, column: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
    
    func getAttachedViewBackgroundColor(_ row: Int, column: Int) -> UIColor {
        return UIColor.cyan
    }

}
