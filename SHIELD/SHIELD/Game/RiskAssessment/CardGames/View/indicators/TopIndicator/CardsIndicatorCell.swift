//
//  CardsIndicatorCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/24.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let cardsIndicatorCellID = "cards indicator cell identifier"

class CardsIndicatorCell: UICollectionViewCell {
    enum DotState {
        // normal, current dot, current answer, answer "no" for judgement
        case normal, highlighted, selectedYes, selectedNo
    }
    
    // the UI set up
    var state: DotState = .normal {
        didSet{
            if state != oldValue {
                switch state {
                case .normal:
                    selectedImageView.isHidden = true
                    dotLayer.isHidden = false
                    dotLayer.strokeColor = normalColor
                    dotLayer.fillColor = clearColor
                case .selectedYes:
                    selectedImageView.isHidden = false
                    dotLayer.isHidden = true
                    selectedImageView.image = selectedImage
                case .selectedNo:
                    selectedImageView.isHidden = false
                    dotLayer.isHidden = true
                    selectedImageView.image = answerNoImage
                case .highlighted:
                    selectedImageView.isHidden = false
                    dotLayer.isHidden = true
                    selectedImageView.image = highlightedImage
                }
            }
        }
    }
    
    // images
    fileprivate let answerNoImage = UIImage(named: "cardIndi_no")
    fileprivate let selectedImage = UIImage(named: "cardIndi_selected")
    fileprivate let highlightedImage = UIImage(named: "cardIndi_highlighted")
    // colors
    fileprivate let normalColor = UIColorFromRGB(108, green: 81, blue: 27).cgColor
    fileprivate let clearColor = UIColor.clear.cgColor
    
    // layer and imageView
    fileprivate let selectedImageView = UIImageView()   // 20 * 20
    fileprivate let dotLayer = CAShapeLayer()           // 10 * 10
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate func updateUI() {
        // unanswered
        dotLayer.fillColor = clearColor
        dotLayer.strokeColor = normalColor
        dotLayer.lineWidth = 1.6
        
        // selected
        selectedImageView.contentMode = .scaleAspectFit
        
        // add sublayer
        contentView.layer.addSublayer(dotLayer)
        contentView.addSubview(selectedImageView)
        
        // init state
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        selectedImageView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let dotCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let imageLength = 0.6 * min(bounds.width, bounds.height)
        
        // image
        selectedImageView.frame = CGRect(center: dotCenter, length: imageLength)
        
        // layer
        dotLayer.path = UIBezierPath(arcCenter: dotCenter, radius: 0.25 * imageLength, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true).cgPath
    }
}
