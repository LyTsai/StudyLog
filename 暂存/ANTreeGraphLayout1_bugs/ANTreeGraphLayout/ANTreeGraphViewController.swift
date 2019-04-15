//
//  ANTreeGraphViewController.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/8/26.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

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
        
        self.view.setNeedsDisplay()
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
