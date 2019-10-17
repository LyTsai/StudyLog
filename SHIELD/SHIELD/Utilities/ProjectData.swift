//
//  ProjectData.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

/* init set */
var RISKPLAYHINT = false
var TREERINGMAPHINT = false
var CARDPLAYHINT = false

var homePageFirstLaunch = true
var USERECORD = false
var WHATIF = false
var HASINSETS = false

/* user defaults keys */
let allowVoiceKey = "AllowVoiceKey"
let loadedBeforeKey = "loaded before"
let TABBARID = "TabbarController"
let rememberAccountKey = "Remember user credentials"
let userAccountNameKey = "User Account Name"
let splashNeverShowKey = "splash never show"

// MARK: --------- adaption
var ISPHONE: Bool {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
}

// statusBar + navigaitonBar
var topLength: CGFloat {
    // >= iPhoneX - 88
    // others -  20 + 44
    return UIApplication.shared.statusBarFrame.size.height + 44
}

// tabBar
var bottomLength: CGFloat {
    if HASINSETS {
        return 34 + 49
    }
    return 49
}


/** the width of the viewController */
var width: CGFloat {
    return UIScreen.main.bounds.width
}
/** the height of the viewController */
var height: CGFloat {
    return UIScreen.main.bounds.height
}

// standard one point, according to the design
// 375 * 667
var standWP: CGFloat {
    if width > height {
        return width / 667
    }else {
        return width / 375
    }
}

var standHP: CGFloat {
    if width > height {
        return height / 375
    }else {
        return height / 667
    }
}

// the smaller one
var fontFactor: CGFloat {
    return min(standWP, standHP)
}

// the larger one
var maxOneP: CGFloat {
    return max(standWP, standHP)
}

// mainFrame
var mainFrame: CGRect {
    return CGRect(x: 0, y: topLength, width: width, height: height - topLength - bottomLength)
}

// alertFrame
var alertFrame: CGRect {
    let top = UIApplication.shared.statusBarFrame.height
    return CGRect(x: 0, y: top, width: width, height: height - top - bottomLength + 49)
}
