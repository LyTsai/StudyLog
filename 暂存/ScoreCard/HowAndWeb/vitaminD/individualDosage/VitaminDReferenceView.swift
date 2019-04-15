//
//  VitaminDReferenceView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/17.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VitaminDReferenceView: UIView, UITextFieldDelegate {
    fileprivate let explainLabel = UILabel()
    fileprivate let chooseTitleLabel = UILabel()
    fileprivate let chooseView = ChooseTableView(frame: CGRect.zero, style: .plain)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    func updateUI() {
        backgroundColor = UIColor.white
        
        // down
        explainLabel.textAlignment = .center
        explainLabel.numberOfLines = 0
        explainLabel.text = "To improve your Vitamin D score, find out how much additional Vitamin D you need daily to reach the “Sweet Spot” from your current level."
 
        chooseTitleLabel.text = "Pick one of the following options that best matches your result."
        chooseTitleLabel.textColor = UIColorGray(74)
        chooseTitleLabel.textAlignment = .center
        chooseTitleLabel.numberOfLines = 0
        
        chooseView.referenceView = self
        addSubview(chooseTitleLabel)
        addSubview(chooseView)
        addSubview(explainLabel)
    }
    
    var riskKey: String!
    var userKey: String!

    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        self.riskKey = measurement.riskKey!
        self.userKey = measurement.playerKey
        chooseView.usedForVitaminD()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        let factor = bounds.width / 345
        explainLabel.font = UIFont.systemFont(ofSize: 12 * factor, weight: UIFont.Weight.semibold)
        chooseTitleLabel.font = UIFont.systemFont(ofSize: 10 * factor, weight: UIFont.Weight.medium)
        
        let spaceH = 15 * factor
        let xMargin = bounds.width * 0.05

        // choose and calculate】
        explainLabel.frame = CGRect(x: 0, y: spaceH, width: bounds.width, height: bounds.height).insetBy(dx: xMargin, dy: 0)
        explainLabel.adjustWithWidthKept()
        
        chooseTitleLabel.frame = CGRect(x: 0, y: explainLabel.frame.maxY + spaceH, width: bounds.width, height: bounds.height).insetBy(dx: xMargin * 1.5, dy: 0)
        chooseTitleLabel.adjustWithWidthKept()
        
        chooseView.frame = CGRect(x: 0, y: chooseTitleLabel.frame.maxY + spaceH, width: bounds.width, height: bounds.height - chooseTitleLabel.frame.maxY - 2 * spaceH).insetBy(dx: xMargin * 0.4, dy: 0)
        chooseView.reloadData()
    }
    
    fileprivate var levelIndex: Int = 0
    fileprivate var levelText: String!
    fileprivate var cardIndex: Int!
    func optionIsChosen(_ level: Int!, cardIndex:Int, withText: String, color: UIColor) {
        self.levelIndex = level
        self.levelText = withText
        self.cardIndex = cardIndex
        
        if cardIndex == 4 {
            calculateWithWeight(150, lbs: true)
        }else {
            getWeight()
        }
    }
    
    func getWeight() {
        let weight = userCenter.tempWeight[userCenter.currentGameTargetUser.Key()]
        if weight != nil {
            calculateWithWeight(weight!, lbs: true)
        }else {
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
            let lbsWeight =  lbs ? weight : weight * 2.20462
            userCenter.tempWeight[userCenter.currentGameTargetUser.Key()] = lbsWeight
//            userCenter.currentGameTargetUser.userInfo().weight = lbsWeight
            let explainVC = VitaminDExplainViewController()
            explainVC.setupWithCurrentLevel(levelIndex, text: levelText, lbsWeight: lbsWeight)
            explainVC.modalPresentationStyle = .overCurrentContext
            viewController.present(explainVC, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
