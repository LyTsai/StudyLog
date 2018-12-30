//
//  ScoreReferenceView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/12.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
class ScoreReferenceView: UIView {
    weak var scorecardAll: ScorecardDisplayAllView!
    @IBOutlet weak var scoreTitleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var sepLine: UIView!
    
    
    @IBAction func forMoreAboutIt(_ sender: UIButton) {
        
    }
    
    // scorecardKey
    enum DetailStyle {
        case brainAge
        case sleepQuality
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate var refView: UIView!
    
    func updateUI() {
        backgroundColor = UIColor.clear
        
        refView = Bundle.main.loadNibNamed("ScoreReferenceView", owner: self, options: nil)?.first as! UIView
        addSubview(refView)
        
        refView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        refView.frame = bounds
        refView.layoutSubviews()
        
        let factor = bounds.width / 345
        // top
        
        // fonts of score
        scoreTitleLabel.font = UIFont.systemFont(ofSize: 14 * factor, weight: UIFont.Weight.semibold)
        scoreLabel.font = UIFont.systemFont(ofSize: 28 * factor, weight: UIFont.Weight.semibold)
        totalScoreLabel.font = UIFont.systemFont(ofSize: 14 * factor, weight: UIFont.Weight.semibold)
        
        layoutRefView()
    }
    
    fileprivate var style: DetailStyle = .brainAge
    
    fileprivate let brainAge = BrainAgeReferenceView() // scroll
    fileprivate let vitaminD = VitaminDReferenceView()

    fileprivate let sleepQ = Bundle.main.loadNibNamed("SleepQualityResultView", owner: self, options: nil)?.first as! SleepQualityResultView
   
    let maskLayer = CAGradientLayer()
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        let riskKey = measurement.riskKey!
        if riskKey == brainAgeKey {
            style = .brainAge
        } else if riskKey == sleepQualityKey {
            style = .sleepQuality
        }
        
        if collection.getTierOfRisk(riskKey) != 3 {
            let maxScore = MatchedCardsDisplayModel.getMaxScoreOfRisk(riskKey)
            // score
            var scoreTitle = collection.getRisk(riskKey).scoreDisplayName ?? ""
            if riskKey == sleepQualityKey {
                scoreTitle = "Sleep Quality Score"
            }
            scoreTitleLabel.text = scoreTitle
            
            let scoreNumber = MatchedCardsDisplayModel.getTotalScoreOfMeasurement(measurement)
            scoreLabel.text = "\(String(scoreNumber))"
            totalScoreLabel.text = "out of \(maxScore)"
        }
        
        if style == .brainAge {
            brainAge.setupWithMeasurement(measurement)
            refView.addSubview(brainAge)
            brainAge.refDelegate = self
            
            addGradientMask()
        }else if style == .sleepQuality {
            sleepQ.setupWithMeasurement(measurement)
            refView.addSubview(sleepQ)
        }
    }
    
    func addGradientMask() {
        maskLayer.colors = [UIColor.white.withAlphaComponent(0.5).cgColor, UIColor.white.cgColor]
        maskLayer.locations = [0.3, 0.8]
        
        refView.layer.addSublayer(maskLayer)
    }
    
    func layoutRefView() {
        let withScoreFrame = CGRect(x: 0, y: sepLine.frame.maxY, width: bounds.width, height: bounds.height - sepLine.frame.maxY)
        switch style {
        case .brainAge:
            brainAge.layoutWithFrame(withScoreFrame)
            brainAge.delegate = self
            
            let maskH = bounds.height * 0.1
            maskLayer.frame = CGRect(x: 0, y: bounds.height - maskH, width: bounds.width, height: maskH)
        case .sleepQuality:
            sleepQ.frame = withScoreFrame
        }
    }
}

extension ScoreReferenceView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustLayer(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustLayer(scrollView)
    }
    
    fileprivate func adjustLayer(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let maxOffsetY = scrollView.contentSize.height - scrollView.bounds.height - maskLayer.bounds.height * 0.5
        maskLayer.isHidden = (offsetY >= maxOffsetY)
    }
}
