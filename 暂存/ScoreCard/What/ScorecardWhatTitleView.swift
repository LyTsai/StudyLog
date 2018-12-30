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
        sloganImageView.image = lowToHigh ? #imageLiteral(resourceName: "lowGood") : #imageLiteral(resourceName: "highGood")
        descriptionLabel.text = lowToHigh ? "A game with a high overall score signals poor outcome – primary goal is to decrease the score." : "A game with a high overall score signals good outcome – primary goal is to increase the score."
        let riskTypeType = RiskTypeType.getTypeOfRiskType(risk.riskTypeKey!)
        if riskTypeType == .iIa {
            descriptionLabel.text = "A high overall score signals warning for elevated impact. The primary goal is to pay more attention and be proactive in prevention of \(risk.metric!.name ?? "")."
        }else if riskTypeType == .iSa {
            descriptionLabel.text = "A high overall score signals warning for the likelihood of \(risk.metric!.name ?? ""). The primary goal is to pay more attention and be proactive in seeking professional consultation soon."
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageH = bounds.height * 0.45
        sloganImageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: imageH).insetBy(dx: bounds.width * 0.1, dy: 0)
        descriptionLabel.frame = CGRect(x: 0, y: imageH, width: bounds.width, height: bounds.height - imageH)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: imageH * 0.25, weight: UIFont.Weight.regular)
        
    }
}
