//
//  VitaminDReferenceView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/17.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VitaminDReferenceView: UIView, UITextFieldDelegate {
    fileprivate let topLabel = UILabel()
    fileprivate let explainLabel = UILabel()
    fileprivate let chooseTitleLabel = UILabel()
    fileprivate let chooseView = ChooseTableView(frame: CGRect.zero, style: .plain)
    fileprivate var dosageIndividualView: VitaminDDosageIndividualView!
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
        
        topLabel.backgroundColor = UIColorFromHex(0xFFF7EB)
        topLabel.text = "Vitamin D Intake Dosage Planner based on an individual’s\nBody Weight & Vitamin D Blood Level: individualized"
        topLabel.numberOfLines = 0
        topLabel.textAlignment = .center
        
        // down
        explainLabel.textAlignment = .center
        explainLabel.numberOfLines = 0
        explainLabel.text = "To improve your Vitamin D score, find out how much additional Vitamin D you need daily to reach the “Sweet Spot” from your current level."
 
        chooseTitleLabel.text = "Pick one of the following options that best matches your result."
        chooseTitleLabel.textColor = UIColorGray(74)
        chooseTitleLabel.textAlignment = .center
        chooseTitleLabel.numberOfLines = 0
        
        chooseView.referenceView = self
        
        addSubview(topLabel)
        addSubview(chooseTitleLabel)
        addSubview(chooseView)
        addSubview(explainLabel)
    }
    
    fileprivate var measurement: MeasurementObjModel!
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        self.measurement = measurement
        chooseView.usedForVitaminD(measurement)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        let factor = min(bounds.width / 353, bounds.height / 471)
        topLabel.font = UIFont.systemFont(ofSize: 11 * factor)
        explainLabel.font = UIFont.systemFont(ofSize: 14 * factor)
        chooseTitleLabel.font = UIFont.systemFont(ofSize: 10 * factor, weight: .medium)
        
        // choose and calculate
        topLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 52 * factor)
        explainLabel.frame = CGRect(x: 0, y: topLabel.frame.maxY, width: bounds.width, height: 80 * factor).insetBy(dx: 15 * factor, dy: 0)
        
        chooseTitleLabel.frame = CGRect(x: 0, y: explainLabel.frame.maxY, width: bounds.width, height: 27 * factor).insetBy(dx: 15 * factor, dy: 0)
        
        chooseView.frame = CGRect(x: 0, y: chooseTitleLabel.frame.maxY, width: bounds.width, height: bounds.height - chooseTitleLabel.frame.maxY).insetBy(dx: 5 * factor, dy: 0)
        chooseView.reloadData()
    }
    
    fileprivate var levelIndex: Int = 0
    fileprivate var levelText: String!
    fileprivate var cardIndex: Int!
    fileprivate var color = tabTintGreen
    
    func optionIsChosen(_ level: Int!, cardIndex:Int, withText: String, color: UIColor) {
        self.levelIndex = level
        self.levelText = withText
        self.cardIndex = cardIndex
        self.color = color
        
        if cardIndex == 4 {
            calculateWithWeight(150, lbs: true)
        }else {
            getWeight()
        }
    }
    
    func getWeight() {
        if let weight = userCenter.tempWeight[measurement.playerKey!] {
            calculateWithWeight(weight, lbs: true)
        }else {
            let alert = UIAlertController(title: "Input your weight", message: "and\n choose the unit to start calculating", preferredStyle: .alert)
            alert.addTextField { (textfield) in
                textfield.delegate = self
                textfield.keyboardType = .decimalPad
                
//                if let weightString = userDefaults.string(forKey: "WeightOf\(self.userKey)") {
//                    textfield.text = weightString
//                }
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
    
    var showDosage = false
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
            let lbsWeight = lbs ? weight : weight * 2.20462
            userCenter.tempWeight[measurement.playerKey!] = lbsWeight

            if dosageIndividualView == nil {
                dosageIndividualView = VitaminDDosageIndividualView(frame: CGRect(x: 0, y: bounds.height, width: bounds.width, height: bounds.height))
                addSubview(dosageIndividualView)
            }
            dosageIndividualView.setupWithCurrentLevel(levelIndex, text: levelText, color: color, lbsWeight: lbsWeight)
            hideDosageView(false)
        }
    }
    
    func hideDosageView(_ hide: Bool)  {
        showDosage = !hide

        UIView.animate(withDuration: 0.3, animations: {
            self.dosageIndividualView.transform = CGAffineTransform(translationX: 0, y: hide ? 0 : -self.bounds.height)
        }) { (true) in
            if self.showDosage {
                self.dosageIndividualView.displayView()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
