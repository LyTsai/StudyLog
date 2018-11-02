//
//  VisualMap.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/16.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VisualMap: UIView {
    var basicType = VisualMapType.riskClass
    
    // total
    var metricNodes: [VisualMapNode] {
        return VisualMapData.createAllMetricNodes()
    }
    var iRaCategoryNodes: [VisualMapNode] {
        return VisualMapData.createAllIRANodes()
    }
    var iSaCategoryNodes: [VisualMapNode] {
        return VisualMapData.createAllISaNodes()
    }
    
    // nodes on view
    var basicNodes = [VisualMapNode]()
    var topicNode: VisualMapNode!
    
    var cardView: VisualMapCardsDisplayView!
    var scorecardView: ScorecardDisplayView!
    
    var riskTypeKey: String!
    
    // UI information
    var viewCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    var maxRadius: CGFloat {
        return min(bounds.midX, bounds.midY)
    }
    
    let centerImageView = UIImageView(image: #imageLiteral(resourceName: "avatar_temp"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
        // center
        centerImageView.isUserInteractionEnabled = true
        centerImageView.contentMode = .scaleAspectFit
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(goBackToOriginalState))
        centerImageView.addGestureRecognizer(tapGR)
        
        // add
        addSubview(centerImageView)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // load nodes
    func loadBasicNodes() {
        // nodes
        switch basicType {
        case .riskClass:
            basicNodes = metricNodes
        case .riskFactors:
            basicNodes = iRaCategoryNodes
            riskTypeKey = iRaKey
        case .symptoms:
            basicNodes = iSaCategoryNodes
            riskTypeKey = iSaKey
        }
        
        if basicType == .riskClass {
            // score
            let topFrame = CGRect(x: bounds.width * 0.02, y: 0, width: bounds.width * 0.96, height: bounds.height - maxRadius * 0.1)
            scorecardView = ScorecardDisplayView.createWithFrame(topFrame, riskKeys: [])
            insertSubview(scorecardView, at: 0)
        }else {
            let cardFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - self.maxRadius * 0.6)
            cardView = VisualMapCardsDisplayView.createWithFrame(cardFrame, cardKeys: [])
            addSubview(cardView)
        }
        
        // add
        // basic
        for node in basicNodes {
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(nodeIsTapped(_:)))
            node.addGestureRecognizer(tapGR)
            addSubview(node)
        }
        
        originalState()
    }
    
    
    // MAKR: ---------- tap gestureRecognizer
    @objc func goBackToOriginalState() {
        UIView.animate(withDuration: 0.5, animations: {
            self.originalState()
        })
    }
    
    @objc func nodeIsTapped(_ tapGR: UITapGestureRecognizer) {
        let node = tapGR.view as! VisualMapNode
        
        if node.disabled {
            alert()
            return
        }
        
        
        // colored node is tapped
        if topicNode != nil && node.key == topicNode.key {
            // is current
            return
        }

        // old
        topicNode = node
        
        for node in basicNodes {
            node.showText = false
        }

        if basicType == .riskClass {
            let risks = MatchedCardsDisplayModel.getRisksPlayedForRiskClass(node.key)
            scorecardView.riskKeys = risks
        }else {
            let cards = MatchedCardsDisplayModel.getCardsPlayedOfCategory(node.key, riskTypeKey: riskTypeKey)
            cardView.cards = cards
        }
        
        let offset = maxRadius * 0.25
        let cornerCenter = CGPoint(x: offset, y: bounds.height - offset * 1.2)

        UIView.animate(withDuration: 0.5, animations: {
            // left down
            self.centerImageView.frame = CGRect(center: cornerCenter, length: self.maxRadius * 0.2)

            if self.basicType == .riskClass {
                ButterflyLayout.layoutEvenCircleWithRootCenter(cornerCenter, children: self.basicNodes, radius: self.maxRadius * 0.18, startAngle: 90, expectedLength: self.maxRadius * 0.12)
                node.frame = CGRect(center: node.center, length: node.frame.width * 2)
                self.bringSubview(toFront: node)
            }else {
                ButterflyLayout.layoutEvenCircleWithRootCenter(cornerCenter, children: self.basicNodes, radius: self.maxRadius * 0.15, startAngle: 90, expectedLength: self.maxRadius * 0.14)
                node.frame = CGRect(center: CGPoint(x: self.bounds.midX, y: cornerCenter.y), length: node.frame.width)
            }
        
        }, completion: { (true) in
            if self.basicType == .riskClass {
                self.scorecardView.isHidden = false
            }else {
                self.cardView.isHidden = false
            }
        })
    }

    // layout
    func originalState() {
        if basicType == .riskClass {
            scorecardView.isHidden = true
        }else {
            cardView.isHidden = true
        }
        
        // no chosen
        topicNode = nil
        for node in basicNodes {
            switch basicType {
            case .riskClass:
                node.disabled = (MatchedCardsDisplayModel.getRisksPlayedForRiskClass(node.key).count == 0)
            case .symptoms:
                node.showText = false
                node.disabled = (MatchedCardsDisplayModel.getCardsPlayedOfCategory(node.key, riskTypeKey: riskTypeKey).count == 0)
            case .riskFactors:
                node.disabled = (MatchedCardsDisplayModel.getCardsPlayedOfCategory(node.key, riskTypeKey: riskTypeKey).count == 0)
    
            }
        }
        
        // layout
        centerImageView.frame = CGRect(center: viewCenter, length: 0.35 * maxRadius)
        switch basicType {
        case .riskClass:
            let sorted = LandingModel.getAllTierRiskClasses()
            let first = sorted[0]!.count
            
            // one
            var groupedNodes = [Int: [VisualMapNode]]()
            
        
            
            // layout
            var startIndex = 0
            for i in 0..<3 {
                let number = sorted[i]!.count
                var nodes = [VisualMapNode]()
                for j in startIndex..<(startIndex + number) {
                    nodes.append(basicNodes[j])
                }
           
                ButterflyLayout.layoutEvenCircleWithRootCenter(viewCenter, children: nodes, radius: CGFloat(i) * maxRadius * 0.26 + maxRadius * 0.04 , startAngle: 90, expectedLength: i == 3 ? maxRadius * 0.35 : maxRadius * 0.2)
                startIndex += number
            }
            
        case .symptoms:
            var radii = [CGFloat]()
            for i in 0..<basicNodes.count {
                if i == 0 || i == 4 {
                    radii.append(maxRadius * 0.2)
                }else if i == 1 || i == 2  {
                    radii.append(maxRadius * 0.15)
                } else {
                    radii.append(maxRadius * 0.04)
                }
            }
            
            let frames = layoutPans(radii, inContainer: bounds, centerRadius: maxRadius * 0.4)
            for (i, node) in basicNodes.enumerated() {
                node.frame = frames[i]
            }
        case .riskFactors:
            ButterflyLayout.layoutEvenCircleWithRootCenter(viewCenter, children: basicNodes, radius: maxRadius * 0.7, startAngle: 90, expectedLength: maxRadius * 0.6)
        }
        
    }
    
    func alert() {
        let title = userCenter.userState != .login ? "You are not loggined in": "The cards are not loaded or played"
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Check Others", style: .default) { (true) in
            }
            alertController.addAction(action)
            let answer = UIAlertAction(title: "Go To Access Tab and Play", style: .default) { (true) in
                self.viewController.dismiss(animated: true, completion: {
                })
            }
            alertController.addAction(answer)

        viewController.present(alertController, animated: true, completion: nil)
    }

    
}
