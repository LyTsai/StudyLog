//
//  SummaryRiskClassesCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/23.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MARK: --------------------------- cell
let riskClassCellID = "Risk Class Cell Identifier"
class RiskClassCollectionViewCell: UICollectionViewCell {
    // open
    var text: String = "" {
        didSet{ textLabel.text = " \(text) " }
    }
    
    var isRelated = true {
        didSet {
            // the type of cells
            textLabel.textColor = (isRelated ? UIColor.black : UIColorGray(178))
            textLabel.backgroundColor = (isRelated ? UIColor.white : UIColorGray(248))
            outerShadow.isHidden = !isRelated
            innerShadow.isHidden = isRelated
        }
    }
    
    // private
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate var outerShadow = CALayer()
    fileprivate var innerShadow = CAShapeLayer()
    
    func setupUI() {
        outerShadow.shadowColor = UIColor.black.cgColor
        outerShadow.shadowOffset = CGSize(width: 0, height: 0.5)
        outerShadow.shadowRadius = 1.5
        outerShadow.shadowOpacity = 0.8
        
        textLabel.layer.cornerRadius = 2
        textLabel.layer.borderColor = UIColorGray(233).cgColor
        textLabel.layer.borderWidth = 1
        textLabel.layer.masksToBounds = true
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOffset = CGSize.zero
        innerShadow.shadowRadius = 1.5
        innerShadow.shadowOpacity = 0.8
        
        contentView.layer.addSublayer(outerShadow)
        contentView.addSubview(textLabel)
        contentView.layer.addSublayer(innerShadow)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds
        textLabel.font = UIFont.systemFont(ofSize: bounds.height / 3)
        
        let borderPath = UIBezierPath(roundedRect: textLabel.frame, cornerRadius: 2)
        outerShadow.shadowPath = borderPath.cgPath
        
        let innerPath = UIBezierPath(roundedRect: textLabel.frame.insetBy(dx: 0.5, dy: 0.5), cornerRadius: 2)
        borderPath.append(innerPath)
        innerShadow.path = borderPath.cgPath
        innerShadow.fillRule = kCAFillRuleEvenOdd
        let maskLayer = CAShapeLayer()
        maskLayer.path = innerPath.cgPath
        innerShadow.mask = maskLayer
    }
}

// MARK: -------------------- header
let riskClassHeaderID = "Risk Class header Identifier"
class RiskClassHeader: UICollectionReusableView {
    // open
    var text: String! {
        didSet{ textLabel.text = text }
    }

    
    // private
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        textLabel.numberOfLines = 0
        addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds
        textLabel.font = UIFont.systemFont(ofSize: bounds.height / 3)
    }
    
}

// MARK: --------------------------- collection
class RiskClassCollectionView: UICollectionView, UICollectionViewDataSource {
    var metric: MetricObjModel! {
        didSet {
            reloadData()
        }
    }
    
    class func createWithFrame(_ frame: CGRect, metric: MetricObjModel) -> RiskClassCollectionView {
        // layout
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        
        // create
        let collectionView = RiskClassCollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.clear
    
        // data
        collectionView.metric = metric
        
        collectionView.register(RiskClassCollectionViewCell.self, forCellWithReuseIdentifier: riskClassCellID)
        collectionView.register(RiskClassHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: riskClassHeaderID)

        collectionView.dataSource = collectionView
        
        return collectionView
    }
    
    fileprivate var totalRiskClasses: [MetricObjModel] {
        return AIDMetricCardsCollection.standardCollection.getRiskClasses()
    }
    
    fileprivate var relatedKeys : [String] {
        let relatedRisks = AIDMetricCardsCollection.standardCollection.getMetricRelatedRiskModels(metric.key!)
        
        if relatedRisks == nil {
            print("no related risks")
            return []
        }
        var keys = [String]()
        for risk in relatedRisks! {
            keys.append(risk.metricKey!)
        }
     
        return keys
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: riskClassHeaderID, for: indexPath) as! RiskClassHeader
        header.text = metric.name
        
        return header
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalRiskClasses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: riskClassCellID, for: indexPath) as! RiskClassCollectionViewCell
        cell.text = totalRiskClasses[indexPath.row].name!
        cell.isRelated = false
        
        let riskClassKey = totalRiskClasses[indexPath.row].key!
        
        if  relatedKeys.contains(riskClassKey) {
            cell.isRelated = true
        }
        
        return cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: 1, height: bounds.height / 3 - 2)
        
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
        layout.itemSize = CGSize(width: bounds.width / 5 - 4, height: bounds.height / 3 - 2)
    }
}
