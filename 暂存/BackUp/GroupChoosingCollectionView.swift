//
//  GroupChoosingCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/28.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// cell
let groupChoosingCellID = "group choosing cell identifier"
class GroupChoosingCell: ImageAndTextCell {
    var isChosen = false {
        didSet{
            backLayer.strokeColor = isChosen ? chosenColor.cgColor : textTintGray.cgColor
            textLabel.textColor = isChosen ? chosenColor : UIColor.black
        }
    }
    
    fileprivate let chosenColor = UIColorFromRGB(80, green: 211, blue: 135)
    // init
    override func updateUI() {
        super.updateUI()
        
        backLayer.strokeColor = textTintGray.cgColor
        backLayer.fillColor = UIColor.clear.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let labelHeight = bounds.height * 0.18
        let imageMargin = bounds.width * 0.1
        let borderWidth = 2 * bounds.height / (133 - 8 * 2)
        // image and back
        let topFrame = CGRect(x: imageMargin, y: 0, width: bounds.width - 2 * imageMargin, height: bounds.height - labelHeight)
        backLayer.lineWidth = borderWidth
        backLayer.path = UIBezierPath(roundedRect: topFrame, cornerRadius: 3 * borderWidth).cgPath
        
        imageView.frame = topFrame.insetBy(dx: borderWidth * 1.5, dy: borderWidth * 1.5)
       
        // text
        textLabel.frame = CGRect(x: 0, y: bounds.height - labelHeight, width: bounds.width, height: labelHeight)
        textLabel.font = UIFont.systemFont(ofSize: labelHeight * 0.6, weight: UIFontWeightBold)
    }
}

// MARK: ---------- collection view -----------------
class GroupChoosingCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    weak var groupChoosingView: GroupChoosingView!
    
    var choices = [(UIImage, String)]()
    var chosenIndex = -1
    
    class func createWithFrame(_ frame: CGRect, choices: [(UIImage, String)]) -> GroupChoosingCollectionView {
        let hMargin = 15 * frame.width / 375
        let vMargin = 8 * frame.height / 133
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 100
        layout.minimumLineSpacing = hMargin
        layout.sectionInset = UIEdgeInsets(top: vMargin, left:  hMargin, bottom: vMargin, right: hMargin)
        layout.itemSize = CGSize(width: (frame.width - 3 * hMargin) * 0.5, height: frame.height - 2 * vMargin)
        
        // create
        let collection = GroupChoosingCollectionView(frame: frame, collectionViewLayout: layout)
        collection.choices = choices
        
        collection.register(GroupChoosingCell.self, forCellWithReuseIdentifier: groupChoosingCellID)
        
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    // data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: groupChoosingCellID, for: indexPath) as! GroupChoosingCell
        let choice = choices[indexPath.item]
        cell.image = choice.0
        cell.text = choice.1
        cell.isChosen = indexPath.item == chosenIndex ? true : false
        
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenIndex = indexPath.item
        performBatchUpdates({
            self.reloadItems(at: [indexPath])
        }) { (true) in
            if self.groupChoosingView != nil {
                self.groupChoosingView.choose(self.choices[indexPath.item])
            }
        }
    }
}
