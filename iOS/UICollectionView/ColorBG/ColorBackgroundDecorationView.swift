//
//  ColorBackgroundDecorationView.swift
//  BeautiPhi
//
//  Created by L on 2020/5/19.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation

let colorBackgroundDecorationViewID = "ColorBackgroundDecorationView identifier"
class ColorBackgroundDecorationView: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let backgroundAttri = layoutAttributes as? ColorBackgroundLayoutAttributes {
            self.backgroundColor = backgroundAttri.backgroundColor
        }
        
    }
}
