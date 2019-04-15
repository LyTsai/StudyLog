//
//  VitaminDRefrenceView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/17.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VitaminDRefrenceView: ReferenceView, UITextFieldDelegate {
    fileprivate let explainView = UIScrollView()
    fileprivate let explainLabel = UILabel()
    fileprivate let chooseTitleLabel = UILabel()
    fileprivate let subTitleLabel = UILabel()
    fileprivate let expandButton = UIButton(type: .custom)
    
    fileprivate let dosageView = RecommandDosageView()
    fileprivate let chooseView = ChooseTableView(frame: CGRect.zero, style: .grouped)
    fileprivate let methodBack = UIView()
    fileprivate let methodLabel = UILabel()
    fileprivate var methodButtons = [UIButton]()
    
    override func updateUI() {
        super.updateUI()
        
        expandButton.setBackgroundImage(UIImage(named: "queryForMore"), for: .normal)
        expandButton.addTarget(self, action: #selector(moreInfomation), for: .touchUpInside)
        addSubview(expandButton)
        
        // down
        explainView.isScrollEnabled = false
        explainView.isPagingEnabled = true
        explainView.backgroundColor = UIColor.white
        addSubview(explainView)
        
        explainLabel.textAlignment = .center
        explainLabel.numberOfLines = 0
        explainLabel.text = "To improve your Vitamin D score, find out how much additional Vitamin D you need daily to reach the “Sweet Spot” from your current level."
        
        chooseTitleLabel.textAlignment = .center
        chooseTitleLabel.numberOfLines = 0
        
        chooseView.referenceView = self
        explainView.addSubview(chooseTitleLabel)
        explainView.addSubview(chooseView)
        
        subTitleLabel.text = "Here’s your individualized additional dosage estimate above your current vitamin D level to your target levels."
        subTitleLabel.numberOfLines = 0
        subTitleLabel.backgroundColor = UIColor.white
        subTitleLabel.textAlignment = .center
        
        explainView.addSubview(explainLabel)
        explainView.addSubview(dosageView)
        explainView.addSubview(subTitleLabel)
        
        methodBack.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        methodLabel.textAlignment = .center
        methodLabel.text = "How do you get vitamin D?"
        explainView.addSubview(methodBack)
        methodBack.addSubview(methodLabel)
        
        for i in 0...2 {
            let button = UIButton(type: .custom)
            button.tag = 300 + i
            button.setBackgroundImage(UIImage(named: "dosages_\(i)"), for: .normal)
            button.addTarget(self, action: #selector(getMethod), for: .touchUpInside)
            methodButtons.append(button)
            methodBack.addSubview(button)
        }
    }
    
    var resultLevelIndex = 0
    var noScore = false
    override func setupWithRiskKey(_ riskKey: String, userKey: String, factor: CGFloat) {
        if riskKey == vitaminDInKey {
            super.setupWithRiskKey(riskKey, userKey: userKey, factor: factor)
        
            if let cKey = MatchedCardsDisplayModel.getResultClassifierOfRisk(riskKey).key {
                let risk = collection.getRisk(riskKey)!
                for (i, c) in risk.classifiers.enumerated() {
                    if c.key == cKey {
                        resultLevelIndex = 2 - i
                        break
                    }
                }
            }
            
        }else {
            noScore = true
            if let most = MatchedCardsDisplayModel.getClassifiedCardsOfRisk(riskKey).first {
                if let iden = collection.getClassificationByKey(most.key) {
                    resultLevelIndex = 2 - Int(iden.score ?? 0)
                }
            }
        }
        
        let titleS = NSMutableAttributedString(string: "Pick one of the following cards that best matches your result.\n", attributes: [NSForegroundColorAttributeName: UIColorGray(74), NSFontAttributeName: UIFont.systemFont(ofSize: 10 * factor * fontFactor, weight: UIFontWeightMedium)])
        chooseTitleLabel.attributedText = titleS
        
        chooseView.usedForVitaminD()
        explainLabel.font = UIFont.systemFont(ofSize: 12 * factor * fontFactor, weight: UIFontWeightMedium)
        subTitleLabel.font = UIFont.systemFont(ofSize: 12 * factor * fontFactor, weight: UIFontWeightMedium)
        methodLabel.font = UIFont.systemFont(ofSize: 12 * factor * fontFactor, weight: UIFontWeightBold)
    }
    
    func moreInfomation() {
        
    }
    
        
    func layoutWithFrame(_ frame: CGRect) {
        self.frame = frame
        
        var topH = frame.width * 70 / 345
        let xMargin = bounds.width * 0.05
    
        // score
        if !noScore {
            scoreTextView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: topH)
            scoreTextView.textContainerInset = UIEdgeInsets(top: xMargin * 0.5, left: xMargin, bottom: 0, right: xMargin)
            expandButton.frame = CGRect(center: CGPoint(x: bounds.width * 0.2, y: scoreTextView.frame.height * 0.6), length: xMargin)
        }else {
            expandButton.frame = CGRect.zero
            scoreTextView.frame = CGRect.zero
            topH = 0
        }
        
        // line
        sepLine.frame = CGRect(x: 0, y: scoreTextView.frame.maxY, width: bounds.width, height: fontFactor)
        
        // choose and calculate
        let downH = bounds.height - topH - fontFactor
        explainView.frame = CGRect(x: 0, y: sepLine.frame.maxY, width: bounds.width, height: downH)
        explainView.contentSize = CGSize(width: bounds.width * 2, height: downH)

        // first page
        explainLabel.frame = CGRect(x: 0, y: xMargin * 0.4, width: bounds.width, height: bounds.height).insetBy(dx: xMargin, dy: 0)
        explainLabel.adjustWithWidthKept()
        
        chooseTitleLabel.frame = CGRect(x: 0, y: explainLabel.frame.maxY + xMargin * 0.4, width: bounds.width, height: bounds.height).insetBy(dx: xMargin * 2, dy: 0)
        chooseTitleLabel.adjustWithWidthKept()
        
        chooseView.frame = CGRect(x: 0, y: chooseTitleLabel.frame.maxY, width: bounds.width, height: downH - chooseTitleLabel.frame.maxY).insetBy(dx: xMargin * 0.4, dy: 0)
        chooseView.reloadData()
        
        // second page
        subTitleLabel.frame = CGRect(x: bounds.width, y: xMargin * 0.4, width: bounds.width, height: bounds.height).insetBy(dx: xMargin, dy: 0)
        subTitleLabel.adjustWithWidthKept()
        dosageView.frame = CGRect(x: bounds.width, y: subTitleLabel.frame.maxY, width: bounds.width, height: explainView.bounds.height - subTitleLabel.frame.maxY)
        
        let mHeight = bounds.width * 80 / 345
        methodBack.frame = CGRect(x: bounds.width, y: downH - mHeight, width: bounds.width, height: mHeight)
        methodLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: mHeight * 0.35)
        let bLength = mHeight * 0.45
        let gap = bLength * 0.7
        let firstX = (bounds.width - bLength * 3 - 2 * gap) * 0.5
        for (i, button) in methodButtons.enumerated() {
            button.frame = CGRect(x: firstX + CGFloat(i) * (bLength + gap), y: methodLabel.frame.maxY, width: bLength, height: bLength)
        }
    }
    
    fileprivate var levelIndex: Int = 0
    fileprivate var levelText: String!
    fileprivate var cardIndex: Int!
    func optionIsChosen(_ level: Int!, cardIndex:Int, withText: String, color: UIColor) {
        resultLevelIndex = min(resultLevelIndex, 2)
        levelIndex = (level == nil ? resultLevelIndex * 2 + 1 : level)
        levelText = withText
        
        if level == nil {
            let options = chooseView.optionsData[resultLevelIndex]
            levelText = "\(options.options.first!)"
        }
        
        self.cardIndex = cardIndex
        if cardIndex == 4 {
            calculateWithWeight(150, lbs: true)
        }else {
            getWeight()
        }
        
    }
    
    func getWeight() {
        detailDelegate.contentOffset = CGPoint(x: 0, y: detailDelegate.contentSize.height - detailDelegate.bounds.height)
        
        let alert = UIAlertController(title: "Input your weight", message: "and\n choose the unit to start calculating", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.delegate = self
            textfield.keyboardType = .decimalPad
        }
        let lbsAction = UIAlertAction(title: "lbs", style: .default) { (action) in
            let input = Float(alert.textFields?.first!.text ?? "0") ?? 0
            self.calculateWithWeight(input, lbs: true)
        }
        let kiloAction = UIAlertAction(title: "kilo", style: .default) { (action) in
            let input = Float(alert.textFields?.first!.text ?? "0") ?? 0
            self.calculateWithWeight(input, lbs: false)
        }

        alert.addAction(lbsAction)
        alert.addAction(kiloAction)

        viewController.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func calculateWithWeight(_ weight: Float, lbs: Bool) {
        if abs(weight) < 1e-6 {
            let alert = UIAlertController(title: "You have put the wrong weight number", message: "", preferredStyle: .alert)
            let redoAction = UIAlertAction(title: "Input again", style: .default) { (action) in
                self.getWeight()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            
            alert.addAction(redoAction)
            alert.addAction(cancelAction)
            viewController.present(alert, animated: true, completion: nil)
        }else {
            let scrollFrame = explainView.frame
//            explainView.isScrollEnabled = true
            explainView.scrollRectToVisible(CGRect(x: bounds.width, y: 0, width: scrollFrame.width, height: scrollFrame.height), animated: true)
            
            // calculate
            dosageView.setupWithCurrentLevel(levelIndex, cardIndex: cardIndex, text: levelText, lbsWeight: lbs ? weight : weight * 2.20462)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func getMethod(_ button: UIButton) {
        let i = button.tag - 300
        if i == 0 {
            detailDelegate.showMethod()
        }
    }
}
