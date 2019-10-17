//
//  TreeRingMapHintViewController.swift
//  AnnielyticX
//
//  Created by L on 2019/5/7.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class TreeRingMapHintViewController: UIViewController {
    var buttonIsTouched: (() -> Void)? 
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var thumbNail: UIImageView!
    @IBOutlet weak var hideButton: GradientBackStrokeButton!
    
    @IBOutlet weak var nevershowButton: GradientBackStrokeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        hideButton.setupWithTitle("Hide")
        hideButton.isSelected = false
        
        nevershowButton.setupWithTitle("Never Show")
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        textView.contentOffset = CGPoint.zero
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.contentOffset = CGPoint.zero
    }
    
    // set up
    fileprivate var hintKey = ""
    func setupWithType(_ type: TreeRingMapType, hintKey: String) {
        self.hintKey = hintKey
        
        let topicFont = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .semibold)
        let normalFont = UIFont.systemFont(ofSize: 14 * fontFactor, weight: .light)

        let text = NSMutableAttributedString(string: "What:\n", attributes: [.font: topicFont])
        text.append(NSAttributedString(string: type.getGoalString(), attributes: [.font: normalFont]))
        text.append(NSAttributedString(string: "\n\nWhy:\n", attributes: [.font: topicFont]))
        text.append(NSAttributedString(string: type.getObjectiveString(), attributes: [.font: normalFont]))
        
        textView.attributedText = text
        thumbNail.image = type.getThumbIcon()
    }
    
    // button actions
    @IBAction func hide(_ sender: Any) {
        dismiss(animated: true) {
            self.buttonIsTouched?()
        }
    }
    
    
    @IBAction func nevershow(_ sender: Any) {
        userDefaults.set(true, forKey: hintKey)
        dismiss(animated: true) {
            self.buttonIsTouched?()
        }
    }
    
}
