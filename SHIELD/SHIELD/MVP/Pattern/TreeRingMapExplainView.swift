//
//  TreeRingMapExplainView.swift
//  AnnielyticX
//
//  Created by L on 2019/5/8.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class TreeRingMapExplainView: PullDownMenuView {
    fileprivate var topMargin: CGFloat = 0
    fileprivate var titleHeight: CGFloat = 30
    fileprivate var oneFont: CGFloat = 1
    fileprivate var horizontal: CGFloat = 0
    
    class func createWithFrame(_ frame: CGRect, bottomHeight: CGFloat, topMargin: CGFloat, titleHeight: CGFloat, horizontalMargin: CGFloat) -> TreeRingMapExplainView {
        let explain = TreeRingMapExplainView(frame: frame)
        explain.topMargin = topMargin
        explain.bottomHeight = bottomHeight
        explain.titleHeight = titleHeight
        explain.oneFont = titleHeight / 30
        explain.horizontal = horizontalMargin
        
        return explain
    }
    
    fileprivate var player: String?
    fileprivate var risk: String?
    fileprivate var time: String?
    
    fileprivate var userNameString: NSAttributedString?
    
    fileprivate var riskIcon: UIImage? {
        didSet{
            setNeedsDisplay()
        }
    }
    fileprivate var riskTypeColor: UIColor?
    fileprivate var riskTypeNameString: NSAttributedString?
    fileprivate var riskNameString: NSAttributedString?
    
    fileprivate var monthString: NSAttributedString?
    fileprivate var dayString: NSAttributedString?
    
    func loadViewWithPlayer(_ player: String?, risk: String?, time: String?) {
        self.player = player
        self.risk = risk
        self.time = time
        
        let titleFont = UIFont.systemFont(ofSize: 12 * oneFont, weight: .medium)
        let promptFont = UIFont.systemFont(ofSize: 10 * oneFont, weight: .medium)
        
        // center
        let centerPara = NSMutableParagraphStyle()
        centerPara.alignment = .center
        
        // player part
        if player != nil {
            let userName = userCenter.getDisplayNameOfKey(player!) ?? ""
            userNameString = NSAttributedString(string: userName, attributes: [.font: titleFont, .paragraphStyle: centerPara])
        }
        
        // risk part
        if risk != nil {
            if let game = collection.getRisk(risk) {
                var riskUrl = game.imageUrl
                if riskUrl == nil {
                    riskUrl = collection.getMetric(game.metricKey)?.imageUrl
                }
                let imageView = UIImageView()
                imageView.sd_setImage(with: riskUrl, placeholderImage: ProjectImages.sharedImage.imagePlaceHolder, options: .refreshCached) { (image, error, type, url) in
                    // if launch
                    self.riskIcon = imageView.image
                }
                self.riskIcon = imageView.image
                // name
                let riskTypeName = collection.getAbbreviationOfRiskType(game.riskTypeKey!)
                let riskName = game.name ?? ""
                riskTypeColor = collection.getRiskTypeByKey(game.riskTypeKey!)?.realColor ?? tabTintGreen
                riskTypeNameString = NSAttributedString(string: riskTypeName, attributes: [.font: promptFont, .foregroundColor: UIColor.white])
                riskNameString = NSAttributedString(string: riskName, attributes: [.font: titleFont, .paragraphStyle: centerPara])
            }
        }
        
        // time part
        if time != nil {
            let date = ISO8601DateFormatter().date(from: time!.appending("T06:41:26Z"))!
            let day = "\(CalendarCenter.getDayOfDate(date))"
            dayString = NSAttributedString(string: day, attributes: [.font: promptFont])
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMM"
            let month = monthFormatter.string(from: date)
            monthString = NSAttributedString(string: month, attributes: [.font: titleFont, .foregroundColor: UIColor.white])
        }
        
        
//       if !calculateHeight() {
//            self.frame = CGRect(x: frame.minX - frame.width * 0.5, y: frame.minY, width: frame.width * 1.5, height: frame.height)
            calculateHeight()
//        }
        setNeedsDisplay()
    }
    
    fileprivate var verticalH: CGFloat = 0
    fileprivate var userH: CGFloat = 0
    fileprivate var lineH: CGFloat = 0
    
    fileprivate var riskIconSize = CGSize.zero
    fileprivate var riskNameH: CGFloat = 0
    fileprivate var calendarSize = CGSize.zero
    
    fileprivate func calculateHeight() {
        var viewHeight = topMargin
        verticalH = 5 * oneFont
        lineH =  oneFont
        
        // max size, ignore the height
        let maxSize = CGSize(width: bounds.width - 2 * horizontal, height: bounds.height)
        
        // player part
        if player != nil {
            viewHeight += titleHeight
            userH = userNameString!.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).height
            viewHeight += userH + verticalH + lineH
        }
        
        // risk part
        if risk != nil {
            viewHeight += titleHeight
            riskIconSize = CGSize(width: 42 * oneFont, height: 49 * oneFont)
            viewHeight += riskIconSize.height + verticalH
            riskNameH = riskNameString!.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).height
            viewHeight += riskNameH + verticalH + lineH
        }
        
        // time part
        if time != nil {
            viewHeight += titleHeight
            calendarSize = CGSize(width: 54 * oneFont, height: 52 * oneFont)
            viewHeight += calendarSize.height + verticalH
        }
        
        viewHeight += bottomHeight
        
