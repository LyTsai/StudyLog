//
//  SplashScreenViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
class SplashScreenViewController: UIViewController {
    weak var presenetedFromVC: ABookHomePageViewController!
    let promptLabel = UILabel()
    let titleLabel = UILabel()
    
    let titles = ["SLOW AGING BY\n DESIGN","Slow Aging By Design:\nTo reduce premature loss of vitality\n and vigor.","Slow Down Aging:\nIncidence of age related diseases\n reduces!","Slow Aging By Design:\nHealthy lifestyle turns back DNA\n methylation age."]
    let promptTexts = ["Add Years to Your Life and Add Life to\n Your Years", "", "“If you can slow againg just by 7 years,\nyou can reduce the incidence of age related\n diseases by half at every age.\nThis would have massive impact on human\n longevity and healthspan.”\n—Dr Joao pedro de Magalhaes", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        
        // back image
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "splashBG")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        // from top down
        // button
        let dismissButton = UIButton(type: .custom)
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.setBackgroundImage(UIImage(named: "Button-Unselected"), for: .normal)
        let buttonLength = 34 / 375 * view.bounds.width
        
        dismissButton.frame = CGRect(x: view.bounds.width - buttonLength - 20, y: 20, width: buttonLength, height: buttonLength)
        view.addSubview(dismissButton)
        
        // scroll and pageControl
        var images = [UIImage]()
        for i in 0..<4 {
            let image = UIImage(named: "splash_\(i)")
            images.append(image!)
        }
        
        let slide = SlideImagesView.createWithFrame(CGRect(x: 0, y: dismissButton.frame.maxY, width: view.bounds.width, height: height * 361 / 667), images: images, margin: 20 * width / 375, pageControlHeight: 15 * height / 667)
        slide.hostVC = self
        view.addSubview(slide)
        
        // texts
        let titleHeight = height * 66 / 667
        let promptHeight = height * 120 / 667
        let addressHeight = 24 * height / 667
        let vGap = (height - slide.frame.maxY - titleHeight - promptHeight - addressHeight - 20) / 3
        if vGap < 0 {
            print("wrong size, please adjust")
        }
        
        // title
        titleLabel.frame = CGRect(x: 0, y: slide.frame.maxY + vGap, width: width, height: titleHeight)
        titleLabel.text = titles.first!
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleHeight / 2.4)
        titleLabel.backgroundColor = UIColor.clear
        view.addSubview(titleLabel)
        
        // prompt
        promptLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY + vGap, width: width, height: promptHeight)
        promptLabel.textAlignment = .center
        promptLabel.numberOfLines = 0
        promptLabel.font = UIFont.systemFont(ofSize: promptHeight / 8, weight: UIFontWeightLight)
        promptLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        promptLabel.text = promptTexts.first!
        view.addSubview(promptLabel)
        
        // address, label or button
        let address = UIButton(type: .custom)
        
        let addressWidth = 120 * width / 375
        address.frame = CGRect(x: (width - addressWidth) * 0.5, y: height - 20 - addressHeight, width: addressWidth, height: addressHeight)
        address.setTitle("www.AnnielyticX.com", for: .normal)
        address.setTitleColor(UIColorFromRGB(104, green: 159, blue: 56), for: .normal)
        address.titleLabel?.textAlignment = .center
        address.titleLabel?.font = UIFont.systemFont(ofSize: addressHeight / 2.3)
        view.addSubview(address)
    }
    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
        
        if presenetedFromVC != nil {
            presenetedFromVC.goToNext()
        }
    }
    
    // status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
