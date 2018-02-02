//
//  Defination.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/18.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// MARK: ------------- defination of colors

func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0, blue: CGFloat((rgbValue & 0xFF) >> 16) / 255.0, alpha: 1)
}

/** the textColor for the green-filled buttons */
let heavyGreenColor = UIColorFromRGB(0x417505)

/** for most of the border of buttons, or fill color */
let darkGreenColor = UIColorFromRGB(0x8BC34A)

/** color on cards */
let lightGreenColor = UIColorFromRGB(0x64DD17)

/** background color of the original view, white color */
let backColor = UIColor.white



// defination of device
