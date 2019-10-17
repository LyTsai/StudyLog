//
//  ScorecardHeaderTagView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/29.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardHeaderTagView: UIView {
    fileprivate let titleLabel = UILabel()
    fileprivate let tagBack = CAGradientLayer()
    fileprivate let tagLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        tagBack.startPoint = CGPoint.zero
        tagBack.endPoint = CGPoint(x: 1, y: 0)
        tagLabel.numberOfLines = 0
        
        // add all
        addSubview(titleLabel)
        layer.addSublayer(tagBack)
        addSubview(tagLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupForScore(_ forScore: Bool) {
        let scoreText = "See how each of your card selection choice impact the overall score assessment. Tap on any thumbnail image to reveal that card."
        titleLabel.text = scoreText
        if !forScore {
            let complementaryText = "Complementary Cards do not contribute to the scoring assessment algorithm. But while your score is not impacted by them, they can provide you with additional actionable information and context."
            let complementaryAttri = NSMutableAttributedString(string: complementaryText, attributes: [.foregroundColor: UIColor.black])
            complementaryAttri.addAttributes([.foregroundColor: UIColorFromHex(0x00D7FF)], range: NSMakeRange(0, "Complementary Cards".count))
            titleLabel.attributedText = complementaryAttri
        }
        
        tagLabel.text = forScore ? "Card Score Ranking Distribution" : "Relative Risk Level"
        if forScore {
            tagBack.colors = [UIColorFromHex(0xB5B4FF).withAlphaComponent(0.9).cgColor, UIColorFromHex(0xB5B4FF).cgColor]
            tagBack.locations = [0.05, 0.1]
        }else {
            tagBack.colors = [UIColorFromHex(0x00D7FF).withAlphaComponent(0.9).cgColor, UIColorFromHex(0xB4EC51).cgColor]
            tagBack.locations = [0.05, 0.95]
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // layout
        let one = bounds.height / 87
        let tagHeight = 27 * one

        tagBack.frame = CGRect(x: 0, y: 0, width: bounds.width * 0.85, height: tagHeight)
        let tagMask = CAShapeLayer()
        let tagPath = UIBezierPath(roundedRect: tagBack.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: tagHeight * 0.5, height: tagHeight * 0.5))
        tagMask.path = tagPath.cgPath
        tagBack.mask = tagMask
        tagLabel.frame = tagBack.frame.insetBy(dx: tagHeight * 0.5, dy: 0)
        tagLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: .medium)
        
        titleLabel.font = UIFont.systemFont(ofSize: 11 * one)
        titleLabel.frame = CGRect(x: 0, y: tagBack.frame.maxY, width: bounds.width, height: bounds.height - tagHeight)
    }
}