//        if viewHeight > maxH {
//            return false
//        }
        
        self.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: viewHeight)
        
//        return true
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if display {
            var viewHeight = topMargin
            let drawWidth = bounds.width - 2 * horizontal
            // max size, ignore the height
            // player part
            let topicFont = UIFont.systemFont(ofSize: 14 * oneFont)
            let linePath = UIBezierPath()
            linePath.lineWidth = lineH
            
            // from top down
            if player != nil {
                let titleFrame = CGRect(x: horizontal, y: viewHeight, width: drawWidth, height: titleHeight)
                drawString(NSAttributedString(string: "Individual", attributes: [.font: topicFont]), inRect: titleFrame, alignment: .center)
                
                viewHeight += titleHeight
                drawString(userNameString!, inRect: CGRect(x: horizontal, y: verticalH + viewHeight, width: drawWidth, height: userH), alignment: .center)
                viewHeight += userH + verticalH + lineH
                
                if risk != nil || time != nil {
                    // draw line
                    linePath.move(to: CGPoint(x: horizontal, y: viewHeight - lineH * 0.5))
                    linePath.addLine(to: CGPoint(x: bounds.width - horizontal, y: viewHeight - lineH * 0.5))
                }
            }
            
            // risk part
            if risk != nil {
                let titleFrame = CGRect(x: horizontal, y: viewHeight, width: drawWidth, height: titleHeight)
                drawString(NSAttributedString(string: "Current Game", attributes: [.font: topicFont]), inRect: titleFrame, alignment: .center)
                viewHeight += titleHeight
        
                // risk icon
                let gap = riskIconSize.height - riskIconSize.width
                let iconL = riskIconSize.width - gap
           
                riskIcon?.draw(in: CGRect(center: CGPoint(x: bounds.midX, y: viewHeight + riskIconSize.width * 0.5), length: iconL))
                
                let border = UIBezierPath(ovalIn: CGRect(center: CGPoint(x: bounds.midX, y: viewHeight + riskIconSize.width * 0.5), length: riskIconSize.width))
                border.lineWidth = 2 * oneFont
                riskTypeColor?.setStroke()
                border.stroke()
                
                // back
                let typeNameH = gap * 2
                let back = UIBezierPath(roundedRect: CGRect(center: CGPoint(x: bounds.midX, y: viewHeight + riskIconSize.width), width: riskIconSize.width * 0.9, height: typeNameH), cornerRadius: gap)

                riskTypeColor?.setFill()
                back.fill()
                
                drawString(riskTypeNameString!, inRect: CGRect(x: horizontal, y: riskIconSize.width - gap + viewHeight, width: drawWidth, height: typeNameH), alignment: .center)
                
                viewHeight += riskIconSize.height + verticalH
                drawString(riskNameString!, inRect: CGRect(x: horizontal, y: verticalH + viewHeight, width: drawWidth, height: riskNameH), alignment: .center)
                viewHeight += riskNameH + verticalH + lineH
                
                if time != nil {
                    // draw line
                    linePath.move(to: CGPoint(x: horizontal, y: viewHeight - lineH * 0.5))
                    linePath.addLine(to: CGPoint(x: bounds.width - horizontal, y: viewHeight - lineH * 0.5))
                }
            }
            
            UIColorFromHex(0xD6DEE9).setStroke()
            linePath.stroke()
            // time part
            if time != nil {
                let titleFrame = CGRect(x: horizontal, y: viewHeight, width: drawWidth, height: titleHeight)
                drawString(NSAttributedString(string: "Time", attributes: [.font: topicFont]), inRect: titleFrame, alignment: .center)
                viewHeight += titleHeight
                
                let calendarOrigin = CGPoint(x: bounds.midX - calendarSize.width * 0.5, y: viewHeight)
                UIImage(named: "calendarTemplate")!.draw(in: CGRect(origin: calendarOrigin, size: calendarSize))
                
                drawString(monthString!, inRect: CGRect(x: horizontal, y: viewHeight + 6 * oneFont, width: drawWidth, height: 18 * oneFont), alignment: .center)
                drawString(dayString!, inRect: CGRect(x: horizontal, y: viewHeight + 25 * oneFont, width: drawWidth, height: 23 * oneFont), alignment: .center)
            }
        }
    }
}
