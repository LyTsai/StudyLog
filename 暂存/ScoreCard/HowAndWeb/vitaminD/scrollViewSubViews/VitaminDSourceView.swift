//
//  VitaminDSourceView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/4.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class VitaminDSourceView: UIView {
    weak var howView: ScorecardVitaminDHowView!
    @IBOutlet var sourceButtons: [UIButton]!
    @IBOutlet var sourceChecks: [UIImageView]!
    
    func setup() {
        for (i, button) in sourceButtons.enumerated() {
            button.layer.addBlackShadow(4 * bounds.width / 255)
            sourceChecks[i].isHidden = true
        }
    }
    
    // tag: 300
    @IBAction func getSource(_ sender: UIButton) {
        let index = sender.tag - 300
        howView.visitSource(index)
        sourceChecks[index].isHidden = false
    }
}
