//
//  TreeRingMapAxisDataModel.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/1.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class TreeRingMapAxisDataModel {
    var key = "Identifier"
    var displayText: String?
    var textAlignment = NSTextAlignment.center
    var textColor = UIColor.black
    var textBackgoundColor = UIColor.clear
    
    var tip: String!
    
    var imageUrl: URL?
    var imageKey: String?   // local image, use name
    var imageBorderColor = UIColor.black
    
    // display type
    var showText = true
    var showImage = true
    var roundImage = true
    var inside = false
//    var labelConstraint = UILayoutConstraintAxis.horizontal
    
}
