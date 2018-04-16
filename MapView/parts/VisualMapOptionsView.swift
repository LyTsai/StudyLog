//
//  VisualMapOptionsView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/11.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

// cell
let visualMapOptionCellID = "visualMap Option Cell Identifier"
class VisualMapOptionCell: UICollectionViewCell {
    var isChosen = false {
        didSet{
            // checkmark and shadow
            checkImageView.isHidden = !isChosen
            alpha = isChosen ? 1 : 0.6
            layer.shadowColor = isChosen ? UIColor.black.cgColor : UIColor.clear.cgColor
        }
    }
    
    // common
    fileprivate let backView = UIView()
    fileprivate let imageView = UIImageView()
    fileprivate let checkImageView = UIImageView(image: #imageLiteral(resourceName: "fullCheck"))
    fileprivate let textLabel = UILabel()
    fileprivate let labelBack = UIView()
    
    // data
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate func updateUI() {
        backgroundColor = UIColor.clear
        backView.backgroundColor = UIColor.white
        
        imageView.contentMode = .scaleAspectFit
        
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        
        
        // add
        contentView.addSubview(backView)
        backView.addSubview(imageView)
        backView.addSubview(labelBack)
        backView.addSubview(textLabel)
        backView.addSubview(checkImageView)
        
        backView.layer.masksToBounds = true
        
        // layer
        backView.layer.cornerRadius = 8 * fontFactor
        backView.layer.borderWidth = fontFactor
        layer.addBlackShadow(2 * fontFactor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backView.frame = bounds
        
        let xMargin = bounds.width * 0.05
        imageView.frame = CGRect(x: xMargin, y: xMargin, width: bounds.width - 2 * xMargin, height: bounds.height - 3 * xMargin)
        let markLength = bounds.width * 0.2
        checkImageView.frame = CGRect(x: bounds.width - xMargin - markLength , y: xMargin, width: markLength, height: markLength)
        
        // textlabel
        let textHeight = bounds.height * 0.3
        textLabel.font = UIFont.systemFont(ofSize: 9 * fontFactor, weight: UIFontWeightBold)
        textLabel.frame = CGRect(x: xMargin, y: bounds.height - textHeight - xMargin, width: bounds.width - 2 * xMargin, height: textHeight)
        labelBack.frame = CGRect(x: 0, y: bounds.height - textHeight - 2 * xMargin, width: bounds.width, height: textHeight + 2 * xMargin)

    }
    
    func configureCellWithText(_ text: String!, imageUrl: URL!, chosen: Bool, color: UIColor) {
        imageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.placeHolder, options: .refreshCached, completed: nil)
        backView.layer.borderColor = color.cgColor
        labelBack.backgroundColor = color.withAlphaComponent(0.7)
        textLabel.text = text
        isChosen = chosen
    }
}

// collection view of one card
class VisualMapOptionsView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var card: CardInfoObjModel! {
        didSet{
            reloadData()
        }
    }
    class func createWithFrame(_ frame: CGRect, card: CardInfoObjModel) -> VisualMapOptionsView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 1000
        
        // create
        let optionsView = VisualMapOptionsView(frame: frame, collectionViewLayout: layout)
        
        optionsView.backgroundColor = UIColor.clear
        optionsView.card = card
        optionsView.register(VisualMapOptionCell.self, forCellWithReuseIdentifier: visualMapOptionCellID)
        
        optionsView.dataSource = optionsView
        optionsView.delegate = optionsView
        
        return optionsView
    }
    
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return card.cardOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: visualMapOptionCellID, for: indexPath) as! VisualMapOptionCell
        let match = card.cardOptions[indexPath.item].match
        cell.configureCellWithText(match?.statement, imageUrl: match?.imageUrl, chosen: card.currentSelection() == indexPath.item, color: match?.classification?.realColor ?? tabTintGreen)
        
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gap = bounds.width * 0.015
        let itemSize = CGSize(width: (bounds.width - gap * CGFloat(card.cardOptions.count + 1)) / CGFloat(card.cardOptions.count), height: bounds.height - gap * 1.5)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = gap
        layout.sectionInset = UIEdgeInsets(top: 0.5 * gap, left: gap, bottom: gap, right: gap)
        layout.itemSize = itemSize
        
        return itemSize
    }
}
