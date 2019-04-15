//
//  CategoryInfoDisplayView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/24.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation


class CategoryDisplayView: UIView {
    func setupWithItem(_ item: RoadItemDisplayModel, category: CategoryDisplayModel) {
        self.frame = item.backFrame
        
        // image
        imageView.sd_setShowActivityIndicatorView(true)
        imageView.sd_setIndicatorStyle(.gray)
        imageView.sd_setImage(with: category.imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, progress: nil) { (image, error, type, url) in
            if image == nil {
                self.imageView.image = ProjectImages.sharedImage.placeHolder
            }else {
                category.image = image
                AIDMetricCardsCollection.standardCollection.imageIsLoadedForMetricGroup(category.key, image: image)
            }
        }
    
        
        // text
        textLabel.text = category.name
        
        // colors
        backgroundColor = item.fillColor
        layer.borderColor = item.borderColor.cgColor
        
        // processView
        let answeredNumber = category.cardsPlayed.count
        let totalNumber = category.cards.count
        
        if answeredNumber > totalNumber {
            print("wrong numbers")
            return
        }
        
        infoLabel.text = "\(answeredNumber)/\(totalNumber)"
        processView.processVaule = CGFloat(answeredNumber) / CGFloat(totalNumber)
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
    fileprivate let decoLayer = CAShapeLayer()
    fileprivate let textLabel = UILabel()
    fileprivate let infoLabel = UILabel()
    fileprivate let processView = CustomProcessView.setupWithProcessColor(UIColorFromRGB(80, green: 211, blue: 135))
    
    fileprivate func updateUI() {
        // setup
        decoLayer.fillColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFit
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        infoLabel.textAlignment = .right
        
        layer.masksToBounds = true
        
        // add
        layer.addSublayer(decoLayer)
        addSubview(imageView)
        addSubview(textLabel)
        addSubview(infoLabel)
        addSubview(processView)
    }
    
    /*
     84 * 115
     border: 2
     radius: 8
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let standP = min(bounds.width / 84, bounds.height / 115)
        let lineWidth = 3 * standP
        let cornerRadius = 8 * standP
        
        //  main
        layer.cornerRadius = cornerRadius
        layer.borderWidth = standP
        
        // parts
        let mainWidth = min(bounds.width - 2 * lineWidth, bounds.height * 0.7)
        let labelHeight = bounds.height * 0.26
        
        // white part
        let rectFrame = CGRect(x: (bounds.width - mainWidth) * 0.5, y: labelHeight, width: mainWidth, height: bounds.height - labelHeight - 1.75 * lineWidth)
        let decoPath = UIBezierPath(roundedRect: rectFrame, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 0.6 * cornerRadius, height: 0.6 * cornerRadius))
        decoLayer.path = decoPath.cgPath
        
        // image
        let margin = rectFrame.height * 0.015
        let imageLength = mainWidth * 0.8
        imageView.frame = CGRect(x: rectFrame.minX + 0.1 * mainWidth, y: rectFrame.minY + margin, width: imageLength, height: imageLength)
        
        // label
        textLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: labelHeight).insetBy(dx: 3 * standP, dy: 3 * standP)
        
        // process
        let infoY = imageView.frame.maxY + margin
        let remainedHeight = rectFrame.maxY - infoY - 0.8 * margin
        processView.frame = CGRect(x: rectFrame.minX + lineWidth, y: infoY + remainedHeight * 0.22, width: imageLength * 0.76, height: remainedHeight * 0.55)
        infoLabel.frame = CGRect(x: processView.frame.maxX + 0.4 * margin, y: infoY, width: rectFrame.maxX - processView.frame.maxX - 0.4 * margin - lineWidth, height: remainedHeight)
        
        // font
        textLabel.font = UIFont.systemFont(ofSize: labelHeight * 0.32, weight: UIFontWeightMedium)
        infoLabel.font = UIFont.systemFont(ofSize: remainedHeight * 0.54)
    }
}

// MARK: ----------------------- all answered
class CategoryAllAnsweredView: UIView {
    func setupWithItem(_ item: RoadItemDisplayModel, category: CategoryDisplayModel, forMatched: Bool) {
        // label
        titleLabel.backgroundColor = item.fillColor
        titleLabel.layer.borderColor = item.borderColor.cgColor
        titleLabel.text = category.name
        
        let labelHeight = item.backFrame.height * 0.26
        titleLabel.frame = CGRect(x: item.backFrame.minX, y: 0, width: item.backFrame.width, height: labelHeight)
        titleLabel.layer.cornerRadius = labelHeight * 0.45
        titleLabel.font = UIFont.systemFont(ofSize: labelHeight * 0.32, weight: UIFontWeightMedium)
        
        let matchedCards = MatchedCardsDisplayModel.getCurrentCategoryOfCardsPlayed()[category.key]
        
        let cardLength = min(item.backFrame.width, item.backFrame.height - labelHeight) * 0.8
        let gap = item.backFrame.height - cardLength - labelHeight
        cardDisplay.frame = CGRect(x: item.backFrame.midX - cardLength * 0.5, y: labelHeight + gap * 0.4, width: cardLength, height: cardLength)
        cardDisplay.layer.borderColor = item.borderColor.cgColor
        
//        var imageUrl = category.imageUrl
        if forMatched {
              cardDisplay.sd_setImage(with: category.imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached)
        }else {
            if let cardImageUrl = matchedCards?.first?.imageUrl {
                cardDisplay.sd_setImage(with: cardImageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached)
            }else {
                cardDisplay.sd_setImage(with: category.imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached)
            }
        }
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate let cardDisplay = UIImageView()
    // create
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate func updateUI() {
        // title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.layer.borderWidth = 1.5
        titleLabel.layer.masksToBounds = true
        
        // card
        cardDisplay.layer.borderWidth = 2
        cardDisplay.layer.masksToBounds = true
        cardDisplay.layer.cornerRadius = 4
        cardDisplay.backgroundColor = UIColor.white
        
        // add
        addSubview(titleLabel)
        addSubview(cardDisplay)
    }
    
}
