//
//  TwoLevelsGraph.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/1/6.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// MARK: -------------- Graph View -------------------
class TwoLevelsGraphView: UIView {
    var root = BasicGraphCell()
    var surroundings = [BasicGraphCell]()
    var selectedSub: BasicGraphCell!
    
    // set up of size, default is width/ height
    /** the width ratio of root: sub , from 1 to 4 */
    // use squre nodes
    var rsRatio: CGFloat = 1.2
    var minGapRatio: CGFloat = 0.04
    
    func addAllLayers() {
        layer.addSublayer(root)
        for sub in surroundings {
            layer.addSublayer(sub)
        }
    }
    
    func clearAll() {
        layer.sublayers = nil
        surroundings.removeAll()
    }
    
    func resizeCellsWithSize(_ size: CGSize) {
        rsRatio = max(min(rsRatio, 4), 1)
        let length = min(size.width, size.height)
        
        let gap = minGapRatio * length
        let subWidth = (length - 2 * gap) / (rsRatio + 2)
        let radius = 0.5 * (length - subWidth)
        let rootWidth = subWidth * rsRatio
        
        let center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        root.frame = CGRect(center: center, length: rootWidth)
        
        let angleGap = Calculation().angleGap(surroundings.count, totalAngle: 2 * CGFloat(Double.pi))
        for (i, sub) in surroundings.enumerated() {
            let angle = Calculation().getAngle(i, totalNumber: surroundings.count, startAngle: 0, endAngle: 2 * CGFloat(Double.pi))
            let position = Calculation().getPositionByAngle(angle, radius: radius, origin: center)
            sub.frame = CGRect(center: position, length: subWidth)
            
            if surroundings.count > 2 {
                let maxLength = 2 * sin(angleGap / 2 ) * radius / sqrt(2)
                // overlap
                if maxLength < subWidth {
                    sub.frame = Calculation().inscribeSqureRect(angleGap, startAngle: angle, radius: length * 0.5, vertex: center)
                }
            }
        }
    }
    // TODO: --------- draw rect about lines or something else ----------------
}

// MARK: ---------- create with keys ---------------
extension TwoLevelsGraphView {
    // factory
    class func createWithRiskKey(_ key: String, frame: CGRect) -> TwoLevelsGraphView {
        let graph = TwoLevelsGraphView()
        graph.setupWithRiskKey(key, frame: frame)
        
        return graph
    }
    
    class func createWithMetricKey(_ key: String, frame: CGRect) -> TwoLevelsGraphView {
        let graph = TwoLevelsGraphView()
        graph.setupWithMetricKey(key, frame: frame)
        
        return graph
    }
    
    // setup
    func setupWithRiskKey(_ key: String, frame: CGRect) {
        self.frame = frame
        clearAll()

        let risk = AIDMetricCardsCollection.standardCollection.getRisk(key)
        if risk == nil {
            print("risk does not exist")
            return
        }
        
        root = BasicGraphCell.createWithImage(risk!.imageObj?.cgImage, text: risk!.name)
        root.imagePosition = .down
        root.imageRatio = 0.7
        root.core = risk!
        
        let riskFactors = AIDMetricCardsCollection.standardCollection.getRiskFactors(key)
        if riskFactors == nil {
            print("no factors")
            // or just create the node of risk and return
            return
        }
        
        // TODO: -------- data fill adjust-----------
        for riskFactor in riskFactors! {
            let factorLayer = BasicGraphCell.createWithImage(riskFactor.metric?.imageObj?.cgImage, text: riskFactor.name)
            factorLayer.imageRatio = 0.4
            factorLayer.core = riskFactor
            surroundings.append(factorLayer)
        }
        
        addAllLayers()
        resizeCellsWithSize(frame.size)
    }
    
    func setupWithMetricKey(_ key: String, frame: CGRect) {
        self.frame = frame
        clearAll()
        
        let metric = AIDMetricCardsCollection.standardCollection.getMetric(key)
        
        if  metric == nil {
            print(" metric does not exist")
            return
        }
        
        root = BasicGraphCell.createWithImage(metric!.imageObj?.cgImage, text:  metric!.name)
        root.imagePosition = .down
        root.imageRatio = 0.75
        root.core = metric
        
        let risks = AIDMetricCardsCollection.standardCollection.getMetricRelatedRiskModels(key)
        if risks == nil {
            print("no risks")
            // or just create the node of risk and return
            return
        }
        
        // -------- data fill adjust-----------
        for risk in risks! {
            let riskLayer = BasicGraphCell.createWithImage(risk.imageObj?.cgImage, text: risk.name)
            riskLayer.imageRatio = 0.4
            riskLayer.core = risk
            surroundings.append(riskLayer)
        }

        addAllLayers()
        resizeCellsWithSize(frame.size)
    }
    
    // riskClass
    func setupWithRiskClass(_ riskClass: MetricObjModel, frame: CGRect) {
        self.frame = frame
        clearAll()
        
        root = BasicGraphCell.createWithImage(riskClass.imageObj?.cgImage, text:  riskClass.name)
        root.imagePosition = .down
        root.imageRatio = 0.75
        root.core = riskClass
        
        let factory = VDeckOfCardsFactory.metricDeckOfCards
        var metrics: [MetricObjModel] {
            var cardMetrics = [MetricObjModel]()
            for i in 0..<factory.totalNumberOfItems() {
                if let metric = factory.getVCard(i)?.metric {
                    cardMetrics.append(metric)
                }
             }
            
            return cardMetrics
        }
        // -------- data fill adjust-----------
        for metric in metrics {
            let metricLayer = BasicGraphCell.createWithImage(metric.imageObj?.cgImage, text: metric.name)
            metricLayer.imageRatio = 0.4
            metricLayer.core = metric
            surroundings.append(metricLayer)
        }
        
        addAllLayers()
        resizeCellsWithSize(frame.size)
    }
    
    
    // actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        for sub in surroundings {
            if sub.frame.contains(location) {
                selectedSub = sub
                rsRatio = max(min(rsRatio, 4), 1)
                let dx = frame.midX - sub.frame.midX
                let dy = frame.midY - sub.frame.midY
                UIView.animate(withDuration: 1, animations: {
                    let translation = CATransform3DMakeTranslation(dx, dy, 0)
                    sub.transform = CATransform3DScale(translation, self.rsRatio, self.rsRatio, 1)
                })
            }
        }
    }
    
    // long press ended, will call
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeAndChange()
    }
    // just touch and lift, will call
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeAndChange()
    }
    
    fileprivate func removeAndChange(){
        if selectedSub == nil {
            removeFromSuperview()
            return
        }
        
        // change
        if selectedSub.core.isKind(of: RiskObjModel.self) {
            let risk = selectedSub.core as! RiskObjModel
            self.setupWithRiskKey(risk.key!, frame: self.frame)
        }
            
        else if selectedSub.core.isKind(of: RiskFactorObjModel.self) {
            let factor = selectedSub.core as! RiskFactorObjModel
            self.setupWithMetricKey((factor.metric?.key)!, frame: self.frame)
        }
        
        selectedSub = nil
    }
}
