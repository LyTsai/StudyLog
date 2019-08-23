//
//  FRGuideView.swift
//  FacialRejuvenationByDesign
//
//  Created by L on 2019/6/12.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation

class FRGuideView: UIView {
    var currentColor = projectTintColor
    var normalColor = UIColorGray(155)
    
    // create
    class func createWithFrame(_ frame: CGRect, titles: [String]) -> FRGuideView {
        let guideView = FRGuideView(frame: frame)
        guideView.setupWithTitles(titles)
        guideView.layoutGuides()
        
        return guideView
    }
    
    fileprivate var guides = [CustomColorButton]()
    func setupWithTitles(_ titles: [String]) {
        // remove
        for guide in guides {
            guide.removeFromSuperview()
        }
        guides.removeAll()
        
        // add
        for title in titles {
            let guide = CustomColorButton(type: .custom)
            guide.setTitle(title)
            guide.layer.addBlackShadow(4)
            
            // add
            addSubview(guide)
            guides.append(guide)
        }
    }
    
    func layoutGuides()  {
        if guides.isEmpty {
            return
        }
        
        // calculate
        let floatNumber = CGFloat(guides.count)
        let gap = bounds.height * 0.9
        let oneLength = (bounds.width - (floatNumber - 1) * gap) / floatNumber
        for (i, guide) in guides.enumerated() {
            guide.frame = CGRect(x: (oneLength + gap) * CGFloat(i), y: 0, width: oneLength, height: bounds.height)
        }
    }
    
    fileprivate var currentIndex = 0
    func setCurrent(_ current: Int) {
        currentIndex = current
        
        for (i, guide) in guides.enumerated() {
            if i == current {
                guide.backgroundColor = currentColor
                guide.setMainColor(UIColor.black)
                guide.layer.shadowColor = UIColor.black.cgColor
            }else {
                guide.backgroundColor = UIColor.white
                guide.setMainColor(normalColor)
                guide.layer.shadowColor = UIColor.clear.cgColor
            }
        }
        
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutGuides()
        setNeedsDisplay()
    }

    
    // lines
    override func draw(_ rect: CGRect) {
        let backPath = UIBezierPath()
        var topPath: UIBezierPath!
        for (i, guide) in guides.enumerated() {
            // last, not draw
            if i == guides.count - 1 {
               continue
            }
            
            let leftPoint = guide.center
            let rightPoint = guides[i + 1].center
            
            // line
            backPath.append(getPathBetween(leftPoint, rightPoint: rightPoint))
            
            // current
            if i == currentIndex {
                topPath = getPathBetween(leftPoint, rightPoint: rightPoint)
            }
        }
        
        // draw
        let lineWidth = bounds.height / 58
        backPath.lineWidth = lineWidth
        normalColor.setStroke()
        backPath.stroke()
        
        if topPath != nil {
            topPath.lineWidth = 4 * lineWidth
            currentColor.setStroke()
            topPath.stroke()
        }
    }
    
    fileprivate func getPathBetween(_ leftPoint: CGPoint, rightPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: leftPoint)
        path.addLine(to: rightPoint)
        
        // arrow
        let arrowL = bounds.height * 0.25
        let arrowCX = (leftPoint.x + rightPoint.x) * 0.5
        path.move(to: CGPoint(x: arrowCX - arrowL * 0.5, y: leftPoint.y - arrowL * 0.5))
        path.addLine(to: CGPoint(x: arrowCX + arrowL * 0.5, y: leftPoint.y))
        path.addLine(to: CGPoint(x: arrowCX - arrowL * 0.5, y: leftPoint.y + arrowL * 0.5))
        
        return path
    }
}


// default
extension FRGuideView {
    func defaultSetup()  {
        let titles = ["Client\nProfile", "Individualized Assessment", "Treatment Consultation", "Complementary Consultation"]
        setupWithTitles(titles)
    }
}
