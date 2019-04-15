//
//  VisualMapNode.swift
//  AnnielyticX
//
//  Created by iMac on 2018/3/23.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

enum NodeShape {
    case none
    case round
    case rect
    case hex
    case oct
}

// visual nodd
class VisualMapNode: UIView {
    var individual = true
    
    // data
    var key: String!
    var borderShape = NodeShape.round
    var text: String!
    var imageUrl: URL! {
        didSet{
            if imageUrl != oldValue && imageUrl != nil {
                let imageView = UIImageView()
                imageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, progress: nil) { (loaded, error, type, url) in
                    if loaded == nil {
                        do {
                            imageView.image = UIImage(data: try Data(contentsOf: self.imageUrl))
                            self.image = imageView.image
                        }catch {
                            print("error: \(error.localizedDescription)")
                        }
                    }else {
                        self.image = loaded
                    }
                }
                
                self.image = imageView.image
            }
        }
    }
    
    // UI
    var showText = false
    var showImage = true
    var textAtTop = false // or down
    var textRatio: CGFloat = 0.4
    var disabled = false
    var mainColor = UIColorFromRGB(126, green: 211, blue: 33)
    var fillColor = UIColor.white
    
    // default or set
    var useDefault = true
    var font: UIFont!
    var attributedString: NSAttributedString!
    var lineWidth: CGFloat = 4
    
    override var frame: CGRect {
        didSet{
            if frame != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    // display
    fileprivate var strokeColor: UIColor! {
        return disabled ? UIColorGray(200) : mainColor
    }
    fileprivate var image = ProjectImages.sharedImage.placeHolder {
        didSet{
            if image != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // method
    fileprivate func getBorderPath() -> UIBezierPath {
        let rect = bounds.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        
        switch borderShape {
        case .round: return getRoundPathForRect(rect)
        case .hex: return getHexPathForRect(rect)
        case .oct: return getOctPathForRect(rect)
        case .none, .rect: return getRectangularPathForRect(rect)
        }
    }
    
    fileprivate func getInnerRect() -> CGRect {
        let viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.midX, bounds.midY) - lineWidth
        
        switch borderShape {
        case .round, .oct: return CGRect(center: viewCenter, length: radius / sqrt(2) * 2)
        case .hex: return CGRect(center: viewCenter, length: radius * sqrt(3) / sqrt(2))
//        case .oct: return CGRect(center: viewCenter, length: radius * 2 / sqrt(2))
        case .none, .rect: return bounds.insetBy(dx: lineWidth, dy: lineWidth)
        }
    }

    
    // drawRect
    func addForDraw() {
        // prepare
        if useDefault {
            lineWidth = min(bounds.midX, bounds.midY) * 0.1
            font = UIFont.systemFont(ofSize: max(bounds.height * 0.1, 5 * fontFactor))
        }
        
        // draw
        // boarder
        let borderPath = getBorderPath()
        borderPath.lineWidth = lineWidth
        fillColor.setFill()
        strokeColor.setStroke()
        borderPath.fill()
        borderPath.stroke()
        
        // remained rect
        let innerRect = getInnerRect()
        var imageRect = innerRect
        var textRect = innerRect
        
        // text
        if text != nil && showText {
            let textStyle = NSMutableParagraphStyle()
            textStyle.lineBreakMode = .byWordWrapping
            textStyle.alignment = .center
            attributedString = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: textStyle])
            if showImage {
                // use ratio and position
                if textAtTop {
                    textRect = CGRect(x: innerRect.minX, y: innerRect.minY, width: innerRect.width, height: innerRect.height * textRatio)
                    
                    imageRect = CGRect(x: innerRect.minX, y: textRect.maxY, width: innerRect.width, height: innerRect.height * (1 - textRatio))
                }else {
                    imageRect = CGRect(x: innerRect.minX, y: innerRect.minY, width: innerRect.width, height: innerRect.height * (1 - textRatio))
                    textRect = CGRect(x: innerRect.minX, y: imageRect.maxY, width: innerRect.width, height: innerRect.height * textRatio)
                }
            }
            
            imageRect = CGRect(center: CGPoint(x: imageRect.midX, y: imageRect.midY), length: imageRect.height)
            
            drawString(attributedString, inRect: textRect, alignment: .center)
        }
        
        // image
        if image != nil && showImage {
            // disabled, alpha??
            image!.draw(in:imageRect)
        }
    }
    
    override func draw(_ rect: CGRect) {
        if individual {
            addForDraw()
        }else {
            // draw on another view
        }
    }
}

// paths
extension VisualMapNode {
    // round path
    func getRoundPathForRect(_ rect: CGRect) -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: min(rect.width, rect.height) * 0.5, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
    }
    
    // rect path
    func getRectangularPathForRect(_ rect: CGRect) -> UIBezierPath {
        return UIBezierPath(rect: rect)
    }
    
    // hex path
    func getHexPathForRect(_ rect: CGRect) -> UIBezierPath {
        if rect.width != rect.height {
            // TODO:---------- adjust size
            print("adjust")
        }
        
        let hex = UIBezierPath()
        
        hex.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        for i in 1...5 {
            let angle = CGFloat(i) * CGFloat(Double.pi / 3)
            hex.addLine(to: Calculation().getPositionByAngle(angle, radius: rect.width * 0.5, origin: CGPoint(x: rect.midX, y: rect.midY)))
        }
        
        hex.close()
        
        return hex
    }
    
    // oct
    func getOctPathForRect(_ rect: CGRect) -> UIBezierPath {
        if rect.width != rect.height {
            // TODO:---------- adjust size
            print("adjust")
        }
        
        let oct = UIBezierPath()
        
        oct.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        for i in 1...7 {
            let angle = CGFloat(i) * CGFloat(Double.pi / 4)
            oct.addLine(to: Calculation().getPositionByAngle(angle, radius: rect.width * 0.5, origin: CGPoint(x: rect.midX, y: rect.midY)))
        }
        
        oct.close()
        
        return oct
    }
}


