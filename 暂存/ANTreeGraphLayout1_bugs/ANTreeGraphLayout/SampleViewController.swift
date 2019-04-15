//
//  ViewController.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/8/15.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import UIKit

class ANTreeGraphSampleViewController: ANTreeGraphViewController {
    var views = [[UIView?]]()
    
    override func prepareGraphView() {
        for r in 0..<numberOfRows() {
            var nodes = [UIView?]()
            for _ in 0..<numberOfColumns(r) {
                let nodeView = UIButton()
                nodeView.backgroundColor = UIColor.blueColor()
                
                view.addSubview(nodeView)
                nodes.append(nodeView)
            }
            views.append(nodes)
        }
    }
    
    override func getNodeView(row row: Int, column: Int) -> AnyObject? {
        // return row 1 and row 3 as "gap"
        if row == 1 || row == 3 {
            return nil
        }
        
        return views[row][column]
    }
    
    override func getTopMargin() -> CGFloat {
        return 60
    }
    
    override func getBottomMargin() -> CGFloat {
        return 44
    }
    
    override func numberOfRows() -> Int {
        return 7
    }
    
    override func numberOfColumns(row: Int) -> Int {
        switch row {
        case 0, 4:
            return 1
        case 2:
            return 3
        case 5:
            return 6
        case 6:
            return 4
        default:
            return 5
        }
    }
    
    override func getRowSizeType(row: Int) -> SizeType {
        return .EvenDistributed
    }
    
    override func getAlignment(row: Int) -> Alignment {
        if row == 6 {
            return .AnchorNode
        }
        return .Center
    }
    
    override func getAnchorNodeIndex(row: Int) -> Int {
        return -1
    }
    
    override func getAnchorNodeParentIndexPath(row: Int) -> IndexPath {
        if row == 6 {
            return IndexPath(row: 5, column: 0)
        }else {
            return IndexPath(row: -1, column: -1)
        }
    }
    
    override func getRowMaxSize(row: Int) -> CGFloat {
        switch row {
        case 0, 2:
            return 128
        case 1:
            return 2
        case 3:
            return 16
        default:
            return 64
        }
    }
    
    override func getSize(row: Int) -> CGFloat {
        return 64
    }
    
    override func getRatio(row: Int) -> CGFloat {
        return 0.2
    }
    
    override func getWeight(row: Int) -> CGFloat {
        if row == 0 || row == 2 {
            return 2.0
        }
        
        return 1.0
    }
    
    override func getLeftEdgeMargin(row: Int) -> CGFloat {
        return 0
    }
    
    override func getRightEdgeMargin(row: Int) -> CGFloat {
        return 0
    }
    
    override func getNodeMaxSize(row row: Int, column: Int) -> CGFloat {
        if row == 0 || row == 2 {
            return 128
        }
        return 64
    }
    
    override func getNodeSizeType(row row: Int, column: Int) -> SizeType {
        if row == 0 || row == 2 {
            return .Ratio
        }
        return .EvenDistributed
    }
    
    override func getNodeWeight(row row: Int, column: Int) -> CGFloat {
        return 1.0
    }
}