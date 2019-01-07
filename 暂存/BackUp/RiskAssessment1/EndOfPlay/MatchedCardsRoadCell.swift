//
//  MatchedCardsRoadCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/30.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let matchedCardsRoadCellID = "matched cards road cell identifier"
class MatchedCardsRoadCell: ImageAndTextCell {
    var isChosen = false {
        didSet{
            maskLayer.isHidden = !isChosen
        }
    }
    
    var font: UIFont! {
        didSet{
            if font != nil {
                textLabel.font = font
            }
        }
    }
    
    fileprivate let maskLayer = CALayer()
    fileprivate let noChoiceImageView = UIImageView(image: UIImage(named: "summary_noChoice"))
    fileprivate let roadItemView = RoadItemDisplayView()
    
    // add subviews and layers
    override func updateUI() {
        super.updateUI()
        
        roadItemView.backgroundColor = UIColor.clear
        
        backLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.backgroundColor = UIColor.black.withAlphaComponent(0.3).cgColor

        // add
        contentView.insertSubview(roadItemView, at: 0)
        contentView.addSubview(noChoiceImageView)
        contentView.layer.addSublayer(maskLayer)
    }
    
    fileprivate var item: RoadItemDisplayModel!
    func setupWithRoadItem(_ item: RoadItemDisplayModel) {
        self.item = item
        
        // 1. draw
        roadItemView.setupItemInfoWithFrame(bounds, item: item)
        
        // 2. backLayer & mask
        backLayer.frame = item.backFrame
        backLayer.borderColor = item.borderColor.cgColor
        backLayer.cornerRadius = item.lineWidth * 4
        backLayer.borderWidth = item.lineWidth * 2
        
        noChoiceImageView.frame = item.backFrame
        noChoiceImageView.layer.cornerRadius = item.lineWidth * 4
        
        maskLayer.frame = item.backFrame
        maskLayer.cornerRadius = item.lineWidth * 4
        
        // 3. imageView
        imageView.frame = item.backFrame.insetBy(dx: item.lineWidth * 4, dy: item.lineWidth * 4)

        // 4. textLabel
        textLabel.frame = item.textFrame
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightBold) // should be fixed
        
        switch item.anchorPosition {
        case .left:
            textLabel.textAlignment = .right
        case .right:
            textLabel.textAlignment = .left
        case .top:
            textLabel.textAlignment = .right
        case .bottom:
            textLabel.textAlignment = .left
            textLabel.adjustWithWidthKept()
        case .free:
            break
        }
    }
    
    func fillDataWithImageUrl(_ imageUrl: URL?, text: String?, answered: Bool) {
        // text
        textLabel.text = text
        if item != nil {
            if item.anchorPosition == .bottom {
                textLabel.sizeToFit()
            }
        }
        
        // image
        if answered {
            imageView.isHidden = false
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setIndicatorStyle(.gray)
            imageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, progress: nil) { (image, error, type, url) in
                if image == nil {
                    self.imageView.image = ProjectImages.sharedImage.placeHolder
                }
            }
        }else {
            imageView.isHidden = true
        }
        
        noChoiceImageView.isHidden = answered

    }
    
}
