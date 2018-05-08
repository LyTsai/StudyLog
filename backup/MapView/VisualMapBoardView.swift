//
//  VisualMapBoardView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/3/23.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
// boardType
enum VisualMapType {
    case symptoms
    case riskFactors
    case riskClass
}

class VisualMapBoardView: UIView {
    // sub views
    fileprivate let backShape = CAShapeLayer()
    fileprivate let bottomBar = UIView()
    fileprivate let scrollView = UIScrollView()
    fileprivate var buttons = [UIButton]()
   
    fileprivate let connectionView1 = VisualMapConnectionView()
    fileprivate let connectionView2 = VisualMapConnectionView()
    fileprivate let conditionView = VisualMapConditionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // back
        backShape.fillColor = UIColor.white.withAlphaComponent(0.85).cgColor
        layer.addSublayer(backShape)
        
        // top
        addSubview(bottomBar)
        
        for i in 0..<3 {
            let button = UIButton(type: .custom)
            button.tag = 100 + i
            
            button.setImage(#imageLiteral(resourceName: "mapUnselected"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "mapSelected"), for: .selected)
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.font = UIFont.systemFont(ofSize: 10 * fontFactor, weight: UIFontWeightSemibold)
            button.setTitleColor(UIColor.black, for: .selected)
            button.setTitleColor(UIColorGray(200), for: .normal)
            button.contentHorizontalAlignment = .left
            
            button.addTarget(self, action: #selector(chooseSegment(_:)), for: .touchUpInside)
            
            buttons.append(button)
            addSubview(button)
        }
        
        // middle
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        scrollView.backgroundColor = UIColor.clear
        
        addSubview(scrollView)
        scrollView.addSubview(conditionView)
        scrollView.addSubview(connectionView1)
        scrollView.addSubview(connectionView2)
        
        // shadow
        layer.shadowRadius = 5 * fontFactor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 0, height: 5 * fontFactor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupWithFrame(_ frame: CGRect, fillColor: UIColor, borderColor: UIColor, shadowColor: UIColor, mapType: VisualMapType) {
        self.frame = frame
        connectionView1.basicType = mapType
        connectionView2.basicType = mapType
        conditionView.basicType = mapType
        
        let cornerRadius = 12 * fontFactor
        let lineWidth = 3 * fontFactor
        
        var titles = [String]()
        switch mapType {
        case .symptoms:
            titles = ["With Risk", "With Factor", "Condition"]
            connectionView1.connectionType = .riskClass
            connectionView2.connectionType = .riskFactors
        case .riskFactors:
            titles = ["With Risk", "With Symptons", "Condition"]
            connectionView1.connectionType = .riskClass
            connectionView2.connectionType = .symptoms
        case .riskClass:
            titles = ["With Factors", "With Symptons", "Condition"]
            connectionView1.connectionType = .riskFactors
            connectionView2.connectionType = .symptoms
        }
        
        for (i, button) in buttons.enumerated() {
            button.setTitle(titles[i], for: .normal)
        }
        
        // back shape
        let backRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 0.92).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        backShape.path = UIBezierPath(roundedRect: backRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius,height: cornerRadius)).cgPath
        backShape.lineWidth = lineWidth
        backShape.strokeColor = borderColor.cgColor
        
        // top
        let xMargin = lineWidth * 3
        let mainWidth = bounds.width - 2 * xMargin
        let length = mainWidth / 3
       
        for (i, button) in buttons.enumerated() {
            button.frame = CGRect(x: CGFloat(i) * length + xMargin, y: lineWidth * 1.5, width: length * 0.9 ,height: bounds.height * 0.08)
        }
        bottomBar.frame = CGRect(x: xMargin, y: buttons[0].frame.maxY, width: length, height: 3 * fontFactor)
        
        bottomBar.backgroundColor = borderColor
        
        // scrollView
        scrollView.frame = CGRect(x: xMargin, y: bottomBar.frame.maxY, width: mainWidth, height: backRect.maxY - bottomBar.frame.maxY - lineWidth * 0.5)
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(titles.count), height: scrollView.bounds.height)
        connectionView1.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        connectionView2.frame = CGRect(x: mainWidth, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        conditionView.frame = CGRect(x: mainWidth * 2, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        
        // colors
        backgroundColor = fillColor.withAlphaComponent(0.6)
        addBorder(borderColor, cornerRadius: cornerRadius, borderWidth: lineWidth, masksToBounds: false)
        
        layer.shadowColor = shadowColor.cgColor
        
        // init state
        scrollView.contentOffset = CGPoint.zero
        chooseSegment(buttons[0])
        connectionView1.loadBasicNodes()
        connectionView2.loadBasicNodes()
        conditionView.loadBasicNodes()
    }
    
    func setupTilted(_ tilted: Bool) {
        if tilted {
            var transform = CATransform3DIdentity
            transform.m34 = -1 / (5 * bounds.height)
            transform = CATransform3DRotate(transform, CGFloat(Double.pi) * 0.42, 1, 0, 0)
            transform = CATransform3DScale(transform, 0.85, 0.8, 1)
            layer.transform = transform
            setupHideState(true)
            
        }else {
            layer.transform = CATransform3DIdentity
            setupHideState(false)
        }
    }
    
    fileprivate func setupHideState(_ hide: Bool) {
        backShape.isHidden = hide
        
        // top
        for button in buttons {
            button.isHidden = hide
        }
        bottomBar.isHidden = hide
        
        scrollView.isUserInteractionEnabled = !hide
    }

    // choose
    fileprivate var chosenSegment = -1
    func chooseSegment(_ button: UIButton)  {
        if (button.tag - 100) == chosenSegment {
            print("current is chosen")
            return
        }
        
        // change
        button.isSelected = true
        if chosenSegment != -1 {
            buttons[chosenSegment].isSelected = false
        }
        
        chosenSegment = button.tag - 100
        
        UIView.animate(withDuration: 0.3) {
            self.bottomBar.center = CGPoint(x: self.bottomBar.frame.width * (CGFloat(self.chosenSegment) + 0.5) + 12 * fontFactor, y: self.bottomBar.center.y)
            self.scrollView.contentOffset = CGPoint(x: CGFloat(self.chosenSegment) * self.scrollView.bounds.width, y: 0)
        }
    }
    
}
