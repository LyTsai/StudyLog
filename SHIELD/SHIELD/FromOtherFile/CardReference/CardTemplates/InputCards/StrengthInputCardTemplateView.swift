//
//  StrengthInputCardTemplateView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/10/24.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class StrengthInputCardTemplateView: JudgementCardTemplateView {
    override func key() -> String {
        return StrengthInputCardTemplateView.styleKey()
    }
    
    override class func styleKey() -> String {
        return "cef0e791-b2ba-4eeb-a619-433e98bb5a96"
    }
    
    fileprivate let startButton = UIButton(type: .custom)
    fileprivate let buttonColor = UIColorFromHex(0xF57C00)
    override func addBackAndUpdateUI() {
        super.addBackAndUpdateUI()
        
        leftButton.removeFromSuperview()
        rightButton.removeFromSuperview()
        
        startButton.backgroundColor = UIColor.white
        startButton.setTitleColor(UIColor.black, for: .normal)
        startButton.setTitle("Start", for: .normal)
        startButton.layer.borderColor = buttonColor.cgColor
        startButton.layer.addBlackShadow(4)
        startButton.layer.shadowColor = buttonColor.cgColor
        
        addSubview(startButton)
        startButton.addTarget(self, action: #selector(startInputNumber), for: .touchUpInside)
    }
    
    override func setUIForSelection(_ answer: Int?) {
        super.setUIForSelection(answer)
        
        if let value = vCard.currentInput() {
            descriptionView.isChosen = true
            average = value
            startButton.setTitle("\(Int(average))", for: .normal)
        }
    }
    
    fileprivate var average: Float = 0
    @objc func startInputNumber()  {
        let alert = Bundle.main.loadNibNamed("StrengthInputViewController", owner: self, options: nil)?.first as! StrengthInputViewController
        alert.strengthCardView = self
        viewController.presentOverCurrentViewController(alert, completion: nil)
    }
    
    func saveWithAverage(_ average: Float)  {
        vCard.saveInput(average, matchKey: self.option.matchKey, refValue: nil)
        startButton.setTitle("\(Int(average))", for: .normal)
        
        if actionDelegate != nil {
            actionDelegate.card?(self, chooseItemAt: 0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonH = descriptionView.bottomForMore * 0.8
        startButton.frame = CGRect(center: CGPoint(x: bounds.midX, y: descriptionView.rimFrame.maxY - descriptionView.bottomForMore * 0.5 - descriptionView.rimLineWidth), width: buttonH * 3.8, height: buttonH)
        startButton.layer.cornerRadius = buttonH * 0.5
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonH * 0.5, weight: .medium)
        startButton.layer.shadowRadius = 4 * buttonH / 35
        startButton.layer.borderWidth = buttonH / 35
    }
}
