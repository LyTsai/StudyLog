//
//  StateSwitchView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/9/3.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class StateSwitchView: UIView {
    var continueIsChosen: (()->())?
        
    // 335 * 330
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    @IBOutlet weak var leftButton: GradientBackStrokeButton!
    @IBOutlet weak var rightButton: GradientBackStrokeButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBasic()
    }
    
    fileprivate func setupBasic() {
        layer.masksToBounds = true
        layer.borderColor = UIColorFromHex(0x5D8148).cgColor
        
        leftButton.setupWithTitle("Cancel")
        rightButton.setupWithTitle("Continue")
        
        leftButton.isSelected = false
        rightButton.isSelected = true
    }
    
    // actions
    @IBAction func showExplainView(_ sender: Any) {
        let explain = Bundle.main.loadNibNamed("StateSwitchView", owner: self, options: nil)![1] as! StateSwitchExplainView
        
        // 335 * 544
        let usableH = height - topLength + 44
        let explainH = min(bounds.width * 544 / 335, usableH * 0.96)
        let explainW = explainH * 335 / 544
        
        explain.frame = CGRect(center: CGPoint(x: frame.midX, y: usableH * 0.5), width: explainW, height: explainH)
        explain.original = self
        explain.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        explain.titleLabel.text = titleLabel.text
        
        self.superview?.addSubview(explain)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            explain.transform = CGAffineTransform.identity
        }) { (true) in
            
        }
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAndContinue(_ sender: Any) {
        viewController.dismiss(animated: true) {
            self.continueIsChosen?()
        }
    }

   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.width / 335
        layer.borderWidth = 4 * one
        layer.cornerRadius = 8 * one
        
        titleLabel.font = UIFont.systemFont(ofSize: 16 * one, weight: .medium)
        messageLabel.font = UIFont.systemFont(ofSize: 13 * one, weight: .light)
        thirdLabel.font = UIFont.systemFont(ofSize: 14 * one, weight: .medium)
    }
}

class StateSwitchExplainView: UIView {
    weak var original: StateSwitchView!
    
    // 335 * 330
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explainTextView: UITextView!
    
    @IBOutlet weak var button: GradientBackStrokeButton!
    
    
    @IBAction func goBackToView(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.alpha = 0.5
            self.original.transform = CGAffineTransform.identity
        }) { (true) in
            self.removeFromSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = true
        layer.borderColor = UIColorFromHex(0x5D8148).cgColor
        button.setupWithTitle("Got It!")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.width / 335
        layer.borderWidth = 4 * one
        layer.cornerRadius = 8 * one
        
        titleLabel.font = UIFont.systemFont(ofSize: 16 * one, weight: .medium)
        explainTextView.font = UIFont.systemFont(ofSize: 12 * one, weight: .light)
    }
}
