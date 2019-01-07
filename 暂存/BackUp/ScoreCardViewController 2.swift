//
//  ScoreCardViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/12/12.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation
//enum ScoreCardStyle {
//    case normal, planToAct, knowledge
//}

class ScoreCardViewController: UIViewController {
    var scoreStyle = CardViewBackStyle.iiaBack
    
    // on view
    @IBOutlet weak var mailBox: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    
    
    
    
    // outlets
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var letterView: UIView!
    
    // top
    @IBOutlet weak var topDecoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userGenderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // main
    // ---- top
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    // ---- middle
    @IBOutlet weak var tapHintImageView: UIImageView!
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var resultSumLabel: UILabel!
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var resultDepButton: UIButton!
    @IBOutlet weak var resultTextBackView: UIView!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var ageDecoLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var distributionLabel: UILabel!
    @IBOutlet weak var resultDesLabel: UILabel!
    @IBOutlet weak var gradientArc: GradientArc!
    @IBOutlet weak var slowImageView: UIImageView!
    @IBOutlet weak var fastImageView: UIImageView!
  
    @IBOutlet weak var bestLabel: UILabel!
    @IBOutlet weak var worstLabel: UILabel!
    
    // ---- bottom
    @IBOutlet weak var panelPointer: UIImageView!
    @IBOutlet weak var dialChartView: DialChart!
    
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var totalNumberLabel: UILabel!
    
    @IBOutlet weak var detailView: MatchedCardsDetailView!
    @IBOutlet weak var segmentBar: SegmentBar!
    
    // bottom
    @IBOutlet weak var shareTitleLabel: UILabel!
    @IBOutlet weak var cardNoteLabel: UILabel!
    @IBOutlet weak var noteHideButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var continueButton: UIButton!
    
    // envelope
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var letterImageView: UIImageView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var openHintLabel: UILabel!
    
    // properties
    weak var presentFrom: SummaryViewController!
    fileprivate var forOpen = true
    fileprivate var withNote = true {
        didSet{
            if !withNote {
                cardNoteLabel.isHidden = true
                noteLabel.isHidden = true
                noteHideButton.isHidden = true
            }
        }
    }
    fileprivate var forDetail = true
    fileprivate var referenceValue: Float = 0
    
    // view did load
    override func viewDidLoad() {
        adjustUI()
        adjustFont()
        fillData()
        
        // state
        backView.transform = CGAffineTransform(translationX: 0, y: height * 0.5)
        backView.transform = backView.transform.scaledBy(x: 0.8, y: 0.8)
    }
    
