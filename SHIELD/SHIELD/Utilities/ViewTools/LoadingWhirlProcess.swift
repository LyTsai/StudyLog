//
//  LoadingWhirlProcess.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/9/30.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class LoadingWhirlProcess {
    fileprivate var timer: Timer!
    fileprivate let imageView = UIImageView(image: UIImage(named: "cache-image"))
    fileprivate let runImage = UIImageView(image: UIImage(named: "child"))
    
    var isLoading: Bool {
        return _isLoading
    }
    fileprivate var _isLoading = false
    
    // process_running, process_balls
    func startLoadingOnView(_ view: UIView, length: CGFloat) {
        _isLoading = true
        
        imageView.frame = CGRect(center: CGPoint(x: view.bounds.midX, y: view.bounds.midY), length: length)
        runImage.frame = imageView.frame.insetBy(dx: length * 0.01, dy: length * 0.01)

        view.addSubview(imageView)
        view.addSubview(runImage)
        
        var angle: Double = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            angle += Double.pi / 40
            if angle >= 2 * Double.pi {
                angle -= 2 * Double.pi
            }
            
            self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        })
    }
    
    func adjustCenter(_ center: CGPoint)  {
        imageView.center = center
        runImage.center = center
    }
    
    func loadingFinished() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        imageView.removeFromSuperview()
        runImage.removeFromSuperview()
        _isLoading = false
    }
}


