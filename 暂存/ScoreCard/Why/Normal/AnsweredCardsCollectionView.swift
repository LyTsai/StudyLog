//
//  AnsweredCardsCollectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/19.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class AnsweredCardsCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var cardsInfo = [(iden: String, cards: [CardInfoObjModel])]()
    var totalNumber: Int = 0
    
    class func createWithFrame(_ frame: CGRect) -> AnsweredCardsCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        // create view
        let answeredCards = AnsweredCardsCollectionView(frame: frame, collectionViewLayout: layout)
        answeredCards.backgroundColor = UIColor.white
        answeredCards.showsVerticalScrollIndicator = false
        // regester
        answeredCards.register(DuplicatedCardsCell.self, forCellWithReuseIdentifier: duplicatedCardsCellID)
        answeredCards.register(AnsweredCardsHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: answeredCardsHeaderID)

        answeredCards.dataSource = answeredCards
        answeredCards.delegate = answeredCards
        
        return answeredCards
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cardsInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsInfo[section].cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: duplicatedCardsCellID, for: indexPath) as! DuplicatedCardsCell
        let card = (cardsInfo[indexPath.section].cards)[indexPath.item]
        cell.configureWithImageUrl(card.currentImageUrl(), borderColor: MatchedCardsDisplayModel.getColorOfIden(cardsInfo[indexPath.section].iden), resultTag: card.judgementChoose(), showBaseline: card.showBaseline())

        cell.layer.addBlackShadow(3 * fontFactor)
        cell.layer.shadowOpacity = 0.5
        
        return cell
    }
    
    // header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: answeredCardsHeaderID, for: indexPath) as! AnsweredCardsHeader
        var drawInfo =  [(number: Int, color: UIColor)]()
        for (iden, cards) in cardsInfo {
            drawInfo.append((cards.count, MatchedCardsDisplayModel.getColorOfIden(iden)))
        }
        header.configureWithDrawInfo(drawInfo, totalNumber: totalNumber, focusing: indexPath.section)
    
        return header
    }
    
    // size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = bounds.width * 0.08
        let cellWidth = bounds.width / 4 - spacing
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing * 0.6
        layout.sectionInset = UIEdgeInsets(top: spacing * 0.2, left: spacing * 0.5, bottom: spacing, right: spacing * 0.5)
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth / 1.2)
        layout.headerReferenceSize = CGSize(width: frame.width, height: cellWidth * 1.4)
        
        return layout.itemSize
    }
    
    
    // touch
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showCardForIndexPath(indexPath, duration: nil)
    }

    func showCardForIndexPath(_ indexPath: IndexPath, duration: TimeInterval!) {
        let reviewVC = PlayedCardsReviewViewController()
        reviewVC.loadWithCards(cardsInfo[indexPath.section].cards, index: indexPath.item, withDistribution: false)
        reviewVC.modalPresentationStyle = .overCurrentContext
        
        performBatchUpdates({
            self.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }) { (true) in
            self.viewController.present(reviewVC, animated: true, completion: {

            })
        }
    }
}
