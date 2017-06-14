//
//  TRCell.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/17.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRCell: NSObject {
    var layer: CALayer?
    var displayStyle: CellValueShow?
    var cellShape: CellValueShape?
    var withShadow: Bool?
    var withOutline: Bool?
    var displaySize: Int?
    var showValue: Bool?
    var value: Double?
    var unit: String?
    var name: String?
    var text: String?
    var metricColor: UIColor?
    var image: UIImage?
    
    override init() {
        super.init()
        displayStyle = .flat
        cellShape = .circle
        showValue = true
        value = -1.0
        name = nil
        unit = nil
        text = nil
        displaySize = 8
        layer = nil
        metricColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        image = nil
    }
}
