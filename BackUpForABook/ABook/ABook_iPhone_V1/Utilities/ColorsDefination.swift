//
//  Defination.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/18.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// MARK: ------------- definations
func UIColorFromRGBA(_ red: Int, green: Int, blue: Int, alpha: Int) -> UIColor {
    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/100.0)
}

func UIColorFromRGB(_ red: Int, green: Int, blue: Int) -> UIColor {
    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
}

func UIColorGray(_ one: Int) -> UIColor {
    return UIColorFromRGB(one, green: one, blue: one)
}

// detail-defination
let tabTintGreen = UIColorFromRGBA(104, green: 159, blue: 56, alpha: 100)

/** the textColor for the green-filled buttons */
let heavyGreenColor = UIColorFromRGB(0x417505)

/** for most of the border of buttons, or fill color */
let darkGreenColor = UIColorFromRGB(0x8BC34A)

/** color on cards */
let lightGreenColor = UIColorFromRGB(0x64DD17)

/* risk assessment */
// MARK: ------- reset ----------
let assessBGColor = UIColorFromRGB(233, green: 233, blue: 233)

let cellDownColor = UIColorFromRGB(66, green: 147, blue: 33)
let cellUpColor = UIColorFromRGB(180, green: 236, blue: 81)
let choiceTextColor = UIColorFromRGB(104, green: 159, blue: 56)
let cellShadowColor = UIColorFromRGB(178, green: 178, blue: 178)

let selectedTextColor = UIColor.black
let unselectedTextColor = UIColorFromRGB(88, green: 88, blue: 88)

/* switch colors*/
let switchOnColor = UIColorFromRGB(126, green: 211, blue: 33)
let switchOffColor = UIColorFromRGB(208, green: 2, blue: 27)
let switchThumbColor = UIColorFromRGB(243, green: 245, blue: 243)
let switchBorderCOlor = UIColor.white

/* introduce page colors*/
let introPageBGColor = UIColorFromRGB(240, green: 241, blue: 243)
let introPageFontColor = UIColorFromRGB(130, green: 130, blue: 130)

let introPageTopColor = UIColorFromRGB(0, green: 63, blue: 12)
let introPageBottomColor = UIColorFromRGB(0, green: 149, blue: 29)

/* summary */
// total
let warnColor = UIColor.red
let cautionColor = UIColorFromRGB(255, green: 196, blue: 0)
let keepColor = UIColorFromRGB(0, green: 200, blue: 83)

let textGrayColor = UIColorGray(155)

// individual
let leftOdd = UIColorFromRGB(222, green: 247, blue: 207)
let leftEven = UIColorFromRGB(243, green: 253, blue: 237)
let rightOdd = UIColorFromRGB(247, green: 253, blue: 233)

let dashGray = UIColorGray(216)
let dashGreen = UIColorFromRGB(207, green: 246, blue: 176)


// card
let innerLineColor = UIColorFromRGB(139, green: 195, blue: 74)
let outerLineColor = UIColorFromRGB(0, green: 142, blue: 159)

