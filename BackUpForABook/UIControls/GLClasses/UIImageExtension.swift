//
//  Extension.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/8/26.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    // 9 slicing a picture
    func stretchedImage() -> UIImage {
        let leftCap = Int(size.width * 0.5)
        let topCap = Int(size.height * 0.5)
        return stretchableImage(withLeftCapWidth: leftCap, topCapHeight: topCap)
    }
    
    // 9 slicing, if use a name to get image
    class func stretchedImageNamed(_ name: String) -> UIImage? {
        let image = UIImage(named: name)
        if image == nil {
            return nil
        }
        
        return image!.stretchedImage()
    }
}
