//
//  TRAxisTick.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRAxisTick: NSObject {
    var label: TRLabel?
    var viewOffset: Float?
    var gridIndex: Int?
    var viewSpace: Float?
    
    override init() {
        super.init()
        gridIndex = 0
        viewOffset = 0
        viewSpace = 8.0
        label = TRLabel.init()
        label!.fullString = "Red Blood Cell Count \(gridIndex)"
        label?.shortString = "Diabetes \(gridIndex)"
        
    }
    
}
