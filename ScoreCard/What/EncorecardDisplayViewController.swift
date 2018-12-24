//
//  EncorecardDisplayViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/17.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class EncoreCardDisplayViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let encore = UIImageView(image: #imageLiteral(resourceName: "vtD_encore_temp"))
        let whRatio: CGFloat = 363 / 535
        let cWidth = min(width, height * whRatio * 0.98)
        encore.frame = CGRect(center: CGPoint(x: width * 0.5, y: height * 0.5), width: cWidth, height: cWidth / whRatio)
        view.addSubview(encore)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        view.addGestureRecognizer(tapGR)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
