//
//  ANTreeGraphSlowAgingGamesController.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/8/22.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ANTreeGraphSlowAgingGamesController: ANTreeGraphNodeLineViewController {
    var backViews = [[UIView?]]()
    var attachedViews = [[UIView?]]()
    
    private let offsetProportion: CGFloat = 0.15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = linesView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // change the frame of attachedViews
        for r in 0..<numberOfRows() {
            for c in 0..<numberOfColumns(r) {
                if getNodeView(row: r, column: c) == nil {
                    attachedViews[r][c] = nil
                }else {
                    let frame = treeGraph.getCellRectAtIndexPath(IndexPath(row: r, column: c))
                    let offset = UIOffset(horizontal: offsetProportion * frame.height, vertical: offsetProportion * frame.height)
                    
                    let view = attachedViews[r][c]
                    view!.frame = CGRect(x: frame.origin.x + offset.horizontal, y: frame.origin.y + offset.vertical, width: frame.width, height: frame.height)
                }
            }
        }
    }
    
    override func prepareGraphView() {
        for r in 0..<numberOfRows() {
            var nodes = [UIView?]()
            var attaches = [UIView?]()
            for c in 0..<numberOfColumns(r) {
                let nodeView = UIView()
                nodeView.backgroundColor = UIColor.lightGrayColor()
                nodeView.layer.masksToBounds = true
                nodeView.layer.cornerRadius = 5
                
                let attachedView = UIButton()
                attachedView.backgroundColor = UIColor.greenColor()
                attachedView.layer.masksToBounds = true
                attachedView.layer.cornerRadius = 5
                attachedView.tag = r * 100 + c
                attachedView.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents: .TouchUpInside)
                
                linesView.addSubview(nodeView)
                linesView.addSubview(attachedView)
                
                nodes.append(nodeView)
                attaches.append(attachedView)
            }
            backViews.append(nodes)
            attachedViews.append(attaches)
        }
    }
    
    // MARK: --------- buttonclicked
    func buttonClicked(button: UIButton) {
        print(button.tag)
    }
    
    override func getNodeView(row row: Int, column: Int) -> AnyObject? {
        switch (row, column) {
        case (1,_),(3,_), (6,4),(6,5),(6,6):
            return nil
        default:
            return backViews[row][column]
        }
    }
    
    override func getTopMargin() -> CGFloat {
        return 35
    }
    
    override func getBottomMargin() -> CGFloat {
        return 20
    }
    
    override func numberOfRows() -> Int {
        return 7
    }
    
    override func numberOfColumns(row: Int) -> Int {
        switch row {
        case 0:
            return 1
        case 2:
            return 3
        case 4:
            return 1
        case 5:
            return 9
        case 6:
            return 10
       
        default:
            return 1
        }
    }
    
    // rows' detail
    override func getRowSizeType(row: Int) -> SizeType {
        return .EvenDistributed
    }
    override func getWeight(row: Int) -> CGFloat {
        switch row {
        case 0, 3:
            return 1.8
        case 2:
            return 2
        default:
            return 1
        }
    }
    override func getRowGap() -> CGFloat {
        return 20
    }
    
    override func getAlignment(row: Int) -> Alignment {
        if row == 6 {
            return Alignment.AnchorNode
        }
        return .Center
    }
    
    override func getAnchorNodeIndex(row: Int) -> Int {
        if row == 6 {
            return 8
        }
        
        return -1
    }
    
    override func getAnchorNodeParentIndexPath(row: Int) -> IndexPath {
        switch row {
        case 6:
            return IndexPath(row: 5, column: 7)

        default:
            return IndexPath(row: -1, column: -1)
        }
    }
    
    override func getRowMaxSize(row: Int) -> CGFloat {
        switch row {
        case 0, 2, 3:
            return 460
        case 1:
            return 10
        default:
            return 200
        }
    }
    
    override func getRowMinSize(row: Int) -> CGFloat {
        return 60
    }
    
    override func getLeftEdgeMargin(row: Int) -> CGFloat {
        if row == 4 || row == 5 {
            return 30
        }
        
        return 0
    }
    
    override func getRightEdgeMargin(row: Int) -> CGFloat {
        if row == 0 || row == 2 {
            return 200
        }
        
        return 20
    }
    
    // nodes' detail
    override func getNodeGap(row: Int) -> CGFloat {
        if row == 2 {
            return 50
        }
        
        return 15
    }
    
    override func getNodeMaxSize(row row: Int, column: Int) -> CGFloat {
        if row == 0 || row == 2{
            return 220
        }
        
        return 110
    }
    
    override func getNodeMinSize(row row: Int, column: Int) -> CGFloat {
        return 50
    }
    
    override func getNodeSizeType(row row: Int, column: Int) -> SizeType {
        if row == 6 {
            if column == 4 || column == 5 || column == 6 {
                return SizeType.Fixed
            }
        }
        return SizeType.EvenDistributed
    }
    
    override func getNodeSize(row row: Int, column: Int) -> CGFloat {

        return 65
    }
    
    // lines
    override func updateLineCollection() -> [ABSLine] {
        var allLines = [ABSLine]()
        // the three yellow arrow and tiny black line(need?)
        let gap = getRowGap() * 2 + treeGraph.getCellRectAtIndexPath(IndexPath(row: 3, column: 0)).height
        allLines.append(ABSLine.createOffsetABSLineWithBeginRow(2, beginColumn: 0, beginAnchorRef: AnchorPosition.Bottom_Center, beginOffset: UIOffsetZero, endRow: 4, endColumn: 0, endAnchorRef: AnchorPosition.Left_Center, endOffset: UIOffset(horizontal: 0, vertical: -10), type: LinePathType.Straight))
        allLines.append(ABSLine.createOffsetABSLineWithBeginRow(4, beginColumn: 0, beginAnchorRef: AnchorPosition.Top_Center, beginOffset: UIOffset(horizontal: 0, vertical: -gap), endRow: 4, endColumn: 0, endAnchorRef: AnchorPosition.Top_Center, endOffset: UIOffsetZero, type: .Straight))
        allLines.append(ABSLine.createOffsetABSLineWithBeginRow(2, beginColumn: 2, beginAnchorRef: AnchorPosition.Bottom_Center, beginOffset: UIOffset(horizontal: 50, vertical: 0), endRow: 4, endColumn: 0, endAnchorRef: AnchorPosition.Right_Center, endOffset: UIOffset(horizontal: 0, vertical: -10), type: .Straight))
        
        let line1 = graphLines.linesHangFromNode(IndexPath(row: 0, column: 0), toRow: 2, toColumns: [], proportionOfFrom: 0.7)
        let line2 = graphLines.linesHangFromNode(IndexPath(row: 4, column: 0), toRow: 5, toColumns: [],proportionOfFrom: 0.7)
        // the last line, add and remove several lines
        let line3 = graphLines.linesHangFromNode(IndexPath(row: 5, column: 1), toRow: 6, toColumns: [0,1,2,3],proportionOfFrom: 0.75)
        let line4 = graphLines.linesHangFromNode(IndexPath(row: 5, column: 7), toRow: 6, toColumns: [7,8,9],proportionOfFrom: 0.75)
        
        allLines += line1 + line2 + line3 + line4
        
        return allLines
    }
    
    override func getLineDrawingStyle(index: NSInteger) -> ANLineDrawStyle {
        // the first three yellow lines
        if index < 3 {
            return ANLineDrawStyle(lineWidth: 6, lineColor: UIColor.orangeColor().colorWithAlphaComponent(0.9), lineCap: .Butt, lineJoin: .Bevel)
        }
        return ANLineDrawStyle(lineWidth: 8, lineColor: UIColor.whiteColor().colorWithAlphaComponent(0.9), lineCap: .Round, lineJoin: .Bevel)
    }
    
    override func getLineEndType(index: Int) -> LineEndType {
        if index < 3 {
            return LineEndType.LinesArrow
        }
        
        return LineEndType.Normal
    }
}
