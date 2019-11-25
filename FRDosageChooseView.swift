//
//  FRDosageChooseView.swift
//  BeautiPhi
//
//  Created by L on 2019/11/12.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation

class FRDosageChooseView {
    fileprivate var backView: UIView!
    fileprivate var menuTable: MenuChooseList!
    init() {
       
        backView = UIView(frame: UIScreen.main.bounds)
        backView.backgroundColor = UIColor.clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
        backView.addGestureRecognizer(tap)
    }
    
    fileprivate let percentage = [200, 150, 100, 50]
    func showWithBase(_ base: String, currentPercent: Float, frame: CGRect) {
        var selections = [String]()
        var index = -1
        for (i, percent) in percentage.enumerated() {
            selections.append("\(base)   *   \(Int(percent))%")
            
            if Int(currentPercent) == percent {
                index = i
            }
        }
        
        menuTable = MenuChooseList(frame: frame, style: .plain)
        menuTable.pulldown = frame.maxY + frame.height * 10 < height
        menuTable.firstFrame = CGRect(x: frame.minX - 2 * frame.width, y: frame.maxY, width: frame.width * 2, height: frame.height * 1.5)
        menuTable.setupWithSelections(selections, selectedIndex: index)
        menuTable.selectionIsMade = choosePercent
        backView.addSubview(menuTable)
        
        print(menuTable.frame)
        
        UIApplication.shared.keyWindow?.addSubview(backView)
    }
  
    fileprivate func choosePercent(_ index: Int) {
        hideView()
    }
    
    @objc func hideView() {

        backView.removeFromSuperview()
      
    }

}
