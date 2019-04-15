//
//  RefrenceView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/16.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ReferenceView: UIView {
    weak var detailDelegate: ScorecardDetailView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    let scoreTitleLabel = UILabel()
   
    let scoreTextView = UITextView()
    let sepLine = UIView()
    
    func updateUI() {
        backgroundColor = UIColor.clear
        
        scoreTextView.backgroundColor = UIColorFromRGB(255, green: 250, blue: 246)
        scoreTextView.isEditable = false
        scoreTextView.isScrollEnabled = false
        scoreTextView.isSelectable = false
        
        sepLine.backgroundColor = UIColorGray(222)
        
        addSubview(scoreTextView)
        addSubview(sepLine)

    }
    
    func setupWithRiskKey(_ riskKey: String, userKey: String, factor: CGFloat) {
        if let _ = MatchedCardsDisplayModel.getResultClassifierOfRisk(riskKey) {
            let maxScore = collection.getRisk(riskKey).classifiers.last!.rangeGroup?.groupRanges.first!.max ?? 0
            // score
            let titleStyle = NSMutableParagraphStyle()
            titleStyle.alignment = .center
            
            var scoreTitle = collection.getRisk(riskKey).scoreDisplayName ?? ""
            if riskKey == vitaminDInKey {
                scoreTitle = "Vitamin D Insufficiency Score"
            }
            let scoreString = NSMutableAttributedString(string: "\(scoreTitle)\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14 * fontFactor * factor, weight: UIFontWeightSemibold), NSParagraphStyleAttributeName: titleStyle])
            
            let scoreNumber = MatchedCardsDisplayModel.getTotalScoreOfRisk(riskKey)
            scoreString.append(NSAttributedString(string: "\(String(scoreNumber))", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 28 * fontFactor * factor, weight: UIFontWeightSemibold), NSParagraphStyleAttributeName: titleStyle]))
            scoreString.append(NSAttributedString(string: " out of \(maxScore)\n", attributes: [NSForegroundColorAttributeName: UIColor.black.withAlphaComponent(0.5), NSFontAttributeName: UIFont.systemFont(ofSize: 14 * fontFactor * factor, weight: UIFontWeightSemibold), NSParagraphStyleAttributeName: titleStyle]))
            scoreTextView.attributedText = scoreString
        }
    }
    

}
