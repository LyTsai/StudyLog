//
//  SelectTableView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/11/30.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

let selectCellIdentifier = "selectCell"

class SelectCell: UITableViewCell {
    var leftImage = UIImage() {
        didSet{ imageView!.image = leftImage }
    }
    var cellText = "Tree" {
        didSet{ textLabel!.text = cellText }
    }
    
    fileprivate var selectSwitch: NormalSwitch!
    
    var isOn = false {
        didSet{
            // change text's fontSize, background, image
            backgroundColor = isOn ? UIColor(white: 1, alpha: 0.4) : UIColor(white: 1, alpha: 0.01)
            textLabel?.font = isOn ? UIFont.boldSystemFont(ofSize: 19) : UIFont.systemFont(ofSize: 12)
        }
    }
    
    weak var table: UITableView!
    var row = -1
    
    class func cellWithTableView(_ tableView: UITableView, indexPath: Foundation.IndexPath) -> SelectCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: selectCellIdentifier) as? SelectCell
        if cell == nil {
            cell = SelectCell(style: .default, reuseIdentifier: selectCellIdentifier)
            cell!.selectSwitch = NormalSwitch.createSwitchWithSwitchModel(SwitchModel())
            cell!.addSubview(cell!.selectSwitch)
            cell!.textLabel?.textColor = UIColor.white
            cell!.textLabel?.textAlignment = .left
            cell!.selectionStyle = .none
        }
        
        cell!.selectSwitch.cellDelegate = cell!
        cell!.backgroundColor = UIColor(white: 1, alpha: 0.01)
        cell!.table = tableView
        cell!.row = indexPath.row
        
        return cell!
    }
    
    var margin: CGFloat = 7
    var switchRatio: CGFloat = 3
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = bounds.height - 2 * margin
        let x = bounds.width - height * switchRatio - margin
        
        selectSwitch.frame = CGRect(x: x, y: margin, width: height * switchRatio, height: height)
        selectSwitch.layoutSubviews()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        selectSwitch.switchState = .unselected
    }
    
    func changeState() {
        let select = table as! SelectTableView
        if selectSwitch.switchState == .selectedOn {
            isOn = true
            
            select.onRows.append(row)
            for (index, offRow) in select.offRows.enumerated() {
                if offRow == row { select.offRows.remove(at: index) }
            }
            
        }else if selectSwitch.switchState == .selectedOff {
            isOn = false
            select.offRows.append(row)
            for (index, onRow) in select.onRows.enumerated() {
                if onRow == row { select.onRows.remove(at: index) }
            }
        }
    }
}

class SelectTableView: UITableView, UITableViewDataSource {
    var dataArray = [MetricModel](){
        didSet{
            if dataArray != oldValue { reloadData() }
        }
    }
    // to save to see which is on, and save data later
    var onRows = [Int]()
    var offRows = [Int]()
    
    class func createTableViewWithFrame(_ frame: CGRect) -> SelectTableView {
        let table = SelectTableView(frame: frame, style: .plain)
        table.backgroundColor = UIColor.clear
        table.dataSource = table
        table.separatorColor = UIColor.clear
        return table
    }
    
    // dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SelectCell.cellWithTableView(tableView, indexPath: indexPath)
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    fileprivate func configureCell(_ cell: SelectCell, indexPath: Foundation.IndexPath){
        let metric = dataArray[indexPath.row]
        cell.cellText = metric.name!
        //        cell.leftImage = metric.image.image
        cell.selectSwitch.switchState = .unselected
        
        // real state
        if onRows.contains(indexPath.row) {
            cell.selectSwitch.switchState = .selectedOn
        }else if offRows.contains(indexPath.row) {
            cell.selectSwitch.switchState = .selectedOff
        }
    }
}
