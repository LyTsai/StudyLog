//
//  PlayedGamesCells.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/14.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MARK: --------- last game cell ------------------
class LastGameView: UIView {
    weak var hostVC: MatchedCardsOverallViewController!
    fileprivate var risk: RiskObjModel!
    class func createWithFrame(_ frame: CGRect, risk: RiskObjModel) -> LastGameView {
        let lastGame = LastGameView(frame: frame)
        lastGame.setupWithRisk(risk)
        
        return lastGame
    }
    
    fileprivate func setupWithRisk(_ risk: RiskObjModel) {
        backgroundColor = UIColor.clear
        self.risk = risk
        let riskClass = risk.metric
        
        // TODO: ------- color from riskClass or risk
        let mainColor = UIColorFromRGB(255, green: 197, blue: 0)
        
        // size
        let standardW = bounds.width / 375
        let standardH = bounds.height / 214

        // create
        // title on top
        let titleLabel = UILabel(frame: CGRect(x: 30 * standardW , y: 0, width: bounds.width -  30 * standardW, height: 36 * standardH))
        titleLabel.text = "Last Game Played"
        titleLabel.font = UIFont.systemFont(ofSize: 12 * standardH, weight: UIFontWeightSemibold)
        
        // card
        let offset = 5 * standardH
        let cardFrame = CGRect(x: 5 * standardW, y: titleLabel.frame.maxY, width: bounds.width * 0.37, height: bounds.height - titleLabel.frame.maxY)
        let cardContainer = UIImageView(frame: cardFrame)
        cardContainer.image = UIImage(named: "matched_cardBack")
        let singleFrame = CGRect(x: 3.2 * offset, y: 0, width: cardFrame.width - 6.4 * offset, height: cardFrame.height - 6 * offset)
        
        var cardKey = JudgementCardTemplateView.styleKey()
        var vCard = CardInfoObjModel()
        
        let deckOfCards = AIDMetricCardsCollection.standardCollection.getMetricCardOfRisk(risk.key)
        if deckOfCards.last != nil {
            vCard = deckOfCards.last!
            cardKey = vCard.cardStyleKey!
        }
        
        let cardView = CardTemplateManager.sharedManager.createCardTemplateWithKey(cardKey, frame: cardContainer.bounds)
        
        if cardKey == JudgementCardTemplateView.styleKey() {
            cardView.frame = singleFrame
        } else {
            cardView.cardFrame = singleFrame
        }
        
        cardContainer.addSubview(cardView)
        cardView.setCardContent(vCard, defaultSelection: vCard.cardOptions.first)
        
        // sep line
        var detailX = 8 * standardW + cardFrame.maxX
        let detailY = titleLabel.frame.maxY
        
        let sepLineView = UIView(frame: CGRect(x: detailX, y: detailY, width: 3 * standardW, height: bounds.height * 0.4))
        sepLineView.backgroundColor = mainColor
        
        detailX += offset
        
        // right part
        // risk class info
        let textColor = UIColorFromRGB(136, green: 136, blue: 157)
        let labelWidth = bounds.width - detailX - 10 * standardW
        
        let riskClassLabel = UILabel(frame: CGRect(x: detailX, y: detailY, width: labelWidth, height: 40 * standardH))
        riskClassLabel.numberOfLines = 0
        riskClassLabel.text = "\(riskClass?.name ?? "") Assessment"
        riskClassLabel.textColor = textColor
        riskClassLabel.font = UIFont.systemFont(ofSize: 16 * standardH, weight: UIFontWeightSemibold)
        // risk info
        let riskNameLabel = UILabel(frame: CGRect(x: detailX, y: riskClassLabel.frame.maxY, width: labelWidth, height: 18 * standardH))
        riskNameLabel.textColor = textColor
        riskNameLabel.font = UIFont.systemFont(ofSize: 14 * standardH, weight: UIFontWeightSemibold)
        riskNameLabel.text = risk.name
        // author info
        let authorNameLabel = UILabel(frame: CGRect(x: detailX, y: riskNameLabel.frame.maxY, width: labelWidth, height: 15 * standardH))
        authorNameLabel.textColor = textColor
        authorNameLabel.font = UIFont.systemFont(ofSize: 12 * standardH, weight: UIFontWeightSemibold)
        authorNameLabel.text = risk.author.displayName
        // date info
        let dateLabel = UILabel(frame: CGRect(x: detailX, y: authorNameLabel.frame.maxY, width: labelWidth, height: 12 * standardH))
        dateLabel.textColor = textColor
        dateLabel.font = UIFont.systemFont(ofSize: 10 * standardH, weight: UIFontWeightSemibold)
        
        let format = DateFormatter()
        format.dateFormat = "MMM dd, yyyy"
        dateLabel.text = "on \(format.string(from: Date()))"
        
        // comments and likes
        
        
        // add
        addSubview(cardContainer)
        addSubview(riskClassLabel)
        addSubview(riskNameLabel)
        addSubview(sepLineView)
        addSubview(dateLabel)
        addSubview(titleLabel)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(goToCards))
        addGestureRecognizer(tapGR)
    }
    
    func goToCards()  {
        if hostVC != nil {
            hostVC.goToSelectedMatchedCards(risk)
        }
    }
}


// MARK: --------- played game cell ------------------
let playedGameCellID = "played game cell ID"
class PlayedGameCell: BasicCollectionViewCell {

