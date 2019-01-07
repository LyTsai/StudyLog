//
//  SummaryOfCardsRoadCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/9/4.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

extension CardInfoObjModel {
    func currentSelection() -> Int? {
        let result = CardSelectionResults.cachedCardProcessingResults.getCurrentSelectionForCard(key)
        if cardStyleKey == JudgementCardTemplateView.styleKey() && result != nil{
            if result == 1 {
                // yes
                return 0
            }else {
                // no
                return 1
            }
        }
        
        return result
    }
    
    func saveResult(_ answerIndex: Int) {
        var value: Int!
        var option: CardOptionObjModel!
        
        // judgement
        if cardStyleKey == JudgementCardTemplateView.styleKey() {
            value = (answerIndex == 0) ? 1 : -1
            option = cardOptions.first
        }
        
        // multiple
        if cardStyleKey == SetOfCardsCardTemplateView.styleKey() {
            option = cardOptions[answerIndex]
            value = answerIndex
        }
        
        // data cached
        CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser.Key(), cardKey: key, riskKey: RiskMetricCardsCursor.sharedCursor.focusingRiskKey, selection: option, value: value as NSNumber?)
    }
}


class SummaryOfCardsRoadCollectionView: WindingRoadCollectionView {
    weak var hostVC: UIViewController!
    
    // situation
    var forMatched = false
    
    
    // data source
    var cards = [CardInfoObjModel]()
    fileprivate var items = [RoadItemDisplayModel]()
    
    fileprivate var standW: CGFloat {
        return bounds.width / 375
    }
    fileprivate var standH: CGFloat {
        return bounds.height / (667 - 49 - 64)
    }
    
    var chosenIndex: Int = -1
    fileprivate var mainColor = UIColor.cyan

    fileprivate var forPart = false
    fileprivate let textFont = UIFont.systemFont(ofSize: 12, weight: UIFontWeightBold)
    // factory
    class func createWithFrame(_ frame: CGRect, cards: [CardInfoObjModel], mainColor: UIColor, forPart: Bool) -> SummaryOfCardsRoadCollectionView {
        let layout = BlockFlowLayout()
        
        let roadCollectionView = SummaryOfCardsRoadCollectionView(frame: frame, collectionViewLayout: layout)
        roadCollectionView.backgroundColor = UIColor.clear
        layout.dataSource = roadCollectionView
        
        roadCollectionView.mainColor = mainColor
        roadCollectionView.cards = cards
        roadCollectionView.forPart = forPart
        roadCollectionView.forMatched = false
        
        // add and data
        roadCollectionView.setupBackgroundImages()
        roadCollectionView.setItems()
        
        roadCollectionView.register(MatchedCardsRoadCell.self, forCellWithReuseIdentifier: matchedCardsRoadCellID)
        
        roadCollectionView.delegate = roadCollectionView
        roadCollectionView.dataSource = roadCollectionView
        
        return roadCollectionView
    }
    
    
    // matched cards
    var matchedCards = [MatchedCardsDisplayModel]()
    class func createWithFrame(_ frame: CGRect, matchedCards: [MatchedCardsDisplayModel], mainColor: UIColor) -> SummaryOfCardsRoadCollectionView {
        let layout = BlockFlowLayout()
        
        let roadCollectionView = SummaryOfCardsRoadCollectionView(frame: frame, collectionViewLayout: layout)
        roadCollectionView.backgroundColor = UIColor.clear
        layout.dataSource = roadCollectionView
        
        roadCollectionView.mainColor = mainColor
        roadCollectionView.matchedCards = matchedCards
        roadCollectionView.forMatched = true
        
        // add and data
        roadCollectionView.setupBackgroundImages()
        roadCollectionView.roadEndImageView.removeFromSuperview()
        
        roadCollectionView.setItems()
        
        roadCollectionView.register(MatchedCardsRoadCell.self, forCellWithReuseIdentifier: matchedCardsRoadCellID)
        
        roadCollectionView.delegate = roadCollectionView
        roadCollectionView.dataSource = roadCollectionView
        
        return roadCollectionView
    }
    
    
    let roadEndImageView = UIImageView()
    fileprivate func setupBackgroundImages() {
        
        // first part road
        let roadStartImage = ProjectImages.sharedImage.roadStart!
        let startWidth = 80 * standW
        let startHeight = startWidth * roadStartImage.size.height / roadStartImage.size.width
        let roadImageView = UIImageView(image: roadStartImage)
        startFlagFrame = CGRect(x: bounds.width - startWidth - 62 * standH, y: 19 * standH, width: startWidth, height: startHeight)
        roadImageView.frame = startFlagFrame
        
        // add
        addSubview(roadImageView)
        addSubview(roadEndImageView)
        
        roadImageView.layer.zPosition = -1
    }
    
