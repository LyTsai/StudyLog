//
//  VisualMapConditionView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/8.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VisualMapConditionView: VisualMapConnectionView {
    override func loadBasicNodes() {
        switch basicType {
        case .riskClass:
            basicNodes = metricNodes
        case .symptoms:
            basicNodes = iSaCategoryNodes
        case .riskFactors:
            basicNodes = iRaCategoryNodes

//            cardsDistributionNodes
        }
        
        for node in basicNodes {
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(showScoreCard))
            node.addGestureRecognizer(tapGR)
            addSubview(node)
        }
        
        originalState()
    }
   
    override func originalState() {
//        clearCurrentCardsNode()
        
        // no chosen

        // layout
        centerImageView.frame = CGRect(center: viewCenter, length: 0.35 * maxRadius)
        ButterflyLayout.layoutEvenCircleWithRootCenter(viewCenter, children: basicNodes, radius: maxRadius * 0.45, startAngle: 90, expectedLength: maxRadius * 0.2)
        
        switch basicType {
        case .riskClass:
            break
        case .riskFactors:
            break
        case .symptoms:
            break
        }
    }
    
    func showScoreCard(_ tapGR: UITapGestureRecognizer) {
        let node = tapGR.view as! VisualMapNode
        
    }
}
