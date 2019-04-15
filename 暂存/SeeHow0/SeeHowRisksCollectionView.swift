//
//  SeeHowRisksCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/30.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class SeeHowRisksCollectionView: UICollectionView {
    weak var hostVC: SeeHowViewController!
    fileprivate var forUser = UserCenter.sharedCenter.currentGameTargetUser.Key()
    fileprivate var playedGames = [RiskObjModel]()
    var isEditing = false {
        didSet{
            if isEditing != oldValue {
                reloadData()
            }
        }
    }
    
    // factory method
    class func createWithFrame(_ frame: CGRect, playedGames: [RiskObjModel]) -> SeeHowRisksCollectionView {
        
        // layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.headerReferenceSize = CGSize(width: 1, height: frame.height * 0.1)
        
        let margin = 20 * frame.width / 375
        let spacing = 2 * frame.width / 375
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: margin, right: margin)
        
        let itemWidth = (frame.width - 2 * margin - 2 * spacing) / 3
        let itemHeight = (frame.height * 0.9 - margin - 2 * spacing) / 3
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        // create
        let collection =  SeeHowRisksCollectionView(frame: frame, collectionViewLayout: layout)
        collection.playedGames = playedGames
        collection.backgroundColor = UIColor.clear
        
        // data source
        collection.register(PlayedGameCell.self, forCellWithReuseIdentifier: playedGameCellID)
        collection.register(PlayedGameHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: playedGameHeaderID)
        
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    func reloadDataOfUser(_ userKey: String) {
        playedGames = MatchedCardsDisplayModel.getRisksPlayedByUser(userKey)
        forUser = userKey
        reloadData()
    }
    
}

// dataSource
extension SeeHowRisksCollectionView: UICollectionViewDataSource {
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

        cell.imageUrl = risk.imageUrl
        cell.text = "\(risk.name ?? "") Assessment"
        cell.mainColor = colorPairs[indexPath.item % colorPairs.count].border
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
extension SeeHowRisksCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let risk = playedGames[indexPath.item]
        
        if hostVC != nil {
            if isEditing {
                // delete or not
                let alert = UIAlertController(title: nil, message: "Remove \"\(risk.name ?? "this game")\" \n in \(risk.info ?? "this Algorithm") ?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                    
                    // delete array
                    self.playedGames.remove(at: indexPath.item)
                    CardSelectionResults.cachedCardProcessingResults.clearAnswerForUser(self.forUser, riskKey: risk.key)
                    // TODO: -------- delete data on net
                    
                    // delete cell
                    self.performBatchUpdates({
                        self.deleteItems(at: [indexPath])
                    }, completion: nil)
                })
                
                alert.addAction(cancelAction)
                alert.addAction(removeAction)
                
                hostVC.present(alert, animated: true, completion: nil)
                
            }else {
                goToSelectedMathchedCards(risk)
            }
        }
    }
    
    fileprivate func goToSelectedMathchedCards(_ risk: RiskObjModel) {
        let cards = MatchedCardsDisplayModel.getMatchedCardForRisk(risk.key, ofUser: forUser)
        let seeHowCardsVC = SeeHowCardsViewController()
        seeHowCardsVC.matchedCards = cards
        if hostVC != nil {
            hostVC.navigationController?.pushViewController(seeHowCardsVC, animated: true)
        }
    }
}
