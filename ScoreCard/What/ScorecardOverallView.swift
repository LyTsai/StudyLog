//
//  ScorecardOverallView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/25.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ScorecardOverallView: UIView {
    var forWhatIf = WHATIF
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var encoreButton: UIButton!
    
    // rainbow
    @IBOutlet weak var leftTag: UIImageView!
    @IBOutlet weak var rightTag: UIImageView!
    
    @IBOutlet weak var whatIfRainbowShadow: UIImageView!
    @IBOutlet weak var rainbow: UIImageView!
    @IBOutlet weak var resultPanel: ScorecardResultPanel! // draw
    @IBOutlet weak var pointer: UIImageView!
    @IBOutlet weak var baselineCPointer: UIImageView!
    
    @IBOutlet weak var scoreNumber: UILabel!
    @IBOutlet weak var scoreAppendLabel: UILabel!
    
    @IBOutlet weak var panelExplain: PanelExplain!
    @IBOutlet weak var distributionLevelLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultDecLabel: UILabel!

    @IBOutlet weak var playStateImageView: UIImageView!
    @IBOutlet weak var playedNumberLabel: UILabel!
    @IBOutlet weak var cardsNumberLabel: UILabel!
    @IBOutlet weak var noteButton: UIButton!
    
    // data
    fileprivate var noScore = true
    fileprivate var riskKey: String!
    fileprivate var userKey: String!
    
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        self.riskKey = measurement.riskKey!
        self.userKey = measurement.playerKey
        encoreButton.isHidden = true
        
        // data
        let risk = collection.getRisk(riskKey)!
        let tier = collection.getTierOfRisk(riskKey)!
        let cards = collection.getScoreCardsOfRisk(riskKey)
        let playedNumber = MatchedCardsDisplayModel.getCurrentMatchedCardsFromCards(cards).count
        let totalNumber = cards.count
        
        noScore = (tier == 3)
        
        // tierPosition
        // for distribution
        resultPanel.forPercent = noScore
        
        // show or hide
        distributionLevelLabel.isHidden = !noScore
        panelExplain.isHidden = !noScore
        
        pointer.isHidden = noScore
        levelLabel.isHidden = noScore
        resultLabel.isHidden = noScore
        resultDecLabel.isHidden = noScore
        scoreNumber.isHidden = noScore
        scoreAppendLabel.isHidden = noScore
        
        // assign texts
        // labels
        // des
        let lowToHigh = MatchedCardsDisplayModel.checkLowHighOfRisk(riskKey)
        rainbow.image = lowToHigh ? #imageLiteral(resourceName: "lowHighRainbow") : #imageLiteral(resourceName: "highLowRainbow")
       
        // panel, risk.classifiers
        var dialInfo = [(CGFloat, UIColor)]()
        resultPanel.forWhatIf = forWhatIf
        
        if noScore {
            resultPanel.totalNumber = totalNumber
            // distribution
            let classified = MatchedCardsDisplayModel.getScoreSortedCardsInMeasurement(measurement, lowToHigh: true)
            
            var explainInfo = [(UIColor, String)]()
            for (iden, cards) in classified {
                let color = MatchedCardsDisplayModel.getColorOfIden(iden)
                dialInfo.append((CGFloat(cards.count), color))
                explainInfo.append((color, MatchedCardsDisplayModel.getNameOfIden(iden)))
            }
            
            if explainInfo.count > 2 {
                let first = explainInfo.first!
                let last = explainInfo.last!
                explainInfo = [first, last]
            }
            
            panelExplain.explainInfo = explainInfo
            
            if let classifier = risk.classifiers.first {
                distributionLevelLabel.text = classifier.name
            }else {
                distributionLevelLabel.text = "Risk Level"
            }
        }else {
            // score
            let score = MatchedCardsDisplayModel.getTotalScoreOfMeasurement(measurement)
            scoreNumber.text = "\(score)"
            for classifier in risk.classifiers {
                let color = classifier.classification?.realColor ?? tabTintGreen
                let score = CGFloat(classifier.rangeGroup?.groupRanges.first?.max ?? 0)
                dialInfo.append((score, color))
            }
            
            // pointer
            if let classifier = MatchedCardsDisplayModel.getResultClassifierOfMeasurement(measurement) {
                levelLabel.text = classifier.name
                let resultName = classifier.classification?.displayName ?? "No Data"
                resultLabel.text = resultName
                resultDecLabel.attributedText = NSAttributedString(string: resultName, attributes: [NSAttributedStringKey.strokeColor: UIColor.black, NSAttributedStringKey.strokeWidth: NSNumber(value: 15)])
                resultLabel.textColor = classifier.classification?.realColor
                
                let max = MatchedCardsDisplayModel.getMaxScoreOfRisk(riskKey)
                let ratio = CGFloat(score / max)
                let rAngle = (ratio - 0.5) * CGFloat(Double.pi)
                pointer.transform = CGAffineTransform(rotationAngle: rAngle)
            }
            
            let offset = pointer.bounds.width * 0.5
            pointer.layer.anchorPoint = CGPoint(x: 0.5, y: 1 - offset / pointer.bounds.height)
        }
        
        resultPanel.dialInfo = dialInfo
        
        // bottom
        playStateImageView.image = (playedNumber == totalNumber ? #imageLiteral(resourceName: "scorecard_boxOpen") : #imageLiteral(resourceName: "scorecard_halfBox"))
        noteButton.isHidden = (playedNumber == totalNumber)
        playedNumberLabel.text = "\(playedNumber)"
        cardsNumberLabel.text = "\(totalNumber)"
        noteLabel.isHidden = true
        noteLabel.transform = CGAffineTransform(scaleX: 0.01, y: 1)
  
        setupWithState()
        encoreButton.isHidden = hideEncore(measurement)
    }
    
    fileprivate var baselineScore: Float = 0
    fileprivate func setupWithState() {
        whatIfRainbowShadow.isHidden = !forWhatIf
        baselineCPointer.isHidden = !forWhatIf
        leftTag.isHidden = !forWhatIf
        rightTag.isHidden = !forWhatIf
        pointer.image = forWhatIf ? #imageLiteral(resourceName: "pointer_whatIf") : #imageLiteral(resourceName: "pointer")

        if forWhatIf {
            // tags
            leftTag.image = noScore ? #imageLiteral(resourceName: "tag_baseline") : #imageLiteral(resourceName: "tag_baselinePointer")
            rightTag.image = noScore ? #imageLiteral(resourceName: "tag_whatIf") : #imageLiteral(resourceName: "tag_whatIfPointer")
            
            let baselineM = selectionResults.getLastMeasurementOfUser(userKey, riskKey: riskKey, whatIf: false)!
            if noScore {
                baselineCPointer.isHidden = true
                
                // panel
                let baseline = MatchedCardsDisplayModel.getScoreSortedCardsInMeasurement(baselineM, lowToHigh: true)
                var baselineInfo = [(CGFloat, UIColor)]()
                for (iden, cards) in baseline {
                    let color = MatchedCardsDisplayModel.getColorOfIden(iden)
                    baselineInfo.append((CGFloat(cards.count), color))
                }
                
                resultPanel.baselineInfo = baselineInfo
                
            }else {
                // score
                baselineScore = MatchedCardsDisplayModel.getTotalScoreOfMeasurement(baselineM)
                let max = MatchedCardsDisplayModel.getMaxScoreOfRisk(riskKey)
                let ratio = CGFloat(baselineScore / max)
                let rAngle = (ratio - 0.5) * CGFloat(Double.pi)
                baselineCPointer.transform = CGAffineTransform(rotationAngle: rAngle)
                
                let offset = pointer.bounds.width * 0.5
                baselineCPointer.layer.anchorPoint = CGPoint(x: 0.5, y: 1 - offset / pointer.bounds.height)
            }
        }
    }
    
    fileprivate func hideEncore(_ measurement: MeasurementObjModel) -> Bool {
        if let risk = collection.getRisk(measurement.riskKey) {
            if risk.metricKey == vitaminDMetricKey && RiskTypeType.getTypeOfRiskType(risk.riskTypeKey!) == .iRa {
                let allCards = collection.getScoreCardsOfRisk(risk.key)
                var judgeCard: CardInfoObjModel!
                for card in allCards {
                    if card.title!.contains("Gene Polymorphism") {
                        judgeCard = card
                        break
                    }
                }
                
                var matchIndex: Int!
                if judgeCard != nil {
                    if let metricKey = collection.getMetricKeyForSaveOfCard(judgeCard.key, inRisk: risk.key) {
                        for value in measurement.values {
                            if value.metricKey == metricKey {
    
                                for (i, option) in judgeCard.cardOptions.enumerated() {
                                    if option.matchKey! == value.matchKey {
                                        matchIndex = i
                                        break
                                    }
                                }
                                 break
                            }
                        }
                    }
                }
               
                if matchIndex != nil {
                    if matchIndex == 0 {
                        return false
                    }else if matchIndex == 1 {
                        var ageCard: CardInfoObjModel!
                        for card in allCards {
                            if card.title!.contains("Age") {
                                ageCard = card
                                break
                            }
                        }
                        if ageCard != nil {
                            if let metricKey = collection.getMetricKeyForSaveOfCard(ageCard.key, inRisk: risk.key) {
                                for value in measurement.values {
                                    if value.metricKey == metricKey {
                                        for (i, option) in ageCard.cardOptions.enumerated() {
                                            if option.matchKey! == value.matchKey {
                                                if i == 0 {
                                                    return false
                                                }
                                            }
                                        }
                                         break
                                    }
                                }
                            }
                        }
                    }
                }
                
                // encore
                let classified = MatchedCardsDisplayModel.getScoreSortedCardsInMeasurement(measurement, lowToHigh: true)
                if let last = classified.last {
                    if Float(last.cards.count) > 0.8 * Float(allCards.count) {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    // frames
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustSizes()
        
        noteButton.layer.cornerRadius = noteButton.frame.width * 0.5
        noteButton.layer.borderColor = UIColor.black.cgColor
       
        pointer.layer.position = CGPoint(x: resultPanel.frame.midX, y: resultPanel.frame.maxY)
        baselineCPointer.layer.position = CGPoint(x: resultPanel.frame.midX, y: resultPanel.frame.maxY)
    }
    
    fileprivate func adjustSizes() {
        let realFactor = bounds.width / 345
        
        noteLabel.font = UIFont.systemFont(ofSize: 12 * realFactor, weight: UIFont.Weight.medium)
        noteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16 * realFactor, weight: .bold)
        noteButton.layer.borderWidth = realFactor
        // fonts
        scoreNumber.font = UIFont.systemFont(ofSize: 24 * realFactor, weight: UIFont.Weight.semibold)
        scoreAppendLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor)
        resultLabel.font = UIFont.systemFont(ofSize: 16 * realFactor, weight: UIFont.Weight.bold)
        resultDecLabel.font = UIFont.systemFont(ofSize: 16 * realFactor, weight: UIFont.Weight.bold)
        
        levelLabel.font = UIFont.systemFont(ofSize: 14 * realFactor, weight: UIFont.Weight.medium)
        distributionLevelLabel.font = UIFont.systemFont(ofSize: 12 * realFactor, weight: UIFont.Weight.medium)
        
        playedNumberLabel.font = UIFont.systemFont(ofSize: 14 * realFactor, weight: UIFont.Weight.medium)
        cardsNumberLabel.font =  UIFont.systemFont(ofSize: 14 * realFactor, weight: UIFont.Weight.medium)
    }

    fileprivate var noteOnShow = false
    @IBAction func showOrHideNote(_ sender: UIButton) {
        noteOnShow = !noteOnShow
        sender.setTitle(self.noteOnShow ? "X" : "!", for: .normal)
        if noteOnShow {
            noteLabel.isHidden = false
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.noteLabel.transform = self.noteOnShow ? CGAffineTransform.identity : CGAffineTransform(scaleX: 0.01, y: 1)
        }) { (true) in
            if !self.noteOnShow {
                self.noteLabel.isHidden = true
            }
        }
    }
    
    @IBAction func showEncoreCard(_ sender: Any) {
        let encore = EncoreCardDisplayViewController()
        encore.modalPresentationStyle = .overCurrentContext
        viewController.present(encore, animated: true, completion: nil)
    }
}
