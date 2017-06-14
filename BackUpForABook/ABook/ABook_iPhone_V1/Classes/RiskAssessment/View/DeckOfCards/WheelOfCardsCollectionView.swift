//
//  WheelOfCardsCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by hui wang on 12/5/16.
//  Copyright © 2016 LyTsai. All rights reserved.
//

import Foundation

// ID for cell view
let wheelCellID = "Wheel"

// collection cell view class.  each cell is a CardTemplateView type view
class CardViewCell: UICollectionViewCell {
    // combine view with cell (add cardView as a subview)
    // load with JudgementView as default style via card manager factory
    
    var singleCard = CardTemplateView()
    var allset = false
    
    func setupCard(_ styleKey: String) {
        layoutSubviews()
        if (allset == true && singleCard.key() == styleKey) {
            // already loaded with corrected card
            return
        }
        backgroundColor = UIColor.clear
        singleCard.removeFromSuperview()
        singleCard = CardTemplateManager.sharedManager.createCardTemplateWithKey(styleKey, frame: CGRect.zero)
        singleCard.addActions()
        addSubview(singleCard)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        singleCard.frame = bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        singleCard.frame = CGRect.zero
        if singleCard.confirmButton != nil && singleCard.denyButton != nil {
            singleCard.confirmButton.isSelected = false
            singleCard.denyButton.isSelected = false
        }
    }
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }
}

// collection view based spinnig view for given array of metrics
// !!! each metric card VCardModel has one or more VOptionModel which maybe presented as one or more card views depends on the prefered template view type
class WheelOfCardsCollectionView: UICollectionView, MetricDeckOfCardsViewProtocol {
    // view host delegate
    weak var topDelegate: UIView!
    
    // card factory where to access all cards infromation
    let cardFactory = VDeckOfCardsFactory.metricDeckOfCards
    
    func showDeckOfCards() {
        reloadData()
        contentOffset = CGPoint.zero
    }
    
    class func createWheelCollectionView(_ frame: CGRect) -> WheelOfCardsCollectionView {
        let circularLayout = CircularCollectionViewLayout()
        
        if 0.8 * frame.width < circularLayout.itemSize.width {
            circularLayout.itemSize.width = CGFloat(Int(0.8 * frame.width)) + 1.0
        }
        if 0.8 * frame.height < circularLayout.itemSize.height {
            circularLayout.itemSize.height = CGFloat(Int(0.8 * frame.height)) + 1.0
        }
        
        let wheelCollectionView = WheelOfCardsCollectionView(frame: frame, collectionViewLayout: circularLayout)
        wheelCollectionView.register(CardViewCell.self, forCellWithReuseIdentifier: wheelCellID)
        
        wheelCollectionView.dataSource = wheelCollectionView
        wheelCollectionView.delegate = wheelCollectionView
        
        wheelCollectionView.backgroundColor = UIColor.clear
        wheelCollectionView.indicatorStyle = .white
        
        // make for a more native feel that is closer to the UIScrollView.
        wheelCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        return wheelCollectionView
    }
    
}

extension WheelOfCardsCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return the number of items in the given section
        return cardFactory.totalNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: wheelCellID, for: indexPath) as! CardViewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell: CardViewCell, atIndexPath indexPath: Foundation.IndexPath) {
        // set card content for presentation here
        // (1) source of risk metric deck of cards (for update user selection result)
        // (2) VCard - for general card information
        // (3) VOption - as default
        
        // make sure the template view embeded inside cell matches.  if not reset it
        // set it to the right card template view style
        if let card = cardFactory.getVCard(indexPath.item) {
            cell.setupCard(card.cardStyleKey!)
            // attache card content
            cell.singleCard.setCardContent(cardFactory.getVCard(indexPath.item)!, defaultSelection: cardFactory.getCardOption(indexPath.item))
            // build connection for getting back events
            cell.singleCard.hostView = self.topDelegate
        }
    }
}

