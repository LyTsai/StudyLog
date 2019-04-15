//
//  CartCardsView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/13.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CartCardsCollectionView: UICollectionView {
    weak var hostCell: CartTableCell!

    // [dataSource]
    fileprivate var cards = [MatchedCardsDisplayModel] ()
    fileprivate var color = UIColor.blue
    fileprivate var selectedIndexes = [Int]()
    fileprivate var selectedCards = [MatchedCardsDisplayModel()]
    
    class func createWithFrame(_ frame: CGRect, cards: [MatchedCardsDisplayModel], color: UIColor) -> CartCardsCollectionView {
        // layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let hMargin = 12 * frame.width / 357
        let vMargin = 10 * frame.height / 165
        layout.minimumLineSpacing = hMargin
        layout.minimumInteritemSpacing = 1000
        layout.sectionInset = UIEdgeInsets(top: vMargin, left: hMargin, bottom: vMargin * 0.4, right: hMargin)
        layout.itemSize = CGSize(width: (frame.width - 4 * hMargin) / 3, height: frame.height - 1.4 * vMargin)
        
        // create
        let cartView = CartCardsCollectionView(frame: frame, collectionViewLayout: layout)
        cartView.backgroundColor = UIColor.clear
        cartView.cards = cards
        cartView.color = color
        
        // register
        cartView.register(CartCollectionCell.self, forCellWithReuseIdentifier: cartCollectionCellID)
        
        // delegate
        cartView.dataSource = cartView
        cartView.delegate = cartView
        
        return cartView
    }
    
    func reloadWithCards(_ cards: [MatchedCardsDisplayModel], color: UIColor) {
        self.cards = cards
        self.color = color
        
        if hostCell != nil {
            let cardKeys = Array(hostCell.hostTable.hostVC.getAllSelectedCardsInfo().keys)
            selectedIndexes.removeAll()
            for (i, card) in cards.enumerated() {
                if cardKeys.contains(card.cardInfo.key) {
                    selectedIndexes.append(i)
                }
            }
        }
        
        reloadData()
    }
    
    // re layout 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let hMargin = 12 * bounds.width / 357
        let vMargin = 10 * bounds.height / 165

        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = hMargin
        layout.sectionInset = UIEdgeInsets(top: vMargin, left: hMargin, bottom: vMargin * 0.4, right: hMargin)
        layout.itemSize = CGSize(width: (bounds.width - 4 * hMargin) / 3, height: bounds.height - 1.4 * vMargin)
    }
}

// MARK: ----------------- data Source -----------------------
extension CartCardsCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cartCollectionCellID, for: indexPath) as! CartCollectionCell
        cell.setupWithMatched(cards[indexPath.item], color: color)
        cell.isChosen = selectedIndexes.contains(indexPath.item)
        
        return cell
    }

}

// MARK: ----------------- delegate -----------------------
extension CartCardsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // cards
        let card = cards[indexPath.item]

        // indexed
        if selectedIndexes.contains(indexPath.item) {
            for (i, index) in selectedIndexes.enumerated() {
                if index == indexPath.item {
                    selectedIndexes.remove(at: i)
                    break
                }
            }
            
            for (i, selectedCard) in hostCell.hostTable.hostVC.selectedCards.enumerated() {
                if selectedCard.cardInfo.key == card.cardInfo.key {
                    hostCell.hostTable.hostVC.selectedCards.remove(at: i)
                    break
                }
            }
        }else {
            selectedIndexes.append(indexPath.item)
            hostCell.hostTable.hostVC.selectedCards.append(card)
        }
        
        performBatchUpdates({ 
            self.reloadItems(at: [indexPath])
        }, completion: nil)
    }
}
