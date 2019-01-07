//
//  MatchedCardsCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/16.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
// MARK: ------------ cell ----------------
let matchedCardsCellID = "matched cards cell identifier"
class MatchedCardsCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate let card = MatchedCardView()
    fileprivate func updateUI() {
        contentView.addSubview(card)
    }
    
    // MARK: --------- configure cell for matched/ seeHow
    func setupWithMatchedCard(_ matchedCard: MatchedCardsDisplayModel, withAssess: Bool)  {
        card.matchedCard = matchedCard
        
        // for see how
        if withAssess {
            if let classification = matchedCard.classification {
                card.adjustCardBackWithScore(classification.score ?? 0)
            }else {
                card.adjustCardBackWithScore(Float(matchedCard.results.first! + 1))
            }
        }else {
            card.layer.shadowOpacity = 0.8
            card.layer.shadowColor = UIColor.black.cgColor
            card.layer.shadowOffset = CGSize(width: 0, height: 2)
            card.layer.shadowRadius = 2
            
            card.hideSide(true)
        }
    }
    
    func setupCartMatchedCard(_ matchedCard: MatchedCardsDisplayModel, byCategory: Bool)  {
        card.matchedCard = matchedCard
        
        // for see how
        if byCategory {
            card.layer.shadowOpacity = 0.8
            card.layer.shadowColor = UIColor.black.cgColor
            card.layer.shadowOffset = CGSize(width: 0, height: 2)
            card.layer.shadowRadius = 2
            
            card.hideSide(true)
        }else {
      
            card.hideSide(false)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        card.frame = bounds
        card.layer.shadowPath = UIBezierPath(rect: bounds.insetBy(dx: 0, dy: 2)).cgPath // the top of card is part-clear
    }
}


// MARK: ------------ collection view -------------------
class MatchedCardsCollectionView: UICollectionView {
    var cards = [MatchedCardsDisplayModel]() {
        didSet{
            currentIndex = 0
            reloadData()
        }
    }
    
    var currentIndex = 0 {
        didSet{
            if currentIndex < 0 || currentIndex > cards.count - 1 {
                return
            }
            
            if currentIndex != oldValue {
                performBatchUpdates({
                    self.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: true)
                }, completion: nil)
            }
        }
    }
    fileprivate var withAssess = false
    class func createWithFrame(_ frame: CGRect, cardEdgeInsets: UIEdgeInsets, cards: [MatchedCardsDisplayModel], withAssess: Bool) -> MatchedCardsCollectionView {
        // layout
        let layout = ScaleLayout()
        layout.itemSize = CGSize(width: frame.width - cardEdgeInsets.left - cardEdgeInsets.right, height: frame.height - cardEdgeInsets.top - cardEdgeInsets.bottom)
        layout.minimumLineSpacing = cardEdgeInsets.left * 1.2
        layout.sectionInset = cardEdgeInsets
        
        // create
        let collection = MatchedCardsCollectionView(frame: frame, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        collection.cards = cards
        collection.withAssess = withAssess
        collection.register(MatchedCardsCell.self, forCellWithReuseIdentifier: matchedCardsCellID)
        collection.isScrollEnabled = false
        
        // delegate
        collection.dataSource = collection
        
        return collection
    }
}

extension MatchedCardsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchedCardsCellID, for: indexPath) as! MatchedCardsCell
        cell.setupWithMatchedCard(cards[indexPath.item], withAssess: withAssess)
        
        return cell
    }
}
