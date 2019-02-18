//
//  MatchedCardsRoadViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/9/1.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MatchedCards
class MatchedCardsRoadViewController: PlayingViewController {
    var matchedCardsRoadCollectionView: MatchedCardsRoadCollectionView!
    var cards = [MatchedCardsDisplayModel]()
    var colorPair = (UIColor.blue, UIColor.cyan)
    
    var cardAnswerView: CardAnswerChangeView!
    fileprivate var answerHeight: CGFloat {
        return 160 * height / 667
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.categoryBack
        view.addSubview(backImageView)
        
        // cards
        matchedCardsRoadCollectionView = MatchedCardsRoadCollectionView.createWithFrame(mainFrame, cards: cards, colorPair: colorPair)
        matchedCardsRoadCollectionView.hostVC = self
        
        view.addSubview(matchedCardsRoadCollectionView)
        
        // answer change
        cardAnswerView = CardAnswerChangeView.createWithFrame(CGRect(x: 0, y: height - answerHeight - 41, width: width, height: answerHeight), topHeight: answerHeight / 4, card: cards.first!.cardInfo, mainColor: colorPair.0)
        cardAnswerView.layer.cornerRadius = 8
//        cardAnswerView.layer.addBlackShadow(2)
        cardAnswerView.layer.masksToBounds = true
        cardAnswerView.transform = CGAffineTransform(translationX: 0, y: self.answerHeight)
        cardAnswerView.hostVC = self
        
        view.addSubview(cardAnswerView)
    }
    
    func showAnswerWithCard(_ card: CardInfoObjModel) {
        cardAnswerView.setupWithMatchedCard(card, mainColor: colorPair.0)
        UIView.animate(withDuration: 0.5) {
            self.cardAnswerView.transform = CGAffineTransform.identity
        }
    }
    
    func answerIsDeterminedForCard(_ card: MatchedCardsDisplayModel) {
        cards[matchedCardsRoadCollectionView.chosenIndex] = card
        matchedCardsRoadCollectionView.changeAnswerToCard(card)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseIn, animations: {
             self.cardAnswerView.transform = CGAffineTransform(translationX: 0, y: self.answerHeight)
        }, completion: nil)
    }
    
    override func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}
