//
//  CardAnswerChangeViewController.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/12/4.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class CardAnswerChangeViewController: UIViewController, CardActionProtocol {
    var forChange = true
    var duration: TimeInterval!
    fileprivate var cardsView: MatchedCardDisplayView!

    weak var summaryVC: SummaryViewController!
    fileprivate var cardView: CardTemplateView!
    fileprivate var matched: MatchedCardsCollectionViewCell!
    fileprivate var timer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.setBackgroundImage(ProjectImages.sharedImage.circleCrossDismiss, for: .normal)
        let length = 34 * min(standHP, standWP)
        dismissButton.frame = CGRect(x: width - max(50 * min(standHP, standWP), width * 0.05), y: max(topLength, height * 0.08), width: length, height: length)
        
        view.addSubview(dismissButton)
        
        if duration != nil {
            timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { (true) in
                self.dismissVC()
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // currentCard
        if cardView != nil {
            cardView.beginToShow()
        }else if cardsView != nil {
//            cardsView.showCurrentCard()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if cardView != nil {
            cardView.endShow()
        }else if cardsView != nil {
        }
    }
    
    func loadWithCard(_ card: CardInfoObjModel) {
        if forChange {
            cardView = CardTemplateManager.sharedManager.createCardTemplateWithKey(card.cardStyleKey, frame: mainFrame.insetBy(dx: width * 0.05, dy: height * 0.1))
            
            if card.isJudgementCard() {
                cardView.addActions()
            }
            
            cardView.actionDelegate = self
            cardView.cardFrame = cardView.bounds.insetBy(dx: width * 0.05, dy: height * 0.03)
            cardView.setCardContent(card, defaultSelection: card.getDisplayOptions().first)
            cardView.setupCardBackAndStyles()
            cardView.setupCardAnswerUI()
            view.addSubview(cardView)
        }else {
            // matched card
            matched = MatchedCardsCollectionViewCell(frame: mainFrame.insetBy(dx: width * 0.05, dy: height * 0.1))
            matched.configureWithCard(card, index: nil, total: nil)
            view.addSubview(matched)
        }
    }
    
    func showBaseline(_ index: Int?) {
        if index != nil {
            cardView.setForBaselineChoice(index)
        }
    }

    func card(_ cardView: CardTemplateView, chooseItemAt item: Int) {
        if summaryVC != nil {
            summaryVC.answerIsSetForCard(cardView.vCard, result: item)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismissVC()
        }
    }
    
    func loadWithCards(_ cards: [CardInfoObjModel], riskTypeKey: String, borderColor: UIColor)  {
        cardsView = MatchedCardDisplayView(frame: mainFrame.insetBy(dx: width * 0.05, dy: height * 0.1))
        view.addSubview(cardsView)
        cardsView.reloadWithCards(cards, riskTypeKey: riskTypeKey)
        cardsView.lineColor = borderColor
    }
    
    @objc func dismissVC() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        dismiss(animated: true) {
            // card view
            if self.cardView != nil && self.forChange && self.summaryVC != nil {
                self.cardView.removeFromSuperview()
                self.summaryVC.answerIsSetForCard(self.cardView.vCard, result: nil)
            }else {
                
            }
        }
    }
}
