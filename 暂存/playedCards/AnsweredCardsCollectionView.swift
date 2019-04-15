//
//  AnsweredCardsCollectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/19.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class AnsweredCardsCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    weak var detailView: ScorecardDetailView!
    var riskKey: String! {
        didSet{
            totalNumber = collection.getSortedCardsForRiskKey(riskKey).count
            cardsInfo = MatchedCardsDisplayModel.getHighLowClassifiedCardsOfRisk(riskKey, userKey: userCenter.currentGameTargetUser.Key())
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
        cell.resultTag = card.judgementChoose()
        cell.isChosen = (need && currentIndexPath != nil && indexPath == currentIndexPath)
        cell.mainColor = MatchedCardsDisplayModel.getColorOfIden(cardsInfo[indexPath.section].iden)
        cell.imageUrl = card.currentImageUrl()
        cell.layer.addBlackShadow(3 * fontFactor)
        cell.layer.shadowOpacity = 0.5
        
        return cell
    }
    
    // header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let info = cardsInfo[indexPath.section]
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: answeredCardsHeaderID, for: indexPath) as! AnsweredCardsHeader
        var drawInfo =  [(number: Int, color: UIColor)]()
        for (iden, cards) in cardsInfo {
            drawInfo.append((cards.count, MatchedCardsDisplayModel.getColorOfIden(iden)))
        }
        header.configureWithClassificationName(MatchedCardsDisplayModel.getNormalizedNameOfIden(info.iden), suffix: "Score Cards:", drawInfo: drawInfo, totalNumber: totalNumber, focusing: indexPath.section)
    
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
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.headerReferenceSize = CGSize(width: frame.width, height: cellWidth * 0.75)
        
        return layout.itemSize
    }
    
    
    // touch
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showCardForIndexPath(indexPath, duration: nil)
        if timer != nil {
            let su = superview as! ScorecardDetailView
            if su.autoPlay {
                su.setupAutoPlayState()
            }
        }
    }
    fileprivate var currentIndexPath: IndexPath!
    fileprivate var need = true
    func showCardForIndexPath(_ indexPath: IndexPath, duration: TimeInterval!) {
        need = true
        currentIndexPath = indexPath
        let card = cardsInfo[indexPath.section].cards[indexPath.item]
        
        // card change view
        let changeVC = CardAnswerChangeViewController()
        changeVC.duration = duration
        changeVC.forChange = false
        changeVC.loadWithCard(card)
        changeVC.modalPresentationStyle = .overCurrentContext
        
        performBatchUpdates({
            self.reloadItems(at: [indexPath])
            self.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }) { (true) in
            self.viewController.present(changeVC, animated: true, completion: { (true) in
                self.need = false
                self.performBatchUpdates({
                    self.reloadItems(at: [indexPath])
                }, completion: nil)
            })
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if detailView.autoPlay {
            detailView.setupAutoPlayState()
        }
    }
    
    fileprivate var timer: Timer!
    func startAutoPlay() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true, block: { (timer) in
                self.showCardForIndexPath(self.nextIndexPath(), duration: 6)
            })
        }
        
//        else {
//            // fire
//            timer.fireDate = Date(timeInterval: 2, since: Date())
//        }
    }
    
    func pause() {
        if timer != nil {
            timer.invalidate()
            timer = nil
//            timer.fireDate = .distantFuture
        }
    }
    
    func nextIndexPath() -> IndexPath {
        if currentIndexPath == nil {
            return IndexPath(item: 0, section: 0)
        }else {
            var item = currentIndexPath.item
            var section = currentIndexPath.section
            
            let maxS = numberOfSections - 1
            let maxI = numberOfItems(inSection: section) - 1
            
            if item < maxI {
                // current section, next item
                item += 1
            }else {
                // next or first section, first item
                item = 0
                if section < maxS {
                    section += 1
                }else {
                    section = 0
                }
            }
            
            return IndexPath(item: item, section: section)
        }
    }
}
