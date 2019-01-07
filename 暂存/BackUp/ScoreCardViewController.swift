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
    
    // outlets
    @IBOutlet weak var backView: UIView!
    
    // top
    @IBOutlet weak var topDecoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userGenderLabel: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // main
    // ---- top
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var mainTitleLabel: UILabel!
    // ---- middle
    @IBOutlet weak var resultDesLabel: UILabel!
    @IBOutlet weak var resultDesImageView: UIImageView!
    @IBOutlet weak var resultBar: GradientProcessBar!
    @IBOutlet weak var totalBar: GradientProcessBar!
    @IBOutlet weak var bestLabel: UILabel!
    @IBOutlet weak var worstLabel: UILabel!
    // ---- bottom
    @IBOutlet weak var panel: UIImageView!
    @IBOutlet weak var panelPointer: UIImageView!
    
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var totalNumberLabel: UILabel!
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultDetailLabel: UILabel!

    @IBOutlet var cNameLabels: [UILabel]!
    @IBOutlet var cNumberLabels: [UILabel]!
    @IBOutlet var cBars: [GradientProcessBar]!
    
    // bottom
    @IBOutlet weak var shareTitleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    
    // properties
    weak var presentFrom: SummaryViewController!

    // view did load
    override func viewDidLoad() {
        adjustUI()
        adjustFont()
        fillData()
    }
    
    // ui adjust
    fileprivate func adjustUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        backView.layer.cornerRadius = max(8 * max(standHP, standWP), 8) // the image's corner is 8
        backView.layer.addBlackShadow(16 * fontFactor)
        backView.layer.shadowOffset = CGSize(width: 0, height: 6 * standHP)
        
        // colors
        detailButton.layer.borderColor = UIColorFromRGB(104, green: 159, blue: 56).cgColor
        detailButton.layer.borderWidth = fontFactor
        
        panel.layer.addBlackShadow(4 * fontFactor)
        
        resultBar.setupWithColors([UIColor.green.cgColor, UIColor.yellow.cgColor, UIColor.red.cgColor], locations: [0, 0.5, 1], value: 0.5)
        totalBar.setupWithColors([UIColor.green.cgColor, UIColor.yellow.cgColor, UIColor.red.cgColor], locations: [0, 0.5, 1], value: 1)
        
        cBars[0].setupWithColor(UIColor.green.cgColor, value: 0.33)
        cBars[1].setupWithColor(UIColor.yellow.cgColor, value: 0.33)
        cBars[2].setupWithColor(UIColor.red.cgColor, value: 0.33)
    }

    fileprivate func adjustFont() {
        let subFont = UIFont.systemFont(ofSize: 12 * fontFactor)
        // sizes

        // user part
        userNameLabel.font = mediumFontOfPoint(18)
        userAgeLabel.font = subFont
        userGenderLabel.font = subFont
        dateLabel.font = subFont
        
        // center part
        mainTitleLabel.font = mediumFontOfPoint(18)
        detailButton.titleLabel?.font = mediumFontOfPoint(10)
        resultDesLabel.font = mediumFontOfPoint(14)
        
        bestLabel.font = mediumFontOfPoint(10)
        worstLabel.font = mediumFontOfPoint(10)
        
        resultTitleLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: UIFontWeightSemibold)
        resultDetailLabel.font = mediumFontOfPoint(12)

        bottomTitleLabel.font = mediumFontOfPoint(14)
        totalNumberLabel.font = mediumFontOfPoint(12)
        
        for label in cNameLabels {
            label.font = subFont
        }
        for label in cNumberLabels {
            label.font = subFont
        }

        // sharePart
        shareTitleLabel.font = mediumFontOfPoint(16)
    }
    
    fileprivate func mediumFontOfPoint(_ point: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: point * fontFactor, weight: UIFontWeightMedium)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layoutIfNeeded()
        
        detailButton.layer.cornerRadius = detailButton.bounds.height * 0.5
        continueButton.adjustThickRectButton(continueButton.frame)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setBarsAndPanel()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismiss(animated: true, completion: nil)
    }
    
    // data
    var total: Double = 0
    var low: CGFloat = 0
    var medium: CGFloat = 0
    var high: CGFloat = 0
    fileprivate func fillData() {
        // risk
        let risk = RiskMetricCardsCursor.sharedCursor.focusingRisk!
        let displayedUser = UserCenter.sharedCenter.currentGameTargetUser.userInfo()!
        let matchedCards = MatchedCardsDisplayModel.getCurrentMatchedCardsOfRisk(risk.key)
        
        // title part
        let titleFont = UIFont.systemFont(ofSize: fontFactor * 18, weight: UIFontWeightSemibold)
        // attributes
        topDecoLabel.attributedText = NSAttributedString(string: risk.name, attributes: [NSFontAttributeName: titleFont, NSStrokeColorAttributeName: UIColor.black, NSStrokeWidthAttributeName: NSNumber(value: 12)])
        
        titleLabel.font = titleFont
        titleLabel.text = risk.name
        
        // userInfo
        userAvatar.image = displayedUser.imageObj ?? ProjectImages.sharedImage.maleAvatar
        userNameLabel.text = displayedUser.displayName
        userGenderLabel.text = "Gender: \(displayedUser.sex ?? "Not told")"
        userAgeLabel.text = "Age: \(CalendarModel.getAgeFromDateOfBirthString(displayedUser.dobString))"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateLabel.text = dateFormatter.string(from: Date())
        
        // card
        let iden = MatchedCardsDisplayModel.getClassifiedCardsOfRisk(risk.key)
        
        for (key, cards) in iden {
            print("\(key), \(cards.count)")
        }
        
        total = 0
        low = 0
        medium = 0
        high = 0
        // result
        for card in matchedCards {
            let score = card.currentScore() ?? 0
            let state = MatchedCardsDisplayModel.checkCurrentPlayResultStateOfCard(card)
            switch state {
            case .none: break
            case .high: high += 1
            case .medium: medium += 1
            case .low: low += 1
            case .unsure:
                low += 1
            }
        }
    
        cNumberLabels[0].text = "\(Int(low))"
        cNumberLabels[1].text = "\(Int(medium))"
        cNumberLabels[2].text = "\(Int(high))"
        
        totalNumberLabel.text = "Total: \(Int(low + medium + high))"
        
        // score
//        resultDesLabel.text = ""
    }
    
    fileprivate func setBarsAndPanel() {
        let delay = 0.4
        let duration = 0.6
        
        let all = low + high + medium
        let lowPercent: CGFloat = low / all
        let mediumPercent: CGFloat = medium / all
        let highPercent: CGFloat = high / all
        
        // panel
        let offset = panelPointer.bounds.width * 0.5
        panelPointer.center = CGPoint(x: panel.frame.midX, y: panelPointer.frame.maxY - offset)
        panelPointer.layer.anchorPoint = CGPoint(x: 0.5, y: 1 - offset / panelPointer.bounds.height)
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
            self.panelPointer.transform = CGAffineTransform(rotationAngle: (highPercent - 0.5) * CGFloat(Double.pi))
        }) { (true) in
            
        }
    
        // timer, bar
        var time = 0.0
        var highNow: CGFloat = 1 / 3
        var lowNow: CGFloat = 1 / 3
        var mediumNow: CGFloat = 1 / 3
        
        let mediumP = (mediumPercent - mediumNow) / CGFloat(duration / 0.1)
        let lowP = (lowPercent - lowNow) / CGFloat(duration / 0.1)
        let highP = (highPercent - highNow) / CGFloat(duration / 0.1)
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            time += 0.1
            if time > delay && time < delay + duration {
                lowNow += lowP
                mediumNow += mediumP
                highNow += highP
                
                self.cBars[0].setupWithValue(lowNow)
                self.cBars[1].setupWithValue(mediumNow)
                self.cBars[2].setupWithValue(highNow)
            }
            
            if time >= delay + duration {
                timer.invalidate()
                
                // adjust
                self.cBars[0].setupWithValue(lowPercent)
                self.cBars[1].setupWithValue(mediumPercent)
                self.cBars[2].setupWithValue(highPercent)
            }
        }
    }
    
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkDetail(_ sender: UIButton) {
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
