//
//  WindingRoadCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/28.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class WindingRoadCollectionView: UICollectionView, UIScrollViewDelegate {
    var viewDidScroll: (() -> Void)?
    
    var solidRoad = false {
        didSet {
            roadDraw.solidRoad = solidRoad
        }
    }
    fileprivate let roadDraw = RoadDrawModel()
    var branchPoint = CGPoint.zero {
        didSet{
            roadDraw.branchPoint = branchPoint
        }
    }
    var drawRoad = true
    var turningRadius: CGFloat = 40 {
        didSet{
            roadDraw.turningRadius = turningRadius
        }
    }
    
    var minGap: CGFloat = 40 {
        didSet{
            roadDraw.minGap = minGap
        }
    }
    
    var startPoint = CGPoint.zero {
        didSet{
            roadDraw.startPoint = startPoint
        }
    }
    var roadWidth: CGFloat = 31.0 {
        didSet{
            roadDraw.roadWidth = roadWidth
        }
    }
    
    // for draw
    var anchorInfo = [(anchor: CGPoint, played: Bool)]() {
        didSet{
            roadDraw.anchorInfo = anchorInfo
        }
    }
    
    var roadLineColor = UIColorFromRGB(253, green: 255, blue: 251){
        didSet{
            roadDraw.roadLineColor = roadLineColor
        }
    }
    // green sets
    var roadMainColor = UIColorFromRGB(185, green: 183, blue: 169){
        didSet{
            roadDraw.roadMainColor = roadMainColor
        }
    }
    var roadPlayedColor = projectTintColor {
        didSet{
            roadDraw.roadPlayedColor = roadPlayedColor
        }
    }
    
    // used for pet
    func setForVirtual()  {
        roadPlayedColor = UIColorFromRGB(153, green: 131, blue: 255).withAlphaComponent(0.5)
        
        setNeedsDisplay()
    }
    
    func setForReal() {
        roadPlayedColor = projectTintColor.withAlphaComponent(0.5)
        setNeedsDisplay()
    }
    
    // update
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewDidScroll?()
        
        setNeedsDisplay()
    }
    
    var firstDirection = RoadDirection.fromTop {
        didSet{
            roadDraw.firstDirection = firstDirection
        }
    }
    override func draw(_ rect: CGRect) {
        // no point
        if  !drawRoad {
            return
        }
        
        roadDraw.drawRoadWithMaxX(bounds.width)
    }
}

