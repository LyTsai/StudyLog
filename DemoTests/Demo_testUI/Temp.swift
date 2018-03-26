//
//  Temp.swift
//  Demo_testUI
//
//  Created by iMac on 2018/3/26.
//  Copyright © 2018年 LyTsai. All rights reserved.
//

import Foundation
var fontFactor: CGFloat {
    return min(standWP, standHP)
}


class ProjectImages {
    static let sharedImage = ProjectImages()
    
    // place holder
    let placeHolder = UIImage(named: "cache")
    let indicator = UIImage(named: "cache-image")
}

func UIColorFromRGBA(_ red: Int, green: Int, blue: Int, alpha: Int) -> UIColor {
    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/100.0)
}

func UIColorFromRGB(_ red: Int, green: Int, blue: Int) -> UIColor {
    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
}

func UIColorGray(_ one: Int) -> UIColor {
    return UIColorFromRGB(one, green: one, blue: one)
}
