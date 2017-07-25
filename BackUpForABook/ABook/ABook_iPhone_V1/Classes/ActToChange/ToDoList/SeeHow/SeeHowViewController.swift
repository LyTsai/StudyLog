//
//  SeeHowViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/6.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class SeeHowViewController: UIViewController {
    
    var currentIndex: Int = 0 {
        didSet{
            if currentIndex != oldValue {
                cardsCollection.currentIndex = currentIndex
//                riskTable.risks = cards[currentIndex].risks
//                setupArrowState()
            }
        }
    }
    
    fileprivate var cardsCollection: MatchedCardsCollectionView!
    fileprivate let cards = MatchedCardModel.getMatchedData()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "See How I am Doing"
        automaticallyAdjustsScrollViewInsets = false
        
        // back image
        view.layer.contents = UIImage(named: "homeBackImage")?.cgImage
        
        // bar
        let comments = UIBarButtonItem(customView: CommentsView.createWithSize(CGSize(width: 22, height: 22), number: 0))
        let shareButton = UIButton(type: .custom)
        shareButton.setBackgroundImage(UIImage(named: "icon_share"), for: .normal)
        shareButton.frame = CGRect(x: 0, y: 0, width: 18, height: 20)
        let share = UIBarButtonItem(customView: shareButton)
        navigationItem.rightBarButtonItems = [share, comments]
        
        let cardsFrame = CGRect(x: 0, y: 70, width: width, height: width * 389 / 375)
        
        cardsCollection = MatchedCardsCollectionView.createWithFrame(cardsFrame, itemSize: CGSize(width: 275 * width / 375, height: cardsFrame.height - 12), cards: cards, withAssess: true)
        view.addSubview(cardsCollection)
        
        let nextSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextView))
        nextSwipe.direction = .left
        cardsCollection.addGestureRecognizer(nextSwipe)
        
        let lastSwipe = UISwipeGestureRecognizer(target: self, action: #selector(lastView))
        lastSwipe.direction = .right
        cardsCollection.addGestureRecognizer(lastSwipe)
    }
    
    func lastView() {
        if currentIndex != 0 {
            currentIndex -= 1
        }
    }
    
    func nextView() {
        if currentIndex != cards.count - 1 {
            currentIndex += 1
        }
    }
    
}
