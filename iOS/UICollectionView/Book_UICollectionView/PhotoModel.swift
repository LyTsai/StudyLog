//
//  PhotoModel.swift
//  Book_UICollectionView
//
//  Created by L on 2020/5/11.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class PhotoModel {
    var image: UIImage?
    var name: String?
    
    class func photeModelWithName(_ name: String) -> PhotoModel {
        let photoModel = PhotoModel()
        photoModel.name = name
        photoModel.image = UIImage(named: name)
        
        return photoModel
    }
    
    class func defaultModels() -> [PhotoModel]{
        var models = [PhotoModel]()
        for i in 0..<12 {
            let photoModel = PhotoModel.photeModelWithName("icon\(i)")
            models.append(photoModel)
        }
        
        return models
    }
}

class PhotoSectionModel {
    var photoModels = [PhotoModel]()
    var selectedPhotoModelIndex: Int = -1

    class func selectionModelWithPhotoModels(_ photoModels: [PhotoModel]) -> PhotoSectionModel {
        let sectionModel = PhotoSectionModel()
        sectionModel.photoModels = photoModels
        
        return sectionModel
    }
    
}


