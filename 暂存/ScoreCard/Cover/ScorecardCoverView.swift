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
    
    // top
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userGender: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    // cards
    // distribution
    @IBOutlet weak var explainBlocks: PanelExplain!
    @IBOutlet weak var distributionLabel: UILabel!
    @IBOutlet weak var cardsBar: AnsweredCardsBar!
    @IBOutlet weak var percentLabel: UILabel!
    
    // score
    @IBOutlet weak var scoreTitleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreBar: CustomProcessView!
    
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
        cover = Bundle.main.loadNibNamed("ScorecardCoverView", owner: self, options: nil)?.first as! UIView
        addSubview(cover)
        cover.layer.masksToBounds = true
        userIcon.layer.masksToBounds = true
    }
    
    fileprivate var metricName = ""
    fileprivate var riskTypeName = ""
    func setupWithUserInfo(_ userInfo: UserinfoObjModel, measurement: MeasurementObjModel) {
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
            
            let tier = collection.getTierOfRisk(riskKey)!
            let total = collection.getScoreCardsOfRisk(riskKey).count
            let played = MatchedCardsDisplayModel.getMatchedScoreCardsInMeaurement(measurement).count
            
            distributionLabel.isHidden = (tier != 3)
            explainBlocks.isHidden = (tier != 3)
            percentLabel.isHidden = (tier != 3)
            cardsBar.isHidden = (tier != 3)
            
            scoreTitleLabel.isHidden = (tier == 3)
            scoreLabel.isHidden = (tier == 3)
            scoreBar.isHidden = (tier == 3)
            
            if tier == 3 {
                // distribution
                let cardsInfo = MatchedCardsDisplayModel.getScoredClassifiedCardsInMeasurement(measurement, badToGood: true)
//                getScoreSortedCardsInMeasurement(measurement, lowToHigh: true)
                
                var drawInfo =  [(number: Int, color: UIColor)]()
                var explainInfo = [(UIColor, String)]()
                for (iden, cards) in cardsInfo {
                    let color = MatchedCardsDisplayModel.getColorOfIden(iden)
                    drawInfo.append((cards.count, color))
                    explainInfo.append((color, MatchedCardsDisplayModel.getNameOfIden(iden)))
                }
             
                if explainInfo.count > 2 {
                    let first = explainInfo.first!
                    let last = explainInfo.last!
                    explainInfo = [first, last]
                }
                
                explainBlocks.explainInfo = explainInfo
                cardsBar.showPercent = true
                cardsBar.setupWithDrawInfo(drawInfo, totalNumber: total, focusIndex: nil)
                let percent = Int(Float(played)/Float(total) * 100)
                percentLabel.text = "\(percent)%"
            }else {
                // score
                if let classifier = MatchedCardsDisplayModel.getResultClassifierOfMeasurement(measurement) {
                    scoreTitleLabel.text = "Overall \(classifier.name ?? "Score")"
                    let maxScore = MatchedCardsDisplayModel.getMaxScoreOfRisk(riskKey)
                    let score = MatchedCardsDisplayModel.getTotalScoreOfMeasurement(measurement)
                    scoreLabel.text = "\(score) out of \(maxScore)"
                    scoreBar.processVaule = CGFloat(score) / CGFloat(maxScore)
                    scoreBar.processColor = classifier.classification?.realColor ?? UIColorFromRGB(0, green: 200, blue: 83)
                }
            }
            
            // cards
            selectedLabel.text = "Cards Selected: \(played)"
            playStateLabel.text = played == total ? "Complete" : "Incomplete"
            playStateImageView.image = played == total ? #imageLiteral(resourceName: "fullCheck") : #imageLiteral(resourceName: "warning")
            playStateLabel.textColor = played == total ? UIColorFromRGB(80, green: 211, blue: 135) : UIColorFromRGB(255, green: 159, blue: 0)
            cardsBarView.processVaule = CGFloat(played) / CGFloat(total)
            cardsBarView.processColor = UIColorFromRGB(0, green: 200, blue: 83)
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yyyy"
            dateLabel.text = dateformatter.string(from: Date())
            
            totalLabel.text = "\(total)"
        }
        
        imagePick.delegate = self
        imagePick.allowsEditing = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cover.frame = bounds
        cover.layoutSubviews()

        let one = bounds.width / 345
        cover.layer.cornerRadius = 8 * one
        userIcon.layer.cornerRadius = userIcon.frame.width * 0.5
        
        userName.font = UIFont.systemFont(ofSize: 22 * one, weight: UIFont.Weight.semibold)
        userGender.font = UIFont.systemFont(ofSize: 12 * one, weight: UIFont.Weight.medium)
        detailLabel.font = UIFont.systemFont(ofSize: 10 * one, weight: UIFont.Weight.medium)
    
        
        let topString = "\(metricName)\n- \(riskTypeName)"
        
        let basicString = NSMutableAttributedString(string: topString, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14 * one, weight: UIFont.Weight.bold)])
        basicString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: one * 12, weight: UIFont.Weight.medium)], range: NSMakeRange(metricName.count, riskTypeName.count + 3))
        gameTitleLabel.attributedText = basicString
        
        let numberFont = UIFont.systemFont(ofSize: 12 * one, weight: UIFont.Weight.semibold)
        achievementLabel.font = numberFont
        
        // fonts
        distributionLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: UIFont.Weight.medium)
        scoreTitleLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: UIFont.Weight.medium)
        scoreLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: UIFont.Weight.medium)
        percentLabel.font = UIFont.systemFont(ofSize: 16 * one, weight: UIFont.Weight.medium)
        selectedLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: UIFont.Weight.medium)
        playStateLabel.font = UIFont.systemFont(ofSize: 10 * one)
        dateLabel.font = UIFont.systemFont(ofSize: 10 * one)
        bottomLabel.font = UIFont.systemFont(ofSize: 10 * one)
        totalLabel.font = UIFont.systemFont(ofSize: 16 * one, weight: UIFont.Weight.medium)
    }

    fileprivate let imagePick = UIImagePickerController()
    @IBAction func chooseAvatar(_ sender: Any) {
        
        let alert = UIAlertController(title: "Choose Avatar", message: "from", preferredStyle: .alert)

        let photo = UIAlertAction(title: "Photo Library", style: .default) { (true) in
            self.imagePick.sourceType = .photoLibrary
            self.viewController.present(self.imagePick, animated: true) {
                
            }
        }
        
//        let camera = UIAlertAction(title: "Camera", style: .default) { (true) in
//            self.imagePick.sourceType = .camera
//            self.viewController.present(self.imagePick, animated: true) {
//
//            }
//        }
//
//        let savedPhotos = UIAlertAction(title: "savedPhotosAlbum", style: .default) { (true) in
//            self.imagePick.sourceType = .savedPhotosAlbum
//            self.viewController.present(self.imagePick, animated: true) {
//
//            }
//        }
        
        alert.addAction(photo)
//        alert.addAction(camera)
//        alert.addAction(savedPhotos)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

extension ScorecardCoverView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        userIcon.image = image
        print(image)
        imagePick.dismiss(animated: true) {
            
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePick.dismiss(animated: true) {
        }
    }

}
