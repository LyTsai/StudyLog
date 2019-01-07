//
//  WindingRoadCollectionViewCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/22.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let windingRoadCellID = "Winding Road CollectionView Cell Identifier"
class WindingRoadCollectionViewCell: UICollectionViewCell {
    var item: RoadItemDisplayModel! {
        didSet{
            itemView.setupWithFrame(bounds, item: item)
        }
    }
    
    fileprivate var itemView = RoadItemDisplayView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        itemView.setupBasicViews()
        contentView.addSubview(itemView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
}

// first view
class WindingCategoryCollectionView: UICollectionView, UICollectionViewDataSource, BlockFlowDataSource {
    var standW: CGFloat = 1
    var standH: CGFloat = 1
    class func createWithFrame(_ frame: CGRect) -> WindingCategoryCollectionView {
        let layout = BlockFlowLayout()
        let categoryView = WindingCategoryCollectionView(frame: frame, collectionViewLayout: layout)
        categoryView.backgroundColor = UIColor.clear
        
        // frames
        categoryView.standW = frame.width / 375
        categoryView.standH = frame.height / (667 - 49 - 64)
        
        // backImages
        let title1 = ProjectImages.sharedImage.categoryTitle1!
        let titleWidth = 248 * categoryView.standW
        let titleImageView = UIImageView(frame: CGRect(x: frame.width - titleWidth, y: -18 * categoryView.standH, width: titleWidth, height: title1.size.height * titleWidth / title1.size.width))
        titleImageView.image = title1
        
        // first part road
        let startRoadImage = ProjectImages.sharedImage.roadStart!
        let roadWidth = frame.width - 10 * categoryView.standW
        let startHeight = roadWidth * startRoadImage.size.height / startRoadImage.size.width
        let roadImageView = UIImageView(image: ProjectImages.sharedImage.roadStart)
        roadImageView.frame = CGRect(x: 10 * categoryView.standW, y: 10 * categoryView.standH, width: roadWidth, height: startHeight)
        
        // add
        categoryView.addSubview(roadImageView)
        categoryView.addSubview(titleImageView)
        titleImageView.layer.zPosition = -2
        roadImageView.layer.zPosition = -1
        
        categoryView.items = categoryView.getAllItems()
        categoryView.register(WindingRoadCollectionViewCell.self, forCellWithReuseIdentifier: windingRoadCellID)
        
        // delegate
        layout.dataSource = categoryView
        categoryView.dataSource = categoryView
        
        return categoryView
    }
    
    var categories = [CategoryDisplayModel]()
    var items = [RoadItemDisplayModel]()
    let anchorPositions: [PositionOfAnchor] = [.left, .left, .right, .right, .bottom, .left]
    fileprivate func getAllItems() -> [RoadItemDisplayModel] {
        categories = getUpdatedCategories()
        
        // sort
        let items = RoadItemDisplayModel.getAllItemsForCategories(categories)
        
        // set frames
        // (87, 134, 119, 115)

        for (i, item) in items.enumerated() {
            item.anchorPosition = anchorPositions[i % 6]
            
            var backOrigin = CGPoint(x: 39 * standW, y: 0)
            switch item.anchorPosition {
            case .right: backOrigin = CGPoint(x: 0, y: 0)
            case .bottom: backOrigin = CGPoint(x: 0, y: 0)
            default:
                break
            }
            let backSize = CGSize(width: 84 * standW, height: 115 * standH)
           
            item.backFrame = CGRect(origin: backOrigin, size: backSize)
            
            let imageMargin = 2 * min(standH, standW)
            let labelHeight = item.backFrame.height * 0.3
            item.labelFrame = CGRect(x: item.backFrame.minX, y: item.backFrame.minY, width: item.backFrame.width, height: labelHeight)
            item.imageFrame = CGRect(x: item.backFrame.minX + imageMargin, y: item.backFrame.minY + labelHeight, width: item.backFrame.width - 2 * imageMargin, height: item.backFrame.height * 0.65)
            item.indexWidth = 20 * min(standH, standW)
        }
        
        return items
    }
    
    fileprivate func getUpdatedCategories() -> [CategoryDisplayModel] {
        var categories = [CategoryDisplayModel]()
        
        let sortedCards = RiskMetricCardsCursor.sharedCursor.getSortedCards()
        var genetics: CategoryDisplayModel!
        for (key, value) in sortedCards {
            let categoryObj = AIDMetricCardsCollection.standardCollection.getMetricGroupByKey(key)
            let category = CategoryDisplayModel()
            category.key = key
            category.name = categoryObj?.name ?? "Others"
            category.imageUrl = categoryObj?.imageUrl
            category.cards = value
            
            if category.name.contains("Genetics") && genetics == nil {
                genetics = category
            }else {
                categories.append(category)
            }
        }
        
        // sort
        if genetics != nil {
            categories.append(genetics)
        }
        
        return categories
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: windingRoadCellID, for: indexPath) as! WindingRoadCollectionViewCell
        cell.item = items[indexPath.item]
        cell.backgroundColor = UIColor.cyan
        return cell
    }
    
    
    // blockDataSource
    // default as 2
    func numberOfColsForLayout(_ layout: BlockFlowLayout) -> Int {
        return 2
    }
    
    func topMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 0: return 51 * standH
        case 1: return 123 * standH
        case 3: return -4 * standH
        case 4: return 14 * standH
        default: return 18 * standH
        }
    }
    
    func leftMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 0: return 68 * standW
        case 1: return 31 * standW
        case 2: return 23 * standW
        case 3: return 30 * standW
        case 4: return 70 * standW
        default: return 55 * standW
        }
    }
    
    func itemSizeForLayout(_ layout: BlockFlowLayout, at indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 3: return CGSize(width: 150 * standW, height: 115 * standH)
        case 4: return CGSize(width: 85 * standW, height: 151 * standH)
        default: return CGSize(width: 118 * standW, height: 115 * standH)
        }
    }
    
    func  sectionEdgeInsetsForLayout(_ layout: BlockFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 70 * standH, right: 0)
    }
}
