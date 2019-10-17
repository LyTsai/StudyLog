//
//  AppTabsIntroCoverflowView.swift
//  SHIELD
//
//  Created by L on 2019/10/8.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class AppTabsIntroCoverflowView: UIView {
    var blockIsTouched: ((Int)->Void)?
    fileprivate var imageBlocks = [UIImageView]()
    fileprivate var focusedFrame = CGRect.zero
    fileprivate var leftFrame = CGRect.zero
    fileprivate var rightFrame = CGRect.zero

    func addBlocks() {
        self.backgroundColor = UIColor.clear
        
        let imageRatio: CGFloat = 285 / 566
        var imageH = bounds.height / 477 * 566 // top: 477
        let imageW = min(imageH * imageRatio, bounds.width * 0.8)
        imageH = imageW / imageRatio
        focusedFrame = CGRect(x: bounds.midX - imageW * 0.5, y: 0, width: imageW, height: imageH)
        
        let scale: CGFloat = 453 / 566
        let normalSize = CGSize(width: imageW * scale, height: imageH * scale)
        let normalY = focusedFrame.midY - normalSize.height * 0.5
        leftFrame = CGRect(x: 0, y: normalY, width: normalSize.width, height: normalSize.height)
        rightFrame = CGRect(x: bounds.width - normalSize.width, y: normalY, width: normalSize.width, height: normalSize.height)
        
        for i in 0..<4 {
            let imageView = UIImageView(image: UIImage(named: "splash_\(i)"))
            imageView.isUserInteractionEnabled = true
            imageView.tag = 100 + i
            
            imageView.frame = focusedFrame
            
            imageBlocks.append(imageView)
            addSubview(imageView)
            
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(blockIsTapped))
            imageView.addGestureRecognizer(tapGR)
        }
        
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(blockIsSwipped))
//        swipeLeft.direction = .left
//        self.addGestureRecognizer(swipeLeft)
//
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(blockIsSwipped))
//        swipeRight.direction = .right
//        self.addGestureRecognizer(swipeRight)

        focusOnBlock(0)
    }
    fileprivate var current:Int = -1
    func focusOnBlock(_ index: Int) {
        var left = index - 1
        var right = index + 1
        if left < 0 {
            left = 3
        }
        if right > 3 {
            right = 0
        }
        
        // animation
        UIView.animate(withDuration: 0.4) {
            for (i, imageView) in self.imageBlocks.enumerated() {
                if i == left {
                    imageView.frame = self.leftFrame
                }else if i == right {
                    imageView.frame = self.rightFrame
                }else {
                    imageView.frame = self.focusedFrame
                    if i == index {
                        self.bringSubviewToFront(imageView)
                    }
                }
            }
            
            self.current = index
        }
    }
    
    @objc fileprivate func blockIsTapped(_ tapGR: UITapGestureRecognizer) {
        let index = tapGR.view!.tag - 100
        focusOnBlock(index)
        blockIsTouched?(index)
    }
//
//    @objc fileprivate func blockIsSwipped(_ swipeGR: UISwipeGestureRecognizer) {
//        var next = self.current + 1
//        if swipeGR.direction == .right {
//            next = self.current - 1
//        }
//        if next == -1 {
//            next = 3
//        }
//
//        if next == 4 {
//            next = 0
//        }
//
//        focusOnBlock(next)
//        blockIsTouched?(next)
//    }
//
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        if !leftFrame.contains(point) && !rightFrame.contains(point) && !focusedFrame.contains(point) {
//            return nil
//        }
//
//        return super.hitTest(point, with: event)
//    }
}

