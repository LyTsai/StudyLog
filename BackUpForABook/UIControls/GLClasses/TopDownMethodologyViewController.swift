//
//  TopDownMethodologyViewController.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/9/12.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import UIKit

class TopDownMethodologyViewController: ANTreeGraphOverlapViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        self.view.insertSubview(linesView, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        // change the frame of attachedViews
//        let offsetProportion: CGFloat = 0.1
//        
//        for r in 0..<numberOfRows() {
//            for c in 0..<numberOfColumns(r) {
//                if getNodeView(row: r, column: c) == nil {
//                    attachedViews[r][c] = nil
//                }else {
//                    let frame = backViews[r][c]!.frame
//                    let offset = UIOffset(horizontal: offsetProportion * frame.height, vertical: offsetProportion * frame.height)
//                    
//                    let view = attachedViews[r][c]
//                    view!.frame = CGRect(x: frame.origin.x + offset.horizontal, y: frame.origin.y + offset.vertical, width: frame.width, height: frame.height)
//                }
//            }
//        }
    }
    
    override func updateFrame(){
        // change the last row
        let settedFrame = treeGraph.getCellRectAtNodeIndexPath(NodeIndexPath(row: 5, column: 0))
        let row2Y = treeGraph.getCellRectAtNodeIndexPath(NodeIndexPath(row: 2, column: 0)).minY
        let newFrame = CGRect(x: settedFrame.minX, y: row2Y, width: settedFrame.width, height: settedFrame.height)
        nodeViews[5][0]!.frame = newFrame
        
    }

    
    override func getNodeView(_ row: Int, column: Int) -> AnyObject? {
        return nodeViews[row][column]
    }
    
    // detail
    let h10Pro: CGFloat = 10 / 768
    let w10Pro: CGFloat = 10 / 1024
    
    
    
    override func numberOfRows() -> Int {
        return 6
    }
    
    override func getRowGap() -> CGFloat {
        return 2 * viewHeight * h10Pro
    }
    
    override func getTopMargin() -> CGFloat {
        return 12 * viewHeight * h10Pro
    }
    
    override func getBottomMargin() -> CGFloat {
        return 12 * viewHeight * h10Pro
    }
    
    override func getRowSizeType(_ row: Int) -> SizeType {
        return .evenDistributed
    }
    
    override func numberOfColumns(_ row: Int) -> Int {
        switch row {
        case 1, 3:
            return 6
        case 2:
            return 4
        case 4:
            return 3
        default:
            return 1
        }
    }
    
    override func getAlignment(_ row: Int) -> Alignment {
        if row == 0 {
            return Alignment.center
        }
        return Alignment.anchorNode
    }
    
    override func getAnchorNodeIndex(_ row: Int) -> Int {
        return -1
    }
    
    override func getAnchorNodeParentIndexPath(_ row: Int) -> NodeIndexPath {
        switch row {
        case 2:
            return NodeIndexPath(row: 1, column: 0)
        case 3:
            return NodeIndexPath(row: 2, column: 0)
        case 4:
            return NodeIndexPath(row: 3, column: 5)
        case 5:
            return NodeIndexPath(row: 1, column: 4)
        default:
            return NodeIndexPath(row: -1, column: -1)
        }
    }
    
    override func getNodeSizeType(_ row: Int, column: Int) -> SizeType {
        return SizeType.evenDistributed
    }
    
    override func getLeftEdgeMargin(_ row: Int) -> CGFloat {
        if row == 0 {
            return viewWidth / 3
        }
        
        return 0
    }
    
    override func getNodeMaxSize(_ row: Int, column: Int) -> CGFloat {
        return 9 * viewWidth * w10Pro
    }
    
    override func getNodeGap(_ row: Int) -> CGFloat {
        return viewWidth * w10Pro
    }
    
    // lines
    override func updateLineCollection() -> [ABSLine] {
        var allLines = [ABSLine]()
        
        let line01 = graphLines.linesHangFromNode(NodeIndexPath(row: 0, column: 0), toRow: 1, toColumns: [], proportionOfFrom: 0.75)
        let line12 = graphLines.linesHangFromNode(NodeIndexPath(row: 1, column: 0), toRow: 2, toColumns: [], proportionOfFrom: 0.75)
        let line23 = graphLines.linesHangFromNode(NodeIndexPath(row: 2, column: 0), toRow: 3, toColumns: [], proportionOfFrom: 0.75)
        let line34 = graphLines.linesHangFromNode(NodeIndexPath(row: 3, column: 5), toRow: 4, toColumns: [], proportionOfFrom: 0.75)
        let line15 = graphLines.linesHangFromNode(NodeIndexPath(row: 1, column: 4), toRow: 5, toColumns: [], proportionOfFrom: 0.75)
        
        allLines = line01 + line12 + line23 + line34 + line15
        
        return allLines
    }
    
    // views
//    override func getAttachedViewAttributedText(_ row: Int, column: Int) -> NSAttributedString? {
//        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20), NSForegroundColorAttributeName: UIColor.yellow]
//        
//        return NSAttributedString(string: "\(row) and \(column)", attributes: attributes)
//    }
    
}
