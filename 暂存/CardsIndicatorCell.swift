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
        // current selected, current unselected, not answered, not the answer, answer
        case selected, unselected, unanswered, notAnswer, isAnswer, isCurrent
    }
    
    // the UI set up
    var state: DotState = .unanswered {
        didSet{
            if state != oldValue {
                switch state {
                case .selected:
                    selectedImageView.isHidden = false
                    dotLayer.isHidden = true
                    selectedImageView.image = selectedImage
                case .unselected:
                    selectedImageView.isHidden = true
                    dotLayer.isHidden = false
                    dotLayer.fillColor = unselectedColor
                case .unanswered:
                    selectedImageView.isHidden = true
                    dotLayer.isHidden = false
                    dotLayer.fillColor = unAnsweredColor
                case .notAnswer:
                    selectedImageView.isHidden = true
                    dotLayer.isHidden = false
                    dotLayer.fillColor = notAnswerColor
                case .isAnswer:
                    selectedImageView.isHidden = false
                    dotLayer.isHidden = true
                    selectedImageView.image = answerImage
                case .isCurrent:
                    // enlarge
                    break
                }
            }
        }
    }
    
    // images
    fileprivate let answerImage = UIImage(named: "cardIndi_answer")
    fileprivate let selectedImage = UIImage(named: "cardIndi_selected")
    // colors
    fileprivate let notAnswerColor = UIColorGray(205).cgColor
    fileprivate let unAnsweredColor = UIColorGray(155).cgColor
    fileprivate let unselectedColor = UIColor.white.cgColor
    
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
        dotLayer.fillColor = unAnsweredColor
        
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
        let imageLength = 0.46 * min(bounds.width, bounds.height) // 20
        
        // image
        selectedImageView.frame = CGRect(center: dotCenter, length: imageLength)
        
        // layer
        dotLayer.path = UIBezierPath(arcCenter: dotCenter, radius: 0.25 * imageLength, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true).cgPath
    }
}


// decoration view
let cardsIndiDecorationID = "cards indicator decoration identifier"
class CardsIndicatorDecorationView: UICollectionReusableView {
    var decoView = UIView()
//    var isSelected
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate func updateUI() {
        decoView.backgroundColor = UIColor.red
        decoView.frame = bounds
        addSubview(decoView)
    }
}
