//
//  ANLayoutGridCell.swift
//  NGClasses
//
//  Created by iMac on 16/12/14.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ANLayoutGridCell {
    // column and row
    var col: Int = -1
    var row: Int = -1
    
    // current node resident.  the same node index
    var nodeIndex: Int = -1
    
    // distance between cell center and its hosting node
    var distance2Node: CGFloat = 10000000.0  // invalid
    
    // node distribution (or overlapp) information
    // nodes that falls (or overlapped with) onto this cell
    // !!! this is a "effective" number of resident.  for example, if a node os size .5 falls onto a cell of size 1 then the contribution to this value is .5
    var numberOfNodeResidents: CGFloat = 0
    // effective node mass attached to this cell
    var nodeMass: CGFloat = 0
    // node mass gradient
    var nodeMassGradient: CGFloat = 0
    
    // hosted node
    weak var node: ANLayoutNode!
    
    // most "dominat" node that may not be hosted within this cell by ovelap with this cell
    weak var strongestNodeNearby: ANLayoutNode!
    
    // method
    init() {
        
    }
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}
