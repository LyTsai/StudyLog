//
//  EncorecardDisplayViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/17.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class EncoreCardDisplayViewController: UIViewController {
    var riskKey: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismiss = UIButton(type: .custom)
        dismiss.setBackgroundImage(ProjectImages.sharedImage.whiteCircleDismiss, for: .normal)
        dismiss.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismiss.frame = CGRect(x: width - 50 * fontFactor, y: topLength - 44, width: 25 * fontFactor, height: 25 * fontFactor)
        view.addSubview(dismiss)
        
        let mainFrame = CGRect(x: 0, y: dismiss.frame.maxY, width: width, height: height - dismiss.frame.maxY - bottomLength + 49).insetBy(dx: 5 * fontFactor, dy: 5 * fontFactor)
        
        let imageView = UIImageView(frame: mainFrame)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        if let risk = collection.getRisk(riskKey) {
            if risk.metricKey == alzheimerMetricKey {
                imageView.image = #imageLiteral(resourceName: "encore_alzheimer")
            }else {
                imageView.image = #imageLiteral(resourceName: "encore_vtD")
            }
        }
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
