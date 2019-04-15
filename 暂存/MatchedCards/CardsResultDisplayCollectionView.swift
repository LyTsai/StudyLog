//
//  CardsResultDisplayCollectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/14.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class CardsResultDisplayCollectionView: UICollectionView {
    var currentCardIsChanged: (()->())?
    
    // create
    fileprivate var showAssess = false
    class func createWithFrame(_ frame: CGRect, cardSize: CGSize, showAssess: Bool) -> CardsResultDisplayCollectionView {
        // collection layout
        let marginX = (frame.width - cardSize.width) * 0.5
        let marginY = (frame.height - cardSize.height) * 0.5
        let layout = ScaleLayout()
        layout.minRatio = 0.8
        layout.itemSize = cardSize
        layout.minimumLineSpacing = marginX
        layout.sectionInset = UIEdgeInsets(top: marginY, left: marginX, bottom: marginY, right: marginX)
        
        // create
        let cardsCollectionView = CardsResultDisplayCollectionView(frame: frame, collectionViewLayout: layout)
        cardsCollectionView.backgroundColor = UIColor.clear
        cardsCollectionView.isScrollEnabled = false
        
        cardsCollectionView.register(MatchedCardsCollectionViewCell.self, forCellWithReuseIdentifier: matchedCardsCellID)
        
        cardsCollectionView.dataSource = cardsCollectionView
        cardsCollectionView.delegate = cardsCollectionView
        cardsCollectionView.addSwipes()
        
        return cardsCollectionView
    }
    
    fileprivate func addSwipes() {
        // gestures
        let nextSwipe = UISwipeGestureRecognizer(target: self, action: #selector(goToNextCard))
        nextSwipe.direction = .left
        addGestureRecognizer(nextSwipe)
        
        let lastSwipe = UISwipeGestureRecognizer(target: self, action: #selector(goToLastCard))
        lastSwipe.direction = .right
        addGestureRecognizer(lastSwipe)
    }
    
    // update
    var cardOnShow: Int {
        return currentIndex
    }
    fileprivate var currentIndex = 0
    fileprivate var cards = [CardInfoObjModel]()
    func loadCards(_ cards: [CardInfoObjModel], firstCardIndex: Int) {
        if firstCardIndex < 0 && firstCardIndex <= cards.count {
            return
        }
        self.cards = cards
        reloadData()
        
        goToCardAt(firstCardIndex)
    }
    
    // action
    @objc func goToNextCard() {
        if currentIndex != cards.count - 1 {
            goToCardAt(currentIndex + 1)
        }
    }
    
    @objc func goToLastCard() {
        if currentIndex != 0 {
            goToCardAt(currentIndex - 1)
        }
    }
    
    fileprivate func goToCardAt(_ index: Int) {
        currentIndex = index
        scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        currentCardIsChanged?()
    }
    
    func endCurrentCard() {
        if let current = cellForItem(at: IndexPath(item: cardOnShow, section: 0)) {
            if let cardCell = current as? MatchedCardsCollectionViewCell {
                cardCell.endShow()
            }
        }
    }
}

// MARK: ------------------ dataSource
extension CardsResultDisplayCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchedCardsCellID, for: indexPath) as! MatchedCardsCollectionViewCell
        cell.configureWithCard(cards[indexPath.item], index: indexPath.item, total: cards.count)
        if showAssess {
            cell.showClassification()
        }
        
        return cell
    }
}

extension CardsResultDisplayCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cardCell = cell as? MatchedCardsCollectionViewCell {
            cardCell.onShow()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cardCell = cell as? MatchedCardsCollectionViewCell {
            cardCell.endShow()
        }
    }
}
