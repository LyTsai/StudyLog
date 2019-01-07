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
        
        let texts = ["Do What's Easy", "Do What's Impactful", "Establish a Habit","Set Daily Reminders"]
        
        for (i, text) in texts.enumerated() {
            let item = ToDoListItem()
            item.image = UIImage(named: "item_\(i)")
            item.text = text
            list.append(item)
        }
        
        return list
    }
}
