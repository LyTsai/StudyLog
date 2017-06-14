//
//  AgeInputView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class AgeInputView: UIView {
    weak var hostCell: UserInfoAgeCell!
    
    var minAge: Int = 0 {
        didSet{ minAgeLabel.text = "\(minAge)" }
    }
    
    var maxAge: Int = 100 {
        didSet{ maxAgeLabel.text = "\(maxAge)" }
    }
    
    // read only
    var age: Int {
        return Int(slider.value * 100)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate let slider = CustomSlider()
    fileprivate let minAgeLabel = UILabel()
    fileprivate let maxAgeLabel = UILabel()
    
    fileprivate func setupBasic() {
        backgroundColor = UIColor.clear
        
        slider.value = 0.5
        slider.addTarget(self, action: #selector(selectAge(_:)), for: .valueChanged)
        
        minAgeLabel.text = "\(minAge)"
        maxAgeLabel.text = "\(maxAge)"
        
        minAgeLabel.textAlignment = .right
        maxAgeLabel.textAlignment = .left
        
        addSubview(slider)
        addSubview(minAgeLabel)
        addSubview(maxAgeLabel)
    }
    
    func selectAge(_ slider: UISlider)  {
        setNeedsDisplay()
        if hostCell != nil {
            hostCell.changeState()
        }
    }
    
    /*
     orginal file:
     size: 240 * 82
     slider: 156 * 34
     bubble: 100 * 21 + 8(triangle) --- (adjust)
     gap: 5
     label: 17(height)
     */
    
    fileprivate var gap: CGFloat {
        return 5 * bounds.height / 80
    }
    fileprivate var sliderHeight: CGFloat {
        return bounds.height * 34 / 80
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let sliderWidth = bounds.width * 156 / 240
        let labelHeight = 17 * bounds.height / 82
        let labelWidth = (bounds.width - 2 * gap - sliderWidth) * 0.5
        let labelFont = UIFont.systemFont(ofSize: labelHeight / 2.4)
        
        minAgeLabel.frame = CGRect(x: 0, y: bounds.height - labelHeight, width: labelWidth, height: labelHeight)
        slider.frame = CGRect(x: labelWidth + gap, y: bounds.height - gap - sliderHeight, width: sliderWidth, height: sliderHeight)
        maxAgeLabel.frame = CGRect(x: slider.frame.maxX + gap, y: bounds.height - labelHeight, width: labelWidth, height: labelHeight)
        
        minAgeLabel.font = labelFont
        maxAgeLabel.font = labelFont
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        let bubbleHeight = bounds.height - 3 * gap - sliderHeight
        let mainHeight = bubbleHeight * 21 / 29
        let textFont = mainHeight / 2.3
        
        let attributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: textFont)]
        let string: NSString = "\(age) Years Old" as NSString
        let calculatedSize = string.boundingRect(with: CGSize(width: bounds.width, height: mainHeight - gap), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        if calculatedSize.width > bounds.width {
            print("font is too large or width is too small")
        }
        
        let stringSize = CGSize(width: calculatedSize.width + gap, height: mainHeight - gap)
        let thumbX = slider.thumbTopPoint.x
        let labelRect = CGRect(origin: CGPoint(x: thumbX - stringSize.width * 0.5, y: 1.5 * gap), size: stringSize)
        
        // drawLabel and arrow
        let radius = mainHeight * 0.5
        let arrowHeigth = bubbleHeight * 8 / 29
        let mainRect = labelRect.insetBy(dx: -radius, dy: -gap * 0.5)
        
        let bubblePath = UIBezierPath()
        let leftUp = CGPoint(x: mainRect.minX + radius, y: mainRect.minY)
        let rightUp = CGPoint(x: mainRect.maxX - radius, y: mainRect.minY)
        
        bubblePath.move(to: CGPoint(x: thumbX, y: mainRect.maxY + arrowHeigth))
        bubblePath.addLine(to:  CGPoint(x: thumbX - arrowHeigth * 0.8, y: mainRect.maxY))
        bubblePath.addLine(to: CGPoint(x: leftUp.x, y: mainRect.maxY))
        bubblePath.addArc(withCenter: CGPoint(x: leftUp.x, y: mainRect.midY), radius: radius, startAngle: CGFloat(M_PI_2), endAngle: 3 * CGFloat(M_PI_2), clockwise: true)
        bubblePath.addLine(to: rightUp)
        bubblePath.addArc(withCenter: CGPoint(x: rightUp.x, y: mainRect.midY), radius: radius, startAngle: -CGFloat(M_PI_2), endAngle: CGFloat(M_PI_2), clockwise: true)
        bubblePath.addLine(to: CGPoint(x: thumbX + arrowHeigth * 0.8, y: mainRect.maxY))
        bubblePath.close()
            
        darkGreenColor.setFill()
        bubblePath.fill()
        UIColor.black.setStroke()
        bubblePath.stroke()
        
        // drawString
        string.draw(in: labelRect, withAttributes: attributes)
    }

    
}
