//
//  ImageNode.swift
//  MagniPhi
//
//  Created by L on 2021/3/3.
//  Copyright © 2021 MingHui. All rights reserved.
//

import Foundation
import UIKit

class ImageNode: UIView {
    var roundImageBack: Bool? {
        didSet {
            setNeedsLayout()
        }
    }
    
    // read
    var backLayer: CAShapeLayer {
        return _backLayer
    }
    
    var imageView: UIImageView {
        return _imageView
    }
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBasic()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupBasic()
    }

    fileprivate let _backLayer = CAShapeLayer()
    fileprivate let _imageView = UIImageView()
    func setupBasic() {
        self.backgroundColor = UIColor.clear
        
        _backLayer.fillColor = UIColor.white.cgColor
        _imageView.contentMode = .scaleAspectFit
        
        // add
        layer.addSublayer(_backLayer)
        addSubview(_imageView)
    }
    
    // data
    func setupWithColor(_ color: UIColor?, image: URL?) {
        setupWithColor(color)
        _imageView.loadWebImage(image, completion: nil)
    }
    
    func setupWithColor(_ color: UIColor?) {
        _backLayer.strokeColor = (color ?? projectTintColor).cgColor
    }
     
    var displayFrame: CGRect {
        let viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let displayL = min(bounds.width, bounds.height)
        
        return CGRect(center: viewCenter, length: displayL)
    }
    
    var backCornerRadius: CGFloat {
        return (roundImageBack ?? false) ? displayFrame.width * 0.5 : displayFrame.width * 0.1
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
      
        // shape
        _backLayer.path = UIBezierPath(roundedRect: displayFrame, cornerRadius: backCornerRadius).cgPath
        // image
        let imageOffset = displayFrame.width * ((roundImageBack ?? false) ? (1 - 1 / sqrt(2)) * 0.5 : 0.05)
        _imageView.frame = displayFrame.insetBy(dx: imageOffset, dy: imageOffset)
    }
}
