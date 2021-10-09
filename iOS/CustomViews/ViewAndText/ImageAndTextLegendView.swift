//
//  ImageAndTextLegendView.swift
//  MagniPhi
//
//  Created by L on 2021/5/24.
//  Copyright © 2021 MingHui. All rights reserved.
//

import Foundation
import UIKit

class ImageAndTextLegendView: UIView {
    var focusOnLegend: ((Int) -> Void)?
    var roundBlock = false
    var defaultNumber = 3
    var horizontalDisplay = false
    
    // detail
    fileprivate let titleLabel = UILabel()
    fileprivate var icons = [UIImageView]()
    fileprivate var colorBlocks = [UIView]()
    fileprivate var textLabels = [UILabel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBasic()
    }
    fileprivate func setupBasic() {
        self.backgroundColor = UIColor.clear
        
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true

        // add title
        addSubview(titleLabel)
        
        setAsRightAlignment(rightAlignment)
    }
        
    // dark mode
    fileprivate var white = false
    func setForWhiteText(_ white: Bool) {
        self.white = white
        self.titleLabel.textColor = white ? UIColor.white : UIColor.black
          
        for textLabel in textLabels {
            textLabel.textColor = white ? UIColor.white : UIColor.black
        }
    }
    
    fileprivate var rightAlignment = false
    func setAsRightAlignment(_ rightAlignment: Bool) {
        self.rightAlignment = rightAlignment
        for textLabel in textLabels {
            textLabel.textAlignment = rightAlignment ? .right : .left
        }
        
        setNeedsLayout()
    }
    
    // setup
    func setupWithLengendInfo(_ legend: [(UIColor?, URL?, String)], title: String?) {
        self.setupAccordingToNumber(legend.count)
        self.titleLabel.text = title
        
        // detail
        for (i, (color, imageUrl, text)) in legend.enumerated() {
            if color == nil {
                colorBlocks[i].isHidden = true
            }else {
                colorBlocks[i].isHidden = false
                colorBlocks[i].backgroundColor = color
                colorBlocks[i].layer.borderColor = (imageUrl == nil ? UIColor.black : UIColor.black.withAlphaComponent(0.8)).cgColor
            }
            
            // image
            if imageUrl == nil {
                icons[i].isHidden = true
            }else {
                icons[i].isHidden = false
                icons[i].loadWebImage(imageUrl, completion: nil)
            }
            
            textLabels[i].text = text
        }
        
        // reset layout
        setNeedsLayout()
    }
    
    fileprivate func setupAccordingToNumber(_ number: Int) {
        if number == colorBlocks.count {
            return
        }
        
        // remove
        for imageView in icons {
            imageView.removeFromSuperview()
        }
        icons.removeAll()
        
        // icons
        for color in colorBlocks {
            color.removeFromSuperview()
        }
        colorBlocks.removeAll()
        
        // label
        for label in textLabels {
            label.removeFromSuperview()
        }
        textLabels.removeAll()
        
        // add
        for _ in 0..<number {
            let iconShape = UIView()
            self.addSubview(iconShape)
            self.colorBlocks.append(iconShape)
            
            // image
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            self.addSubview(imageView)
            self.icons.append(imageView)
            
            // text
            let textLabel = UILabel()
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.textColor = white ? UIColor.white : UIColor.black
            textLabel.textAlignment = rightAlignment ? .right : .left
            textLabel.numberOfLines = 0
            self.addSubview(textLabel)
            self.textLabels.append(textLabel)
        }
    }
    
    // action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let locationY = touches.first?.location(in: self).y ?? 0
        for (i, label) in textLabels.enumerated() {
            if locationY > label.frame.minY && locationY < label.frame.maxY {
                focusOnLegend?(i)
                setupAsFocus(i)
                
                break
            }
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if let lastY = textLabels.last?.frame.maxY {
            // ignore the margin
            if point.y > lastY || point.x > bounds.width * 0.8{
                return nil
            }
        }
        
        return hitView
    }
    
    // for nil, all display
    func setupAsFocus(_ index: Int?) {
        for (i, icon) in icons.enumerated() {
            let focused = index == nil || (index == i)
            
            let adjustAlpha: CGFloat = focused ? 1 : 0.65
            icon.alpha = adjustAlpha
            textLabels[i].alpha = adjustAlpha
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // draw
        let oneH = bounds.height / (CGFloat(max(icons.count, defaultNumber) + 1))
        
        // title
        titleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: oneH)
        titleLabel.font = UIFont.systemFont(ofSize: oneH * 0.45, weight: .medium)
        
        // legend
        var currentY: CGFloat = oneH
        for (i, block) in colorBlocks.enumerated() {
            let lineWidth = oneH / 25
            
            // rect
            let squareL = icons[i].isHidden ? oneH * 0.42 : oneH * 0.8
            let imageFrame = CGRect(x: rightAlignment ? (bounds.width - squareL - lineWidth * 0.5): lineWidth * 0.5, y: currentY + (oneH - squareL) * 0.5, width: squareL, height: squareL)
            
            let gap = oneH * 0.15
            var currentX = imageFrame.minX
            var textL = bounds.width
            
            if !icons[i].isHidden {
                icons[i].frame = imageFrame
                currentX = rightAlignment ? imageFrame.minX - squareL - gap: imageFrame.maxX + gap
                textL -= (squareL + gap)
            }
            
            if !block.isHidden {
                let offset = squareL * 0.15
                block.frame = CGRect(x:currentX, y: imageFrame.minY, width: squareL, height: squareL).insetBy(dx: offset, dy: offset)
                currentX = rightAlignment ? block.frame.minX - squareL - gap: block.frame.maxX + gap
                textL -= (squareL + gap)
                
                block.layer.cornerRadius = roundBlock ? block.frame.height * 0.5 : 4 * lineWidth
                block.layer.borderWidth = lineWidth
            }
        
            // text
            let textRect = CGRect(x: rightAlignment ? 0 : bounds.width - textL, y: currentY, width: textL, height: oneH)
            let fontSize = oneH * 0.5
            textLabels[i].frame = textRect
            textLabels[i].font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
            
            // next
            currentY += oneH
        }
    }
}

