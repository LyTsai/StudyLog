//
//  ANTreeGraphSlowAgingGamesController.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/8/22.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ANTreeGraphSlowAgingGamesController: ANTreeGraphOverlapViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        view.insertSubview(linesView, at: 0)
    }
    
    
    override func prepareGraphView() {
        super.prepareGraphView()
        for r in 0..<numberOfRows() {
            for c in 0..<numberOfColumns(r) {
                let attachedView = attachedViews[r][c]
                if attachedView == nil {
                    continue
                }
                
                attachedView!.tag = r * 100 + c
                attachedView!.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            }
        }
    }
    
    // MARK: --------- buttonclicked
    func buttonClicked(_ button: UIButton) {
        print(button.tag)
    }
    
    
    // MARK: ---------- protocol
    override func getNodeView(_ row: Int, column: Int) -> AnyObject? {
        switch (row, column) {
        case (1,_),(3,_), (6,4),(6,5),(6,6):
            return nil
        default:
            return nodeViews[row][column]
        }
    }
    
    override func getTopMargin() -> CGFloat {
        return viewHeight * 0.04
    }
    
    override func getBottomMargin() -> CGFloat {
        return viewHeight * 0.03
    }
    
    override func numberOfRows() -> Int {
        return 7
    }
    
    override func numberOfColumns(_ row: Int) -> Int {
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
    override func getRowSizeType(_ row: Int) -> SizeType {
        return .evenDistributed
    }
    override func getWeight(_ row: Int) -> CGFloat {
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
        return viewHeight * 0.026
    }
    
    override func getAlignment(_ row: Int) -> Alignment {
        if row == 6 {
            return Alignment.anchorNode
        }
        return .center
    }
    
    override func getAnchorNodeIndex(_ row: Int) -> Int {
        if row == 6 {
            return 8
        }
        
        return -1
    }
    
    override func getAnchorNodeParentIndexPath(_ row: Int) -> NodeIndexPath {
        switch row {
        case 6:
            return NodeIndexPath(row: 5, column: 7)

        default:
            return NodeIndexPath(row: -1, column: -1)
        }
    }
    
    override func getRowMaxSize(_ row: Int) -> CGFloat {
        switch row {
        case 0, 2, 3:
            return viewHeight * 0.3
        case 1:
            return viewHeight * 0.01
        default:
            return viewHeight / 5
        }
    }
    
    override func getRowMinSize(_ row: Int) -> CGFloat {
        return viewHeight * 0.07
    }
    
    override func getLeftEdgeMargin(_ row: Int) -> CGFloat {
        if row == 4 || row == 5 {
            return viewWidth * 0.03
        }
        
        return 0
    }
    
    override func getRightEdgeMargin(_ row: Int) -> CGFloat {
        if row == 0 || row == 2 {
            return viewWidth / 6
        }
        
        return viewWidth * 0.02
    }
    
    // nodes' detail
    override func getNodeGap(_ row: Int) -> CGFloat {
        if row == 2 {
            return viewWidth / 20
        }
        
        return viewWidth * 0.019
    }
    
    override func getNodeMaxSize(_ row: Int, column: Int) -> CGFloat {
        if row == 0 || row == 2{
            return viewWidth / 5
        }
        
        return viewWidth * 0.1
    }
    
    override func getNodeMinSize(_ row: Int, column: Int) -> CGFloat {
        return viewWidth * 0.05
    }
    
    override func getNodeSizeType(_ row: Int, column: Int) -> SizeType {
        if row == 6 {
            if column == 4 || column == 5 || column == 6 {
                return SizeType.fixed
            }
        }
        return SizeType.evenDistributed
    }
    
    override func getNodeSize(_ row: Int, column: Int) -> CGFloat {

        return viewWidth * 0.063
    }
    
    // lines
    override func updateLineCollection() -> [ABSLine] {
        var allLines = [ABSLine]()
        // the three yellow arrow and tiny black line(need?)
        let gap = getRowGap() * 2 + treeGraph.getCellRectAtNodeIndexPath(NodeIndexPath(row: 3, column: 0)).height
        allLines.append(ABSLine.createOffsetABSLineWithBeginRow(2, beginColumn: 0, beginAnchorRef: AnchorPosition.Bottom_Center, beginOffset: UIOffset.zero, endRow: 4, endColumn: 0, endAnchorRef: AnchorPosition.Left_Center, endOffset: UIOffset(horizontal: 0, vertical: -10), type: LinePathType.Straight))
        allLines.append(ABSLine.createOffsetABSLineWithBeginRow(4, beginColumn: 0, beginAnchorRef: AnchorPosition.Top_Center, beginOffset: UIOffset(horizontal: 0, vertical: -gap), endRow: 4, endColumn: 0, endAnchorRef: AnchorPosition.Top_Center, endOffset: UIOffset.zero, type: .Straight))
        allLines.append(ABSLine.createOffsetABSLineWithBeginRow(2, beginColumn: 2, beginAnchorRef: AnchorPosition.Bottom_Center, beginOffset: UIOffset(horizontal: 50, vertical: 0), endRow: 4, endColumn: 0, endAnchorRef: AnchorPosition.Right_Center, endOffset: UIOffset(horizontal: 0, vertical: -10), type: .Straight))
        
        let line1 = graphLines.linesHangFromNode(NodeIndexPath(row: 0, column: 0), toRow: 2, toColumns: [], proportionOfFrom: 0.7)
        let line2 = graphLines.linesHangFromNode(NodeIndexPath(row: 4, column: 0), toRow: 5, toColumns: [],proportionOfFrom: 0.7)
        // the last line, add and remove several lines
        let line3 = graphLines.linesHangFromNode(NodeIndexPath(row: 5, column: 1), toRow: 6, toColumns: [0,1,2,3],proportionOfFrom: 0.75)
        let line4 = graphLines.linesHangFromNode(NodeIndexPath(row: 5, column: 7), toRow: 6, toColumns: [7,8,9],proportionOfFrom: 0.75)
        
        allLines += line1 + line2 + line3 + line4
        
        return allLines
    }
    
    override func getLineDrawingStyle(_ index: NSInteger) -> ANLineDrawStyle {
        // the first three yellow lines
        if index < 3 {
            return ANLineDrawStyle(lineWidth: 5, lineColor: UIColor.orange.withAlphaComponent(0.9), lineCap: .butt, lineJoin: .bevel)
        }
        return ANLineDrawStyle(lineWidth: 8, lineColor: UIColor.white.withAlphaComponent(0.9), lineCap: .round, lineJoin: .bevel)
    }
    
    override func getLineEndType(_ index: Int) -> LineEndType {
        if index < 3 {
            return LineEndType.LinesArrow
        }
        
        return LineEndType.Normal
    }
    
    override func getEndInfo(_ index: Int) -> (includedAngle: CGFloat, edgeLength: CGFloat){
        return (CGFloat(M_PI / 3), 0.04 * viewWidth)
    }
    
    // overlap
//    override func getAttachedViewContentAlignment(_ row: Int, column: Int) -> (horizontal: UIControlContentHorizontalAlignment,vertical: UIControlContentVerticalAlignment){
//        if row == 2  {
//            return (.left, .top)
//
//        }
//        return (.center, .center)
//    }
//    
//    override func getAttachedViewAttributedText(_ row: Int, column: Int) -> NSAttributedString? {
//        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20), NSForegroundColorAttributeName: UIColor.yellow]
//        
//        return NSAttributedString(string: "\(row) and \(column)", attributes: attributes)
//    }
//    
//    override func getAttachedViewTitleEdgeInsets(_ row: Int, column: Int) -> UIEdgeInsets {
//        if row == 2 {
//            let button = attachedViews[row][column]!
//            return UIEdgeInsets(top: 10, left: button.bounds.midX - button.titleLabel!.bounds.width * 0.5 - button.imageView!.bounds.width , bottom: 5, right: 0)
//        }
//        return UIEdgeInsets.zero
//    }
//    
//    override func getAttachedViewImage(_ row: Int, column: Int) -> UIImage? {
//        if row == 2 {
//            return UIImage(named: "leftImage")
//        }
//        
//        return nil
//    }
//    
//    override func getAttachedViewImageEdgeInsets(_ row: Int, column: Int) -> UIEdgeInsets {
//        if row == 2 {
//            let button = attachedViews[row][column]!
//            return UIEdgeInsets(top: button.bounds.midY - button.titleLabel!.bounds.maxY, left: button.bounds.midX - button.imageView!.bounds.width * 0.5, bottom: 0, right: 0)
//        }
//        
//        return UIEdgeInsets.zero
//    }
    
}
