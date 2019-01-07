//
//  SeeHowRiskView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/4.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class SeeHowRiskView: UIView {
    // properties
    // basic view
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet var stateIndis: [UIView]!
    @IBOutlet var stateDesLabels: [UILabel]!
    
    @IBOutlet weak var moreButton: UIButton!
    
    // more risks view
    @IBOutlet weak var moreRiskView: UIView!
    @IBOutlet weak var risksDisplayView: RisksDisplayCollectionView!
    
    // awake from nib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // the more risk view
        clipsToBounds = true
        
        moreRiskView.layer.addBlackShadow(4)
        
        // layout
        layoutIfNeeded()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // border
        layer.cornerRadius = 8
        layer.borderWidth = 2
        
        // icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 5

        // button
        moreButton.layer.cornerRadius = 8
        
        // hide more
        moreRiskView.transform = CGAffineTransform(translationX: bounds.width * 0.8, y: 0)
        moreRiskView.layer.cornerRadius = 8
    }
    
    // set contents
    fileprivate var card = MatchedCardsDisplayModel()
    fileprivate var normalTextColor = UIColorFromRGB(136, green: 136, blue: 156)
    // set up content
    func setupWithCard(_ card: MatchedCardsDisplayModel) {
        self.card = card
        
        // first risk
        if let risk = card.risks.first {
            // image
            iconImageView.sd_setShowActivityIndicatorView(true)
            iconImageView.sd_setIndicatorStyle(.gray)
            iconImageView.sd_setImage(with: risk.imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, progress: nil) { (image, error, type, url) in
                if image == nil {
                    self.iconImageView.image = ProjectImages.sharedImage.placeHolder
                }
            }
            
            // texts
            titleLabel.text = risk.name
            detailLabel.text = risk.metric?.name
        }

        // classification
        if let classification = card.classification {
            let score = classification.score ?? 0
            var stateIndex = 0
            if score <= 1.0001 {
                stateIndex = 0
            }else if score <= 2.001 {
                stateIndex = 1
            }else {
                stateIndex = 2
            }
            
            for (i, view) in stateIndis.enumerated() {
                if i == stateIndex {
                    view.isHidden = false
                    view.layer.cornerRadius = 3
                    view.backgroundColor = classification.realColor
                    stateDesLabels[i].textColor = UIColor.black
                }else {
                    view.isHidden = true
                    stateDesLabels[i].textColor = normalTextColor
                }
            }
            
            layer.borderColor = classification.realColor?.cgColor
        }else {
            // classification is nil
            for (i, view) in stateIndis.enumerated() {
                if i == Int(card.results.first!) {
                    view.isHidden = false
                    view.layer.cornerRadius = 3
                    stateDesLabels[i].textColor = UIColor.black
                    layer.borderColor = view.backgroundColor?.cgColor
                }else {
                    view.isHidden = true
                    stateDesLabels[i].textColor = normalTextColor
                }
            }
            
        }
        
        // more risks
        // show others
        moreButton.isHidden = (card.risks.count == 1)
        
        if card.risks.count > 1 {
            var otherRisks = card.risks
            otherRisks.remove(at: 0)
            
            // risks display
            risksDisplayView.risks = otherRisks
        }
    }
    
    // actions
    @IBAction func forMore(_ sender: UIButton) {

        // show more risk view
        UIView.animate(withDuration: 0.4) { 
            self.moreRiskView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func hideMore() {
        UIView.animate(withDuration: 0.4) {
            self.moreRiskView.transform = CGAffineTransform(translationX: self.bounds.width * 0.8, y: 0)
        }
    }
    
}
