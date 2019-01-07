//
//  MatchedCardsRoadCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/28.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class MatchedCardsRoadCollectionView: WindingRoadCollectionView {
    weak var hostVC: UIViewController!
    
    fileprivate var matchedCards = [MatchedCardsDisplayModel]()
    fileprivate var items = [RoadItemDisplayModel]()
    
    fileprivate var standW: CGFloat {
        return bounds.width / 375
    }
    fileprivate var standH: CGFloat {
        return bounds.height / (667 - 49 - 64)
    }
    
    var chosenIndex: Int = -1
    fileprivate var colorPair = (UIColor.blue, UIColor.cyan)
    fileprivate let textFont = UIFont.systemFont(ofSize: 12, weight: UIFontWeightBold)
    // factory
    class func createWithFrame(_ frame: CGRect, cards: [MatchedCardsDisplayModel], colorPair: (UIColor, UIColor)) -> MatchedCardsRoadCollectionView {
        let layout = BlockFlowLayout()
        
        let roadCollectionView = MatchedCardsRoadCollectionView(frame: frame, collectionViewLayout: layout)
        roadCollectionView.backgroundColor = UIColor.clear
        layout.dataSource = roadCollectionView
    
        roadCollectionView.colorPair = colorPair
        roadCollectionView.matchedCards = cards
        roadCollectionView.setupBackgroundImages()
        roadCollectionView.setItems()
        
        roadCollectionView.register(MatchedCardsRoadCell.self, forCellWithReuseIdentifier: matchedCardsRoadCellID)
        
        roadCollectionView.delegate = roadCollectionView
        roadCollectionView.dataSource = roadCollectionView
        
        return roadCollectionView
    }
    
    fileprivate let titleImageView = UIImageView()
    fileprivate let titleLabel = UILabel()
    fileprivate let roadEndImageView = UIImageView()
    fileprivate func setupBackgroundImages() {
        let titleImage = ProjectImages.sharedImage.roadCardTitle!
        let titleWidth = 188 * standW
        titleImageView.frame = CGRect(x: 0, y: -25 * standH, width: titleWidth, height: titleImage.size.height * titleWidth / titleImage.size.width)
        titleImageView.image = titleImage
        
        // label
        titleLabel.frame = CGRect(x: 10 * standW, y: 5 * standH, width: 120 * standW, height: 50 * standH)
        titleLabel.numberOfLines = 0
        titleLabel.text = matchedCards.first?.side
        titleLabel.font = UIFont.systemFont(ofSize: 15 * standW, weight: UIFontWeightSemibold)
        
        // first part road
        let roadStartImage = ProjectImages.sharedImage.roadStartCard!
        let startWidth = 120 * standW
        let startHeight = startWidth * roadStartImage.size.height / roadStartImage.size.width
        let roadImageView = UIImageView(image: roadStartImage)
        startFlagFrame = CGRect(x: bounds.width - startWidth - 55 * standH, y: 19 * standH, width: startWidth, height: startHeight)
        roadImageView.frame = startFlagFrame
        
        // add
        addSubview(roadImageView)
        addSubview(titleImageView)
        addSubview(titleLabel)
        addSubview(roadEndImageView)
        
        titleImageView.layer.zPosition = -2
        roadImageView.layer.zPosition = -1
    }
    
    fileprivate let anchorPositions: [PositionOfAnchor] = [.right, .bottom, .top, .left]
    fileprivate var backLength: CGFloat = 0
    fileprivate func setItems() {
        items.removeAll()
        roadWidth = 20 * standH
        
        for i in 0..<matchedCards.count {
            let item = RoadItemDisplayModel()
            backLength = min(standH, standW) * 65
            item.backFrame = CGRect(x: 0, y: 0, width: backLength, height: backLength)
            item.fillColor = colorPair.0
            item.borderColor = colorPair.0
            
            if i == 0 {
                item.anchorPosition = .bottom
            }else if i == 1 {
                item.anchorPosition = .left
            }else {
                let lastAnchor = items.last!.anchorPosition
                item.anchorPosition = anchorPositions[Int(arc4random() % 4)]
                while lastAnchor == item.anchorPosition {
                    item.anchorPosition = anchorPositions[Int(arc4random() % 4)]
                }
            }
            
            item.lineWidth = 2 * min(standH, standW)
            item.indexWidth = 19 * standH
            
            items.append(item)
        }
    }
    
    func changeAnswerToCard(_ card: MatchedCardsDisplayModel) {
        // change data first
        matchedCards[chosenIndex] = card
        
        // change UI if necessary
        if let chosenCell = cellForItem(at: IndexPath(item: chosenIndex, section: 0)) {
            let cell = chosenCell as! MatchedCardsRoadCell
            cell.fillDataWithCard(card)
            cell.isChosen = false
        }else {
            print("not in view now: \(chosenIndex)")
        }
        
        chosenIndex = -1
    }

}

