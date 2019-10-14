//
//  AssessmentsClassificationCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/17.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation


let assessmentsClassificationCellID = "Assessments Classification Cell identifier"
class AssessmentsClassificationCell: UICollectionViewCell {
    fileprivate let nameLabel = UILabel()
    fileprivate let numberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    fileprivate func setupBasic() {
        nameLabel.textAlignment = .center
        numberLabel.textAlignment = .center
        nameLabel.layer.masksToBounds = true
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(numberLabel)
    }
    
    func configureWithName(_ name: String, number: Int, color: UIColor) {
        nameLabel.text = name
        numberLabel.text = "\(number)"
        nameLabel.backgroundColor = color
        numberLabel.textColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let topH = bounds.height * 0.6
        nameLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: topH)
        numberLabel.frame = CGRect(x: 0, y: topH, width: bounds.width, height: bounds.height - topH)
        let font = UIFont.systemFont(ofSize: topH * 0.67, weight: .semibold)
        nameLabel.font = font
        numberLabel.font = font
        
        nameLabel.layer.cornerRadius = 2 * topH / 18
    }
}
