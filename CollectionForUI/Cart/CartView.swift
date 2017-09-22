//
//  CartView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/18.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CartView: UIControl {
    var number: Int = 0 {
        didSet{
            if number != oldValue {
                if number == 0 {
                    numberLabel.isHidden = true
                    cartCardIcon.isHidden = true
                }else {
                    numberLabel.isHidden = false
                    numberLabel.text = "\(number)"
                    cartCardIcon.isHidden = false
                }
            }
        }
    }

    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasicUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasicUI()
    }
    
    fileprivate let cartIcon = UIImageView(image: UIImage(named: "cart_only"))
    fileprivate let animationCardIcon = UIImageView(image: UIImage(named: "cart_card"))
    fileprivate let cartCardIcon = UIImageView(image: UIImage(named: "cart_card"))
    fileprivate let numberLabel = UILabel()
    fileprivate func setupBasicUI() {
        numberLabel.textColor = UIColor.white
        numberLabel.textAlignment = .center
        numberLabel.backgroundColor = UIColor.red
        numberLabel.layer.masksToBounds = true
        
        // add
        addSubview(cartCardIcon)
        addSubview(cartIcon)
        addSubview(numberLabel)
        
        // initState
        numberLabel.isHidden = true
        cartCardIcon.isHidden = true
        
//        clipsToBounds = true
    }
    /*
     bounds: 38 * 38
     total: 32 * 38
     cart: 32 * 30
     card: 22 * 22
     cardBottom: 22
     label: 21
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let standP = min(bounds.width, bounds.height) / 38
        let cartWidth = 32 * standP
        let labelLength = 21 * standP
        let cardLength = 22 * standP
        cartIcon.frame = CGRect(x: 0, y: 8 * standP, width: cartWidth, height: 30 * standP)
        cartCardIcon.frame = CGRect(x: 2 * standP, y: 0, width: cardLength, height: cardLength)
        
        // nunmberlabel
        numberLabel.frame = CGRect(x: bounds.width - labelLength, y: bounds.height - labelLength, width: labelLength, height: labelLength)
        numberLabel.font = UIFont.systemFont(ofSize: labelLength * 0.5, weight: UIFontWeightBold)
        numberLabel.layer.cornerRadius = 0.5 * labelLength
    }
    
    // animation
    // add
    func cardAddAnimation() {
        insertSubview(animationCardIcon, belowSubview: cartIcon)
        self.animationCardIcon.transform = CGAffineTransform.identity
        
        let endFrame = cartCardIcon.frame
        let startFrame = CGRect(x: 0, y: bounds.height, width: endFrame.width, height: endFrame.height)
        animationCardIcon.frame = startFrame
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.cartIcon.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.animationCardIcon.transform = CGAffineTransform(translationX: endFrame.minX - startFrame.minX, y: endFrame.midY - startFrame.midY)
        }) { (true) in
            UIView.animate(withDuration: 0.2, animations: {
                self.cartIcon.transform = CGAffineTransform.identity
            }, completion: { (true) in
                self.animationCardIcon.removeFromSuperview()
            })
        }
    }
}
