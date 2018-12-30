//
//  VitaminDDosageView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/4.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class VitaminDDosageView: UIView {
    weak var howView: ScorecardVitaminDHowView!
    @IBOutlet weak var generalButton: UIButton!
    @IBOutlet weak var personalButton: UIButton!
    @IBOutlet var explainLabels: [UILabel]!
    @IBOutlet weak var comparisonDecoLabel: UILabel!
    @IBOutlet weak var comparisonLabel: UILabel!
    
    fileprivate let userCheckedGeneral = "UserCheckedGeneral"
    
    func setup() {
        let one = bounds.width / 310
        
        let cFont = UIFont.systemFont(ofSize: 18 * one, weight: .semibold)
        comparisonLabel.font = cFont
        comparisonDecoLabel.attributedText = NSAttributedString(string: "← Comparison →", attributes: [NSAttributedStringKey.font: cFont, .strokeColor: UIColor.black, .strokeWidth: NSNumber(value: 10)])
        comparisonLabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.16))
        comparisonDecoLabel.transform = comparisonLabel.transform
        
        personalButton.isEnabled = userDefaults.bool(forKey: userCheckedGeneral)
        personalButton.layer.addBlackShadow(4 * one)
        generalButton.layer.addBlackShadow(4 * one)
        personalButton.layer.shadowColor = personalButton.isEnabled ? UIColor.black.cgColor : UIColor.clear.cgColor
        for label in explainLabels {
            label.layer.borderColor = UIColorFromHex(0xD6DEE9).cgColor
            label.layer.borderWidth = 2 * one
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 8 * one
            label.font = UIFont.systemFont(ofSize: 9 * one)
        }
    }
  
    // tag: 101, 102
    @IBAction func checkDosageQuestionMark(_ sender: UIButton) {
        howView.visitDosageQuestion(sender.tag - 101)
    }
    
    // tag: 201, 202
    @IBAction func checkDoageDetail(_ sender: UIButton) {
        howView.visitDosage(sender.tag - 201)
        
        if sender.tag == 201 && !personalButton.isEnabled {
            userDefaults.set(true, forKey: userCheckedGeneral)
            userDefaults.synchronize()
            personalButton.isEnabled = true
            personalButton.layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    @IBAction func checkComparison(_ sender: Any) {
        howView.showDosageComparison()
    }
    
}
