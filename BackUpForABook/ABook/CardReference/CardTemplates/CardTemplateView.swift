//
//  CardTemplateView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/10/9.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// expected from card template view such as CardTemplateView
protocol CardTemplateProtocol {
    // identification of card view
    func key() -> String
    
    // setting (or re-setting) card content
    // each card view display information is provided with VCardModel and VOptionModel.  see document for details
    // card - attached card content
    // selection - default selection
    func setCardContent(_ card: CardInfoObjModel, defaultSelection: CardOptionObjModel?)
}

// represents each metric data input card that presents end user with selection options (depends on card style)
class CardTemplateView: UIView, CardTemplateProtocol {
    func key() -> String {
        return CardTemplateManager.defaultCardStyleKey
    }
    
    // MARK: ------ code properties ----------
    // default card size
    static var defaultSize = CGSize(width: 335, height: 367)
    /** the frame of card in the cardView*/
    var cardFrame = CGRect(x: 40, y: 20, width: 230, height: 260)
    
    // MARK: ------- properties
    ///////////////////////////////////////////////////////////
    // attached card content references and current result for data input
    // attached card (each card has one or more VOptionModel)
    var vCard: CardInfoObjModel!
    // user's selection (or no selection).  in case of single option card (or statement card) it is set on creation
    var option: CardOptionObjModel!
    var chosenIndex = -1
    
    // buttons: confirm, deny, skip
    // confirmation button
    var confirmButton: UIButton!
    // deny button
    var denyButton: UIButton!
    // skip button
    var skipButton: UIButton!
    
    var flipButton = UIButton(type: .custom)
    
    // default views: icon and center background image
    var iconImageView: UIImageView!
    var centerBackView: UIView!
    // reference to host view for sending back generic events
    weak var hostView: UIView!
    
    ///////////////////////////////////////////////////////////
    // Protocol function for setting up card display information
    ///////////////////////////////////////////////////////////
    // setting (or re-setting) card content
    // vCard - attached card content
    // selection - default selection
    func setCardContent(_ card: CardInfoObjModel, defaultSelection: CardOptionObjModel?)
    {
        // card content 
        vCard = card
        option = defaultSelection
    }
    
    // MARK: -------- methods can be used by subclasses ----------------------
    // can be add more information
    
    // backImage
    var backImages = ProjectImages.sharedImage
    let backImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBack()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBack()
    }
    
    fileprivate func addBack() {
        addSubview(backImageView)
        backImageView.contentMode = .scaleToFill
        backImageView.image = backImages.normal
        
        backImageView.layer.addBlackShadow(5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backImageView.frame = bounds
        
    }
    
    // add normal buttons if necessary
    func setupBasic(){
        let imageCenter = ProjectImages.sharedImage
        flipButton.setBackgroundImage(imageCenter.flip, for: .normal)
        addSubview(flipButton)
        
        confirmButton = UIButton(type: .custom)
        denyButton = UIButton(type: .custom)
        confirmButton.setBackgroundImage(imageCenter.unselectedYes, for: .normal)
        denyButton.setBackgroundImage(imageCenter.unselectedNo, for: .normal)
        confirmButton.setBackgroundImage(imageCenter.selectedYes, for: .selected)
        denyButton.setBackgroundImage(imageCenter.selectedNo, for: .selected)
        
        addSubview(confirmButton)
        addSubview(denyButton)
    }
    
    func drawTriangleButton(_ button: UIButton) {
        let buttonBounds = button.bounds
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 0, y: buttonBounds.height))
        path.addLine(to: CGPoint(x: buttonBounds.maxX, y: buttonBounds.midY))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = buttonBounds
        maskLayer.path = path.cgPath
        maskLayer.lineWidth = 0.01
        maskLayer.fillColor = UIColor.red.cgColor
        button.layer.mask = maskLayer
    }
}
