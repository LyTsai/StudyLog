//
//  MatchedCardsRoadCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/30.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let matchedCardsRoadCellID = "matched cards road cell identifier"
class MatchedCardsRoadCell: ImageAndTextViewCell {
    func setupWithType(_ factorType: FactorType) {
        switch factorType {
        case .bonus:
            indexLabel.isHidden = true
            complementaryRoot.isHidden = true
            bonusRoot.isHidden = false
            borderImageView.image = #imageLiteral(resourceName: "bonus_border")
            baseCard.image = #imageLiteral(resourceName: "bonus_border")
            backLayer.isHidden = true
            
            baseCard.backgroundColor = UIColor.clear
            baseCard.layer.borderColor = UIColor.clear.cgColor
        case .complementary:
            indexLabel.isHidden = true
            complementaryRoot.isHidden = false
            bonusRoot.isHidden = true
            borderImageView.image = #imageLiteral(resourceName: "complementary_border")
            baseCard.image = #imageLiteral(resourceName: "complementary_border")
            backLayer.isHidden = true
            
            baseCard.backgroundColor = UIColor.clear
            baseCard.layer.borderColor = UIColor.clear.cgColor
        default:
            backLayer.isHidden = false
            indexLabel.isHidden = false
            complementaryRoot.isHidden = true
            bonusRoot.isHidden = true
            borderImageView.image = nil
            baseCard.image = nil
            baseCard.backgroundColor = UIColor.white
            baseCard.layer.borderColor = UIColorFromHex(0x83F9E5).cgColor
        }
    }
    
    var isChosen = false {
        didSet{
            maskLayer.isHidden = !isChosen
        }
    }

    var resultTag: Bool! {
        didSet{
            if resultTag != oldValue {
                if resultTag == nil {
                    resultLabel.isHidden = true
                }else {
                    resultLabel.isHidden = false
                    resultLabel.text = resultTag ? "ME" : "NOT ME"
                    resultLabel.backgroundColor = resultTag ? UIColorFromRGB(61, green: 59, blue: 238) : UIColorFromRGB(204, green: 123, blue: 0) 
                }
            }
        }
    }
    
    var showBaseline = false {
        didSet {
            baseCard.isHidden = !showBaseline
        }
    }
    
    // subviews
    fileprivate let indexLabel = UILabel()
    fileprivate let maskLayer = CAShapeLayer()
    fileprivate let lineView = UIView()
    fileprivate let resultLabel = UILabel()
    fileprivate let tagImageView = UIImageView()
    
