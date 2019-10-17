//
//  VitaminDDosageIndividualView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/17.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class VitaminDDosageIndividualView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate let visualizerButton = UIButton(type: .custom)
    
    fileprivate let subTitleLabel = UILabel()
    fileprivate let scrollView = UIScrollView()
    fileprivate let dosageView = Bundle.main.loadNibNamed("VitaminDosageEstimateView", owner: self, options: nil)?.first as! VitaminDosageEstimateView
    fileprivate let insightHint = UIView()
    fileprivate let insightLabel = UILabel()
    
    fileprivate func addViews() {
        backgroundColor = UIColor.white
        
        titleLabel.text = "Here's your individualized additional dosage estimate above your current vitamin D level to your target levels."
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        visualizerButton.setBackgroundImage(#imageLiteral(resourceName: "vtD_dosageVisualizer"), for: .normal)
        visualizerButton.addTarget(self, action: #selector(showVisulizer), for: .touchUpInside)
        
        subTitleLabel.text = "The “Sweet Spot Level” of Vitamin D Can help reduce disease risks."
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textAlignment = .center
        subTitleLabel.textColor = UIColorGray(88)
      
        scrollView.bounces = false
        
        subTitleLabel.text = "The “Sweet Spot Level” of Vitamin D Can help reduce disease risks."
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textAlignment = .center
        
        // bottom
        insightHint.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        insightLabel.numberOfLines = 0
        insightLabel.textAlignment = .center
        insightLabel.text = "You can check the \"insight page\" for disease reductions with increased vitamin D level."
        insightLabel.textColor = UIColorFromHex(0xFF8700)
        
        // add all
        addSubview(scrollView)
        scrollView.addSubview(dosageView)
        addSubview(titleLabel)
        addSubview(visualizerButton)
        addSubview(subTitleLabel)
        addSubview(insightHint)
        insightHint.addSubview(insightLabel)
    }
    
    func setupWithCurrentLevel(_ levelIndex: Int, text: String, color: UIColor, lbsWeight: Float) {
        dosageView.setupWithCurrentLevel(levelIndex, text: text, color: color, lbsWeight: lbsWeight)
    }
    
    func displayView() {
        // animation
        let focus = dosageView.displayView()
        let focusY = min(focus, scrollView.contentSize.height - scrollView.bounds.height)
        scrollView.scrollRectToVisible(CGRect(x: 0, y: focusY, width: scrollView.bounds.width, height: scrollView.bounds.height), animated: true)
    }
    
    @objc func showVisulizer() {
        viewController.dismiss(animated: true) {
            // go to insight
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = min(bounds.width / 353, bounds.height / 471)
        titleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 64 * one).insetBy(dx: 30 * one, dy: 0)
        titleLabel.font = UIFont.systemFont(ofSize: 12 * one)
        
        visualizerButton.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: 126 * one, height: 53 * one)
        subTitleLabel.frame = CGRect(x: 0, y: visualizerButton.frame.maxY, width: visualizerButton.frame.width, height: 40 * one)
        subTitleLabel.font = UIFont.systemFont(ofSize: 10 * one, weight: .light)
        
        // bottom
        let bottomH = 50 * one
        insightHint.frame = CGRect(x: 0, y: bounds.height - bottomH, width: bounds.width, height: bottomH)
        insightLabel.frame = insightHint.bounds.insetBy(dx: 20 * one, dy: 0)
        insightLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: .medium)
        
        // dosage
        let dosageWidth = bounds.width * 338 / 353
        let dosageHeight = dosageWidth / 338 * 434
        
        let leftH = bounds.height - bottomH - visualizerButton.frame.maxY
        if dosageHeight < leftH {
            scrollView.frame = CGRect(x: 0, y: visualizerButton.frame.minY, width: bounds.width, height: leftH + visualizerButton.frame.height).insetBy(dx: (bounds.width - dosageWidth) * 0.5, dy: (leftH - dosageHeight) * 0.5)
            scrollView.contentInset = UIEdgeInsets.zero
            scrollView.contentSize = scrollView.bounds.size
        }else {
            scrollView.frame = CGRect(x: 0, y: visualizerButton.frame.minY, width: bounds.width, height: bounds.height - visualizerButton.frame.minY).insetBy(dx: (bounds.width - dosageWidth) * 0.5, dy: 0)
            scrollView.contentSize = CGSize(width: dosageWidth, height: dosageHeight + bottomH + visualizerButton.frame.height)
        }
        
        dosageView.frame = CGRect(x: 0, y: visualizerButton.frame.height, width: dosageWidth, height: dosageHeight)
    }
}
