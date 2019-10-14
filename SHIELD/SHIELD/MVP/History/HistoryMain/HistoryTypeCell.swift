//
//  HistoryTypeCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/20.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation
let historyTypeCellID = "history type cell identifier"
class HistoryTypeCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let label = UILabel()
    fileprivate func setupBasic() {
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = [0.01, 0.8]
        label.textAlignment = .center
        
        contentView.backgroundColor = UIColor.white
        contentView.layer.addSublayer(gradientLayer)
        contentView.addSubview(label)
        
        contentView.layer.masksToBounds = true
    }
    
    var isChosen: Bool! {
        didSet{
            if isChosen != oldValue {
                gradientLayer.isHidden = !isChosen
            }
        }
    }
    
    func configureWithRiskType(_ riskTypeKey: String!) {
        if let riskType = collection.getRiskTypeByKey(riskTypeKey) {
            configureWithColor(riskType.realColor ?? tabTintGreen, title: String(riskType.name![0..<3]))
        }
    }
    
    func configureWithRiskMetric(_ riskMetricKey: String!) {
        if let riskMetric = collection.getMetric(riskMetricKey) {
            configureWithColor(tabTintGreen, title: riskMetric.name!)
        }
    }
    
    func configureWithColor(_ color: UIColor, title: String) {
        gradientLayer.colors = [color.withAlphaComponent(0.2).cgColor, color.cgColor]
        contentView.layer.borderColor = color.cgColor
        label.text = title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        label.frame = bounds
        label.font = UIFont.systemFont(ofSize: bounds.height * 0.4, weight: .bold)
        contentView.layer.cornerRadius = bounds.height * 0.15
        contentView.layer.borderWidth = bounds.height * 0.05
    }
}
