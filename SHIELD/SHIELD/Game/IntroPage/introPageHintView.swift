//
//  introPageHintView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/4/3.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class IntroPageHintView: UIView {
    fileprivate let hintImage = UIImageView(image: #imageLiteral(resourceName: "tapHand"))
    fileprivate let hintLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hintImage.contentMode = .scaleAspectFit
        hintLabel.numberOfLines = 0
        hintLabel.textAlignment = .center
        
        hintLabel.backgroundColor = UIColor.white
        hintLabel.layer.borderColor = tabTintGreen.cgColor
        hintLabel.layer.borderWidth = fontFactor
        hintLabel.layer.cornerRadius = 6 * fontFactor
        hintLabel.layer.masksToBounds = true
        
        addSubview(hintImage)
        addSubview(hintLabel)
        
        setupWithFrame(frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setupWithName(_ name: String) {
        hintLabel.text = "There are more than one game about \(name). You can tap the header or swipe to play others."
        startTimer()
    }
    
    fileprivate var timer: Timer!
    fileprivate func startTimer() {
        var sign: CGFloat = -1
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
            self.hintImage.transform = CGAffineTransform(translationX: sign * (5 * fontFactor), y: 0)
            sign *= -1
        })
    }
    
    func stopTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func setupWithFrame(_ frame: CGRect) {
        self.frame = frame
        
        let labelH = bounds.height * 0.6
        hintImage.frame = CGRect(x: bounds.width * 0.35, y: 0, width: bounds.width * 0.5, height: bounds.height - labelH)
        hintLabel.frame = CGRect(x: 0, y: hintImage.frame.maxY, width: bounds.width, height: labelH)
        hintLabel.font = UIFont.systemFont(ofSize: labelH * 0.2, weight: .light)
        layer.addBlackShadow(2 * fontFactor)
    }
}