    fileprivate let anchorPositions: [PositionOfAnchor] = [.right, .bottom, .top, .left]
    fileprivate var backLength: CGFloat = 0
    fileprivate func setItems() {
        items.removeAll()
        roadWidth = 20 * standH
        
        //let total = forMatched ? matchedCards.count : cards.count
        let total = cards.count
        
        for i in 0..<total {
            let item = RoadItemDisplayModel()
            backLength = min(standH, standW) * 65
            item.backFrame = CGRect(x: 0, y: 0, width: backLength, height: backLength)
            item.fillColor = mainColor
            item.borderColor = mainColor
            
            if i == 0 {
                item.anchorPosition = .bottom
            }else if i == 1 {
                item.anchorPosition = .left
            }else {
                item.anchorPosition = anchorPositions[Int(arc4random() % 4)]
                let lastAnchor = items[i - 2].anchorPosition
                while lastAnchor == item.anchorPosition {
                    item.anchorPosition = anchorPositions[Int(arc4random() % 4)]
                }
            }
            
            item.lineWidth = 2 * min(standH, standW)
            item.indexWidth = 19 * standH
            
            items.append(item)
        }
    }
    
    func changeAnswerOfCard(_ card: CardInfoObjModel, toIndex index: Int) {
        // change data first
        let match = card.cardOptions[index].match
     
        // change UI if necessary
        if let chosenCell = cellForItem(at: IndexPath(item: chosenIndex, section: 0)) {
            let cell = chosenCell as! MatchedCardsRoadCell
            cell.fillDataWithImageUrl(match?.imageUrl, text: match?.name, answered: true)
            cell.isChosen = false
        }else {
            print("not in view now: \(chosenIndex)")
        }
        
        // no card is chosen
        chosenIndex = -1
    }
    
}

// MARK: --------- collection data source ---------
extension SummaryOfCardsRoadCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
        //return forMatched ? matchedCards.count : cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchedCardsRoadCellID, for: indexPath) as! MatchedCardsRoadCell
        
        cell.isChosen = (indexPath.item == chosenIndex)
        let card = cards[indexPath.item]
        if let result = card.currentSelection() {
            let match = card.cardOptions[result].match
            cell.fillDataWithImageUrl(match?.imageUrl, text: match?.name, answered: true)
        }else {
            cell.fillDataWithImageUrl(nil, text: card.title, answered: false)
        }

        cell.setupWithRoadItem(items[indexPath.item])
        cell.font = textFont
        
        return cell
    }
}

// layout data source
extension SummaryOfCardsRoadCollectionView: BlockFlowDataSource {
//    func numberOfColsForLayout(_ layout: BlockFlowLayout) -> Int {
//        return 1
//    }
    
    // the first row is fixed, to avoid the overlap
    func topMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return 86 * standH
        }
        
        if indexPath.item == 1 {
            return 73 * standH
        }
    
        return 45 * standH
    }
    
    func leftMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return 53 * standW
        }
        
        if indexPath.item == 1 {
            return 36 * standW
        }
        
        if indexPath.item % 2 == 0 {
            // just like left margin
            let item = items[indexPath.item]
            switch item.anchorPosition {
            case .left:
                return 25 * standW
            case .right:
                return 20 * standW
            default:
                return 28 * standW
            }
        }
        
        return 25 * standW
    }
    
    func itemSizeForLayout(_ layout: BlockFlowLayout, at indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.item]
        let card = cards[indexPath.item]
        var text: String!
        
        // get the loggest text to draw
        var allTexts = [String]()
        for option in card.cardOptions {
            if let name = option.match?.name {
                allTexts.append(name)
            }
        }
        if let cardTitle = card.title {
            allTexts.append(cardTitle)
        }
        
        allTexts.sort { (a, b) -> Bool in
            return a.lengthOfBytes(using: .ascii) > b.lengthOfBytes(using: .ascii)
        }
        
        text = allTexts.first
        
        // calculate
        let attribute = [NSFontAttributeName: textFont]
        
        switch item.anchorPosition {
        case .left, .right:
            let maxHeight = text.boundingRect(with: CGSize(width: 125 * standW, height: 190 * standH), options: .usesLineFragmentOrigin, attributes: attribute, context: nil).height
            return CGSize(width: 125 * standW, height: max(maxHeight + backLength, 101 * standH))
        default: // top bottom free
            let maxHeight = text.boundingRect(with: CGSize(width: 155 * standW - backLength, height: 190 * standH), options: .usesLineFragmentOrigin, attributes: attribute, context: nil).height
            return CGSize(width: 155 * standW, height: max(maxHeight, 101 * standH))
        }
    }
    
    // with answered view, maybe, set a large number for bottom
    func sectionEdgeInsetsForLayout(_ layout: BlockFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: forPart ? 110 * standH : 175 * standH, right: 0)
    }
}

// MARK: --------- collection delegate ---------
extension SummaryOfCardsRoadCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if forMatched {
                return
        }
        
        let chosenCell = cellForItem(at: indexPath) as! MatchedCardsRoadCell
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
        let endImage = ProjectImages.sharedImage.roadEnd!
        let endWidth = 89 * standW
        let endHeight = endWidth * endImage.size.height / endImage.size.width
        roadEndImageView.image = endImage
        
        let layout = collectionViewLayout as! BlockFlowLayout
        let endFlagFrame = CGRect(x: bounds.width - endWidth * 2, y: contentSize.height - layout.sectionInset.bottom + 10 * standH, width: endWidth, height: endHeight)
        roadEndImageView.frame = endFlagFrame
        endPoint = CGPoint(x: endFlagFrame.midX, y: endFlagFrame.minY + endHeight * 0.25)
        
        // all read
        setAnchorInfoWithItems(items)
        
        if roadEndImageView.superview == nil {
            anchorInfo.removeLast()
        }
        
        setNeedsDisplay()
    }
}
