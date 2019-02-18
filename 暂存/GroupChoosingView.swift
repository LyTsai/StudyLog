//
//  GroupChoosingView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/28.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class GroupChoosingView: UIView {
    weak var hostVC: ABookLandingPageViewController!
    
    fileprivate var asBar = false
    fileprivate var duringChooseing = false {
        didSet{
            if duringChooseing != oldValue {
                if !asBar {
                    backgroundColor = duringChooseing ? UIColor.black.withAlphaComponent(0.5) : UIColor.clear
                    displayButton.backgroundColor = duringChooseing ? UIColorFromRGB(80, green: 211, blue: 135) : lightTintGray
                }else {
                    backView.isHidden = false
                }
                arrow.transform = duringChooseing ? CGAffineTransform(rotationAngle: -CGFloat(Double.pi)) : CGAffineTransform.identity
            }
        }
    }
    
    // factory
    // normal
    class func createWithFrame(_ frame: CGRect, topHeight: CGFloat, selectionHeight: CGFloat, chosenIndex: Int, choices: [(UIImage, String)]) -> GroupChoosingView {
        let choosing = GroupChoosingView()
        choosing.setupWithFrame(frame, topHeight: topHeight, selectionHeight: selectionHeight, chosenIndex: chosenIndex, choices: choices)
        return choosing
    }
    
    class func createAsBarWithSize(_ size: CGSize, viewController vc: UIViewController, selectionHeight: CGFloat, chosenIndex: Int, choices: [(UIImage, String)]) -> GroupChoosingView {
        let choosing = GroupChoosingView()
        choosing.setupAsBarWithSize(size, viewController: vc, selectionHeight: selectionHeight, chosenIndex: chosenIndex, choices: choices)
        return choosing
    }
    
    // MARK: ------------------- methods -------------------
    var chosenIndex = 0
    var choices = [(UIImage, String)]()
    var optional: [(UIImage, String)] {
        var option = choices
        option.remove(at: chosenIndex)
        return option
    }
    // subviews
    fileprivate let displayButton = UIButton(type: .custom)
    fileprivate let arrow = UIImageView(image: UIImage(named: "arrow_black_down"))
    fileprivate var groupCollection: GroupChoosingCollectionView!
    // create for normal
    fileprivate func setupWithFrame(_ frame: CGRect, topHeight: CGFloat, selectionHeight: CGFloat, chosenIndex: Int, choices: [(UIImage, String)]) {
        if chosenIndex < 0 || chosenIndex > choices.count - 1 {
            return
        }
        
        self.frame = frame
        self.chosenIndex = chosenIndex
        self.choices = choices
        self.asBar = false
        
        // subviews
        // title
        displayButton.frame = CGRect(x: 0, y: 0, width: bounds.width, height: topHeight)
        displayButton.backgroundColor = lightTintGray
        displayButton.setTitle(choices[chosenIndex].1, for: .normal)
        displayButton.titleLabel?.font = UIFont.systemFont(ofSize: topHeight * 0.4, weight: UIFontWeightBold)
        displayButton.setTitleColor(UIColor.black, for: .normal)
        displayButton.layer.addBlackShadow(4)
        
        // arrow
        let arrowLength = topHeight * 0.5
        arrow.frame = CGRect(x: bounds.width - 2 * topHeight, y: (topHeight - arrowLength) * 0.5, width: arrowLength, height: arrowLength)
        arrow.contentMode = .scaleAspectFit
        
        // choices
        groupCollection = GroupChoosingCollectionView.createWithFrame(CGRect(x: 0, y: topHeight - selectionHeight, width: bounds.width, height: selectionHeight), choices: optional)
        groupCollection.backgroundColor = UIColor.white
        groupCollection.groupChoosingView = self
        
        // add
        addSubview(groupCollection)
        addSubview(displayButton)
        addSubview(arrow)
        
        // action
        displayButton.addTarget(self, action: #selector(changeChoosing), for: .touchUpInside)

        // not during choosing
        backgroundColor = UIColor.clear
        groupCollection.isUserInteractionEnabled = false
        clipsToBounds = true
    }
    
    // create for normal
    fileprivate let backView = UIView()
    fileprivate let imageView = UIImageView()
    fileprivate let titleLabel = UILabel()
    fileprivate func setupAsBarWithSize(_ size: CGSize, viewController vc: UIViewController, selectionHeight: CGFloat, chosenIndex: Int, choices: [(UIImage, String)]) {
        if chosenIndex < 0 || chosenIndex > choices.count - 1 {
            return
        }
        
        self.frame = CGRect(origin: CGPoint.zero, size: size)
        self.chosenIndex = chosenIndex
        self.choices = choices
        self.asBar = true
        
        // subviews
        // arrow
        let arrowLength = size.height * 0.15
        arrow.frame = CGRect(x: size.width - arrowLength, y: size.height - arrowLength * 2, width: arrowLength, height: arrowLength)
        arrow.contentMode = .scaleAspectFit
        
        // display
        displayButton.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        displayButton.backgroundColor = UIColor.clear
        
//        displayButton.layer.borderColor = tabTintGreen.cgColor
//        displayButton.layer.borderWidth = 1
//        displayButton.layer.cornerRadius = 4
//        displayButton.backgroundColor = UIColor.white
        
        let imageLength = size.height - 2 * arrowLength
        imageView.frame = CGRect(x: 0, y: arrowLength, width: imageLength, height: imageLength)
        titleLabel.frame = CGRect(x: imageLength, y: 0, width: size.width - imageLength - arrowLength, height: size.height)
        
        imageView.contentMode = .scaleAspectFit
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: size.height * 0.26, weight: UIFontWeightSemibold)
        setBarDisplayWithChoice(choices[chosenIndex])
        
        displayButton.addSubview(titleLabel)
        displayButton.addSubview(imageView)
        
//        displayButton.contentMode = .topLeft
//        displayButton.setImage(choices[chosenIndex].0, for: .normal)
//        displayButton.setTitle(choices[chosenIndex].1, for: .normal)
//        
//        displayButton.imageView?.contentMode = .scaleAspectFit
//        displayButton.titleLabel?.font = UIFont.systemFont(ofSize: size.height * 0.3, weight: UIFontWeightBold)
//        displayButton.titleLabel?.numberOfLines = 0
//        displayButton.titleLabel?.textAlignment = .center
        
//        let imageOffset = size.width * 0.4 - displayButton.imageView!.frame.width //size.width * 0.4 - displayButton.titleLabel!.frame.width
//        let titleOffset = displayButton.imageView!.frame.width - size.width * 0.4
//        displayButton.imageEdgeInsets = UIEdgeInsets(top: arrowLength * 0.4, left: 0, bottom: arrowLength * 0.4, right: -imageOffset)
//        displayButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -titleOffset, bottom: 0, right: 0)
        
        // backView
        let vcMainFrame = CGRect(x: 0, y: 64, width: vc.width, height: vc.height - 64)
        backView.frame = vcMainFrame
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backView.clipsToBounds = true

        // choices
        groupCollection = GroupChoosingCollectionView.createWithFrame(CGRect(x: 0, y: -selectionHeight, width: vcMainFrame.width, height: selectionHeight), choices: optional)
        groupCollection.backgroundColor = UIColor.white
        groupCollection.groupChoosingView = self
        
        // add
        vc.view.addSubview(backView)
        backView.addSubview(groupCollection)
        addSubview(displayButton)
        addSubview(arrow)
        
        // action
        displayButton.addTarget(self, action: #selector(changeChoosing), for: .touchUpInside)
        
        // start
        backgroundColor = UIColor.clear
        backView.isHidden = true
        groupCollection.isUserInteractionEnabled = false

    }

    fileprivate func setBarDisplayWithChoice(_ choice: (UIImage, String)) {
        imageView.image = choice.0
        titleLabel.text = choice.1
    }
    
    // actions
    func changeChoosing()  {
        duringChooseing = !duringChooseing
        UIView.animate(withDuration: 0.4, animations: {
            self.groupCollection.transform = self.duringChooseing ? CGAffineTransform(translationX: 0, y: self.groupCollection.frame.height) : CGAffineTransform.identity
            self.groupCollection.isUserInteractionEnabled = self.duringChooseing
        }) { (true) in
            if self.asBar {
                self.backView.isHidden = !self.duringChooseing
            }
        }
    }
    
    // itme chosen
    func choose(_ choice: (UIImage, String)) {
        changeChoosing()
        if asBar {
            setBarDisplayWithChoice(choice)
        }else {
            displayButton.setTitle(choice.1, for: .normal)
        }
        
        for (i, value) in choices.enumerated(){
            if value == choice {
                chosenIndex = i
                break
            }
        }
        
        if hostVC != nil {
            hostVC.landing.focusOnTire(chosenIndex)
        }
        
        // other choices
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.groupCollection.chosenIndex = -1
            self.groupCollection.choices = self.optional
            self.groupCollection.reloadData()
        }
    }
    
    // hitTest
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, with: event)
        // background is clear, the plate is touched
        if !duringChooseing {
            if (!displayButton.frame.contains(point)) && !asBar {
                hitView = nil
            }
        }
        
        
        return hitView
    }
}
