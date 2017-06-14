//
//  LoadingViewController.swift
//  LoginView
//
//  Created by dingf on 16/11/16.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    var imageRotateAngle :CGFloat = 0
    var timer :Timer!
    
    @IBOutlet weak var gradientLineImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(rotateImageView), userInfo: nil, repeats: true)
    }
    func rotateImageView(){
        imageRotateAngle = imageRotateAngle + 0.05
        if imageRotateAngle > 6.28 {
            imageRotateAngle = 0
        }
        gradientLineImageView.transform = CGAffineTransform(rotationAngle: imageRotateAngle)
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
  

}
