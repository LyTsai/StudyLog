//
//  GenderInputView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
class GenderInputView: UIView {
    var isMale: Bool! {
        didSet{
            if hostCell != nil {
                hostCell.changeState()
            }
        }
    }
    
    weak var hostCell: UserInfoGenderCell!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate let imageView = UIImageView()
    fileprivate func setupBasic() {
        backgroundColor = UIColor.clear
        
        imageView.image = UIImage(named: "genderSwitch_start")
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapToChoose(_:)))
        addGestureRecognizer(tapGR)
    }
    
    func tapToChoose(_ tapGR: UITapGestureRecognizer) {
        let location = tapGR.location(in: self)
        if location.x <= bounds.midX {
            imageView.image = UIImage(named: "genderSwitch_male")
            isMale = true
        }else {
            imageView.image = UIImage(named: "genderSwitch_female")
            isMale = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds.insetBy(dx: 10, dy: 0)
    }
}
