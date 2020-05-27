//
//  ColorBackgroundLayoutAttributes.swift
//  BeautiPhi
//
//  Created by L on 2020/5/19.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation

class ColorBackgroundLayoutAttributes: UICollectionViewLayoutAttributes {
    var backgroundColor = UIColor.clear
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! ColorBackgroundLayoutAttributes
        copy.backgroundColor = self.backgroundColor
        
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let compare = object as? ColorBackgroundLayoutAttributes else {
            return false
        }
         
        if !self.backgroundColor.isEqual(compare.backgroundColor) {
            return false
        }
        
        return super.isEqual(object)
    }
}
