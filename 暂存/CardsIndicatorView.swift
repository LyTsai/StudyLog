//
//  CardsIndicatorView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/24.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
class CardsIndicatorLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        register(CardsIndicatorDecorationView.self, forDecorationViewOfKind: cardsIndiDecorationID)
        minimumLineSpacing = 2
        minimumInteritemSpacing = 100
        
        sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrArray = super.layoutAttributesForElements(in: rect)
        
        if attrArray != nil {
   
            // is decoration added
            for i in 0..<collectionView!.numberOfSections {
                let attributes1 = layoutAttributesForDecorationView(ofKind: cardsIndiDecorationID, at: IndexPath(item: 0,section: i))
                if attributes1 == nil {
                    print("will be nil ???")
                    continue
                }
                attrArray!.append(attributes1!)
            }
        }
        
        return attrArray
    }
        
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attributes = super.layoutAttributesForItem(at: indexPath)
//    
//        
//        return attributes
//    }
//    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
        if elementKind == cardsIndiDecorationID {
            let attributes0 = layoutAttributesForItem(at: IndexPath(item: 0, section: indexPath.section))
            let attributes1 = layoutAttributesForItem(at: IndexPath(item: collectionView!.numberOfItems(inSection: indexPath.section) - 1, section: indexPath.section))
            let x0 = attributes0!.frame.minX
            let x1 = attributes1!.frame.maxX
            
            layoutAttributes?.size = CGSize(width: x1 - x0, height: collectionView!.bounds.height)
            layoutAttributes?.center = CGPoint(x: (x1 + x0) * 0.5, y: collectionView!.bounds.midY)
            layoutAttributes?.zIndex = -1
        }
        
        return layoutAttributes
    }
}

// MARK: --------- view of indicator -------------
class CardsIndicatorView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    // key: Section, value: item
    var cardAnswers = [Int: Int]()
    var currentSection = 0 {
        didSet{
            if currentSection != oldValue {
                reloadSections([currentSection, oldValue])
                assessmentViewDelegate.resetMaskPath()
            }
        }
    }
    
    weak var assessmentViewDelegate: AssessmentTopView!
    
    class func createWithFrame( _ frame: CGRect) -> CardsIndicatorView{
        let collection = CardsIndicatorView(frame: frame, collectionViewLayout: CardsIndicatorLayout())
        collection.backgroundColor = UIColor.clear
        
        // register
        collection.register(CardsIndicatorCell.self, forCellWithReuseIdentifier: cardsIndicatorCellID)
        
        // delegate
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    fileprivate let cardFactory = VDeckOfCardsFactory.metricDeckOfCards

    // MARK: -------------------- data source -------------------
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cardFactory.totalNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let card = cardFactory.getVCard(section)!
        if card.cardStyleKey == JudgementCardTemplateView.styleKey() {
            return 2
        }
        
        return card.cardOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardsIndicatorCellID, for: indexPath) as! CardsIndicatorCell
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    fileprivate func configureCell(_ cell: CardsIndicatorCell, indexPath: IndexPath) {
        let answer = cardAnswers[indexPath.section]
        
        if indexPath.section == currentSection {
            cell.state = .unselected
            if answer != nil && answer == indexPath.item {
                cell.state = .selected
            }
            
        }else {
            if answer == nil {
                cell.state = .unanswered
            }else {
                cell.state = .notAnswer
                if answer == indexPath.item {
                    cell.state = .isAnswer
                }
            }
        }
    }
    
    // MARK: --------------------- delegate -------------------
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // cards
        assessmentViewDelegate.goToCard(indexPath.section)
    }
    
    
    // MARK: ------------------ methods -------------------
    func scrollSectionToCenter(_ section: Int) {
        let itemNumber = numberOfItems(inSection: section)
        let middleIndexPath = IndexPath(item: itemNumber / 2, section: section)
        
        if itemNumber % 2 != 0 {
            performBatchUpdates({ 
                self.scrollToItem(at: middleIndexPath, at: .centeredHorizontally, animated: true)
            }, completion: nil)
        }else {
            // adjust offset if necessary
            let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
            var totalX: CGFloat = 0
            for i in 0..<section {
                let number = CGFloat(numberOfItems(inSection: i))
                let subLength = layout.sectionInset.left + layout.sectionInset.right + number * layout.itemSize.width + (number - 1) * layout.minimumLineSpacing
                totalX += subLength
            }
            
            let passedItems = CGFloat(itemNumber / 2)
            totalX += layout.sectionInset.left + passedItems * layout.itemSize.width + (passedItems - 0.5) * layout.minimumLineSpacing
            
            // show in center
            totalX -= bounds.width * 0.5
            
            let adjustedRect = CGRect(x: totalX, y: 0, width: bounds.width, height: bounds.height)
            scrollRectToVisible(adjustedRect, animated: true)
        }
        
    }
}

// size adjust
extension CardsIndicatorView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemNumbers = CGFloat(collectionView.numberOfItems(inSection: indexPath.section))
        let flow = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (collectionView.frame.width / 3 - 20 - flow.minimumLineSpacing * (itemNumbers - 1)) / itemNumbers
        
        return CGSize(width: itemWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let sectionWidth = collectionView.frame.width / 3
        // adjust section here??
        if collectionView.numberOfSections == 1 {
            sectionInset = UIEdgeInsets(top: 0, left: sectionWidth, bottom: 0, right: sectionWidth)
        }else if collectionView.numberOfSections == 2 {
            sectionInset = UIEdgeInsets(top: 0, left: sectionWidth / 4, bottom: 0, right: sectionWidth / 4)
        }
        
        return sectionInset
    }
    
}
