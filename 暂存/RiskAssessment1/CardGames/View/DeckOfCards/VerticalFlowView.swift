//
//  VerticalFlowView.swift
//  ABook_iPhone_V1
//
//  Created by hui wang on 11/14/16.
//  Copyright © 2016 LyTsai. All rights reserved.
//

import Foundation
import UIKit

let VerticalFlowCellID = "VerticalFlowCellID"
class VerticalFlowCell: UICollectionViewCell {
    var cardIndex: Int = 0 {
        didSet {
            indexLabel.text = "\(cardIndex + 1)"
        }
    }
    
    fileprivate var indexLabel = UILabel()
    var singleCard = CardTemplateManager.sharedManager.createCardTemplateWithKey(CardTemplateManager.defaultCardStyleKey, frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        layer.cornerRadius = 8
        backgroundColor = UIColor.clear
        
        addSubview(singleCard)
        addSubview(indexLabel)
    }
    
    func setupCard(_ styleKey: String) {
        layoutSubviews()
        if singleCard.key() == styleKey { return }
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
        singleCard.confirmButton.isSelected = false
        singleCard.denyButton.isSelected = false
        
        indexLabel.text = ""
    }
}

class VerticalFlowView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, MetricDeckOfCardsViewProtocol {
    
    // card factory where to access all cards infromation
    let cardFactory = VDeckOfCardsFactory.metricDeckOfCards

    // adjustHeight --- if there are bars, some adjust maybe need (navi: 64)
    class func createViewWithFrame(_ frame: CGRect, interitemSpacing: CGFloat, lineSpacing: CGFloat, adjustHeight: CGFloat) -> VerticalFlowView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = interitemSpacing
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: lineSpacing, left: lineSpacing, bottom: lineSpacing, right: lineSpacing)
        flowLayout.itemSize = CGSize(width: (frame.width - 2 * interitemSpacing - 2 * lineSpacing) / 3, height: (frame.height - adjustHeight - 4 * lineSpacing) / 3)
        
        let collectionView = VerticalFlowView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.register(VerticalFlowCell.self, forCellWithReuseIdentifier: VerticalFlowCellID)
        
        collectionView.delegate = collectionView
        collectionView.dataSource = collectionView
        collectionView.backgroundColor = UIColor.clear
        
        return collectionView
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardFactory.totalNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let riskCell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalFlowCellID, for: indexPath) as! VerticalFlowCell
        configureCell(riskCell, atIndexPath: indexPath)
        
        return riskCell
    }
    
    fileprivate func configureCell(_ cell: VerticalFlowCell, atIndexPath indexPath: Foundation.IndexPath) {
        let item = indexPath.item
        cell.cardIndex = item
        cell.setupCard((cardFactory.getVCard(item)?.cardStyleKey)!)
        cell.singleCard.setCardContent(cardFactory.getVCard(item)!, defaultSelection: cardFactory.getCardOption(item))
    }
    
    func showDeckOfCards() {
        reloadData()
    }
}
