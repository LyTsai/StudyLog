//
//  WindingCategoryCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/25.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// first view
class WindingCategoryCollectionView: WindingRoadCollectionView {
    weak var hostVC: UIViewController!

    var categories = [CategoryDisplayModel]()
    var items = [RoadItemDisplayModel]()
    
    class func createWithFrame(_ frame: CGRect, categories: [CategoryDisplayModel]) -> WindingCategoryCollectionView {
        let layout = BlockFlowLayout()
        let categoryView = WindingCategoryCollectionView(frame: frame, collectionViewLayout: layout)
        categoryView.backgroundColor = UIColor.clear
        categoryView.categories = categories
        
        // backImages
        categoryView.setupBackgroundImages()
        
        // data
        categoryView.items = categoryView.getAllItems()
        categoryView.register(WindingRoadCollectionViewCell.self, forCellWithReuseIdentifier: windingRoadCellID)
        
        // delegate
        layout.dataSource = categoryView
        categoryView.dataSource = categoryView
        categoryView.delegate = categoryView
        
        return categoryView
    }
    
    fileprivate var standW: CGFloat {
        return bounds.width / 375
    }
    fileprivate var standH: CGFloat {
        return bounds.height / (667 - 49 - 64)
    }
    
    
    let titleImageView = UIImageView()
    let roadEndImageView = UIImageView()
    func setupBackgroundImages() {
        let title1 = ProjectImages.sharedImage.categoryTitle1!
        let titleWidth = 248 * standW
        titleImageView.frame = CGRect(x: frame.width - titleWidth, y: -18 * standH, width: titleWidth, height: title1.size.height * titleWidth / title1.size.width)
        titleImageView.image = title1
        
        // first part road
        let roadStartImage = ProjectImages.sharedImage.roadStart!
        let startWidth = 80 * standW
        let startHeight = startWidth * roadStartImage.size.height / roadStartImage.size.width
        let roadImageView = UIImageView(image: roadStartImage)
        startFlagFrame = CGRect(x: 39 * standW, y: 9 * standH, width: startWidth, height: startHeight)
        roadImageView.frame = startFlagFrame
        
        // add
        addSubview(roadImageView)
        addSubview(titleImageView)
        addSubview(roadEndImageView)
        titleImageView.layer.zPosition = -2
        roadImageView.layer.zPosition = -1
    }
    
    fileprivate let anchorPositions: [PositionOfAnchor] = [.left, .left, .right, .right, .bottom, .left]
    func getAllItems() -> [RoadItemDisplayModel] {
        // sort
        var items = [RoadItemDisplayModel]()
        
        // set frames
        // (87, 134, 119, 115)
        for i in 0..<categories.count {
            let item = RoadItemDisplayModel()
            
            let colorPair = colorPairs[i % colorPairs.count]
            item.fillColor = colorPair.fill
            item.borderColor = colorPair.border
            
            item.anchorPosition = anchorPositions[i % 6]
            
            var backOrigin = CGPoint(x: 39 * standW, y: 0)
            switch item.anchorPosition {
            case .right, .bottom: backOrigin = CGPoint.zero
            default: // TODO: ------------ top, left, should with cell's bounds
                break
            }
            
            // fixed back size
            let backSize = CGSize(width: 84 * standW, height: 115 * standH)
            item.backFrame = CGRect(origin: backOrigin, size: backSize)
            item.indexWidth = roadWidth * 0.9

            items.append(item)
        }
        
        return items
    }
    
    // title image and updated category
    func setupWithPlayState(_ playState: [String: [String]]) {
        var answered: Int = 0
        for (_, value) in playState {
            answered += value.count
        }
        
        // title
        titleImageView.image = (answered == 0) ? ProjectImages.sharedImage.categoryTitle1 : ProjectImages.sharedImage.categoryTitle2
        
        // cells
        for category in categories {
            category.updateCurrentPlayStateData()
        }
        
        reloadData()
    }
    
}

// collection view dataSource
extension WindingCategoryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: windingRoadCellID, for: indexPath) as! WindingRoadCollectionViewCell
        cell.setupWithItem(items[indexPath.item], category: categories[indexPath.item])
        
        return cell
    }
}

// blockDataSource
extension WindingCategoryCollectionView: BlockFlowDataSource {
    // default as 2
    func numberOfColsForLayout(_ layout: BlockFlowLayout) -> Int {
        return 2
    }
    
    func topMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 0: return 51 * standH
        case 1: return 125 * standH
        case 2: return 14 * standH
        case 3: return -2 * standH
        case 4: return 12 * standH
        default: return 70 * standH
        }
    }
    
    func leftMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 0: return startFlagFrame.midX - roadWidth * 0.5
//        68 * standW
        case 1: return 36 * standW
        case 2: return 23 * standW
        case 3: return 30 * standW
        case 4: return 70 * standW
        default: return 50 * standW
        }
    }
    
    func itemSizeForLayout(_ layout: BlockFlowLayout, at indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 3, 5: return CGSize(width: 150 * standW, height: 115 * standH)
        case 4: return CGSize(width: 85 * standW, height: 151 * standH)
        default: return CGSize(width: 118 * standW, height: 115 * standH)
        }
    }
    
    // button and flag height
    func sectionEdgeInsetsForLayout(_ layout: BlockFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 155 * standH, right: 0)
    }
}

// collection view delegate
extension WindingCategoryCollectionView: UICollectionViewDelegate {
    // selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        VDeckOfCardsFactory.metricDeckOfCards.attachCategoryCards(category.cards)
        RiskMetricCardsCursor.sharedCursor.focusingCategoryKey = category.key
        
        category.updateCurrentPlayStateData()
        if category.cards.count == category.cardsPlayed.count {
            let summary = SummaryViewController()
            summary.cards = category.cards
            summary.roadTitle = category.name
            summary.forPart = true
            
            // color
            let chosenItem = self.items[indexPath.item]
            summary.mainColor = chosenItem.fillColor
            self.hostVC.navigationController?.pushViewController(summary, animated: true)
        }else {
            let riskAssess = ABookRiskAssessmentViewController()
            hostVC.navigationController?.pushViewController(riskAssess, animated: true)
        }
    }
    
    // draw road after all data is set
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // end
        let endImage = ProjectImages.sharedImage.roadEnd!
        let endWidth = 89 * standW
        let endHeight = endWidth * endImage.size.height / endImage.size.width
        roadEndImageView.image = endImage
        
        let layout = collectionViewLayout as! BlockFlowLayout
        let endFlagFrame = CGRect(x: bounds.width - endWidth * 2, y: contentSize.height - layout.sectionInset.bottom, width: endWidth, height: endHeight)
        roadEndImageView.frame = endFlagFrame
        endPoint = CGPoint(x: endFlagFrame.midX, y: endFlagFrame.minY + endHeight * 0.25)
        
        // all read
        setAnchorInfoWithItems(items)
        
        setNeedsDisplay()
    }
    
}
