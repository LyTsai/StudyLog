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
    /** the width of the viewController */
    var width: CGFloat {
        return view.bounds.width
    }
    /** the height of the viewController */
    var height: CGFloat {
        return view.bounds.height
    }
    
    func getFramesOfViewStack(_ number: Int, isHorizontal: Bool, edgeInsets: UIEdgeInsets, gap: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        let totalWidth = width - edgeInsets.left - edgeInsets.right
        let totalHeight = height - edgeInsets.top - edgeInsets.bottom
    
        if isHorizontal == true {
            let subWidth = (totalWidth - gap * CGFloat(number - 1)) / CGFloat(number)
            for i in 0..<number {
                let frame = CGRect(x: edgeInsets.left + CGFloat(i) * (subWidth + gap), y: edgeInsets.top, width: subWidth, height: totalHeight)
                frames.append(frame)
            }
        } else {
            let subHeight = (totalHeight - gap * CGFloat(number - 1)) / CGFloat(number)
            for i in 0..<number {
                let frame = CGRect(x: edgeInsets.left, y: edgeInsets.top + CGFloat(i) * (subHeight + gap), width: totalWidth, height: subHeight)
                frames.append(frame)
            }
        }
        
        return frames
    }
}

// MARK: ----------- UIView, can be also used for the subclasses
extension UIView {
    // extension for roundRect
    func roundRectView(_ cornerRadius: CGFloat, borderWidth: CGFloat, strokeColor: UIColor, fillColor: UIColor) {
        self.backgroundColor = fillColor
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = strokeColor.cgColor
    }
    
    // clip view with beizer path
    func clipViewWithPath(_ path: UIBezierPath, borderWidth: CGFloat, borderColor: UIColor) {
        layer.masksToBounds = true
        
        // clip, add mask
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.fillColor = UIColor.red.cgColor
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        
        // add border
        let borderLayer = CAShapeLayer()
        borderLayer.frame = bounds
        borderLayer.lineWidth = borderWidth // can be 0 for no border, if out of the range of mask, part will not show
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.path = path.cgPath
        
        layer.addSublayer(borderLayer)
    }
    
    // clip round view
    func clipRoundViewWithCenter(centerInView center: CGPoint, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        let roundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        clipViewWithPath(roundPath, borderWidth: borderWidth, borderColor: borderColor)
    }
    
    
    // add shadow for the view, get the shape layer and add it to your superView
    func createShadowLayerWithPath(_ path: UIBezierPath, shadowOffset: CGSize, shadowColor: UIColor, shadowOpacity: Float, shadowRadius: CGFloat) -> CALayer {
        let shadowLayer = CALayer()
        
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.masksToBounds = false
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowRadius
        
        return shadowLayer
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
    
    func clipToRoundWithBorder(_ color: UIColor, borderWidth: CGFloat) -> UIImage {
        let radius = min(size.width, size.height) / 2 + borderWidth
        let totalSize = CGSize(width: radius * 2, height: radius * 2)
        
        UIGraphicsBeginImageContextWithOptions(totalSize, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        
        if ctx == nil {
            return self
        }
        
        ctx!.addEllipse(in: CGRect(origin: CGPoint.zero, size: totalSize))
        ctx!.clip()
        
        let changedImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        return changedImage
    }
}

// MARK: ------------ UIColor
extension UIColor {
    class func randomColor() -> UIColor {
        let red = CGFloat(arc4random() % 255) / 255
        let green = CGFloat(arc4random() % 255) / 255
        let blue = CGFloat(arc4random() % 255) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

// MARK: ------------ CGRect, moved to CardOnlyExtension


// MARK: ------------ CALayer
extension CALayer {
    func addBlackShadow(_ radius: CGFloat) {
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: 0, height: 1)
        shadowRadius = radius
        shadowOpacity = 0.95
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
//        let button = UIButton.customCenterTextButton(text, textColor: cellDownColor, selectedTextColor: UIColor.white, backImage: UIImage(named: "button_lightBG"), selectedBackImage: UIImage(named: "button_greenBG"))
        let button = UIButton.customCenterTextButton(text, textColor: UIColor.black, selectedTextColor: UIColor.white, backImage: ProjectImages.sharedImage.lightBG, selectedBackImage: ProjectImages.sharedImage.greenBG)
        
        return button
    }
    
    func adjustNormalButton(_ frame: CGRect) {
        self.frame = frame
        
        // border： shaodow, x:2, y: 4
        let hori = 7 * frame.width / 134
        let top = 4 * frame.height / 48
        let bottom = 10 * frame.height / 48
        
        titleEdgeInsets = UIEdgeInsets(top: top, left: hori, bottom: bottom, right: hori)
        titleLabel?.font = UIFont.systemFont(ofSize: frame.height * 0.29)
    }
}
