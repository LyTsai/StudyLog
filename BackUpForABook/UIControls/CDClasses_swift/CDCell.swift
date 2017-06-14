//
//  CDCell.swift
//  ChordTest
//
//  Created by dingf on 16/12/12.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

class CDCell: NSObject {
    var textPainter: ANCircleText!
    // array of CDConnector object ids
    var connectorIDs = NSMutableArray()
    
    var symbolAttrubutes: [String : AnyObject]!
    var showImage: Bool!
    var showSymbol: Bool!
    var showBackground: Bool!
    var image: UIImage!
    var text: String!
    
    var symbol: NSMutableString!
    var background: CDSliceBackground!
    var sizeWeight: CGFloat!
    var left: CGFloat!
    var right: CGFloat!
    
    override init() {
        super.init()
        symbolAttrubutes = [String : AnyObject]()
        showImage = false
        showSymbol = false
        showBackground = true
        background = CDSliceBackground.init()
        sizeWeight = 1.0
        textPainter = ANCircleText.init()
        textPainter.space = 0
    }
    
    // paint ringSlice
    func paint(_ ctx: CGContext,
              center: CGPoint,
              bottom: CGFloat,
                 top: CGFloat,
         frameHeight: CGFloat){
        
        ctx.saveGState()
        
        var size = RingSlice()
        size.left = left
        size.right = right
        size.bottom = bottom
        size.top = top
        
        // paint ring slice background first
        if showBackground == true{
            background.paint(ctx, size: size, center: center)
        }
        // paint image
        if showImage == true && image != nil{
        
        }
        // paint text in cell
        if showSymbol == true && symbol != nil && symbol.length > 0{
            drawSymbol(ctx, size: size, center: center)
        }
        ctx.restoreGState()
    }
    
    // paint text in cell
    func drawSymbol(_ ctx:CGContext,size:RingSlice,center:CGPoint){
        
        // draw symbol at the center of size
        // make attributed string for the title first
        let attString = NSMutableAttributedString.init(string: symbol as String, attributes: symbolAttrubutes)
        // dingf.mark
        let symbolStyle = RingTextStyle.alignMiddle
        var left = size.left!
        var right = size.right!
        if max(left, right) >= 360.0{
            left -= 360.0
            right -= 360.0
        }
        textPainter.paintCircleText(ctx, text: attString, style: symbolStyle, radius: size.bottom, width: (size.top - size.bottom), left: left, right: right, center: center)
    }
    
    // set the connectors of one cell
    func onDirtyView(){
        var totalIntensity :CGFloat = 0.0
        if connectorIDs.count <= 0{
            return
        }
        
        for i in 0..<connectorIDs.count{
            let connector = connectorIDs.object(at: i) as! CDConnection
            totalIntensity += connector.getIntensity(cell: self)
        }
        
        var start :CGFloat = right
        let den :CGFloat = (left - right) / CGFloat(connectorIDs.count)
        var end :CGFloat!
        for i in 0..<connectorIDs.count{
            end = start + den
            let connector = connectorIDs.object(at: i) as! CDConnection
            // set connector's left and right,this is the key point of draw connection line !
            let _ = connector.setNodeGuiSize(cell: self, left: end, right: start)
            start = end
        }
    }
}
