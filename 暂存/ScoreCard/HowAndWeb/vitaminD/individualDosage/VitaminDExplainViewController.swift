//
//  VitaminDExplainViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/8.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VitaminDExplainViewController: UIViewController {
    weak var scorecardAllDelegate: ScorecardDisplayAllView!
    
    fileprivate let subTitleLabel = UILabel()
    fileprivate let dosageView = RecommandDosageView()
    fileprivate let insightHint = UIView()
    fileprivate let insightLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let mainBack = UIView()
        mainBack.frame = view.bounds.insetBy(dx: 15 * fontFactor, dy: UIApplication.shared.statusBarFrame.size.height + 5 * standHP)
        mainBack.backgroundColor = UIColor.white
        mainBack.layer.cornerRadius = 8 * fontFactor
        mainBack.layer.masksToBounds = true
        view.addSubview(mainBack)
        
        let dismiss = UIButton(type: .custom)
        dismiss.setBackgroundImage(#imageLiteral(resourceName: "grayDismiss"), for: .normal)
        dismiss.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismiss.frame = CGRect(x: mainBack.bounds.width - 25 * fontFactor, y: 10 * standHP, width: 20 * fontFactor, height: 20 * fontFactor)
        mainBack.addSubview(dismiss)
        
        subTitleLabel.text = "Here’s your individualized additional dosage estimate above your current vitamin D level to your target levels."
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textAlignment = .center
        mainBack.addSubview(subTitleLabel)
        
        subTitleLabel.frame = CGRect(x: 0, y: 8 * fontFactor, width: mainBack.bounds.width, height: 70 * fontFactor).insetBy(dx: 30 * fontFactor, dy: 0)
        subTitleLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: UIFont.Weight.medium)
        subTitleLabel.adjustWithWidthKept()
        
        let top = subTitleLabel.frame.maxY + 8 * fontFactor
        dosageView.frame = CGRect(x: 0, y: top, width: mainBack.bounds.width, height: mainBack.bounds.height - top)
        dosageView.setupWithCurrentLevel(levelIndex, text: text, lbsWeight: lbsWeight)
        mainBack.addSubview(dosageView)
        
        // bottom
        let bottomH = mainBack.bounds.height * 0.1
        insightHint.frame = CGRect(x: 0, y: mainBack.bounds.height - bottomH, width: mainBack.bounds.width, height: bottomH)
        insightHint.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        insightLabel.numberOfLines = 0
        insightLabel.textAlignment = .center
        insightLabel.font = UIFont.systemFont(ofSize: 10 * fontFactor, weight: .medium)
        insightLabel.text = "You can check the \"insight page\" for disease reductions with increased vitamin D level."
        mainBack.addSubview(insightHint)
        insightHint.addSubview(insightLabel)
        insightLabel.frame = insightHint.bounds.insetBy(dx: 10 * fontFactor, dy: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        dosageView.arrowAnimation()
    }
    
    fileprivate var levelIndex = 0
    fileprivate var text = ""
    fileprivate var lbsWeight: Float  = 0
    func setupWithCurrentLevel(_ levelIndex: Int, text: String, lbsWeight: Float) {
        self.levelIndex = levelIndex
        self.text = text
        self.lbsWeight = lbsWeight
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        dismissVC()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
