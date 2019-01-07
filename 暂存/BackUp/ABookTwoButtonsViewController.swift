//
//  ABookTwoButtonsViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/20.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ABookTwoButtonsViewController: UIViewController {
    var buttonsHorizontal = true

    var cornerRadius: CGFloat = 10
    var stackHeight: CGFloat = 56
    var buttonMargin: CGFloat = 15
    var buttonGap: CGFloat = 10
    
    // properties
    var firstButtonViewController = UIViewController()
    var secondButtonViewController = UIViewController()
    
    /** the left or up button*/
    var button1 = CustomButton()
    
    /** the right or down button*/
    var button2 = CustomButton()
    
    var buttonTitles = ["Title1","Title2"]
    
    // MARK: ---------  superClass methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // simple set
        view.backgroundColor = backColor
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: nil)
    }
    
    override func viewDidLayoutSubviews() {
        var buttonEdgeInsets: UIEdgeInsets {
            return UIEdgeInsets(top: height - bottomLayoutGuide.length - stackHeight, left: buttonMargin, bottom: bottomLayoutGuide.length + buttonMargin, right: buttonMargin)
        }
        let frames = getFramesOfViewStack(2, isHorizontal: buttonsHorizontal, edgeInsets: buttonEdgeInsets, gap: buttonGap)
        button1.frame = frames[0]
        button2.frame = frames[1]
    }
    
    // MARK: ----------- updateUI
    // buttons for push, call after all the data refreshed
    func setupButtons()  {
        button1.setCustomType(.roundRectHollow(color: darkGreenColor, cornerRadius: cornerRadius, title: buttonTitles[0]))
        button2.setCustomType(.roundRectHollow(color: UIColor.lightGray, cornerRadius: cornerRadius, title: buttonTitles[1]))
        
        button1.addTarget(self, action: #selector(button1Clicked), for: .touchUpInside)
        button2.addTarget(self, action: #selector(button2Clicked), for: .touchUpInside)
        
        view.addSubview(button1)
        view.addSubview(button2)
    }
    
    // MARK: ----------- click buttons
    func button1Clicked() {
        navigationController?.pushViewController(firstButtonViewController, animated: true)
    }
    func button2Clicked() {
        navigationController?.pushViewController(secondButtonViewController, animated: true)
    }
    
}
