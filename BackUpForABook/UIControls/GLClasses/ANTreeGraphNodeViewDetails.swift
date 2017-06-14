//
//  ANTreeGraphNodeViewDetails.swift
//  ANTreeGraphLayout
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ANTreeOverlapViews {
    var viewDataSource: ANTreeGraphOverlapViewProtocol!
    var nodeDataSource: ANTreeMapDataSourceProtocal!

    func setNodeViewDetail()  {
        for row in 0..<nodeDataSource.numberOfRows() {
            for column in 0..<nodeDataSource.numberOfColumns(row) {
                let attachedView = viewDataSource.getNodeAttachedView(row, column: column)
                let nodeView = nodeDataSource.getNodeView(row, column: column) as! UIView? // as shadow
                
                
                if attachedView == nil || nodeView == nil {// meanwhile, the nodeView is nil too
                    continue
                }
                
                let cornerRadius = viewDataSource.getCornerRadius(row, column: column)
                nodeView!.layer.masksToBounds = true
                nodeView!.layer.cornerRadius = cornerRadius
                attachedView!.layer.masksToBounds = true
                attachedView!.layer.cornerRadius = cornerRadius
//                let alignment = viewDataSource.getAttachedViewContentAlignment(row, column: column)
//                attachedView!.contentHorizontalAlignment = alignment.horizontal
//                attachedView!.contentVerticalAlignment = alignment.vertical
//                
//                attachedView!.setAttributedTitle(viewDataSource.getAttachedViewAttributedText(row, column: column), for: .normal)
//                attachedView!.titleEdgeInsets = viewDataSource.getAttachedViewTitleEdgeInsets(row, column: column)
//                attachedView!.setImage(viewDataSource.getAttachedViewImage(row, column: column), for: .normal)
//                attachedView!.imageEdgeInsets = viewDataSource.getAttachedViewImageEdgeInsets(row, column: column)
                attachedView!.backgroundColor = viewDataSource.getAttachedViewBackgroundColor(row, column: column)
                
                // buttonClicked
                // backgroundImage?
                
                nodeView!.backgroundColor = viewDataSource.getNodeBackgroundColor(row, column: column)
            }
        }
    }
    
    func adjustEdgeInsets(){
        for row in 0..<nodeDataSource.numberOfRows() {
            for column in 0..<nodeDataSource.numberOfColumns(row) {
                let attachedView = viewDataSource.getNodeAttachedView(row, column: column)
                let nodeView = nodeDataSource.getNodeView(row, column: column) as! UIView? // as shadow
                
                if attachedView == nil || nodeView == nil {// meanwhile, the nodeView is nil too
                    continue
                }
                
//                attachedView!.titleEdgeInsets = viewDataSource.getAttachedViewTitleEdgeInsets(row, column: column)
//                attachedView!.imageEdgeInsets = viewDataSource.getAttachedViewImageEdgeInsets(row, column: column)
            }
        }
    }
}
    
protocol ANTreeGraphOverlapViewProtocol {
    func getCornerRadius(_ row: Int, column: Int) -> CGFloat
    
    // the node view
    func getNodeBackgroundColor(_ row: Int, column: Int) -> UIColor

    // the overlap - attachedView
    func getNodeAttachedView(_ row: Int, column: Int) -> UIView? // the view on the top
    //func getAttachedViewAttributedText(_ row: Int, column: Int) -> NSAttributedString?
    //func getAttachedViewContentAlignment(_ row: Int, column: Int) -> (horizontal: UIControlContentHorizontalAlignment,vertical: UIControlContentVerticalAlignment)
    //func getAttachedViewTitleEdgeInsets(_ row: Int, column: Int) -> UIEdgeInsets
    //func getAttachedViewImage(_ row: Int, column: Int) -> UIImage?
    //func getAttachedViewImageEdgeInsets(_ row: Int, column: Int) -> UIEdgeInsets
    func getAttachedViewBackgroundColor(_ row: Int, column: Int) -> UIColor
}
