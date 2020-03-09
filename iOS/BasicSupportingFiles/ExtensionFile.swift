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
    
    func getAspectFitSize(_ expectedRatio: CGFloat) -> CGSize {
        let ratio = width / height
        if ratio > expectedRatio {
            return CGSize(width: height * expectedRatio, height: height)
        }else {
            return CGSize(width: width, height: width / expectedRatio)
        }
    }
    
    // points
    var bottomLeftPoint: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }
    var bottomRightPoint: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }
    var topRightPoint: CGPoint {
        return CGPoint(x: maxX, y: minY)
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
    weak var navigation: UINavigationController! {
        return viewController.navigationController
    }
    
    weak var viewController: UIViewController! {
        var nextView = self.superview
        while nextView != nil {
            if let responder = nextView!.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
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
    
    func addBorder(_ color: UIColor!, cornerRadius: CGFloat, borderWidth: CGFloat, masksToBounds: Bool) {
        if color != nil {
            layer.borderColor = color.cgColor
        }
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = masksToBounds
    }
    
    //  convert
    
    // if Data is needed, use image.pngData() to convert
    func createImageCopy() -> UIImage? {
        let viewFrame = self.frame
        
        // for a scroll view
        if let scrollView = self as? UIScrollView {
            scrollView.contentOffset = CGPoint.zero
            scrollView.frame.size = scrollView.contentSize
        }
        
        UIGraphicsBeginImageContext(self.bounds.size)
        
        var image: UIImage?
        if let context = UIGraphicsGetCurrentContext() {
            // it will call the viewDidLayoutSubviews of the view's view controller.....
            self.layer.render(in: context)
        
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        // assign back
        self.frame = viewFrame
        
        return image
        
    }
    
    func createPDFFile(_ fileName: String) {
        let viewFrame = self.frame
         
        // for a scroll view
        if let scrollView = self as? UIScrollView {
            self.frame.size = scrollView.contentSize
        }
        
        let pdf = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdf, self.bounds, nil)
        UIGraphicsBeginPDFPage()
        
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
        }
        UIGraphicsEndPDFContext()

        // assign back
        self.frame = viewFrame
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/\(fileName)")
        pdf.write(toFile: documentPath, atomically: true)
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
    // bubbles
    class func getDownArrowBubblePathWithMainFrame(_ rect: CGRect, arrowPoint: CGPoint, radius: CGFloat) -> UIBezierPath {
        let innerRect = rect.insetBy(dx: radius, dy: radius)
        let arrowL = (arrowPoint.y - rect.maxY) * 0.6
        
        // path
        let bubblePath = UIBezierPath(arcCenter: innerRect.origin, radius: radius, startAngle: -CGFloatPi * 0.5, endAngle: CGFloatPi, clockwise: false)
        bubblePath.addLine(to: CGPoint(x: rect.minX, y: innerRect.maxY))
        bubblePath.addArc(withCenter: innerRect.bottomLeftPoint, radius: radius, startAngle: CGFloatPi, endAngle: CGFloatPi * 0.5, clockwise: false)
        bubblePath.addLine(to: CGPoint(x: arrowPoint.x - arrowL, y: rect.maxY))
        bubblePath.addLine(to: arrowPoint)
        bubblePath.addLine(to: CGPoint(x: arrowPoint.x + arrowL, y: rect.maxY))
        bubblePath.addLine(to: CGPoint(x: innerRect.maxX, y: rect.maxY))
        bubblePath.addArc(withCenter: innerRect.bottomRightPoint, radius: radius, startAngle: CGFloatPi * 0.5, endAngle: 0, clockwise: false)
        bubblePath.addLine(to: CGPoint(x: rect.maxX, y: innerRect.minY))
        bubblePath.addArc(withCenter: innerRect.topRightPoint, radius: radius, startAngle: 0, endAngle: -CGFloatPi * 0.5, clockwise: false)
        bubblePath.close()
        
        return bubblePath
    }
    
    class func getLeftArrowBubblePathWithMainFrame(_ rect: CGRect, arrowPoint: CGPoint, radius: CGFloat) -> UIBezierPath {
        let innerRect = rect.insetBy(dx: radius, dy: radius)
        let arrowL = (rect.minX - arrowPoint.x) * 0.6
        
        // path
        let bubblePath = UIBezierPath(arcCenter: innerRect.origin, radius: radius, startAngle: -CGFloatPi * 0.5, endAngle: CGFloatPi, clockwise: false)
        bubblePath.addLine(to: CGPoint(x: rect.minX, y: arrowPoint.y - arrowL))
        bubblePath.addLine(to: arrowPoint)
        bubblePath.addLine(to: CGPoint(x: rect.minX, y: arrowPoint.y + arrowL))
        bubblePath.addLine(to: CGPoint(x: rect.minX, y: innerRect.maxY))
        bubblePath.addArc(withCenter: innerRect.bottomLeftPoint, radius: radius, startAngle: CGFloatPi, endAngle: CGFloatPi * 0.5, clockwise: false)
        bubblePath.addLine(to: CGPoint(x: innerRect.maxX, y: rect.maxY))
        bubblePath.addArc(withCenter: innerRect.bottomRightPoint, radius: radius, startAngle: CGFloatPi * 0.5, endAngle: 0, clockwise: false)
        bubblePath.addLine(to: CGPoint(x: rect.maxX, y: innerRect.minY))
        bubblePath.addArc(withCenter: innerRect.topRightPoint, radius: radius, startAngle: 0, endAngle: -CGFloatPi * 0.5, clockwise: false)
        bubblePath.close()
        
        return bubblePath
    }
    
    class func getRightArrowBubblePathWithMainFrame(_ rect: CGRect, arrowPoint: CGPoint, radius: CGFloat) -> UIBezierPath {
        let innerRect = rect.insetBy(dx: radius, dy: radius)
        let arrowL = (arrowPoint.x - rect.maxX) * 0.6
        
        // path
        let bubblePath = UIBezierPath(arcCenter: innerRect.origin, radius: radius, startAngle: -CGFloatPi * 0.5, endAngle: CGFloatPi, clockwise: false)
        bubblePath.addLine(to: CGPoint(x: rect.minX, y: innerRect.maxY))
        bubblePath.addArc(withCenter: innerRect.bottomLeftPoint, radius: radius, startAngle: CGFloatPi, endAngle: CGFloatPi * 0.5, clockwise: false)
        bubblePath.addLine(to: CGPoint(x: innerRect.maxX, y: rect.maxY))
        bubblePath.addArc(withCenter: innerRect.bottomRightPoint, radius: radius, startAngle: CGFloatPi * 0.5, endAngle: 0, clockwise: false)
        
        bubblePath.addLine(to: CGPoint(x: rect.maxX, y: arrowPoint.y - arrowL))
        bubblePath.addLine(to: arrowPoint)
        bubblePath.addLine(to: CGPoint(x: rect.maxX, y: arrowPoint.y + arrowL))
        bubblePath.addLine(to: CGPoint(x: rect.maxX, y: innerRect.minY))
        
        bubblePath.addArc(withCenter: innerRect.topRightPoint, radius: radius, startAngle: 0, endAngle: -CGFloatPi * 0.5, clockwise: false)
        bubblePath.close()
        
        
        return bubblePath
    }
    
    class func pathWithAttributedString(_ attributedString: NSAttributedString, maxWidth: CGFloat) -> UIBezierPath {
        /*
         如果不做任何位移，是一堆叠在一起的y轴翻转了的字符

        \n不起折行的作用


        textLayer.isGeometryFlipped = true
        竖直翻转，文字会在最下面开始排列

        如果考虑到不止一排的情况，需要计算当前字符所在的行数目然后上移（翻转后就是看起来下移了
        ）
         */
        let letters = CGMutablePath()

        // CTLine
        let line = CTLineCreateWithAttributedString(attributedString as CFAttributedString)
        // CFArray
        let runArray = CTLineGetGlyphRuns(line)
        for runIndex in 0..<CFArrayGetCount(runArray) {
            let run = CFArrayGetValueAtIndex(runArray, runIndex)
            let runBit = unsafeBitCast(run, to: CTRun.self)
            let CTFontName = unsafeBitCast(kCTFontAttributeName, to: UnsafeRawPointer.self)
            
            let runFontC = CFDictionaryGetValue(CTRunGetAttributes(runBit),CTFontName)
            let runFontS = unsafeBitCast(runFontC, to: CTFont.self)

            for i in 0..<CTRunGetGlyphCount(runBit) {
                let range = CFRangeMake(i, 1)
                let glyph = UnsafeMutablePointer<CGGlyph>.allocate(capacity: 1)
                glyph.initialize(to: 0)
                let position = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
                position.initialize(to: .zero)
                CTRunGetGlyphs(runBit, range, glyph)
                CTRunGetPositions(runBit, range, position);
                
                if let path = CTFontCreatePathForGlyph(runFontS,glyph.pointee,nil) {
                    let transform = CGAffineTransform(translationX: position.pointee.x, y: position.pointee.y)
                    letters.addPath(path, transform: transform)
                }
                glyph.deinitialize(count: 1)
                glyph.deallocate()
                
                position.deinitialize(count: 1)
                position.deallocate()
            }
        }
        
        let path = UIBezierPath(cgPath: letters)
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
    
    // add the color of the image
    func addMaskWithColor(_ color: UIColor) -> UIImage {
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
    
    func imageFromColor(_ color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
       
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
       
        UIGraphicsEndImageContext()

        return image
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
    
    // part of the image
    func getImageAtFrame(_ frame: CGRect) -> UIImage? {
        if let cropped = self.cgImage?.cropping(to: frame) {
            return UIImage(cgImage: cropped)
        }
        return  nil
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
    
    weak var overCurrentPresentController: UIViewController? {
        if (navigationController != nil) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let rootViewController = appDelegate.window?.rootViewController
            return rootViewController
        }else {
            return self
        }
    }
    
    // present a viewController, if there is a tabbar     
    func presentOverCurrentViewController(_ viewController: UIViewController, completion: (()->Void)?)  {
        viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        viewController.modalPresentationStyle = .overCurrentContext
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootViewController = appDelegate.window?.rootViewController
        rootViewController?.present(viewController, animated: true, completion: completion)
    }
    
    func showAlertMessage(_ message : String?, title : String?, buttons: [(name: String, handle: (()->Void)?)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         
        // buttons
        for button in buttons {
            let action = UIAlertAction(title: button.name, style: .default, handler: { (action) in
                button.handle?()
            })
            alert.addAction(action)
        }
    
        present(alert, animated: true, completion: nil)
    }
}

// MARK: ------ UIResponder
private weak var currentFirstResponder: AnyObject?
extension UIResponder {
    static func firstResponder() -> AnyObject? {
        currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return currentFirstResponder
    }
    
    @objc func findFirstResponder(_ sender: AnyObject) {
        currentFirstResponder = self
    }
}


// MARK: --------- table View
extension UITableView {
    func setToFullDisplay() {
        self.layoutIfNeeded()
        self.frame.size = self.contentSize
    }
}

// MARK: --------- textView
extension UITextView {
    func placeTextMiddle(_ left: CGFloat, right: CGFloat) {
        textContainerInset = UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
        let textH = layoutManager.usedRect(for: textContainer).height
        if textH < bounds.height {
            let offsetH = (bounds.height - textH) * 0.5
            textContainerInset = UIEdgeInsets(top: offsetH, left: left, bottom: offsetH, right: right)
        }
        
        contentOffset = CGPoint.zero
    }
}

// MARK: -------- String
extension String {
    func getStartIndexesOf(_ subString: String) -> [Int] {
        var subStartIndex = startIndex
        var indexes = [Int]()
        while let range = range(of: subString, options: .caseInsensitive, range: subStartIndex..<endIndex, locale: nil) {
            indexes.append(range.lowerBound.utf16Offset(in: self))
            subStartIndex = range.upperBound
        }
        
        return indexes
    }
    
    func isEmailAddress() -> Bool {
        let emailRegex = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        
        return emailTest.evaluate(with: self)
    }
    
    // 10 numbers, US phone number
    func isPhoneNumber() -> Bool {
        let phoneRegex = "^\\d{10}?$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@",phoneRegex)
        
        return phoneTest.evaluate(with: self)
    }
    
    func isDecimal(_ maxNumber: Int) -> Bool {
        let decimalRegex = "^[0-9]+(\\.[0-9]{1,\(maxNumber)})?$"
        let decimalTest = NSPredicate(format: "SELF MATCHES %@", decimalRegex)
        return decimalTest.evaluate(with: self)
    }
}

// MARK: ---------- number
extension Float {
    // 0 of float will disappear
    func getStringValue() -> String {
        let number = NSNumber(value: self)
        return String(format: "%@", number)
    }
    
    // 000, 000, 000
    func getCurrentValue() -> String {
        let number = NSNumber(value: self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: number) ?? "0"
    }
    
    // for example: 233,233.23
    func getTwoFractionDigitsCurrentValue() -> String {
        let number = NSNumber(value: self)
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.alwaysShowsDecimalSeparator = true
        
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter.string(from: number) ?? "0"
    }
}

