//
//  ANNodeLayer.swift
//  NGClasses
//
//  Created by iMac on 16/12/20.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// MARK: ------------ NANodeLayer ------------------
class ANNodeLayer: CALayer {
    // this layer is not added to any superLayer
    // the "isHidden" property of CALayer, used with ANLayoutNode's isHidden
    
    var imageLayer = CALayer()
    var textLayer = CATextLayer()
    
    // zero, no changes; (0.5, 0.5), halfWidth and halfHeight
    var shrinkRatio: UIOffset = UIOffset.zero
    // adjust of imageLayer and textLayer
    // TODO: ------ in case of more detailed change, leave it now
    var shrink: CGFloat = 0
    
    class func createWithImage(_ image: CGImage!, text: String!) -> ANNodeLayer {
        let nodeLayer = ANNodeLayer()
        nodeLayer.imageLayer.contents = image ?? UIImage(named: "flowers")!.cgImage
        nodeLayer.textLayer.string = text
        nodeLayer.textLayer.foregroundColor = UIColor.black.cgColor
        nodeLayer.textLayer.alignmentMode = "center"
        
        return nodeLayer
    }
}

// layout and add
extension ANNodeLayer {
    // load into parent page and set up transformation matrix that would map the original view onto given layout
    // parentPage -  our new parent layer
    // layout - the new frame area
    func loadOntoPage(_ parentPage: CALayer, layout: CGRect) {
        // map to _imageLayer
        if  imageLayer.superlayer != nil {
            imageLayer.removeFromSuperlayer()
        }
        // connect to the new parent
        parentPage.addSublayer(imageLayer)
        
        if  textLayer.superlayer != nil {
            textLayer.removeFromSuperlayer()
        }
        // connect to the new parent
        parentPage.addSublayer(textLayer)
        
        // set frame
        bounds = layout.insetBy(dx: layout.width * 0.5 * shrinkRatio.horizontal, dy: layout.height * 0.5 * shrinkRatio.vertical)
        
        layoutSublayers()
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        // the relationship between imageLayer-bounds, textLayer-bounds
        imageLayer.frame = bounds.insetBy(dx: bounds.width * shrink * 0.5, dy: bounds.height * shrink * 0.5)
        textLayer.frame = bounds.insetBy(dx: bounds.width * shrink * 0.5, dy: bounds.height * shrink * 0.5)
//        textLayer.font = UIFont.systemFont(ofSize: 10)
    }
}

// MARK: ------------- default for test ---------------------
extension ANNodeLayer {
    func initWithDefault()  {
        imageLayer.contents = UIImage(named: "face_red")!.cgImage
        imageLayer.masksToBounds = true
        imageLayer.borderColor = UIColor.clear.cgColor
        imageLayer.backgroundColor = UIColor.clear.cgColor
    }
    func initWithDefault1()  {
        imageLayer.contents = UIImage(named: "face1")!.cgImage
        imageLayer.masksToBounds = true
        imageLayer.borderColor = UIColor.clear.cgColor
        imageLayer.backgroundColor = UIColor.clear.cgColor
    }
}

func getRandomSymbolPath() -> ANNodeLayer {
    let obj = ANNodeLayer()
    obj.initWithDefault()
    
    return obj
}

func getRandomSymbolPath_Face() -> ANNodeLayer {
    let obj = ANNodeLayer()
    obj.initWithDefault1()
    
    return obj
}
