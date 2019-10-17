//
//  MatchedCardDisplayView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/28.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class MatchedCardDisplayView: UIView {
    var cardsCollectionView: CardsResultDisplayCollectionView!
    fileprivate var risksCollection: MatchedCardsRisksCollectionView!
    fileprivate var cards = [CardInfoObjModel]()
    fileprivate var riskTypeKey: String!
    fileprivate let leftArrow = UIButton(type: .custom)
    fileprivate let rightArrow = UIButton(type: .custom)
    fileprivate let sepLine = UIView()
    
    var lineColor = UIColorFromRGB(123, green: 228, blue: 8) {
        didSet{
            layer.borderColor = lineColor.cgColor
            sepLine.backgroundColor = lineColor
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addAllViews()
    }
    
    fileprivate func addAllViews() {
        // back
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addBorder(UIColorFromRGB(123, green: 228, blue: 8), cornerRadius: 8 * fontFactor, borderWidth: fontFactor, masksToBounds: false)
        
        let topH = bounds.height * 0.82
        let gap = fontFactor * 3
        // collection
        let collectionFrame = CGRect(x: 0, y: 0, width: bounds.width, height: topH).insetBy(dx: gap, dy: gap)
        let cardSize = CGSize(width: collectionFrame.width * 0.98, height: collectionFrame.height)
        cardsCollectionView = CardsResultDisplayCollectionView.createWithFrame(collectionFrame, cardSize: cardSize, showAssess: false)
        cardsCollectionView.currentCardIsChanged = currentCardIsChanged
        addSubview(cardsCollectionView)
        
        // arrows
        let arrowW = bounds.width * 0.06
        let arrowH = arrowW * 75 / 23
        let arrowY = collectionFrame.midY - arrowH * 0.5
        
        leftArrow.setBackgroundImage(UIImage(named: "left_rect"), for: .normal)
        leftArrow.frame =  CGRect(x: fontFactor, y: arrowY, width: arrowW, height: arrowH)
        
        rightArrow.setBackgroundImage(UIImage(named: "right_rect"), for: .normal)
        rightArrow.frame = CGRect(x: bounds.width - arrowW - fontFactor, y: arrowY, width: arrowW, height: arrowH)
        
        leftArrow.layer.addBlackShadow(4 * fontFactor)
        leftArrow.layer.shadowOpacity = 0.5
        rightArrow.layer.addBlackShadow(4 * fontFactor)
        rightArrow.layer.shadowOpacity = 0.5
        
        leftArrow.addTarget(self, action: #selector(goToLastCard), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(goToNextCard), for: .touchUpInside)
        
        addSubview(leftArrow)
        addSubview(rightArrow)
        
        // bottom
        sepLine.frame = CGRect(x: 0, y: collectionFrame.maxY + gap, width: bounds.width, height: fontFactor)
        sepLine.backgroundColor = lineColor
        addSubview(sepLine)
        
        // risks
        let bottomFrame = CGRect(x: 0, y: sepLine.frame.maxY, width: bounds.width, height: bounds.height - sepLine.frame.maxY).insetBy(dx: gap, dy: gap)
        risksCollection = MatchedCardsRisksCollectionView.createWithFrame(bottomFrame)
        addSubview(risksCollection)
    }
    
    // update
    func reloadWithCards(_ cards: [CardInfoObjModel], riskTypeKey: String) {
        self.cards.removeAll()
        for (_, cards) in MatchedCardsDisplayModel.getNumberSortedClassifiedCards(cards) {
            self.cards.append(contentsOf: cards)
        }
        
        self.riskTypeKey = riskTypeKey
        cardsCollectionView.loadCards(cards, firstCardIndex: 0)
        currentIndex = 0
        currentCardIsChanged()
    }

    // action
    @objc func goToNextCard() {
        if currentIndex != cards.count - 1 {
            cardsCollectionView.goToNextCard()
        }
    }
    
    @objc func goToLastCard() {
        if currentIndex != 0 {
            cardsCollectionView.goToLastCard()
        }
    }
    
    // current card on show
    fileprivate var currentIndex: Int = 0
    func currentCardIsChanged() {
        currentIndex = cardsCollectionView.cardOnShow
        let card = cards[currentIndex]
        risksCollection.risks = card.connectedRisks()
        
        leftArrow.isHidden = (currentIndex == 0)
        rightArrow.isHidden = (cards.count == 1 || (currentIndex == cards.count - 1))
    }
}

