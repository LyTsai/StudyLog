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
class RoadItemDisplayModel {
    // location and size
    var imageFrame = CGRect.zero
    var labelFrame = CGRect.zero
    var backFrame = CGRect.zero
    
    var indexWidth: CGFloat = 0
    var lineWidth: CGFloat = 2
    
    var anchorPosition = PositionOfAnchor.free
    var anchorPoint = CGPoint.zero
    
    // color info
    var fillColor = UIColor.cyan
    var borderColor = UIColor.blue
//    var imageBGColor = UIColor.clear // decided by backShadow
    var lineColor = UIColor.black
    
    // data fill
    var image: UIImage!
    var imageUrl: URL!
    var text: String!
    var index: Int = 0
    
    // decoration
    var backShadow = false
    
}

// item display view
class RoadItemDisplayView: UIView {
    // properties
    fileprivate let indexLabel = UILabel()
    fileprivate let imageView = UIImageView()
    fileprivate let textLabel = UILabel()
    fileprivate let backLayer = CAShapeLayer()
    
    // methods
    // factory
//    class func createWithFra(_ item: RoadItemDisplayModel) -> RoadItemDisplayView {
//        let display = RoadItemDisplayView()
//        display.setupBasicViews()
//        display.setupWithItem(item)
//        
//        return display
//    }
    
    // add subviews and layers
    func setupBasicViews() {
        indexLabel.textAlignment = .center

        imageView.contentMode = .scaleAspectFit
        
        textLabel.backgroundColor = UIColor.clear
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center // some seems to be .right
        
        // add
        layer.addSublayer(backLayer)
        addSubview(indexLabel)
        addSubview(imageView)
        addSubview(textLabel)
    }
    
    // properties for draw line
    fileprivate var anchorPoint = CGPoint.zero
    fileprivate var lineWidth: CGFloat = 2
    fileprivate var backCenter = CGPoint.zero
    fileprivate var lineColor = UIColor.black
    // setup
    func setupWithFrame(_ frame: CGRect, item: RoadItemDisplayModel) {
        self.backgroundColor = UIColor.clear
        self.frame = frame
        
        // adjust frames
        self.lineWidth = item.lineWidth
        self.lineColor = item.lineColor
        self.backCenter = CGPoint(x: item.backFrame.midX, y: item.backFrame.midY)
        
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
        
        self.anchorPoint = realAnchor
        
        // 1. backLayer
        backLayer.path = UIBezierPath(roundedRect: item.backFrame, cornerRadius: item.lineWidth * 4).cgPath
        
        if item.backShadow {
            // has shadow, for card
            backLayer.lineWidth = item.lineWidth
            backLayer.fillColor = UIColor.white.cgColor
            backLayer.strokeColor = item.fillColor.cgColor
            
            // shadow
            backLayer.shadowColor = item.fillColor.cgColor
            backLayer.shadowOffset = CGSize.zero
            backLayer.shadowRadius = item.lineWidth
            backLayer.shadowOpacity = 1
            backLayer.shadowPath = backLayer.path
        }else {
            // for category
            backLayer.lineWidth = item.lineWidth
            backLayer.fillColor = item.fillColor.cgColor
            backLayer.strokeColor = item.borderColor.cgColor
        }
        
        // 2. indexLabel
        indexLabel.frame = CGRect(center: realAnchor, length: item.indexWidth)
        indexLabel.layer.borderWidth = item.lineWidth
        indexLabel.layer.borderColor = item.lineColor.cgColor
        indexLabel.backgroundColor = item.fillColor
        indexLabel.layer.masksToBounds = true
        indexLabel.layer.cornerRadius = item.indexWidth * 0.5
        indexLabel.text = "\(item.index + 1)"
        indexLabel.font = UIFont.systemFont(ofSize: item.indexWidth * 0.4)
        
        // 3. imageView
        imageView.frame = item.imageFrame
        imageView.backgroundColor = item.backShadow ? UIColor.clear : UIColor.white
        if item.image != nil {
            imageView.image = item.image
        }else {
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setIndicatorStyle(.gray)
            imageView.sd_setImage(with: item.imageUrl, placeholderImage: ProjectImages.sharedImage.placeHolder, options: .refreshCached)
        }
        
        // 4. textLabel
        textLabel.frame = item.labelFrame
        textLabel.text = item.text
        textLabel.font = UIFont.systemFont(ofSize: item.labelFrame.height * 0.3, weight: UIFontWeightBold)
        
        // 5. lines
        setNeedsDisplay()
    }
    
    func updateFrames(_ item: RoadItemDisplayModel) {
        
    }
    
    override func draw(_ rect: CGRect) {
        // lines
        let path = UIBezierPath()
        path.move(to: anchorPoint)
        path.addLine(to: backCenter)
        lineColor.setStroke()
        path.stroke()
        
        // star ?
    }
}
