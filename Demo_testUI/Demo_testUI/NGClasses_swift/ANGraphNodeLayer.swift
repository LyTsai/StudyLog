//
//  ANGraphNodeLayer.swift
//  NGClasses
//
//  Created by iMac on 16/12/14.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// object for holding visual presentation information:
// node - reference to object that has size and location computed
// layer - reference to object that provide visual presentation for this node
class ANGraphNodeLayer {
    // node for data
    var node = ANLayoutNode()
    
    // CALayer for node presentation
    var layer = ANNodeLayer()
    
    // Designated init
    // initalize with node only
    init(_ node: ANLayoutNode){
        self.node = node
        self.layer = ANNodeLayer()
    }
    
    // initalize with node and drawing layer
    init(_ node: ANLayoutNode, layer: CALayer) {
        self.node = node
        self.layer = layer as! ANNodeLayer
    }
}
