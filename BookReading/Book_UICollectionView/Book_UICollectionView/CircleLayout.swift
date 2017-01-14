//
//  CircleLayout.swift
//  Book_UICollectionView
//
//  Created by iMac on 16/11/30.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit


class CircleAndFlowCollectionViewController: UICollectionViewController {
    var cellCount: Int = 12
    var circleLayout = CircleLayout()
    var flowLayout = FlowLayout()
    
    let CellIdentifier = "Cell Identifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: circleLayout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.collectionView = collectionView
    }
    
    // dataSource
    
    // actions
    @IBAction func layoutChangeSegmentedControlDidChangeValue(_ sender: UISegmentedControl) {
    }
    
    @IBAction func addItem(_ sender: AnyObject) {
    }
    
    @IBAction func deleteItem(_ sender: AnyObject) {
    }
}

class CircleLayout: UICollectionViewLayout {
    
}

class FlowLayout: UICollectionViewFlowLayout {
    
}

class CollectionViewCell: UICollectionViewCell {
    
}
