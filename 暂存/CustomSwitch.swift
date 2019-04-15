//
//  CustomSwitch.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/11/30.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
class SwitchModel {
    var unChoosenColor = UIColor.lightGray// get more detailed color later
    var onColor = switchOnColor
    var offColor = switchOffColor
    var onText = "Yes"
    var offText = "No"
    var borderColor = switchBorderCOlor
    var thumbColor = switchThumbColor
}

enum SwitchState{
    case unselected
    case selectedOn
    case selectedOff
}

class NormalSwitch: UIView {
    
    var switchState: SwitchState = .unselected {
        didSet{
            setupWithState()
            
            if cellDelegate != nil {
                cellDelegate.changeState()
            }
        }
    }

    weak var cellDelegate: SelectCell!
    
    fileprivate var borderWidth: CGFloat = 1.5
    fileprivate var labelMargin: CGFloat = 4
    fileprivate var switchModel = SwitchModel()
    fileprivate var textLabel = UILabel()
    fileprivate var thumbLayer = CAShapeLayer()
    
    class func createSwitchWithSwitchModel(_ switchModel: SwitchModel) -> NormalSwitch{
        let normal = NormalSwitch()
        normal.setSwitchWithSwitchModel(switchModel)
        return normal
    }

    func setSwitchWithSwitchModel(_ switchModel: SwitchModel){
        if frame.width < frame.height {
            print("please change the size") // maybe can create an up-down switch, just hold now
            return
        }
        self.switchModel = switchModel

        layer.borderColor = switchModel.borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.masksToBounds = true
        
        thumbLayer.fillColor = switchModel.thumbColor.cgColor
        thumbLayer.lineWidth = 1
        thumbLayer.strokeColor = switchModel.thumbColor.cgColor
        thumbLayer.shadowColor = UIColor.black.cgColor
        thumbLayer.shadowOffset = CGSize.zero
        thumbLayer.shadowRadius = 4
        thumbLayer.shadowOpacity = 0.7
        layer.addSublayer(thumbLayer)
        
        textLabel.textColor = UIColor.black
        textLabel.backgroundColor = UIColor.clear
        addSubview(textLabel)
        
        setupWithState()
    }
    
    fileprivate func setupWithState(){
        switch switchState {
        case .unselected:
            setupWithText("", backgroundColor: switchModel.unChoosenColor)
        case .selectedOn:
            setupWithText(switchModel.onText, backgroundColor: switchModel.onColor)
            textLabel.textAlignment = .left
        case .selectedOff:
            setupWithText(switchModel.offText, backgroundColor: switchModel.offColor)
             textLabel.textAlignment = .right
        }
        
        calcuteFinalThumb()
    }
    
    fileprivate func setupWithText(_ text: String, backgroundColor: UIColor) {
        layer.backgroundColor = backgroundColor.cgColor
        textLabel.text = text
    }
    
    fileprivate var radius: CGFloat {
        return bounds.height * 0.5
    }
    
    fileprivate var thumbCenterX: CGFloat = 0 {
        didSet{
            let path = UIBezierPath(arcCenter: CGPoint(x: thumbCenterX, y: radius), radius: radius, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
            thumbLayer.path = path.cgPath
        }
    }
    
    fileprivate func calcuteFinalThumb() {
        switch switchState {
        case .unselected:
            thumbCenterX = bounds.midX
        case .selectedOn:
            thumbCenterX = bounds.width - radius
        case .selectedOff:
            thumbCenterX = radius
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = bounds.height * 0.5
        layer.cornerRadius = radius
        thumbLayer.frame = bounds
        textLabel.frame = CGRect(x: radius - labelMargin, y: borderWidth + labelMargin, width: frame.width - frame.height + 2 * labelMargin, height: frame.height - 2 * (borderWidth + labelMargin))
        calcuteFinalThumb()
    }
    
    // touches
    var activeOffset: UIOffset = UIOffset(horizontal: 30, vertical: 15)
    // simplify the code, just tap and change according to the location of the touch
    // if the state is selected, change to another
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // set up the state
        let touch = touches.first // no anyObject
        let point = touch!.location(in: self)
        let activeRect = bounds.insetBy(dx: -abs(activeOffset.horizontal), dy: -abs(activeOffset.vertical))
        if !activeRect.contains(point) {
            // ignore if too far
            return
        }
        
        switch switchState {
        case .unselected:
            if point.x < bounds.midX - radius  {
                switchState = .selectedOff
            }else if point.x > bounds.midX + radius {
                switchState = .selectedOn
            }else {
                // touch the thumb, ignore
                return
            }
        case .selectedOff:
            switchState = .selectedOn
        case .selectedOn:
            switchState = .selectedOff
        }
    }
}
