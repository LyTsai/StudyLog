//
//  CardOnlyExtension.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/28.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

// colors
/** background color of the original view, white color */
let backColor = UIColor.white

let confirmGreen = UIColorFromRGB(0x8FC07C)
let denyRed = UIColorFromRGB(0xD22208)

func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0, blue: CGFloat((rgbValue & 0xFF) >> 16) / 255.0, alpha: 1)
}

// extension
// Methods of dateConvert
func convertNSSetToArray(_ aSet: NSSet?) -> [AnyObject]? {
    if aSet == nil { return nil }
    
    var array = [AnyObject]()
    for element in aSet! { array.append(element as AnyObject) }
    return array
}

func convertDataObjectToImage(_ object: NSObject!) -> UIImage? {
    if object == nil {
        return nil
    }
    
    if object.isKind(of: UIImage.self) == true {
        return object as? UIImage
    }
    
    let data = object as? Data
    return (data != nil) ? UIImage(data: data!): nil
}

// MARK: ------------ UILabel
extension UILabel {
    func adjustFontToFit() {
        adjustsFontSizeToFitWidth = true
        baselineAdjustment = .alignCenters
        numberOfLines = 0
    }
    
    func adjustWithWidthKept() {
        let oldWidth = frame.width
        let oldHeight = frame.height
        
        sizeToFit()
        self.frame = CGRect(origin: frame.origin, size: CGSize(width: oldWidth, height: min(frame.height, oldHeight)))
    }
}

extension CGRect {
    init(center: CGPoint, length: CGFloat) {
        let originX = center.x - length * 0.5
        let originY = center.y - length * 0.5
        self.origin = CGPoint(x: originX, y: originY)
        self.size = CGSize(width: length, height: length)
    }
    
    init(center: CGPoint, width: CGFloat, height: CGFloat) {
        let originX = center.x - width * 0.5
        let originY = center.y - height * 0.5
        self.origin = CGPoint(x: originX, y: originY)
        self.size = CGSize(width: width, height: height)
    }
}

//
enum CardsViewType: String {
    case WheelOfCards
    case VerticalFlow
    case TableView
    case StackView
}
