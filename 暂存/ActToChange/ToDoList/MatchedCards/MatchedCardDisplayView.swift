//
//  MatchedCardDisplayView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/28.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class MatchedCardDisplayView: UIView {
    fileprivate var cardsCollectionView: UICollectionView!
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
    // current card on show
    var currentIndex: Int = 0 {
        didSet{
            goToCardAt(currentIndex)
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

        // shadow
        
        // sizes
        let marginX = bounds.width * 0.12
        let gap = bounds.width * 0.02
        
        // collection
        let collectionFrame = CGRect(x: gap, y: gap, width: bounds.width - 2 * gap, height: bounds.height - gap - bounds.height * 0.18)
        let layout = ScaleLayout()
        layout.itemSize = CGSize(width: collectionFrame.width - 2 * marginX, height: collectionFrame.height)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = marginX
        layout.sectionInset = UIEdgeInsets(top: 0, left: marginX, bottom: 0, right: marginX)
        cardsCollectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        cardsCollectionView.backgroundColor = UIColor.clear
        cardsCollectionView.isScrollEnabled = false
        
        cardsCollectionView.register(MatchedCardsCollectionViewCell.self, forCellWithReuseIdentifier: matchedCardsCellID)
        
        cardsCollectionView.dataSource = self
        cardsCollectionView.delegate = self
        
        addSubview(cardsCollectionView)
        
        // gestures
        let nextSwipe = UISwipeGestureRecognizer(target: self, action: #selector(goToNextCard))
        nextSwipe.direction = .left
        cardsCollectionView.addGestureRecognizer(nextSwipe)
        
        let lastSwipe = UISwipeGestureRecognizer(target: self, action: #selector(goToLastCard))
        lastSwipe.direction = .right
        cardsCollectionView.addGestureRecognizer(lastSwipe)
        
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
        for (_, cards) in MatchedCardsDisplayModel.getSortedClassifiedCards(cards) {
            self.cards.append(contentsOf: cards)
        }
        
        self.riskTypeKey = riskTypeKey
        cardsCollectionView.reloadData()
        currentIndex = 0
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
    
    // move
    fileprivate var risks = [RiskObjModel]()
    fileprivate var riskIndex = 0
    fileprivate func goToCardAt(_ index: Int) {
        if cards.count == 0 || index < 0 || index > cards.count || currentIndex > cards.count {
            return
        }
        
        let card = cards[index]
        cardsCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        setupArrowState()
        
        risksCollection.risks = card.connectedRisks()
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
        cell.configureWithCard(cards[indexPath.item], index: indexPath.item, total: cards.count)
        
        return cell
    }
}

extension MatchedCardDisplayView: UICollectionViewDelegate {
    
}
