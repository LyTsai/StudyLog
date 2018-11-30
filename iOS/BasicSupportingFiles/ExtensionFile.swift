//
//  ExtensionFile.swift
//
//  Created by LyTsai on 2018/6/28.
//  Copyright © 2018年 LyTsai. All rights reserved.
//

import Foundation
// MARK: ------------- Extensions --------------
// MARK: ------------ CGRect
extension CGRect {
    init(center: CGPoint, length: CGFloat) {
        let originX = center.x - length * 0.5
        let originY = center.y - length * 0.5
        self.init()
        self.origin = CGPoint(x: originX, y: originY)
        self.size = CGSize(width: length, height: length)
    }
    
    init(center: CGPoint, size: CGSize) {
        let originX = center.x - size.width * 0.5
        let originY = center.y - size.height * 0.5
        self.init()
        self.origin = CGPoint(x: originX, y: originY)
        self.size = size
    }
    
    init(center: CGPoint, width: CGFloat, height: CGFloat) {
        let originX = center.x - width * 0.5
        let originY = center.y - height * 0.5
        self.init()
        self.origin = CGPoint(x: originX, y: originY)
        self.size = CGSize(width: width, height: height)
    }
}

// MARK: ------------ UIColor
extension UIColor {
    // green, blue, alpha为1， 2， 3
    func getRed() -> CGFloat! {
        if self.cgColor.numberOfComponents >= 3 {
            return self.cgColor.components![0]
        }else {
            return nil
        }
    }
    
    // set up color
    class func colorFromHex(_ hexValue: Int) -> UIColor {
        return UIColor(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((hexValue & 0xFF00) >> 8) / 255.0, blue: CGFloat(hexValue & 0xFF) / 255.0, alpha: 1)
    }
    
    class func colorFromRGBA(_ red: Int, green: Int, blue: Int, alpha: Int) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 100.0)
    }
    
    class func colorFromRGB(_ red: Int, green: Int, blue: Int) -> UIColor {
        return colorFromRGBA(red, green: green, blue: blue, alpha: 1)
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
    
    func addShadowWithColor(_ color: CGColor, offset: CGSize, radius: CGFloat, opacity: Float) {
        shadowColor = color
        shadowOffset = offset
        shadowRadius = radius
        shadowOpacity = opacity
    }
}

// MARK: ----------- UIView --------
extension UIView {
    var navigation: UINavigationController! {
        var nextView = self.superview
        while nextView != nil {
            if let responder = nextView!.next {
                if responder.isKind(of: UINavigationController.self) {
                    return responder as! UINavigationController
                }
                nextView = nextView!.superview
            }
        }
        
        return nil
    }
    
    var viewController: UIViewController! {
        var nextView = self.superview
        while nextView != nil {
            if let responder = nextView!.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as! UIViewController
                }
                nextView = nextView!.superview
            }
        }
        
        return nil
    }
    
    // draw rect
    func drawAspectFitImage(_ image: UIImage, inRect rect: CGRect) {
        let imageSize = image.size
        let imageW = min(rect.width, rect.height * imageSize.width / imageSize.height)
        
        image.draw(in: CGRect(center: CGPoint(x: rect.midX, y: rect.midY), width: imageW, height: imageW * imageSize.height / imageSize.width))
    }
    
    //  .center
    func drawString(_ aString: NSAttributedString, inRect rect: CGRect) {
        drawString(aString, inRect: rect, alignment: .center)
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
    
    func getFanPath(_ radius: CGFloat, innerRadius: CGFloat, vertex: CGPoint, sAngle: CGFloat, eAngle: CGFloat, clockwise: Bool) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: vertex, radius: radius, startAngle: eAngle, endAngle: sAngle, clockwise: !clockwise)
        path.addArc(withCenter: vertex, radius: innerRadius, startAngle: sAngle, endAngle: eAngle, clockwise: clockwise)
        path.close()
        
        return path
    }
    
    func addBorder(_ color: UIColor!, cornerRadius: CGFloat, borderWidth: CGFloat, masksToBounds: Bool) {
        if color != nil {
            layer.borderColor = color.cgColor
        }
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = masksToBounds
    }
}

// MARK: ------ UIBezierPath
extension UIBezierPath {
    class func getFanPath(_ radius: CGFloat, innerRadius: CGFloat, vertex: CGPoint, sAngle: CGFloat, eAngle: CGFloat, clockwise: Bool) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: vertex, radius: radius, startAngle: eAngle, endAngle: sAngle, clockwise: !clockwise)
        path.addArc(withCenter: vertex, radius: innerRadius, startAngle: sAngle, endAngle: eAngle, clockwise: clockwise)
        path.close()
        
        return path
    }
    
    class func getTopRectConnectionBetweenLeftPoint(_ leftPoint: CGPoint, rightPoint: CGPoint, radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: leftPoint)
        path.addArc(withCenter: CGPoint(x: leftPoint.x + radius, y: leftPoint.y), radius: radius, startAngle: -CGFloat(Double.pi), endAngle: -CGFloat(Double.pi * 0.5), clockwise: true)
        path.addLine(to: CGPoint(x: rightPoint.x - radius, y: leftPoint.y - radius))
        path.addArc(withCenter: CGPoint(x: rightPoint.x - radius, y: leftPoint.y), radius: radius, startAngle: -CGFloat(Double.pi) * 0.5, endAngle: 0, clockwise: true)
        
        return path
    }
    
    class func getBottomRectConnectionBetweenLeftPoint(_ leftPoint: CGPoint, rightPoint: CGPoint, radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: leftPoint)
        path.addArc(withCenter: CGPoint(x: leftPoint.x + radius, y: leftPoint.y), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * 0.5), clockwise: false)
        path.addLine(to: CGPoint(x: rightPoint.x - radius, y: leftPoint.y + radius))
        path.addArc(withCenter: CGPoint(x: rightPoint.x - radius, y: leftPoint.y), radius: radius, startAngle: CGFloat(Double.pi) * 0.5, endAngle: 0, clockwise: false)
        
        return path
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
    
    func getImageAtFrame(_ frame: CGRect) -> UIImage {
        
        let cgFrame = CGRect(x: frame.minX * 2 ,y: frame.minY * 2, width: frame.width * 2, height: frame.height * 2)
        
        return  UIImage(cgImage: self.cgImage!.cropping(to: cgFrame)!)
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
    func createNavigationBackButton(_ backImage: UIImage) -> UIBarButtonItem {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 44)
        
        backButton.setImage(backImage, for: .normal)
        return UIBarButtonItem(customView: backButton)
    }
}
