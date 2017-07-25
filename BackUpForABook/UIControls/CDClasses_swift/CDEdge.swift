//
//  CDEdge.swift
//  ANBookPad
//
//  Created by dingf on 16/12/12.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

class CDEdge: NSObject {
    var background:CDSliceBackground!
    var runtimeSize_edge:CGFloat!
    var size :CGFloat!
    override init() {
        size = 0.0
        runtimeSize_edge = 1.0
        background = CDSliceBackground.init()
        background.highlight = false
        background.highlightStyle = HighLightStyle.fill
        background.style = BackgroundStyle.colorFill
        background.bkgColor = UIColor.lightGray
        background.edgeColor = UIColor.lightGray
    }
    
    func translateChildernFontSize(_ pointsPerFontSize:CGFloat){
        runtimeSize_edge = size * pointsPerFontSize
    }
    func takeOutRuntimeSize() -> CGFloat{
        return runtimeSize_edge
    }
    

}
