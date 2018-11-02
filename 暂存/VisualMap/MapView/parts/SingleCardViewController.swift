//
//  SingleCardViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/17.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class SingleCardViewController: UIViewController, CardActionProtocol {
    var card: CardInfoObjModel!
    var indexPath: IndexPath!
    weak var presentFrom: UICollectionView!
    
    fileprivate var oldItem: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.setBackgroundImage(ProjectImages.sharedImage.circleCrossDismiss, for: .normal)
        dismissButton.frame = CGRect(x: width - 44 * fontFactor, y: 40, width: 34 * fontFactor, height: 34 * fontFactor)
        
        view.addSubview(dismissButton)
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let cardViewFrame = mainFrame.insetBy(dx: 10 * standHP, dy: 40 * standHP)
        let cardView = CardTemplateManager.sharedManager.createCardTemplateWithKey(card.cardStyleKey, frame: cardViewFrame)
        view.addSubview(cardView)
        
        oldItem = card.currentSelection()
        cardView.cardFrame = cardViewFrame.insetBy(dx: cardViewFrame.width * 0.04, dy: cardViewFrame.height * 0.02)
        cardView.actionDelegate = self
        
        // data
        cardView.setCardContent(card, defaultSelection: card.cardOptions.first)
        cardView.setupCardBackAndStyles()
        cardView.setupCardAnswerUI()
    }
    
    func card(_ cardView: CardTemplateView, chooseItemAt item: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismissVC()
        }

    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true) {
            if self.oldItem == nil || self.oldItem != self.card.currentSelection() {
                // changed
                self.presentFrom.performBatchUpdates({
//                    if self.presentFrom.isKind(of: VisualMapCardsCollectionView.self) {
//                        let present = self.presentFrom as! VisualMapCardsCollectionView
//                        self.presentFrom.reloadData()
//                        present.scoreChanged()
//                        // change score card's display
//
//                    }else {
                        self.presentFrom.reloadItems(at: [self.indexPath])
//                    }
                }, completion: nil)
            }
        }
    }
    
}
