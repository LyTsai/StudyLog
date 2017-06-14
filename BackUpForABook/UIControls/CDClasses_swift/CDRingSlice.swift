//
//  CDRingSlice.swift
//  ANBookPad
//
//  Created by dingf on 16/12/12.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

enum SliceSize: Int{
    case fixed = 1
    case auto
}

class CDRingSlice: NSObject {
    var label: String!
    var cells: NSMutableArray!
    var showBackground: Bool!
    var background: CDSliceBackground!
    var gap: CGFloat!
    var left: CGFloat!
    var right: CGFloat!
    var maxSize: CGFloat!
    var size: CGFloat!
    var sizeStyle: SliceSize!
    
    override init() {
        super.init()
        cells = NSMutableArray()
        background = CDSliceBackground.init()
        sizeStyle = SliceSize.auto
        maxSize = 180.0
        size = 90.0
        gap = 0.5
        showBackground = false
    }
    
    // create n initial cells 
    func createCells(_ nCells:Int){
        if cells == nil{
            cells = NSMutableArray.init(capacity: nCells)
        }else{
            cells.removeAllObjects()
        }
        for _ in 0..<nCells{
            cells.add(CDCell.init())
        }
    }
    func cell(_ ncell:Int) -> CDCell!{
        if cells == nil || ncell >= cells.count{
            return nil
        }else{
            return cells.object(at: ncell) as! CDCell
        }
    }
    
    // paint ring slice
    func paint(_ ctx: CGContext,
              center: CGPoint,
              bottom: CGFloat,
                 top: CGFloat,
         frameHeight: CGFloat){
        
        // save current context
        ctx.saveGState()
        
        if showBackground == true{
            var size = RingSlice()
            size.left = left
            size.right = right
            size.bottom = bottom
            size.top = top
            background.paint(ctx, size: size, center: center)
        }
        
        // paint ring slice cells
        for i in 0..<cells.count{
            let cell = cells.object(at: i) as! CDCell
            cell.paint(ctx, center: center, bottom: bottom, top: top, frameHeight: frameHeight)
        }
        
        // restore the original contest
        ctx.restoreGState()
    }
    func numberOfCells() -> Int{
        return cells.count
    }
    
    // set the position (left and right) of each cell at one slice
    func onDirtyView(){
        if self.numberOfCells() <= 0{
            return
        }
        var totalWeight:CGFloat = 0.0
        for i in 0..<numberOfCells(){
            totalWeight += cell(i).sizeWeight
        }
        let density = (left - right - gap * CGFloat(cells.count - 1)) / totalWeight
        var start = right
        for i in 0..<numberOfCells(){
            cell(i).right = start
            cell(i).left = start! + density * (cell(i).sizeWeight)
            start = cell(i).left + gap
        }
        for i in 0..<numberOfCells(){
            cell(i).onDirtyView()
        }
    }
    
    
    
    
    

}
