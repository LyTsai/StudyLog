//
//  ScorecardHowMainView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/25.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardHowMainView: UIScrollView {
    fileprivate let roadDraw = RoadDrawModel()
    fileprivate let hintImage = UIImageView(image: UIImage(named: "how_mainHint"))
    fileprivate let encoreIntro = BorderImageControl.createWithIcon(UIImage(named: "how_main_encore"), circleColor: UIColorFromHex(0xE5FFC8))
    fileprivate let assessIntro = BorderImageControl.createWithIcon(UIImage(named: "how_main_assessment"), circleColor: UIColorFromHex(0x40E7BE))
    fileprivate let plannerIntro = BorderImageControl.createWithIcon(UIImage(named: "how_main_planners"), circleColor: dosageColor)
    fileprivate let otherIntro = BorderImageControl.createWithIcon(UIImage(named: "how_main_other"), circleColor: UIColorFromHex(0x768AFF))
    fileprivate let encoreView = GradientLabelView()
    fileprivate let assessView = GradientLabelView()
    fileprivate let plannerView = GradientLabelView()
    fileprivate let otherView = GradientLabelView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func addBasic() {
        backgroundColor = UIColor.clear
        addSubview(hintImage)
        
        // round buttons
        addSubview(encoreIntro)
        addSubview(assessIntro)
        addSubview(plannerIntro)
        addSubview(otherIntro)
        
        // right
        encoreView.setupWithTopColor(UIColorFromHex(0xE5FFC8), bottomColor: UIColorFromHex(0xE5FFC8), text: "Encore Scorecard")
        assessView.setupWithTopColor(UIColorFromHex(0xCDFFF2), bottomColor: UIColorFromHex(0x40E7BE), text: "Action Suggestions per Risk Assessment")
        plannerView.setupWithTopColor(UIColorFromHex(0xFFEA99), bottomColor: dosageColor, text: "Action Planners")
        otherView.setupWithTopColor(UIColorFromHex(0xCBD3FF), bottomColor: UIColorFromHex(0x768AFF), text: "General Action Planners")

        addSubview(encoreView)
        addSubview(assessView)
        addSubview(plannerView)
        addSubview(otherView)
        
        // add actions
        encoreView.tag = 200
        assessView.tag = 201
        plannerView.tag = 202
        otherView.tag = 203
        
        encoreIntro.addTarget(self, action: #selector(getIntrodution(_:)), for: .touchUpInside)
        encoreView.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
        assessView.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
        plannerView.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
        otherView.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
        
        encoreView.layer.addBlackShadow(4 * fontFactor)
        assessView.layer.addBlackShadow(4 * fontFactor)
        plannerView.layer.addBlackShadow(4 * fontFactor)
        otherView.layer.addBlackShadow(4 * fontFactor)
    }
    
    fileprivate var withEncore = false
    fileprivate var assessMeasurement: MeasurementObjModel!
    fileprivate var measurement: MeasurementObjModel!
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        self.measurement = measurement
        if let risk = collection.getRisk(measurement.riskKey) {
            
            if let subjectName = risk.metric?.name {
            plannerView.setupWithTopColor(UIColorFromHex(0xFFEA99), bottomColor: dosageColor, text: "Action Planners for " + subjectName)
            }
            
            let typeType = RiskTypeType.getTypeOfRiskType(risk.riskTypeKey!)
            if typeType != .iRa && typeType != .iCa && typeType != .iPa && typeType != .iAa {
                if let iraRisk = collection.getRiskModelKeys(risk.metricKey!, riskType: GameTintApplication.sharedTint.iRaKey).first {
                    assessMeasurement = selectionResults.getLastMeasurementOfUser(measurement.playerKey, riskKey: iraRisk, whatIf: false)
                }
            }else {
                assessMeasurement = measurement
            }
            
            if assessMeasurement != nil {
                withEncore = MatchedCardsDisplayModel.showEncoreForMeasurement(assessMeasurement)
            }else {
                assessView.textLabel.text = "Go to iRa Game for assessment"
            }
        }

        layoutWithFrame(frame)
    }
    
    
    // Layout
    fileprivate var leftRect = CGRect.zero
    func layoutWithFrame(_ frame: CGRect) {
        self.frame = frame
        
        let oneH = bounds.height / 471
        let oneW = bounds.width / 353
        let minOne = min(oneH, oneW)
        
        let leftC = 60 * oneW
        hintImage.frame = CGRect(x: leftC - minOne * 23, y: 20 * oneH, width: 161 * minOne, height: 56 * minOne)
        leftRect = CGRect(x: 0, y: 0, width: 120 * oneW, height: bounds.height)
        
        let introL = 58 * minOne
        let gap = (withEncore ? 34 * oneH : 45 * oneH) + introL
        var introY = hintImage.frame.maxY + gap * 0.8
        encoreIntro.frame = withEncore ? CGRect(center: CGPoint(x: leftC, y: introY), length: introL) : CGRect.zero
        introY += withEncore ? gap : 0
        assessIntro.frame = CGRect(center: CGPoint(x: leftC, y: introY), length: introL)
        introY += gap
        plannerIntro.frame = CGRect(center: CGPoint(x: leftC, y: introY), length: introL)
        introY += gap
        otherIntro.frame = CGRect(center: CGPoint(x: leftC, y: introY), length: introL)
        
        let itemSize = CGSize(width: 175 * oneW, height: 45 * oneH)
        let itemX = 127 * oneW
        if withEncore {
            encoreView.frame = CGRect(x: itemX, y: encoreIntro.center.y - itemSize.height * 0.5, width: itemSize.width, height: itemSize.height)
            encoreView.addBorder(.allCorners, borderWidth: minOne, cornerRadius: 4 * minOne)
        }else {
            encoreView.frame = CGRect.zero
        }
        
        assessView.frame = CGRect(x: itemX, y: assessIntro.center.y - itemSize.height * 0.5, width: itemSize.width, height: itemSize.height)
        assessView.addBorder(.allCorners, borderWidth: minOne, cornerRadius: 4 * minOne)
        plannerView.frame = CGRect(x: itemX, y: plannerIntro.center.y - itemSize.height * 0.5, width: itemSize.width, height: itemSize.height)
        otherView.frame = CGRect(x: itemX, y: otherIntro.center.y - itemSize.height * 0.5, width: itemSize.width, height: itemSize.height)
        plannerView.addBorder(.allCorners, borderWidth: minOne, cornerRadius: 4 * minOne)
        otherView.addBorder(.allCorners, borderWidth: minOne, cornerRadius: 4 * minOne)
        
        // road
        roadDraw.startPoint = CGPoint(x: leftC, y: hintImage.frame.midY)
        roadDraw.roadWidth = 14 * minOne
        roadDraw.turningRadius = 10 * minOne
        let anchorInfo = [(CGPoint(x: leftC, y: assessIntro.frame.minY + 9 * oneH), false),(CGPoint(x: 30 * oneW, y: assessIntro.frame.minY + 9 * oneH), false), (CGPoint(x: 30 * oneW, y: assessIntro.frame.maxY + 18 * oneH),false), (CGPoint(x: 88 * oneW, y: assessIntro.frame.maxY + 18 * oneH), false), (plannerIntro.center, false), (CGPoint(x: 18 * oneW, y: otherIntro.center.y), false), (CGPoint(x: 100 * oneW, y: otherIntro.center.y), false), (CGPoint(x: 88 * oneW, y: bounds.height), false)]
        roadDraw.anchorInfo = anchorInfo
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        roadDraw.drawRoadInRect(leftRect)
        
        let linePath = UIBezierPath()
        
        if withEncore {
            linePath.move(to: encoreIntro.center)
            linePath.addLine(to: encoreView.center)
        }
        
        linePath.move(to: assessIntro.center)
        linePath.addLine(to: assessView.center)
        linePath.move(to: plannerIntro.center)
        linePath.addLine(to: plannerView.center)
        linePath.move(to: otherIntro.center)
        linePath.addLine(to: otherView.center)
        
        linePath.lineWidth = bounds.height / 471
        UIColor.black.setStroke()
        linePath.stroke()
    }
    
    // actions
    // introduction
    @objc func getIntrodution(_ sender: UIControl) {
        let intro = WebViewDisplayViewController()
        intro.setupWithUrlString(nil)
        viewController.presentOverCurrentViewController(intro, completion: nil)
    }
    
    // label
    @objc func goToNext(_ sender: UIControl) {
        switch sender.tag {
        case 200:
            // show encore card
            let encore = EncoreCardDisplayViewController()
            encore.riskKey = assessMeasurement.riskKey
            viewController.presentOverCurrentViewController(encore, completion: nil)
        case 201:
            if assessMeasurement != nil {
                // show assessment
                let action = ScorecardActionViewController()
                action.measurement = assessMeasurement
                action.riskKey = measurement.riskKey!
                action.userKey = measurement.userKey!
                action.index = 0
                viewController.presentOverCurrentViewController(action, completion: nil)
            }else {
                // go to iRa
                let alert = UIAlertController(title: "You should play iRa first to get assessment", message: "or check others now", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Later", style: .default, handler: { (action) in
                })
                let action2 = UIAlertAction(title: "Go Play Now", style: .default, handler: { (action) in
                    self.goToPlayIRa()
                })
                alert.addAction(action1)
                alert.addAction(action2)
                
                viewController.present(alert, animated: true, completion: nil)
            }
        case 202, 203:
            // action planners
            let action = ScorecardActionViewController()
            action.riskKey = measurement.riskKey!
            action.userKey = measurement.userKey!
            action.measurement = assessMeasurement
            action.index = sender.tag - 201
            viewController.presentOverCurrentViewController(action, completion: nil)
        default: break
        }
    }
    
    fileprivate func goToPlayIRa() {
        // iRa game
        cardsCursor.riskTypeKey = GameTintApplication.sharedTint.iRaKey
        cardsCursor.selectedRiskClassKey = collection.getRisk(measurement.riskKey).metricKey
        
        if let navi = navigation {
            for vc in navi.viewControllers {
                // first tab
                if vc.isKind(of: IntroPageViewController.self) {
                    navi.popToViewController(vc, animated: true)
                    return
                }
            }
            
            let intro = IntroPageViewController()
            viewController.hidesBottomBarWhenPushed = false
            navi.pushViewController(intro, animated: true)
        }
    }
    
//    fileprivate func showWeb(_ urlString: String!) {
//        let intro = WebViewDisplayViewController()
//        intro.setupWithUrlString(urlString)
//        viewController.presentOverCurrentViewController(intro, completion: nil)
//    }
}
