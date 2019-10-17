//
//  SummaryOfCardsRoadCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/9/4.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// winding road
class SummaryOfCardsRoadCollectionView: WindingRoadCollectionView {
    weak var hostVC: UIViewController!
    fileprivate var endPoint = CGPoint.zero
    // situation
    var forMatched = false
    
    // data source
    var cards = [CardInfoObjModel]()
    var chosenIndex: Int = -1
    fileprivate var mainColor = UIColor.blue

    fileprivate var forCart = false
    fileprivate let textFont = UIFont.systemFont(ofSize: 12, weight: .bold)
    fileprivate var cardLength: CGFloat = 65
    fileprivate var startX: CGFloat = 135
    fileprivate var firstTop: CGFloat = 100
    
    // factory
    class func createWithFrame(_ frame: CGRect, cards: [CardInfoObjModel], mainColor: UIColor, forCart: Bool, cardLength: CGFloat, startX: CGFloat, firstTop: CGFloat) -> SummaryOfCardsRoadCollectionView {
        let layout = BlockFlowLayout()
        
        let roadCollectionView = SummaryOfCardsRoadCollectionView(frame: frame, collectionViewLayout: layout)
        roadCollectionView.backgroundColor = UIColor.clear
        layout.dataSource = roadCollectionView
        
        // assign
        roadCollectionView.mainColor = mainColor
        roadCollectionView.cards = cards
        roadCollectionView.forCart = forCart
        roadCollectionView.cardLength = cardLength
        roadCollectionView.startX = startX
        roadCollectionView.firstTop = firstTop
        
        roadCollectionView.forMatched = false
        roadCollectionView.bounces = false
        
        // add and data
        roadCollectionView.setupBackgroundImages()
        roadCollectionView.register(MatchedCardsRoadCell.self, forCellWithReuseIdentifier: matchedCardsRoadCellID)
        
        roadCollectionView.delegate = roadCollectionView
        roadCollectionView.dataSource = roadCollectionView
        
        return roadCollectionView
    }
    
    let roadEndImageView = UIImageView()
    fileprivate func setupBackgroundImages() {
        roadWidth = 21 * fontFactor
        turningRadius = 25 * fontFactor
        
        // add for review
        if !forCart {
            let roadStartImage = ProjectImages.sharedImage.roadStart!
            let startWidth = 86 * standWP
            let startHeight = startWidth * roadStartImage.size.height / roadStartImage.size.width
            let roadImageView = UIImageView(image: roadStartImage)
            let startFlagFrame = CGRect(x: 25 * standHP, y: 10 * fontFactor, width: startWidth, height: startHeight)
            roadImageView.frame = startFlagFrame
            startPoint = CGPoint(x: startFlagFrame.midX, y: startFlagFrame.midY)
            
            // add
            addSubview(roadImageView)
            addSubview(roadEndImageView)
        }
    }

    func changeAnswerOfCard(_ card: CardInfoObjModel, toIndex index: Int!) {
        // change UI if necessary
        if let chosenCell = cellForItem(at: IndexPath(item: chosenIndex, section: 0)) {
            let cell = chosenCell as! MatchedCardsRoadCell
            if index != nil {
                cell.configureWithCard(card, mainColor: mainColor, index: chosenIndex, mainLength: bounds.width - startX - 25 * standWP)
                cell.showBaseline = card.showBaseline()
            }

            cell.isChosen = false
        }
        
        // no card is chosen
        chosenIndex = -1
        
        setupAnchorInfo()
        setNeedsDisplay()
    }
}

// MARK: --------- collection data source ---------
extension SummaryOfCardsRoadCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchedCardsRoadCellID, for: indexPath) as! MatchedCardsRoadCell
        
        let card = cards[indexPath.item]
        cell.configureWithCard(card, mainColor: mainColor, index: indexPath.item, mainLength: bounds.width - startX - 20 * standWP)
        
        // set state
        cell.isChosen = (indexPath.item == chosenIndex)
        cell.resultTag = card.judgementChoose()
        var factorType = FactorType.score
        if let riskKey = cardsCursor.focusingRiskKey {
            if card.isBonusCardInRisk(riskKey) {
                factorType = .bonus
            }else if card.isComplementaryCardInRisk(riskKey) {
                factorType = .complementary
            }
        }
        cell.setupWithType(factorType)
        
        cell.showBaseline = card.showBaseline()
        
        return cell
    }
}

// layout data source
extension SummaryOfCardsRoadCollectionView: BlockFlowDataSource {
    func numberOfColsForLayout(_ layout: BlockFlowLayout) -> Int {
        return 1
    }
    
    // the first row is fixed, to avoid the overlap
    func topMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return firstTop
        }
        
        return 10 * standHP
    }
    
    func getLeftMarginOfIndex(_ index: Int) -> CGFloat {
        let params: [CGFloat] = [54, 24, 22, 56, 48, 40]
        return params[index % params.count] * standWP
    }
    
    func leftMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        return getLeftMarginOfIndex(indexPath.item)
    }
    
    func itemSizeAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width - getLeftMarginOfIndex(indexPath.item) - 20 * standWP, height: cardLength)
    }
    
    // with answered view, maybe, set a large number for bottom
    func sectionEdgeInsetsForLayout(_ layout: BlockFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: forCart ? 70 * standHP : 175 * standHP, right: 0)
    }
}

// MARK: --------- collection delegate ---------
extension SummaryOfCardsRoadCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if forMatched {
            return
        }
        
        let chosenCell = cellForItem(at: indexPath) as! MatchedCardsRoadCell
        
        // review, change
        chosenCell.isChosen = true
        if chosenIndex != -1 {
            performBatchUpdates({
                if let lastCell = self.cellForItem(at: IndexPath(item: self.chosenIndex, section: 0))  {
                    let cell = lastCell as! MatchedCardsRoadCell
                    cell.isChosen = false
                }
            }, completion: { (true) in
                self.chosenIndex = indexPath.item
            })
        }else {
            chosenIndex = indexPath.item
        }
        
        if hostVC.isKind(of: SummaryViewController.self) {
            let vc = hostVC as! SummaryViewController
            vc.showAnswerWithCard(cards[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // end
        let endImage = ProjectImages.sharedImage.roadFlag!
        let endWidth = 89 * standWP
        let endHeight = endWidth * endImage.size.height / endImage.size.width
        roadEndImageView.image = endImage
        
        let layout = collectionViewLayout as! BlockFlowLayout
        let endFlagFrame = CGRect(x: endWidth * 0.8, y: contentSize.height - layout.sectionInset.bottom + 12 * standHP, width: endWidth, height: endHeight)
        roadEndImageView.frame = endFlagFrame
        endPoint = CGPoint(x: endFlagFrame.midX, y: endFlagFrame.minY + endHeight * 0.25)
        
        // anchorInfo
        setupAnchorInfo()
    }
    
    fileprivate func setupAnchorInfo() {
        let layout = collectionViewLayout as! BlockFlowLayout
        
        // all read
        let attriArray = layout.attriArray
        anchorInfo.removeAll()
        for (i, attri) in attriArray.enumerated() {
            let card = cards[i]
            anchorInfo.append((CGPoint(x: attri.frame.minX + 10 * standWP, y: attri.center.y), card.currentPlayed()))
        }
        
        // last flag, if all played, true
        if !forCart {
            anchorInfo.append((endPoint, MatchedCardsDisplayModel.currentAllCardsPlayed()))
        }
    }
}
