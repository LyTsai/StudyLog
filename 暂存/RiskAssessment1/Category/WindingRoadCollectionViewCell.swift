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
        
    fileprivate var itemView = RoadItemDisplayView()
    fileprivate var categoryInfoView = CategoryDisplayView()
    fileprivate var categoryAll = CategoryAllAnsweredView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupWithItem(_ item: RoadItemDisplayModel, category: CategoryDisplayModel) {
        // draw
        itemView.setupAndDrawWithFrame(bounds, item: item)
        
        if category.cards.count == category.cardsPlayed.count {
            categoryInfoView.isHidden = true
            categoryAll.isHidden = false
            categoryAll.setupWithItem(item, category: category, forMatched: false)
        }else {
            categoryInfoView.isHidden = false
            categoryAll.isHidden = true
            
            // data
            categoryInfoView.setupWithItem(item, category: category)
        }
    }
    
    // for matched
    func setupMatchedWithItem(_ item: RoadItemDisplayModel, category: CategoryDisplayModel) {
        // draw
        itemView.setupAndDrawWithFrame(bounds, item: item)
        categoryInfoView.isHidden = true
        categoryAll.isHidden = false
        categoryAll.setupWithItem(item, category: category, forMatched: true)
    }
    
    private func setupUI() {
        contentView.addSubview(itemView)
        contentView.addSubview(categoryAll)
        contentView.addSubview(categoryInfoView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryAll.frame = bounds
    }
}

