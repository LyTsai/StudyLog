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
    fileprivate let imageView = UIImageView()
    fileprivate let runImage = UIImageView(image: UIImage(named: "process_running"))
//    process_running, process_balls
    func startLoadingOnView(_ view: UIView, size: CGSize) {
        imageView.image = ProjectImages.sharedImage.indicator
        imageView.frame = CGRect(center: CGPoint(x: view.bounds.midX, y: view.bounds.midY), width: size.width, height: size.height)
        runImage.frame = imageView.frame.insetBy(dx: size.width * 0.01, dy: size.width * 0.01)
        runImage.contentMode = .scaleAspectFit
        imageView.contentMode = .scaleAspectFit

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
    
    func loadingFinished() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        imageView.removeFromSuperview()
        runImage.removeFromSuperview()
    }
}


