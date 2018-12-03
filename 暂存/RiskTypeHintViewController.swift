//
//  RiskTypeHintViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/10/16.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class RiskTypeHintViewController: UIViewController {
    // delegate
    weak var presentedFrom: UIViewController!
    
    // subviews
    fileprivate let backImageView = UIImageView()
    fileprivate let titleLabel = UILabel()

    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
       
        // 375 * 580， back hint image, with shadow
        let imageFrame = CGRect(center: CGPoint(x: view.bounds.midX, y: view.bounds.height * 0.48), width: 375 * fontFactor, height: 580 * fontFactor)
        backImageView.frame = imageFrame
//        backImageView.contentMode = .scaleAspectFit
        backImageView.image = CardViewImagesCenter.sharedCenter.launchHintImage
        
        // title
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.text = cardsCursor.selectedRiskClass.name
        titleLabel.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: UIFont.Weight.semibold)
        titleLabel.frame = CGRect(x: 20 * fontFactor, y: 20 * fontFactor, width: imageFrame.width - 40 * fontFactor, height: 35 * fontFactor)
        
        backImageView.addSubview(titleLabel)
        
        // no longer， 110 * 36
        let buttonY = backImageView.frame.maxY - 82 * fontFactor
        let buttonSize = CGSize(width: 138 * fontFactor, height: 50 * fontFactor)
        let nolongerShowButton = UIButton(frame: CGRect(origin: CGPoint(x: backImageView.frame.minX + 44 * fontFactor, y: buttonY), size: buttonSize))
    
        nolongerShowButton.addTarget(self, action: #selector(nolongerShow), for: .touchUpInside)
        
        // dismiss, 145 * 36
        let gotItButton = UIButton(frame: CGRect(origin: CGPoint(x: backImageView.frame.maxX - 44 * fontFactor - buttonSize.width, y: buttonY), size: buttonSize))
        gotItButton.addTarget(self, action: #selector(gotIt), for: .touchUpInside)

        // add
        view.addSubview(backImageView)
        view.addSubview(nolongerShowButton)
        view.addSubview(gotItButton)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // if the other tab's item is touched
        gotIt()
    }
    
    
    @objc func gotIt() {
        dismiss(animated: true) {
            if self.presentedFrom != nil {
                self.presentedFrom.navigationController?.pushViewController(IntroPageViewController(), animated: true)
            }
        }
    }
    
    @objc func nolongerShow(_ button: UIButton) {
        let riskTypeKey = cardsCursor.riskTypeKey
        let keyString = "showedFor\(riskTypeKey)"
        userDefaults.set(true, forKey: keyString)
        userDefaults.synchronize()
        gotIt()
    }
}
