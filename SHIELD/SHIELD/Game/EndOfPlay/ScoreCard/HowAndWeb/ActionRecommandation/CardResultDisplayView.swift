//
//  CardResultDisplayView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/13.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class CardResultDisplayView: UIView {
    fileprivate let matchImageView = UIImageView()
    fileprivate let resultTextView = UITextView()
    fileprivate let imageBackLayer = CAShapeLayer()
    fileprivate let factorTypeDeco = UIImageView()
 
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    func updateUI() {
        matchImageView.contentMode = .scaleAspectFit
        resultTextView.isEditable = false
        resultTextView.isSelectable = false
        resultTextView.bounces = false
        resultTextView.textContainerInset = UIEdgeInsets.zero
        
        factorTypeDeco.contentMode = .scaleAspectFit
        imageBackLayer.fillColor = UIColor.white.cgColor
        
        // add
        layer.addSublayer(imageBackLayer)
        
        addSubview(factorTypeDeco)
        addSubview(matchImageView)
        addSubview(resultTextView)
        
        // add shadow??
    }
    
    func setupWithImageUrl(_ imageUrl: URL?, borderColor: UIColor, attributedText: NSAttributedString, factorType: FactorType) {
        // image
        matchImageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.imagePlaceHolder,options: .refreshCached, completed: nil)
        
        // text
        resultTextView.attributedText = attributedText
        
        //factor
        if factorType == .complementary || factorType == .bonus {
            imageBackLayer.isHidden = true
            factorTypeDeco.image = (factorType == .complementary ? #imageLiteral(resourceName: "complementary_border") : #imageLiteral(resourceName: "bonus_border"))
        }else {
            imageBackLayer.isHidden = false
            factorTypeDeco.image = nil
            imageBackLayer.strokeColor = borderColor.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // left back part
        let lineWidth = bounds.height / 30 // about 2
        let leftRect = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height)
        imageBackLayer.lineWidth = lineWidth
        imageBackLayer.path = UIBezierPath(roundedRect: leftRect.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5), cornerRadius: 3 * lineWidth).cgPath
        
        factorTypeDeco.frame = leftRect
        
        // image
        let imageInset = 3 * lineWidth
        matchImageView.frame = leftRect.insetBy(dx: imageInset, dy: imageInset)
        
        // text
        let textX = leftRect.width + 5 * lineWidth
        resultTextView.frame = CGRect(x: textX, y: 0, width: bounds.width - textX, height: bounds.height)
    }
}
