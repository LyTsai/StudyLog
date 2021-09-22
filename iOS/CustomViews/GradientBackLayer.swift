//
//  GradientBackLayer.swift
//  MagniPhi
//
//  Created by L on 2021/2/22.
//  Copyright © 2021 MingHui. All rights reserved.
//

import Foundation
import UIKit

class GradientBackLayer: CAGradientLayer {
    override init() {
        super.init()
        self.basicSetup()
    }
    override init(layer: Any) {
        super.init(layer: layer)
        self.basicSetup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.basicSetup()
    }

    fileprivate func basicSetup() {
        self.backgroundColor = UIColor.white.cgColor
    }
    
    // main color
    func setupWithColor(_ color: UIColor) {
        self.colors = [color.withAlphaComponent(0.15).cgColor, color.withAlphaComponent(0.35).cgColor]
    }
    
    // mask
    func addMask(_ path: CGPath) {
        let gradientMask = CAShapeLayer()
        gradientMask.path = path
        gradientMask.fillColor = UIColor.red.cgColor
        
        self.mask = gradientMask
    }
}
