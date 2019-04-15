//
//  IntroIndicatorsCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/9.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import Kingfisher

let introImagesDisplayCellID = "intro images display cell ID"
// buttons of pages
class IntroImagesDisplayCell: UITableViewCell {
    fileprivate var scrollView = UIScrollView()
    class func cellWithTableView(_ tableView: UITableView, images: [Any]) -> IntroImagesDisplayCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: introImagesDisplayCellID) as? IntroImagesDisplayCell
        if cell == nil {
            cell = IntroImagesDisplayCell(style: .default, reuseIdentifier: introImagesDisplayCellID)
            cell!.selectionStyle = .none
            cell!.addSubview(cell!.scrollView)
        }
        
        cell!.reloadImages(images)
        return cell!
    }
    
    fileprivate var imageViews = [UIImageView]()
    fileprivate func reloadImages(_ images: [Any]) {
        for imageView in imageViews {
            imageView.removeFromSuperview()
        }
        imageViews.removeAll()
        
        // new
        for (_, image) in images.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            
            if image is UIImage {
                imageView.image = image as? UIImage
            }else if image is URL {
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(with: ImageResource.init(downloadURL: image as! URL), placeholder: ProjectImages.sharedImage.indicator, options: [KingfisherOptionsInfoItem.transition(ImageTransition.fade(0.4)), KingfisherOptionsInfoItem.cacheMemoryOnly], progressBlock: nil) { (image, error, type, url) in
                }
            }
            
            // add
            imageViews.append(imageView)
            addSubview(imageView)
        }
    }
    
    // layoutSubviews
    fileprivate let arrowRatio: CGFloat = 0.516
    override func layoutSubviews() {
        super.layoutSubviews()

        scrollView.frame = bounds
        scrollView.contentSize = bounds.size
        if imageViews.count == 0 {
            return
        }
        
        if imageViews.count == 1 {
            imageViews.first?.frame = bounds.insetBy(dx: 10, dy: 5)
            return
        }
        
        let hGap = 5 * standWP
        let imageWidth = (bounds.width - 3 * hGap) * 0.5 // show part of the 3rd image
        
        // imageViews(buttons)
        for (i, imageView) in imageViews.enumerated() {
            let x = CGFloat(i) * (hGap + imageWidth)
            imageView.frame = CGRect(x: x, y: 0, width: imageWidth, height: bounds.height)
        }
        
        scrollView.contentSize = CGSize(width: max(imageViews.last!.frame.maxY, bounds.width), height: bounds.height)
    }
}
