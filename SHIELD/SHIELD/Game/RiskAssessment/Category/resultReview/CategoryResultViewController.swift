//
//  CategoryResultViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/10/19.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class CategoryResultViewController: UIViewController, CardActionProtocol {
    weak var categoryVC: CategoryViewController!
    
    fileprivate var cards = [CardInfoObjModel]()
    fileprivate var currentIndex = 0
    fileprivate var categoryName = ""
    
    fileprivate let titleLabel = UILabel()
    fileprivate var cardsResultView: CategoryCardsCollectionView!
    fileprivate var cardView: CardTemplateView!
    
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let middleLayer = CAShapeLayer()
    fileprivate let hideButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // back
        let topColor = UIColorFromHex(0xB4EC51)
        let downColor = UIColorFromHex(0x429321)
        gradientLayer.colors = [topColor.cgColor, downColor.cgColor]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.borderColor = topColor.cgColor
        gradientLayer.borderWidth = fontFactor
        gradientLayer.cornerRadius = 8 * fontFactor
        gradientLayer.masksToBounds = true
        
        middleLayer.fillColor = UIColor.black.cgColor
        middleLayer.opacity = 0.6
        
        view.layer.addSublayer(gradientLayer)
        gradientLayer.addSublayer(middleLayer)
        
        // hide button
        hideButton.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        hideButton.frame.size = CGSize(width: 20 * fontFactor, height: 22 * fontFactor)
        hideButton.setBackgroundImage(ProjectImages.sharedImage.rectCrossDismiss, for: .normal)
        view.addSubview(hideButton)
        
        // title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18 * fontFactor, weight: .bold)
        view.addSubview(titleLabel)
        
        // views
        useScrollFrame(false)
    }
    
    func setupWithCards(_ cards: [CardInfoObjModel], categoryName: String, desIndex: Int) {
        self.cards = cards
        self.categoryName = categoryName
        self.currentIndex = desIndex
    }
    
    // horizontal
    // 14, 197, 347 * 275, h: 68
    fileprivate var scrollVersion = true
    fileprivate func useScrollFrame(_ animated: Bool) {
        scrollVersion = true
        
        let scrollFrame = CGRect(x: 14 * standWP, y: 197 * fontFactor, width: 347 * standWP, height: 275 * fontFactor)
        let resultFrame = setupFramesWithMain(scrollFrame)
        titleLabel.text = categoryName
        
        if cardsResultView == nil {
            cardsResultView = CategoryCardsCollectionView.createWithFrame(resultFrame.insetBy(dx: fontFactor, dy: fontFactor), cards: cards)
            cardsResultView.hostVC = self
            view.addSubview(cardsResultView)
        }
        
        // hide card, show scroll
        cardsResultView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        if self.cardView != nil {
            self.cardView.endShow()
        }
        
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.cardsResultView.alpha = 1
            if self.cardView != nil {
                self.cardView.alpha = 0
            }
        }) { (true) in
            if self.cardView != nil {
                self.cardView.removeFromSuperview()
                self.cardView = nil
            }
        }
    }
    
    fileprivate func setupFramesWithMain(_ fullFrame: CGRect) -> CGRect {
        let topH = 68 * fontFactor
        gradientLayer.locations = [0.01, NSNumber(value: Float(topH / fullFrame.height * 0.5))]
        gradientLayer.frame = fullFrame
        
        hideButton.center = CGPoint(x: fullFrame.maxX - 12 * fontFactor, y: fullFrame.minY + 14 * fontFactor)
        titleLabel.frame = CGRect(x: fullFrame.minX, y: fullFrame.minY, width: hideButton.frame.maxX - fullFrame.minX , height: topH - fontFactor * 2).insetBy(dx: hideButton.frame.width + fontFactor, dy: 0)
        
        let resultFrame = CGRect(x: 0, y: topH, width: fullFrame.width, height: fullFrame.height - topH)
        middleLayer.path = UIBezierPath(rect: resultFrame).cgPath
        
        
        return CGRect(x: fullFrame.minX, y: fullFrame.minY + topH, width: fullFrame.width, height: fullFrame.height - topH).insetBy(dx: 4 * fontFactor, dy: fontFactor)
    }
    
    // show card at index
    func showCardWithCardIndex(_ index: Int) {
        if index < 0 || index > cards.count - 1 {
            return
        }
        currentIndex = index
        
        cardsResultView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        
        scrollVersion = false
        let fullFrame = CGRect(x: 9 * standWP, y: 113 * fontFactor, width: 357 * standWP, height: 442 * fontFactor)
        let resultFrame = setupFramesWithMain(fullFrame)
        let cardFrame = CGRect(x: fullFrame.midX - 121 * fontFactor, y: 193 * fontFactor, width: 242 * fontFactor, height: 331 * fontFactor)

        let card = cards[index]
        cardView = CardTemplateManager.sharedManager.createCardTemplateWithKey(card.cardStyleKey, frame: resultFrame)
        view.addSubview(cardView)
        cardView.cardFrame = cardFrame
        cardView.actionDelegate = self
        
        // data
        cardView.setCardContent(card, defaultSelection: card.getDisplayOptions().first)
        cardView.setupCardBackAndStyles()
        cardView.setupCardAnswerUI()
        
        // action
        if card.isJudgementCard() || card.isInputCard() {
            cardView.frame = cardFrame
        }
        
        if card.isJudgementCard() {
            cardView.addActions()
        }
        
        titleLabel.text = card.title ?? "Choose an Answer"
        
        UIView.animate(withDuration: 0.3, animations: {
            self.cardsResultView.alpha = 0
            self.cardView.alpha = 1
        }) { (true) in
            self.cardView.beginToShow()
        }
    }
    
    // show all played cards
    func backToDisplay(_ changed: Bool) {
        // answer is changed
        if changed {
            self.cardsResultView.reloadItems(at: [IndexPath(item: currentIndex, section: 0)])
        }
        useScrollFrame(true)
    }
    
    // hide button is touched
    @objc func hideView()  {
        // go back to display all cards
        if scrollVersion {
           dismiss(animated: true, completion: nil)
        } else {
            backToDisplay(false)
        }
    }
    
    func card(_ cardView: CardTemplateView, chooseItemAt item: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.backToDisplay(true)
        }
    }
    
    func card(_ cardView: CardTemplateView, input value: Float) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.backToDisplay(true)
        }
    }
}
