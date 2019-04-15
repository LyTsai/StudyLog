//
//  CardOptionsCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/9/1.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MARK: -------------- cell ------------------------
let cardOptionCellID = "card option Cell Identifier"
class CardOptionCell: ImageAndTextCell {
    var mainColor = UIColor.blue {
        didSet{
            backLayer.strokeColor = mainColor.cgColor
        }
    }
    
    var isChosen = false {
        didSet{
            backLayer.shadowColor = isChosen ? UIColor.black.cgColor : UIColor.clear.cgColor
            maskCheckView.isHidden = !isChosen
        }
    }
    
    fileprivate let maskCheckView = UIImageView(image: UIImage(named: "card_maskCheck"))
    override func updateUI() {
        super.updateUI()
        
        backLayer.fillColor = UIColor.white.cgColor
        backLayer.strokeColor = mainColor.cgColor
        backLayer.addBlackShadow(2)
        
        contentView.addSubview(maskCheckView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let backLength = min(bounds.width * 0.5, bounds.height * 0.6)
        let borderWidth = 2 * backLength / 65
        // image and back
        let topFrame = CGRect(center: CGPoint(x: bounds.midX, y: backLength * 0.5 + 2 * borderWidth), length: backLength)
        // larger
        maskCheckView.frame = topFrame.insetBy(dx: -borderWidth, dy: -borderWidth)
        
        backLayer.lineWidth = borderWidth
        backLayer.path = UIBezierPath(roundedRect: topFrame, cornerRadius: 3 * borderWidth).cgPath
        imageView.frame = topFrame.insetBy(dx: borderWidth * 1.5, dy: borderWidth * 1.5)
        
        // text
        let labelHeight = bounds.height - backLength - borderWidth * 3
        textLabel.frame = CGRect(x: 0, y: bounds.height - labelHeight, width: bounds.width, height: labelHeight)
        textLabel.font = UIFont.systemFont(ofSize: labelHeight * 0.28, weight: UIFontWeightBold)
    }
}


// MARK: --------------- collection view ---------------------------
class CardOptionsCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var cardAnswerViewDelegate: CardAnswerChangeView!
    var cardOptions = [CardOptionObjModel]()
    var chosenIndex: Int!
    var mainColor = UIColor.blue
    
    class func createWithFrame(_ frame: CGRect, cardOptions: [CardOptionObjModel], chosenIndex: Int, mainColor: UIColor) -> CardOptionsCollectionView {
        
        // layout
        let margin = frame.width / 375 * 10
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = frame.height
        layout.minimumLineSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: margin * 0.5, left: margin, bottom: margin, right: margin)
        
        // create
        let collection = CardOptionsCollectionView(frame: frame, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.white
    
        collection.cardOptions = cardOptions
        collection.chosenIndex = chosenIndex
        
        collection.register(CardOptionCell.self, forCellWithReuseIdentifier: cardOptionCellID)
        
        // delegate
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    // data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardOptionCellID, for: indexPath) as! CardOptionCell
        let option = cardOptions[indexPath.item]
        cell.imageUrl = option.match?.imageUrl
        cell.text = option.match?.name
        cell.mainColor = mainColor
        if chosenIndex != nil {
            cell.isChosen = (indexPath.item == chosenIndex)
        }else {
            cell.isChosen = false
        }
        
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if chosenIndex == nil {
            chosenIndex = indexPath.item
            performBatchUpdates({
                self.reloadItems(at: [indexPath])
            }, completion: nil)
        }else if indexPath.item != chosenIndex {
            let oldValue = chosenIndex
            chosenIndex = indexPath.item
            
            performBatchUpdates({
                self.reloadItems(at: [IndexPath(item: oldValue!, section: 0), indexPath])
            }, completion: nil)
        }
        
        cardAnswerViewDelegate.changeAnswerToIndex(chosenIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = bounds.width / 375 * 10
        let number = CGFloat(max(min(cardOptions.count, 3), 1))
        
        return CGSize(width: (bounds.width - number * margin - margin) / number, height: (bounds.height - 1.5 * margin))
    }
    
}
