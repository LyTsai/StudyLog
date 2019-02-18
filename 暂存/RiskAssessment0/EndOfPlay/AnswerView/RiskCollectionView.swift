//
//  RiskCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/1/14.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MARK: --------------risks for metric "table"
// collection view
let riskCellID = "Risk Cell ID"
class TextCollectionViewCell: UICollectionViewCell {
    var text: String = "" {
        didSet{ textLabel.text = text }
    }
    
    fileprivate let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = UIColor.clear
        
        textLabel.textAlignment = .center
        textLabel.backgroundColor = UIColor.white
        textLabel.layer.addBlackShadow(1)
        textLabel.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        textLabel.numberOfLines = 0
        textLabel.layer.borderColor = UIColorGray(216).cgColor
        textLabel.layer.borderWidth = 0.4
        
        contentView.addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds.insetBy(dx: 1, dy: 2)
        textLabel.font = UIFont.systemFont(ofSize: bounds.height / 2.8)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        text = " "
    }
}


class RiskCollectionView: UICollectionView, UICollectionViewDataSource {
    var dataSourceMetirc: MetricObjModel! {
        didSet {
            reloadData()
        }
    }
    
    class func createRiskCollectionWithFrame(_ frame: CGRect, dataSourceMetirc: MetricObjModel) -> RiskCollectionView {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 3
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.sectionInset = UIEdgeInsets.zero
        
        let riskCollectionView = RiskCollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        riskCollectionView.backgroundColor = UIColor.clear
        riskCollectionView.indicatorStyle = .white
        
        riskCollectionView.register(TextCollectionViewCell.self, forCellWithReuseIdentifier: riskCellID)
        riskCollectionView.dataSource = riskCollectionView
        riskCollectionView.dataSourceMetirc = dataSourceMetirc
        
        return riskCollectionView
    }
    
    fileprivate var risks : [RiskObjModel]! {
        return AIDMetricCardsCollection.standardCollection.getMetricRelatedRiskModels(dataSourceMetirc.key!)
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return risks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: riskCellID, for: indexPath) as! TextCollectionViewCell
        cell.text = risks[indexPath.row].name!
        
        return cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let collectionViewLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.itemSize = CGSize(width: bounds.width / 8, height: bounds.height * 0.94)
    }
}
