//
//  PageControlTable.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/18.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// table cell
let DotCellID = "Dot Cell ID"
class DotCell: UITableViewCell {
    fileprivate let processedImage = UIImage(named: "processed")
    fileprivate let unprocessedImage = UIImage(named: "unprocessed")
    fileprivate let currentImage = UIImage(named: "current")
    fileprivate let dotImageView = UIImageView()
    
    // current is set after processed is set
    var processed = true {
        didSet {
            dotImageView.image = processed ? processedImage : unprocessedImage
        }
    }
    
    var current = false {
        didSet{
            if current == true {
                dotImageView.image = currentImage
            }
            layoutSubviews()
        }
    }
    
    class func cellWithTableView(_ tableView: UITableView, isProcessed: Bool, isCurrent: Bool) -> DotCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: DotCellID) as? DotCell
        if cell == nil {
            cell = DotCell(style: .default, reuseIdentifier: DotCellID)
            cell!.updateUI()
        }
        
        cell!.processed = isProcessed
        cell!.current = isCurrent
        
        return cell!
    }
    
    fileprivate func updateUI() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        dotImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(dotImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sub = min(bounds.width, bounds.height) * 0.2
        dotImageView.frame = current ? bounds.insetBy(dx: -sub, dy: -sub) : bounds.insetBy(dx: sub, dy: sub)
    }
}


// table
class PageControlTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var currentIndex = 0 {
        didSet{
            if currentIndex != oldValue {
                if currentIndex >= totalNumber || currentIndex < 0 {
                    return
                }else {
                    reloadData()
                    scrollToRow(at: IndexPath(row: currentIndex, section: 0), at: .middle, animated: true)
                }
            }
        }
    }

    fileprivate var totalNumber = 0
    class func createWithFrame(_ frame: CGRect, totalNumber: Int) -> PageControlTableView {
        let table = PageControlTableView(frame: frame, style: .plain)
        table.backgroundColor = UIColor.clear
        table.showsHorizontalScrollIndicator = false
        table.allowsSelection = false
        table.separatorStyle = .none
        
        table.totalNumber = totalNumber
        table.dataSource = table
        table.delegate = table
        
        return table
    }
    
    // dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isCurrent = (indexPath.row == currentIndex)
        let isProcessed = (indexPath.row < currentIndex)
        
        let cell = DotCell.cellWithTableView(tableView, isProcessed: isProcessed, isCurrent: isCurrent)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return min(bounds.width, bounds.height) * 1.3
    }
}
