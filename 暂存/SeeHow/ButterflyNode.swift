//
//  ButterflyNode.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/9.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation
import SDWebImage

enum BorderShape {
    case none       // no border
    case circle     // normal

    case triangle   // iKa
    case diamond    // iRa
    case square     // iSa
    case pentagon   // iIa
    case hex        // iAa
}

enum DecoPosition {
    case center
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

class SimpleNode: UIView {
    var isDisabled = false {
        didSet{
            circleColor = isDisabled ? UIColorGray(200) : UIColorFromRGB(126, green: 211, blue: 33)
        }
    }
    
    // extension data
    var key: String!
    var borderShape = BorderShape.circle
    var lineWidth: CGFloat = 1
    var hasCircle = true
    var borderColor = UIColor.black
    var circleColor = UIColorFromRGB(126, green: 211, blue: 33)
    
    var image: UIImage!
    
    var text: String!
    var boldFont = false
    var font: UIFont!
    
    var attributedString: NSAttributedString!
    var textAngle = CGFloat(Double.pi) / 8 // radian
    
    var decoView: UIView!
    var decoPosition = DecoPosition.center
    
    var tagged = false {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override var frame: CGRect {
        didSet{
            backgroundColor = UIColor.clear
            setNeedsDisplay()
            
            if decoView != nil {
                decoView.center = center
            }
        }
    }
    
    var imageUrl: URL! {
        didSet{
            image = ProjectImages.sharedImage.placeHolder
            let imageView = UIImageView()
            imageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, progress: nil) { (image, error, type, url) in
                self.image = imageView.image
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        // rect
        let viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.midX, bounds.midY)
        
        // set some for reload
        lineWidth = 2 * fontFactor
      
        // draw outer
        let path = UIBezierPath()
            
        // shape
        var length = radius * 2 - lineWidth * 2
        switch borderShape {
        case .none: break
        case .circle: path.addArc(withCenter: viewCenter, radius: radius - lineWidth * 0.5, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
            length = length / sqrt(2)
        case .triangle:
            path.move(to: CGPoint(x: bounds.midX, y: 0))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            path.close()
        case .diamond:
            path.move(to: CGPoint(x: bounds.midX, y: 0))
            path.addLine(to: CGPoint(x: 0, y: bounds.midY))
            path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
            path.close()
        case .square: path.append(UIBezierPath(rect: bounds.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)))
        case .pentagon: path.append(UIBezierPath(rect: bounds))
            
        case .hex: path.append(UIBezierPath(rect: bounds))
        }
            
        path.lineWidth = lineWidth
        circleColor.setStroke()
        UIColor.white.setFill()
        path.stroke()
        path.fill()
       
        // draw image
        if image != nil {
            image.draw(in: CGRect(center: viewCenter, length: length))
        }
        
        // draw text
        if text != nil {
            font = UIFont.systemFont(ofSize: boldFont ? 16 * fontFactor: 9 * fontFactor, weight: boldFont ? UIFont.Weight.bold : UIFont.Weight.semibold)
            let textStyle = NSMutableParagraphStyle()
            textStyle.lineBreakMode = .byWordWrapping
            textStyle.alignment = .center
            attributedString = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: textStyle])
            if image == nil {
                drawString(attributedString, inRect: CGRect(center: viewCenter, width: length * cos(textAngle), height: length * sin(textAngle)))
            }else {
                drawString(attributedString, inRect: CGRect(center: CGPoint(x: viewCenter.x, y: viewCenter.y + length * 0.1 / sqrt(2)), width: length * 0.9, height: length * 0.5))
            }
        }
        
        // tagged
        if tagged {
            let tapImage = UIImage(named: "tapHand")! // 71 * 56
            let tapSize = CGSize(width: length * 0.65, height: length * 0.65 * 56 / 71)
            let tapRect = CGRect(x: lineWidth, y: bounds.height - tapSize.height - lineWidth, width: tapSize.width, height: tapSize.height)
            tapImage.draw(in: tapRect)
        }
    }
}


class ButterflyNode: SimpleNode {
//    var lineColor = UIColorFromRGB(126, green: 211, blue: 33)

    var innerColor = UIColor.white
    var outerWidth: CGFloat = 2
    var circleWidth: CGFloat = 3
    
    var useStandard = true
    
    // draw
    override func draw(_ rect: CGRect) {
        // rect
        let viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.midX, bounds.midY)
        
        // set some for reload
        if useStandard {
            let standP = radius / 35
            lineWidth = 1.5 * standP
            outerWidth = 2 * standP
            circleWidth = 3.5 * standP
            
            font = UIFont.systemFont(ofSize: boldFont ? 18 * standP: 9 * standP, weight: boldFont ? UIFont.Weight.bold : UIFont.Weight.semibold)
        }
        
        // draw outer
        if hasCircle {
            // color part
            let path = UIBezierPath()
            
            // shape
            switch borderShape {
            case .none: break
            case .circle: path.addArc(withCenter: viewCenter, radius: radius - outerWidth * 0.5, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
            case .triangle:
                path.move(to: CGPoint(x: bounds.midX, y: 0))
                path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
                path.close()
            case .diamond: path.append(UIBezierPath(rect: bounds))
            case .square: path.append(UIBezierPath(rect: bounds))
            case .pentagon: path.append(UIBezierPath(rect: bounds))
            case .hex: path.append(UIBezierPath(rect: bounds))
            }
            
            path.lineWidth = outerWidth
            circleColor.setFill()
            borderColor.setStroke()
            path.stroke()
            path.fill()
            
            // inner background
            // with shadow
            let innerPath = UIBezierPath()
            switch borderShape {
            case .none: break
            case .circle: innerPath.addArc(withCenter: viewCenter, radius: radius - outerWidth - circleWidth, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
            case .triangle:
                innerPath.move(to: CGPoint(x: bounds.midX, y: 0))
                innerPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
                innerPath.close()
            case .diamond: innerPath.append(UIBezierPath(rect: bounds))
            case .square: innerPath.append(UIBezierPath(rect: bounds.insetBy(dx: outerWidth, dy: outerWidth)))
            case .pentagon: innerPath.append(UIBezierPath(rect: bounds))
            case .hex: innerPath.append(UIBezierPath(rect: bounds))
            }
            
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            context?.setShadow(offset: CGSize.zero, blur: circleWidth * 0.8, color: UIColor.black.cgColor)
            
            innerColor.setFill()
            innerPath.fill()
            
            context?.restoreGState()
        }
        
        // text and image
        let length = hasCircle ? (radius - outerWidth - circleWidth) * 2 : radius * 2
        // draw image
        if image != nil {
            if text == nil {
                image.draw(in: CGRect(center: viewCenter, length: hasCircle ? length / sqrt(2) : length))
            }else {
                image.draw(in: CGRect(center: CGPoint(x: viewCenter.x, y: viewCenter.y - length * 0.3), length: 0.46 * length))
            }
        }
       
        // draw text
        if text != nil {
            let textStyle = NSMutableParagraphStyle()
            textStyle.lineBreakMode = .byWordWrapping
            textStyle.alignment = .center
            attributedString = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: textStyle])
            if image == nil {
                drawString(attributedString, inRect: CGRect(center: viewCenter, width: length * cos(textAngle), height: length * sin(textAngle)))
            }else {
                drawString(attributedString, inRect: CGRect(center: CGPoint(x: viewCenter.x, y: viewCenter.y + length * 0.1 / sqrt(2)), width: length * 0.9, height: length * 0.5))
            }
        }
    }
}
