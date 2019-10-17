//
//  ScorecardVitaminDPlannerView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/27.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardHowVitaminDPlannerView: UIView {
    fileprivate let general = ScorecardHowVitaminPlannerCell()
    fileprivate let individual = ScorecardHowVitaminPlannerCell()
    
    fileprivate let source1 = ScorecardHowVitaminPlannerCell()
    fileprivate let source2 = ScorecardHowVitaminPlannerCell()
    fileprivate let source3 = ScorecardHowVitaminPlannerCell()
    
    fileprivate let compareButton = UIButton(type: .custom)
    fileprivate let dosageIntroButton = UIButton(type: .custom)
    
    func loadAllViews() {
        self.backgroundColor = UIColor.clear
        let color = UIColorFromHex(0xFFEBAD)
        general.placeCellOnView(self, color: color, title: "General RDA\nFor General Population", mark: true) // 200
        individual.placeCellOnView(self, color: color, title: "Individualized Calculator\nFor Each Individual", mark: true)
        source1.placeCellOnView(self, color: color, title: "Sun's UVB Rays", mark: false)
        source2.placeCellOnView(self, color: color, title: "Food Sources", mark: false)
        source3.placeCellOnView(self, color: color, title: "Supplements", mark: false)
        
        compareButton.setBackgroundImage(#imageLiteral(resourceName: "how_vtd_compare"), for: .normal)
        compareButton.layer.addBlackShadow(4 * fontFactor)
        compareButton.addTarget(self, action: #selector(showCompare), for: .touchUpInside)
        dosageIntroButton.setBackgroundImage(#imageLiteral(resourceName: "button_rectMark"), for: .normal)
        dosageIntroButton.addTarget(self, action: #selector(showDosageIntroduction), for: .touchUpInside)
        addSubview(compareButton)
        addSubview(dosageIntroButton)
        
        // actions
        // top
        general.cellIsTouched = showGeneral
        general.markIsTouched = showGeneralIntroduction
        individual.cellIsTouched = showCalculator
        individual.markIsTouched = showCalculatorIntroduction
        
        // down
        source1.cellIsTouched = showSource
        source1.cellTag = 201
        source2.cellIsTouched = showSource
        source2.cellTag = 202
        source3.cellIsTouched = showSource
        source3.cellTag = 203
    }
    
    fileprivate var topRect = CGRect.zero
    fileprivate var bottomRect = CGRect.zero
    fileprivate var titleH: CGFloat = 0
    fileprivate var compareRect = CGRect.zero
    func setupFrameWithOrigin(_ origin: CGPoint, blockWidth: CGFloat, cellHeight: CGFloat) {
        let one = cellHeight / 35
        titleH = 24 * one
        let gap = one * 15
        let marginX = blockWidth * 20 / 165
        let cellWidth = blockWidth - 2 * marginX
        
        // resize
        self.frame = CGRect(origin: origin, size: CGSize(width: blockWidth + cellHeight, height: (titleH * 2 + cellHeight * 5 + gap * 6)))
        // top
        let lineGap = fontFactor * 0.5
        topRect = CGRect(x: 0, y: 0, width: blockWidth, height: titleH + 2 * (gap + cellHeight)).insetBy(dx: lineGap, dy: lineGap)
        bottomRect = CGRect(x: 0, y: topRect.maxY + 15 * one, width: blockWidth, height: titleH + 3 * (gap + cellHeight)).insetBy(dx: lineGap, dy: lineGap)

        // layout
        general.layoutWithFrame(CGRect(x: marginX, y: titleH, width: cellWidth, height: cellHeight))
        compareRect = CGRect(x: marginX, y: titleH + cellHeight, width: cellWidth, height: gap)
        individual.layoutWithFrame(CGRect(x: marginX, y: compareRect.maxY, width: cellWidth, height: cellHeight))
        compareButton.frame = CGRect(center: CGPoint(x: blockWidth, y: compareRect.midY), length: 25 * one)

        dosageIntroButton.frame = CGRect(x: blockWidth - marginX * 0.6, y: topRect.maxY - marginX * 0.6, width: marginX * 0.5, height: marginX * 0.5)

        // bottom
        source1.layoutWithFrame(CGRect(x: marginX, y: bottomRect.minY + titleH, width: cellWidth, height: cellHeight))
        source2.layoutWithFrame(CGRect(x: marginX, y: bottomRect.minY + titleH + cellHeight + gap, width: cellWidth, height: cellHeight))
        source3.layoutWithFrame(CGRect(x: marginX, y: bottomRect.minY + titleH + (cellHeight + gap) * 2, width: cellWidth, height: cellHeight))

        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        // border
        let path = UIBezierPath(roundedRect: topRect, cornerRadius: 4 * fontFactor)
        path.append(UIBezierPath(roundedRect: bottomRect, cornerRadius: 4 * fontFactor))
        path.lineWidth = fontFactor
        dosageColor.setStroke()
        path.stroke()

        // texts
        let titleFont = UIFont.systemFont(ofSize: titleH * 0.56, weight: .medium)
        drawString(NSAttributedString(string: "Vitamin D Daily Dosage Planner", attributes: [.font: titleFont]), inRect: CGRect(x: topRect.minX, y: topRect.minY, width: topRect.width, height: titleH), alignment: .center)
        drawString(NSAttributedString(string: "Vitamin D Source Planner", attributes: [.font: titleFont]), inRect: CGRect(x: bottomRect.minX, y: bottomRect.minY, width: topRect.width, height: titleH), alignment: .center)
        drawString(NSAttributedString(string: "Comparison", attributes: [.font: UIFont.systemFont(ofSize: compareRect.height * 0.8)]), inRect: compareRect, alignment: .right)
        
        // connect
        let radius = compareButton.center.x - compareRect.maxX
        let cPath = UIBezierPath(arcCenter: CGPoint(x: compareRect.maxX, y: compareRect.midY), radius: radius, startAngle: -CGFloatPi * 0.5, endAngle: CGFloatPi * 0.5, clockwise: true)
        cPath.lineWidth = fontFactor
        UIColor.black.setStroke()
        cPath.stroke()
    }
    
    // data
    fileprivate var howUrls = [String]()
    fileprivate func getPlannerDefaultKeyForUser(_ userKey: String, index: Int) -> String {
        return "VitaminDReadFor\(userKey)OfIndex\(index)"
    }
    
    fileprivate var userKey: String!
    var measurement: MeasurementObjModel! {
        didSet{
            howUrls = collection.getRisk(measurement.riskKey!).howUrls
            userKey = measurement.playerKey!
            general.checked = userDefaults.bool(forKey: getPlannerDefaultKeyForUser(userKey, index: 0))
            individual.checked = userDefaults.bool(forKey: getPlannerDefaultKeyForUser(userKey, index: 1))
            source1.checked = userDefaults.bool(forKey: getPlannerDefaultKeyForUser(userKey, index: 2))
            source2.checked = userDefaults.bool(forKey: getPlannerDefaultKeyForUser(userKey, index: 3))
            source3.checked = userDefaults.bool(forKey: getPlannerDefaultKeyForUser(userKey, index: 4))
        }
    }
    
    func showGeneral(_ cell: ScorecardHowVitaminPlannerCell) {
        userDefaults.set(true, forKey: getPlannerDefaultKeyForUser(userKey, index: 0))
        userDefaults.synchronize()
        general.checked = true
        showWeb("Vitamin D Source Planner\n", subString: "For General Population", urlString: howUrls[0])
    }
    
    func showGeneralIntroduction(_ cell: ScorecardHowVitaminPlannerCell) {
        showIntroductionWeb(howUrls[4])
    }
    
    func showCalculator(_ cell: ScorecardHowVitaminPlannerCell) {
        individual.checked = true
        userDefaults.set(true, forKey: getPlannerDefaultKeyForUser(userKey, index: 1))
        userDefaults.synchronize()
        let calculator = ScorecardVitaminDCalculatorViewController()
        calculator.measurement = measurement
        viewController.presentOverCurrentViewController(calculator, completion: nil)
    }
    
    func showCalculatorIntroduction(_ cell: ScorecardHowVitaminPlannerCell) {
        showIntroductionWeb(howUrls[6])
    }
    
    @objc func showCompare() {
        showIntroductionWeb(howUrls[5])
    }
    
    @objc func showDosageIntroduction() {
        showIntroductionWeb(howUrls[7])
    }

    func showSource(_ cell: ScorecardHowVitaminPlannerCell) {
        userDefaults.set(true, forKey: getPlannerDefaultKeyForUser(userKey, index: cell.cellTag))
        userDefaults.synchronize()
        
        cell.checked = true
        showWeb("Vitamin D Source Planner\n", subString: cell.title, urlString:howUrls[cell.cellTag - 200])
    }
    
    fileprivate func showWeb(_ title: String, subString: String, urlString: String)  {
        let webVC = ScorecardWebDisplayViewController()
        webVC.setupWithTitle(title, subTitle: subString, urlString: urlString)
        viewController.presentOverCurrentViewController(webVC, completion: nil)
    }
    
    fileprivate func showIntroductionWeb(_ urlString: String)  {
        let webVC = WebViewDisplayViewController()
        webVC.setupWithUrlString(urlString)
        viewController.presentOverCurrentViewController(webVC, completion: nil)
    }
}
