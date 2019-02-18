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
        cardView.confirmButton.isHidden = true
        cardView.denyButton.isHidden = true
        
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
        cardView.setCardContent(card, defaultSelection: card.currentOption())
        cardView.setupCardBackAndStyles()
        
        let match = card.currentMatch()!
        // card
        cardView.flipButton.isHidden = (card.note == nil)
        cardView.infoDetailView.text = card.note
        cardView.descriptionView.detail = match.statement
        cardView.descriptionView.title = match.name ?? "Disease"
        cardView.descriptionView.mainImageUrl = match.imageUrl
        cardView.hintPerson = nil
        
        // missing url
        if card.cardStyleKey == PromptMultipleChoiceTemplateView.styleKey() || card.cardStyleKey == IIAMultipleChoiceTemplateView.styleKey() || card.cardStyleKey == HintMultipleChoiceTemplateView.styleKey() {
            cardView.descriptionView.detail = card.title ?? ""
        }else if card.cardStyleKey == JudgementCardTemplateView.styleKey() || card.cardStyleKey == PromptJudgementCardTemplateView.styleKey(){
            cardView.descriptionView.detail = card.currentMatchedText()
            cardView.descriptionView.mainImageUrl = card.currentImageUrl()
        }
        
        // special
        let backStyle = collection.getCardViewBackStyleOfCard(card.key)
        if backStyle == .blueZone || backStyle == .negativeBE || backStyle == .positiveBE {
            cardView.descriptionView.title = ""
            cardView.descriptionView.detail = card.currentMatchedText()
        }
   
        // index
        if index != nil && total != nil {
            indexLabel.text = "\(index + 1) / \(total!)"
        }
        
        layoutSubviews()
    }
}
