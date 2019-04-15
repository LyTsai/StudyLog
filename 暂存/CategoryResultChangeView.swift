//
//  CategoryResultChangeView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/10/20.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class CategoryResultChangeView: UIView, CardActionProtocol {
    weak var hostVC: CategoryViewController!
    
    fileprivate var cards = [CardInfoObjModel]()
    fileprivate var currentIndex = 0
    fileprivate var categoryName = ""
    fileprivate let titleLabel = UILabel()
    fileprivate var cardsResultView: CategoryCardsCollectionView!
    fileprivate var cardView: CardTemplateView!
    fileprivate let bgImageView = UIImageView(image: UIImage(named: "resultDisplay_back"))
    
    // set of cards
    class func createWithFrame(_ frame: CGRect, cards: [CardInfoObjModel], title: String) -> CategoryResultChangeView {
        let changeView = CategoryResultChangeView(frame: frame)
        changeView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        changeView.setupUIWithCards(cards, title: title)
        
        return changeView
    }
    
    fileprivate var backFrame: CGRect {
        return CGRect(x: 5, y: bounds.height * 0.2, width: bounds.width - 10, height: bounds.height * 0.5)
    }
    
    fileprivate var cardBackFrame: CGRect {
        return CGRect(x: backFrame.minX, y: bounds.height * 0.03, width: backFrame.width, height: bounds.height * 0.9)
    }
    
    // top: 219, bottom: 54 (@3x)
    fileprivate var areaEdgeInset: UIEdgeInsets {
        return UIEdgeInsets(top: 73, left: 15, bottom: 18, right: 15)
    }

    fileprivate var cardViewFrame: CGRect {
        return CGRect(x: areaEdgeInset.left, y: areaEdgeInset.top, width: backFrame.width - areaEdgeInset.left - areaEdgeInset.right, height: cardBackFrame.height - areaEdgeInset.top - areaEdgeInset.bottom)
    }
    
    fileprivate var resultFrame: CGRect {
        return CGRect(x: areaEdgeInset.left, y: areaEdgeInset.top, width: backFrame.width - areaEdgeInset.left - areaEdgeInset.right, height: backFrame.height - areaEdgeInset.top - areaEdgeInset.bottom)
    }
    
    // create
    fileprivate func setupUIWithCards(_ cards: [CardInfoObjModel], title: String) {
        bgImageView.isUserInteractionEnabled = true
        addSubview(bgImageView)
        bgImageView.frame = backFrame
        
        // cards
        cardsResultView = CategoryCardsCollectionView.createWithFrame(resultFrame, cards: cards)
        cardsResultView.hostView = self
        bgImageView.addSubview(cardsResultView)
        
        // hide button
        let hideButton = UIButton(type: .custom)
        hideButton.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        hideButton.setBackgroundImage(ProjectImages.sharedImage.rectCrossDismiss, for: .normal)
        hideButton.frame = CGRect(x: backFrame.width - 50, y: 15, width: 26, height: 26)
        bgImageView.addSubview(hideButton)
        
        // title
        titleLabel.frame = CGRect(x: 50, y: 15, width: backFrame.width - 100, height: 50)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18 * fontFactor, weight: UIFont.Weight.bold)
        categoryName = title
        titleLabel.text = title
        bgImageView.addSubview(titleLabel)
    }
    
    // reset data
    func reloadWithCards(_ cards: [CardInfoObjModel], mainColor: UIColor, title: String, desIndex: Int!) {
        if cards.count == 0 {
            return
        }
        
        self.cards = cards
        cardsResultView.mainColor = mainColor
        cardsResultView.cards = cards
        titleLabel.text = title
        categoryName = title
        cardsResultView.reloadData()
        
        // scroll
        if desIndex != nil && desIndex > 0 && desIndex < cards.count {
            currentIndex = desIndex
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.cardsResultView.scrollToItem(at: IndexPath(item: desIndex, section: 0), at: .centeredHorizontally, animated: true)
            })
        }
    }
    
    // show card at index
    func showCardWithCardIndex(_ index: Int) {
        if index < 0 || index > cards.count - 1 {
            return
        }
        
        currentIndex = index
        cardsResultView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        
        // card
        if cardView != nil {
            cardView.removeFromSuperview()
        }
        
        // in a deck
        let card = cards[index]
        cardView = CardTemplateManager.sharedManager.createCardTemplateWithKey(card.cardStyleKey, frame: cardViewFrame)
        cardView.cardFrame = cardViewFrame.insetBy(dx: cardViewFrame.width * 0.04, dy: cardViewFrame.height * 0.02)
        cardView.actionDelegate = self
   
        // data
        cardView.setCardContent(card, defaultSelection: card.cardOptions.first)
        cardView.setupCardBackAndStyles()
        cardView.setupCardAnswerUI()
        
        // action
        if card.isJudgementCard() {
            cardView.addActions()
            cardView.frame = cardViewFrame.insetBy(dx: cardViewFrame.width * 0.01, dy: cardViewFrame.height * 0.01)
        }
        
        titleLabel.text = card.title ?? "Choose an Answer"
        // move
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseIn, animations: {
            self.bgImageView.frame = self.cardBackFrame
            self.cardsResultView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (true) in
            self.bgImageView.addSubview(self.cardView)
        }
    }

    // show all played cards
    func backToDisplay()  {
        // answer is changed
        self.cardsResultView.reloadItems(at: [IndexPath(item: currentIndex, section: 0)])
        if self.cardView != nil {
            self.cardView.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
            self.cardsResultView.transform = CGAffineTransform.identity
            self.bgImageView.frame = self.backFrame
        }) { (true) in
            self.titleLabel.text = self.categoryName
            self.hostVC.checkDataAndReload()
        }
    }
    
    // hide button is touched
    @objc func hideView()  {
        // go back to display all cards
        if cardsResultView.transform != CGAffineTransform.identity {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.backToDisplay()
            }
        } else {
            // go back to category
            if cardView != nil {
                cardView.removeFromSuperview()
            }
            
            UIView.animate(withDuration: 0.4, animations: {
                self.cardsResultView.transform = CGAffineTransform.identity
                self.bgImageView.frame = self.backFrame
            }) { (true) in
                self.titleLabel.text = self.categoryName
                self.hostVC.hideCategoryResult()
            }
        }
    }
    
    func card(_ cardView: CardTemplateView, chooseItemAt item: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.backToDisplay()
        }
    }

    func card(_ cardView: CardTemplateView, input value: Float) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.backToDisplay()
        }
    }
}
