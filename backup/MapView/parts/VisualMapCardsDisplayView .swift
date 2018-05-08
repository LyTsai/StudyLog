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
            currentCard = 0
            setupArrowState()
            cardsView.cards = cards
        }
    }
    
    fileprivate let leftArrow = UIButton(type: .custom)
    fileprivate let rightArrow = UIButton(type: .custom)
    fileprivate var cardsView: VisualMapCardsCollectionView!
    class func createWithFrame(_ frame: CGRect, cardKeys: [String]) -> VisualMapCardsDisplayView {
        let view = VisualMapCardsDisplayView(frame: frame)
        let collection = VisualMapCardsCollectionView.createWithFrame(frame, cardKeys: cardKeys)
        collection.isScrollEnabled = false
        view.addSubview(collection)
        
        view.cardsView = collection
        view.addActions()
        
        return view
    }
    
    fileprivate func addActions() {
        let arrowLength = bounds.width * 0.08
        let arrowY = bounds.midY
        
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
    func goToLastCard() {
        if currentCard != 0 {
            currentCard -= 1
            moveToCard()
        }
    }
    
    func goToNextCard() {
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
        })
    }
    
    fileprivate func setupArrowState() {
        leftArrow.isHidden = (currentCard == 0)
        rightArrow.isHidden = (currentCard == cards.count - 1 || cards.count == 0)
    }
}
