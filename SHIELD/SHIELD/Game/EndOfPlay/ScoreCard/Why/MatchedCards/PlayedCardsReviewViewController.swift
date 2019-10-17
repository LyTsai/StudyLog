//
//  PlayedCardsReviewViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/8/21.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class PlayedCardsReviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    fileprivate var cards = [CardInfoObjModel]()
    fileprivate var currentIndex = 0
    fileprivate var cardsReviewView: UICollectionView!
    fileprivate let distributionView = AssessmentsClassificationView.createWithFrame(CGRect.zero)
    fileprivate var withDistribution = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.setBackgroundImage(ProjectImages.sharedImage.circleCrossDismiss, for: .normal)
        let length = 30 * fontFactor
        let marginX = length * 1.2
        dismissButton.frame = CGRect(x: width - marginX, y: 44, width: length, height: length)
        
        view.addSubview(dismissButton)
        
        // top
        if withDistribution {
            // cardInfo
            let topFrame = CGRect(x: 0, y: dismissButton.frame.midY, width: width, height: 30 * fontFactor).insetBy(dx: marginX, dy: 0)
            distributionView.frame = topFrame
            view.addSubview(distributionView)
        }
        
        let topY = withDistribution ? distributionView.frame.maxY : dismissButton.frame.maxY
        // cards
        let reviewFrame = CGRect(x: 0, y: topY, width: width, height: height - topY - bottomLength)
        let layout = CoverFlowLayout()
        let itemW = reviewFrame.width * 0.93
        let itemH = reviewFrame.height * 0.98
        let xMargin = (reviewFrame.width - itemW) * 0.5

        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: xMargin, bottom: 0, right: xMargin)
        cardsReviewView = UICollectionView(frame: reviewFrame, collectionViewLayout: layout)
        cardsReviewView.backgroundColor = UIColor.clear
        cardsReviewView.isScrollEnabled = false
        cardsReviewView.register(MatchedCardsCollectionViewCell.self, forCellWithReuseIdentifier: matchedCardsCellID)
        cardsReviewView.dataSource = self
        cardsReviewView.delegate = self
        
        view.addSubview(cardsReviewView)
        
        // gestures
        let nextSwipe = UISwipeGestureRecognizer(target: self, action: #selector(goToNextCard))
        nextSwipe.direction = .left
        view.addGestureRecognizer(nextSwipe)
        
        let lastSwipe = UISwipeGestureRecognizer(target: self, action: #selector(goToLastCard))
        lastSwipe.direction = .right
        view.addGestureRecognizer(lastSwipe)
        
         goToCardAt(currentIndex)
    }
    
    // action
    @objc func goToNextCard() {
        if currentIndex != cards.count - 1 {
            goToCardAt(currentIndex + 1)
        }
    }
    
    @objc func goToLastCard() {
        if currentIndex != 0 {
            goToCardAt(currentIndex - 1)
        }
    }
    
    fileprivate func goToCardAt(_ index: Int) {
        if index >= cards.count {
            return
        }
        
        if cardsReviewView == nil {
            currentIndex = index
            return
        }
        
        // stop
        if currentIndex != index {
            if let lastCell = cardsReviewView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) {
                if let cardCell = lastCell as? MatchedCardsCollectionViewCell {
                    cardCell.endShow()
                }
            }
            
            currentIndex = index
            
        }
        cardsReviewView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        // if the same, just play
        if let currentCell = cardsReviewView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) {
            if let cardCell = currentCell as? MatchedCardsCollectionViewCell {
                cardCell.onShow()
            }
        }
    }
    
    func loadWithCards(_ cards: [CardInfoObjModel], index: Int, withDistribution: Bool) {
        if index < 0 || index >= cards.count {
            return
        }
        
        self.cards = cards
        currentIndex = index
        self.withDistribution = withDistribution
        
        if withDistribution {
            let classified = MatchedCardsDisplayModel.getHighLowClassifiedCards(cards)
            var classificationInfo = [(name: String, number: Int, color: UIColor)]()
            for (iden, cards) in classified {
                let color = MatchedCardsDisplayModel.getColorOfIden(iden)
                classificationInfo.append((MatchedCardsDisplayModel.getNameOfIden(iden), cards.count, color))
            }

            distributionView.classificationInfo = classificationInfo
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchedCardsCellID, for: indexPath) as! MatchedCardsCollectionViewCell
        cell.configureWithCard(cards[indexPath.item], index: indexPath.item, total: cards.count)
        cell.showClassification()
        
        return cell
    }
    
    @objc func dismissVC() {
        // stop timer...
        if let lastCell = cardsReviewView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) {
            if let cardCell = lastCell as? MatchedCardsCollectionViewCell {
                cardCell.endShow()
            }
        }
        
        dismiss(animated: true) {
            
        }
    }
}
