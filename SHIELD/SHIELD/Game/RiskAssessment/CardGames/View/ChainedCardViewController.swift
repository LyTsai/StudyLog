//
//  ChainedCardViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/21.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class ChainedCardViewController: UIViewController, CardActionProtocol {
//    var hostCardAction: (()->Void)?
    
    fileprivate var cardView: CardTemplateView!
    weak var hostCardCardView: CardTemplateView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.setBackgroundImage(ProjectImages.sharedImage.circleCrossDismiss, for: .normal)
        let length = 34 * fontFactor
        dismissButton.frame = CGRect(x: width - max(50 * fontFactor, width * 0.05), y: max(topLength, height * 0.08), width: length, height: length)
        
        view.addSubview(dismissButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // currentCard
        if cardView != nil {
            cardView.beginToShow()
        }
    }
    
    func loadWithCard(_ card: CardInfoObjModel, hostCard: CardInfoObjModel, hostItem: Int) {
        cardView = CardTemplateManager.sharedManager.createCardTemplateWithKey(card.cardStyleKey, frame: mainFrame.insetBy(dx: width * 0.05, dy: height * 0.1))
        cardView.hostCard = hostCard
        cardView.hostItem = hostItem
        
        if card.isJudgementCard() {
            cardView.addActions()
        }
        
        cardView.actionDelegate = self
        cardView.cardFrame = cardView.bounds.insetBy(dx: width * 0.05, dy: height * 0.03)
        cardView.setCardContent(card, defaultSelection: card.getDisplayOptions().first)
        cardView.setupCardBackAndStyles()
        
        let index = hostCard.getChainedAnswerIndex()
        cardView.setUIForSelection(index)
        view.addSubview(cardView)
    }
    
    func card(_ cardView: CardTemplateView, chooseItemAt item: Int) {
        let chosenMatch = cardView.vCard.getDisplayOptions()[item].matchKey
        cardView.hostCard.saveResult(chosenMatch, answerIndex: cardView.hostItem)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismissVC()
            self.hostCardCardView.actionDelegate.card?(self.hostCardCardView, chooseItemAt: self.cardView.hostItem)
        }
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true) {
            // card view
            if self.cardView != nil  {
                self.cardView.endShow()
                self.cardView.removeFromSuperview()
            }
        }
    }
}

