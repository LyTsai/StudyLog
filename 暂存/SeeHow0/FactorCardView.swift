//
//  FactorCardView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/18.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class FactorCardView: UIView {
    fileprivate let backImageView = UIImageView(image: UIImage(named: "factorCardBackImage"))
    fileprivate let infoBtton = UIButton(type: .custom)
    fileprivate let factorView = CenteredView()
    
    class func createWithRiskFactor(_ riskFactor: RiskFactorObjModel) -> FactorCardView{
        let card = FactorCardView()
        card.addSubs()
        card.setupWithFactor(riskFactor)

        return card
    }
    
    fileprivate func addSubs() {
        infoBtton.setBackgroundImage(UIImage(named: "cardInfo"), for: .normal)
        
        addSubview(backImageView)
        addSubview(infoBtton)
    }
    
    fileprivate func setupWithFactor(_ factor: RiskFactorObjModel) {
        let metric = factor.metric
        
        // TODO: -------------- factor.metric is nil now --------------
        if metric == nil {
            return
        }
        
        let risks = AIDMetricCardsCollection.standardCollection.getMetricRelatedRiskModels(metric!.key!)
     
        var surroudings = [DisplayModel]()
        if risks != nil {
            for risk in risks! {
                // TODO: --------- data of color
                surroudings.append(DisplayModel(image: risk.imageObj, color: arc4random() % 3 == 0 ? UIColor.red : UIColor.green))
            }
        }
        
        let center = DisplayModel(image: metric?.imageObj, color: UIColorGray(236))
        factorView.setWithCenterImage(center, surroundings: surroudings)
        addSubview(factorView)
    }
    
    
    // layout
    fileprivate var mainWidth: CGFloat {
        return 249 * bounds.width / 305
    }
    fileprivate var mainHeight: CGFloat {
        return 335 * bounds.height / 392
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backImageView.frame = bounds
        let buttonLength = 40 * bounds.width / 305
        let buttonOffset = buttonLength * 0.25
        
        infoBtton.frame = CGRect(center: CGPoint(x: bounds.width - buttonOffset,y: buttonOffset), length: buttonLength)
        factorView.frame = CGRect(x: bounds.midX - mainWidth * 0.5, y: bounds.midY - mainHeight * 0.5, width: mainWidth, height: mainHeight)
    }
}
