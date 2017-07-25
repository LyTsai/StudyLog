//
//  MatchedCardsViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/6.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class MatchedCardsViewController: UIViewController {
    
    // data
    fileprivate let cards = MatchedCardModel.getMatchedData()
    
    // views
    fileprivate let leftArrow = UIButton(type: .custom)
    fileprivate let rightArrow = UIButton(type: .custom)
    fileprivate var cardsCollectionView: MatchedCardsCollectionView!
    fileprivate let maskView = UIView()
    fileprivate var riskTable: MatchedCardRiskTableView!
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "Matched Cards"
        automaticallyAdjustsScrollViewInsets = false
        
        // back image
        view.layer.contents = UIImage(named: "homeBackImage")?.cgImage
        
        // bar
        let comments = UIBarButtonItem(customView: CommentsView.createWithSize(CGSize(width: 22, height: 22), number: 5))
        let shareButton = UIButton(type: .custom)
        shareButton.setBackgroundImage(UIImage(named: "icon_share"), for: .normal)
        shareButton.frame = CGRect(x: 0, y: 0, width: 18, height: 20)
        let share = UIBarButtonItem(customView: shareButton)
        navigationItem.rightBarButtonItems = [share, comments]
    
        // cards
        let xMargin = 25 * width / 375
        let cardsFrame = CGRect(x: 0, y: 70, width: width, height: height - 64 - 49 - 110)
        cardsCollectionView = MatchedCardsCollectionView.createWithFrame(cardsFrame, itemSize: CGSize(width: width - 2 * xMargin, height: cardsFrame.height - 4), cards: cards, withAssess: false)

        view.addSubview(cardsCollectionView)
    
        // arrows
        let arrowWidth = 31 * width / 375
        let arrowHeight = 90 * width / 375
        let arrowY = cardsFrame.midY - arrowHeight * 0.5
        
        leftArrow.setBackgroundImage(UIImage(named: "move_to_left"), for: .normal)
        leftArrow.frame =  CGRect(x: 0, y: arrowY, width: arrowWidth, height: arrowHeight)
        leftArrow.isHidden = true
        
        rightArrow.setBackgroundImage(UIImage(named: "move_to_right"), for: .normal)
        rightArrow.frame = CGRect(x: width - arrowWidth, y: arrowY, width: arrowWidth, height: arrowHeight)
        
        leftArrow.addTarget(self, action: #selector(lastView), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(nextView), for: .touchUpInside)
        
        view.addSubview(leftArrow)
        view.addSubview(rightArrow)
        
        // mask
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        maskView.frame = view.bounds
        maskView.isHidden = true
        view.addSubview(maskView)
        
        // table
        riskTable = MatchedCardRiskTableView.createWithFirstFrame(CGRect(x: xMargin, y: cardsFrame.maxY, width: width - 2 * xMargin, height: height - cardsFrame.maxY - 49 - 4), maxHeight: height - 2 * cardsFrame.minX + 64 - 49, risks: cards.first!.risks)
        riskTable.layer.cornerRadius = 4
        riskTable.isScrollEnabled = false
        riskTable.allowsSelection = false
        view.addSubview(riskTable)
        
        addGestures()
    }
    
    fileprivate func addGestures() {
        let nextSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextView))
        nextSwipe.direction = .left
        cardsCollectionView.addGestureRecognizer(nextSwipe)
        
        let lastSwipe = UISwipeGestureRecognizer(target: self, action: #selector(lastView))
        lastSwipe.direction = .right
        cardsCollectionView.addGestureRecognizer(lastSwipe)
        
        let upSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(checkTable))
        upSwipeGR.direction = .up
        riskTable.addGestureRecognizer(upSwipeGR)
        
        let downSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(hideTable))
        downSwipeGR.direction = .down
        riskTable.addGestureRecognizer(downSwipeGR)
    }
    
    // action
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
    
    func checkTable() {
        checkCard = false
        let transform = CGAffineTransform(translationX: 0, y: (0.5 * (height - 64 - 49) + 64 - riskTable.frame.midY))
        UIView.animate(withDuration: 0.4) {
            self.riskTable.transform = transform
        }
    }
    
    func hideTable() {
        checkCard = true
        UIView.animate(withDuration: 0.4) {
            self.riskTable.transform = CGAffineTransform.identity
        }
    }
    
    
    // state
    fileprivate var checkCard = true {
        didSet{
            if checkCard != oldValue {
                setupArrowState()
                maskView.isHidden = checkCard
                riskTable.isScrollEnabled = !checkCard
            }
        }
    }
    var currentIndex: Int = 0 {
        didSet{
            if currentIndex != oldValue {
                cardsCollectionView.currentIndex = currentIndex
                riskTable.risks = cards[currentIndex].risks
                setupArrowState()
            }
        }
    }
    
    // the arrows
    fileprivate func setupArrowState() {
        if checkCard {
            if currentIndex == 0 {
                leftArrow.isHidden = true
                rightArrow.isHidden = false
            }else if currentIndex == cards.count - 1 {
                leftArrow.isHidden = false
                rightArrow.isHidden = true
            }else {
                leftArrow.isHidden = false
                rightArrow.isHidden = false
            }
        } else {
            leftArrow.isHidden = true
            rightArrow.isHidden = true
        }
    }
}

