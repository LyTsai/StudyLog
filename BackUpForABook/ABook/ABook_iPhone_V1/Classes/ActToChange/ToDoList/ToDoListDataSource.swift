//
//  ToDoListDataSource.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/12.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class ToDoListItem {
    var image: UIImage!
    var checkedImage: UIImage! // check mark
    var text = ""
    var checked = false
    
    // data
    class func getCurrentData() -> [ToDoListItem] {
        var list = [ToDoListItem]()
        
        let texts = ["我现在的选择会影响哪些风险", "", "Set Daily Reminders", "我现在的生活方式", "Establish a Habit", "Do What's Easy", "Do What's Impactful","Share Info with others", "Get Others Involved"]
        
        for (i, text) in texts.enumerated() {
            let item = ToDoListItem()
            item.image = UIImage(named: "item_\(i)_un") ?? UIImage(named: "item_\(7)_un")
            item.text = text
            list.append(item)
        }
        
        return list
    }
}

// with model
extension ToDoListDetailView {
    class func createWithFrame(_ frame: CGRect, item: ToDoListItem) -> ToDoListDetailView {
        let detailView = ToDoListDetailView()
    
        detailView.setupUI(frame, image: item.image, text: item.text)
        
        return detailView
    }
}
