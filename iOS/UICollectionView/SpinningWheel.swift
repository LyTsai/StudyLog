//
//  SpinningWheel.swift
//  UIDesignCollection
//
//  Created by iMac on 16/11/3.
//  Copyright © 2016年 LyTsai. All rights reserved.
//  https://www.raywenderlich.com/107687/uicollectionview-custom-layout-tutorial-spinning-wheel
//

import Foundation
import UIKit

class CircularCollectionViewLayout: UICollectionViewLayout {
    var itemSize = CGSize(width: 133, height: 173)
    var radius: CGFloat = 500 {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return atan(itemSize.width / radius)
    }// can be any value you want, but this formula ensures that the cells aren’t spread too far apart
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width, height: collectionView!.bounds.height)
    }
    
    // This tells the collection view that you’ll be using CircularCollectionViewLayoutAttributes, and not the default UICollectionViewLayoutAttributes for your layout attributes.
    override class var layoutAttributesClass : AnyClass {
        return CircularCollectionViewLayoutAttributes.self
    }
    
    var attributesList = [CircularCollectionViewLayoutAttributes]()
    override func prepare() {
        super.prepare()
        let centerX = collectionView!.contentOffset.x + collectionView!.bounds.width * 2

        attributesList = (0..<collectionView!.numberOfItems(inSection: 0)).map { (i)
            -> CircularCollectionViewLayoutAttributes in
            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            attributes.size = itemSize
            attributes.center = CGPoint(x: centerX, y: collectionView!.bounds.midY)
            attributes.angle = anglePerItem * CGFloat(i)
            
            return attributes
        }
        print(attributesList)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesList[indexPath.item]
    }
}

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    var angle: CGFloat = 0 {
        didSet {
            zIndex = Int(angle * 1000000) //  Since angle is expressed in radians, you amplify its value by 1,000,000 to ensure that adjacent values don’t get rounded up to the same value of zIndex, which is an Int.
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    // Subclasses of UICollectionViewLayoutAttributes need to conform to the NSCopying protocol because the attribute’s objects can be copied internally when the collection view is performing a layout. You override this method to guarantee that both the anchorPoint and angle properties are set when the object is copied.
    override func copy(with zone: NSZone?) -> Any {
        let copiedAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = anchorPoint
        copiedAttributes.angle = angle
        
        return copiedAttributes
    }
}

class CardViewCell: UICollectionViewCell {
    // combine view with cell (add cardView as a subview)
    var singleCard = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCard()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCard()
    }
    
    func setupCard() {
        singleCard.frame = bounds
        backgroundColor = UIColor.green
        addSubview(singleCard)
    }
}

let cellID = "Wheel"
class WheelOfCardsCollectionView: UICollectionView{
    // dataSource
     var cardViews = [[UIView(), UIView(), UIView(), UIView()]]
//    var cardViews = [[UIView]]() {
//        didSet{
//            if cardViews != oldValue {
//                reloadData()
//            }
//        }
//    }

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupCard()
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupCard()
//    }
//    
    class func createWheelCollectionView() -> WheelOfCardsCollectionView {
        let circularLayout = CircularCollectionViewLayout()
        let wheelCollectionView = WheelOfCardsCollectionView(frame: CGRect.zero, collectionViewLayout: circularLayout)
        print(circularLayout.attributesList)
        wheelCollectionView.register(CardViewCell.self, forCellWithReuseIdentifier: cellID)
        wheelCollectionView.dataSource = wheelCollectionView
        
        return wheelCollectionView
    }
    
    
}

extension WheelOfCardsCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cardViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardViews[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CardViewCell
        configureCell(cell, atIndexPath: indexPath)

        return cell
    }
    
    func configureCell(_ cell: CardViewCell, atIndexPath indexPath: IndexPath) {
        // set details here
        cell.singleCard = cardViews[indexPath.section][indexPath.item]
        cell.singleCard.backgroundColor = UIColor.green
    }
}
