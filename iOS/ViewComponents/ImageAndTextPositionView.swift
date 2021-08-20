//
//  ImageAndTextPositionView.swift
//  MagniPhi
//
//  Created by L on 2021/3/3.
//  Copyright © 2021 MingHui. All rights reserved.
//

import Foundation
import UIKit

class ImageAndTextPositionView: UIView {
    var titleTouchAllowed = true
    var tapAction: (() -> Void)?
    var roundImageBack: Bool? {
        didSet {
            imageNode.roundImageBack = roundImageBack
            setNeedsLayout()
        }
    }
    
    var viewKey: String?
    
    var textWidthExpandRatio: CGFloat?
    var textHeightExpandRatio: CGFloat?
    
    var labelPosition = TextPosition.top
    var autoAdjustAlignment = true
    var verticalAdjustRatio: CGFloat?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBasic()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupBasic()
    }

    var imageNode: ImageNode {
        return _imageNode
    }
    var titleLabel: UILabel {
        return _titleLabel
    }
    
    fileprivate let _imageNode = ImageNode()
    fileprivate let _titleLabel = UILabel()
    func setupBasic() {
        self.backgroundColor = UIColor.clear
        _titleLabel.numberOfLines = 0
        _titleLabel.adjustsFontSizeToFitWidth = true
        
        addSubview(_imageNode)
        addSubview(_titleLabel)
    }
    
    // data
    func setupWithColor(_ color: UIColor?, image: URL?, title: String?) {
        _imageNode.setupWithColor(color, image: image)
        _titleLabel.text = title
    }
    
    func setColor(_ color: UIColor) {
        _imageNode.setupWithColor(color)
    }
    
    func hideText(_ hide: Bool) {
        _titleLabel.isHidden = hide
    }
    
    func showGray(_ show: Bool) {
        _imageNode.backLayer.fillColor = (show ? UIColorGray(204) : UIColor.white).cgColor
    }
    
    // adjust auto
    func autoAdjust(_ arcCenter: CGPoint)  {
        // top or bottom
        let autoResult = TextPosition.autoAdjust(arcCenter, viewCenter: self.center)
        self.labelPosition = autoResult.0
        self.verticalAdjustRatio = autoResult.1
        self.updateLabelPosition()
    }
    
    // label frames
    fileprivate func updateLabelPosition() {
        let textBounding = CGSize(width: bounds.height * (textWidthExpandRatio ?? 4), height: bounds.height * (textHeightExpandRatio ?? 1))
        titleLabel.frame = TextPosition.getFrame(textBounding, sideFrame: bounds, labelPosition: labelPosition, gap: 5, verticalAdjustRatio: verticalAdjustRatio ?? 0)
       
        // text alignment
        if autoAdjustAlignment {
            titleLabel.textAlignment = labelPosition.suggestedTextAlignment
        }
    }
        
    var textFontRatio: CGFloat = 11 / 40
    override func layoutSubviews() {
        super.layoutSubviews()

        let viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let displayL = min(bounds.width, bounds.height)
       
        // image
        _imageNode.frame = CGRect(center: viewCenter, length: displayL)
    
        // title
        updateLabelPosition()
        titleLabel.font = UIFont.systemFont(ofSize: bounds.height * textFontRatio, weight: .regular)
    }
    
    // action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            if imageNode.frame.contains(point) || (!_titleLabel.isHidden && titleLabel.frame.contains(point)) {
                tapAction?()
            }
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hit = super.hitTest(point, with: event)
        if !titleLabel.isHidden && titleLabel.frame.contains(point) {
            hit = self
        }
        
        return hit
    }
}
