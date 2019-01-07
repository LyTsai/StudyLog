//
//  VCardSingleCards.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/10/20.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

enum CardLayoutStyle {
    case Header
    case LeftImage
}

class QueryItem: UIView {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var normalImage = UIImage(named: "Button-Unselected")
    var selectedImage = UIImage(named: "Button-Selected")
    
    var selected = false {
        willSet {
            // change button images
            if newValue == true {
                selectButton.setImage(selectedImage, forState: .Normal) // .Selected
            }else {
                selectButton.setImage(normalImage, forState: .Normal)
            }
        }
    }

    class func itemWithDescription(description: String) -> QueryItem {
        let item = NSBundle.mainBundle().loadNibNamed("VCardSingleCards", owner: self, options: nil).last as! QueryItem
        item.descriptionLabel.text = description
        item.selected = false
        
        return item
    }
    
    
    weak var cardViewDelegate: VCardSingleCardView!
    
    @IBAction func buttonClicked(sender: UIButton) {
        selected = !selected
        
        // delegate in Card, unselect others
        cardViewDelegate.updateButtonState(sender.tag)
    }
}

let CellIdentifier = "Header"
class VCardQueryCell: UITableViewCell {
    var queryItem = QueryItem()
    
    class func queryCellWithTableView(tableView: UITableView, description: String) -> VCardQueryCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! VCardQueryCell
        cell.selectionStyle = .None
        cell.queryItem = QueryItem.itemWithDescription(description)
        cell.contentView.addSubview(cell.queryItem)
        
        return cell
    }
    
    override func layoutSubviews() {
        queryItem.frame = CGRectInset(bounds, 10, 5)
//        queryItem.descriptionLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
}

// Type One
class VCardSingleCardView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    
    var cardLayoutStyle = CardLayoutStyle.Header

    var descriptionArray = ["test", "also test", "test again"]
    
    // TODO: or just get a model, including strings/images/style etc.
    // for now, just a test for the views
    class func createSingleCardViewWithFrame(frame: CGRect) -> VCardSingleCardView {
        let singleCard = NSBundle.mainBundle().loadNibNamed("VCardSingleCards", owner: self, options: nil).first as! VCardSingleCardView
        singleCard.frame = frame
        singleCard.detailTableView.registerClass(VCardQueryCell.self, forCellReuseIdentifier: CellIdentifier)
        singleCard.layer.cornerRadius = 3
        return singleCard
    }
    

    var selectedIndex = -1
    
    func updateButtonState(selectedTag: Int) {
//        print("selectedTag is \(selectedTag), \(selectedIndex)")
        
        if selectedIndex < 0 {
            selectedIndex = selectedTag
            return
        }
        if selectedIndex == selectedTag {
            selectedIndex = -1
            return
        }
        
        let cell = detailTableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedIndex, inSection: 0)) as? VCardQueryCell
        cell?.queryItem.selected = false
        selectedIndex = selectedTag
    }
    
    // MARK: ---------- table view -------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = VCardQueryCell.queryCellWithTableView(tableView, description: descriptionArray[indexPath.row])
        cell.queryItem.selectButton.tag = indexPath.row
        cell.queryItem.cardViewDelegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return detailTableView.bounds.height/CGFloat(descriptionArray.count)
    }
}