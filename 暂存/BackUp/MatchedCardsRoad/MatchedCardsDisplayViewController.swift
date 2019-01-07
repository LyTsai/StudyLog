//
//  MatchedCardsDisplayViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/9/14.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class MatchedCardsDisplayViewController: UIViewController {
    var cards = [MatchedCardsDisplayModel]()
    var mainColor = tabTintGreen
    var roadTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "Matched Cards"
        
        // back image
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.categoryBack
        view.addSubview(backImageView)
        
        var cardInfos = [CardInfoObjModel]()
        for card in cards {
            cardInfos.append(card.cardInfo)
        }
        
        let summaryRoad = SummaryOfCardsRoadCollectionView.createWithFrame(mainFrame, cards: cardInfos, mainColor: mainColor, forPart: true)
        summaryRoad.forMatched = true
        
        view.addSubview(summaryRoad)
        summaryRoad.roadEndImageView.removeFromSuperview()
        
        addTitleCloud()
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate func addTitleCloud() {

        // topLeft
        let titleImage = ProjectImages.sharedImage.roadCardTitle!
        let titleWidth = 188 * standWP
        let titleImageView = UIImageView(frame : CGRect(x: 0, y: 39, width: titleWidth, height: titleImage.size.height * titleWidth / titleImage.size.width))
        titleImageView.image = titleImage
        
        // label on it
        titleLabel.frame = CGRect(x: 5 * standWP, y: 68, width: 123 * standWP, height: 50)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)

        titleLabel.text = roadTitle
        
        view.addSubview(titleImageView)
        view.addSubview(titleLabel)
    }
}
