//
//  ScorecardHowMainView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/25.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardHowMainView: UIScrollView, UIScrollViewDelegate {
    fileprivate let roadDraw = RoadDrawModel()
    fileprivate let hintImage = UIImageView(image: UIImage(named: "how_mainHint"))
    
    // main
    fileprivate var encorePair: ScorecardHowMainPair!
    fileprivate let assessmentPair = ScorecardHowMainPair()
    fileprivate let riskPair = ScorecardHowMainPair()
    fileprivate let generalPair = ScorecardHowMainPair()
   
    // sub cells
    fileprivate var encoreCell: ScorecardHowActionCell!
    fileprivate let assessCell = ScorecardHowActionCell()
    fileprivate var plannerCollectionView: ScorecardHowActionCollectionView!
    fileprivate var vitaminDPlannerView: ScorecardHowVitaminDPlannerView!
    fileprivate var vitaminPlannerView: ScorecardHowVitaminPlannerView!
    fileprivate let generalCell = ScorecardHowActionCell()
   
    fileprivate let assessImageView = UIImageView(image: UIImage(named: "how_conductor"))
    fileprivate let generalImageView = UIImageView(image: UIImage(named: "how_conductor"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBasic()
    }
    
    fileprivate func addBasic() {
        delegate = self
        self.bounces = false
        
        backgroundColor = UIColor.clear
        addSubview(hintImage)
        
        // main
        assessmentPair.addPairOnView(self, icon: UIImage(named: "how_main_assessment"), title: "Action Suggestions per Risk Assessment", color: UIColorFromHex(0x40E7BE))
        riskPair.addPairOnView(self, icon: #imageLiteral(resourceName: "how_main_planners"), title: "Action Planners", color: dosageColor)
        generalPair.addPairOnView(self, icon: #imageLiteral(resourceName: "tab_2_selected"), title: "General Action Planners", color: UIColorFromHex(0x768AFF))
        
        // cells
        assessCell.setupWithColor(UIColorFromHex(0x40E7BE), title: "Improve your score")
        addSubview(assessCell)
        let assessTap = UITapGestureRecognizer(target: self, action: #selector(goToRiskAssessmentSuggestion))
        assessCell.addGestureRecognizer(assessTap)
        
        generalCell.setupWithColor(UIColorFromHex(0x768AFF), title: "Tap to access Additional Action Planners")
        addSubview(generalCell)
        let generalTap = UITapGestureRecognizer(target: self, action: #selector(goToGeneralAction))
        generalCell.addGestureRecognizer(generalTap)

        assessImageView.contentMode = .scaleAspectFit
        addSubview(assessImageView)
        
        generalImageView.contentMode = .scaleAspectFit
        addSubview(generalImageView)
    }
    
    fileprivate var assessMeasurement: MeasurementObjModel!
    fileprivate var measurement: MeasurementObjModel!
    fileprivate var urlStrings = [String]()
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        self.measurement = measurement
        
        if let risk = collection.getRisk(measurement.riskKey) {
            urlStrings = risk.howUrls
            
            if let subjectName = risk.metric?.name {
                riskPair.setTitle("Action Planners for \(subjectName)")
            }
            
            let typeType = RiskTypeType.getTypeOfRiskType(risk.riskTypeKey!)
            if typeType != .iRa && typeType != .iCa && typeType != .iPa && typeType != .iAa {
                if let iraRisk = collection.getRiskModelKeys(risk.metricKey!, riskType: GameTintApplication.sharedTint.iRaKey).first {
                    assessMeasurement = selectionResults.getLastMeasurementOfUser(measurement.playerKey, riskKey: iraRisk, whatIf: false)
                }
            }else {
                assessMeasurement = measurement
            }
            
            // encore
            if assessMeasurement != nil {
//                assessCell.isChecked = userDefaults.bool(forKey: getAssessKey(assessMeasurement.riskKey!, userKey: assessMeasurement.playerKey))
                if MatchedCardsDisplayModel.showEncoreForMeasurement(assessMeasurement) {
                    if encorePair == nil {
                        encorePair = ScorecardHowMainPair()
                        encorePair.addPairOnView(self, icon: #imageLiteral(resourceName: "how_main_encore"), title: "Encore Scorecard", color: UIColorFromHex(0xD0FF9A))
                        encorePair.enableLeftAction()
                        encorePair.leftIsTouched = showEncoreIntroduction

                        // encore cell
                        encoreCell = ScorecardHowActionCell()
                        encoreCell.setupWithColor(UIColorFromHex(0xD0FF9A), title: "Encore Scorecard")
                        let encoreTap = UITapGestureRecognizer(target: self, action: #selector(getEncoreScorecard))
                        encoreCell.addGestureRecognizer(encoreTap)
                        addSubview(encoreCell)
//                        encoreCell.isChecked = userDefaults.bool(forKey: getEncoreKey(measurement.riskKey!, userKey: measurement.playerKey))
                    }
                }else {
                    // no need
                    if encorePair != nil {
                        encorePair.clearPair()
                        encorePair = nil
                    }
                    if encoreCell != nil {
                        encoreCell.removeFromSuperview()
                        encoreCell = nil
                    }
                }
            }
            
            // vitaminD
            riskPair.setMainColor(dosageColor)
            if risk.metricKey == vitaminDMetricKey {
                if vitaminDPlannerView == nil {
                    vitaminDPlannerView = ScorecardHowVitaminDPlannerView()
                    addSubview(vitaminDPlannerView)
                }
                vitaminDPlannerView.measurement = measurement
                vitaminDPlannerView.loadAllViews()
                
                // remove
                if plannerCollectionView != nil {
                    plannerCollectionView.removeFromSuperview()
                    plannerCollectionView = nil
                }
                
                if vitaminPlannerView != nil {
                    vitaminPlannerView.removeFromSuperview()
                    vitaminPlannerView = nil
                }
            }else if risk.metricKey == vitaminB12MetricKey || risk.metricKey == vitaminMgMetricKey {
                if vitaminPlannerView == nil {
                    vitaminPlannerView = ScorecardHowVitaminPlannerView()
                    addSubview(vitaminPlannerView)
                }
                riskPair.setMainColor((risk.metricKey == vitaminB12MetricKey) ? UIColorFromHex(0xFF6F86) : UIColorFromHex(0x00DB79))
                vitaminPlannerView.setupWithMeasurement(measurement)
                vitaminPlannerView.loadAllViews()
                
                if vitaminDPlannerView != nil {
                    vitaminDPlannerView.removeFromSuperview()
                    vitaminDPlannerView = nil
                }
                
                if plannerCollectionView != nil {
                    plannerCollectionView.removeFromSuperview()
                    plannerCollectionView = nil
                }
            }else {
                if plannerCollectionView == nil {
                    plannerCollectionView = ScorecardHowActionCollectionView.createWithColor(dosageColor, title: "Action Planners")
                    addSubview(plannerCollectionView)
                }
                plannerCollectionView.displayInfo = getDisplayInfoFromUrl(urlStrings.first!)
                
                if vitaminDPlannerView != nil {
                    vitaminDPlannerView.removeFromSuperview()
                    vitaminDPlannerView = nil
                }
                
                if vitaminPlannerView != nil {
                    vitaminPlannerView.removeFromSuperview()
                    vitaminPlannerView = nil
                }
            }
        }

        layoutWithFrame(frame)
    }
    
    fileprivate func getDisplayInfoFromUrl(_ urlString: String) -> [(String, String)] {
        var urlAppends = [String]()
        if let urlsStartIndex = urlString.range(of: "urls=")?.upperBound {
            let fileNames = String(urlString.suffix(from: urlsStartIndex))
            urlAppends = fileNames.components(separatedBy: ",")
        }
        
        // display
        var displayInfo = [(String, String)]()
        for (i, name) in urlAppends.enumerated() {
            let subUrlString = "\(pagesBaseUrl)public/\(name)/"
            if let subUrl = URL(string: subUrlString) {
                var title: String!
                // get html
                do {
                    let htmlString = try String(contentsOf: subUrl, encoding: .utf8)
                    let start = "<title>"
                    let end = "</title>"
                    if let startOffset = htmlString.range(of: start)?.upperBound {
                        if let endOffset = htmlString.range(of: end)?.lowerBound {
                            title = String(htmlString[startOffset..<endOffset])
                        }
                    }
                }catch {
                    
                }
                displayInfo.append((title ?? name, "\(urlString)&index=\(i)"))
            }
        }
        
        return displayInfo
    }
    
    // user defaults keys
    fileprivate func getEncoreKey(_ riskKey: String, userKey: String) -> String {
        return "\(riskKey)EncoreIsReadFor\(userKey)"
    }
    
    fileprivate func getAssessKey(_ riskKey: String, userKey: String) -> String {
        return "\(riskKey)AssessIsReadFor\(userKey)"
    }
    fileprivate func getPlannerKey(_ riskKey: String, userKey: String, index: Int) -> String {
        return "\(riskKey)PlannerIsReadOfIndex\(index)For\(userKey)"
    }
    
    
    // MARK: -----------------  Layout
    fileprivate var leftRect = CGRect.zero
    fileprivate var generalRect = CGRect.zero
    func layoutWithFrame(_ frame: CGRect) {
        self.frame = frame
        
        let oneH = bounds.height / 471
        let oneW = bounds.width / 353
        let minOne = min(oneH, oneW)
        
        let leftC = 65 * oneW
        let rightX = 115 * oneW
        let mainH = 55 * minOne
        let cellL = 65 * minOne
        let topicGap = 25 * oneH
        let subGap = 5 * oneH
        
        let leftX = leftC - mainH * 0.5
        let mainWidth = bounds.width - leftX - mainH * 0.5 // 248 * oneW
        
        // image
        hintImage.frame = CGRect(x: leftC - minOne * 23, y: 5 * minOne, width: 161 * minOne, height: 56 * minOne)
        var maxY = hintImage.frame.maxY
        var anchorInfo = [(CGPoint, Bool)]()
        // encore
        if encorePair != nil {
            encorePair.layoutWithFrame(CGRect(x: leftX, y: maxY - subGap, width: mainWidth, height: mainH), rightStartX: rightX)
            anchorInfo.append((CGPoint(x: leftC, y: maxY), false))
            maxY += mainH
            encoreCell.frame = CGRect(x: rightX, y: maxY, width: cellL, height: cellL)
            maxY += cellL + topicGap
            anchorInfo.append((CGPoint(x: leftC - 27 * oneW, y: encoreCell.frame.midY), false))
        }
        
        // assess
        assessmentPair.layoutWithFrame(CGRect(x: leftX, y: maxY, width: mainWidth, height: mainH), rightStartX: rightX)
        anchorInfo.append((CGPoint(x: leftC, y: maxY + mainH * 0.5), false))
        maxY += mainH + subGap
        
        assessCell.frame = CGRect(x: rightX, y: maxY, width: cellL * 2, height: cellL)
        maxY += cellL + topicGap
        anchorInfo.append((CGPoint(x: leftC + 27 * oneW, y: assessCell.frame.midY), false))
        
        assessImageView.frame = CGRect(x: assessCell.frame.maxX, y: assessCell.frame.minY, width: bounds.width - assessCell.frame.maxX, height: assessCell.frame.height).insetBy(dx: 10 * oneW, dy: -oneH * 5)
        
        // planner
        riskPair.layoutWithFrame(CGRect(x: leftX, y: maxY, width: mainWidth, height: mainH), rightStartX: rightX)
        anchorInfo.append((CGPoint(x: leftC - 15 * oneW, y: maxY + mainH * 0.5), false))
        maxY += subGap + mainH
        
        // add
        if plannerCollectionView != nil {
            plannerCollectionView.frame = CGRect(x: rightX, y: maxY, width: bounds.width - rightX, height: cellL)
            maxY += cellL + topicGap
            anchorInfo.append((CGPoint(x: leftC - 27 * oneW, y: maxY - cellL * 0.5), false))
        }
        
        if vitaminDPlannerView != nil {
            vitaminDPlannerView.setupFrameWithOrigin(CGPoint(x: rightX, y: maxY), blockWidth: mainWidth - rightX + leftX, cellHeight: 35 * minOne)
            maxY = vitaminDPlannerView.frame.maxY + topicGap
            anchorInfo.append((CGPoint(x: leftC - 35 * oneW, y: vitaminDPlannerView.frame.minY + cellL), false))
            anchorInfo.append((CGPoint(x: leftC - 15 * oneW, y: vitaminDPlannerView.frame.minY + cellL * 2), false))
            anchorInfo.append((CGPoint(x: leftC + 15 * oneW, y: vitaminDPlannerView.frame.maxY - cellL), false))
            anchorInfo.append((CGPoint(x: leftC - 17 * oneW, y: maxY - mainH * 0.5), false))
        }
        
        if vitaminPlannerView != nil {
            vitaminPlannerView.setupFrameWithOrigin(CGPoint(x: rightX, y: maxY), blockWidth: mainWidth - rightX + leftX, cellHeight: 35 * minOne)
            maxY = vitaminPlannerView.frame.maxY + topicGap
            anchorInfo.append((CGPoint(x: leftC - 35 * oneW, y: vitaminPlannerView.frame.minY + cellL), false))
            anchorInfo.append((CGPoint(x: leftC - 15 * oneW, y: vitaminPlannerView.frame.minY + cellL * 2), false))
        }
        
        // general
        generalPair.layoutWithFrame(CGRect(x: leftX, y: maxY, width: mainWidth, height: mainH), rightStartX: rightX)
        generalRect = CGRect(x: rightX, y: maxY, width: mainWidth - rightX + leftX, height: mainH).insetBy(dx: minOne, dy: 3 * minOne)
        anchorInfo.append((CGPoint(x: leftC + 10 * oneW, y: maxY + mainH * 0.5), false))
        
        maxY += subGap + mainH
        
        generalCell.frame = CGRect(x: rightX, y: maxY, width: cellL * 2, height: cellL)

        maxY += cellL
        anchorInfo.append((CGPoint(x: leftC, y: maxY), false))
        generalImageView.frame = CGRect(x: generalCell.frame.maxX, y: generalCell.frame.minY, width: bounds.width - generalCell.frame.maxX, height: generalCell.frame.height).insetBy(dx: 10 * oneW, dy: -oneH * 5)
            
        maxY += subGap
        
        // all
        contentSize = CGSize(width: frame.width, height: max(frame.height, maxY))
        leftRect = CGRect(x: 0, y: 0, width: 120 * oneW, height: contentSize.height)
        
        // road
        anchorInfo.append((CGPoint(x: leftC - 27 * oneW, y: contentSize.height), false))
        roadDraw.startPoint = CGPoint(x: leftC, y: hintImage.frame.midY)
        roadDraw.roadWidth = 14 * minOne
        roadDraw.turningRadius = 20 * oneH
        roadDraw.anchorInfo = anchorInfo
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        roadDraw.drawRoadWithMaxX(leftRect.maxX)
    }
    
    // MARK:  ------------------------ Actions
    // introductions
    func showEncoreIntroduction() {
        
    }
    
    // show detail
    // show encore card
    @objc func getEncoreScorecard() {
        userDefaults.set(true, forKey: getEncoreKey(measurement.riskKey!, userKey: measurement.playerKey))
        userDefaults.synchronize()
//        encoreCell.isChecked = true
        let encore = EncoreCardDisplayViewController()
        encore.riskKey = assessMeasurement.riskKey
        viewController.presentOverCurrentViewController(encore, completion: nil)
    }
    
    // show assessment suggestion
    @objc func goToRiskAssessmentSuggestion() {
        if assessMeasurement != nil {
//            assessCell.isChecked = true
            userDefaults.set(true, forKey: getAssessKey(measurement.riskKey!, userKey: measurement.playerKey))
            userDefaults.synchronize()
            let assessment = ScorecardHowAssessmentViewController()
            assessment.measurement = assessMeasurement
            viewController.presentOverCurrentViewController(assessment, completion: nil)
        }else {
            // go to ira
            goToIRaGame()
        }
    }
    
    // go to iRa
    func goToIRaGame() {
        let alert = CatCardAlertViewController()
        alert.addTitle("You should play iRa first to get assessment", subTitle:"or check others now", buttonInfo:[("Go Play Now", false, goToPlayIRa), ("Later", true, nil)])
        viewController.presentOverCurrentViewController(alert, completion: nil)
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
    
    // general
    @objc func goToGeneralAction() {
        let intro = WebViewDisplayViewController()
        intro.showGradientBorder = false
        
        intro.setupWithUrlString(urlStrings.last ?? "\(pagesBaseUrl)public/TabAction/")
        viewController.presentOverCurrentViewController(intro, completion: nil)
    }
    
    // road
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNeedsDisplay()
    }
}
