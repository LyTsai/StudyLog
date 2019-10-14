//
//  LoadingViewController.swift
//  LoginView
//
//  Created by dingf on 16/11/16.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    fileprivate var imageRotateAngle: CGFloat = 0
    fileprivate var timer :Timer!
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var gradientLineImageView: UIImageView!

    @IBOutlet weak var backButton: GradientBackStrokeButton!
    fileprivate var onshowTimer: Timer!
    @objc fileprivate func rotateImageView(){
        imageRotateAngle = imageRotateAngle + 0.05
        if imageRotateAngle > 6.28 {
            imageRotateAngle = 0
        }
        gradientLineImageView.transform = CGAffineTransform(rotationAngle: imageRotateAngle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        promptLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor)
        mainLabel.font = UIFont.systemFont(ofSize: 35 * fontFactor, weight: .bold)
        backButton.setupWithTitle("Stop Loading")
    }
    
    // read only
    var isLoading: Bool {
        return _isLoading
    }
    var _isLoading = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _isLoading = true
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(rotateImageView), userInfo: nil, repeats: true)
        }
        
        self.backButton.isHidden = true
      
        var number = 0
        onshowTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            number += 1
            if number >= 5 {
                self.backButton.isHidden = false
                timer.invalidate()
            }
        })
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true) {
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _isLoading = false
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        if onshowTimer != nil {
            onshowTimer.invalidate()
            onshowTimer = nil
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
