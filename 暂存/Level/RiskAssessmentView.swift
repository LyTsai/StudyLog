//
//  RiskAssessmentView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/10/10.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class RiskAssessmentView: UIView {
    var graph = ANGraph()
    var radialLayout = ANRadialLayout()
    
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
        
        // pinchGR
        let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(pinchNode))
        pinchGR.cancelsTouchesInView = true
        addGestureRecognizer(pinchGR)
    }
    
    // call to update layer position based on node graph
    func updateNodeLayerObjects() {
        for i in 0..<graph.numberOfNodes() {
           setFrameOfNode(i)
        }
    }

    fileprivate func setFrameOfNode(_ index: Int) {
        if let node = graph.node(index) {
            let radiusRatio = radialLayout.mapParams.treeSize / radialLayout.mapParams.treeSizeTran
            let sizeRatio = radialLayout.nodeVisualSizeRatio * radiusRatio // mapParams.sizeRatio * radiusRatio

            // for visual presentation us the value stored in _tran
            if !node.node.isHidden {
                let xySize = node.node.sizeTran * sizeRatio
                node.node.xySize = xySize
                
                let x = node.node.xPosition - xySize * 0.5
                let y = node.node.yPosition - xySize * 0.5
                
                let rc = CGRect(x: x, y: y, width: xySize, height: xySize)
                node.layer.loadOntoPage(layer, layout: rc)
            }
        }

    }
    
    // draw rect
    override func draw(_ rect: CGRect) {
        let color = colorPairs[0].fill
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
                color.setStroke()
                aPath.stroke()
            }
        }
    }

    // user interaction
    fileprivate var chosenIndex: Int = -1
    fileprivate var pinchIndex: Int = -1
    fileprivate var sizeTranRecord: CGFloat = 1
//    fileprivate var touchNode: ANNodeLayer!
//    fileprivate var pinchNode: ANNodeLayer!
    
    // pinchGR
    func pinchNode(_ pinchGR: UIPinchGestureRecognizer) {
        if pinchGR.state == .began {
            if let node = graph.node(pinchIndex) {
                sizeTranRecord = node.node.sizeTran
            }
        }else if pinchGR.state == .changed {
            if let node = graph.node(pinchIndex) {
                let scale = pinchGR.scale
                node.node.sizeTran = sizeTranRecord * scale
                // update the node position
                updateNodeLayerObjects()
                
                setFrameOfNode(pinchIndex)
                setNeedsDisplay()
            }
            
        }else {
            pinchIndex = -1
        }
    }
    
    // touches event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        
        // node being hit (or chosen)
        let nodeHit = graph.hitTest(point)
        
        for i in 0..<graph.numberOfNodes() {
            let rect = graph.getFrameOfNode(i)!
            if rect.contains(point) {
                chosenIndex = i
                pinchIndex = i
                
                break
            }
        }
        
        // back to original mapping first
        radialLayout.treeLayout_spaceShape(graph.getRoot(), bendspace: true, hostRc: self.bounds)
        // reset the focus
        _ = radialLayout.treeLayout_zoom_sub_tree(graph.getRoot(), node_focus: nodeHit?.node, hostRc: self.bounds)
        // update the node position
        updateNodeLayerObjects()
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let node = graph.node(chosenIndex) {
            let point = touches.first!.location(in: self)
            node.node.xPosition = point.x
            node.node.yPosition = point.y

            setFrameOfNode(chosenIndex)
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        pinchIndex = -1
        chosenIndex = -1
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        chosenIndex = -1
    }

}

// MARK: ----------------- load -----------------------------
extension RiskAssessmentView {
    func loadMapForRisk(_ riskKey: String, hostRc: CGRect) {
        // all info is loaded, if not, download
        // loaded, for test
        if let risk = collection.getRisk(riskKey) {
            // risk node
            let riskNodeLayer = ANNodeLayer.createWithImage(risk.imageObj?.cgImage, text: risk.name)
            let root = graph.createNewGraph(riskNodeLayer)
            
            let nNodes: Int = 0
            let weight: CGFloat = 1
            
            // categorys
            let categoryDic = collection.getOrganizedCardsOfRiskKey(riskKey)

            for (categoryKey, cards) in categoryDic {
                let category = collection.getMetricGroupByKey(categoryKey)
                let categoryNodeLayer = ANNodeLayer.createWithImage(category?.imageObj?.cgImage ?? UIImage(named: "child")!.cgImage, text: "")
                let categoryNode = graph.addNode(root, weight: weight, layer: categoryNodeLayer)!
                
                // cards
                for (i,_) in cards.enumerated() {
                    let cardNodeLayer = ANNodeLayer.createWithImage(UIImage(named: "card_maskCheck")!.cgImage, text: "\(i + 1)")
                    _ = graph.addNode(categoryNode, weight: weight, layer: cardNodeLayer)
                }
            }
            
            // layout
            radialLayout.treeLayout_spaceShape(root, bendspace: true, hostRc: hostRc)
            _ = radialLayout.treeLayout_zoom_shift_circle_by_focus(root, hostRc: hostRc, x0_byRatio: 0.75, y0_byRatio: -0.25)
            
        }else {
            print("risk does not exist")
        }
        
        updateNodeLayerObjects()
        setNeedsDisplay()
    }
    
    // test
    // assume as the numbers of cards for each category
    func loadTestNodesOfNumbers(_ numbers: [Int], hostRc: CGRect) {
        // risk node
        let riskNodeLayer = ANNodeLayer.createWithImage(nil, text: "")
        let root = graph.createNewGraph(riskNodeLayer)
        
        let nNodes: Int = 0
        let weight: CGFloat = 1
        
        // categorys
        for number in numbers {
            let categoryNodeLayer = ANNodeLayer.createWithImage(UIImage(named: "child")!.cgImage, text: "")
            let categoryNode = graph.addNode(root, weight: weight, layer: categoryNodeLayer)!
            
            // cards
            for i in 0..<number {
                let cardNodeLayer = ANNodeLayer.createWithImage(UIImage(named: "card_maskCheck")!.cgImage, text: "\(i + 1)")
                _ = graph.addNode(categoryNode, weight: weight, layer: cardNodeLayer)!
            }
        }
        
        // layout
        radialLayout.treeLayout_spaceShape(root, bendspace: true, hostRc: hostRc)
        _ = radialLayout.treeLayout_zoom_shift_circle_by_focus(root, hostRc: hostRc, x0_byRatio: 0.4, y0_byRatio: -0.1)
        
        updateNodeLayerObjects()
        setNeedsDisplay()
    }
}
