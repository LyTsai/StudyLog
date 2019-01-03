//
//  SubviewController.swift
//  Demo_testUI
//
//  Created by iMac on 2019/1/3.
//  Copyright © 2019年 LyTsai. All rights reserved.
//

import Foundation

class SubViewController: UIViewController {
    
    @IBAction func present(_ sender: Any) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        vc.modalPresentationStyle = .overCurrentContext
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    @IBAction func push(_ sender: Any) {
        let viewc = UIViewController()
        viewc.view.backgroundColor = UIColor.white
        navigationController?.pushViewController(viewc, animated: true)
    }
}
