//
//  IndividualSummaryView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/4.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class IndividualSummaryView: UIView {
    weak var hostVC: ABookRiskAssessmentViewController!

    class func createWithFrame(_ frame: CGRect, answered: Int) -> IndividualSummaryView {
        let summaryView = IndividualSummaryView()
        summaryView.setupWithFrame(frame, answered: answered)
        
        return summaryView
    }
    
    fileprivate let playNewButton = UIButton.customNormalButton("Play a new game")
    fileprivate let playForOthersButton = UIButton.customNormalButton("Play for someone else")
    fileprivate let actionButton = UIButton.customNormalButton("Action Plan")
    fileprivate func setupWithFrame(_ frame: CGRect, answered: Int) {
        self.frame = frame
        
        let stackHeight = 0.25 * frame.height
        let table = IndividualSummaryTableView.createWithFrame(CGRect(x: 0, y: 0, width: frame.width, height: frame.height - stackHeight), answered: answered)
        let stackView = UIView(frame: CGRect(x: -2, y: table.frame.height, width: frame.width + 4, height: stackHeight + 2))
        stackView.backgroundColor = UIColor.white
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 1
        
        addSubview(stackView)
        addSubview(table)
        
        // buttons on stack
        playNewButton.isSelected = true
        playNewButton.addTarget(self, action: #selector(continueNextGame), for: .touchUpInside)
        playForOthersButton.addTarget(self, action: #selector(playForOthers), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(goToTotalSummary), for: .touchUpInside)
        
        // frames
        let buttonWidth = 0.87 * frame.width
        let buttonHeight = stackHeight * 0.4
        
        let gap = stackHeight * 0.2 / 3
        let buttonX = (stackView.frame.width - buttonWidth) * 0.5
        
        playNewButton.isSelected = true
        playNewButton.adjustNormalButton(CGRect( x: buttonX, y:gap, width: buttonWidth, height: buttonHeight))
        let sbuttonY = playNewButton.frame.maxY + gap
        playForOthersButton.adjustNormalButton(CGRect(x: buttonX, y: sbuttonY, width: buttonWidth * 0.55, height: buttonHeight))
        actionButton.adjustNormalButton(CGRect(x: playForOthersButton.frame.maxX + gap, y: sbuttonY, width: 0.45 * buttonWidth - gap, height: buttonHeight))
        
        let font = UIFont.systemFont(ofSize: buttonHeight / 3.2)
        playNewButton.titleLabel?.font = font
        playForOthersButton.titleLabel?.font = font
        actionButton.titleLabel?.font = font
        
        stackView.addSubview(playNewButton)
        stackView.addSubview(playForOthersButton)
        stackView.addSubview(actionButton)
    }
    
    // actions for buttons
    func continueNextGame() {
        playNewButton.isSelected = true
        playForOthersButton.isSelected = false
        actionButton.isSelected = false
        
        if hostVC != nil {
            let navi = hostVC.navigationController
            for vc in navi!.viewControllers {
                if vc.isKind(of: ABookLandingPageViewController.self) {
                    let _ = navi?.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
    
    func playForOthers() {
        playNewButton.isSelected = false
        playForOthersButton.isSelected = true
        actionButton.isSelected = false
        
        if hostVC != nil {
            let playForOthers = PlayForOthersViewController()
            hostVC.navigationController?.pushViewController(playForOthers, animated: true)
        }
    }
    
    func goToTotalSummary() {
        playNewButton.isSelected = false
        playForOthersButton.isSelected = false
        actionButton.isSelected = true
        
//        let actToChange = TotalSummaryViewController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let actToChange = storyboard.instantiateViewController(withIdentifier: "To do List") as! ToDoListViewController
       
        hostVC.navigationController?.pushViewController(actToChange, animated: true)
    }
}




