//
//  ScorecardBarDetailView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/7/2.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
class ScorecardBarDetailView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cardsBar: AnsweredCardsBar!
    @IBOutlet weak var barView: CustomProcessView!
    @IBOutlet weak var playStateImageView: UIImageView!
    @IBOutlet weak var playStateLabel: UILabel!
    
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    // distribution
    
    // score
    func setupWithScore(_ score: Float, total: Float, classifier: ClassifierObjModel) {
        cardsBar.isHidden = true
        
        titleLabel.text = "Overall Score"
        playStateImageView.image = nil
        resultLabel.text = "\(score) out of \(total)"
        barView.processVaule = CGFloat(score) / CGFloat(total)
        barView.processColor = classifier.classification?.realColor ?? tabTintGreen

        playStateLabel.text = ""
        dateLabel.text = ""
        totalLabel.text = ""
        resultImageView.sd_setImage(with: classifier.classification?.imageUrl, completed: nil)
        bottomLabel.text = ""
//            classifier.classification?.name
    }
    
    // cards
    func setupWithPlayed(_ played: Int, total: Int, date: Date) {
        cardsBar.isHidden = true
        
        titleLabel.text = "Cards Selected"
        resultLabel.text = "\(played)"
        playStateLabel.text = played == total ? "Complete" : "Incomplete"
        playStateImageView.image = played == total ? #imageLiteral(resourceName: "fullCheck") : #imageLiteral(resourceName: "warning")
        playStateLabel.textColor = played == total ? UIColorFromRGB(80, green: 211, blue: 135) : UIColorFromRGB(255, green: 159, blue: 0)
        barView.processVaule = CGFloat(played) / CGFloat(total)
        barView.processColor = tabTintGreen
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy"
        dateLabel.text = dateformatter.string(from: date)
        
        totalLabel.text = "\(total)"
        bottomLabel.text = "Total"
        resultImageView.image = nil
    }
    
    
    func setupWithDistribution(_ drawInfo: [(number: Int, color: UIColor)], total: Int) {
        cardsBar.isHidden = false
        cardsBar.layer.masksToBounds = true
        
        titleLabel.text = "Overall Distribution"
        playStateImageView.image = nil
        resultLabel.text = ""
       
        cardsBar.setupWithDrawInfo(drawInfo, totalNumber: total, focusIndex: nil)
        
        playStateLabel.text = ""
        dateLabel.text = ""
        totalLabel.text = ""
        resultImageView.image = nil
        bottomLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let fontSize = bounds.height / 6 // 10
        
        // fonts
        titleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightMedium)
        resultLabel.font = UIFont.systemFont(ofSize: fontSize * 1.2, weight: UIFontWeightMedium)
        playStateLabel.font = UIFont.systemFont(ofSize: fontSize)
        dateLabel.font = UIFont.systemFont(ofSize: fontSize)
        bottomLabel.font = UIFont.systemFont(ofSize: fontSize)
        totalLabel.font = UIFont.systemFont(ofSize: fontSize * 1.6, weight: UIFontWeightMedium)
        
        if !cardsBar.isHidden {
            cardsBar.layer.cornerRadius = cardsBar.bounds.height * 0.5
            
            cardsBar.setNeedsDisplay()
        }
    }
}


let scorecardBarCellID = "scorecard Bar Cell Identifier"
class ScorecardBarCell: UITableViewCell {
    let detail = Bundle.main.loadNibNamed("ScorecardBarDetailView", owner: self, options: nil)?.first as! ScorecardBarDetailView

    class func cellWithTable(_ table: UITableView, riskKey: String, userKey: String, forCard: Bool) -> ScorecardBarCell {
        var cell = table.dequeueReusableCell(withIdentifier: scorecardBarCellID) as? ScorecardBarCell
        if cell == nil {
            cell = ScorecardBarCell(style: .default, reuseIdentifier: scorecardBarCellID)
            cell?.contentView.addSubview(cell!.detail)
            cell?.selectionStyle = .none
        }
        
        cell?.setupWithRiskKey(riskKey, userKey: userKey, forCard: forCard)
        
        return cell!
    }
    
    fileprivate func setupWithRiskKey(_ riskKey: String, userKey: String, forCard: Bool) {
        let total = collection.getSortedCardsForRiskKey(riskKey).count
        if forCard {
            detail.setupWithPlayed(MatchedCardsDisplayModel.getMatchedCardsOfRisk(riskKey, forUser: userKey).count, total: total, date: Date())
        }else {
            // score
            if let classifier = MatchedCardsDisplayModel.getResultClassifierOfRisk(riskKey) {
                  let maxScore = MatchedCardsDisplayModel.getMaxScoreOfRisk(riskKey)
                detail.setupWithScore(MatchedCardsDisplayModel.getTotalScoreOfRisk(riskKey), total: maxScore, classifier: classifier)
            }else {
                // no classifier
                let cardsInfo = MatchedCardsDisplayModel.getHighLowClassifiedCardsOfRisk(riskKey, userKey: userKey)
                var drawInfo =  [(number: Int, color: UIColor)]()
                for (iden, cards) in cardsInfo {
                    drawInfo.append((cards.count, MatchedCardsDisplayModel.getColorOfIden(iden)))
                }
                detail.setupWithDistribution(drawInfo, total: total)
            }
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        detail.frame = bounds
    }
    
}
