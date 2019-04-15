//
//  ImageChooseCollectionView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/12/28.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

// cell for images
let imageChooseCellID = "image Choose Cell Identifier"
class ImageChooseCell: UICollectionViewCell {
    var image: UIImage! {
        didSet{
            if image != oldValue {
                imageView.image = image
            }
        }
    }
    
    var imageUrl: URL! 
    var isChosen = false {
        didSet{
            if isChosen != oldValue {
                checkMark.isHidden = !isChosen
            }
        }
    }
    
    fileprivate let imageView = UIImageView()
    fileprivate let checkMark = UIImageView(image: UIImage(named: "process_answered"))
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate func setupBasic() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        checkMark.isHidden = true
        contentView.addSubview(imageView)
        contentView.addSubview(checkMark)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let length = min(bounds.width, bounds.height)
        imageView.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY), length: length)
        imageView.layer.cornerRadius = length * 0.5
        
        let checkLength = length * 15 / 40
        checkMark.frame = CGRect(x: bounds.width - checkLength, y: bounds.height - checkLength, width: checkLength, height: checkLength)
    }
}

// view
class ImageChooseCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var chosenImage: UIImage! {
        return chosenIndex == -1 ? nil : images[chosenIndex]
    }
    fileprivate var chosenIndex = -1
    fileprivate var images = [UIImage]()
    
//    var chooseDelegate: ImageChooseDelegate!
    
    // create
    class func createWithFrame(_ frame: CGRect, iconSize: CGSize, existing: [UIImage]) -> ImageChooseCollectionView {
        // layout
        let colNumber = max(Int(frame.width / iconSize.width), 1)
        let gap = colNumber == 1 ? 0 : (frame.width - CGFloat(colNumber) * iconSize.width) / CGFloat(colNumber - 1)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = iconSize
        flowLayout.minimumInteritemSpacing = gap
        flowLayout.minimumLineSpacing = gap
        flowLayout.scrollDirection = .vertical
        
        // collection view
        let chooseView = ImageChooseCollectionView(frame: frame, collectionViewLayout: flowLayout)
        chooseView.backgroundColor = UIColor.clear
        chooseView.images = existing
        
        chooseView.register(ImageChooseCell.self, forCellWithReuseIdentifier: imageChooseCellID)
        chooseView.dataSource = chooseView
        chooseView.delegate = chooseView
        
        return chooseView
    }
    
    func resetIconSize(_ iconSize: CGSize) {
        let colNumber = max(Int(bounds.width / iconSize.width), 1)
        let gap = colNumber == 1 ? 0 : (frame.width - CGFloat(colNumber) * iconSize.width) / CGFloat(colNumber - 1)
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = iconSize
        flowLayout.minimumInteritemSpacing = gap
        flowLayout.minimumLineSpacing = gap
    }
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageChooseCellID, for: indexPath) as! ImageChooseCell
        if indexPath.item == images.count {
            cell.image = UIImage(named: "avatar_add")
        }else {
            cell.image = images[indexPath.item]
        }
        cell.isChosen = (indexPath.item == chosenIndex)
        
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == images.count {
            // choose from album
//            if chooseDelegate != nil {
//                chooseDelegate.chooseFromLibrary()
//            }
        }else {
            // choose as avatar
            var update = [indexPath]
            if chosenIndex != indexPath.item {
                if chosenIndex != -1 {
                    update.append(IndexPath(item: chosenIndex, section: 0))
                }
                chosenIndex = indexPath.item
            }else {
                // cancel
                chosenIndex = -1
            }
            // reload
            performBatchUpdates({
                reloadItems(at: update)
            }, completion: nil)
        }
    }
    
    // update data
    func chooseImageFromLibrary(_ image: UIImage) {
        images.append(image)
        chosenIndex = images.count - 1
        reloadData()
    }
}


