//
//  VisualMapCardsDisplayView .swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/12.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VisualMapCardsDisplayView: UIView {
    var cards = [String]() {
        didSet{
            setupArrowState()
            cardsView.cards = cards
            if cards.count != 0 {
                currentCard = 0
                moveToCard()
            }
        }
    }
    
    fileprivate let leftArrow = UIButton(type: .custom)
    fileprivate let rightArrow = UIButton(type: .custom)
    fileprivate var cardsView: VisualMapCardsCollectionView!
    fileprivate var risksCollection: MatchedCardsRisksCollectionView!
    class func createWithFrame(_ frame: CGRect, cardKeys: [String]) -> VisualMapCardsDisplayView {
        let view = VisualMapCardsDisplayView(frame: frame)
        
        // cards
        let cardsFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height * 0.75)
        let cardsCollection = VisualMapCardsCollectionView.createWithFrame(cardsFrame, cardKeys: cardKeys)
        cardsCollection.isScrollEnabled = false
        view.addSubview(cardsCollection)
        
        // risks
        let risksCollection = MatchedCardsRisksCollectionView.createWithFrame(CGRect(x: 0, y: frame.height * 0.8, width: frame.width, height: frame.height * 0.2))
        risksCollection.textColor = UIColor.black
        view.addSubview(risksCollection)
        
        view.risksCollection = risksCollection
        view.cardsView = cardsCollection
        view.addActions()
        
        return view
    }
    
    fileprivate func addActions() {
        let arrowLength = bounds.width * 0.08
        let arrowY = bounds.midY * 0.8
        
        leftArrow.setBackgroundImage(UIImage(named: "match_left"), for: .normal)
        leftArrow.frame = CGRect(x: 0, y: arrowY, width: arrowLength, height: arrowLength)
        
        rightArrow.setBackgroundImage(UIImage(named: "match_right"), for: .normal)
        rightArrow.frame = CGRect(x: bounds.width - arrowLength, y: arrowY, width: arrowLength, height: arrowLength)
        
        leftArrow.addTarget(self, action: #selector(goToLastCard), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(goToNextCard), for: .touchUpInside)
        
        addSubview(leftArrow)
        addSubview(rightArrow)
        
        // swipe
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(goToLastCard))
        swipeBack.direction = .right
        
        let swipeNext = UISwipeGestureRecognizer(target: self, action: #selector(goToNextCard))
        swipeNext.direction = .left
        
        addGestureRecognizer(swipeBack)
        addGestureRecognizer(swipeNext)
        
        // state
        setupArrowState()
    }
    
    
    fileprivate var currentCard = 0
    @objc func goToLastCard() {
        if currentCard != 0 {
            currentCard -= 1
            moveToCard()
        }
    }
    
    @objc func goToNextCard() {
        if currentCard != cards.count - 1 {
            currentCard += 1
            moveToCard()
        }
    }
    
    fileprivate func moveToCard() {
        cardsView.performBatchUpdates({
            cardsView.scrollToItem(at: IndexPath(item: self.currentCard, section: 0), at: .centeredHorizontally, animated: true)
        }, completion: { (true) in
            self.setupArrowState()
            var risks = [RiskObjModel]()
            for riskKey in collection.getRisksContainsCard(self.cards[self.currentCard]) {
                risks.append(collection.getRisk(riskKey))
            }
            self.risksCollection.risks = risks
        })
    }
    
    fileprivate func setupArrowState() {
        leftArrow.isHidden = (currentCard == 0)
        rightArrow.isHidden = (currentCard == cards.count - 1 || cards.count == 0)
    }
}
