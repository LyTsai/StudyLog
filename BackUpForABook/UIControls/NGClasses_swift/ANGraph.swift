//
//  ANGraph.swift
//  NGClasses
//
//  Created by iMac on 16/12/13.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// wrap a ANLayoutNode tree
class ANGraph {
    // root of embeded node tree.
    // caller can directly attach a ANLayoutNode tree by passing a root.  an empty ANGraphNodeLayer object will be crated for each node for reserving the drawing layer
    fileprivate var root: ANLayoutNode!
    
    // array of ANGraphNodeLayer stored in _root
    fileprivate var allNodes = [ANGraphNodeLayer?]()
}

extension ANGraph {
    // access the root object
    func getRoot() -> ANLayoutNode {
        return root
    }
    
    /////////////////////////////////////////////////////////////////////////////
    // functions for creating and populating graph tree of ANGraphNodeLayer node
    // starting a new graph
    func createNewGraph(_ layer: ANNodeLayer) -> ANLayoutNode {
        root = ANLayoutNode()
        
        // create {node, layer} object and add onto _allNodes
        root.index = 0
        allNodes.append(ANGraphNodeLayer(root, layer: layer))
        
        return root
    }
    
    // add node
    func addNode(_ parent: ANLayoutNode!, index: Int, weight: CGFloat, layer: CALayer) -> ANLayoutNode? {
        if parent == nil {
            return nil
        }
        
        // create a new node
        let node = parent.addNode(index, weight: weight)
        
        // create {node, layer} object and add onto _allNodes
        node.index = allNodes.count
        allNodes.append(ANGraphNodeLayer(node, layer: layer))
        
        return node
    }
    
    // remove node
    func removeNode(_ parent: ANLayoutNode!, node: ANLayoutNode!) {
        if parent == nil || node == nil {
            return
        }
        
        // remove from _allNodes
        if allNodes.count != 0 && node.index >= 0 && node.index < allNodes.count {
            allNodes[node.index] = nil
        }
        parent.removeNode(node)
    }
    
    /////////////////////////////////////////////////////////////////////////////
    // access to nodes synced inside array
    func numberOfNodes() -> Int {
        return allNodes.count
    }
    
    func node(_ index: Int) -> ANGraphNodeLayer? {
        if index < 0 || index >= allNodes.count {
            return nil
        }
        
        return allNodes[index]
    }
    
    // call this function to resync after delting many nodes
    fileprivate func syncUp(_ node: ANLayoutNode!, nodeArray allNodes: inout [ANGraphNodeLayer?]) {
        if node == nil {
            return
        }
        
        node.index = allNodes.count
        allNodes.append(ANGraphNodeLayer(node))
        
        for child in node.children {
            syncUp(child, nodeArray: &allNodes)
        }
    }
    
    // sync up node index.  !!! an internal dynamic array of ANGraphNodeLayer is maintainted internally.  the array is for the purpose of fast accessing to nodes of embeded tree.  as result the index needs to be synced up each time when the tree structure changes
    func syncUpNodesIndex() {
        if root == nil { return }
        syncUp(root, nodeArray: &allNodes)
    }
    
    // pick a sub-tree
    func pickSubTree() -> ANLayoutNode? {
        var node = root.children.last
        node = node?.children.last

        return node
    }
 
    // pick a segment
    func pickSegment() -> ANLayoutNode? {
        return root.children.last
    }
    
    /////////////////////////////////////////////////////////////////////////////
    // functions for test purpose
    /////////////////////////////////////////////////////////////////////////////
    // create tree of graph with presentation layer
    func createTestGraph() {
        let root = createNewGraph(getRandomSymbolPath_Face())
        
        let nNodes: Int = 0
        let weight: CGFloat = 1
        var segment: Int = 0
        
        // segment Prenatal
        let prenatal = addNode(root, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        prenatal.segment = segment
 
        var node = addNode(prenatal, index: nNodes, weight: weight, layer: getRandomSymbolPath())!
        node.segment = segment
        var risks = addNode(prenatal, index: nNodes, weight: weight, layer: getRandomSymbolPath())!
        risks.segment = segment

        node = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())!
        node.segment = segment
        node = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())!
        node.segment = segment
        
        risks = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())!
        risks.segment = segment
        
        node = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())!
        node.segment = segment
        node = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())!
        node.segment = segment
        
        risks = addNode(prenatal, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        risks.segment = segment
        
        node = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        node.segment = segment
        node = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        node.segment = segment
      
        // segment Infant
        segment += 1
        let infant = addNode(root, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        let _ = addNode(infant, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())
        
        risks = addNode(infant, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
   
        // segment Child
        let child = addNode(root, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        let _ = addNode(child, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())
        
        risks = addNode(child, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        
        // segment Adult
        let adult = addNode(root, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        let _ = addNode(adult, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())
        
        risks = addNode(adult, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())

        risks = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
   
        // segment Elderly
        let elderly = addNode(root, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        let _ = addNode(elderly, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())
        
        risks = addNode(elderly, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        
        risks = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath_Face())!
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())
        let _ = addNode(risks, index: nNodes, weight: weight, layer: getRandomSymbolPath())

    }
}
