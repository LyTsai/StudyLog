//
//  PageControlAssessment.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/11/15.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// 1. use collectionView to indicate the pages
// 2. the read cells as processed, set different properties to the color/ border
// 3. the label is below, can use as the second section(or footer, if scroll direction is set as vertical)

let IndicatorCellID = "Indicator Cell ID"
let footerID = "Situation Footer ID"
let borderWidth: CGFloat = 1.2
let shadowRadius: CGFloat = 2

struct Dot {
    var dotGap: CGFloat = 2
    var dotDiameter: CGFloat = 8
}

class IndicatorCell: UICollectionViewCell {
    
    // colors
    fileprivate let processedColor = UIColor.white.cgColor
    fileprivate let unprocessedColor = UIColor.clear.cgColor
//        UIColor(red: 206/255.0, green: 206/255.0, blue: 206/255.0, alpha: 1).cgColor
    fileprivate let borderColor = UIColor(red: 193/255.0, green: 239/255.0, blue: 172/255.0, alpha: 1).cgColor
    fileprivate let clearColor = UIColor.clear.cgColor

    var processed = true {
        didSet {
            dotLayer.fillColor = (processed ? processedColor : unprocessedColor)
            dotLayer.strokeColor = (processed ? borderColor : processedColor)
        }
    }
    
    var current = false {
        didSet{
            if current == true {
                dotLayer.fillColor = processedColor
                dotLayer.shadowColor = borderColor
                dotLayer.strokeColor = borderColor
            }else {
                dotLayer.shadowColor = clearColor
            }
        }
    }

    //-----init------
    fileprivate var dotView = UIView() // layer also works
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addLayers()
    }
    
    let dotLayer = CAShapeLayer()
    fileprivate func addLayers(){
        backgroundColor = UIColor.clear
        
        dotLayer.lineWidth = borderWidth
        dotLayer.strokeColor = borderColor
        dotLayer.shadowRadius = shadowRadius
        dotLayer.shadowOffset = CGSize.zero
        dotLayer.shadowOpacity = 1

        layer.addSublayer(dotLayer)
    }
    
    override func layoutSubviews() {
        dotLayer.frame = bounds
        let offset = borderWidth + shadowRadius
        let path = UIBezierPath(ovalIn: bounds.insetBy(dx: offset, dy: offset)).cgPath
        dotLayer.path = path
        dotLayer.shadowPath = path
    }
    
}

class SituationFooter: UICollectionReusableView {
    var situation: String = "This is a test footer" {
        didSet{ label.text = situation  }
    }
    
    fileprivate var label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        addSubview(label)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
        label.font = UIFont.boldSystemFont(ofSize: bounds.height * 0.9)
    }
}

class PageIndicatorCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // dataSource
    var currentIndex: Int = 0 {
        didSet{
            if currentIndex != oldValue {
                UIView.performWithoutAnimation {
                    performBatchUpdates({
                        self.reloadItems(at: [IndexPath(item: oldValue, section: 0), IndexPath(item: self.currentIndex, section: 0)])
                    }, completion: nil)
                    
                }
            }
        
        }
        // TODO: -------- or just update the cell and last cell, if click is not allowed, just in sequence
        // if all shown, lastCurrentIndex to currentIndex
    }
    
    var totalNumber: Int = 1 {
        didSet{ reloadData() }
    }
    
    fileprivate var dot: Dot = Dot()
    class func createPageIndicatorWithFrame(_ frame: CGRect, dot: Dot) -> PageIndicatorCollectionView {
        let cellWidth = dot.dotDiameter + 2 * (borderWidth + shadowRadius)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = dot.dotGap
        flowLayout.scrollDirection = .vertical
        flowLayout.footerReferenceSize = CGSize(width: 200, height: min(cellWidth, frame.height - cellWidth - dot.dotDiameter * 0.2))
        
        let indicator = PageIndicatorCollectionView(frame: frame, collectionViewLayout: flowLayout)
        indicator.dataSource = indicator
        indicator.delegate = indicator
        
        indicator.dot = dot
        indicator.backgroundColor = UIColor.clear
        indicator.currentIndex = 0
        
        indicator.register(IndicatorCell.self, forCellWithReuseIdentifier: IndicatorCellID)
        indicator.register(SituationFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerID)
        
        return indicator
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dotCell = collectionView.dequeueReusableCell(withReuseIdentifier: IndicatorCellID, for: indexPath) as! IndicatorCell
        configureCell(dotCell, atIndexPath: indexPath)
        
        return dotCell
    }
    
    fileprivate func configureCell(_ cell: IndicatorCell, atIndexPath indexPath: Foundation.IndexPath) {
        cell.processed = true
        cell.current = false
        
        let itemIndex = indexPath.item
        if itemIndex > currentIndex {
            cell.processed = false
        }else if itemIndex == currentIndex {
            cell.current = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerID, for: indexPath) as! SituationFooter
        if totalNumber == 0 {
             footer.situation = "0 of 0, no cards here"
        } else {
            footer.situation = "\(currentIndex + 1) of \(totalNumber)"
        }

        return footer
    }

    // delegate
    // size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = dot.dotDiameter + 2 * (borderWidth + shadowRadius)
        if indexPath.item == currentIndex {
            let currentWidth = cellWidth + dot.dotDiameter * 0.2
            return CGSize(width: currentWidth, height: currentWidth)
        }
        return CGSize(width: cellWidth, height:  cellWidth)
    }
    
    // selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // switch to the selected one
        // change currentIndex
    }
}
