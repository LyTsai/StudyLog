//
//  MatchedCardsViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/16.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class MatchedCardsViewController: UIViewController {
    var risk: RiskObjModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = ""
        
        navigationItem.title = "\(risk.name!) Prediction"
        
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = UIImage(named: "homeBackImage")
        view.addSubview(backImageView)

        let topHeight: CGFloat = 77 * width / 375
        let riskInfoView = RiskDetailInfoView.createWithFrame(CGRect(x: 0, y: 64, width: width, height: topHeight), risk: risk)
        riskInfoView.hostVC = self
        view.addSubview(riskInfoView)
        
        let cardsFrame = CGRect(x: 0, y: 64 + topHeight, width: width, height: height - 64 - 49 - topHeight)
        let collection = MatchedCardsCollectionView.createWithFrame(cardsFrame, risks: [risk], withAssessment: false)
        view.addSubview(collection)
    }
    
}