    var riskName: String! {
        didSet {
            if riskName != oldValue {
                riskNameLabel.text = text
            }
        }
    }
    
    var authorInfo: String! {
        didSet{
            if authorInfo != oldValue {
                riskAuthorLabel.text = authorInfo
            }
        }
    }
    
    
    var mainColor = UIColor.white {
        didSet{
            if mainColor != oldValue {
                backView.backgroundColor = mainColor
                sepLineView.backgroundColor = mainColor
                backView.layer.borderColor = mainColor.cgColor
            }
        }
    }
    
    var date: Date! {
        didSet{
            if date != oldValue {
                let format = DateFormatter()
                format.dateFormat = "MMM dd, yyyy"
                riskDateLabel.text = "on \(format.string(from: date))"
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
    
//    fileprivate let backImageView = UIImageView(image: UIImage(named: "sketchBack"))
    fileprivate let riskNameLabel = UILabel()
    fileprivate let riskAuthorLabel = UILabel()
    fileprivate let riskDateLabel = UILabel()
    fileprivate let sepLineView = UIView()
    fileprivate let backView = UIView()
    fileprivate let imageBackView = UIView()
    fileprivate let deleteImageView = UIImageView(image: UIImage(named: "icon_deleteItem"))
    
    override func updateUI() {
        super.updateUI()
    
        backView.layer.borderWidth = 2
        backView.layer.cornerRadius = 5
        backView.layer.masksToBounds = true
        
        riskNameLabel.numberOfLines = 0
        
        let textColor = UIColorFromRGB(136, green: 136, blue: 157)
        riskNameLabel.textColor = textColor
        riskDateLabel.textColor = textColor
        riskAuthorLabel.textColor = UIColorFromRGB(104, green: 159, blue: 56)
        
        deleteImageView.isHidden = true
        
        imageBackView.backgroundColor = UIColor.white
        
        backView.addSubview(imageBackView)
        backView.addSubview(textLabel)
        backView.addSubview(imageView)
        
        contentView.addSubview(sepLineView)
        contentView.addSubview(backView)
        contentView.addSubview(riskNameLabel)
        contentView.addSubview(riskDateLabel)
        contentView.addSubview(riskAuthorLabel)
        contentView.addSubview(deleteImageView)
    }
    
    // 101 * 128, card: 82 * 115
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        
        let standardW = bounds.width / 112
        let standardH = bounds.height / 200
        let mainWidth = 98 * standardW
        let margin = (bounds.width - mainWidth) * 0.5
        let topHeight = 44 * standardH
        
        let offset = 4 * standardW
        deleteImageView.frame = CGRect(center: CGPoint(x: margin + offset, y: margin + offset), length: margin + 2 * offset)
        
        let backFrame = CGRect(x: margin, y: margin, width: mainWidth, height: 130 * standardH)
        backView.frame = backFrame
        textLabel.frame = CGRect(x: 2, y: 2, width: mainWidth - 4, height: topHeight)
        textLabel.font = UIFont.systemFont(ofSize: 10 * standardH, weight: UIFontWeightMedium)
        
        imageBackView.frame = CGRect(x: 0, y: topHeight + 2, width: mainWidth, height: backFrame.height - topHeight - 4)
        imageView.frame = imageBackView.frame.insetBy(dx: 5, dy: 5)
    
        sepLineView.frame = CGRect(x: margin, y: backFrame.maxY, width: 1, height: bounds.height - backFrame.maxY)
     
        // risk info
        let detailX = margin + 2
        let labelFrame1 = CGRect(x: detailX, y: backFrame.maxY + 5 * standardH, width: mainWidth, height: 32 * standardH)
        riskNameLabel.frame = labelFrame1
        riskNameLabel.font = UIFont.systemFont(ofSize: 12 * standardH, weight: UIFontWeightMedium)
        
        // author info
        let labelFrame2 = CGRect(x: detailX, y: labelFrame1.maxY, width: mainWidth, height: 15 * standardH)
        riskAuthorLabel.frame = labelFrame2
        riskAuthorLabel.font = UIFont.systemFont(ofSize: 11 * standardH)

        // date info
        riskDateLabel.frame = CGRect(x: detailX, y: labelFrame2.maxY, width: mainWidth, height: bounds.height - labelFrame2.maxY)
        riskDateLabel.font =  UIFont.systemFont(ofSize: (bounds.height - labelFrame2.maxY) * 0.8, weight: UIFontWeightSemibold)
    }
    
//    func askForDelete() {
//        
//    }
}

// MARK: --------- header View ------------------
let playedGameHeaderID = "played game header ID"
class PlayedGameHeaderView: UICollectionReusableView {
    weak var hostCollection: MatchedCardsOverallCollectoinView!
    
    fileprivate let textLabel = UILabel()
    fileprivate let editButton = UIButton(type: .custom)
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
    }
    
    func editPlayedGames(_ button: UIButton)  {
        button.isSelected = !button.isSelected
        hostCollection.isEditing = button.isSelected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel.frame = CGRect(x: 20, y: 0, width: bounds.width * 0.4, height: bounds.height)
        textLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.45, weight: UIFontWeightSemibold)
        
        editButton.frame = CGRect(center: CGPoint(x: bounds.width * 0.9 , y: bounds.midY), width: bounds.width * 0.15, height: bounds.height * 0.7)

        editButton.titleLabel?.font = UIFont.systemFont(ofSize: bounds.height * 0.5)
    }
}
