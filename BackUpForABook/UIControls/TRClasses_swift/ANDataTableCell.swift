//
//  ANDataTableCell.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/17.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class ANDataTableCell: NSObject {
    var unit_name: String?
    var unit_symbol: String?
    var value: Double?
    var image: UIImage?
    var viewSize: Int?
    var tip: String?
    
    class func create(_ unit: String, symbol: String, value: Double, image: UIImage?, viewSize: Int, tip: String) -> ANDataTableCell{
        let oneCell = ANDataTableCell()
        oneCell.unit_name = unit
        oneCell.unit_symbol = symbol
        oneCell.value = value
        oneCell.image = image
        oneCell.viewSize = viewSize
        oneCell.tip = tip
        return oneCell
    }

}
