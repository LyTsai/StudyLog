//
//  MatchedCardsCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/16.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
// MARK: ------------ cell ----------------
let matchedCardsCellID = "matched cards cell identifier"
class MatchedCardsCell: UICollectionViewCell {
    var withAssess = false {
        didSet{
            if withAssess != oldValue {
                card.layer.shadowColor = withAssess ? UIColor.black.cgColor : UIColor.clear.cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate let card = MatchedCardView()
    fileprivate func updateUI() {
        card.layer.shadowOffset = CGSize(width: 0, height: 6)
        card.layer.shadowRadius = 10
        contentView.addSubview(card)
    }
    
    // configure cell
    func setupWithMatch(_ match: MatchedCardModel)  {
        card.matchedCard = match
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        card.frame = bounds
        card.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
}

class ScaleLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
    
        scrollDirection = .horizontal
        minimumInteritemSpacing = 100
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let orginalArray = super.layoutAttributesForElements(in: rect)
        let curArray = orginalArray!
        let centerX = collectionView!.contentOffset.x + collectionView!.bounds.width * 0.5
        
        for attrs in curArray {
            let space = abs(attrs.center.x - centerX)
            let scale = max(0.8, min(1 - space / collectionView!.bounds.width,1))
            attrs.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        return curArray
    }

//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        let rect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: collectionView!.bounds.size)
//        
//        let array = super.layoutAttributesForElements(in: rect)!
//        let centerX = proposedContentOffset.x + collectionView!.bounds.width * 0.5
//        
//        var minSpace = CGFloat(MAXFLOAT)
//        for attrs in array {
//            if abs(minSpace) > abs(attrs.center.x - centerX) {
//                minSpace = attrs.center.x - centerX
//            }
//        }
//        
//        let changedCenter = CGPoint(x: proposedContentOffset.x + minSpace, y: proposedContentOffset.y)
//        
//        return changedCenter
//    }
}


// MARK: ------------ collection view -------------------
class MatchedCardsCollectionView: UICollectionView {

    fileprivate var result = [MatchedCardModel]()
    
    var currentIndex = 0 {
        didSet{
            if currentIndex < 0 || currentIndex > result.count - 1 {
                return
            }
            
            if currentIndex != oldValue {
                performBatchUpdates({
                    self.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: true)
                }, completion: nil)
            }
        }
    }
    fileprivate var withAssess = false
    class func createWithFrame(_ frame: CGRect, itemSize: CGSize, cards: [MatchedCardModel], withAssess: Bool) -> MatchedCardsCollectionView {
        // layout
        let layout = ScaleLayout()
        layout.itemSize = itemSize
        let xMargin = (frame.width - itemSize.width) * 0.5
        let yMargin = (frame.height - itemSize.height) * 0.5
        layout.minimumLineSpacing = xMargin
        layout.sectionInset = UIEdgeInsets(top: yMargin, left: xMargin, bottom: yMargin, right: xMargin)
        
        // create
        let collection = MatchedCardsCollectionView(frame: frame, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        collection.result = cards
        collection.withAssess = withAssess
        collection.register(MatchedCardsCell.self, forCellWithReuseIdentifier: matchedCardsCellID)
        collection.isScrollEnabled = false
        
        // delegate
        collection.dataSource = collection
        
        return collection
    }
}

extension MatchedCardsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchedCardsCellID, for: indexPath) as! MatchedCardsCell
        cell.withAssess = withAssess
        cell.setupWithMatch(result[indexPath.item])

        return cell
    }
}
