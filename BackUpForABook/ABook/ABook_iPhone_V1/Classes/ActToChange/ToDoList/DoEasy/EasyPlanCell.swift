//
//  EasyPlanCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/9.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let easyPlanCellID = "easy plan cell identifier"
class EasyPlanCell: UICollectionViewCell {
    // content
    var planTitle: String! {
        didSet{ if planTitle != oldValue { titleLabel.text = planTitle } }
    }
    var planImage: UIImage!{
        didSet{ if planImage != oldValue { planImageView.image = planImage } }
    }
    var mainColor: UIColor!{
        didSet{
            if mainColor != oldValue {
                contentView.layer.borderColor = mainColor.cgColor
                topView.backgroundColor = mainColor
            }
        }
    }
    
//    #imageLiteral(resourceName: "checkbox_no") #imageLiteral(resourceName: "checkbox_yes") #imageLiteral(resourceName: "icon_no_bell") #imageLiteral(resourceName: "icon_yes_bell")
    override var isSelected: Bool {
        didSet{
            checkboxImageView.image = isSelected ? UIImage(named: "checkbox_yes") : UIImage(named: "checkbox_no")
            if !isSelected {
                bellImageView.image = nil
            }else {
                bellImageView.image = UIImage(named: "icon_no_bell")
            }
        }
    }
    var isReminded = false {
        didSet{
            bellImageView.image = isReminded ? UIImage(named: "icon_yes_bell") : UIImage(named: "icon_no_bell")
            if !isSelected {
                bellImageView.image = nil
            }
        }
    }
    var isEditing = false {
        didSet{
            if isEditing != oldValue {
                checkboxImageView.isHidden = !isEditing
            }
        }
    }
    
    // MARK:---------- private ------------
    // private properties
    fileprivate let titleLabel = UILabel()
    fileprivate let planImageView = UIImageView()
    fileprivate let checkboxImageView = UIImageView()
    fileprivate let bellImageView = UIImageView()
    fileprivate let topView = UIView()
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate func updateUI() {
        // basic
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        planImageView.contentMode = .scaleAspectFit
        bellImageView.contentMode = .scaleAspectFit
        checkboxImageView.backgroundColor = UIColor.white
        
        // add
        contentView.addSubview(topView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(planImageView)
        contentView.addSubview(bellImageView)
        contentView.addSubview(checkboxImageView)
        
        // layer
        contentView.layer.masksToBounds = true
        
        // reuse
        checkboxImageView.isHidden = true
    }
    
    // layout
    /* 115 * 155, labelh: 55, bell: 14 + 2 * 2, checkbox: 16 * 16, checkM: 5 */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let topHeight = bounds.height * 55 / 155
        let minPro = min(bounds.width / 115, bounds.height / 155)
        let bellLength = 18 * minPro
        let checkboxLength = 16 * minPro
        let boxMargin = 5 * minPro
        
        let topFrame = CGRect(x: 0, y: 0, width: bounds.width, height: topHeight)
        topView.frame = topFrame
        titleLabel.frame = topFrame.insetBy(dx: bellLength * 0.5, dy: bellLength * 0.5)
        titleLabel.font = UIFont.systemFont(ofSize: topHeight * 0.28, weight: UIFontWeightMedium)

        planImageView.frame = CGRect(x: 0, y: topHeight, width: bounds.width, height: bounds.height - topHeight)
        bellImageView.frame = CGRect(x: bounds.width - bellLength, y: 0, width: bellLength, height: bellLength)
        checkboxImageView.frame = CGRect(x: bounds.width - boxMargin - checkboxLength, y: bounds.height - boxMargin - checkboxLength, width: checkboxLength, height: checkboxLength)
        
        contentView.layer.borderWidth = 2 * minPro
        contentView.layer.cornerRadius = 8 * minPro
    }
}
