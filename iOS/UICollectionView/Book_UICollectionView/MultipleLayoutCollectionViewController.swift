//
//  MultipleLayoutCollectionViewController.swift
//  Book_UICollectionView
//
//  Created by L on 2020/5/11.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation
import UIKit
class MultipleLayoutCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, BlockFlowDelegate {
    @IBOutlet weak var layoutChangeSegmentedControl: UISegmentedControl!
    
    let photoModelArray = PhotoModel.defaultModels()
    var coverFlowCollectionViewLayout = CoverFlowFlowLayout()
    var boringCollectionViewLayout = UICollectionViewFlowLayout()
    var blockFlowLayout = BlockFlowLayout()
    
    
    // there is a method called "loadView" in UIViewController
    override func loadView() {
        boringCollectionViewLayout.itemSize = CGSize(width: 140, height: 140)
        boringCollectionViewLayout.minimumLineSpacing = 10
        boringCollectionViewLayout.minimumInteritemSpacing = 10
        
        let photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: boringCollectionViewLayout)
        photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: photoCellID)
        
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
    
    @objc func layoutChangeSegmentedControlDidChangeValue() {
        let segmentIndex = layoutChangeSegmentedControl.selectedSegmentIndex
        if segmentIndex == 0 {
            collectionView!.setCollectionViewLayout(boringCollectionViewLayout, animated: true)
        }else if segmentIndex == 1 {
            collectionView!.setCollectionViewLayout(coverFlowCollectionViewLayout, animated: true)
        }else if segmentIndex == 2 {
            collectionView.setCollectionViewLayout(blockFlowLayout, animated: true)
        }
        
        // Invalidate the new layout
        collectionView!.collectionViewLayout.invalidateLayout()
    }
    
    // flowLayoutDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionViewLayout == boringCollectionViewLayout {
            return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }else {
            return UIEdgeInsets(top: 50, left: 190, bottom: 0, right: 190)
        }
    }
    
    // dataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModelArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellID, for: indexPath) as! PhotoCell
        configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    fileprivate func configureCell(_ cell: PhotoCell, forIndexPath indexPath: IndexPath) {
        cell.image = photoModelArray[indexPath.item].image
    }
}
