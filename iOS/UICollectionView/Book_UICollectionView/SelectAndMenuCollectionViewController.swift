//
//  SelectAndMenuCollectionViewController.swift
//  Book_UICollectionView
//
//  Created by L on 2020/5/12.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class SelectAndMenuCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var currentModelArrayIndex: Int = 0 // which section we’re currently prompting the user for
    var selectionModelArray = [PhotoSectionModel]()
    var isFinished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setModel()
        
        let flowLayout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.headerReferenceSize = CGSize(width: 60, height: 50)
        
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: photoCellID)
        collectionView?.register(PhotoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoHeaderViewIdentifier)
        
        collectionView?.allowsMultipleSelection = true
        collectionView?.indicatorStyle = .white
    }
    
    func setModel() {
        selectionModelArray.removeAll()
        currentModelArrayIndex = 0
        isFinished = false
        
        for j in 0..<5 {
            var photoArray = [PhotoModel]()
            if j == 0 {
                for i in 0..<3 {
                    photoArray.append(PhotoModel.photeModelWithName("back\(i)"))
                }
            }else {
                for i in (j-1)*3..<3*j{
                    photoArray.append(PhotoModel.photeModelWithName("icon\(i)"))
                }
            }
          
            let sectionArray = PhotoSectionModel.selectionModelWithPhotoModels(photoArray)
            selectionModelArray.append(sectionArray)
        }
    }
    
    
    func photoModelForIndexPath(_ indexPath: IndexPath) -> PhotoModel {
        return selectionModelArray[indexPath.section].photoModels[indexPath.item]
    }
    
    func configureCell(_ cell: PhotoCell, forIndexPath indexPath: IndexPath) {
        cell.image = photoModelForIndexPath(indexPath).image
        
        // default
        cell.isSelected = false
        cell.setDisabled(false)
        
        if indexPath.section < currentModelArrayIndex {
            cell.setDisabled(true)
            
            if indexPath.row == selectionModelArray[indexPath.section].selectedPhotoModelIndex {
                cell.isSelected = true
            }
        }
    }


    // header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PhotoHeaderViewIdentifier, for: indexPath) as! PhotoHeaderView
        
        if indexPath.section == 0 {
            headerView.text = "Tap on a photo to start the recommendation engine."
        }else if indexPath.section <= currentModelArrayIndex {
            let selectionModel = selectionModelArray[indexPath.section - 1]
            let selectedPhotoModel = photoModelForIndexPath(IndexPath(item: selectionModel.selectedPhotoModelIndex, section: indexPath.section - 1))
            headerView.text = "Because you liked \(selectedPhotoModel.name ?? "This Picture") ..."
        }
        
        return headerView
    }
    
    // dataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return min(currentModelArrayIndex + 1, selectionModelArray.count)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectionModelArray[currentModelArrayIndex].photoModels.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellID, for: indexPath) as! PhotoCell
        configureCell(cell, forIndexPath: indexPath)
     
        return cell
    }
    
    // delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // no matter what, deselect that cell
        collectionView.deselectItem(at: indexPath, animated: true)
     
        if currentModelArrayIndex >= selectionModelArray.count - 1 {
            isFinished = true
            
            // reset
            let alert = UIAlertController(title: "Recommendation Engine", message: "Based on your selections, we have concluded you have excellent taste in photography.", preferredStyle: .alert)
            let oKAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                self.setModel()
                collectionView.reloadData()
            })
            alert.addAction(oKAction)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        selectionModelArray[currentModelArrayIndex].selectedPhotoModelIndex = indexPath.item
        collectionView.performBatchUpdates({
            self.currentModelArrayIndex += 1
          
            collectionView.insertSections(IndexSet(integer: self.currentModelArrayIndex))
            collectionView.reloadSections(IndexSet(integer: self.currentModelArrayIndex-1))
            }) { (true) in
                collectionView.scrollToItem(at: IndexPath(item: 0, section: self.currentModelArrayIndex), at: .top, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photoModel = photoModelForIndexPath(indexPath)
        let maxWidth = collectionView.frame.width / 3.5
        let maxHeight = collectionView.frame.height / 7
        
        var itemSize = CGSize(width: maxWidth, height: maxHeight)
        let currentRatio = maxWidth / maxHeight
        if let photoSize = photoModel.image?.size {
            let aspectRatio = photoSize.width / photoSize.height

            if aspectRatio < currentRatio {
                itemSize = CGSize(width: maxHeight * aspectRatio, height: maxHeight)
            }else if aspectRatio > currentRatio {
                itemSize = CGSize(width: maxWidth, height: maxHeight / aspectRatio)
            }
        }
        
        return itemSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == currentModelArrayIndex && !isFinished
    }
    
    // menu
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        if NSStringFromSelector(action) == "copy" {
            return true
        }
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        if NSStringFromSelector(action) == "copy" {
            let pasteboard = UIPasteboard.general
               pasteboard.string = photoModelForIndexPath(indexPath).name
//          pasteboard.image =
        }
    }
}


