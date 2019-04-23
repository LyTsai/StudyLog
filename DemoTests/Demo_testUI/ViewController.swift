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
        
        let decoLabel = UILabel(frame: view.bounds)
        decoLabel.numberOfLines = 0
        decoLabel.font = UIFont.systemFont(ofSize: 22 * fontFactor)
        
        let label = UILabel(frame: view.bounds)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 22 * fontFactor)
        view.addSubview(decoLabel)
        
        view.addSubview(label)
        let text = "By creating an account, I agree to AnnielyticX’s.By creating an account, By creating an account, By creating an account"
        label.text = text
        
         let attributedText = NSMutableAttributedString(string: text, attributes: [.strokeWidth: NSNumber(value: 3)])
        
        let subString = "By"
        var startIndex = text.startIndex
        while let range = text.range(of: subString, options: .caseInsensitive, range: startIndex..<text.endIndex, locale: nil) {
            attributedText.addAttributes([.strokeWidth: NSNumber(value: -20)], range: NSMakeRange(range.upperBound.utf16Offset(in: text), 2))
            
            startIndex = range.upperBound
        }
        
//        text. var result: [Index] = []
//        var start = startIndex
//        while let range = range(of: string, options: options, range: start..<endIndex) {
//            result.append(range.lowerBound)
//            start = range.upperBound
//        }
//        return result
        
      
        
        decoLabel.attributedText = attributedText
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

