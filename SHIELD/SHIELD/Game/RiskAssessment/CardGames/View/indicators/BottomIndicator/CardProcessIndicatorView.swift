//
//  CardProcessIndicatorView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/10/13.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class CardProcessIndicatorView: UICollectionView {
    weak var cardPlayDelegate: AssessmentTopView!
    
    var currentItem: Int = 1 {
        didSet{
            if currentItem != oldValue {
                let currentIndexPath = IndexPath(item: currentItem, section: 0)
                performBatchUpdates({
                    self.reloadItems(at: [IndexPath(item: oldValue, section: 0), currentIndexPath])
                }, completion: { (true) in
                    self.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: true)
                })
            }
        }
    }
   
    var allCards = [CardInfoObjModel]() {
        didSet{
            numberOfNodes = allCards.count
        }
    }
    
    var numberOfNodes: Int = 0 {
        didSet {
            reloadData()
        }
    }
    var usedForCards = true
    class func createWithFrame(_ frame: CGRect) -> CardProcessIndicatorView {
        // layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        // MARK: -------- line interithem
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: frame.height * 1.2, height: frame.height)
        flowLayout.sectionInset = UIEdgeInsets.zero
        
        // create
        let collection = CardProcessIndicatorView(frame: frame, collectionViewLayout: flowLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.bounces = false
        collection.isScrollEnabled = false
        
        collection.register(CardProcessCell.self, forCellWithReuseIdentifier: cardIndexCellID)
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    func answeredForItem(_ item: Int) {
        var indexPaths = [IndexPath(item: item, section: 0)]
        performBatchUpdates({
            if item == 1 {
                indexPaths.append(IndexPath(item: 0, section: 0))
            }
            self.reloadItems(at: indexPaths)
        }, completion: nil)
    }
}

// data source
extension CardProcessIndicatorView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfNodes + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardIndexCellID, for: indexPath) as! CardProcessCell
        
        // cells
        if usedForCards {
            if indexPath.item == 0 {
                // check
                var answered = false
                if let firstCard = allCards.first {
                    if firstCard.currentPlayed() {
                        answered = true
                    }
                }
                
                cell.setupForFirst(answered)
            }else if indexPath.item == numberOfItems(inSection: 0) - 1 {
                let played = MatchedCardsDisplayModel.getCurrentMatchedCardsFromCards(allCards)
                cell.setupForLast(allCards.count == played.count)
            }else {
                let card = allCards[indexPath.item - 1]
                cell.setupWithIndex(indexPath.item, answered: card.currentPlayed() , current: indexPath.item == currentItem)
            }
        }else {
            cell.setAsProcess()
            // normal process
            if indexPath.item == 0 {
                cell.setupForFirst(true)
            }else if indexPath.item == numberOfItems(inSection: 0) - 1 {
                cell.setupForLast(indexPath.item == currentItem)
            }else {
                cell.setupWithIndex(indexPath.item, answered: indexPath.item <= currentItem, current: indexPath.item == currentItem)
            }
        }
        
        return cell
    }
}

// delegate
extension CardProcessIndicatorView: UICollectionViewDelegateFlowLayout {
    // max == 10 or according to height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = min(bounds.width / 10, bounds.height * 1.2)

        var leftW = bounds.height * 0.5
        var rightW = cellWidth * 0.9
        let contentWidth = cellWidth * CGFloat(numberOfItems(inSection: 0) - 2) + leftW + rightW
        if contentWidth < bounds.width {
            let gap = (bounds.width - contentWidth) * 0.5
            leftW += gap
            rightW += gap
        }
        
        // sizes
        if indexPath.item == 0 {
            return CGSize(width: leftW, height: bounds.height)
        }else if indexPath.item == numberOfItems(inSection: 0) - 1 {
            return CGSize(width: rightW, height: bounds.height)
        }else {
            return CGSize(width: cellWidth, height: bounds.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // left-half   cards   right-half
        let index = indexPath.item
        
        if index == 0 || index == numberOfNodes + 1 {
            return
        }
        
        if index != currentItem && usedForCards {
            cardPlayDelegate.goToCard(index - 1)
        }
    }
}
