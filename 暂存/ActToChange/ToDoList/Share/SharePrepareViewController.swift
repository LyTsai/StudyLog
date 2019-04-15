//
//  SharePrepareViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/18.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class SharePrepareViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var backView: UIView!
  
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.layer.cornerRadius = 5
        chooseButton.isSelected = true
  
        titleTextView.delegate = self
        noteTextView.delegate = self
    }
    
    // delegate for textViews
    
    
    
    
    // action of buttons
    @IBAction func chooseToShare(_ sender: UIButton) {
        chooseButton.isSelected = true
        allButton.isSelected = false
    }

    @IBAction func shareToAll(_ sender: UIButton) {
        chooseButton.isSelected = false
        allButton.isSelected = true
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func save(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
