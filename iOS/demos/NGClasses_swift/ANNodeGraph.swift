//
//  ANNodeGraph.swift
//  NGClasses
//
//  Created by iMac on 16/12/14.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ANNodeGraph: UIView {
    // nodes collection (graph nodes and layer presentation)
    fileprivate var graph = ANGraph()
    
    // radial layout rendering engine
    fileprivate var radialLayout = ANRadialLayout()
    
    // init method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitData()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInitData()
    }
    
    fileprivate func setupInitData() {
        backgroundColor = UIColor.white
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    // draw the connection lines
    var bTest = false
    override func draw(_ rect: CGRect) {
        // enable for testing purpose
        
        if bTest {
            // (1) draw frame
            let rectanglePath = UIBezierPath(rect: bounds.insetBy(dx: 80, dy: 80))
            let strokeColor = UIColor(white: 0, alpha: 1)
            let lineWidth: CGFloat = 1
            
            rectanglePath.lineWidth = lineWidth
            strokeColor.setStroke()
            rectanglePath.stroke()
        }
        
        // (2) node to child node connections
        for i in 0..<graph.numberOfNodes(){
            let node = graph.node(i)
            
            if node == nil || node!.node.children.count <= 0 {
                continue
            }
            
            for child in node!.node.children {
                if child.isHidden == true { continue }

                let aPath = UIBezierPath()
                aPath.move(to: CGPoint(x: node!.node.xPosition, y: node!.node.yPosition))
                aPath.addLine(to: CGPoint(x: child.xPosition, y: child.yPosition))
                aPath.lineWidth = 1
                UIColor(white: 0, alpha: 0.6).setStroke()
                aPath.stroke()
            }
        }
    }
}

// MARK: -------------- the public method in the orginal interface file
extension ANNodeGraph {
    // access graph node collection: data source
    // you need to get ANGraph object before feeding data set.
    // see how graph data are loaded into graph from createTestGraph function
    func getGraph() -> ANGraph {
        return graph
    }
  
    // graph rendering nethods.  after this call the nodes are placed onto coorect positions with size ready for drawing
    // MARK: --------- the orginal method has a parameter "graph", which is never called, so I removed it here
    func radialLayout(_ hostRc: CGRect) {
        // (1) layout onto page hostRC
        // with space bending
        radialLayout.treeLayout_spaceShape(graph.getRoot(), bendspace: true, hostRc: hostRc)
        // (2) resposition layer nodes and put on the page
        updateNodeLayerObjects()
    }
    
    // call to update layer position based on node graph
    func updateNodeLayerObjects() {
       
        let radiusRatio = radialLayout.mapParams.treeSize / radialLayout.mapParams.treeSizeTran
        let sizeRatio = radialLayout.nodeVisualSizeRatio() * radiusRatio
        
        for i in 0..<graph.numberOfNodes() {
            let node = graph.node(i)
            
            if node == nil { continue }
            
            // ignore the layer, will not shown, leave a gap
            if node!.node.isHidden == true { continue }
            
            let path = node!.layer
            // for visual presentation us the value stored in _tran
            let width = node!.node.sizeTran * sizeRatio
            let height = node!.node.sizeTran * sizeRatio
            
            let x = node!.node.xPosition - width * 0.5
            let y = node!.node.yPosition - height * 0.5
                
            let rc = CGRect(x: x, y: y, width: width, height: height)
            path.loadOntoPage(layer, layout: rc)
        }
    }
    
    //////////////////////////////////////////////
    // test functions
    //////////////////////////////////////////////
    
    func loadTestNodeTree()  {
         // TODO: ---------- not used now
    }
    
    func loadTestNodeTree_New()  {
        // (1) load testing node graph
        graph.createTestGraph()
        // (2) render onto rect area
        let hostRc = bounds.insetBy(dx: 0, dy: 0)
        radialLayout(hostRc)
    }

    
}
