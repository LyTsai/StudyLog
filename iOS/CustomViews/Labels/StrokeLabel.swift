//
//  StrokeLabel.swift
//  AnnielyticX
//
//  Created by L on 2019/4/25.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation
import UIKit

// bottom label is stroke label
class StrokeLabel: UILabel {
    var strokeColor = UIColor.black {
        didSet {
            updateWithCurrentText()
        }
    }
    var strokeWidth: Float = 10
    var frontColor = UIColor.white {
        didSet{
            frontLabel.textColor = frontColor
        }
    }
    
    fileprivate let frontLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        basicSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        basicSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateWithCurrentText()
    }
    
    // normal setup
    fileprivate func basicSetup() {
        numberOfLines = 0
        textAlignment = .center
        frontLabel.textColor = UIColor.white
        
        addSubview(frontLabel)
    }
    
    // set up
    override var numberOfLines: Int {
        didSet {
            frontLabel.numberOfLines = numberOfLines
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet{
            frontLabel.textAlignment = textAlignment
        }
    }
    
    override var font: UIFont! {
        didSet{
            frontLabel.font = font
        }
    }

    override var text: String? {
        didSet{
            frontLabel.text = text
            if text != nil {
                self.attributedText = NSAttributedString(string: text!, attributes: [.strokeColor: strokeColor, .strokeWidth: NSNumber(value: strokeWidth)])
            }
        }
    }
    
    fileprivate func updateWithCurrentText() {
        if let title = self.text {
            self.text = title
        }
    }

    // attributed text
    func setAttributedText(_ attributedText: NSAttributedString)  {
        frontLabel.attributedText = attributedText
        let mutable = NSMutableAttributedString(attributedString: attributedText)
        mutable.addAttributes([.strokeColor: strokeColor, .strokeWidth: NSNumber(value: strokeWidth)], range: NSMakeRange(0, attributedText.length))
        self.attributedText = mutable
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frontLabel.frame = bounds
    }
    
}
