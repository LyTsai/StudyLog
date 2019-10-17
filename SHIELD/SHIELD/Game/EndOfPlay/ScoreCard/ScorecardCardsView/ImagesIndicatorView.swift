//
//  ImagesIndicatorView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/29.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

let imageIndicatorCellID = "image indicator Cell Identifier"
class ImageIndicatorCell: UICollectionViewCell {
//    var scale: CGFloat = 1.2
    var current = false {
        didSet{
            imageView.layer.shadowColor = current ? UIColor.black.cgColor : UIColor.clear.cgColor
            imageView.alpha = current ? 1 : 0.5
        }
    }
    var image: UIImage! {
        didSet {
            if image != oldValue {
                imageView.image = image
            }
        }
    }
    
    fileprivate let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        imageView.layer.shadowOffset = CGSize.zero
        imageView.layer.shadowOpacity = 0.6
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let adjust = max(bounds.height, bounds.height) * 0.05
        imageView.frame = bounds.insetBy(dx: adjust, dy: adjust)
        imageView.layer.shadowRadius = adjust
    }
}

class ImagesIndicatorCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var scorecardAll: ScorecardDisplayAllView!
//    var forDisplay = false
    var currentIndex = 0
    var images = [UIImage?]() {
        didSet{
            if images != oldValue {
                reloadData()
            }
        }
    }
    
    class func createWithFrame(_ frame: CGRect, images: [UIImage]) -> ImagesIndicatorCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        // create
        let collection = ImagesIndicatorCollectionView(frame: frame, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        collection.isScrollEnabled = false
        collection.register(ImageIndicatorCell.self, forCellWithReuseIdentifier: imageIndicatorCellID)
        collection.images = images
        
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageIndicatorCellID, for: indexPath) as! ImageIndicatorCell
        cell.image = images[indexPath.item]
        cell.current = (indexPath.item == currentIndex || (indexPath.item == images.count - 1))
    
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gap = frame.height * 0.12
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 2000
        layout.minimumLineSpacing = gap
        
        let marginX = max((frame.width - CGFloat(images.count) * frame.height - gap * CGFloat(images.count - 1)) * 0.5, 0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: marginX, bottom: 0, right: marginX)
        
        return CGSize(width: frame.height, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentIndex != indexPath.item {
            if indexPath.item == images.count - 1 {
                let mushroomVC = Bundle.main.loadNibNamed("MushroomViewController", owner: self, options: nil)?.first as! MushroomViewController
                if navigation != nil {
                    if ISPHONE {
                        viewController.hidesBottomBarWhenPushed = false
                    }
                    navigation.pushViewController(mushroomVC, animated: true)
                }else {
                    viewController.dismiss(animated: true, completion: nil)
                }
            }else {
                scorecardAll.scrollToIndicator(indexPath.item)
            }
        }
    }
}
