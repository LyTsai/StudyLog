//
//  LoadingFilmView.swift
//  SHIELD
//
//  Created by L on 2019/8/5.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation
import UIKit

class LoadingFilm {
    var isLoading = false
    fileprivate var imageView: UIImageView!
    fileprivate var backView: UIView!
    fileprivate let button = GradientButton(type: .custom)
   
    init() {
        backView = UIView(frame: UIScreen.main.bounds)
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        imageView = UIImageView(image: UIImage.animatedImageNamed("loading_0", duration: 1))
        imageView.layer.addBlackShadow(12)
        backView.addSubview(imageView)
        
        // button
        button.setTitle("Stop Loading")
        button.addTarget(self, action: #selector(self.endLoading), for: .touchUpInside)
        backView.addSubview(button)
        
        // layout
        layoutViews()
    }
    
    fileprivate func layoutViews() {
        backView.frame = UIScreen.main.bounds
        
        let loadingLength = min(width * 0.5, height * 0.45)
        imageView.frame = CGRect(center: CGPoint(x: width * 0.5, y: height * 0.4), length: loadingLength)
        
        // button
        button.frame = CGRect(center: CGPoint(x: width * 0.5, y: imageView.frame.maxY + loadingLength * 0.3), width: loadingLength * 0.78, height: loadingLength * 0.15)
    }
    
    fileprivate func relayoutLoading() {
        if backView.frame.width != UIScreen.main.bounds.width {
            layoutViews()
        }
    }
    
    fileprivate var resignTimer: Timer!
    func startLoading() {
        relayoutLoading()
        
        if isLoading {
            return
        }
        
        button.isHidden = true
        isLoading = true
        if backView.superview == nil {
            (UIApplication.shared.delegate as! AppDelegate).window?.addSubview(backView)
        }
 
        var time: TimeInterval = 0
        resignTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            time += 1
            
            self.relayoutLoading()
            if time >= 8 {
                self.button.isHidden = false
                timer.invalidate()
            }
        })
    }
    
    fileprivate var prepareLabel: UILabel!
    func setForScreenShotPrepare() {
        backView.backgroundColor = UIColor.clear
        button.isHidden = true
        
        if prepareLabel == nil {
            let imageBounds = imageView.bounds
            prepareLabel = UILabel(frame: CGRect(x: 0, y: imageBounds.height, width: imageBounds.width, height: imageBounds.height * 0.2))
            prepareLabel.font = UIFont.systemFont(ofSize: prepareLabel.frame.height * 0.25)
            prepareLabel.textColor = UIColorGray(175)
            prepareLabel.backgroundColor = UIColor.white
            prepareLabel.textAlignment = .center
            prepareLabel.text = "Preparing..."
            imageView.addSubview(prepareLabel)
        }
    }
    
    func addOnView(_ view: UIView!) {
        if view == nil {
            (UIApplication.shared.delegate as! AppDelegate).window?.addSubview(backView)
        }else {
            view.addSubview(backView)
        }
    }
    
    @objc func endLoading() {
        isLoading = false
        
        backView.removeFromSuperview()
        
        if resignTimer != nil {
            resignTimer.invalidate()
            resignTimer = nil
        }
    }
}