    // ui adjust
    fileprivate func adjustUI() {
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
//        backView.layer.cornerRadius = max(8 * maxOneP, 8) // the image's corner is 8
//        backView.layer.addBlackShadow(16 * fontFactor)
//        backView.layer.shadowOffset = CGSize(width: 0, height: 6 * standHP)
        backView.isHidden = true
        letterView.isHidden = true
        
        // colors
        detailButton.layer.borderColor = UIColorFromRGB(104, green: 159, blue: 56).cgColor
        detailButton.layer.borderWidth = fontFactor
        
        // segment and cards
        mainBackView.clipsToBounds = true
        
        // special
        resultTextBackView.layer.borderWidth = 1.5 * fontFactor
        resultTextBackView.layer.cornerRadius = 4 * fontFactor
        resultTextBackView.layer.masksToBounds = true
        
        detailView.hostVC = self
        
        // tap
        let sTapGR = UITapGestureRecognizer(target: self, action: #selector(showSplash))
        let fTapGR = UITapGestureRecognizer(target: self, action: #selector(showSplash))
        slowImageView.addGestureRecognizer(sTapGR)
        fastImageView.addGestureRecognizer(fTapGR)
    }

    fileprivate func adjustFont() {
        let subFont = UIFont.systemFont(ofSize: 12 * fontFactor)
        // sizes
        noteLabel.font = UIFont.systemFont(ofSize: 18 * fontFactor, weight: UIFontWeightSemibold)
        openHintLabel.font = mediumFontOfPoint(18)

        // user part
        userNameLabel.font = mediumFontOfPoint(18)
        userGenderLabel.font = subFont
        dateLabel.font = subFont
        
        // center part
        distributionLabel.font = mediumFontOfPoint(16)
        resultSumLabel.font = mediumFontOfPoint(12)
        
        resultTextView.font = mediumFontOfPoint(14)
        
        scoreLabel.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: UIFontWeightBold)
        mainTitleLabel.font = UIFont.systemFont(ofSize: 18 * fontFactor, weight: UIFontWeightBold)
        detailButton.titleLabel?.font = mediumFontOfPoint(10)
        resultDesLabel.font = mediumFontOfPoint(12)
        
        bestLabel.font = mediumFontOfPoint(12)
        worstLabel.font = mediumFontOfPoint(12)
        
        bottomTitleLabel.font = mediumFontOfPoint(12)
        totalNumberLabel.font = mediumFontOfPoint(11)

        // sharePart
        shareTitleLabel.font = mediumFontOfPoint(16)
        cardNoteLabel.font = mediumFontOfPoint(14)
    }
    
    fileprivate func mediumFontOfPoint(_ point: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: point * fontFactor, weight: UIFontWeightMedium)
    }
    
    
    fileprivate var layed = false
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        if !layed {
            view.layoutIfNeeded()
            
            let angle = CGFloat(Double.pi) * (ratio - 1)
            
            let radius = dialChartView.radius * 0.85
            resultButton.center = CGPoint(x: cos(angle) * radius + dialChartView.frame.midX, y: sin(angle) * radius + dialChartView.frame.maxY)
            
            // segment
            segmentBar.setNeedsDisplay()
            detailView.layoutIfNeeded()
            
            // size and frames
            resultButton.layer.cornerRadius = resultButton.frame.height * 0.5
            resultDepButton.layer.cornerRadius = resultButton.frame.height * 0.5
            detailButton.layer.cornerRadius = detailButton.bounds.height * 0.5
            continueButton.adjustThickRectButton(continueButton.frame)
            detailView.transform = CGAffineTransform(translationX: width, y: 0)
            
            // panel
            let offset = panelPointer.bounds.width * 0.5
            panelPointer.center = CGPoint(x: dialChartView.frame.midX, y: panelPointer.frame.maxY - offset)
            panelPointer.layer.anchorPoint = CGPoint(x: 0.5, y: 1 - offset / panelPointer.bounds.height)
            panelPointer.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi) * 0.5)
            
            layed = true
        }
        
         hideTextView()
    }
    
    fileprivate func hideTextView() {
        resultTextBackView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        resultTextBackView.alpha = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismiss(animated: true, completion: nil)
    }
    
    // data
    fileprivate var ratio: CGFloat = 0
    fileprivate var tempPanel = [(cards: [CardInfoObjModel], color: UIColor, seqNumber: Int)]()
    
    fileprivate let collection = AIDMetricCardsCollection.standardCollection
    fileprivate var risk: RiskObjModel {
        return RiskMetricCardsCursor.sharedCursor.focusingRisk!
    }
    fileprivate var riskTypeKey: String {
        return collection.getRiskTypeKeyOfRisk(risk.key)!
    }
    fileprivate func fillData() {
        // risk
        let displayedUser = UserCenter.sharedCenter.currentGameTargetUser.userInfo()!
        let riskType = collection.getRiskTypeByKey(riskTypeKey)!
        
        // note
        withNote = (MatchedCardsDisplayModel.getNumberOfAnsweredCardsForCurrent() != collection.getSortedCardsForRiskKey(risk.key).count)
        
        // title part
        let riskClassName = collection.getMetric(risk.metricKey!)!.name!
        let titleString = "\(riskClassName)\n- \(collection.getFullNameOfRiskType(riskTypeKey))"
        let titleAttrString = NSMutableAttributedString(string: titleString, attributes: [NSFontAttributeName: mediumFontOfPoint(18), NSStrokeColorAttributeName: UIColor.white])
        titleAttrString.addAttributes([NSFontAttributeName: mediumFontOfPoint(14)], range: NSMakeRange(riskClassName.count, titleString.count - riskClassName.count))
        titleLabel.attributedText = titleAttrString
        
        titleAttrString.addAttributes([NSStrokeColorAttributeName: UIColor.black, NSStrokeWidthAttributeName: NSNumber(value: 12)], range: NSMakeRange(0, titleString.count))
        topDecoLabel.attributedText = titleAttrString

        // userInfo
        let toName = "To \(displayedUser.displayName!)"
        let nameAttrString = NSMutableAttributedString(string: toName, attributes: [NSFontAttributeName: mediumFontOfPoint(22), NSForegroundColorAttributeName: UIColor.black])
        nameAttrString.addAttributes([NSForegroundColorAttributeName: UIColorFromRGB(104, green: 159, blue: 56)], range: NSMakeRange(3, toName.count - 3))
        
        toLabel.attributedText = nameAttrString
        userAvatar.image = displayedUser.imageObj ?? ProjectImages.sharedImage.maleAvatar
        userNameLabel.text = displayedUser.displayName
        userGenderLabel.text = "Gender: \(displayedUser.sex ?? "Not told")"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateLabel.text = dateFormatter.string(from: Date())
        
        // card
        // brain age
        var needReverse = false
        resultSumLabel.isHidden = (risk.key != brainAgeKey)
        ageButton.isHidden = (risk.key != brainAgeKey)
        tapHintImageView.isHidden = (risk.key != brainAgeKey)
        resultButton.isHidden = (risk.key != brainAgeKey)
        resultDepButton.isHidden = (risk.key != brainAgeKey)
        resultTextView.isHidden = (risk.key != brainAgeKey)
        
        let isThree = (riskTypeKey != iCaKey && riskTypeKey != iPaKey)
        distributionLabel.isHidden = !isThree
        scoreLabel.isHidden = isThree
        dialChartView.showSegNumber = !isThree
        dialChartView.numberInside = isThree
        dialChartView.segNumberAsPercent = (risk.key != brainAgeKey)
        dialChartView.showPercentNumber = isThree
        
        totalNumberLabel.text = "Total Cards: \(MatchedCardsDisplayModel.getNumberOfAnsweredCardsForCurrent())"
        let iden = MatchedCardsDisplayModel.getSortedClassifiedCardsOfRisk(risk.key)
        
        var gradientColors = [CGColor]()
        var gradientLocations = [NSNumber]()
        
        var info = [(color: UIColor, number: Int, text: String)]()
        var idenCards = [(color: UIColor, cards: [CardInfoObjModel])]()
        var panelInfo = [(max: CGFloat, color: UIColor)]()

        for (key, cards) in iden {
            if let classification = collection.getClassificationByKey(key) {
                idenCards.append((color: classification.realColor!, cards: cards))
                info.append((classification.realColor!, cards.count, text: classification.name))
                
                if isThree {
                    tempPanel.append((cards: cards, color: classification.realColor ?? UIColor.lightGray, cards.first!.currentOption.match?.seqNumber ?? 0))
                }
            }else {
                var supposed = MatchedCardsDisplayModel.getColorOfIden(key)
                
                // TODO: ------- remove if the two options for this risk is added
                if risk.key == negativeBEKey {
                    if key == "ME" {
                        supposed = MatchedCardsDisplayModel.getColorOfIden("NOT ME")
                    }else {
                        supposed = MatchedCardsDisplayModel.getColorOfIden("ME")
                    }
                }
                info.append((supposed, cards.count, text: key))
                idenCards.append((color: supposed, cards: cards))
                
                if isThree {
                    // ika.....
                    if cards.first?.cardOptions.count == 1 {
                        tempPanel.append((cards, supposed, key == "ME" ? 0 : 1))
                    }else if let seqNumber = cards.first?.currentOption.seqNumber {
                        tempPanel.append((cards, supposed, seqNumber))
                    }
                }
            }
        }
        
        detailView.idenCards = idenCards
        segmentBar.setupWithInfo(info, usePercent: false)
        
        // panel
        if let classifier = MatchedCardsDisplayModel.getResultClassifierOfRisk(risk.key) {
            resultDesLabel.text = classifier.name
            resultButton.backgroundColor = classifier.classification?.realColor
            resultDepButton.backgroundColor = classifier.classification?.realColor
        }
        
        // MARK: ------------ backend
        if riskType.name!.localizedCaseInsensitiveContains("isa") {
            resultDesLabel.text = "Symptom Frequency/Intensity Level"
        }
        
        // TODO: ----- scoreCardStyle
        if !isThree {
            // MARK: ------- score, classifier
            let all = risk.classifiers.last?.rangeGroup?.groupRanges.first?.max ?? 1
            for classifier in risk.classifiers {
                if let max = classifier.rangeGroup?.groupRanges.first?.max {
                    if let classification = classifier.classification {
                        panelInfo.append((CGFloat(max), classification.realColor!))
                        gradientLocations.append(NSNumber(value: Float(max)/Float(all)))
                        gradientColors.append(classification.realColor!.cgColor)
                    }
                }
            }
        }else {
            // distribution
            panelPointer.isHidden = true
            if riskType.name!.localizedCaseInsensitiveContains("iaa") || riskType.name!.localizedCaseInsensitiveContains("ika") {
                needReverse = true
            }
            
            tempPanel.sort(by: {$0.seqNumber > $1.seqNumber})
      
            var max: Int = 0
            let all = MatchedCardsDisplayModel.getNumberOfAnsweredCardsForCurrent()
            
            for (cards, color, _ ) in tempPanel {
                max += cards.count
                
                gradientColors.append(color.cgColor)
                gradientLocations.append(NSNumber(value: Float(max)/Float(all)))
                
                panelInfo.append((CGFloat(max), color))
            }
        }
        
        dialChartView.dialInfo = panelInfo
        if gradientLocations.count == 0 {
            gradientLocations = [0.1, 0.5, 0.9]
        }
        gradientArc.setupWithColors(gradientColors, locations: gradientLocations, lineWidth: 6 * fontFactor)
        
        // text
        if risk.classifiers.count != 0 {
            if let first = risk.classifiers.first!.classification {
                bestLabel.text = first.name
                bestLabel.textColor = first.realColor

            }
            if let last = risk.classifiers.last!.classification {
                worstLabel.text = last.name
                worstLabel.textColor = last.realColor
            }
        }
        
        if panelInfo.count == 0 {
            print("no data for classifier now")
        }
    
        // swap and flip
        // TODO:  ------------------------- get from scoreTypeKey
        if (riskType.name!.localizedCaseInsensitiveContains("ica") && risk.key != negativeBEKey) || risk.key == brainAgeKey {
            needReverse = true
        }
        
        if needReverse {
            slowImageView.image = #imageLiteral(resourceName: "Fast Pace of Aging")
            fastImageView.image = #imageLiteral(resourceName: "Slow Pace of Aging")
        }
        
        ratio = CGFloat(MatchedCardsDisplayModel.getRatioScoreOfRisk(risk.key))
        let scoreNumber = Int(MatchedCardsDisplayModel.getTotalScoreOfRisk(risk.key))
        if riskTypeKey == iPaKey {
            // tier 2
            if risk.key == brainAgeKey {
                if let classifier = MatchedCardsDisplayModel.getResultClassifierOfRisk(risk.key) {
                    referenceValue = classifier.referenceValue ?? 0
                    scoreLabel.text = "\(risk.scoreDisplayName!): \(scoreNumber)"
                    resultTextBackView.layer.borderColor = classifier.classification?.realColor?.cgColor
                    
                    setupAge("?")
                    
                    var displayString = ""
                    for result in classifier.results {
                        displayString.append(result)
                        displayString.append("\n")
                    }
                    if classifier.suggestions.count != 0 {
                        displayString.append("\nSuggestion: ")
                        for suggestion in classifier.suggestions {
                            displayString.append(suggestion)
                            displayString.append("\n")
                        }
                    }
                    
                    resultTextView.text = displayString
                }
            }else {
                scoreLabel.text = "Predictive Score: \(scoreNumber)"
                resultDesLabel.text = "Severity Level"
            }
            
            if risk.key == vitaminDIn {
                resultDesLabel.text = "Insufficiency Level"
            }
        }else if riskTypeKey == iCaKey {
            // tier 1
            scoreLabel.text = "Compatibility Score: \(Int(nearbyint(ratio * 100)))%"
        }
        
        bottomTitleLabel.text = "Matched Card Assessment Distribution( Assessment Adductor:  \(risk.author?.name ?? "AnnielyticX"))"
    }
    
    fileprivate var popTimer: Timer!
    fileprivate func setPanel() {
        // panel pointer
        let rAngle = (ratio - 0.5) * CGFloat(Double.pi)
        UIView.animate(withDuration: 0.6, delay: 0.4, options: .curveEaseInOut, animations: {
            self.panelPointer.transform = CGAffineTransform(rotationAngle: rAngle)
        }) { (true) in
            // display
            if self.popTimer == nil {
                var count = 0
                let amplitude = self.ageButton.frame.height * 0.05
                self.popTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (timer) in
                        if count == 2 {
                            count = 0
                        }
                    self.tapHintImageView.transform = CGAffineTransform(translationX: 0, y: count % 2 == 0 ? -amplitude : amplitude)
                        count += 1
                })
            }
        }
    }
    
    fileprivate func setupAge(_ text: String) {
        let font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: UIFontWeightBold)
        ageLabel.font = font
        ageLabel.text = text
        
        let decoAttribute = [NSFontAttributeName: font, NSStrokeColorAttributeName: UIColor.black, NSStrokeWidthAttributeName: 15] as [String : Any]
        ageDecoLabel.attributedText = NSAttributedString(string: text, attributes: decoAttribute)
    }
    
    
    // MAKR: ----------------- touches and actions -------------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if forOpen {
            forOpen = false
            
            // show
            openHintLabel.isHidden = true
            UIView.transition(with: letterImageView, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                self.toLabel.isHidden = true
                self.letterImageView.image = UIImage(named: "envelope_back")
            }) { (true) in
                UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseIn, animations: {
                    self.letterView.transform = CGAffineTransform(translationX: 0, y: height - bottomLength - self.letterImageView.frame.maxY)
                }, completion: { (true) in
                    self.backView.isHidden = false
                    self.letterImageView.image = UIImage(named: "envelope_front")
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                        self.backView.transform = CGAffineTransform.identity
                        self.letterImageView.transform = CGAffineTransform(translationX: 0, y: height)
                        self.noteLabel.transform = CGAffineTransform(translationX: 0, y: -height)
                    }, completion: { (true) in
                        self.letterView.isHidden = true
                        self.setPanel()
                    })
                })
            }
            
            return
        }
        
        // panel is touched
        if riskTypeKey != iPaKey && riskTypeKey != iCaKey {
            let point = touches.first?.location(in: dialChartView) ?? CGPoint.zero
            let distance = Calculation().distanceOfPointA(point, pointB: dialChartView.vertex)
            if distance < dialChartView.radius && distance != 0 {
                // in the dial
                let angle = 2 * CGFloat(Double.pi) - acos((point.x - dialChartView.vertex.x) / distance)
                for (i, eAngle) in dialChartView.eAngles.enumerated() {
                    if angle < eAngle {
                        showDetailCardsOfIndex(i)
                        break
                    }
                }
            }
        }
    }
    
    func showDetailCardsOfIndex(_ index: Int) {
        if index < 0 || index > tempPanel.count - 1 {
            return
        }
        
        let cardsVC = CardAnswerChangeViewController()
        cardsVC.modalPresentationStyle = .overCurrentContext
        cardsVC.loadWithCards(tempPanel[index].cards, riskTypeKey: riskTypeKey, borderColor: tempPanel[index].color)
        
        present(cardsVC, animated: true, completion: nil)
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ageCheck(_ sender: Any) {
        if popTimer != nil {
            popTimer.invalidate()
            popTimer = nil
        }
        
        tapHintImageView.transform = CGAffineTransform.identity
        // present age view
        let displayedUser = UserCenter.sharedCenter.currentGameTargetUser.userInfo()!
        
        let picker = Bundle.main.loadNibNamed("DatePickerViewController", owner: self, options: nil)?.first as! DatePickerViewController
        picker.presentFrom = self
        picker.modalPresentationStyle = .overCurrentContext
        let record = CalendarCenter.getDateFromString(displayedUser.dobString) ?? Date()
        picker.recordYear = CalendarCenter.getYearOfDate(record)

        present(picker, animated: true, completion: nil)
    }
    
    func chooseBirthYear(_ year: Int) {
        tapHintImageView.isHidden = true
        
        let addValue = Int(referenceValue)
        if addValue == 0 {
        }else if addValue > 0 {
            ageButton.setBackgroundImage(#imageLiteral(resourceName: "alzheimer_high"), for: .normal)
        }else {
            ageButton.setBackgroundImage(#imageLiteral(resourceName: "alzheimer_low"), for: .normal)
        }
        
        // button's
        let age = CalendarCenter.getYearOfDate(Date()) - year
        setupAge("\(age + addValue)")
    }
    
    func showSplash() {
        let splashVC = SplashScreenViewController()
        splashVC.modalPresentationStyle = .overFullScreen
        present(splashVC, animated: true, completion: nil)
    }
    
    @IBAction func showResultInfo(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.resultTextBackView.transform = CGAffineTransform.identity
            self.resultTextBackView.alpha = 1
        }, completion: { (true) in
            self.resultTextView.contentOffset = CGPoint.zero
            self.resultTextView.setNeedsLayout()
        })
    }
    
    @IBAction func hideTextView(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: {
            self.hideTextView()
        })
    }
    
    @IBAction func checkDetail(_ sender: UIButton) {
        sender.isEnabled = false
        UIView.animate(withDuration: 0.6, animations: {
            self.detailView.transform = self.forDetail ? CGAffineTransform.identity : CGAffineTransform(translationX: width, y: 0)
            self.segmentBar.alpha = self.forDetail ? 0 : 1
        }) { (true) in
            sender.isEnabled = true
            self.forDetail = !self.forDetail
            sender.setTitle(self.forDetail ? "Detail" : "Overall", for: .normal)
        }
    }
    
    @IBAction func hideNote(_ sender: UIButton) {
        sender.isHidden = true
        
        UIView.animate(withDuration: 0.4, animations: {
            self.cardNoteLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//            self.cardNoteLabel.layer.transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(Double.pi * 0.5), 0, 1, 0)
            
        }) { (true) in
            self.cardNoteLabel.isHidden = true
        }
    }

    @IBAction func saveAndContinue(_ sender: Any) {
        dismiss(animated: true) {
            if self.presentFrom != nil {
                let mushroomVC = Bundle.main.loadNibNamed("MushroomViewController", owner: self, options: nil)?.first as! MushroomViewController
                self.presentFrom.navigationController?.pushViewController(mushroomVC, animated: true)
            }
        }
    }
    
    
}
