//
//  MatchedCardsRisksReviewViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/24.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class MatchedCardsRisksReviewViewController: UIViewController {
    fileprivate var cardsDisplayView: MatchedCardDisplayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.setBackgroundImage(ProjectImages.sharedImage.circleCrossDismiss, for: .normal)
        let length = 34 * fontFactor
        let marginX = length * 1.4
        dismissButton.frame = CGRect(x: width - marginX, y: topLength - 44, width: length, height: length)
        
        view.addSubview(dismissButton)
        
        cardsDisplayView = MatchedCardDisplayView(frame:(CGRect(x: 0, y: dismissButton.frame.maxY, width: width, height: height - bottomLength - dismissButton.frame.maxY).insetBy(dx: 8 * standWP, dy: 5 * standHP)))
        cardsDisplayView.reloadWithCards(cards, riskTypeKey: riskTypeKey)
        view.addSubview(cardsDisplayView)
    }
    
    fileprivate var cards = [CardInfoObjModel]()
    fileprivate var riskTypeKey: String!
    func loadWithCards(_ cards: [CardInfoObjModel], riskTypeKey: String) {
        self.cards = cards
        self.riskTypeKey = riskTypeKey
        if cardsDisplayView != nil {
            cardsDisplayView.reloadWithCards(cards, riskTypeKey: riskTypeKey)
        }
    }
    
    func endCardDisplay() {
        if cardsDisplayView != nil {
            if cardsDisplayView.cardsCollectionView != nil {
                cardsDisplayView.cardsCollectionView.endCurrentCard()
            }
        }
    }
    
    @objc func dismissVC()  {
        endCardDisplay()
        dismiss(animated: true, completion: nil)
    }
}
