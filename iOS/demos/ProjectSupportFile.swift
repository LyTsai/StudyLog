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
var topLength: CGFloat {
    // iPhoneX - 44 + 44
    // others  - 20 + 44
    return UIApplication.shared.statusBarFrame.size.height + 44
}

// tabBar
var bottomLength: CGFloat {
    // TODO: ---------- not a best solution
    if UIScreen.main.bounds.height == 812 {
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

// standard point
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

// MARK: ------------- Extensions --------------
// MARK: ------------ CGRect
extension CGRect {
    init(center: CGPoint, length: CGFloat) {
        let originX = center.x - length * 0.5
        let originY = center.y - length * 0.5
        self.origin = CGPoint(x: originX, y: originY)
        self.size = CGSize(width: length, height: length)
    }
    
    init(center: CGPoint, size: CGSize) {
        let originX = center.x - size.width * 0.5
        let originY = center.y - size.height * 0.5
        self.origin = CGPoint(x: originX, y: originY)
        self.size = size
    }
    
    init(center: CGPoint, width: CGFloat, height: CGFloat) {
        let originX = center.x - width * 0.5
        let originY = center.y - height * 0.5
        self.origin = CGPoint(x: originX, y: originY)
        self.size = CGSize(width: width, height: height)
    }
}

// MARK: ------------ UIColor
extension UIColor {
    // green, blue, alpha为1， 2， 3
    class func getRedFromColor(_ color: UIColor) -> CGFloat! {
        if color.cgColor.numberOfComponents >= 3 {
            return color.cgColor.components![0]
        }else {
            return nil
        }
    }
    
    // set up color
    class func colorFromHexRGB(_ rgbValue: Int) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0, blue: CGFloat((rgbValue & 0xFF) >> 16) / 255.0, alpha: 1)
    }
    
    class func colorFromRGBA(_ red: Int, green: Int, blue: Int, alpha: Int) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/100.0)
    }
    
    class func colorFromRGB(_ red: Int, green: Int, blue: Int) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
    class func grayColorFrom(_ one: Int) -> UIColor {
        return colorFromRGB(one, green: one, blue: one)
    }
}

// MARK: ------------ CALayer
extension CALayer {
    func addBlackShadow(_ radius: CGFloat) {
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize.zero
        shadowRadius = radius
        shadowOpacity = 1
    }
}

// MARK: ----------- UIView --------
extension UIView {
    func drawString(_ aString: NSAttributedString, inRect rect: CGRect) {
        let sSize = aString.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil)
        let cRect = CGRect(center: CGPoint(x: rect.midX, y: rect.midY), width: sSize.width, height: sSize.height)
        aString.draw(in: cRect)
    }
    
    func drawString(_ aString: NSAttributedString, inRect rect: CGRect, alignment: NSTextAlignment) {
        let sSize = aString.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil)
        var cRect = rect
        
        // NATextAlignment
        switch alignment {
        case .center: cRect = CGRect(center: CGPoint(x: rect.midX, y: rect.midY), width: sSize.width, height: sSize.height)
        case .left: cRect = CGRect(x: rect.minX, y: rect.midY - sSize.height * 0.5, width: sSize.width, height: sSize.height)
        case .right: cRect = CGRect(x: rect.maxX - sSize.width, y: rect.midY - sSize.height * 0.5, width: sSize.width, height: sSize.height)
        default: break
        }
        
        aString.draw(in: cRect)
    }
}

// MARK: --------- UIImage
extension UIImage {
    func changeImageSizeTo(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        let changedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return changedImage!
    }
    
    
    func changeImageSizeTo(_ size: CGSize, alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .normal, alpha: alpha)
        let changedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return changedImage!
    }
    
    
    // MARK: if the color's alpha is 0, it will turn to black
    func convertImageToGrayScale() -> UIImage {
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        context?.draw(self.cgImage!, in: imageRect)
        let imageRef = context?.makeImage()
        let grayImage = UIImage(cgImage: imageRef!)
        
        return grayImage
    }
    
    // change the color of the image
    func imageWithColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        context?.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func clipRoundImageWithBorderColor(_ color: UIColor, borderWidth: CGFloat) -> UIImage {
        let radius = min(size.width, size.height) / 2 + borderWidth
        let totalSize = CGSize(width: radius * 2, height: radius * 2)

        UIGraphicsBeginImageContextWithOptions(totalSize, false, 0)
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.addEllipse(in: CGRect(origin: CGPoint.zero, size: totalSize)) // an oval path
        ctx!.clip()

        let changedImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        return changedImage
    }
}


// MARK: ------------ UILabel
extension UILabel {
    // fixed size, variable font
    func adjustFontToFit() {
        adjustsFontSizeToFitWidth = true
        baselineAdjustment = .alignCenters
        numberOfLines = 0
    }
    
    // fixed font, variable size
    func adjustWithWidthKept(){
        let oldWidth = frame.width
        sizeToFit()
        self.frame = CGRect(origin: frame.origin, size: CGSize(width: oldWidth, height: frame.height))
    }
    
    func adjustWithHeightKept() {
        let oldHeight = frame.height
        sizeToFit()
        self.frame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: oldHeight))
    }
    
}

// MARK: ------------ UIButton
extension UIButton {
    class func customCenterTextButton(_ text: String?, textColor: UIColor?, selectedTextColor: UIColor?, backImage: UIImage?, selectedBackImage: UIImage?) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
//        button.setTitle(text, for: .selected)
        button.setTitleColor(selectedTextColor, for: .selected)
        button.setBackgroundImage(backImage, for: .normal)
        button.setBackgroundImage(selectedBackImage ?? backImage, for: .selected)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        
        return button
    }
}

// MARK: ----------- UIViewController
extension UIViewController {
    // mainFrame
    var mainFrame: CGRect {
        return CGRect(x: 0, y: topLength, width: width, height: height - topLength - bottomLength)
    }
    
    // custom back barbutton
    func createBackButton() -> UIButton {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 44)
        
        backButton.setImage(UIImage(named: "barButton_back"), for: .normal)
        return backButton
    }
}
