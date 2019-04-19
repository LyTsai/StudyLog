//
//  ViewController.swift
//  Demo_testUI
//
//  Created by iMac on 17/3/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: view.bounds)
        view.addSubview(label)
        let text = "By creating an account, I agree to AnnielyticX’s terms of use and privacy policy."
        
        let attributedText = NSMutableAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 12 * fontFactor)])
        attributedText.addAttributes([NSAttributedString.Key.link: "netdown"], range: NSMakeRange(0, 5))
        
        label.attributedText = attributedText
    }
    

    @IBAction func actionForButton(_ sender: Any) {
        let vc = AbookHintViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.focusOnFrame(CGRect(x: 40, y: 160, width: 100, height: 200), hintText: "this is a test string") 
        present(vc, animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
}

