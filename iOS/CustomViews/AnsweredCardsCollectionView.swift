//
//  AnsweredCardsCollectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/19.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class AnsweredCardsCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var riskKey: String! {
        didSet{
            totalNumber = collection.getSortedCardsForRiskKey(riskKey).count
            cardsInfo = MatchedCardsDisplayModel.getSortedClassifiedCardsOfRisk(riskKey)
            reloadData()
        }
    }
    
    fileprivate var cardsInfo = [(iden: String, cards: [CardInfoObjModel])]()
    fileprivate var totalNumber: Int = 0
    
    class func createWithFrame(_ frame: CGRect) -> AnsweredCardsCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        // create view
        let answeredCards = AnsweredCardsCollectionView(frame: frame, collectionViewLayout: layout)
        answeredCards.backgroundColor = UIColor.white
        
        // regester
        answeredCards.register(CardOptionCell.self, forCellWithReuseIdentifier: cardOptionCellID)
        answeredCards.register(AnsweredCardsHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: answeredCardsHeaderID)
//        answeredCards.register(AnsweredCardsFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: answeredCardsFooterID)
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardOptionCellID, for: indexPath) as! CardOptionCell
        let card = (cardsInfo[indexPath.section].cards)[indexPath.item]
        cell.ratio = 1
        cell.isChosen = false
        cell.mainColor = MatchedCardsDisplayModel.getColorOfIden(cardsInfo[indexPath.section].iden)
        cell.imageUrl = card.currentImageUrl()
        cell.layer.addBlackShadow(3 * fontFactor)
        cell.layer.shadowOpacity = 0.5
        
        return cell
    }
    
    // header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let info = cardsInfo[indexPath.section]
        
//        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: answeredCardsHeaderID, for: indexPath) as! AnsweredCardsHeader
            header.configureWithText("\(MatchedCardsDisplayModel.getNameOfIden(info.iden)) cards: \(info.cards.count)", textColor: MatchedCardsDisplayModel.getColorOfIden(info.iden))

            return header
//        }else {
//            // footer
//            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: answeredCardsFooterID, for: indexPath) as! AnsweredCardsFooter
//            var drawInfo =  [(number: Int, color: UIColor)]()
//            for (iden, cards) in cardsInfo {
//                drawInfo.append((cards.count, MatchedCardsDisplayModel.getColorOfIden(iden)))
//            }
//
//            footer.configureWithDrawInfo(drawInfo, totalNumber: totalNumber, focusing: indexPath.section)
//
//            return footer
//        }
    }
    
    // size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = bounds.width * 0.08
        let cellWidth = bounds.width / 4 - spacing
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing * 0.6
        layout.sectionInset = UIEdgeInsets(top: spacing * 0.2, left: spacing * 0.5, bottom: spacing * 0.2, right: spacing * 0.5)
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.headerReferenceSize = CGSize(width: frame.width, height: cellWidth * 0.45)
        layout.footerReferenceSize = CGSize(width: frame.width, height: cellWidth * 0.7)
        
        return layout.itemSize
    }
    
    
    // touch
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = cardsInfo[indexPath.section].cards[indexPath.item]
   
        // card change view
        let changeVC = CardAnswerChangeViewController()
//            SingleCardViewController()
        changeVC.forChange = false
        changeVC.loadWithCard(card)
//        changeVC.card = card
//        changeVC.indexPath = indexPath
//        changeVC.presentFrom = self
        changeVC.modalPresentationStyle = .overCurrentContext
        
        viewController.present(changeVC, animated: true, completion: nil)
    }
    
}
