//
//  RoadItem.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/22.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

enum PositionOfAnchor {
    case free, top, left, bottom, right
}

// model for an item on the road
// (not a typical model, with UI information in it)
// only about the layout and colors
class RoadItemDisplayModel {
    // location and size
    var backFrame = CGRect.zero
    var imageFrame = CGRect.zero
    var textFrame = CGRect.zero
    
    var indexWidth: CGFloat = 0
    var lineWidth: CGFloat = 2
    
    var anchorPosition = PositionOfAnchor.free
    var anchorPoint = CGPoint.zero
    
    // color info
    var fillColor = UIColor.cyan
    var borderColor = UIColor.blue
    var lineColor = UIColor.black
    
    // different types
    // all contains, used for category
    var allContains = false
}

// item display view
class RoadItemDisplayView: UIView {
    
    // properties for draw line
    var item: RoadItemDisplayModel!
    
    
    // adjust frames of sub views
    /* rules:
     left: image up, text down
     right: image up, text down
     top: image right, text left
     bottom: image left, text right
     */
    func setupItemInfoWithFrame(_ frame: CGRect, item: RoadItemDisplayModel) {
        self.frame = frame
        
        // ajust backLayer, anchorPoint, label and image
        var backFrame = item.backFrame
        var textFrame = item.textFrame
        var anchorPoint = item.anchorPoint
        let offset = item.indexWidth * 0.5
        switch item.anchorPosition {
        case .top:
            backFrame = CGRect(origin: CGPoint(x: bounds.width - backFrame.width, y: bounds.height - backFrame.height), size: backFrame.size)
            textFrame = CGRect(x: 0, y: 0, width: bounds.width - backFrame.width, height: bounds.height)
            anchorPoint = CGPoint(x: backFrame.midX, y: offset)
        case .left:
            backFrame = CGRect(origin: CGPoint(x: bounds.width - backFrame.width, y: 0), size: backFrame.size)
            textFrame = CGRect(x: 0, y: backFrame.height, width: bounds.width, height: bounds.height - backFrame.height)
            anchorPoint = CGPoint(x: offset, y: backFrame.midY)
        case .bottom:
            backFrame = CGRect(origin: CGPoint.zero, size: backFrame.size)
            textFrame = CGRect(x: backFrame.width, y: 0, width: bounds.width - backFrame.width, height: bounds.height)
            anchorPoint = CGPoint(x: backFrame.midX, y: bounds.height - offset)
        case .right:
            backFrame = CGRect(origin: CGPoint.zero, size: backFrame.size)
            textFrame = CGRect(x: 0, y: backFrame.height, width: bounds.width, height: bounds.height - backFrame.height)
            anchorPoint = CGPoint(x: bounds.width - offset, y: backFrame.midY)
        case .free: break
        }
        
        // assign
        item.backFrame = backFrame
        item.textFrame = textFrame
        item.anchorPoint = anchorPoint
        
        self.item = item
        setNeedsDisplay()
    }
    
    
    // setup ------- based on backFrame
    func setupAndDrawWithFrame(_ frame: CGRect, item: RoadItemDisplayModel) {
        self.backgroundColor = UIColor.clear
        self.frame = frame
        
        // adjust anchorPoint
        var realAnchor = item.anchorPoint
        let offset = item.indexWidth * 0.5
        switch item.anchorPosition {
        case .free: break
        case .top:      // top middle
            realAnchor = CGPoint(x: item.backFrame.midX, y: offset)
        case .left:     // left middle
            realAnchor = CGPoint(x: offset, y: item.backFrame.midY)
        case .bottom:   // bottom middle
            realAnchor = CGPoint(x: item.backFrame.midX, y: bounds.maxY - offset)
        case .right:    // right middle
            realAnchor = CGPoint(x: bounds.maxX - offset, y: item.backFrame.midY)
        }
        
        item.anchorPoint = realAnchor
        self.item = item
        
        // draw
        setNeedsDisplay()
    }
    
    // MARK: ----------- draw rect -------------------
    override func draw(_ rect: CGRect) {
        let backCenter = CGPoint(x: item.backFrame.midX, y: item.backFrame.midY)
        // lines
        let path = UIBezierPath()
        path.move(to: item.anchorPoint)
        path.addLine(to: backCenter)
        item.lineColor.setStroke()
        path.stroke()
        
        // star ?
        // draw star
        let starPath = UIBezierPath(ovalIn: CGRect(center: item.anchorPoint, length: item.indexWidth - item.lineWidth * 2))
        item.fillColor.setFill()
        starPath.fill()
        
        item.lineColor.setStroke()
        starPath.stroke()
    }
}
