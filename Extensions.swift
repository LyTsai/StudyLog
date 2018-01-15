//
//  Extension.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/18.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit
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
    
//    func clipToRoundWithBorder(_ color: UIColor, borderWidth: CGFloat) -> UIImage {
//        let radius = min(size.width, size.height) / 2 + borderWidth
//        let totalSize = CGSize(width: radius * 2, height: radius * 2)
//
//        UIGraphicsBeginImageContextWithOptions(totalSize, false, 0)
//        let ctx = UIGraphicsGetCurrentContext()
//
//        if ctx == nil {
//            return self
//        }
//
//        ctx!.addEllipse(in: CGRect(origin: CGPoint.zero, size: totalSize))
//        ctx!.clip()
//
//        let changedImage = UIGraphicsGetImageFromCurrentImageContext()!
//
//        return changedImage
//    }
}

// MARK: ------------ CGRect, moved to CardOnlyExtension


// MARK: ------------ CALayer
extension CALayer {
    func addBlackShadow(_ radius: CGFloat) {
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: 0, height: 1.5)
        shadowRadius = radius
        shadowOpacity = 1
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
    
    class func customNormalButton(_ text: String?) -> UIButton {
        let button = UIButton.customCenterTextButton(text, textColor: UIColor.black, selectedTextColor: UIColor.white, backImage: ProjectImages.sharedImage.lightBG, selectedBackImage: ProjectImages.sharedImage.greenBG)
        
        return button
    }
    
    func adjustNormalButton(_ frame: CGRect) {
        self.frame = frame
        
        // border： shaodow, x:2, y: 4
        let hori = 5 * frame.width / 148
        let top = 5 * frame.height / 49
        let bottom = 10 * frame.height / 49
        
        titleEdgeInsets = UIEdgeInsets(top: top, left: hori, bottom: bottom, right: hori)
        titleLabel?.font = UIFont.systemFont(ofSize: frame.height * 0.31)
    }
    
    class func customThickRectButton(_ text: String?) -> UIButton {
        let button = UIButton.customCenterTextButton(text, textColor: UIColor.black, selectedTextColor: UIColor.white, backImage: ProjectImages.sharedImage.thickRectUn, selectedBackImage: ProjectImages.sharedImage.thickRect)
        
        return button
    }
    
    func adjustThickRectButton(_ frame: CGRect) {
        self.frame = frame
        
        // border： shaodow, x:2, y: 4
        let hori = 5 * frame.width / 150
        let top = 5 * frame.height / 51
        let bottom = 10 * frame.height / 51
        
        titleEdgeInsets = UIEdgeInsets(top: top, left: hori, bottom: bottom, right: hori)
        titleLabel?.font = UIFont.systemFont(ofSize: frame.height * 0.31, weight: UIFontWeightBold)
    }
    
    // pair
    class func customGreenLineButton(_ text: String?) -> UIButton {
        let button = UIButton(type: .custom)
        button.setupAsGreenLineButton()
        button.setTitle(text, for: .normal)
    
        return button
    }
    
    func setupAsGreenLineButton()  {
        backgroundColor = UIColor.white
        setTitleColor(UIColor.black, for: .normal)
        layer.addBlackShadow(2)
        layer.borderColor = UIColorFromRGB(139, green: 195, blue: 74).cgColor
        layer.shadowOpacity = 0.3
    }
    
    func adjustGreenLineButton(_ frame: CGRect) {
        self.frame = frame
        let standP = frame.height / 40
        titleLabel?.font = UIFont.systemFont(ofSize: 16 * standP, weight: UIFontWeightBold)
        layer.borderWidth = standP * 2
        layer.cornerRadius = 3 * standP
    }
    
    func adjustGreenLine(_ standP: CGFloat) {
        titleLabel?.font = UIFont.systemFont(ofSize: 16 * standP, weight: UIFontWeightBold)
        layer.borderWidth = standP * 2
        layer.cornerRadius = 3 * standP
    }
}
