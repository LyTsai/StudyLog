//
//  ProjectSupportFile.swift
//  Created by LyTsai on 16/9/18.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

/** path for a file */
let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/fileName.data")

/** user defaults keys */
/** user defaults - account name */
let ACCOUNT = "AccountName"

// MARK: ---------- Adaptation
// statusBar + navigaitonBar
// iPhoneX - 44 + 44
// others  - 20 + 44
let topLength = UIApplication.shared.statusBarFrame.size.height + 44

// tabBar
var bottomLength: CGFloat {
    if ISPHONE, #available(iOS 11, *) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.window!.safeAreaInsets.bottom > CGFloat(0.0) {
            return 34 + 49
        }
    }
    
    return 49
}

/** the width of the viewController */
let width = UIScreen.main.bounds.width

/** the height of the viewController */
let height = UIScreen.main.bounds.height

// standard point, for design of 375 * 667
var standWP: CGFloat {
    return width / 375
}

var standHP: CGFloat {
    return height / 667
}

/** can use as font factor*/
var minOneP: CGFloat {
    return min(standWP, standHP)
}

var maxOneP: CGFloat {
    return max(standWP, standHP)
}

// device
let currentLanguage = Locale.preferredLanguages.first // ex: Optional("en")
let isPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) // let deviceModel = UIDevice.current.model
let isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)

let deviceVersion = UIDevice.current.systemVersion // String, ex: 11.1

// singletion
let notificationCenter = NotificationCenter.default


// MARK: --------- only objects for subclasses of NSObject
// runTime
// all
//func getIvarNames(_ model: AnyObject) -> [String] {
//    var propertyCount: UInt32 = 0
//    var names = [String]()
//    if let properties = class_copyIvarList(model.classForCoder, &propertyCount) {
//        for i in 0..<Int(propertyCount) {
//            if let property = properties[i] {
//                if let nameString = String(validatingUTF8: ivar_getName(property)) {
//                    names.append(nameString)
//                }
//            }
//        }
//    }
//
//    return names
//}

// int is not included
//func getPropertyNames(_ model: AnyObject) -> [String] {
//    var propertyCount: UInt32 = 0
//    var names = [String]()
//    if let properties = class_copyPropertyList(model.classForCoder, &propertyCount) {
//        for i in 0..<Int(propertyCount) {
//            if let property = properties[i] {
//                if let nameString = String(validatingUTF8: property_getName(property)) {
//                    names.append(nameString)
//                }
//            }
//        }
//    }
//    
//    return names
//}

//func getTypeOfProperty(_ name: String, model: AnyObject) {
//    var propertyCount: UInt32 = 0
//    if let properties = class_copyPropertyList(model.classForCoder, &propertyCount) {
//        for i in 0..<Int(propertyCount) {
//            if let property = properties[i] {
//                if let nameString = String(validatingUTF8: property_getName(property)) {
//                    if nameString == name {
//                        let attrString = String(validatingUTF8: property_getAttributes(property))
//                        // string compare
//
//                    }
//                }
//            }
//        }
//    }
//}
