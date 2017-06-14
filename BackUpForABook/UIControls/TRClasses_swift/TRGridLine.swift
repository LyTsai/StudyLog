//
//  TRGridLine.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRGridLine: NSObject {
    var color: UIColor?
    var size: Float?
    var style: GridLine?

    override init() {
        super.init()
        style = .solid
        size = 2.0
        color = UIColor.white
    }
}
