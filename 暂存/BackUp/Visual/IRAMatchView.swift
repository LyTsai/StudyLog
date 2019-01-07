//
//  IRAMatchView.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/1/16.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class IRAMatchView: UIView, VisualNodeDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        basicUI()
    }
    
    fileprivate func basicUI() {
        backgroundColor = UIColor.clear
        
        loadData()
        riskClassView.backgroundColor = UIColor.clear
        categoryView.backgroundColor = UIColor.clear
        
        addSubview(riskClassView)
        addSubview(categoryView)
        
        for key in riskClassGroupedFactors.keys {
            let riskClass = AIDMetricCardsCollection.standardCollection.getMetric(key)!
            let node = VisualNode()
            node.key = riskClass.key
            node.text = riskClass.name
            node.imageUrl = riskClass.imageUrl
            //            node.color = riskClass.color
            // append
            node.delegate = self
            riskClassesNodes.append(node)
        }
        riskClassView.loadWithRoot(upAvatar, children: riskClassesNodes)
    }
    
    
    
    // ------------- riskClass center --------------
    // riskClass: [category: [riskFactor/card]]
    var riskClass2Factors = [String: [String]]()
    var riskClassGroupedFactors = [String: [String: [String]]]()
//    var riskClass2Factors = [MetricObjModel: [RiskFactorObjModel]]()
//    var riskClassGroupedFactors = [MetricObjModel: [MetricGroupObjModel: [RiskFactorObjModel]]]()
    
    // -------------category center --------------
    // category: [riskFactor/card: [riskClass]]
//    var categoryGrouped = [MetricGroupObjModel: [CardInfoObjModel: [MetricObjModel]]]()
    var categoryGrouped = [String: [String: [String]]]()
    
    func loadData() {
        riskClass2Factors.removeAll()
        riskClassGroupedFactors.removeAll()
        categoryGrouped.removeAll()
        
        // load
        let collection = AIDMetricCardsCollection.standardCollection
        for riskClass in collection.getTier3RiskClasses() {
            let riskKeys = collection.getRiskModelKeys(riskClass.key, riskType: iRaKey)
            var allFactorKeys = Set<String>()
            for riskKey in riskKeys {
                for factor in collection.getRiskFactors(riskKey) {
                    allFactorKeys.insert(factor.key)
                }
            }
            riskClass2Factors[riskClass.key] = Array(allFactorKeys)
            
            // grouped factors
            var categoryDic = [String: [String]]()
            
            for factorKey in allFactorKeys {
                let factor = AIDMetricCardsCollection.standardCollection.getRiskFactorByKey(factorKey)!
                if let metricGroupKey = factor.metricGroupKey {
                    if categoryDic[metricGroupKey] == nil {
                        categoryDic[metricGroupKey] = [factorKey]
                    }else {
                        categoryDic[metricGroupKey]!.append(factorKey)
                    }
                
                    // category
                    if let card = factor.card {
                        // category: [riskFactor/card: [riskClass]]
                        if categoryGrouped[metricGroupKey] == nil {
                            categoryGrouped[metricGroupKey] = [card.key: [riskClass.key]]
                        }else {
                            if categoryGrouped[metricGroupKey]![card.key] == nil {
                                categoryGrouped[metricGroupKey]![card.key] = [riskClass.key]
                            }else {
                                categoryGrouped[metricGroupKey]![card.key]!.append(riskClass.key)
                            }
                        }
                    }
                }
            }
            
            riskClassGroupedFactors[riskClass.key] = categoryDic
        }
    }
    
    
    let riskClassView = SurroundingMapView()
    let categoryView = SurroundingMapView()
    var riskClassesNodes = [VisualNode]()
    var categoryNodes = [VisualNode]()
    
    fileprivate let upAvatar = UIImageView(image: ProjectImages.sharedImage.maleAvatar)
    fileprivate let downAvatar = UIImageView(image: ProjectImages.sharedImage.maleAvatar)
    func loadTwoParts() {
        loadData()
        
        let topHeight = bounds.height * 0.6
        riskClassView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: topHeight)
        categoryView.frame = CGRect(x: bounds.width * 0.1, y: topHeight, width: bounds.width * 0.8, height: bounds.height - topHeight)
        
        // nodes
        categoryNodes.removeAll()
        for categoryKey in categoryGrouped.keys {
            let category = AIDMetricCardsCollection.standardCollection.getMetricGroupByKey(categoryKey)!
            let node = VisualNode()
            node.key = category.key
            node.text = category.name
            node.imageUrl = category.imageUrl
            //            node.color = riskClass.color
            // append
            node.delegate = self
            categoryNodes.append(node)
        }
        
        let avatarSize = CGSize(width: 111 * fontFactor * 0.7, height: 76 * fontFactor * 0.7)
        let nodeSize = CGSize(width: 50 * fontFactor, height: 50 * fontFactor)
        riskClassView.layNodes(avatarSize, childSize: nodeSize)
        categoryView.loadWithRoot(downAvatar, children: categoryNodes)
        categoryView.layNodes(avatarSize, childSize: nodeSize)
        
        
        var tile = CATransform3DRotate(CATransform3DIdentity, CGFloat(Double.pi) / 5, 1, -0.5, 0)
//        tile = CATransform3DScale(tile, 0.9, 0.9, 0.5)
        riskClassView.layer.transform = tile
        categoryView.layer.transform = tile
        
        setNeedsDisplay()
    }
    
    
    func nodeIsTapped(_ node: VisualNode) {
        UIView.animate(withDuration: 0.5, animations: {
            self.riskClassView.layer.transform = CATransform3DIdentity
            self.categoryView.layer.transform = CATransform3DIdentity
        }, completion: {(true) in
            self.setNeedsDisplay()
        })
        
        if riskClassGroupedFactors.keys.contains(node.key) {
            focusOnRiskClass(node.key)
            
            // risk class
        
            
        }else {
            UIView.animate(withDuration: 0.5, animations: {
                self.categoryView.layer.transform = CATransform3DIdentity
            })
        }
        
    }
    
    fileprivate func focusOnRiskClass(_ key: String) {
         let dic = riskClassGroupedFactors[key]!
        
    }
    
    
    override func draw(_ rect: CGRect) {
        let viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        for node in riskClassesNodes {
            for cNode in categoryNodes {
                if riskClassGroupedFactors[node.key]?[cNode.key] != nil {
                    let path = UIBezierPath()

                    path.move(to: convert(node.center, from: riskClassView))
                    path.addCurve(to: convert(cNode.center, from: categoryView), controlPoint1: viewCenter, controlPoint2: viewCenter)
//                    path.addLine(to: convert(cNode.center, from: categoryView))
                    path.stroke()
                }
            }
        }
    }
}
