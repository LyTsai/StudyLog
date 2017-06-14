//
//  CardBackImages.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/10.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation


class ProjectImages {
    static let sharedImage = ProjectImages()
    
    // back
    let backImage = UIImage(named: "homeBackImage")
    
    // card images
    let normal =  UIImage(named: "cardBack_normal_0")
    let selected = UIImage(named: "cardBack_selected_0")
    let cardSide = UIImage(named: "card_side")
    
    // buttons
    let flip = UIImage(named: "cardInfo")
    let unselectedYes = UIImage(named:"button_yes_unselected")
    let unselectedNo = UIImage(named:"button_no_unselected")
    let selectedYes = UIImage(named:"button_yes_selected")
    let selectedNo = UIImage(named:"button_no_selected")
    
    let lightBG = UIImage(named: "button_lightBG")
    let greenBG = UIImage(named: "button_greenBG")
    
    // arrows
    
}

//class CardBackImages {
//    static let sharedBack = CardBackImages()
//    
//    let normal =  UIImage(named: "cardBack_normal_0")
//    let selected = UIImage(named: "cardBack_selected_0")
//    let backImage = UIImage(named: "homeBackImage")
//    
//    /*
//    var normal: UIImage? {
//        get{
//            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//            let imagePath = path[0] + "/73e20eaa-ccac-4457-9045-92bea5be7294.png"
//            let image: UIImage? = UIImage(contentsOfFile: imagePath)
//            
//            if image != nil {
//                return image
//            }else {
//                let image = UIImage(named: "cardBack_normal_0")
//                let data = UIImagePNGRepresentation(image!)
//                if let imageData = data {
//                    CacheImage.sharedCache.saveDataToCache(data: imageData, imageKey: "73e20eaa-ccac-4457-9045-92bea5be7294")
//                    let image: UIImage = UIImage(data: imageData)!
//                    return image
//                }else {
//                    return nil
//                }
//            }
//            
//        }
//    }
//    
//    var selected: UIImage? {
//        get{
//            if let data = CacheImage.sharedCache.getDataFromCache(imageKey: "fdde785a-29a5-4fe4-ae73-46dbb3d6c493"){
//                let image: UIImage = UIImage(data: data)!
//                return image
//            }else {
//                let image = UIImage(named: "cardBack_selected_0")
//                let data = UIImagePNGRepresentation(image!)
//                if let imageData = data {
//                    CacheImage.sharedCache.saveDataToCache(data: imageData, imageKey: "fdde785a-29a5-4fe4-ae73-46dbb3d6c493")
//                    let image: UIImage = UIImage(data: imageData)!
//                    return image
//                }else {
//                    return nil
//                }
//            }
//            
//        }
//    }
// 
// */
//}
//
//// color: 32B4C3
//let backImagesStyle0 = CardBackImages.sharedBack
//
//class CardBackView: UIView {
//    // to put into the information of card, just for test now
//    
//}
