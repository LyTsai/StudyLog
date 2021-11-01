//
//  ImageMaskColorLayer.swift
//  MerriPhi
//
//  Created by L on 2021/10/12.
//  Copyright © 2021 MingHui. All rights reserved.
//

import Foundation
import UIKit

class ImageMaskColorLayer: CALayer {
    fileprivate let maskImageView = UIImageView()
    func setupWithMaskImage(_ maskImage: UIImage?) {
        self.mask = maskImageView.layer
        maskImageView.contentMode = .scaleAspectFit
        maskImageView.image = maskImage
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        maskImageView.frame = bounds
    }
}
