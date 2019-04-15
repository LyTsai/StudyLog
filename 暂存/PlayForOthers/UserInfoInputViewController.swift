//
//  UserInfoInputViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/6.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class UserInfoInputViewController: UIViewController {
    weak var playForOthersDelegate: PlayForOthersView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        modalPresentationStyle = .overCurrentContext
        
        let table = UserInfoInputTableView.createWith(CGRect(x: 5, y: topLength + 5, width: width - 10, height: height - topLength - bottomLength - 10))
        table.hostVC = self
        table.layer.cornerRadius = 5
        table.backgroundColor = UIColorGray(240)
        view.addSubview(table)
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.setBackgroundImage(ProjectImages.sharedImage.circleCrossDismiss, for: .normal)
        dismissButton.frame = CGRect(x: table.frame.maxX - 50, y: 20, width: 34, height: 34)
        
        view.addSubview(dismissButton)
    }

    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
