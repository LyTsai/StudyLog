//
//  CardAnswerChangeView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CardAnswerChangeView: UIView {
    weak var hostVC: UIViewController!
    
    class func createWithFrame(_ frame: CGRect, topHeight: CGFloat, card: CardInfoObjModel, mainColor: UIColor) -> CardAnswerChangeView {
        let view = CardAnswerChangeView(frame: frame)
        view.updateUIWithTop(topHeight)
        view.setupWithCard(card, mainColor: mainColor)
        
        return view
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate var cardOptionsCollectionView: CardOptionsCollectionView!
    fileprivate var card: CardInfoObjModel!
    
    // add subviews
    fileprivate func updateUIWithTop(_ top: CGFloat) {
        titleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: top)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: top * 0.4, weight: UIFontWeightSemibold)
        
        let topMask = CAShapeLayer()
        topMask.path = UIBezierPath(roundedRect: titleLabel.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        
        titleLabel.layer.mask = topMask
        addSubview(titleLabel)
        
        cardOptionsCollectionView = CardOptionsCollectionView.createWithFrame(CGRect(x: 0, y: top, width: bounds.width, height: bounds.height - top), cardOptions: [], chosenIndex: 0, mainColor: UIColor.white)
        cardOptionsCollectionView.cardAnswerViewDelegate = self
        addSubview(cardOptionsCollectionView)
    }
    
    // data set up
    func setupWithCard(_ card: CardInfoObjModel, mainColor: UIColor) {
        self.card = card
        titleLabel.text = card.metric?.name
        titleLabel.backgroundColor = mainColor
        
        // card options
        cardOptionsCollectionView.chosenIndex = card.currentSelection()
        if card.cardStyleKey == JudgementCardTemplateView.styleKey() {
            cardOptionsCollectionView.cardOptions = [card.cardOptions.first!, card.cardOptions.first!]
        }else {
            cardOptionsCollectionView.cardOptions = card.cardOptions
        }
        
        cardOptionsCollectionView.mainColor = mainColor
        cardOptionsCollectionView.reloadData()
    }
    
    func changeAnswerToIndex(_ answerIndex: Int) {
        // data
        card.saveResult(answerIndex)
        
        // UI
        if hostVC.isKind(of: SummaryViewController.self) {
            let host = hostVC as! SummaryViewController
            host.answerIsSetForCard(card, result: answerIndex)
        }else if hostVC.isKind(of: CartCardsViewController.self) {
            let host = hostVC as! CartCardsViewController
            host.answerIsSetForCard(card, result: answerIndex)
        }
       
    }
  
}
