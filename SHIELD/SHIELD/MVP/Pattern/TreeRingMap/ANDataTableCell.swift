//
//  ANDataTableCell.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/17.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class ANDataTableCell: NSObject {
    // data
    var value: Float?
    // data unit
    var unit_name: String?
    var unit_symbol: String?
    // tip, can store statement used for card
    var tip: String?
    // !!! to do, add additional information needed for card presentation
    var title: String?
    // presentation information
//    var viewSize: CGFloat?
    // color
    var color: UIColor?     // used in the absense of image
    // image options
    var image: UIImage?
    // source of image
    var imageUrl: URL?
    var imageKey: String?
}
