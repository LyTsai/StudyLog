//
//  ScrollHeaderCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/11/16.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// MARK: ----------------- header collection cell --------------------
// text only
let headerCellID = "header cell Identifier"
class HeaderCollectionViewCell: UICollectionViewCell {
    var text = "" {
        didSet{ textLabel.text = text }
    }
    
    var isChosen = false {
        didSet{
            if isChosen != oldValue {
                textLabel.textColor = (isChosen ? UIColor.black : UIColorGray(155))
                chosenLayer.isHidden = !isChosen
                shadowLayer.strokeColor = (isChosen ? UIColorFromRGB(108, green: 81, blue: 27).cgColor : nil)
                layoutSubviews()
            }
        }
    }
    
    fileprivate let textLabel = UILabel()
    fileprivate let chosenLayer = CAGradientLayer()
    fileprivate let chosenMask = CAShapeLayer()
    fileprivate let shadowLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate func updateUI() {
        // shadow
        shadowLayer.shadowOffset = CGSize(width: 0, height: 1)
        shadowLayer.shadowRadius = 2
        shadowLayer.shadowOpacity = 0.9
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.lineWidth = 3
        
        // gradient
        chosenLayer.colors = [UIColorFromRGB(184, green: 236, blue: 81).cgColor, UIColorFromRGB(66, green: 147, blue: 33).cgColor]
        chosenLayer.locations = [0.2, 0.8]
        chosenLayer.startPoint = CGPoint(x: 0, y: 0)
        chosenLayer.endPoint = CGPoint(x: 0, y: 1)
        chosenLayer.isHidden = true
        
        // mask for
        chosenMask.strokeColor = UIColor.red.cgColor
        
        
        // text
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColorGray(155)
        
        // add
        contentView.layer.addSublayer(shadowLayer)
        contentView.layer.addSublayer(chosenLayer)
        contentView.addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let mainHeight =  bounds.height * 0.8
        let mainFrame = CGRect(x: 0, y: 0, width: bounds.width, height: mainHeight)
        let path = UIBezierPath(roundedRect: mainFrame, cornerRadius: 4)
        
        if isChosen {
            let offsetX = bounds.height * 0.2
            path.move(to: CGPoint(x: bounds.midX - offsetX, y: mainHeight))
            path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
            path.addLine(to:  CGPoint(x: bounds.midX + offsetX, y: mainHeight))
           
            chosenLayer.frame = bounds
            chosenMask.path = path.cgPath
            chosenLayer.mask = chosenMask
        }
        
        shadowLayer.path = path.cgPath
        shadowLayer.shadowPath = path.cgPath

        let gap = bounds.height * 0.03
        let labelHeight = mainFrame.height * 0.95
        textLabel.frame = CGRect(x: 4, y: gap, width: bounds.width - 8, height: labelHeight)
        textLabel.font = UIFont.systemFont(ofSize: labelHeight * 0.3, weight: UIFontWeightSemibold)
    }
}

// MARK: ------------ ScrollHeaderCollectionView  ----------------
/** cellWidth / bounds.width */
class ScrollHeaderCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    // delegate
    weak var matchedViewDelegate: MatchedCardsDisplayView!
    
    // texts on cells
    var textsOnShow = [String]() {
        didSet {
            if textsOnShow != oldValue {
                chosenItem = 0
                reloadData()
            }
        }
    }
    
    var chosenItem: Int = 0 {
        didSet {
            if chosenItem != oldValue {
                performBatchUpdates({
                    self.reloadItems(at: [IndexPath(item: oldValue, section: 0), IndexPath(item: self.chosenItem, section: 0)])
                    self.scrollToItem(at: IndexPath(item: self.chosenItem, section: 0), at: .centeredHorizontally, animated: true)
                }, completion: nil)
            }
        }
    }
    
    // create
    class func createHeaderWithFrame(_ frame: CGRect, textsOnShow: [String]) -> ScrollHeaderCollectionView {
        let lineSpacing: CGFloat = 6
        let vMargin: CGFloat = 4
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.minimumInteritemSpacing = 100
        let itemSize = CGSize(width: (frame.width - 2 * lineSpacing - 2 * vMargin) / 3, height: frame.height - 3 * vMargin)
        flowLayout.itemSize = itemSize
        flowLayout.sectionInset = UIEdgeInsets(top: vMargin, left: 2 * vMargin + itemSize.width, bottom: 2 * vMargin, right: 2 * vMargin + itemSize.width)
        
        // create
        let headerCollectionView = ScrollHeaderCollectionView(frame: frame, collectionViewLayout: flowLayout)
        headerCollectionView.textsOnShow = textsOnShow
        headerCollectionView.backgroundColor = UIColor.clear
        
        headerCollectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: headerCellID)
        
        headerCollectionView.dataSource = headerCollectionView
        headerCollectionView.delegate = headerCollectionView

        return headerCollectionView
    }
    
    // MARK: --------- dataSource -----------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textsOnShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellID, for: indexPath) as! HeaderCollectionViewCell
        configureCell(cell, forIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: HeaderCollectionViewCell, forIndexPath indexPath: Foundation.IndexPath) {
        cell.isChosen = false
        cell.text = textsOnShow[indexPath.item]
        
        if indexPath.item == chosenItem {
            cell.isChosen = true
        }
    }

    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenItem = indexPath.item
        if matchedViewDelegate != nil {
            matchedViewDelegate.currentIndex = chosenItem
        }
    }

}
