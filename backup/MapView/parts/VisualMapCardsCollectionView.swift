//
//  VisualMapCardsCollectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/11.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

let visualMapCardCellID = "visual map card cell identifier"
class VisualMapCardCell: UICollectionViewCell {
    fileprivate let titleLabel = UILabel()
    fileprivate var optionsView = VisualMapOptionsView.createWithFrame(CGRect.zero, card: CardInfoObjModel())
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: UIFontWeightMedium)
        titleLabel.textAlignment = .center
        
        // add
        contentView.addSubview(titleLabel)
        contentView.addSubview(optionsView)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let labelHeight = bounds.height * 0.2
        titleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: labelHeight)
        optionsView.frame = CGRect(x: 0, y: labelHeight, width: bounds.width, height: bounds.height - labelHeight)
    }

    func configureWithCard(_ card: CardInfoObjModel)  {
        titleLabel.text = card.title
        optionsView.card = card
    }
}

// collection view
class VisualMapCardsCollectionView: UICollectionView, UICollectionViewDataSource {
    var cards = [String]() {
        didSet{
            reloadData()
        }
    }
    
    class func createWithFrame(_ frame: CGRect, cardKeys: [String]) -> VisualMapCardsCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = frame.size
        
        // create
        let cardsView = VisualMapCardsCollectionView(frame: frame, collectionViewLayout: layout)
        cardsView.backgroundColor = UIColor.clear
        
        cardsView.cards = cardKeys
        cardsView.register(VisualMapCardCell.self, forCellWithReuseIdentifier: visualMapCardCellID)
        cardsView.dataSource = cardsView
        
        return cardsView
    }
    
    // datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: visualMapCardCellID, for: indexPath) as! VisualMapCardCell
        let card = collection.getCard(cards[indexPath.item])!
        cell.configureWithCard(card)
        
        return cell
    }

}

