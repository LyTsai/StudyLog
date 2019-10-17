//
//  CardTemplateView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/10/9.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// item chosen protocol
@objc protocol CardActionProtocol {
    // for single judgement card, 0 is first choice. Otherwise, the item is the index
    // nil for skip
    @objc optional func card(_ cardView: CardTemplateView, chooseItemAt item: Int)
    @objc optional func card(_ cardView: CardTemplateView, input value: Float)
}

// represents each metric data input card that presents end user with selection options (depends on card style)
class CardTemplateView: UIView {
    
    var actionDelegate: CardActionProtocol!
    
    func key() -> String {
        return CardTemplateManager.defaultCardStyleKey
    }
    
    var withDeco = false

    // default card size
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
    
    // if the card has a host for chain
    var hostCard: CardInfoObjModel!
    var hostItem: Int!
    
    // buttons: confirm, deny, skip
    // confirmation button
    var leftButton: GradientBackStrokeButton!
    // deny button
    var rightButton: GradientBackStrokeButton!
    
    // default views: icon and center background image
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
    
    // show result for user
    func setUIForSelection(_ answer: Int?) {
        if answer == nil {
            return
        }
    }
    
    func setForBaselineChoice(_ choice: Int?) {
        if choice == nil {
            return
        }
    }
    
    func beginToShow() {
        
    }
    
    func endShow() {
        
    }
    
    // MARK: -------- methods can be used by subclasses ----------------------
    // can be add more information
    
    // backImage and flip
    var cardOnShow = true
    let infoDetailView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBackAndUpdateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBackAndUpdateUI()
    }
    
    func addBackAndUpdateUI() {

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
