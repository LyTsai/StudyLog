//
//  VitaminDPlannersView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/26.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class VitaminDPlannersView: UIView {
    var showIntroduction: ((Int) -> Void)?
    var showPlanner: ((Int) -> Void)?
    var showCompare: (() -> Void)?
    // dosage
    fileprivate let dosageIconButton = BorderImageControl.createWithIcon(UIImage(named: "how_vtd_dosage"), circleColor: dosageColor)
    fileprivate let dosageTagView = GradientLabelView()
    fileprivate let genericIconButton = BorderImageControl.createWithIcon(UIImage(named: "how_vtd_generic"), circleColor: dosageColor)
    fileprivate let genericTagView = BorderTextControl.createWithText("Generic RDA\nFor General Population", color: dosageColor)
    fileprivate let individualizedIconButton = BorderImageControl.createWithIcon(UIImage(named: "how_vtd_individualized"), circleColor: dosageColor)
    fileprivate let individualizedTagView = BorderTextControl.createWithText("Individualized Calculator\nFor Each Individual", color: dosageColor)
    // compare
    fileprivate let compareButton = BorderImageControl.createWithIcon(UIImage(named: "how_vtd_compare"), circleColor: dosageColor)
    
    // source
    fileprivate let sourceIconButton = BorderImageControl.createWithIcon(UIImage(named: "how_vtd_source"), circleColor: sourceColor)
    fileprivate let sourceTagView = GradientLabelView()
    fileprivate let sunIconButton = BorderImageControl.createWithIcon(UIImage(named: "how_vtd_sun"), circleColor: sourceColor)
    fileprivate let sunTagView = BorderTextControl.createWithText("Sun\'s UVB Rays", color: sourceColor)
    fileprivate let foodIconButton = BorderImageControl.createWithIcon(UIImage(named: "how_vtd_food"), circleColor: sourceColor)
    fileprivate let foodTagView = BorderTextControl.createWithText("Food Sources", color: sourceColor)
    fileprivate let supplementsIconButton = BorderImageControl.createWithIcon(UIImage(named: "how_vtd_dosage"), circleColor: sourceColor)
    fileprivate let supplementsTagView = BorderTextControl.createWithText("Supplements", color: sourceColor)
    
    fileprivate let roadDraw = RoadDrawModel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // init
    fileprivate func addBasic() {
        backgroundColor = UIColor.clear
        
        // basic
        dosageTagView.setLeftAlignText("Vitamin D\nDaily Dosage Planner", topColor: UIColorFromHex(0xFFEA99), bottomColor: dosageColor)
        sourceTagView.setLeftAlignText("Vitamin D\nSource Planner", topColor: UIColorFromHex(0xEAFFC5), bottomColor: sourceColor)
        
        // add all
        // dosage
        addSubview(dosageIconButton)
        addSubview(dosageTagView)
        addSubview(genericIconButton)
        addSubview(genericTagView)
        addSubview(individualizedIconButton)
        addSubview(individualizedTagView)
        
        addSubview(compareButton)
        
        // source
        addSubview(sourceIconButton)
        addSubview(sourceTagView)
        addSubview(sunIconButton)
        addSubview(sunTagView)
        addSubview(foodIconButton)
        addSubview(foodTagView)
        addSubview(supplementsIconButton)
        addSubview(supplementsTagView)
        
        // add actions
        // introductions
        dosageIconButton.tag = 100
        genericIconButton.tag = 101
        individualizedIconButton.tag = 102
        
        sourceIconButton.tag = 103
        sunIconButton.tag = 104
        foodIconButton.tag = 105
        supplementsIconButton.tag = 106
        
        dosageIconButton.addTarget(self, action: #selector(iconIsTouched), for: .touchUpInside)
        genericIconButton.addTarget(self, action: #selector(iconIsTouched), for: .touchUpInside)
        individualizedIconButton.addTarget(self, action: #selector(iconIsTouched), for: .touchUpInside)

//        sourceIconButton.addTarget(self, action: #selector(iconIsTouched), for: .touchUpInside)
//        sunIconButton.addTarget(self, action: #selector(iconIsTouched), for: .touchUpInside)
//        foodIconButton.addTarget(self, action: #selector(iconIsTouched), for: .touchUpInside)
//        supplementsIconButton.addTarget(self, action: #selector(iconIsTouched), for: .touchUpInside)
        
        // next step
        genericTagView.tag = 200
        individualizedTagView.tag = 201
        sunTagView.tag = 203
        foodTagView.tag = 204
        supplementsTagView.tag = 205
        
        genericTagView.addTarget(self, action: #selector(tagIsTouched), for: .touchUpInside)
        individualizedTagView.addTarget(self, action: #selector(tagIsTouched), for: .touchUpInside)
        sunTagView.addTarget(self, action: #selector(tagIsTouched), for: .touchUpInside)
        foodTagView.addTarget(self, action: #selector(tagIsTouched), for: .touchUpInside)
        supplementsTagView.addTarget(self, action: #selector(tagIsTouched), for: .touchUpInside)
        
        // compare
        compareButton.addTarget(self, action: #selector(showCompareView), for: .touchUpInside)
    }
    
    // layout
    fileprivate var roadFrame = CGRect.zero
    func layoutWithFrame(_ frame: CGRect)  {
        self.frame = frame
        
        let oneH = bounds.height / 471
        let oneW = bounds.width / 353
        let minOne = min(oneH, oneW)
        
        let firstX = 58 * oneW
        let secondX = 105 * oneW
        
        // main
        let iconL = 55 * minOne
        let tagSize = CGSize(width: 175 * oneW, height: 46 * oneH)
        dosageIconButton.frame = CGRect(center: CGPoint(x: firstX, y: 62 * oneH), length: iconL)
        dosageTagView.frame = CGRect(x: secondX, y: dosageIconButton.center.y - tagSize.height * 0.5, width: tagSize.width, height: tagSize.height)
        dosageTagView.addBorder(.allCorners, borderWidth: minOne, cornerRadius: 4 * minOne)
        
        sourceIconButton.frame = CGRect(center: CGPoint(x: firstX, y: 250 * oneH), length: iconL)
        sourceTagView.frame = CGRect(x: secondX, y: sourceIconButton.center.y - tagSize.height * 0.5, width: tagSize.width, height: tagSize.height)
        sourceTagView.addBorder(.allCorners, borderWidth: minOne, cornerRadius: 4 * minOne)
    
        
        // sub
        let subIconL = 37 * minOne
        let subSize = CGSize(width: 145 * oneW, height: 36 * oneH)
        let subX = 158 * oneW
        genericIconButton.frame = CGRect(x: secondX, y: 100 * oneH, width: subIconL, height: subIconL)
        genericTagView.frame = CGRect(x: subX, y: genericIconButton.center.y - subSize.height * 0.5, width: subSize.width, height: subSize.height)
        individualizedIconButton.frame = CGRect(x: secondX, y: 155 * oneH, width: subIconL, height: subIconL)
        individualizedTagView.frame = CGRect(x: subX, y: individualizedIconButton.center.y - subSize.height * 0.5, width: subSize.width, height: subSize.height)
        
        let compareL = 22 * minOne
        compareButton.frame = CGRect(x: individualizedTagView.frame.maxX + oneW, y: 0.5 * (genericTagView.center.y + individualizedTagView.center.y) - compareL * 0.5, width: compareL, height: compareL)
        
        sunIconButton.frame = CGRect(x: secondX, y: 285 * oneH, width: subIconL, height: subIconL)
        sunTagView.frame = CGRect(x: subX, y: sunIconButton.center.y - subSize.height * 0.5, width: subSize.width, height: subSize.height)
        foodIconButton.frame = CGRect(x: secondX, y: 340 * oneH, width: subIconL, height: subIconL)
        foodTagView.frame = CGRect(x: subX, y: foodIconButton.center.y - subSize.height * 0.5, width: subSize.width, height: subSize.height)
        supplementsIconButton.frame = CGRect(x: secondX, y: 398 * oneH, width: subIconL, height: subIconL)
        supplementsTagView.frame = CGRect(x: subX, y: supplementsIconButton.center.y - subSize.height * 0.5, width: subSize.width, height: subSize.height)
        
        // road
        roadFrame = CGRect(x: 0, y: 0, width: secondX, height: bounds.height)
        roadDraw.roadWidth = 14 * oneW
        roadDraw.turningRadius = 10 * minOne
        roadDraw.startPoint = CGPoint(x: 22 * oneW, y: 0)
        roadDraw.anchorInfo = [(dosageIconButton.center, false), (sourceIconButton.center, false)]
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        roadDraw.drawRoadInRect(roadFrame)
        
        let oneH = bounds.height / 471
        let linePath = UIBezierPath()
        linePath.move(to: dosageIconButton.center)
        linePath.addLine(to: dosageTagView.center)
        linePath.move(to: sourceIconButton.center)
        linePath.addLine(to: sourceTagView.center)
        
        linePath.lineWidth = 2 * oneH
        UIColor.black.setStroke()
        linePath.stroke()
        
        let subPath = UIBezierPath()
        subPath.move(to: CGPoint(x: genericIconButton.center.x, y: dosageTagView.center.y))
        subPath.addLine(to: individualizedIconButton.center)
        subPath.addLine(to: individualizedTagView.center)
        subPath.move(to: genericIconButton.center)
        subPath.addLine(to: genericTagView.center)
        
        subPath.move(to: CGPoint(x: genericTagView.frame.maxX, y: genericTagView.frame.midY))
        subPath.addCurve(to: CGPoint(x: individualizedTagView.frame.maxX, y: individualizedTagView.frame.midY), controlPoint1: CGPoint(x: compareButton.frame.maxX, y: compareButton.frame.midY), controlPoint2: CGPoint(x: compareButton.frame.maxX, y: compareButton.frame.midY))
        
        subPath.move(to: CGPoint(x: genericIconButton.center.x, y: sourceTagView.center.y))
        subPath.addLine(to: supplementsIconButton.center)
        subPath.addLine(to: supplementsTagView.center)
        subPath.move(to: foodIconButton.center)
        subPath.addLine(to: foodTagView.center)
        subPath.move(to: sunIconButton.center)
        subPath.addLine(to: sunTagView.center)
        
        subPath.lineWidth = oneH
        subPath.stroke()
    }
    
    // action
    @objc func iconIsTouched(_ sender: UIControl) {
        showIntroduction?(sender.tag - 100)
    }
    
    @objc func tagIsTouched(_ sender: UIControl) {
        showPlanner?(sender.tag - 200)
    }
    @objc func showCompareView() {
        showCompare?()
    }
}
