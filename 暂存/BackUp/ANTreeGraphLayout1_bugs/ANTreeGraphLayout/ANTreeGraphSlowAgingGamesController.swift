//
//  ANTreeGraphSlowAgingGamesController.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/8/22.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ANTreeGraphSlowAgingGamesController: ANTreeGraphViewController {
    var views = [[UIView?]]()
    
    override func prepareGraphView() {
        for r in 0..<numberOfRows() {
            var nodes = [UIView?]()
            for c in 0..<numberOfColumns(r) {
                let nodeView = UILabel()
                nodeView.numberOfLines = 0
                nodeView.font = UIFont.boldSystemFontOfSize(14)
                nodeView.lineBreakMode = .ByClipping
                nodeView.text = "row is \(r) and column is \(c)"
                nodeView.backgroundColor = UIColor.whiteColor()
            
                view.addSubview(nodeView)
                nodes.append(nodeView)
            }
            views.append(nodes)
        }
    }
    
    override func getNodeView(row row: Int, column: Int) -> AnyObject? {
        switch (row, column) {
        case (1,_),(3,_), (6,4),(6,5),(6,6):
            return nil
        default:
            return views[row][column]
        }
    }
    
    override func getTopMargin() -> CGFloat {
        return 35
    }
    
    override func getBottomMargin() -> CGFloat {
        return 25
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
        if row == 0 || row == 2 || row == 3 {
            return 2
        } 
        
        return 1
    }
    override func getRowGap() -> CGFloat {
        return 25
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
            return 360
        case 1:
            return 10
        default:
            return 100
        }
    }
    
    override func getRowMinSize(row: Int) -> CGFloat {
        return 20
    }
    
    override func getLeftEdgeMargin(row: Int) -> CGFloat {
        if row == 5{
            return 50
        }
        
        return 0
    }
    
    override func getRightEdgeMargin(row: Int) -> CGFloat {
//        if row == 0 || row == 2 {
//            return 150
//        }
        return 0
    }
    
    // nodes' detail
    override func getNodeRatio(row row: Int, column: Int) -> CGFloat {
        return 2
    }
    override func getNodeGap(row: Int) -> CGFloat {
        if row == 2 {
            return 60
        }
        
        return 20
    }
    
    override func getNodeMaxSize(row row: Int, column: Int) -> CGFloat {
        if row == 0 || row == 2 || row == 3 {
            return 320
        }
        
        return 150
    }
    
    override func getNodeMinSize(row row: Int, column: Int) -> CGFloat {
        return 10
    }
    
    override func getNodeSizeType(row row: Int, column: Int) -> SizeType {
        if row == 6 {
            if column == 4 || column == 5 || column == 6 {
                return SizeType.Fixed
            }
        }
        return SizeType.Ratio
    }
    
    override func getNodeSize(row row: Int, column: Int) -> CGFloat {
        // TODO: should consider many situations
        return 65
    }
}
