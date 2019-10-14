//
//  AnsweredCardsCollectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/19.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class AnsweredCardsCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    class func createWithFrame(_ frame: CGRect) -> AnsweredCardsCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        // create view
        let answeredCards = AnsweredCardsCollectionView(frame: frame, collectionViewLayout: layout)
        answeredCards.setupCollectionView()
        
        return answeredCards
    }
    
    fileprivate func setupCollectionView() {
        self.bounces = false
        backgroundColor = UIColor.white
        showsVerticalScrollIndicator = false
        
        // regester
        register(CardResultImageCell.self, forCellWithReuseIdentifier: cardResultImageCellID)
        register(AnsweredCardsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: answeredCardsHeaderID)
        
        dataSource = self
        delegate = self
    }
    
    fileprivate var cardsInfo = [(iden: String, cards: [CardInfoObjModel])]()
    fileprivate var factorType: FactorType = .score
    fileprivate var measurement: MeasurementObjModel!
    func loadAllCardsWithMeasurement(_ measurement: MeasurementObjModel, factorType: FactorType) {
        self.measurement = measurement
        self.forAction = false
        
        self.factorType = factorType
        switch factorType {
        case .score:
            cardsInfo = MatchedCardsDisplayModel.getSortedScoreCardsInMeasurement(measurement, lowToHigh: false)
        case .complementary:
            cardsInfo = MatchedCardsDisplayModel.getSortedComplementaryCardsInMeasurement(measurement, lowToHigh: false)
        default: break
        }
        
        reloadData()
    }
    
    fileprivate var forAction = false
    func loadAllCardsForActionsWithMeasurement(_ measurement: MeasurementObjModel) {
        self.measurement = measurement
        self.forAction = true
        self.factorType = .score
        
        let lowGood = MatchedCardsDisplayModel.checkLowHighOfRisk(measurement.riskKey!)
        cardsInfo = MatchedCardsDisplayModel.getSortedScoreCardsInMeasurement(measurement, lowToHigh: !lowGood)
     
        reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cardsInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsInfo[section].cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardResultImageCellID, for: indexPath) as! CardResultImageCell
        let info = cardsInfo[indexPath.section]
        let card = (info.cards)[indexPath.item]
        cell.configureWithCard(card, mainColor: MatchedCardsDisplayModel.getColorOfIden(info.iden), factorType: factorType)
        
        cell.layer.addBlackShadow(3 * fontFactor)
        cell.layer.shadowOpacity = 0.5
        
        return cell
    }
    
    // header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: answeredCardsHeaderID, for: indexPath) as! AnsweredCardsHeader
        if forAction {
            header.configureForActionWithIden(cardsInfo[indexPath.section].iden)
        }else {
            switch factorType {
            case .score:
                let totalNumber = collection.getScoreCardsOfRisk(measurement.riskKey!).count
                var drawInfo =  [(number: Int, color: UIColor)]()
                for (iden, cards) in cardsInfo {
                    drawInfo.append((cards.count, MatchedCardsDisplayModel.getColorOfIden(iden)))
                }
                header.configureWithDrawInfo(drawInfo, totalNumber: totalNumber, focusing: indexPath.section)
            case .complementary:
                header.configureWithIden(cardsInfo[indexPath.section].iden)
            default:
                break
            }
        }
        
        return header
    }
    
    // size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lineNumber: CGFloat = 4
        let hMargin = forAction ? bounds.width * 0.08 : bounds.width * 0.04
        let vMargin = bounds.width * 0.03
        let spacing = bounds.width * 0.08
        let cellWidth = (bounds.width - 2 * hMargin - (lineNumber - 1) * spacing) / lineNumber
        
        // assign
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing * 0.6
        layout.sectionInset = UIEdgeInsets(top: vMargin, left: hMargin, bottom: vMargin, right: hMargin)
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        var headerHeight = cellWidth * 0.9
        if factorType != .score {
            headerHeight = cellWidth * 0.45
        }
        if forAction {
            headerHeight = cellWidth * 0.35
        }
        
        layout.headerReferenceSize = CGSize(width: frame.width, height: headerHeight)
        
        return layout.itemSize
    }
    
    
    // touch
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showCardForIndexPath(indexPath, duration: nil)
    }

    func showCardForIndexPath(_ indexPath: IndexPath, duration: TimeInterval!) {
        let reviewVC = PlayedCardsReviewViewController()
        reviewVC.loadWithCards(cardsInfo[indexPath.section].cards, index: indexPath.item, withDistribution: false)
        
        performBatchUpdates({
            self.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }) { (true) in
            self.viewController.presentOverCurrentViewController(reviewVC, completion: nil)
        }
    }
}
