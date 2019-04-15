//
//  RisksDisplayCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/5.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// cell
let riskDisplayCellID = "risk display cell identifier"
class RiskDisplayCell: BasicCollectionViewCell {
    
    override func updateUI() {
        super.updateUI()
        
        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageLength = min(bounds.width, bounds.height) * 0.6
        
        imageView.frame = CGRect(center: CGPoint(x: bounds.midX, y: imageLength * 0.5), length: imageLength)
        imageView.layer.cornerRadius = 5
        textLabel.frame = CGRect(x: 0, y: imageLength, width: bounds.width, height: bounds.height - imageLength)
        textLabel.font = UIFont.systemFont(ofSize: (bounds.height - imageLength) * 0.3)
    }
}


// collection
class RisksDisplayCollectionView: UICollectionView, UICollectionViewDataSource {
    
    var risks = [RiskObjModel]() {
        didSet{
            reloadData()
        }
    }
    
    // awake from nib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        register(RiskDisplayCell.self, forCellWithReuseIdentifier: riskDisplayCellID)
        dataSource = self
    }
    
    // data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return risks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let risk = risks[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: riskDisplayCellID, for: indexPath) as! RiskDisplayCell
        cell.imageUrl = risk.imageUrl
        cell.text = risk.name
        cell.imageView.backgroundColor = colorPairs[indexPath.item % colorPairs.count].fill
        
        return cell
    }
}

