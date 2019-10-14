//
//  ScorecardCoverView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/27.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ScorecardCoverView: UIView {
    @IBOutlet weak var coverTopImageView: UIImageView!
    
    @IBOutlet weak var labelWidthLayout: NSLayoutConstraint!
    // top
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userGender: UILabel!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    // cards
    // distribution
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var explainBlocks: PanelExplain!
    @IBOutlet weak var distributionLabel: UILabel!
    @IBOutlet weak var cardsBar: AnsweredCardsBar!
    @IBOutlet weak var percentLabel: UILabel!
    
    // score
    @IBOutlet weak var scoreTitleDecoLabel: UILabel!
    @IBOutlet weak var scoreTitleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreBar: ColorfulProcessBar!
    
    // selected
    @IBOutlet weak var cardsBarView: CustomProcessView!
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var playStateImageView: UIImageView!
    @IBOutlet weak var playStateLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    // achievements
    @IBOutlet weak var achievementLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addView()
    }
    
    fileprivate var cover: UIView!
    fileprivate func addView() {
        self.backgroundColor = UIColor.clear
    
        cover = Bundle.main.loadNibNamed("ScorecardCoverView", owner: self, options: nil)?.first as? UIView
        addSubview(cover)
        cover.layer.masksToBounds = true
        userIcon.layer.masksToBounds = true
        
        coverImage.transform = CGAffineTransform(rotationAngle: -0.06 * CGFloatPi)
    }
    
    fileprivate var metricName = ""
    fileprivate var riskTypeName = ""
    fileprivate var scoreRatio: CGFloat = 1
    func setupWithUserInfo(_ userInfo: UserInfoObjModel, measurement: MeasurementObjModel) {
        coverTopImageView.image = (measurement.whatIfFlag == 1) ? #imageLiteral(resourceName: "scorecard_coverTop_virtual") : #imageLiteral(resourceName: "scorecard_coverTop")
        
        userName.text = userInfo.displayName
        userGender.text = "\(userInfo.sex ?? "Not told")"
        
        var playerName = userInfo.displayName ?? ""
        if userCenter.loginKey == userCenter.currentGameTargetUser.Key() {
            playerName = "Myself"
        }
        detailLabel.text = "Player: Me\nAssessment for: \(playerName)\nAssessment Adjudicator: AnnielyticX"
        
        let riskKey = measurement.riskKey!
        
        if let risk = collection.getRisk(riskKey) {
            metricName = risk.metric!.name
            riskTypeName = collection.getFullNameOfRiskType(risk.riskTypeKey!)
            
            let tier = collection.getTierOfRisk(riskKey)
            let total = collection.getScoreCardsOfRisk(riskKey).count
            let played = MatchedCardsDisplayModel.getMatchedScoreCardsInMeaurement(measurement).count
            
            distributionLabel.text = (tier == 2) ? "Overall Distribution" : "Your overall score"
            explainBlocks.isHidden = (tier != 2)
            explainLabel.isHidden = (tier != 2)
            percentLabel.isHidden = (tier != 2)
            cardsBar.isHidden = (tier != 2)
            
            scoreTitleLabel.isHidden = (tier == 2)
            scoreTitleDecoLabel.isHidden = (tier == 2)
            scoreLabel.isHidden = (tier == 2)
            scoreBar.isHidden = (tier == 2)
            
            if tier == 2 {
                // distribution
                let cardsInfo = MatchedCardsDisplayModel.getScoredClassifiedCardsInMeasurement(measurement, badToGood: true)
                
                var drawInfo = [(number: Int, color: UIColor)]()
                var explainInfo = [(UIColor, String)]()
                for (iden, cards) in cardsInfo {
                    let color = MatchedCardsDisplayModel.getColorOfIden(iden)
                    drawInfo.append((cards.count, color))
                    explainInfo.append((color, MatchedCardsDisplayModel.getNameOfIden(iden)))
                }
                
                explainLabel.text = "Personal \(risk.classifiers.first?.name ?? "Assessment Level")"
                explainBlocks.explainInfo = explainInfo
                cardsBar.showPercent = true
                cardsBar.setupWithDrawInfo(drawInfo, totalNumber: total, focusIndex: nil)
                let percent = Int(Float(played)/Float(total) * 100)
                percentLabel.text = "\(percent)%"
            }else {
                // score
                if let result = MatchedCardsDisplayModel.getResultClassifierOfMeasurement(measurement) {
                    let levelText = NSMutableAttributedString(string: "Overall \(result.name ?? "Level"): ", attributes: [ .foregroundColor: UIColorFromHex(0x58595B)])
                    let prefixLength = levelText.length
                    levelText.append(NSAttributedString(string: "\(result.classification?.name ?? "Wait for add in backend")", attributes: [.foregroundColor: result.classification?.realColor ?? UIColor.brown]))
                   
                    scoreTitleLabel.attributedText = levelText
                    levelText.addAttributes([.strokeColor: UIColor.black, .strokeWidth: NSNumber(value: 15)], range: NSMakeRange(prefixLength, levelText.length - prefixLength))
                    scoreTitleDecoLabel.attributedText = levelText
                    
                    let maxScore = MatchedCardsDisplayModel.getMaxScoreOfRisk(riskKey)
                    let score = MatchedCardsDisplayModel.getTotalScoreOfMeasurement(measurement)
                    scoreLabel.text = "\(score) out of \(maxScore)"
                    scoreRatio = CGFloat(score / maxScore)
                    
                    // scoreBar
                    var drawInfo = [(UIColor, CGFloat)]()
                    for classifier in risk.classifiers {
                        let color = classifier.classification?.realColor ?? UIColor.brown
                        let score = CGFloat(classifier.rangeGroup?.groupRanges.first?.max ?? 0)
                        drawInfo.append((color, score))
                    }
                    scoreBar.setWithDrawInfo(drawInfo, current: CGFloat(score), currentColor: result.classification?.realColor ?? UIColor.brown)
                    // leave it as "About" since this is not about the score only
                    //subTitle = (result.classification?.name)!
                }
            }
            
            // cards
            selectedLabel.text = "Cards Selected: \(played)"
            playStateLabel.text = played == total ? "Complete" : "Incomplete"
            playStateImageView.image = played == total ?  #imageLiteral(resourceName: "box_open_1") : #imageLiteral(resourceName: "box_half_1")
            playStateLabel.textColor = played == total ? UIColorFromRGB(80, green: 211, blue: 135) : UIColorFromRGB(255, green: 159, blue: 0)
            cardsBarView.processVaule = CGFloat(played) / CGFloat(total)
            cardsBarView.processColor = UIColorFromHex(0x768DFB)
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yyyy"
            dateLabel.text = dateformatter.string(from: Date())
            
            totalLabel.text = "\(total)"
        }
        
        imagePick.delegate = self
        imagePick.allowsEditing = true
        
        setupTitle()
        setLabelWidth()
    }
    
    fileprivate var subTitle:String = "About"
    fileprivate func setupTitle() {
        let one = bounds.width / 363
        let basicString = NSMutableAttributedString(string: "Scorecard Concerto:\n", attributes: [ .font: UIFont.systemFont(ofSize: 14 * one, weight: .semibold)])
        basicString.append(NSAttributedString(string: subTitle, attributes:[ .font: UIFont.systemFont(ofSize: one * 12)]))
        gameTitleLabel.attributedText = basicString
    }
    
    fileprivate func setLabelWidth() {
        scoreLabel.sizeToFit()
        let labelWidth = scoreLabel.frame.width
        let middleY = (scoreRatio * scoreBar.frame.width) + scoreBar.frame.minX
        labelWidthLayout.constant = min(max(middleY + labelWidth * 0.5, labelWidth), totalLabel.frame.maxX)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cover.frame = bounds
        cover.layoutSubviews()
        bannerView.layoutSubviews()

        let one = bounds.width / 363
        cover.layer.cornerRadius = 8 * one
        backView.layer.cornerRadius = 8 * one
        userIcon.layer.cornerRadius = userIcon.frame.width * 0.5
        
        userName.font = UIFont.systemFont(ofSize: 22 * one, weight: .semibold)
        userGender.font = UIFont.systemFont(ofSize: 12 * one, weight: .medium)
        detailLabel.font = UIFont.systemFont(ofSize: 10 * one, weight: .medium)
        
        let numberFont = UIFont.systemFont(ofSize: 12 * one, weight: .semibold)
        achievementLabel.font = numberFont
        
        // fonts
        explainLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: .medium)
        distributionLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: .medium)
        scoreTitleLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: .medium)
        scoreTitleDecoLabel.font = scoreTitleLabel.font
        scoreLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: .medium)
        percentLabel.font = UIFont.systemFont(ofSize: 16 * one, weight: .medium)
        selectedLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: .medium)
        playStateLabel.font = UIFont.systemFont(ofSize: 10 * one)
        dateLabel.font = UIFont.systemFont(ofSize: 10 * one)
        bottomLabel.font = UIFont.systemFont(ofSize: 10 * one)
        totalLabel.font = UIFont.systemFont(ofSize: 16 * one, weight: .medium)
        
        scoreBar.setNeedsDisplay()
        maskBanner()
        
        setupTitle()
        setLabelWidth()
    }
    
    fileprivate func maskBanner() {
        // mask
        let maskPath = UIBezierPath()
        maskPath.move(to: CGPoint.zero)
        maskPath.addLine(to: CGPoint(x: 0, y: bannerView.bounds.height))
        maskPath.addLine(to: CGPoint(x: bannerView.bounds.width, y: bannerView.bounds.height))
        maskPath.addLine(to: CGPoint(x: gameTitleLabel.frame.maxX, y: bannerView.bounds.midY))
        maskPath.addLine(to: CGPoint(x: bannerView.bounds.width, y: 0))
        
        maskPath.close()
        let shapeMask = CAShapeLayer()
        shapeMask.path = maskPath.cgPath
        bannerView.layer.mask = shapeMask
    }

    fileprivate let imagePick = UIImagePickerController()
    @IBAction func chooseAvatar(_ sender: Any) {
        let alert = CatCardAlertViewController()
        alert.addTitle("Choose Avatar", subTitle: "from", buttonInfo:[("Photo Library", true, chooseFromLibrary)])
        viewController.presentOverCurrentViewController(alert, completion: nil)
    }
    
    fileprivate func chooseFromLibrary() {
        self.imagePick.sourceType = .photoLibrary
        self.viewController.present(self.imagePick, animated: true) {
            
        }
    }
}

extension ScorecardCoverView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        userIcon.image = image

        imagePick.dismiss(animated: true) {
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePick.dismiss(animated: true) {
        }
    }

}
