//
//  SimpleCoverflowDisplayView.swift
//  Demo_testUI
//
//  Created by L on 2019/10/8.
//  Copyright © 2019 LyTsai. All rights reserved.
//

import Foundation

class SimpleCoverflowDisplayView: UIView {
    fileprivate var imageBlocks = [UIImageView]()
    fileprivate var focusedFrame = CGRect.zero
    fileprivate var leftFrame = CGRect.zero
    fileprivate var rightFrame = CGRect.zero
    fileprivate func addImages(_ imageNames: [String]) {
        self.backgroundColor = UIColor.clear

        
        focusedFrame = CGRect(center: CGPoint(x: centerFrame.midX, y: centerFrame.midY), size: CGSize(width: focusH / 352 * 310, height: focusH))
        let scale: CGFloat = 310 / 344
        let normalSize = CGSize(width: focusedFrame.width * scale, height: focusH * scale)
        let normalY = focusedFrame.midY - normalSize.height * 0.5
        let overlap = focusedFrame.width * 0.15
        leftFrame = CGRect(x: focusedFrame.minX + overlap - normalSize.width, y: normalY, width: normalSize.width, height: normalSize.height)
        rightFrame = CGRect(x: focusedFrame.maxX - overlap, y: normalY, width: normalSize.width, height: normalSize.height)
        
        for (i, imageName) in imageNames.enumerated() {
            if let image = UIImage(named: imageName) {
                let imageView = UIImageView(image: image)
                imageView.isUserInteractionEnabled = true
                imageView.tag = 100 + i
                
                imageView.layer.addBlackShadow(18 * fontFactor)
                imageView.layer.shadowOffset = CGSize(width: 0, height: 9 * fontFactor)
                imageView.frame = focusedFrame
                
                imageBlocks.append(imageView)
                addSubview(imageView)
                
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(blockIsTapped))
                imageView.addGestureRecognizer(tapGR)
            }
           
        }
        
        focusOnBlock(0)
    }
    
    fileprivate func focusOnBlock(_ index: Int) {
        var left = index - 1
        if left < 0 {
            left = 2
        }
        // animation
        UIView.animate(withDuration: 0.5) {
            for (i, imageView) in self.imageBlocks.enumerated() {
                if index == i {
                    imageView.frame = self.focusedFrame
                    self.scrollView.bringSubviewToFront(imageView)
                }else if i == left {
                    imageView.frame = self.leftFrame
                }else {
                    imageView.frame = self.rightFrame
                }
            }
        }
    }
    
    @objc fileprivate func blockIsTapped(_ tapGR: UITapGestureRecognizer) {
        let index = tapGR.view!.tag - 100
        focusOnBlock(index)
        
        // timer
//        if blockTimer != nil {
//            blockTimer.invalidate()
//            blockTimer = nil
//        }
    }
}
