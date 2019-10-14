//
//  CategoryCardsCollectionView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/10/23.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

// scale cells 
class CategoryCardsCollectionView: UICollectionView {
    weak var hostVC: CategoryResultViewController!

    var cards = [CardInfoObjModel]()
    var mainColor = UIColor.blue
    class func createWithFrame(_ frame: CGRect, cards: [CardInfoObjModel]) -> CategoryCardsCollectionView {
        // layout
        let scaleLayout = ScaleLayout()
        scaleLayout.itemSize = CGSize(width: frame.width * 0.7, height: frame.height * 0.95)
        scaleLayout.sectionInset = UIEdgeInsets(top: 0, left: frame.width * 0.25, bottom: 0, right: frame.width * 0.25)
        scaleLayout.minimumLineSpacing = -frame.width * 0.13
        
        // create
        let categoryCards = CategoryCardsCollectionView(frame: frame, collectionViewLayout: scaleLayout)
        categoryCards.backgroundColor = UIColor.clear
        categoryCards.cards = cards
        
        // register and delegate
        categoryCards.register(CardOptionCell.self, forCellWithReuseIdentifier: cardOptionCellID)
        categoryCards.dataSource = categoryCards
        categoryCards.delegate = categoryCards
        
        return categoryCards
    }
}

// dataSource
extension CategoryCardsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardOptionCellID, for: indexPath) as! CardOptionCell
        cell.mainColor = mainColor
        cell.isChosen = false // no need to mask
        cell.ratio = 0.65
        cell.textLines = 4
        
        let card = cards[indexPath.item]
        card.addMatchedImageOnImageView(cell.imageView)
        cell.textView.text = "\(card.cardTitle()): \(card.currentMatchedChoice())"
        cell.textView.textColor = UIColor.white
        cell.resultTag = card.judgementChoose()
        return cell
    }
}

// delegate
extension CategoryCardsCollectionView: UICollectionViewDelegate {
    // show cards
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if hostVC != nil {
             self.hostVC.showCardWithCardIndex(indexPath.item)
        }
    }
}
