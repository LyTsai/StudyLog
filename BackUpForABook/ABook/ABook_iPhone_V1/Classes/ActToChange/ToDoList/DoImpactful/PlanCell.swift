//
//  PlanCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/20.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
// items

// MARK: -------------- plan cell
let planCellID = "plan cell identifier"
class PlanCell: UICollectionViewCell {

    var image: UIImage! {
        didSet{
            if image != oldValue { imageView.image = image }
        }
    }
    var text: String! {
        didSet{
            if text != oldValue { textLabel.text = text.uppercased() }
        }
    }
    var index = -1 {
        didSet {
            indexLabel.text = "\(index)"
        }
    }
    
    var borderColor: UIColor! {
        didSet {
            if borderColor != oldValue {
                backLayer.strokeColor = borderColor.cgColor
                indexLabel.layer.borderColor = borderColor.cgColor
            }
        }
    }
    var fillColor: UIColor! {
        didSet {
            if fillColor != oldValue { backLayer.fillColor = fillColor.cgColor }
        }
    }
    
    override var isSelected: Bool {
        didSet{
            checkImageView.isHidden = !isSelected
            // shadow for selected items
            backLayer.shadowColor = isSelected ? UIColor.black.cgColor : UIColor.clear.cgColor
        }
    }
    
    // create
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate let imageView = UIImageView()
    fileprivate let textLabel = UILabel()
    fileprivate let indexLabel = UILabel()
    fileprivate let backLayer = CAShapeLayer()
    fileprivate let checkImageView = UIImageView()
    
    fileprivate func updateUI() {
        // setup
        backLayer.lineWidth = 2
        backLayer.shadowOffset = CGSize(width: 0, height: 2)
        backLayer.shadowOpacity = 0.8
        
        imageView.contentMode = .scaleAspectFit
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        indexLabel.textAlignment = .center
        indexLabel.layer.borderWidth = 2

        checkImageView.image = UIImage(named: "planCheck")

        // add
        contentView.layer.addSublayer(backLayer)
        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)
        contentView.addSubview(indexLabel)
        contentView.addSubview(checkImageView)
        
        // init
        checkImageView.isHidden = true
        backLayer.shadowColor = UIColor.clear.cgColor
    }
    
    /*
     115 * 115, borderWidth: 2
     (5, 5, 25, 25)
     (-6, + 4)
     shadow: 4
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let length = min(bounds.width, bounds.height) * 115 / 121
        let margin = 5 * length / 115
        let mainFrame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY), length: length)
        
        backLayer.frame = mainFrame
        backLayer.path = UIBezierPath(roundedRect: backLayer.bounds.insetBy(dx: 1, dy: 1), cornerRadius: 5).cgPath
        backLayer.shadowRadius = margin
        backLayer.shadowPath = backLayer.path
        
        let tagFrame = CGRect(x: mainFrame.minX + margin, y: mainFrame.minY + margin, width: 5 * margin, height: 5 * margin)
        indexLabel.frame = tagFrame
        indexLabel.layer.cornerRadius = 2.5 * margin
        checkImageView.frame = tagFrame
        
        let imageLength = 80 * length / 115
        imageView.frame = CGRect(x: bounds.width - imageLength, y: 0, width: imageLength, height: imageLength)
        textLabel.frame = CGRect(x: 2 * margin, y: imageView.frame.maxY, width: mainFrame.width - 2 * margin, height: mainFrame.maxY - imageView.frame.maxY)

        // font
        indexLabel.font = UIFont.systemFont(ofSize: 3 * margin, weight: UIFontWeightSemibold)
        textLabel.font = UIFont.systemFont(ofSize: 2 * margin, weight: UIFontWeightBold)
    }
}
