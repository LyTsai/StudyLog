//
//  MagniPhiLoadingFilm.swift
//  MagniPhi
//
//  Created by L on 2021/2/26.
//  Copyright © 2021 MingHui. All rights reserved.
//

import Foundation
import UIKit

class LoadingFilm {
    fileprivate var isLoading = false
    fileprivate var imageView: UIImageView!
    fileprivate var backView: UIView!
    fileprivate var button: GradientButton!
    fileprivate var titleLabel: UILabel!
    
    init() {
        backView = UIView(frame: UIScreen.main.bounds)
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        imageView = UIImageView(image: UIImage.animatedImageNamed("loading_0", duration: 0.9))
        backView.addSubview(imageView)
 
        // layout
        layoutViews()
    }
    
    fileprivate func layoutViews() {
        backView.frame = UIScreen.main.bounds
        
        let loadingLength = min(width * 0.2, height * 0.2)
        let imageFrame = CGRect(center: CGPoint(x: width * 0.5, y: height * 0.4), length: loadingLength)
        imageView.frame = imageFrame
        
        if button != nil && !button.isHidden {
            button.frame = CGRect(center: CGPoint(x: width * 0.5, y: imageFrame.maxY + loadingLength * 0.3), width: loadingLength, height: loadingLength * 0.2)
            
            let titleH = loadingLength * 0.4
            let titleW = width * 0.48
            titleLabel.frame = CGRect(x: width * 0.5 - titleW * 0.5, y: imageFrame.minY - titleH, width: titleW, height: titleH)
            titleLabel.font = UIFont.systemFont(ofSize: loadingLength * 0.12, weight: .semibold)
        }
    }
    
    fileprivate var resignTimer: Timer!
    func startLoading() {
        relayoutLoadingIfNecessary()
        
        if isLoading {
            return
        }
        
        if button != nil {
            button.isHidden = true
            titleLabel.isHidden = true
        }
        
        isLoading = true
        if backView.superview == nil {
            (UIApplication.shared.delegate as! AppDelegate).window?.addSubview(backView)
        }
 
        var time: TimeInterval = 0
        resignTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            time += 1
            self.relayoutLoadingIfNecessary()
            
            if time >= 10 {
                self.showButtons()
                timer.invalidate()
            }
        })
    }
    
    fileprivate func relayoutLoadingIfNecessary() {
        if backView.frame.width != UIScreen.main.bounds.width {
            layoutViews()
        }
    }
    
    fileprivate func showButtons() {
        if button == nil {
            // button
            button = GradientButton(type: .custom)
            button.setTitle("Stop Loading")
            button.addTarget(self, action: #selector(self.endLoading), for: .touchUpInside)
            backView.addSubview(button)
            
            titleLabel = UILabel()
            titleLabel.text = "Experiencing long network connection delay.\nContinue waiting or tap button to exit."
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.white
            backView.addSubview(titleLabel)
            
            layoutViews()
        }else {
            button.isHidden = false
            titleLabel.isHidden = false
        }
    }
    
    fileprivate var prepareLabel: UILabel!
    func setForScreenShotPrepare() {
        backView.backgroundColor = UIColor.clear
    
        if prepareLabel == nil {
            let imageBounds = imageView.bounds
            prepareLabel = UILabel(frame: CGRect(x: 0, y: imageBounds.height, width: imageBounds.width, height: imageBounds.height * 0.2))
            prepareLabel.font = UIFont.systemFont(ofSize: prepareLabel.frame.height * 0.3, weight: .medium)
            prepareLabel.textColor = UIColorGray(123)
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


