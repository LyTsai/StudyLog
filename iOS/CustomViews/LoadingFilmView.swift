//
//  LoadingFilmView.swift
//  Demo
//
//  Created by Lydire on 2019/8/5.
//  Copyright © 2019 LyTsai. All rights reserved.
//

import Foundation

class LoadingFilm {
    fileprivate var isLoading = false
    fileprivate var backView: UIView!
    fileprivate let button = CustomColorButton(type: .custom)
    init() {
        backView = UIView(frame: UIScreen.main.bounds)
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let loadingLength = 300 * fontFactor
        let imageView = UIImageView(image: UIImage.animatedImageNamed("loading_0", duration: 1))
        imageView.frame = CGRect(center: CGPoint(x: width * 0.5, y: 346 * standHP), length: loadingLength)
        imageView.layer.addBlackShadow(12 * fontFactor)
        backView.addSubview(imageView)
        
        // button
        button.frame = CGRect(center: CGPoint(x: width * 0.5, y: imageView.frame.maxY + 40 * fontFactor), width: 200 * fontFactor, height: 46 * fontFactor)
        button.backgroundColor = UIColorFromHex(0x7ED321)
        button.setTitle("Stop Loading")
        button.addTarget(self, action: #selector(self.endLoading), for: .touchUpInside)
        backView.addSubview(button)
    }
    
    fileprivate var resignTimer: Timer!
    func startLoading() {
        if isLoading {
            return
        }
        
        button.isHidden = true
        isLoading = true
        (UIApplication.shared.delegate as! AppDelegate).window?.addSubview(backView)
 
        var time: TimeInterval = 0
        resignTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            time += 1
            if time >= 8 {
                self.button.isHidden = false
                timer.invalidate()
            }
        })
    }
    
    func addOnView(_ view: UIView) {
        isLoading = true
        view.addSubview(backView)
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
