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
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: circleLayout)
        collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier)
        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.collectionView = collectionView
    }
    
    // dataSource
    
    // actions
    @IBAction func layoutChangeSegmentedControlDidChangeValue(sender: UISegmentedControl) {
    }
    
    @IBAction func addItem(sender: AnyObject) {
    }
    
    @IBAction func deleteItem(sender: AnyObject) {
    }
}

class CircleLayout: UICollectionViewLayout {
    
}

class FlowLayout: UICollectionViewFlowLayout {
    
}

class CollectionViewCell: UICollectionViewCell {
    
}