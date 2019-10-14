//
//  ScorecardWhatTitleView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/30.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardWhatTitleView: UIView {
    fileprivate var sloganImageView = UIImageView()
    fileprivate var descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    fileprivate func setupBasic() {
        sloganImageView.contentMode = .scaleAspectFit
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        addSubview(sloganImageView)
        addSubview(descriptionLabel)
    }
    
    func setupWithRiskKey(_ riskKey: String) {
        let lowToHigh = MatchedCardsDisplayModel.checkLowHighOfRisk(riskKey)
        let risk = collection.getRisk(riskKey)!
        let riskTypeType = RiskTypeType.getTypeOfRiskType(risk.riskTypeKey!)
        
        sloganImageView.image = lowToHigh ? #imageLiteral(resourceName: "lowGood") : #imageLiteral(resourceName: "highGood")
    
        if riskTypeType == .iKa {
            descriptionLabel.text = "Large % of low scoring cards signals poorer outcome. \nGoal: lower the % of such cards to foster “Slow Aging By Design”."
        }else if riskTypeType == .iRa {
            descriptionLabel.text = "Large % of high scoring cards signals poorer outcome. \nGoal: lower the % of such cards to foster “Slow Aging By Design”."
        }else if riskTypeType == .iIa {
            descriptionLabel.text = "The larger the % of high linkage cards, the higher is the negative impact of the interconnections on you. \nGoal: prevention is the most direct path to foster \"Slow Aging By Design\"."
        }else if riskTypeType == .iSa {
            descriptionLabel.text = "Large % of high frequency cards signals poorer outcome. \nGoal: lower the % of such cards to foster “Slow Aging By Design”."
        }else if riskTypeType == .iAa || riskTypeType == .iFa {
            descriptionLabel.text = "Large % of high commitment cards signals better outcome.\nGoal: raise the % of such cards to foster “Slow Aging By Design”."
        } else {
            descriptionLabel.text = lowToHigh ? "High overall score signals poorer outcome.\nGoal: lower the overall score to foster “Slow Aging By Design”." : "High scoring cards signals better outcome.\nGoal: increase the overall score to foster “Slow Aging By Design”"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageH = bounds.height * 0.45
        sloganImageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: imageH).insetBy(dx: bounds.width * 0.1, dy: 0)
        descriptionLabel.frame = CGRect(x: 0, y: imageH, width: bounds.width, height: bounds.height - imageH)
        descriptionLabel.font = UIFont.systemFont(ofSize: imageH * 0.25, weight: .regular)
    }
}
