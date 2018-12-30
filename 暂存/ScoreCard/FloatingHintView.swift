//
//  FloatingHintView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/7/18.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class FloatingHintView: UIView {
    var attributedText: NSAttributedString! {
        didSet{
            hintLabel.attributedText = attributedText
        }
    }
    
    var image: UIImage! {
        didSet{
            imageView.image = image
        }
    }
    
    fileprivate let imageView = UIImageView()
    fileprivate let hintLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hintLabel.numberOfLines = 0
        hintLabel.backgroundColor = UIColor.white
        
        imageView.contentMode = .scaleAspectFit
        
        layer.masksToBounds = true
        addSubview(hintLabel)
        addSubview(imageView)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var frame: CGRect {
        didSet{
            imageView.frame = bounds
            hintLabel.frame = CGRect(x: bounds.midX, y: 0, width: 0, height: 0)
        }
    }
    
    func handleLabel(_ show: Bool) {
        UIView.animate(withDuration: 0.5) {
            
        }
    }
}
