//
//  PulldownChooseView.swift
//  BeautiPhi
//
//  Created by Lydire on 2020/2/12.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation
import UIKit

class PulldownChooseView: UIView {
    var viewIsOnFocus: ((Bool)->Void)?
    var selectionIsMade:(() -> Void)?
   
    
    var displayY: CGFloat {
        return chooseList.frame.maxY
    }
    
    // views
    fileprivate let backLayer = CAGradientLayer()
    fileprivate let actionView = UIView()
    fileprivate let selectionLabel = UILabel()
    fileprivate let selectionArrow = UIImageView(image: UIImage(named: "input_arrow"))
    fileprivate var chooseList = MenuChooseList(frame: CGRect.zero, style: .plain)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        basicSetup()
    }
    
    fileprivate func basicSetup() {
        backLayer.locations = [0.2, 1]
        backLayer.colors = [UIColor.white.cgColor, UIColorGray(229).cgColor]
        layer.addSublayer(backLayer)
        actionView.backgroundColor = UIColor.clear
        
        addSubview(actionView)
        addSubview(selectionLabel)
        addSubview(selectionArrow)
        
        layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToSelectOrHide))
        actionView.addGestureRecognizer(tap)
        chooseList.layer.borderColor = UIColorGray(151).cgColor
    }
    
    var selecitonIndex: Int {
        return selectedIndex
    }
       
    var result: String? {
        if selectedIndex < 0 || selectedIndex >= selections.count {
            return nil
        }
        return selections[selectedIndex]
    }
    
    fileprivate var selections = [String]()
    fileprivate var selectedIndex: Int = -1
    fileprivate var placeHolder: String?
    func setForSelect(_ placeHolder: String?, selections: [String]) {
        chooseList.isHidden = true
        selectionArrow.isHidden = (selections.count <= 1)
        self.selections = selections
        self.placeHolder = placeHolder
        selectionLabel.text = placeHolder
        
        setSelected(placeHolder)
        
        chooseList.selectionIsMade = { (index) in
            self.setSelectedIndex(index)
            self.changeCurrentState(false)
            
            self.selectionIsMade?()
        }
        changeCurrentState(false)
    }
    
    func setSelected(_ selected: String?) {
        selectedIndex = -1
        if selected != nil {
            for (i, selection) in selections.enumerated() {
                if selected! == selection {
                    selectedIndex = i
                    break
                }
            }
        }

        selectionLabel.text = (selectedIndex == -1 ? placeHolder : selected)
    }
        
    func setSelectedIndex(_ index: Int?) {
        if index == nil || index! < 0 || index! >= selections.count {
            self.selectedIndex = -1
            selectionLabel.text = placeHolder
        }else {
            self.selectedIndex = index!
            selectionLabel.text = selections[index!]
        }
        
        chooseList.setSelectedIndex(index)
    }
    
    @objc func tapToSelectOrHide() {
        if selections.count > 1 {
            changeCurrentState(chooseList.isHidden)
        }else {
            selectionIsMade?()
        }
    }
    
    func changeCurrentState(_ onFocus: Bool) {
        layer.borderColor = onFocus ? UIColorFromHex(0x10A860).cgColor : UIColorGray(190).cgColor
        if onFocus {
            // show
            if chooseList.superview == nil {
                self.superview?.addSubview(chooseList)
                chooseList.setupWithSelections(selections, selectedIndex: selectedIndex)
            }
            chooseList.isHidden = false
        }else {
            chooseList.isHidden = true
        }
        
        selectionArrow.transform = onFocus ? CGAffineTransform(rotationAngle: CGFloatPi) : CGAffineTransform.identity
        
        viewIsOnFocus?(onFocus)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        actionView.frame = bounds
        backLayer.frame = bounds
        
        let oneL = bounds.height / 40
        layer.borderWidth = oneL
        layer.cornerRadius = 2 * oneL
        
        selectionLabel.font = UIFont.systemFont(ofSize: 16 * oneL, weight: .medium)
       
        let leftL = 10 * oneL
        selectionLabel.frame = CGRect(x: leftL, y: 0, width: bounds.width - leftL - bounds.height, height: bounds.height)
        selectionArrow.frame = CGRect(center: CGPoint(x: bounds.width - bounds.midY, y: bounds.midY), width: 12 * oneL, height: 16 * oneL)
        
        chooseList.firstFrame = CGRect(x: self.frame.minX, y: self.frame.maxY, width: self.frame.width, height: self.frame.height)
        chooseList.layer.borderWidth = oneL
    }

}
