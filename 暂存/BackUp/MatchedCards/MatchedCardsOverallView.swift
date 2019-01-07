//
//  MatchedCardsOverallView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/14.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class MatchedCardsOverallCollectoinView: UICollectionView {
    weak var hostVC: MatchedCardsOverallViewController!
    
    var playedGames = [RiskObjModel]()
    var isEditing = false {
        didSet{
            if isEditing != oldValue {
                reloadData()
            }
        }
    }
    
    // factory method
    class func createWithFrame(_ frame: CGRect, playedGames: [RiskObjModel]) -> MatchedCardsOverallCollectoinView {
        
        // layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.headerReferenceSize = CGSize(width: 1, height: frame.height * 0.12)
        
        let margin = 20 * frame.width / 375
        let spacing = 2 * frame.width / 375
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: margin, right: margin)
        
        let itemWidth = (frame.width - 2 * margin - 2 * spacing) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.8)

        // create
        let collection = MatchedCardsOverallCollectoinView(frame: frame, collectionViewLayout: layout)
        collection.playedGames = playedGames
        collection.backgroundColor = UIColor.clear
        
        collection.register(PlayedGameCell.self, forCellWithReuseIdentifier: playedGameCellID)
        collection.register(PlayedGameHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: playedGameHeaderID)
        
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }

}

// dataSource
extension MatchedCardsOverallCollectoinView: UICollectionViewDataSource {
    // data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playedGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playedGameCellID, for: indexPath) as! PlayedGameCell
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    fileprivate func configureCell(_ cell: PlayedGameCell, indexPath: IndexPath) {
        let risk = playedGames[indexPath.item]
        //        let riskClass = risk.metric
        //            AIDMetricCardsCollection.standardCollection.getMatch(risk.metricKey!)
        
        cell.image = risk.imageObj
        cell.text = "\(risk.name ?? "") Risk Assessment"
        cell.mainColor = UIColorFromRGB(185, green: 235, blue: 135)
        cell.date = Date()
        cell.authorInfo = risk.author.displayName
        cell.riskName = risk.info
        cell.underEditing = isEditing
    }
    
    // header view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: playedGameHeaderID, for: indexPath) as! PlayedGameHeaderView
        header.hostCollection = self
        
        return header
    }
}


// delegate
extension MatchedCardsOverallCollectoinView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let risk = playedGames[indexPath.item]
        
        if hostVC != nil {
            if isEditing {
                // delete or not
                let alert = UIAlertController(title: nil, message: "Remove \"\(risk.name ?? "this game")\" \n in \(risk.info ?? "this Algorithm") ?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                    // TODO: -------- delete data on net
                    
                    // delete array
                    self.playedGames.remove(at: indexPath.item)
                    
                    // delete cell
                    self.performBatchUpdates({
                        self.deleteItems(at: [indexPath])
                    }, completion: nil)
                })
                
                alert.addAction(cancelAction)
                alert.addAction(removeAction)
                
                hostVC.present(alert, animated: true, completion: nil)
                
            }else {
                hostVC.goToSelectedMatchedCards(risk)
            }
        }
    }
}
