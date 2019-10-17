//
//  CatCardAlertViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/4/2.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class CatCardAlertViewController: UIViewController {
    fileprivate let titleLabel = UILabel()
    fileprivate var buttons = [GradientBackStrokeButton]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let catBoxBack = UIImageView(image: UIImage(named: "catBox"))
        catBoxBack.setScaleAspectFrameInConfine(mainFrame.insetBy(dx: 5 * fontFactor, dy: 0), widthHeightRatio: 365 / 222)
        view.addSubview(catBoxBack)
        catBoxBack.isUserInteractionEnabled = true
        
        /* 365 / 222
                55
         5             5
                5
         */
        let oneLength = catBoxBack.frame.width / 365
        let buttonH = 44 * oneLength
        let buttonGap = 8 * oneLength
        let bottomH = CGFloat((buttons.count - 1) / 2 + 1) * (buttonH + buttonGap)
        // top title
        titleLabel.frame = CGRect(x: 0, y: 55 * oneLength, width: catBoxBack.frame.width, height: catBoxBack.frame.height - 60 * oneLength - bottomH).insetBy(dx: 5 * oneLength, dy: 0)
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        catBoxBack.addSubview(titleLabel)
        
        // buttons
        if buttons.isEmpty {
            return
        }
        
        var buttonWidth = 135 * oneLength
        if buttons.count == 1 {
            let first = buttons.first!
            buttonWidth = 171 * oneLength
            first.frame = CGRect(x: catBoxBack.bounds.midX - buttonWidth * 0.5, y: titleLabel.frame.maxY, width: buttonWidth, height: buttonH)
            catBoxBack.addSubview(first)
        }else {
            let left = buttons.first!
            left.frame = CGRect(x: catBoxBack.bounds.midX - buttonWidth - buttonGap * 0.5, y: titleLabel.frame.maxY, width: buttonWidth, height: buttonH)
            catBoxBack.addSubview(left)
            
            let right = buttons[1]
            right.frame = CGRect(x: catBoxBack.bounds.midX + buttonGap * 0.5, y: titleLabel.frame.maxY, width: buttonWidth, height: buttonH)
            catBoxBack.addSubview(right)
            
            if buttons.count == 3 {
                let last = buttons.last!
                last.frame = CGRect(x: left.frame.minX, y: left.frame.maxY + buttonGap, width: right.frame.maxX - left.frame.minX, height: buttonH)
                catBoxBack.addSubview(last)
            }
        }
    }
    
    fileprivate var buttonInfo = [(String, Bool, (()->Void)?)]()
    func addTitle(_ title: String, subTitle: String?, buttonInfo: [(String, Bool, (()->Void)?)]) {
        self.buttonInfo = buttonInfo
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 22 * fontFactor, weight: .medium)])
        if subTitle != nil {
            attributedText.append(NSAttributedString(string: "\n\n\(subTitle!)", attributes: [.font: UIFont.systemFont(ofSize: 16 * fontFactor)]))
        }
        titleLabel.attributedText = attributedText
        
        for (i, one) in buttonInfo.enumerated() {
            let button = GradientBackStrokeButton(type: .custom)
            button.tag = 100 + i
            button.setupWithTitle(one.0)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            button.isSelected = one.1
            buttons.append(button)
        }
    }
    
    func useDismissButton()  {
        
    }
    
    @objc func buttonAction(_ button: UIButton) {
        let realAction = buttonInfo[button.tag - 100].2
        dismiss(animated: true) {
            realAction?()
        }
    }
    
    @objc func dismissVC()  {
        dismiss(animated: true) {
            // after dismiss
            
        }
    }
}
