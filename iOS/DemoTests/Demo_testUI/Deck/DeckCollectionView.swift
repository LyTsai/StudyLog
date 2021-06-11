//
//  DeckCollectionView.swift
//  WholeSHIELD
//
//  Created by L on 2020/7/16.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation
class DeckCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // basic setup
    func setupBasic() {
        self.backgroundColor = UIColor.clear
        // layout
        let deck = DeckLayout()
        self.setCollectionViewLayout(deck, animated: true)
        
        register(DeckCell.self, forCellWithReuseIdentifier: deckCellID)
        
        // delegate
        self.dataSource = self
        self.delegate = self
    }

    
    func setupWithSize(_ aSize: CGSize) {
        let layout = collectionViewLayout as! DeckLayout
        layout.itemSize = aSize
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deckCellID, for: indexPath) as! DeckCell
        cell.configureWithModel()
        
        return cell
    }
}