// MARK: --------- collection data source ---------
extension MatchedCardsRoadCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchedCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchedCardsRoadCellID, for: indexPath) as! MatchedCardsRoadCell
        cell.isChosen = (indexPath.item == chosenIndex)
        cell.fillDataWithCard(matchedCards[indexPath.item])
        cell.setupWithRoadItem(items[indexPath.item])
        cell.font = textFont
        
        return cell
    }
}

extension MatchedCardsRoadCollectionView: BlockFlowDataSource {
    // the first row is fixed, to avoid the overlap
    func topMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return 86 * standH
        }
        
        if indexPath.item == 1 {
            return 73 * standH
        }
        
        let item = items[indexPath.item]
        switch item.anchorPosition {
        case .left:
            return 44 * standH
        case .right:
            return 48 * standH
        default:
            return 42 * standH
        }

    }
    
    func leftMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return 58 * standW
        }
        
        if indexPath.item == 0 {
            return 45 * standW
        }
        
        let item = items[indexPath.item]
        switch item.anchorPosition {
        case .left:
            return 30 * standW
        case .right:
            return 33 * standW
        default:
            return 20 * standW
        }

    }
    
    func itemSizeForLayout(_ layout: BlockFlowLayout, at indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.item]
//        let text = matchedCards[indexPath.item].prompt! as NSString
        let text = matchedCards[indexPath.item].title! as NSString
        
        let attribute = [NSFontAttributeName: textFont]

        switch item.anchorPosition {
        case .left, .right:
            let maxHeight = text.boundingRect(with: CGSize(width: 115 * standW, height: 300 * standH), options: .usesLineFragmentOrigin, attributes: attribute, context: nil).height
            return CGSize(width: 115 * standW, height: max(maxHeight + backLength, 101 * standH))
        default: // top bottom free
            let maxHeight = text.boundingRect(with: CGSize(width: 155 * standW - backLength, height: 300 * standH), options: .usesLineFragmentOrigin, attributes: attribute, context: nil).height
            return CGSize(width: 155 * standW, height: max(maxHeight, 101 * standH))
        }
    }
    
    func sectionEdgeInsetsForLayout(_ layout: BlockFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 90 * standH, right: 0)
    }
}

extension MatchedCardsRoadCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
        
        if hostVC.isKind(of: MatchedCardsRoadViewController.self) {
            let vc = hostVC as! MatchedCardsRoadViewController
//            vc.showAnswerWithCard(matchedCards[indexPath.item])
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // all read
        setAnchorInfoWithItems(items)
        
        let endImage = ProjectImages.sharedImage.roadEnd!
        let endWidth = 89 * standW
        let endHeight = endWidth * endImage.size.height / endImage.size.width
        roadEndImageView.image = endImage
        
        let lastPoint = anchorInfo.last!
        
        let endFlagFrame = CGRect(x: max(lastPoint.x - endWidth * 0.5, 0), y: contentSize.height - endHeight, width: endWidth, height: endHeight)
        roadEndImageView.frame = endFlagFrame
        endPoint = CGPoint(x: endFlagFrame.midX, y: endFlagFrame.minY + endHeight * 0.25)
        
        setNeedsDisplay()
    }
}
