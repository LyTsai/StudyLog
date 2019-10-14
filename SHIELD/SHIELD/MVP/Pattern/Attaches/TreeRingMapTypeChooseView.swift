//
//  TreeRingMapTypeChooseView.swift
//  AnnielyticX
//
//  Created by L on 2019/5/6.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class TreeRingMapTypeChooseView: PullDownMenuView, UITableViewDataSource, UITableViewDelegate {
    var titleIsChosen: ((Int)->Void)?
    
    fileprivate var titles = [String]()
    var chosenTypeIndex = 0
    fileprivate var cellHeight: CGFloat = 0
    
    fileprivate var assistView: UIView!
    fileprivate var table: UITableView!
    // create
    class func createWithFrame(_ frame: CGRect, titles: [String], tableFrame: CGRect, bottomHeight: CGFloat) -> TreeRingMapTypeChooseView {
        let table = UITableView(frame: tableFrame, style: .plain)
        table.bounces = false
        table.backgroundColor = UIColor.clear
        table.separatorStyle = .none
        
        let chooseView = TreeRingMapTypeChooseView(frame: frame)
        chooseView.backgroundColor = UIColor.clear
        chooseView.titles = titles
        chooseView.cellHeight = tableFrame.height / CGFloat(max(1, titles.count))
        chooseView.bottomHeight = bottomHeight
  
        // data
        table.dataSource = chooseView
        table.delegate = chooseView
        table.contentInsetAdjustmentBehavior = .never
        
        chooseView.table = table
        chooseView.addSubview(table)
        chooseView.setDisplayState(true)
      
        return chooseView
    }
    

    func setDisplayState(_ display: Bool)  {
        self.display = display
        table.isHidden = !display
        
        setNeedsDisplay()
    }
    
    func updateTable() {
        table.reloadData()
    }
    
    // data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TreeRingMapTypeChooseCell.cellWithTableView(tableView, text: titles[indexPath.item], chosen: indexPath.item == chosenTypeIndex)
    }
    
    // delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if chosenTypeIndex != indexPath.item {
            let update = [IndexPath(item: chosenTypeIndex, section: 0), indexPath]
            chosenTypeIndex = indexPath.item
            tableView.reloadRows(at: update, with: .automatic)
        }
      
        titleIsChosen?(indexPath.item)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
}


