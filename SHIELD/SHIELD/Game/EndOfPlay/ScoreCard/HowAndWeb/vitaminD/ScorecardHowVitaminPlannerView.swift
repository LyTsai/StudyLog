//
//  ScorecardHowVitaminPlannerView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/4/1.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardHowVitaminPlannerView: UIView {
    var blockColor = UIColor.red
    var color = UIColor.orange
    var topTitle = ""
    var bottomTitle = ""
    
    // detail
    var topIntroUrl: String?
    var bottomIntroUrl: String?
    
    var plannerInfo = [(title: String, url: String?, intro: String?)]()
    var topNumber = 1
    fileprivate var plannerCells = [ScorecardHowVitaminPlannerCell]()
    fileprivate var topIntroButton: UIButton!
    
    func loadAllViews() {
        // init
        for view in subviews {
            view.removeFromSuperview()
        }
        plannerCells.removeAll()

        self.backgroundColor = UIColor.clear
        
        // create
        // top
        for (i, planner) in plannerInfo.enumerated() {
            let plannerCell = ScorecardHowVitaminPlannerCell()
            plannerCell.placeCellOnView(self, color: color, title: planner.title, mark: (planner.intro != nil))
            plannerCell.cellTag = 100 + i
            plannerCell.markIsTouched = showIntroduction
            plannerCell.cellIsTouched = showPlanner
            plannerCells.append(plannerCell)
            plannerCell.checked = userDefaults.bool(forKey: getPlannerDefaultKeyForIndex(i))
        }
        
        if topIntroUrl != nil {
            topIntroButton = UIButton(type: .custom)
            topIntroButton.setBackgroundImage(#imageLiteral(resourceName: "button_rectMark"), for: .normal)
            topIntroButton.addTarget(self, action: #selector(showTopIntroduction), for: .touchUpInside)
            addSubview(topIntroButton)
        }
    }
    
    fileprivate var oneLine: CGFloat = 0
    fileprivate var topRect = CGRect.zero
    fileprivate var bottomRect = CGRect.zero
    fileprivate var topAttri: NSAttributedString!
    fileprivate var bottomAttri: NSAttributedString!
    fileprivate var topH: CGFloat = 0
    fileprivate var bottomH: CGFloat = 0
    fileprivate var compareRect = CGRect.zero
    func setupFrameWithOrigin(_ origin: CGPoint, blockWidth: CGFloat, cellHeight: CGFloat) {
        oneLine = cellHeight / 35
        let gap = oneLine * 15
        
        // texts and overall
        let titleFont = UIFont.systemFont(ofSize: 12 * oneLine, weight: .medium)
        topAttri = NSAttributedString(string: topTitle, attributes: [.font: titleFont])
        topH = topAttri.boundingRect(with: CGSize(width: blockWidth - oneLine, height: blockWidth), options: .usesLineFragmentOrigin, context: nil).height + gap
        topRect = CGRect(x: 0, y: 0, width: blockWidth, height: topH + (cellHeight + gap) * CGFloat(topNumber)).insetBy(dx: oneLine * 0.5, dy: oneLine * 0.5)
        
        bottomAttri = NSAttributedString(string: bottomTitle, attributes: [.font: titleFont])
        bottomH = bottomAttri.boundingRect(with: CGSize(width: blockWidth - oneLine, height: blockWidth), options: .usesLineFragmentOrigin, context: nil).height + gap
        bottomRect = CGRect(x: 0, y: topRect.maxY + gap, width: blockWidth, height: bottomH + (cellHeight + gap) * CGFloat(plannerInfo.count - topNumber)).insetBy(dx: oneLine * 0.5, dy: oneLine * 0.5)
        // resize
        self.frame = CGRect(origin: origin, size: CGSize(width: blockWidth, height: bottomRect.maxY + gap))
        
        // layout all
        let marginX = blockWidth * 14 / 165
        // top
        var currentY = topH
        for (i, cell) in plannerCells.enumerated() {
            cell.layoutWithFrame(CGRect(x: marginX, y: currentY, width: blockWidth - 2 * marginX, height: cellHeight))
            
            // last top item
            if i == topNumber - 1 {
                currentY = bottomRect.minY + bottomH
            }else {
                // next y
                currentY += (gap + cellHeight)
            }
        }
        
        if topIntroButton != nil {
            topIntroButton.frame = CGRect(x: topRect.maxX - 12 * oneLine, y: topRect.maxY - gap, width: 10 * oneLine, height: 11 * oneLine)
        }
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        // border
        let path = UIBezierPath(roundedRect: topRect, cornerRadius: 4 * oneLine)
        path.append(UIBezierPath(roundedRect: bottomRect, cornerRadius: 4 * oneLine))
        path.lineWidth = oneLine
        blockColor.setStroke()
        path.stroke()
        
        // texts
        drawString(topAttri, inRect: CGRect(x: topRect.minX, y: topRect.minY, width: topRect.width, height: topH), alignment: .center)
        drawString(bottomAttri, inRect: CGRect(x: bottomRect.minX, y: bottomRect.minY, width: topRect.width, height: bottomH), alignment: .center)
    }
    
    // data
    fileprivate var playerKey: String!
    fileprivate var metricKey: String!
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        let risk = collection.getRisk(measurement.riskKey)!
        playerKey = measurement.playerKey
        metricKey = risk.metricKey!
        
        let howUrls = risk.howUrls
        var mainString = ""
        if metricKey == vitaminMgMetricKey {
            blockColor = UIColorFromHex(0x00DB79)
            color = UIColorFromHex(0x90FBCB)
            mainString = "Magnesium"
        }else if metricKey == vitaminB12MetricKey {
            blockColor = UIColorFromHex(0xFF6F86)
            color = UIColorFromHex(0xFF9EAF)
            mainString = "Vitamin B12"
        }
        
        topTitle = "\(mainString) Daily Dosage Planner"
        bottomTitle = "\(mainString) Source Planner"
        plannerInfo = [("Generic RDA for General Population", subjectUrlStringAtIndex(0, ofArray: howUrls), subjectUrlStringAtIndex(3, ofArray: howUrls)),
                       ("Food Sources", subjectUrlStringAtIndex(1, ofArray: howUrls), nil),
                       ("Supplements", subjectUrlStringAtIndex(2, ofArray: howUrls) ,nil)]
        topIntroUrl = subjectUrlStringAtIndex(4, ofArray: howUrls)
    }
    fileprivate func subjectUrlStringAtIndex(_ index: Int, ofArray array: [String]) -> String? {
        // ignore the last index, it is for general action planners
        if index < 0 || index >= array.count - 1 {
            return nil
        }
        return array[index]
    }

    fileprivate var howUrls = [String]()
    fileprivate func getPlannerDefaultKeyForIndex(_ index: Int) -> String {
        return "\(String(describing: metricKey))ReadFor\(String(describing: playerKey))OfIndex\(index)"
    }
    
    func showPlanner(_ cell: ScorecardHowVitaminPlannerCell) {
        let cellIndex = cell.cellTag - 100
        userDefaults.set(true, forKey: getPlannerDefaultKeyForIndex(cellIndex))
        userDefaults.synchronize()
        
        cell.checked = true
        
        if let urlString = plannerInfo[cellIndex].url {
            let webVC = ScorecardWebDisplayViewController()
            webVC.setupWithTitle("\(cellIndex < topNumber ? topTitle : bottomTitle)\n" , subTitle: cell.title, urlString: urlString)
            viewController.presentOverCurrentViewController(webVC, completion: nil)
        }
    }
    
    func showIntroduction(_ cell: ScorecardHowVitaminPlannerCell)  {
        let cellIndex = cell.cellTag - 100
        if let urlString = plannerInfo[cellIndex].intro {
            let webVC = WebViewDisplayViewController()
            webVC.setupWithUrlString(urlString)
            viewController.presentOverCurrentViewController(webVC, completion: nil)
        }
    }
    
    @objc func showTopIntroduction() {
        if topIntroUrl != nil {
            let webVC = WebViewDisplayViewController()
            webVC.setupWithUrlString(topIntroUrl!)
            viewController.presentOverCurrentViewController(webVC, completion: nil)
        }
    }
}
