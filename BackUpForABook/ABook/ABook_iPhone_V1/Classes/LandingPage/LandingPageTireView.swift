//
//  LandingPageTireView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/1/10.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
// pass key for button

class LandingPageTireView: UIView {
    // properties for UI
//    var maxIndex: Int = 0
    var arrowAngle: CGFloat = -CGFloat(M_PI/2.0)
    
    // properties for push
    weak var hostVC: ABookLandingPageViewController!
    
    // MARK: --------------- creating -----------------
    class func createWithFrame(_ frame: CGRect, landingModel: LandingModel) -> LandingPageTireView {
        let landing = LandingPageTireView()
        landing.setupWithFrame(frame, landingModel: landingModel)
        
        return landing
    }
    
    // set up
    fileprivate var viewCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    fileprivate var landingModel: LandingModel!
    
    func setupWithFrame(_ frame: CGRect, landingModel: LandingModel) {
        // prepare
        for view in subviews {
            view.removeFromSuperview()
        }
        
        layer.sublayers = nil
        
        if frame.height < frame.width {
            print("wrong size, please change")
        }
        
        self.frame = frame
        self.landingModel = landingModel
        
        // background
        backgroundColor = UIColor.clear

        addTireThree()
        addTireTwo()
        addTireOne()
        addSurroundings()
        
        let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(pinchPlate(_:)))
        addGestureRecognizer(pinchGR)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(originalSize(_:)))
        addGestureRecognizer(tapGR)
    }
    
    // gestures
    func pinchPlate(_ pinch: UIPinchGestureRecognizer)  {
        transform = transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1
    }
    
    func originalSize(_ tapGR: UITapGestureRecognizer) {
        tapGR.numberOfTapsRequired = 2
        transform = CGAffineTransform.identity
    }
    
    // each part
    fileprivate func addTireThree() {
        let radius = 0.47 * bounds.width
        let innerRadius = 0.027 * bounds.width
        
        let tireThreePlate = PieView()
        let tireThree = landingModel.tireThree
        tireThreePlate.setupWithFrame(CGRect(center: viewCenter, length: 2 * radius), innerRadius: innerRadius, numberOfSlices: tireThree.count, enlargeAngle: CGFloat(-M_PI_2))
        addSubview(tireThreePlate)
        
        // set up image and key
        for (index, metricInfo) in tireThree.enumerated() {
            let button = tireThreePlate.buttonsOnView[index]
            button.riskClassKey = metricInfo.key
            button.riskClassImage = metricInfo.value
            button.addTarget(self, action: #selector(tireClicked(_:)), for: .touchUpInside)
        }
        
        // UI
        tireThreePlate.layer.cornerRadius = radius
        tireThreePlate.layer.borderColor = UIColor.darkGray.cgColor
        tireThreePlate.layer.borderWidth = 1
        tireThreePlate.layer.addBlackShadow(4)
    }
    
    // plate and two
    fileprivate let plateLayer = CALayer()
    fileprivate func addTireTwo() {
        // ------------ plate -----------
        let plateRadius = 0.26 * bounds.width
        
        // the green plate
        plateLayer.frame = CGRect(center: viewCenter, length: 2 * plateRadius)
        plateLayer.contents = UIImage(named: "plate")!.cgImage
        plateLayer.cornerRadius = plateRadius
        plateLayer.addBlackShadow(8)
        layer.addSublayer(plateLayer)
        
        // the shadow of tireTwo's buttons
        let shadowLayer = CAShapeLayer()
        let shadowPath = UIBezierPath()
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.addBlackShadow(5)
        layer.addSublayer(shadowLayer)
        // ------------- two ----------------
        
        // MARK: ------- for better visual now, should modify for dynamic choices -----------------
        let tireTwo = landingModel.tireTwo
        let length = 0.189 * bounds.width

        for (i, info) in tireTwo.enumerated() {
            let button = RiskClassButton(type: .custom)
        
            // set up frame
            let angle = Calculation().getAngle(i, totalNumber: tireTwo.count, startAngle: CGFloat(M_PI) / 4, endAngle: 9 * CGFloat(M_PI) / 4)
            let position = Calculation().getPositionByAngle(angle, radius: sqrt(2) / 2 * length, origin: viewCenter)
            button.frame = CGRect(center: position, length: length)
            shadowPath.append(UIBezierPath(ovalIn: button.frame))
            
            button.riskClassKey = info.metricKey
            button.riskClassImage = UIImage(named: info.imageName)
            button.addTarget(self, action: #selector(tireClicked(_:)), for: .touchUpInside)
            addSubview(button)
        }
       // --------------------------- for better visual -----------------
        shadowLayer.path = shadowPath.cgPath
    }
    
    // -------------- one ---------------
    fileprivate func addTireOne() {
        let tireOne = RiskClassButton(type: .custom)
        tireOne.setBackgroundImage(UIImage(named: "tireOne"), for: .normal)
        tireOne.addTarget(self, action: #selector(tireOneClicked), for: .touchUpInside)
        tireOne.frame = CGRect(center: viewCenter, length: 0.17 * bounds.width)
        
        addSubview(tireOne)
    }
    
    // ---------- surroundings ----------
//    fileprivate var postions = [CGPoint]()
    
    fileprivate func addSurroundings() {
        // metric
        let surroundings = landingModel.surroundings
        
        // size
        let attachLength = 0.06 * bounds.width
        let attachRadius = 0.56 * bounds.width
        let confinedAngle = acos((bounds.width - attachLength) * 0.5 / attachRadius)
        let usableAngle = CGFloat(M_PI) - confinedAngle * 2
        let maxHalfNumber = 1 + Int(usableAngle * attachRadius * 2 / (attachLength) * CGFloat(M_PI))
        let maxNumber = min(2 * maxHalfNumber,surroundings.count)
        
        let realHalf = maxNumber / 2 + ((maxNumber % 2 == 0) ? 0 : 1)
        
        let subGap = Calculation().angleGap(realHalf - 1, totalAngle: usableAngle)
        for (i, metric) in surroundings.enumerated() {
            if i >= maxNumber {
                break
            }
            
            var angle = confinedAngle + subGap * CGFloat(i)
            if angle > (CGFloat(M_PI) - confinedAngle) {
                angle += 2 * confinedAngle
            }

            // show and lines
            let button = RiskClassButton(type: .custom)
    
            let position = Calculation().getPositionByAngle(angle, radius: attachRadius, origin: viewCenter)
            button.frame = CGRect(center: position, length: attachLength)
            button.addTarget(self, action: #selector(metricClicked(_:)), for: .touchUpInside)
            
            addSubview(button)
        }
    }

    // MARK: ------------ actions ------------------------
    // click
    // the center
    func tireOneClicked() {
         hostVC.navigationController?.pushViewController(DoEasyViewController(), animated: true)
    }
    
    func tireClicked(_ button: RiskClassButton) {
        let hostNavigationDelegate = hostVC.navigationController
        if  hostNavigationDelegate == nil {
            print("not added yet")
            return
        }
        
        RiskMetricCardsCursor.sharedCursor.selectedRiskClassKey = button.riskClassKey!
        hostNavigationDelegate!.pushViewController(IntroPageViewController(), animated: true)
    }
    
    
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    func metricClicked(_ button: RiskClassButton)  {
        let hostNavigationDelegate = hostVC.navigationController
        if hostNavigationDelegate == nil {
            print("not added yet")
            return
        }
    }
}

