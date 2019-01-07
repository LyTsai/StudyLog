//
//  CategoryDisplayModel.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/15.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MARK: ----------- category display model ----------------------
class CategoryDisplayModel {
    var key: String!
    var name: String!
    var image: UIImage!
    var imageUrl: URL!

    var cardsPlayed = [String]()
    var cards = [CardInfoObjModel]()
    
//    var mainColor: UIColor!
}

// MARK: ----------- category display cell ----------------------
let categoryDisplayCellID = "category display cell identifier"
class CategoryDisplayCell: UICollectionViewCell {
    var imageUrl: URL! {
        didSet{
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setIndicatorStyle(.gray)
            imageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.placeHolder, options: .refreshCached)
        }
    }
    
    var image: UIImage! {
        didSet{
            if image != oldValue { imageView.image = image }
        }
    }
    var text: String! {
        didSet{
            if text != oldValue { textLabel.text = text }
        }
    }
    
    var answeredNumber: Int = 0 {
        didSet{
            if answeredNumber != oldValue {
                checkAnswering()
            }
        }
    }
    
    var totalNumber: Int = 0 {
        didSet{
            if totalNumber != oldValue {
                checkAnswering()
            }
        }
    }
    
    var borderColor: UIColor! {
        didSet {
            if borderColor != oldValue {
                contentView.layer.borderColor = borderColor.cgColor
                checkLayer.strokeColor = borderColor.cgColor
                markImageView.layer.shadowColor = borderColor.cgColor
            }
        }
    }
    var fillColor: UIColor! {
        didSet {
            if fillColor != oldValue {
                contentView.backgroundColor = fillColor
                checkLayer.fillColor = fillColor.cgColor
            }
        }
    }
    
    fileprivate func checkAnswering() {
        if answeredNumber > totalNumber {
            print("wrong numbers")
            return
        }
        
        infoLabel.text = "\(answeredNumber)/\(totalNumber)"
        processView.processVaule = CGFloat(answeredNumber) / CGFloat(totalNumber)
        
        let isFinished = (answeredNumber == totalNumber)
        checkLayer.isHidden = !isFinished
        markImageView.isHidden = !isFinished
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
    fileprivate let checkLayer = CAShapeLayer()
    fileprivate let markImageView = UIImageView(image: UIImage(named: "category_Check"))
    fileprivate let infoLabel = UILabel()
    fileprivate let processView = CustomProcessView.setupWithProcessColor(UIColorFromRGB(80, green: 211, blue: 135))
    
    fileprivate func updateUI() {
        // setup
        decoLayer.fillColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFit
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        infoLabel.textAlignment = .right
        checkLayer.backgroundColor = UIColor.black.withAlphaComponent(0.4).cgColor
        
        markImageView.contentMode = .scaleAspectFit
        markImageView.layer.shadowOpacity = 1
        markImageView.layer.shadowOffset = CGSize.zero
        
        contentView.layer.masksToBounds = true
        
        // add
        contentView.layer.addSublayer(decoLayer)
        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(processView)
        contentView.layer.addSublayer(checkLayer)
        contentView.addSubview(markImageView)
        
        // init
        checkLayer.isHidden = true
        markImageView.isHidden = true
    }
    
    /*
     109 * 160
     border: 2
     radius: 8
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let standP = min(bounds.width / 109, bounds.height / 160)
        let lineWidth = 4 * standP
        let cornerRadius = 8 * standP
        
        //  main
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.borderWidth = standP
        
        // parts
        let mainWidth = bounds.width - 2 * lineWidth
        let labelHeight = bounds.height - bounds.width - 2 * lineWidth - standP
        let rectFrame = CGRect(x: lineWidth, y: labelHeight, width: mainWidth, height: bounds.width)
        let decoPath = UIBezierPath(roundedRect: rectFrame, cornerRadius: 0.6 * cornerRadius)
        decoPath.append(UIBezierPath(rect: CGRect(origin: rectFrame.origin, size: CGSize(width: mainWidth, height: rectFrame.height - 0.6 * cornerRadius))))
        decoLayer.path = decoPath.cgPath
        
        let margin = rectFrame.height * 0.05
        let imageLength = mainWidth * 0.8
        imageView.frame = CGRect(x: rectFrame.minX + 0.1 * mainWidth, y:  rectFrame.minY +  margin, width: imageLength, height: imageLength)
        textLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: labelHeight).insetBy(dx: 3 * standP, dy: 3 * standP)
        
        let infoY = imageView.frame.maxY + margin
        let remainedHeight = rectFrame.maxY - infoY - 0.8 * margin
        processView.frame = CGRect(x: rectFrame.minX + lineWidth, y: infoY + remainedHeight * 0.25, width: imageLength * 0.76, height: remainedHeight * 0.5)
        infoLabel.frame = CGRect(x: processView.frame.maxX + 0.5 * margin, y: infoY, width: rectFrame.maxX - processView.frame.maxX - 0.5 * margin - lineWidth, height: remainedHeight)
        // font
        textLabel.font = UIFont.systemFont(ofSize: labelHeight * 0.3, weight: UIFontWeightMedium)
        infoLabel.font = UIFont.systemFont(ofSize: remainedHeight * 0.8)
        
        // check mark
        let checkRect = CGRect(center: CGPoint(x: bounds.midX, y: imageView.frame.midY), length: imageLength * 0.6)
        checkLayer.frame = bounds
        checkLayer.lineWidth = 2 * standP
        checkLayer.path = UIBezierPath(ovalIn: checkRect).cgPath
        markImageView.frame = checkRect.insetBy(dx: imageLength * 0.1, dy: imageLength * 0.1)
        markImageView.layer.shadowRadius = 2 * standP
    }
}
