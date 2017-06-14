//
//  AddAndChooseCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/16.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class AddAndChooseCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var options = [(UIImage, String)]() {
        didSet{
            reloadData()
        }
    }
    
    var needAdd = true {
        didSet{
            if needAdd != oldValue {
                reloadData()
            }
        }
    }
    
    weak var hostCell: UserInfoRelationshipCell!
    // let relationships = ["grandfather", "grandmother", "father", "mother", "boyfriend", "girlfriend"]
    let relationships = ["Elder Generation", "Younger Generation", "Relative", "Friend"]
    let imageNames = ["grandfather", "girlfriend", "father", "mother"]
    var relationship: String! {
        if chosenItem == -1 {
            return nil
        }
        return options[chosenItem].1
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        var tempOptions = [(UIImage, String)]()
        for (i, relationship) in relationships.enumerated() {
            let image = UIImage(named: "relationship_\(imageNames[i])")
            tempOptions.append((image!, relationship))
        }
        
        register(AddAndChooseCell.self, forCellWithReuseIdentifier: addAndChooseCellID)
        dataSource = self
        delegate = self
        
        options = tempOptions
    }
    
    class func createWithFrame(_ frame: CGRect, options: [(UIImage, String)], needAdd: Bool) -> AddAndChooseCollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets.zero
        
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        let estiLength = (frame.width - 5 * 3) / 4
        flowLayout.itemSize = CGSize(width: estiLength, height: estiLength)
        
        let collection = AddAndChooseCollectionView(frame: frame, collectionViewLayout: flowLayout)
        collection.register(AddAndChooseCell.self, forCellWithReuseIdentifier: addAndChooseCellID)
        collection.options = options
        collection.needAdd = needAdd
        
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return needAdd ? 1 + options.count : options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addAndChooseCellID, for: indexPath) as! AddAndChooseCell
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    fileprivate func configureCell(_ cell: AddAndChooseCell, atIndexPath indexPath: Foundation.IndexPath) {
        if indexPath.row == options.count && needAdd == true {
            // last one
            cell.text = ""
            cell.image = UIImage(named: "avatar_add")
            cell.isLast = true
        }else {
            let option = options[indexPath.row]
            cell.text = option.1
            cell.image = option.0
            cell.isChosen = false
            cell.isLast = false
            
            if indexPath.row == chosenItem {
                cell.isChosen = true
            }
        }
    }
    
    // delegate
    fileprivate var chosenItem: Int = -1 {
        didSet {
            if chosenItem != oldValue {
                hostCell.changeState()
                UIView.performWithoutAnimation {
                    if chosenItem == -1 {
                        performBatchUpdates({
                            self.reloadItems(at: [IndexPath(item: oldValue, section: 0)])
                        }, completion: nil)
                    }else if oldValue == -1 {
                        performBatchUpdates({
                            self.reloadItems(at: [IndexPath(item: self.chosenItem, section: 0)])
                        }, completion: nil)
                    }else {
                        performBatchUpdates({
                            self.reloadItems(at: [IndexPath(item: oldValue, section: 0), IndexPath(item: self.chosenItem, section: 0)])
                        }, completion: nil)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == options.count && needAdd == true{
            chosenItem = -1
            // add new
            addRelationship()
        }else {
            // choose
            chosenItem = indexPath.item
        }
    }
    
    fileprivate func addRelationship() {
        
        print("add more relationship")
    }
    
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.itemSize = CGSize(width: (bounds.width - 3 * 5) / 4 , height: (bounds.height - 2) * 0.5)
    }
}
