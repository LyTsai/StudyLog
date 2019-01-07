//
//  DialView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/1/14.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let panelRiskCellID = "Panel Risk Cell ID"
class PanelRiskCell: UICollectionViewCell {
    var image: UIImage! {
        didSet{
            layer.contents = image.cgImage
        }
    }
    
    var disabled = false {
        didSet {
            image = disabled ? image.convertImageToGrayScale() : image
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.9) * self.bounds.height
    }
    
}

class PanelView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    fileprivate var allRiskClasses: [MetricObjModel] {
        return AIDMetricCardsCollection.standardCollection.getRiskClasses()
    }
    
    var usedKeys = [String]()

    class func creatPanelWithFrame(_ frame: CGRect) -> PanelView {
        let circularLayout = CircularCollectionViewLayout()
        circularLayout.itemSize = CGSize(width: frame.width * 0.16, height: frame.width * 0.16)
        circularLayout.radius = frame.width * 0.42
        circularLayout.overlap = -0.2

        let panel = PanelView(frame: frame, collectionViewLayout: circularLayout)
        panel.register(PanelRiskCell.self, forCellWithReuseIdentifier: panelRiskCellID)
        panel.dataSource = panel
        panel.delegate = panel
        
        panel.backgroundColor = UIColor.clear
        
        return panel
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allRiskClasses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: panelRiskCellID, for: indexPath) as! PanelRiskCell
        
        let riskClass = allRiskClasses[indexPath.item]
        cell.image = riskClass.imageObj
        cell.disabled = !usedKeys.contains(riskClass.key!)
        
        return cell
    }
    
    // avoid the margins
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let maxWidth = contentSize.width
        contentOffset.x = min(max(0.11 * maxWidth, contentOffset.x), 0.8 * maxWidth)
    }
}
