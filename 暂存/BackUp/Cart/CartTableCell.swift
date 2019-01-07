//
//  CartTableCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/13.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MARK: ------------ cell ---------------
let cartCellID = "cart cell identifier"
class CartTableCell: UITableViewCell {
    weak var hostTable: CartTableView!

    class func cellWithTableView(_ tableView: UITableView, cards: [MatchedCardsDisplayModel], color: UIColor, mode: Bool) -> CartTableCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cartCellID) as? CartTableCell
        
        if cell == nil {
            cell = CartTableCell(style: .default, reuseIdentifier: cartCellID)
            cell!.firstLoad()
        }
        
        cell!.setupWithCards(cards, color: color, mode: mode)
        
        return cell!
    }
    
    fileprivate let line = UIView()
    fileprivate var cartCardsView: CartCardsCollectionView!
    fileprivate func firstLoad() {
        // cards
        cartCardsView = CartCardsCollectionView.createWithFrame(CGRect(x: 0, y: 0, width: 370, height: 150), cards: [], color: UIColor.blue)

        // add
        addSubview(line)
        addSubview(cartCardsView)
    }
    
    fileprivate func setupWithCards(_ cards: [MatchedCardsDisplayModel], color: UIColor, mode: Bool) {
        cartCardsView.reloadWithCards(cards, color: color, mode: mode)
        cartCardsView.hostCell = self
        line.backgroundColor = color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin: CGFloat = 15 * bounds.width / 375
        // set up
        line.frame = CGRect(x: margin, y: margin * 0.67, width: bounds.width * 0.006, height: bounds.height * 0.8)
        let collectionX = line.frame.maxX
        cartCardsView.frame = CGRect(x: collectionX, y: 0, width: bounds.width - collectionX, height: bounds.height)
    }
}
