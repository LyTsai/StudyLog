//
//  CDConnection.swift
//  ChordTest
//
//  Created by dingf on 16/12/12.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit
struct CnnNode {
    // ring index
    var ring :Int!
    // slice index
    var slice :Int!
    // cell index
    var cell :Int!
    // connectivity intensity in terms of percentage
    var intensity :CGFloat!
    // start / end angle degrees
    var left :CGFloat = 0
    var right :CGFloat = 0
    // true if already painted
    var painted :Bool!
}

// connection to other element (ring index, slice index, cell index)
// used for connection between two cell connectors
// each cell may have array of indexs to CDConnections that "connects" two cells

class CDConnection: NSObject {
    // node a and b of connector
    var cnnNodeA = CnnNode()
    var node_a :AnyObject!
    var cnnNodeB = CnnNode()
    var node_b :AnyObject!
    // small font for showing tips for groups of highlighted connectors
    var attrSmallFont :NSMutableDictionary!
    // large font
    var attrLargeFont :NSMutableDictionary!
    // label or connector text details
    var label :String!
    // information for visual presentation
    var aPath :UIBezierPath!
    // if show as highlighted
    var highlight :Bool!
    // if show tip
    var showTip :Bool!
    // if display in large font
    var largeFont :Bool!
    
    init(cnnLabel: String,
           ring_a: Int,
          slice_a: Int,
           cell_a: Int,
      intensity_a: CGFloat,
           ring_b: Int,
          slice_b: Int,
           cell_b: Int,
      intensity_b: CGFloat)
    {
        super.init()
        cnnNodeA.ring = ring_a
        cnnNodeA.slice = slice_a
        cnnNodeA.cell = cell_a
        cnnNodeA.intensity = intensity_a
        
        cnnNodeB.ring = ring_b
        cnnNodeB.slice = slice_b
        cnnNodeB.cell = cell_b
        cnnNodeB.intensity = intensity_b
        
        attrSmallFont = NSMutableDictionary()
        attrLargeFont = NSMutableDictionary()
        // set attrSmallFont and attr
        setSmall("Helverica" as CFString, size: 10, color:UIColor.darkText)
        setLarge("Helverica" as CFString, size: 12, color: UIColor.darkText)
        
        label = cnnLabel
        aPath = UIBezierPath()
        highlight = false
        showTip = true
        largeFont = false
    }
    
    // set very basic attributes. other cases please operate on the objects attrSmallFont and attrLargeFont directly
    func setSmall(_ font:CFString,size:CGFloat,color:UIColor){
        if attrSmallFont == nil{
            attrSmallFont = NSMutableDictionary()
        }
        let lbFont = CTFontCreateWithName(font, size, nil)
        attrSmallFont[NSFontAttributeName] = lbFont
        attrSmallFont[NSForegroundColorAttributeName] = color.cgColor
    }
    
    func setLarge(_ font:CFString,size:CGFloat,color:UIColor){
        if attrLargeFont == nil{
            attrLargeFont = NSMutableDictionary()
        }
        let lbFont = CTFontCreateWithName(font, size, nil)
        attrLargeFont[NSFontAttributeName] = lbFont
        attrLargeFont[NSForegroundColorAttributeName] = color.cgColor
    }
    
    // get intensity of the cell node
    func getIntensity(cell:AnyObject) -> CGFloat{
        if cell.isKind(of: CDCell.self) != true{
            return 0.0
        }
        if cell.isEqual(node_a) == true{
            return cnnNodeA.intensity
        }else if cell.isEqual(node_b) == true{
            return cnnNodeB.intensity
        }
        return 0.0
    }
    
    // set the left and right of connector's point A and point B ,it is according to the parameter "cell"
    func setNodeGuiSize(cell:AnyObject,left:CGFloat,right:CGFloat) -> Bool{
        if cell.isKind(of: CDCell.self) != true{
            return false
        }
        if cell.isEqual(node_a) == true{
            cnnNodeA.left = left
            cnnNodeA.right = right
        }else if cell.isEqual(node_b) == true{
            cnnNodeB.left = left
            cnnNodeB.right = right
        }
        return true
    }
    
    // hit test 
    func hitTest(_ pt:CGPoint) -> Bool{
        return aPath.contains(pt)
    }
}
