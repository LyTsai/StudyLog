//
//  SimpleTestVC.swift
//  Demo_testUI
//
//  Created by iMac on 17/4/19.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// for test
class SimpleTestVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
//        let arc = CoreTextArcView(frame: view.bounds)
//        arc.backgroundColor = UIColor.cyan
//        view.addSubview(arc)
     
        let flipView = FlipAnimationView(frame: view.bounds.insetBy(dx: 10, dy: 40))
        flipView.demo()
        view.addSubview(flipView)
    }
}


class FlipAnimationView: UIView {
    let backImageView = UIImageView(image: #imageLiteral(resourceName: "base"))
    let faceImageView = UIImageView(image: #imageLiteral(resourceName: "background"))
    let moreImageView = UIImageView(image: #imageLiteral(resourceName: "icon5"))
    
    var faceUp = true
    func demo() {
        backgroundColor = UIColor.cyan
        
        let viewFrame = CGRect(x: 50, y: 50, width: 200, height: 200)
        backImageView.frame = viewFrame
        faceImageView.frame = viewFrame
        moreImageView.frame = viewFrame.insetBy(dx: 60, dy: 60)
        
        addSubview(backImageView)
        addSubview(faceImageView)
        faceImageView.addSubview(moreImageView)
    
        // tap GR
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(flip))
        addGestureRecognizer(tapGR)
    }
    
    func flip() {
//        let transition = CATransition()
//        transition.type = "flip"
//        transition.subtype = kCATransitionFromRight
//        transition.duration = 0.3
//        
//        layer.add(transition, forKey: nil)
        // 整个view的翻转
        // 只有这两个的时候，OK，可以是其他子视图加在某个上。否则，翻转后消失。
        if faceUp {
            UIView.transition(from: faceImageView, to: backImageView, duration: 0.5, options: .transitionFlipFromRight, completion: nil)
        }else {
            UIView.transition(from: backImageView, to: faceImageView, duration: 0.5, options: .transitionFlipFromLeft, completion: nil)
        }
        
        faceUp = !faceUp
    }
}
