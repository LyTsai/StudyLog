//
//  TRCellTip.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRCellTip: NSObject {
    var show: Bool?
    var sliceIndex: Int?
    var columnIndex: Int?
    var rowIndex: Int?
    var cellTip: ANText?
    
    override init() {
        super.init()
        show = true
        sliceIndex = -1
        columnIndex = -1
        rowIndex = -1
        
        cellTip = ANText.init("Helvetica", size: 16, shadow: true, underline: false)
        cellTip!.textAttributeDic![NSForegroundColorAttributeName] = UIColor.red
        cellTip!.textAttributeDic![NSStrokeColorAttributeName] = UIColor(red: 255/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1.0)
        cellTip!.textAttributeDic![NSUnderlineStyleAttributeName] = NSNumber(value: 2)
    }
    
    func paint(_ ctx: CGContext, cell: TRCell, position: CGPoint){
        print("real paint tip")
        if show == false || cellTip == nil {return}
        if cell.showValue == false{
            // do not show value
            cellTip!.text = cell.text!

        }else{
            // show value
            cellTip!.text = cell.text! + ""
            cellTip!.text!.append("\(cell.value!) ")
            cellTip!.text!.append(cell.unit!)
        }
        
        let textSize = cellTip!.attributedText.size()
        let rect = CGRect(x: position.x - 0.5 * textSize.width, y: position.y - 0.5 * textSize.height - 0.5 * CGFloat(cell.displaySize!), width: textSize.width, height: textSize.height + 2)
        
        cellTip!.textAttributeDic![NSForegroundColorAttributeName] = UIColor(red: 255/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1.0).cgColor
        cellTip!.textAttributeDic![NSStrokeColorAttributeName] = cell.metricColor
        cellTip!.paint(ctx, rect: rect)
        
    }

}
