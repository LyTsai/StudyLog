//
//  MatchedCardsCollectionViewCell.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/28.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

// cell
let matchedCardsCellID = "matched Cards Cell Identifier"
class MatchedCardsCollectionViewCell: UICollectionViewCell {
    fileprivate var cardView: JudgementCardTemplateView!
    fileprivate var indexLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        // card
        cardView = JudgementCardTemplateView()
        cardView.leftButton.isHidden = true
        cardView.rightButton.isHidden = true
        
        // index
        indexLabel.textAlignment = .center
        
        // add
        contentView.addSubview(cardView)
        contentView.addSubview(indexLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cardView.frame = bounds
        cardView.layoutSubviews()
        
        indexLabel.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height * 0.9), width: bounds.width * 0.4, height: bounds.height * 0.08)
        indexLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.04)
    }
    
    func configureWithCard(_ card: CardInfoObjModel, index: Int!, total: Int!) {
        let styleKey = card.cardStyleKey!
        
        if card.isJudgementCard() {
            cardView.withPrompt = false
        }else {
            cardView.withPrompt = (styleKey != SpinningMultipleChoiceCardsTemplateView.styleKey())
            cardView.forIIA = (styleKey == IIAMultipleChoiceTemplateView.styleKey())
        }
        
        cardView.setCardContent(card, defaultSelection: card.currentOption())
        cardView.setupCardBackAndStyles()

        // missing url and me/not me
        if card.isJudgementCard() {
            cardView.descriptionView.detail = card.currentMatchedText()
            cardView.descriptionView.mainImageUrl = card.currentImageUrl()
        }
   
        // index
        if index != nil && total != nil {
            indexLabel.text = "\(index + 1) / \(total!)"
        }
        
        layoutSubviews()
    }
    
    func showClassification() {
        let iden = cardView.vCard.currentIdentification()
        let color = MatchedCardsDisplayModel.getColorOfIden(iden)
        cardView.descriptionView.chosenColor = color
        cardView.descriptionView.isChosen = true
    }
    
    func onShow() {
        cardView.beginToShow()
    }
    func endShow() {
        cardView.endShow()
    }
}
