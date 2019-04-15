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
        
        // sizes
        let marginX = bounds.width * 0.12
        let gap = bounds.width * 0.02
        
        // collection
        let collectionFrame = CGRect(x: gap, y: gap, width: bounds.width - 2 * gap, height: bounds.height - gap - bounds.height * 0.18)
        let cardSize = CGSize(width: collectionFrame.width - 2 * marginX, height: collectionFrame.height)
        cardsCollectionView = CardsResultDisplayCollectionView.createWithFrame(collectionFrame, cardSize: cardSize, showAssess: false)
        cardsCollectionView.currentCardIsChanged = currentCardIsChanged
        addSubview(cardsCollectionView)
        
        // arrows
        let arrowLength = marginX * 0.7
        let arrowMargin = gap + (marginX - arrowLength) * 0.2
        let arrowY = collectionFrame.midY - arrowLength * 0.5
        
        leftArrow.setBackgroundImage(UIImage(named: "match_left"), for: .normal)
        leftArrow.frame =  CGRect(x: arrowMargin, y: arrowY, width: arrowLength, height: arrowLength)
        
        rightArrow.setBackgroundImage(UIImage(named: "match_right"), for: .normal)
        rightArrow.frame = CGRect(x: bounds.width - arrowLength - arrowMargin, y: arrowY, width: arrowLength, height: arrowLength)
        
        leftArrow.addTarget(self, action: #selector(goToLastCard), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(goToNextCard), for: .touchUpInside)
        
        addSubview(leftArrow)
        addSubview(rightArrow)
        
        // bottom
        sepLine.frame = CGRect(x: 0, y: collectionFrame.maxY + gap, width: bounds.width, height: fontFactor)
        sepLine.backgroundColor = lineColor
        addSubview(sepLine)
        
        // risks
        let bottomFrame = CGRect(x: gap, y: sepLine.frame.maxY + gap, width: bounds.width - 4 * gap, height: bounds.height - sepLine.frame.maxY - gap * 2)
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

