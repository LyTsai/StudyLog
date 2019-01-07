//
//  NodeGraphCell.swift
//  TwoLevelsNodeGraph_Demo
//
//  Created by iMac on 17/1/6.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

enum ImagePosition {
    case left
    case right
    case up
    case down
    case middle
}

// MARK: --------- basic cell, with one image and one text ----------
class BasicGraphCell: CALayer {
    var core: AnyObject!
    
    var imageLayer = CALayer()
    var textLayer = CATextLayer()
    var imagePosition = ImagePosition.up {
        didSet {
            if imagePosition != oldValue {
                updateLayout()
            }
        }
    }
    var imageRatio: CGFloat = 0.5 {
        didSet{
            if imageRatio != oldValue {
                updateLayout()
            }
        }
    }
    
    // MARK: --------------------- methods -----------------------
    // factory method
    class func createWithImage(_ image: CGImage!, text: String!) -> BasicGraphCell {
        let nodeLayer = BasicGraphCell()
        
        // setup imageLayer
        nodeLayer.imageLayer.contents = image ?? UIImage(named: "placeHolder")!.cgImage
        
        // setup textLayer
        nodeLayer.textLayer.string = text
        nodeLayer.textLayer.foregroundColor = UIColor.black.cgColor
        nodeLayer.textLayer.alignmentMode = "center"
        nodeLayer.textLayer.isWrapped = true
        nodeLayer.textLayer.truncationMode = "end"
        nodeLayer.textLayer.contentsScale = UIScreen.main.scale
        
        // add layers
        nodeLayer.addSublayer(nodeLayer.imageLayer)
        nodeLayer.addSublayer(nodeLayer.textLayer)
        
        return nodeLayer
    }
    
    // detail set and layout
    // when the positon is left/ right, ratio is widith ratio
    //                       up/ down, ratio is height ratio
    fileprivate func updateLayout() {
        // setup the frame
        // setup the sublayers, just set part now
        let iRatio = max(0.2, min(imageRatio, 0.9))
        let ih = bounds.height * iRatio // for up/ down
        let iw = bounds.width * iRatio  // for left/ right
    
        switch imagePosition {
        case .left:
            imageLayer.frame = CGRect(x: 0, y: bounds.midY - iw * 0.5, width: iw, height: iw)
            textLayer.frame = CGRect(x: iw, y: 0, width: bounds.width - iw, height: bounds.height)
        case .right:
            imageLayer.frame = CGRect(x: bounds.width - iw, y: bounds.midY - iw * 0.5, width: iw, height: iw)
            textLayer.frame = CGRect(x: 0, y: 0, width: bounds.width - iw, height: bounds.height)
        case .up:
            imageLayer.frame = CGRect(x: bounds.midX - ih * 0.5, y: 0, width: ih, height: ih)
            textLayer.frame = CGRect(x: 0, y: ih, width: bounds.width, height: bounds.height - ih)
        case .down:
            imageLayer.frame = CGRect(x: bounds.midX - ih * 0.5, y: bounds.height - ih, width: ih, height: ih)
            textLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - ih)
        case .middle:
            let imageWidth = min(ih, iw)
            imageLayer.frame = CGRect(x: bounds.midX - imageWidth * 0.5, y: bounds.midY - imageWidth * 0.5, width: imageWidth, height: imageWidth)
            textLayer.frame = imageLayer.frame
        }
        
        // adjust font
        textLayer.fontSize = min(textLayer.frame.width, textLayer.frame.height) / 2.8
    }
    
    // decorations, shadow and so on
    override func layoutSublayers() {
        super.layoutSublayers()
        updateLayout()
    }
}
