//
//  MatchedCardsDetailView.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/1/18.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class MatchedCardsDetailView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    weak var hostVC: UIViewController!
    
    var idenCards = [(color: UIColor, cards: [CardInfoObjModel])]() {
        didSet{
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBasic()
    }
    
    fileprivate func setupLayout() {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 1000
        
        let top = bounds.height * 0.1
        let length = min(bounds.width * 0.3, bounds.height - 2 * top)
        let spacing = (bounds.width - 4 * length) / 5
        
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: top, left: 0, bottom: top, right: 0)
        
        layout.itemSize = CGSize(width: length + spacing, height: length)
    }
    
    fileprivate func setupBasic() {
        backgroundColor = UIColor.clear
        showsHorizontalScrollIndicator = false
        
        // dataSource
        register(CardOptionCell.self, forCellWithReuseIdentifier: cardOptionCellID)
        dataSource = self
        delegate = self
    }
    
    // layout
    // layout adjust
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setupLayout()
    }

    // dataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return idenCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return idenCards[section].cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardOptionCellID, for: indexPath) as! CardOptionCell
        cell.ratio = 1
        cell.isChosen = false
        cell.mainColor = idenCards[indexPath.section].color
       
        let card = idenCards[indexPath.section].cards[indexPath.item]
        cell.imageUrl = card.currentImageUrl()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = idenCards[indexPath.section].cards[indexPath.item]
        let cardChange = CardAnswerChangeViewController()
        cardChange.forChange = false
        cardChange.modalPresentationStyle = .overCurrentContext
        cardChange.loadWithCard(card)
        
        performBatchUpdates({
            self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }) { (true) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                self.hostVC.present(cardChange, animated: true, completion: nil)
            })
        }
    }
}
