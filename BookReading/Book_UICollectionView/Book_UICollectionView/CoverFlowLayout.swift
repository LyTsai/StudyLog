//
//  CoverFlowLayout.swift
//  Book_UICollectionView
//
//  Created by iMac on 16/11/28.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class PhotoModel {
    var name = "icon"
    var image: UIImage!
    
    class func photoModelWithName(_ name: String, image: UIImage) -> PhotoModel {
        let photeModel = PhotoModel()
        photeModel.name = name
        photeModel.image = image
        
        return photeModel
    }
    
    class func defaultModel() -> [PhotoModel]{
        var model = [PhotoModel]()
        
        for i in 0..<3 {
            let name = "back\(i)"
            model.append(PhotoModel.photoModelWithName(name, image: UIImage(named: name)!))
        }
        
        for i in 0..<12 {
            let name = "icon\(i)"
            model.append(PhotoModel.photoModelWithName(name, image: UIImage(named: name)!))
        }
        
        return model
    }
    
}

class CoverFlowLayoutViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var layoutChangeSegmentedControl: UISegmentedControl!
    
    var photoModelArray = PhotoModel.defaultModel()
    var coverFlowCollectionViewLayout = CoverFlowFlowLayout()
    var boringCollectionViewLayout = UICollectionViewFlowLayout()
    
    let CellIdentifier = "CellIdentifier"
    
    // there is a method called "loadView" in UIViewController
    override func loadView() {
        boringCollectionViewLayout.itemSize = CGSize(width: 140, height: 140)
        boringCollectionViewLayout.minimumLineSpacing = 10
        boringCollectionViewLayout.minimumInteritemSpacing = 10
        
        let photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: boringCollectionViewLayout)
        photoCollectionView.register(CoverFlowCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier)
        
        photoCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        photoCollectionView.allowsSelection = false
        photoCollectionView.indicatorStyle = .white
        
        self.collectionView = photoCollectionView // now, all delegates are finished
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutChangeSegmentedControl.selectedSegmentIndex = 0
        layoutChangeSegmentedControl.addTarget(self, action: #selector(layoutChangeSegmentedControlDidChangeValue), for: .valueChanged)
    }
    
    func layoutChangeSegmentedControlDidChangeValue() {
        if layoutChangeSegmentedControl.selectedSegmentIndex == 0 {
            collectionView!.setCollectionViewLayout(boringCollectionViewLayout, animated: true)
        }else {
            collectionView!.setCollectionViewLayout(coverFlowCollectionViewLayout, animated: true)
        }
        // Invalidate the new layout
        collectionView!.collectionViewLayout.invalidateLayout()
    }
    
    // flowLayoutDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionViewLayout == boringCollectionViewLayout {
            return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }else {
            return UIEdgeInsets(top: 0, left: 190, bottom: 0, right: 190)
        }
    }
    
    // dataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModelArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! CoverFlowCollectionViewCell
        configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    fileprivate func configureCell(_ cell: CoverFlowCollectionViewCell, forIndexPath indexPath: IndexPath){
        cell.image = photoModelArray[indexPath.item].image
    }
}

class CoverFlowCollectionViewCell: UICollectionViewCell {
    var image: UIImage! {
        didSet{ imageView.image = image }
    }
    
    fileprivate let imageView = UIImageView()
    fileprivate var coverMaskView = UIView() // maskView is a property of UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        imageView.backgroundColor = UIColor.cyan
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        coverMaskView.backgroundColor = UIColor.black
        coverMaskView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coverMaskView.alpha = 0
        contentView.insertSubview(coverMaskView, aboveSubview: imageView)
        
        backgroundColor = UIColor.white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        coverMaskView.alpha = 0
        layer.shouldRasterize = false
        
        if layoutAttributes.isKind(of: CoverFlowLayoutAttributes.self) {
            let castedLayoutAttributes = layoutAttributes as! CoverFlowLayoutAttributes
            layer.shouldRasterize = castedLayoutAttributes.shouldRasterize
            coverMaskView.alpha = castedLayoutAttributes.maskingValue
        }
    }
    
    override func layoutSubviews() {
        imageView.frame = bounds.insetBy(dx: 10, dy: 10)
        coverMaskView.frame = bounds
    }
}

class CoverFlowFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        setupInit()
    }
    
    func setupInit() {
        scrollDirection = .horizontal
        itemSize = CGSize(width: 180, height: 180)
        
        minimumLineSpacing = -60  // Gets items up close to one another
        minimumInteritemSpacing = 200 // only one row
    }
    
    // now, the attributes is custom
    override class var layoutAttributesClass : AnyClass{
        return CoverFlowLayoutAttributes.self
    }
    
    //  re-layout the cells when scrolling
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesArray = super.layoutAttributesForElements(in: rect)!
        let visibleRect = CGRect(x: collectionView!.contentOffset.x, y: collectionView!.contentOffset.y, width: collectionView!.bounds.width, height: collectionView!.bounds.height)
        
        for attributes in layoutAttributesArray {
            if attributes.frame.intersects(rect) {
                applyLayoutAttributes(attributes, forVisibleRect: visibleRect)
            }
        }
        
        return layoutAttributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)!
        let visibleRect = CGRect(x: collectionView!.contentOffset.x, y: collectionView!.contentOffset.y, width: collectionView!.bounds.width, height: collectionView!.bounds.height)
        applyLayoutAttributes(attributes, forVisibleRect: visibleRect)
        
        return attributes
    }
    
    var activeDistance: CGFloat = 100
    var translateDistance: CGFloat = 100
    var zoomFactor: CGFloat = 0.2
    var flowOffset: CGFloat = 40
    var inactiveGrayValue: CGFloat = 0.6
    func applyLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes, forVisibleRect visibleRect: CGRect)  {
        // skip supplementary views
        if (attributes.representedElementKind != nil) { return }
        
        let distanceFromVisibleRectToItem = visibleRect.midX - attributes.center.x
        let normalizedDistance = distanceFromVisibleRectToItem / activeDistance
        let isLeft = distanceFromVisibleRectToItem > 0
        var transform = CATransform3DIdentity
        var maskAlpha: CGFloat = 0
        
        if fabs(distanceFromVisibleRectToItem) < activeDistance {
            // We're close enough to apply the transform in relation to how far away from the center we are.
            transform = CATransform3DTranslate(CATransform3DIdentity, (-flowOffset * distanceFromVisibleRectToItem / translateDistance), 0,  (1 - fabs(normalizedDistance)) * 40000 + (isLeft ? 200 : 0))
            let zoom = 1 + zoomFactor * (1 - abs(normalizedDistance))
            transform = CATransform3DRotate(transform, normalizedDistance * CGFloat(M_PI_4), 0, 1, 0)
            transform = CATransform3DScale(transform, zoom, zoom, 1)
            attributes.zIndex = 1
            
            maskAlpha = inactiveGrayValue * fabs(normalizedDistance)
        }else {
            // We're too far away - just apply a standard perspective transform.
            transform.m34 = -1 / (4.6777 * itemSize.width)
            transform = CATransform3DTranslate(transform, isLeft ? -flowOffset : flowOffset, 0, 0)
            transform = CATransform3DRotate(transform, (isLeft ? 1 : -1) * CGFloat(M_PI_4), 0, 1, 0)
            attributes.zIndex = 0
            maskAlpha = inactiveGrayValue
        }
        attributes.transform3D = transform
        
        // Rasterize the cells for smoother edges.
        let attribute = attributes as! CoverFlowLayoutAttributes
        attribute.shouldRasterize = true
        attribute.maskingValue = maskAlpha
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat(MAXFLOAT)
        let horizontalCenter = proposedContentOffset.x + collectionView!.bounds.width * 0.5
        
        let proposedRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: collectionView!.bounds.size)
        let array = layoutAttributesForElements(in: proposedRect)!
        
        for layoutAttributes in array {
            // skip supplementary views
            if layoutAttributes.representedElementCategory != UICollectionElementCategory.cell {
                continue
            }
            
            let itemHorizontalCenter = layoutAttributes.center.x
            if fabs(itemHorizontalCenter - horizontalCenter) < fabs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}

class CoverFlowLayoutAttributes: UICollectionViewLayoutAttributes {
    var shouldRasterize = true
    var maskingValue: CGFloat = 1.0
    
    override func copy(with zone: NSZone?) -> Any {
        let attributes = super.copy(with: zone) as! CoverFlowLayoutAttributes
        attributes.shouldRasterize = shouldRasterize
        attributes.maskingValue = maskingValue
        
        return attributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if (object! as AnyObject).isKind(of: CoverFlowLayoutAttributes){
            let other = object as! CoverFlowLayoutAttributes
            return super.isEqual(other) && (shouldRasterize == other.shouldRasterize) && (maskingValue == other.maskingValue)
        }
        return super.isEqual(object)
    }
}
