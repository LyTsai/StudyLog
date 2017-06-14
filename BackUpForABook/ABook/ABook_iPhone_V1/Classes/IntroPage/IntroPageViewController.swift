//
//  IntroPageViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/9.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class IntroPageViewController: UIViewController {
    var pageTableView:IntroPageTableView!
    // frame
    fileprivate var marginGap: CGFloat {
        // 5, for iPhone7
        return view.bounds.width / 75.0
    }
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "" // keep the title in center
        navigationItem.title = "Welcome to the game"
        
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: view.bounds.width, height: view.bounds.height - 49))
        let riskMetric = RiskMetricCardsCursor.sharedCursor.selectedRiskClass
        if riskMetric == nil {
            print("no riskClass is chosen")
            
        }else {
            pageTableView = IntroPageTableView.createTableViewWith(rect, riskMetric: riskMetric!)
            view.addSubview(pageTableView)
            pageTableView.hostNavi = navigationController
        }
        setupUI()
    }
    
    fileprivate func setupUI() {
        // background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [introPageTopColor.cgColor, introPageBottomColor.cgColor]
        gradientLayer.locations = [0.2, 0.8]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        
         // add mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        let showRect = CGRect(x: marginGap, y: marginGap * 1.2 + 64, width: view.bounds.width - 2 * marginGap, height: view.bounds.height)
        
        let path = UIBezierPath(roundedRect: showRect, cornerRadius: marginGap * 1.2)
        path.append(UIBezierPath(rect: view.bounds))
        maskLayer.path = path.cgPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        maskLayer.fillColor = UIColor.red.cgColor
        gradientLayer.mask = maskLayer
    }

    
    // for title and reload
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Welcome to the game"
    }
}
