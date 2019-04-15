//
//  MatchedCardsDisplayView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/23.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class MatchedCardsDisplayView: UIView {

    weak var seeHowHost: SeeHowCardsView!
    
    // index and changes
    var currentIndex: Int = 0 {
        didSet{
            if currentIndex != oldValue {
                headerCollectionView.chosenItem = currentIndex
                cardsCollectionView.currentIndex = currentIndex
                setupArrowState()
                
                // change cards
                if seeHowHost != nil {
                    seeHowHost.updateWithCard(cards[currentIndex])
                }
            }
        }
    }

    // data source
    fileprivate var cardTexts = [String]()
    fileprivate var cards = [MatchedCardsDisplayModel]() {
        didSet{
            cardTexts.removeAll()
            for card in cards {
                cardTexts.append(card.headerTitle)
            }
        }
    }
    
    // create
    fileprivate var cardsCollectionView: MatchedCardsCollectionView!
    fileprivate var headerCollectionView: ScrollHeaderCollectionView!
    fileprivate let leftArrow = UIButton(type: .custom)
    fileprivate let rightArrow = UIButton(type: .custom)
    func setupWithFrame(_ frame: CGRect, cardEdgeInsets: UIEdgeInsets, cards: [MatchedCardsDisplayModel], withAssess: Bool) {
        self.frame = frame
        self.cards = cards
        
        // scroll header
        headerCollectionView = ScrollHeaderCollectionView.createHeaderWithFrame(CGRect(x: 0, y: 0, width: bounds.width, height: cardEdgeInsets.top), textsOnShow: cardTexts)
        headerCollectionView.matchedViewDelegate = self
    
        // cards
        let collectionFrame = CGRect(x: 0, y: cardEdgeInsets.top, width: bounds.width, height: bounds.height - cardEdgeInsets.top - cardEdgeInsets.bottom)
        let collectionInsets = UIEdgeInsets(top: 1, left: cardEdgeInsets.left, bottom: 2, right: cardEdgeInsets.right)
        cardsCollectionView = MatchedCardsCollectionView.createWithFrame(collectionFrame ,cardEdgeInsets: collectionInsets, cards: cards, withAssess: withAssess)
        
        // add
        addSubview(headerCollectionView)
        addSubview(cardsCollectionView)
        
        // gestures
        let nextSwipe = UISwipeGestureRecognizer(target: self, action: #selector(goToNextCard))
        nextSwipe.direction = .left
        cardsCollectionView.addGestureRecognizer(nextSwipe)
        
        let lastSwipe = UISwipeGestureRecognizer(target: self, action: #selector(goToLastCard))
        lastSwipe.direction = .right
        cardsCollectionView.addGestureRecognizer(lastSwipe)
        
        // arrow
        let arrowLength = 47 * bounds.width / 375
        let arrowMargin = (cardEdgeInsets.left - arrowLength) * 0.5
        let arrowY = collectionFrame.midY - arrowLength * 0.5
        
        leftArrow.setBackgroundImage(UIImage(named: "match_left"), for: .normal)
        leftArrow.frame =  CGRect(x: arrowMargin, y: arrowY, width: arrowLength, height: arrowLength)
        
        rightArrow.setBackgroundImage(UIImage(named: "match_right"), for: .normal)
        rightArrow.frame = CGRect(x: bounds.width - arrowLength - arrowMargin, y: arrowY, width: arrowLength, height: arrowLength)
        
        leftArrow.addTarget(self, action: #selector(goToLastCard), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(goToNextCard), for: .touchUpInside)
        
        addSubview(leftArrow)
        addSubview(rightArrow)
        
        setupArrowState()
    }

    // action
    func goToNextCard() {
        if currentIndex != cards.count - 1 {
            currentIndex += 1
        }
    }

    func goToLastCard() {
        if currentIndex != 0 {
            currentIndex -= 1
        }
    }
    
    // the arrows
    fileprivate func setupArrowState() {
        // only one card, hide arrows
        if cards.count == 1 {
            leftArrow.isHidden = true
            rightArrow.isHidden = true
        }else {
            // more than one card
            if currentIndex == 0 {
                leftArrow.isHidden = true
                rightArrow.isHidden = false
            }else if currentIndex == cards.count - 1 {
                leftArrow.isHidden = false
                rightArrow.isHidden = true
            }else {
                leftArrow.isHidden = false
                rightArrow.isHidden = false
            }
        }
    }

    // MARK: ------ reset
    func reloadWithCards(_ cards: [MatchedCardsDisplayModel]) {
        self.cards = cards
        currentIndex = 0
        setupArrowState()
        
        headerCollectionView.textsOnShow = cardTexts
        cardsCollectionView.cards = cards
    }
}


extension MatchedCardsDisplayView {
    func adjustForSeeHow()  {
        headerCollectionView.removeFromSuperview()
        
        // arrows
        let arrowWidth = 28 * bounds.width / 375
        let arrowHeight = 90 * bounds.width / 375
        let arrowY = cardsCollectionView.frame.midY - arrowHeight * 0.5
        
        let leftFrame = CGRect(x: 0, y: arrowY, width: arrowWidth, height: arrowHeight)
        let rightFrame = CGRect(x: bounds.width - arrowWidth, y: arrowY, width: arrowWidth, height: arrowHeight)
        
        leftArrow.setBackgroundImage(UIImage(named: "move_to_left"), for: .normal)
        rightArrow.setBackgroundImage(UIImage(named: "move_to_right"), for: .normal)
        leftArrow.frame = leftFrame
        rightArrow.frame = rightFrame
    }
}
