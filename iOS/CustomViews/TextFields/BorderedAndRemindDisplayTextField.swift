//
//  BorderedAndRemindDisplayTextField.swift
//  MapniPhi
//
//  Created by L on 2021/9/2.
//  Copyright © 2021 MingHui. All rights reserved.
//

import Foundation
import UIKit

class BorderedAndRemindDisplayTextField: UITextField {
    var borderColor = UIColorFromHex(0xB2BCCA)
    var borderlineWidth: CGFloat = 2 {
        didSet {
            if borderlineWidth != oldValue && !self.isEditing {
                hideRemindAndDisplay()
            }
        }
    }
    
    // editing
    var editingBorderColor = UIColor.green
    var editingBorderLineWidth: CGFloat?
     
    // remind
    var remindBorderColor = UIColorFromHex(0xC74B4D)
    var remindBorderLineWidth: CGFloat?
    var reminderBubbleView: TextBubbleView!
    var remindBubbleBorderColor = UIColorFromHex(0xFF8300)
    
    var textFieldBeginEditing: (() -> Void)?
    var checkResultAction: (() -> String?)?
    
    // left Image
    var leftImage: UIImage? {
        didSet {
            leftImageView.image = leftImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBasic()
    }
    
    fileprivate let leftImageView = UIImageView()
    fileprivate func setupBasic() {
        self.clearButtonMode = .whileEditing
        self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.systemFont(ofSize: 18 * fontFactor, weight: .medium)
        self.minimumFontSize = 5
        self.leftViewMode = .always
        
        leftImageView.contentMode = .scaleAspectFit
        self.leftView = leftImageView
        
        // action
        self.addTarget(self, action: #selector(textFieldDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidEnd), for: .editingDidEnd)
        
        hideRemindAndDisplay()
    }
    
    func setAsPasswordTextField() {
        self.isSecureTextEntry = true
        
        self.clearButtonMode = .never
        self.rightViewMode = .always
        
        // eye button
        let rightButton = UIButton(type: .custom)
        rightButton.setBackgroundImage(UIImage(named: "icon_passwordHide"), for: .normal)
        rightButton.setBackgroundImage(UIImage(named: "icon_passwordShow"), for: .selected)
        rightButton.addTarget(self, action: #selector(passwordRightViewIsTouched), for: .touchUpInside)
        
        self.rightView = rightButton
    }
    
    
    // action
    @objc fileprivate func textFieldDidBegin() {
        hideRemindAndDisplay()
        textFieldBeginEditing?()
    }
    
    @objc fileprivate func textFieldDidEnd() {
        if let remind = checkResultAction?() {
            showRemind(remind)
        }else {
            hideRemindAndDisplay()
        }
    }
    
    @objc func passwordRightViewIsTouched(_ button: UIButton) {
        button.isSelected.toggle()
        self.isSecureTextEntry = !button.isSelected
    }
    
    // UI display
    func hideRemindAndDisplay() {
        if self.isEditing {
            self.layer.borderColor = editingBorderColor.cgColor
            self.layer.borderWidth = editingBorderLineWidth ?? borderlineWidth
        }else {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = borderlineWidth
        }
        
        if reminderBubbleView != nil {
            reminderBubbleView.removeFromSuperview()
        }
    }
    
    func showRemind(_ remind: String) {
        self.layer.borderColor = remindBorderColor.cgColor
        self.layer.borderWidth = remindBorderLineWidth ?? borderlineWidth
        
        // showRemind
        if reminderBubbleView == nil {
            reminderBubbleView = TextBubbleView()
            reminderBubbleView.bubbleBackColor = remindBorderColor
            reminderBubbleView.bubbleBorderColor = remindBubbleBorderColor
            reminderBubbleView.bubbleIsTouched = self.hideRemindAndDisplay
        }
        
        let oneH = bounds.height / 48
        reminderBubbleView.attributedString = NSAttributedString(string: remind, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16 * oneH, weight: .semibold)])
        reminderBubbleView.setupTalkBubbleWithX(CGPoint(x: bounds.midX, y: -5 * oneH), edgeInsets: UIEdgeInsets(top: 10 * oneH, left: 8 * oneH, bottom: 10 * oneH, right: 8 * oneH), confine: CGRect(x: 0, y: -12 * oneH - height, width: bounds.width, height: height), radius: 4 * oneH, overlapOnWindow: false, topArrow: false)
        self.addSubview(reminderBubbleView)
    }
    
    // Layout
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return leftImage == nil ? CGRect.zero : CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height).insetBy(dx: bounds.height * 0.3, dy: bounds.height * 0.1)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height).insetBy(dx: bounds.height * 0.25, dy: bounds.height * 0.25)
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let oneH = bounds.height / 40
//        self.font = UIFont.systemFont(ofSize: 18 * oneH, weight: .medium)
        self.layer.cornerRadius = 2 * oneH
    }
    
    // tap
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, with: event)
        
        if reminderBubbleView != nil && reminderBubbleView.superview != nil {
            if reminderBubbleView.frame.contains(point) {
                hitView = reminderBubbleView
            }
        }
        
        return hitView
    }
}
