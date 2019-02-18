//
//  RoughRiskTestSliderView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/22.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class BaseSlider: UISlider {
    var thumbImage = UIImage(named: "sliderThumb")
    var trackImage = UIImage(named: "sliderTrack")
    
    var thumbTopPoint: CGPoint {
        let thumbRect = self.thumbRect(forBounds: frame, trackRect: frame, value: value)
        return CGPoint(x: thumbRect.midX, y: thumbRect.minY)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupBasicInfo()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setupBasicInfo()
    }
    
    func setupBasicInfo()  {
        let edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        setMinimumTrackImage(trackImage?.resizableImage(withCapInsets: edgeInsets), for: .normal)
        setMaximumTrackImage(trackImage?.resizableImage(withCapInsets: edgeInsets), for: .normal)
        setThumbImage(thumbImage, for: .normal)
    }
}

class AgeSlider: UIView {
    let slider = BaseSlider()
    var totalEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpSilder()
    }
    
    var sliderFrame: CGRect {
        return CGRect(x: 40, y: 40, width: bounds.width - 10, height: 30)
    }
    var space: CGFloat = 10
    var tagFontSize: CGFloat = 8
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setNeedsDisplay()
    }
    
    func setUpSilder() {
        layoutSubviews()
        
        backgroundColor = UIColor.clear
        slider.value = Float(arc4random() % 100) * 0.01
        addSubview(slider)
        
        let font = UIFont.systemFont(ofSize: tagFontSize)
        
        // labels, can draw, use label first
        let minLabel = UILabel(frame: CGRect(x: sliderFrame.minX - space - 5, y: sliderFrame.midY - 10, width: 10, height: 20))
        minLabel.font = font
        minLabel.text = "0"
        addSubview(minLabel)
        
        let maxLabel = UILabel(frame: CGRect(x: sliderFrame.maxX + space, y: sliderFrame.midY - 10, width: 20, height: 20))
        maxLabel.font = font
        maxLabel.text = "100"
        addSubview(maxLabel)
    
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

    }
    
    func sliderValueChanged(_ slider: BaseSlider) {
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        let age = Int(slider.value * 100)
        let attributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: tagFontSize * 1.5)]
        let string: NSString = "\(age) Years Old" as NSString
        let calculatedSize = string.boundingRect(with: bounds.size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let stringSize = CGSize(width: calculatedSize.width + 2, height: calculatedSize.height)
        let stringRect = CGRect(origin: CGPoint(x: slider.thumbTopPoint.x - stringSize.width * 0.5, y: slider.thumbTopPoint.y - stringSize.height / 0.6), size: stringSize)
        
        // drawLabel and arrow
        let radius = stringRect.height * 0.5 + 1
        let labelRect = stringRect.insetBy(dx: -radius, dy: -2)
        let labelPath = UIBezierPath(roundedRect: labelRect, cornerRadius: radius)
        
        let thumbX = slider.thumbTopPoint.x
        
        labelPath.move(to: CGPoint(x: thumbX, y: slider.thumbTopPoint.y - 1))
        labelPath.addLine(to: CGPoint(x: thumbX - 4, y: labelRect.maxY))
        labelPath.addLine(to: CGPoint(x: thumbX + 4, y: labelRect.maxY))
        labelPath.close()
        
        darkGreenColor.setFill()
        labelPath.fill()
        
        // drawString
        string.draw(in: stringRect, withAttributes: attributes)
    }
}
