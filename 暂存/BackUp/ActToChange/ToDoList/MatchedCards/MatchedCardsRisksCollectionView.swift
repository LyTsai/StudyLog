//
//  MatchedCardsRisksCollectionView.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/1/18.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class MatchedCardsRisksCollectionView: UICollectionView, UICollectionViewDataSource {
    var risks = [RiskObjModel]() {
        didSet{
            reloadData()
        }
    }
    
    var textColor = UIColor.white
    class func createWithFrame(_ frame: CGRect) -> MatchedCardsRisksCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize(width: frame.width * 0.48, height: frame.height)
        layout.minimumLineSpacing = frame.width * 0.02
        layout.minimumInteritemSpacing = 1000
        
        // create
        let collection = MatchedCardsRisksCollectionView(frame: frame, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        collection.register(CardOptionCell.self, forCellWithReuseIdentifier: cardOptionCellID)
        collection.dataSource = collection
        return collection
    }
    
    // MARK: ---------- dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return risks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardOptionCellID, for: indexPath) as! CardOptionCell
        cell.ratio = 0.8
        cell.horizontal = true
        cell.mainColor = UIColor.clear
        cell.imageUrl = risks[indexPath.item].imageUrl
        cell.text = risks[indexPath.item].name
        cell.textView.textColor = textColor
        cell.isChosen = false
        
        return cell
    }
}
