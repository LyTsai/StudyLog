//
//  ImageTextButton.swift
//  MagniPhi
//
//  Created by L on 2021/4/29.
//  Copyright © 2021 MingHui. All rights reserved.
//

import Foundation
import UIKit

class ImageTextButton: UIButton {
    
    // from xib, may be the text is set
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setTitle(self.titleLabel?.text)
        self.setImage(self.imageView?.image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBasic()
    }
    
    fileprivate let buttonTitleLabel = UILabel()
    fileprivate let buttonIconView = UIImageView()
    fileprivate func addBasic() {
        self.backgroundColor = UIColor.white
        
        // gradient
        buttonIconView.contentMode = .scaleAspectFit
        buttonTitleLabel.numberOfLines = 0
        
        self.addSubview(buttonIconView)
        self.addSubview(buttonTitleLabel)
    }
    
    func setImage(_ image: UIImage?)  {
        buttonIconView.image = image
        self.setImage(nil, for: .normal)
    }
    
    func setTitle(_  title: String?) {
        buttonTitleLabel.text = title
        self.setTitle(nil, for: .normal)
    }
    
    func setTitleColor(_  color: UIColor) {
        buttonTitleLabel.textColor = color
    }
    
    func setImage(_ imageURL: URL?) {
        buttonIconView.loadWebImage(imageURL, completion: nil)
        self.setImage(nil, for: .normal)
    }
   
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
         
        let one = bounds.height / 44
        layer.borderWidth = one
        self.layer.cornerRadius = 4 * one
        
        let gap = 5 * one
        let iconL = bounds.height * 0.8
        buttonIconView.frame = CGRect(x: gap, y: bounds.midY - iconL * 0.5, width: iconL, height: iconL)
        
        let titleX = gap * 2 + iconL
        self.buttonTitleLabel.frame = CGRect(x: titleX, y: 0, width: bounds.width - titleX - gap, height: bounds.height)
        self.buttonTitleLabel.font = UIFont.systemFont(ofSize: 16 * one, weight: .medium)
    }
}
