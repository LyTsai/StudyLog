//
//  SeeHowCardsViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/3.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class SeeHowCardsViewController: UIViewController {
    var matchedCards = [MatchedCardsDisplayModel]() {
        didSet{
            // reload cards, will be called before viewDidLoad
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navi & back
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "See How I am Doing"
        automaticallyAdjustsScrollViewInsets = false
        view.layer.contents = UIImage(named: "homeBackImage")?.cgImage
        
        // barButton
        let share = UIBarButtonItem(title: "My Share", style: .plain, target: self, action: #selector(getMyShare))
        navigationItem.rightBarButtonItem = share
        
        // subviews
        let seeHow = SeeHowCardsView()
        seeHow.setupWithFrame(mainFrame, cardEdgeInsets: UIEdgeInsets(top: 10, left: 20, bottom: 96 * height / 667, right: 20), cards: matchedCards)
        view.addSubview(seeHow)
    }
    
    func getMyShare() {
        print("show share")
    }
}