    fileprivate let bonusRoot = UIImageView(image: #imageLiteral(resourceName: "bonus_index"))
    fileprivate let borderImageView = UIImageView(image: #imageLiteral(resourceName: "bonus_border"))
    fileprivate let complementaryRoot = UIImageView(image: #imageLiteral(resourceName: "complementary_root"))
    
    fileprivate let baseCard = UIImageView() // baseline card
    
    // add subviews and layers
    override func updateUI() {
        super.updateUI()
        
        indexLabel.textAlignment = .center
        complementaryRoot.contentMode = .scaleAspectFit
        
        // colors and border
        textView.textAlignment = .left
        
        lineView.backgroundColor = UIColor.black
        indexLabel.layer.borderColor = UIColor.black.cgColor
        indexLabel.layer.masksToBounds = true
        maskLayer.fillColor = UIColor.black.withAlphaComponent(0.3).cgColor
  
        backLayer.fillColor = UIColor.white.cgColor

        baseCard.layer.masksToBounds = true
        
        // add
        contentView.addSubview(lineView)
        contentView.addSubview(baseCard)
        backLayer.removeFromSuperlayer()
        contentView.layer.addSublayer(backLayer)
        
        borderImageView.contentMode = .scaleAspectFit
        contentView.addSubview(borderImageView)
        contentView.bringSubviewToFront(imageView)
        
        resultLabel.textAlignment = .center
        resultLabel.backgroundColor = UIColorFromRGB(61, green: 59, blue: 238)
        resultLabel.isHidden = true
        resultLabel.layer.masksToBounds = true
        resultLabel.layer.borderColor = UIColor.black.cgColor
        resultLabel.textColor = UIColor.white
        contentView.addSubview(resultLabel)
        
        contentView.addSubview(complementaryRoot)
        contentView.addSubview(indexLabel)
        contentView.addSubview(bonusRoot)
        
        contentView.layer.addSublayer(maskLayer)
        
        tagImageView.contentMode = .scaleAspectFit
        contentView.addSubview(tagImageView)
    }
    
    // layout, textWidth = 2.2 * imageWidth
    // indi 20, image 64
    fileprivate var mainLength: CGFloat = 0
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let length = bounds.height
        let gap = length * 0.05
        let labelWidth = mainLength - length - gap
        textView.frame = CGRect(x: bounds.width - labelWidth , y: 0, width: labelWidth, height: bounds.height)
        let one = length / 65
        
        setText()
        
        let imageFrame = CGRect(x: bounds.width - mainLength, y: 0, width: length, height: length).insetBy(dx: length * 0.02, dy: length * 0.02) // a little gap: 6
        backLayer.lineWidth = one * 2
        backLayer.path = UIBezierPath(roundedRect: imageFrame, cornerRadius: length * 0.1).cgPath
        
        baseCard.frame = CGRect(x: imageFrame.minX - imageFrame.width * 0.2, y: imageFrame.minY, width: imageFrame.width, height: imageFrame.height).insetBy(dx: one * 1.5, dy: one * 1.5)
        baseCard.layer.borderWidth = one * 2
        baseCard.layer.cornerRadius = length * 0.1
        
        maskLayer.path = UIBezierPath(roundedRect: imageFrame, cornerRadius: length * 0.05).cgPath
        
        borderImageView.frame = imageFrame
        let inset = imageFrame.width * 0.15
        imageView.frame = imageFrame.insetBy(dx: inset, dy: inset)
        
        tagImageView.frame = CGRect(center: CGPoint(x: imageFrame.minX, y: imageFrame.minY + 10 * one), width: 35 * one, height: 41 * one)
        
        // check
        resultLabel.frame = CGRect(x: imageFrame.minX + 2 * one, y: imageFrame.minY + 2 * one, width: 45 * one, height: 12 * one)
        resultLabel.layer.borderWidth = one
        resultLabel.font = UIFont.systemFont(ofSize: 9 * one, weight: .semibold)
        resultLabel.layer.cornerRadius = 6 * one
        
        // line
        let indiWidth = length * 0.32
        indexLabel.frame = CGRect(center: CGPoint(x: indiWidth * 0.5, y: bounds.midY), length: indiWidth)
        indexLabel.layer.cornerRadius = indiWidth * 0.5
        indexLabel.layer.borderWidth = length * 0.02
        indexLabel.font = UIFont.systemFont(ofSize: indiWidth * 0.45)
        
        lineView.frame = CGRect(x: indexLabel.frame.midX, y: indexLabel.frame.midY, width: imageView.frame.midX - indexLabel.frame.midX, height: length * 0.02)
        
        // 49 * 54
        let bonusH = imageFrame.midY * 54 / 42
        bonusRoot.frame = CGRect(x: 0, y: 0, width: bonusH / 54 * 49, height: bonusH)
        
        // 42 * 54, 42
        complementaryRoot.frame = CGRect(x: 0, y: 0, width: bonusH / 54 * 96, height: bonusH)
    }
    
    fileprivate func setText() {
        let one = bounds.height / 65
        
        if answer != "" {
            let textSize = 12 * one
            let attributed = NSMutableAttributedString(string:"\(question)\n", attributes: [ .font: UIFont.systemFont(ofSize: textSize, weight: .light)])
            if resultTag == nil {
                let tag = #imageLiteral(resourceName: "icon_legend")
                let imageText = NSTextAttachment()
                imageText.image = tag
                imageText.bounds = CGRect(x: 0, y: 0, width: textSize * 17 / 16, height: textSize)
                
                attributed.append(NSAttributedString(attachment: imageText))
                attributed.append(NSMutableAttributedString(string: "\(answer)", attributes: [ .font: UIFont.systemFont(ofSize: textSize, weight: .medium)]))
            }
            
            textView.attributedText = attributed
        }else {
            textView.font = UIFont.systemFont(ofSize: 12 * one, weight: .semibold)
        }
    }
    
    // set up
    func configureWithCard(_ card: CardInfoObjModel, mainColor: UIColor, index: Int, mainLength: CGFloat) {
        // image
        card.addMatchedImageOnImageView(imageView)
        indexLabel.text = "\(index + 1)"
        indexLabel.backgroundColor = UIColorFromRGB(126, green: 211, blue: 33)
        
        // layer
        backLayer.strokeColor = mainColor.cgColor
        setTextWithAnswer(card.currentMatchedChoice(), question: card.cardTitle())
        resultTag = card.judgementChoose()
        setText()
        
        // played
        if let match = card.currentMatch() {
            tagImageView.sd_setImage(with: match.classification?.previewImageUrl, placeholderImage: nil, options: .refreshCached, completed: nil)
        }else {
            tagImageView.image = nil
        }
        
        self.mainLength = mainLength
    }
}
