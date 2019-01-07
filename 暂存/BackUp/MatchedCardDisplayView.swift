//
//  MatchedCardDisplayView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/28.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class MatchedCardDisplayView: UIView {
    
    fileprivate let titleLabel = UILabel()
    fileprivate var cardsCollectionView: UICollectionView!
    fileprivate var cards = [CardInfoObjModel]()
    fileprivate var riskTypeKey: String!
    fileprivate let leftArrow = UIButton(type: .custom)
    fileprivate let rightArrow = UIButton(type: .custom)
    fileprivate var currentIndex: Int = 0
        
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
        let areaEdgeInset = UIEdgeInsets(top: 73, left: 15, bottom: 18, right: 15)
        let backImageView = UIImageView(image: UIImage(named: "resultDisplay_back"))
        backImageView.frame = bounds
        addSubview(backImageView)
        
        // space left
        let remainedSize = CGSize(width: bounds.width - areaEdgeInset.left - areaEdgeInset.right, height: bounds.height - areaEdgeInset.top - areaEdgeInset.bottom)
        titleLabel.frame = CGRect(x: areaEdgeInset.left, y: 5, width: remainedSize.width, height: 60)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        addSubview(titleLabel)
        
        // collection
        let layout = ScaleLayout()
        layout.itemSize = CGSize(width: remainedSize.width * 0.8, height: remainedSize.height * 0.9)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: remainedSize.height * 0.05, left: remainedSize.width * 0.1, bottom: remainedSize.height * 0.05, right: remainedSize.width * 0.1)
        cardsCollectionView = UICollectionView(frame: CGRect(x: areaEdgeInset.left, y: areaEdgeInset.top, width: remainedSize.width, height: remainedSize.height), collectionViewLayout: layout)
        cardsCollectionView.backgroundColor = UIColor.clear
        
        cardsCollectionView.register(MatchedCardsCollectionViewCell.self, forCellWithReuseIdentifier: matchedCardsCellID)
        
        cardsCollectionView.dataSource = self
        cardsCollectionView.delegate = self
        
        addSubview(cardsCollectionView)
        
        // arrows
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
    
    // update
    func reloadWithCards(_ cards: [CardInfoObjModel], riskTypeKey: String, index: Int!) {
        self.cards = cards
        self.riskTypeKey = riskTypeKey
        titleLabel.text = "Number Of Cards Matched: \(cards.count)"
        cardsCollectionView.reloadData()
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

}

// MARK: ------------------ dataSource
extension MatchedCardDisplayView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchedCardsCellID, for: indexPath) as! MatchedCardsCollectionViewCell
        cell.configureWithCard(cards[indexPath.item], riskTypeKey: riskTypeKey)
        
        return cell
    }
}

extension MatchedCardDisplayView: UICollectionViewDelegate {
    
}
