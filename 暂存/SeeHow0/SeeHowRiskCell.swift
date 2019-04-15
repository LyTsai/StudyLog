//
//  SeeHowRiskCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/30.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let playedGameCellID = "played game cell ID"
class PlayedGameCell: BasicCollectionViewCell {

    var mainColor = UIColor.white {
        didSet{
            if mainColor != oldValue {
                backView.backgroundColor = mainColor
                backView.layer.borderColor = mainColor.cgColor
            }
        }
    }
    
    var underEditing = false {
        didSet{
            if underEditing != oldValue {
                deleteImageView.isHidden = !underEditing
            }
        }
    }
    
    fileprivate let backImageView = UIImageView(image: UIImage(named: "sketchBack"))
    fileprivate let backView = UIView()
    fileprivate let imageBackView = UIView()
    fileprivate let deleteImageView = UIImageView(image: UIImage(named: "icon_deleteItem"))
    
    override func updateUI() {
        super.updateUI()
        
        backView.layer.borderWidth = 2
        backView.layer.cornerRadius = 5
        backView.layer.masksToBounds = true
    
        deleteImageView.isHidden = true
        imageBackView.backgroundColor = UIColor.white
        
        // add
        backView.addSubview(imageBackView)
        backView.addSubview(textLabel)
        backView.addSubview(imageView)
        
        contentView.addSubview(backImageView)
        contentView.addSubview(backView)
        contentView.addSubview(deleteImageView)
    }
    
    // 101 * 128, card: 82 * 115
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backImageView.frame = bounds
        
        let standardW = bounds.width / 108
        let standardH = bounds.height / 148
        
        let imageEdgeInsets = UIEdgeInsets(top: 2 * standardH, left: 4 * standardW, bottom: 16 * standardH, right: 4 * standardW)
        
        let mainWidth = bounds.width - imageEdgeInsets.left - imageEdgeInsets.right
        let margin = (bounds.width - mainWidth) * 0.5
        let topHeight = 50 * standardH
        
        let deleteLength = 16 * standardW
        deleteImageView.frame = CGRect(x: 0, y: 0, width: deleteLength, height: deleteLength)
        
        let backFrame = CGRect(x: margin, y: margin, width: mainWidth, height: bounds.height - imageEdgeInsets.top - imageEdgeInsets.bottom)
        backView.frame = backFrame
        textLabel.frame = CGRect(x: 2, y: 2, width: mainWidth - 4, height: topHeight)
        textLabel.font = UIFont.systemFont(ofSize: 10 * standardH, weight: UIFontWeightMedium)
        
        imageBackView.frame = CGRect(x: 0, y: topHeight + 2, width: mainWidth, height: backFrame.height - topHeight - 4)
        imageView.frame = imageBackView.frame.insetBy(dx: 10 * standardW, dy: 10 * standardH)

    }
    
    //    func askForDelete() {
    //
    //    }
}

// MARK: --------- header View ------------------
let playedGameHeaderID = "played game header ID"
class PlayedGameHeaderView: UICollectionReusableView {
    weak var hostCollection: SeeHowRisksCollectionView!
    
    fileprivate let textLabel = UILabel()
    fileprivate let editButton = UIButton(type: .custom)
    fileprivate let lineView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    fileprivate func updateUI() {
        textLabel.text = "Games Played"
        
        editButton.setTitleColor(UIColor.darkGray, for: .normal)
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitle("Done", for: .selected)
        editButton.addTarget(self, action: #selector(editPlayedGames), for: .touchUpInside)
        editButton.titleLabel?.textAlignment = .center
        
        addSubview(textLabel)
        addSubview(editButton)
        
        // one line
        lineView.backgroundColor = tabTintGreen
        addSubview(lineView)
    }
    
    func editPlayedGames(_ button: UIButton)  {
        button.isSelected = !button.isSelected
        hostCollection.isEditing = button.isSelected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel.frame = CGRect(x: 20, y: 0, width: bounds.width * 0.4, height: bounds.height)
        textLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.3, weight: UIFontWeightSemibold)
        
        editButton.frame = CGRect(center: CGPoint(x: bounds.width * 0.9 , y: bounds.midY), width: bounds.width * 0.15, height: bounds.height * 0.7)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: bounds.height * 0.3)
        
        lineView.frame = CGRect(x: 0, y: bounds.height - 2, width: bounds.width, height: 2)
    }
}
