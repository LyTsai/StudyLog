//
//  ANRadialLayout.swift
//  NGClasses
//
//  Created by iMac on 16/12/14.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// circle corodiante to hoting rect mapping mode
enum MappingMode: Int {
    case byRadis        = 1 // by circle radius
    case byDimension        // by circle dimension
}

// define structure for mapping radial positions to hosting rect area
struct Circle2RectMapping {
    // hosting rect information
    var left: CGFloat = 0
    var right: CGFloat = 0
    var top: CGFloat = 0
    var bottom: CGFloat = 0
    
    // circle to rect mapping function selection
    // virtual circle information
    
    // radius (without space bending)
    var radius: CGFloat = 100
    
    // radius after space bending
    // by rPosition
    var treeSize: CGFloat = 0
    // by rPosition_tran
    var treeSizeTran: CGFloat = 0
    // largerst node size on the edge in transitional state
    var edgeTran: CGFloat = 0
    
    // map between rect and circle using (rPosition, aPosition) or (rPosition_tran, aPosition_tran)
    var bUseTran = true
    
    // try best to minimize overlaping?
    var bMinimizeOveralp = true
    
    // shift in mapping.  default is to put the circle and rect center on top of each other
    // dynamic parameter
    var orginShift: XYPos = XYPos(x: 0, y: 0)
    
    // circle corodinate to hosting rect mapping mode
    var mappingMode: MappingMode = .byDimension
    
    /////////////////////////////////////////////////////////////////////////
    // dynamic parameters (do not modify):
    /////////////////////////////////////////////////////////////////////////
    
    // ratio used for mapping node size in virtual space to hosting RECT area.  this is the size ration between node size on rect and virtual circle
    var sizeRatio: CGFloat = 1
    
    // new radius for the sub trees (exclude the sub tree with greater than 180 degree) areas after moving to the new  circle center (by _orginShift)
    var radius1: CGFloat = 100
    
    // rect center position
    var x0: CGFloat = 0
    var y0: CGFloat = 0
    
    // run time mapping for the four quad
    var kr: CGFloat = 0  // right
    var kl: CGFloat = 0  // left
    var kt: CGFloat = 0  // top
    var kb: CGFloat = 0  // bottom
    
    // run time mapping from circle coordinate to hosting rect coordinate
    var kx: CGFloat = 0    //
    var ky: CGFloat = 0    //
    
    // (xPosition, yPosition) range of virtual circel for mapping purpose
    var xPositionMin: CGFloat = 0
    var xPositionMax: CGFloat = 0
    var yPositionMin: CGFloat = 0
    var yPositionMax: CGFloat = 0
}

// data structure used for "zooming" given sub-tree segment
struct AngleZoomParams {
    var k: CGFloat       // angle slop
    var c: CGFloat       // angle shift
    var b: CGFloat       // angle bias (or beginning position)
}

///////////////////////////////////////////////////////////////////////////////
// layout the tree.  called top set up the inital tree layout
///////////////////////////////////////////////////////////////////////////////
// radial layout public functions

// !!! the purpose of tree node layout is to compute for each node the following visual paramters: (1) position {r, angle} in circle coordinate (2) radius distance for gap between node level (3) visual size (4)

// layout the tree.  assumes the tree is already setup with size and distance (by calling calculateTreeStrength)
// node - tree root
// r0 - hosting circle radius
// shifts - intrinsic center shift
// aRatio - ratio to combine the two angular range: aRatio * uniform + (1.0 - aRatio) * weighted  aRatio = 1.0 for using uniform angular width

// default version that
func radialLayout(_ node: ANLayoutNode, aRatio: CGFloat, mapParams: inout Circle2RectMapping) -> Int {
    // !!! assumes all sub treees have been computed for their distance and strength already (by calling calculateTreeStrength) etc
    
    ////////////////////////////////////////
    // Phase one: inital layout
    ////////////////////////////////////////
    var distanceParams = Level2DistanceParams()
    distanceParams.setDefaultLevel2DistanceParams(type: LayoutType.layoutType1)

    // (1) compute tree node strength first
    ANLayoutNode.calculateTreeStrength(node, param: &distanceParams)
    // virtual circle radius
    mapParams.radius = distanceParams.maxDistance
    
    // (2) angular distribution of root (level one child nodes) node first
    
    // TODO: ------------------- will this method return number other than 0 ?????????????????
    let rc = radialLayout_root_2(node, r0: mapParams.radius, r1: &mapParams.radius1, aRatio: aRatio, shifts: &mapParams.orginShift)
    if rc != 0 { return rc }
    
    // (3) all rest of the nodes (level two and above nodes)
    for child in node.children {
        let _ = radialLayout_node_2(child)
    }
    
    return 0
}

// version that perform uniform layout first followed by layout space defromation (transform by specified function)
// aRatio - weight between uniform angle or by strength for the level one sub trees
func radialLayout_spaceShape(_ node: ANLayoutNode, aRatio: CGFloat, mapParams: inout Circle2RectMapping) -> Int {
    // !!! assumes all sub treees have been computed for their distance and strength already (by calling calculateTreeStrength) etc
    
    ////////////////////////////////////////
    // Phase one: inital layout
    ////////////////////////////////////////
    var distanceParams = Level2DistanceParams()
    distanceParams.setDefaultLevel2DistanceParams(type: LayoutType.layoutType3)
  
    // (1) compute tree node strength first
    ANLayoutNode.calculateTreeStrength(node, param: &distanceParams)
 
    // virtual circle radius
    mapParams.radius = distanceParams.maxDistance
    
    // (2) angular distribution of root (level one child nodes) node first
    let rc = radialLayout_root_2(node, r0: mapParams.radius, r1: &mapParams.radius1, aRatio: aRatio, shifts: &mapParams.orginShift)
    if rc != 0 {  return rc }

    // (3) all rest of the nodes (level two and above nodes)
    for child in node.children {
        let _ = radialLayout_node_2(child)
    }
    ////////////////////////////////////////
    // (4) bent space shape
    ////////////////////////////////////////
    var ratios: CircleScaling!
    
//    CircleScaling ratios;
//    
//    setScalingRatio_1(&ratios);
//    radialLayoutTransform_scaling(node, &ratios);
//    
    return 0;

}

///////////////////////////////////////////////////////////////////////////////
// set focusing node on top of inital tree layout
// node - node of sub tree
// size - new size of focusing node
// mapParams [in, out] mapping information
// (1) locate the node and increse the node size if new size is greater than the current one
// (2) compute the new location (rDiatance) and size of node
// (3) compute the increase in angular as result of (2)
// (4) as result of (3) parent of node will be "pushed" towards the center while child nodes are all enlardged
// (5) compute the shift and new size as result of (4) by calling radialLayout_shiftByAngularRangeChange
func radialLayout_setFocus(_ node: ANLayoutNode, size: CGFloat, mapParams: inout Circle2RectMapping) -> Int {
    // !! make sure to update node zoom.  see radialLayout_node_1 and radialLayout_node_2
    
    return 0
}

///////////////////////////////////////////////////////////////////////
// transform to rect area for the given rect based mapping information
// (aPosition_tran, rPosition_tran) to (xPosition, yPosition)
// fill out (x, y) or (xPosition, yPosition) field of each node for the given rect and mapping

// call getTreeDimension to get virtual circle dimentison for mapping onto hosting rect area
// the final result is to translate from (aPosition_tran, rPosition_tran) to (xPosition, yPosition)
func radialLayout_transform_by_demension(_ node: ANLayoutNode!, mapParams: inout Circle2RectMapping) {
    if node == nil { return }
    
    // (0) get original size of tree
    var treeSize: CGFloat = 0
    var treeSizeTran: CGFloat = 0
    var edgeTran: CGFloat = 0
    
    getTreeLength(node, length: &treeSize, lengthTran: &treeSizeTran, edgeTran: &edgeTran)
    
    mapParams.treeSize = treeSize
    mapParams.treeSizeTran = treeSizeTran
    mapParams.edgeTran = edgeTran
    
    // (1) call updateNodeXYTranPositions to project (xPostion, yPostion) from (rPostion_tran, aPositon_tran)
    updateNodeXYTranPositions(node)
    
    // (2) get node tree (xPostion, yPostion) dimension
    mapParams.xPositionMin = 10000000.0
    mapParams.xPositionMax = -10000000.0
    mapParams.yPositionMin = 10000000.0
    mapParams.yPositionMax = -10000000.0
    
    getTreeDimension(node, mapParams: &mapParams)
    
    // (3) map circle of (mapParams->_xPosition_Min, mapParams->_xPosition_Max, mapParams->_yPosition_Min, mapParams->_yPosition_Max) onto (mapParams->_left, mapParams->_right, mapParams->_top, mapParams->_bottom)
    
    mapParams.kx = (mapParams.right - mapParams.left) / (mapParams.xPositionMax - mapParams.xPositionMin)
    mapParams.ky = (mapParams.bottom - mapParams.top) / (mapParams.yPositionMin - mapParams.yPositionMax)
    
    // (4) transform the layout
    linear_tranform_by_demension(node, mapParams: &mapParams)
}

// based on the size of virtual circle
func radialLayout_transform(_ node: ANLayoutNode!, mapParams: inout Circle2RectMapping) {
    if node == nil { return }
    
    if mapParams.mappingMode == .byRadis {
        radialLayout_transform_by_radius(node, mapParams: &mapParams)
    } else if mapParams.mappingMode == .byDimension {
        radialLayout_transform_by_demension(node, mapParams: &mapParams)
    }
}

// map circle coordinate onto hosting rect coordiante by circle radius
func radialLayout_transform_by_radius(_ node: ANLayoutNode!, mapParams: inout Circle2RectMapping) {
    if node == nil { return }

    // (1) get original size of tree
    var treeSize: CGFloat = 0
    var treeSizeTran: CGFloat = 0
    var edgeTran: CGFloat = 0
    
    getTreeLength(node, length: &treeSize, lengthTran: &treeSizeTran, edgeTran: &edgeTran)
    
    mapParams.treeSize = treeSize
    mapParams.treeSizeTran = treeSizeTran
    mapParams.edgeTran = edgeTran
    
    if mapParams.bUseTran {
        // use treeSize_tran
        treeSize = treeSizeTran
        
        // need to leave marge at the edge so node will be kept within hosting rect ?
        treeSize += edgeTran * 0.5
    }
    
    // (2) mapping shift stored in mapParams indicates the cut into portion of area to be mapped to smaller rect portion.  so we need to shift the circle mapping origin the oppsite direction
    
    // hosting rect center position
    mapParams.x0 = (mapParams.left + mapParams.right) * 0.5
    mapParams.y0 = (mapParams.top + mapParams.bottom) * 0.5
    
    // mapping from circle to hosting rect with option of shifting the virtual circel origin
    
    // virtual circle origin offset
    let circel_x0 = mapParams.orginShift.x
    let circel_y0 = mapParams.orginShift.y
    
    let rect_x0 = mapParams.x0
    let rect_y0 = mapParams.y0
    
    // this means four way mapping from circle coordinate to rect coordinate:
    // (2.1) (shift._x, treeSize) => ((left + right) / 2, right)      <= less areas are projected into the right half
    // (2.2) (-treeSize, shift._x) => (left, (left + right) / 2)      <= more areas are projected into left half
    // (2.3) (shift._y, treeSize) => ((top + bottom) / 2, top)        <= less areas are projected into the top half
    // (2.4) (-treeSize, shift._y) => (bottom, (left + right) / 2)    <= more areas are projected into the bottom half
    
    mapParams.kr = (mapParams.right - rect_x0) / (treeSize - circel_x0)
    mapParams.kl = (mapParams.left - rect_x0) / (-treeSize - circel_x0)
    mapParams.kt = (mapParams.top - rect_y0) / (treeSize - circel_y0)
    mapParams.kb = (mapParams.bottom - rect_y0) / (-treeSize - circel_y0)
    
    // (3) transform node layout
    _linear_tranform(node, mapParams: &mapParams)
}


// used by radialLayout_transform_by_demension
func linear_tranform_by_demension(_ node: ANLayoutNode!, mapParams: inout Circle2RectMapping){
    if node == nil { return }
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    
    if mapParams.bUseTran {
        x = node.rPositionTran * cos(degreesToRadians(node.aPositionTran))
        y = node.rPositionTran * sin(degreesToRadians(node.aPositionTran))
        
    } else {
        x = node.rPosition * cos(degreesToRadians(node.aPosition))
        y = node.rPosition * sin(degreesToRadians(node.aPosition))
    }
    
    node.xPosition = mapParams.kx * (x - mapParams.xPositionMin) + mapParams.left
    node.yPosition = mapParams.ky * (y - mapParams.yPositionMax) + mapParams.top
    
    for child in node.children {
        linear_tranform_by_demension(child, mapParams: &mapParams)
    }
}


// used by radialLayout_transform_by_radius.  node position (xPosition, yPosition) is set after this call
func _linear_tranform(_ node: ANLayoutNode!, mapParams: inout Circle2RectMapping) {
    if node == nil { return }

    var x: CGFloat = 0
    var y: CGFloat = 0
    
    if mapParams.bUseTran {
        x = node.rPositionTran * cos(degreesToRadians(node.aPositionTran))
        y = node.rPositionTran * sin(degreesToRadians(node.aPositionTran))
        
    } else {
        x = node.rPosition * cos(degreesToRadians(node.aPosition))
        y = node.rPosition * sin(degreesToRadians(node.aPosition))
    }
    
    let xShift = x - mapParams.orginShift.x + mapParams.x0
    let yShift = y - mapParams.orginShift.y + mapParams.y0
    
    node.xPosition = (x > mapParams.orginShift.x) ? mapParams.kr * xShift : mapParams.kl * xShift
    node.yPosition = (y > mapParams.orginShift.y) ? mapParams.kt * yShift : mapParams.kb * yShift
  
    for child in node.children {
        _linear_tranform(child, mapParams: &mapParams)
    }
}

// point coordinate conversion between hosting rect and virtual circle
//int circle2rect(float r, float a, float* x, float* y, Circle2RectMapping* mapParams);
//int rect2circle(float x, float y, float* r, float* a, Circle2RectMapping* mapParams);

// project node circle coordiante (rPosition, aPosition) to xy coordinate (xPosition, yPosition)
func updateNodeXYPositions(_ node: ANLayoutNode!) {
    if node == nil { return }
    
    node.xPosition = node.rPosition * cos(degreesToRadians(node.aPosition))
    node.yPosition = node.rPosition * sin(degreesToRadians(node.aPosition))
    
    for child in node.children {
        updateNodeXYPositions(child)
    }
}

// project node circle coordiante (rPosition_tran, aPosition_tran) to xy coordinate (xPosition, yPosition)
func updateNodeXYTranPositions(_ node: ANLayoutNode!) {
    if node == nil { return }
    
    node.xPosition = node.rPositionTran * cos(degreesToRadians(node.aPositionTran))
    node.yPosition = node.rPositionTran * sin(degreesToRadians(node.aPositionTran))
    
    for child in node.children {
        updateNodeXYTranPositions(child)
    }
}

// get tree size by (xPosition, yPosition)
func getTreeXYPositionRanges(_ node: ANLayoutNode!, mapParams: inout Circle2RectMapping!) {
    if node == nil || mapParams == nil {
        return
    }
    
    let x = node.xPosition
    let y = node.yPosition
    
    mapParams.xPositionMin = min(mapParams.xPositionMin, x - 0.5 * node.width)
    mapParams.xPositionMax = max(mapParams.xPositionMax, x + 0.5 * node.width)
    mapParams.yPositionMin = min(mapParams.yPositionMin, y - 0.5 * node.height)
    mapParams.yPositionMax = max(mapParams.yPositionMax, y + 0.5 * node.height)
    
    for child in node.children {
        getTreeXYPositionRanges(child, mapParams: &mapParams)
    }
}

// get current xPosition, yPostion extent for mapping purpose
func getTreeDimension(_ node: ANLayoutNode!, mapParams: inout Circle2RectMapping) {
    if node == nil  { return }
    
    let x = node.xPosition
    let y = node.yPosition
    
    mapParams.xPositionMin = min(mapParams.xPositionMin, x - 0.5 * node.sizeTran)
    mapParams.xPositionMax = max(mapParams.xPositionMax, x + 0.5 * node.sizeTran)
    mapParams.yPositionMin = min(mapParams.yPositionMin, y - 0.5 * node.sizeTran)
    mapParams.yPositionMax = max(mapParams.yPositionMax, y + 0.5 * node.sizeTran)
    
    for child in node.children {
        getTreeDimension(child, mapParams: &mapParams)
    }
}

///////////////////////////////////////////////////////////////////////////////
// radial layout functions



// layout for the root only.
// !!! the range is assumed as 0 - 360 degree
// !!! since the stength of each branch is already know the caller can re-order branch so the largest one is placed at the first in order to use the left or right side
// algorithm:
// (1) assumes the strength of all child branches have been computed
// (2) the origin of the root is given and the radius is normalized at unit value of 1.0
// tree root only
// r0 - [in] radius of hosting circle
// shifts - [in, out] proposed shift in center

// version one uses the angle ranges decided by the node strength relative to the root circle origin
// function 1
func radialLayout_root_1(_ node: ANLayoutNode!, r0: CGFloat, r1: inout CGFloat, aRatio: CGFloat, shifts: inout XYPos) -> Int {
    
    return 0
}

// versions two used range (0 - 180 degree) around node parent circle
// function 2
func radialLayout_root_2(_ node: ANLayoutNode!, r0: CGFloat, r1: inout CGFloat, aRatio: CGFloat, shifts: inout XYPos) -> Int {
    r1 = r0
    shifts.x = 0
    shifts.y = 0

    if node == nil || node.children.count <= 1 || node.root != nil || node.layoutClass != .radial {
        return 0
    }
    
    // (1) set 0 - 360 degree
    var aR = node.aRange
    
    // 45 degree pointing to the maximum space exptent direction
    let mainAngel: CGFloat = 45.0
    
    aR.beginAngle = mainAngel
    aR.endAngle = aR.beginAngle + 360
  
    node.aRange = aR
    
    // (2) distribute by LAYOUTSTYLE_Radial_By_Strength
    // weighted by node strength
    var totalWeights: CGFloat = 0
    var maxStrength: CGFloat = 0
    var maxStrengthIndex: Int = 0
    
    for (i, child) in node.children.enumerated() {
        totalWeights += child.angularStrength()
        
        if child.angularStrength() > maxStrength {
            maxStrength = child.angularStrength()
            maxStrengthIndex = i
        }
    }

    var delta = node.aRange.endAngle - node.aRange.beginAngle
    delta -= node.aRange.angleGap * CGFloat(node.children.count)
    delta /= totalWeights
    // (3) make sure the array starts with the largest branch
    if maxStrengthIndex != 0 {
        swap(&node.children[0], &node.children[maxStrengthIndex])
    }
    
    // (4) mixture of uniform angular range
    var aveAngle = (node.aRange.endAngle - node.aRange.beginAngle) / CGFloat(node.children.count)
    
    if aveAngle > node.aRange.angleGap {
        aveAngle -= node.aRange.angleGap
    }
    
    // first child
    let firstChild = node.children.first!
    let angleWidth = aRatio * aveAngle + (1.0 - aRatio) * firstChild.angularStrength() * delta
    var begin = mainAngel - angleWidth * 0.5
    
    var aRange = AngularRange()
    for child in node.children {
        aRange = child.aRange
        
        aRange.beginAngle = begin
        aRange.endAngle = aRange.beginAngle + aRatio * aveAngle + (1.0 - aRatio) * child.angularStrength() * delta
        aRange.angle = (aRange.beginAngle + aRange.endAngle) * 0.5
        aRange.angleLocal = aRange.angle
        aRange.beginAngleLocal = aRange.beginAngle
        aRange.endAngleLocal = aRange.endAngle
        
        child.aRange = aRange
        
        begin = aRange.endAngle + node.aRange.angleGap
    }

    // (5) supress the maximum angle within 180 degress by shifting the mapping center
    aRange = firstChild.aRange
    let maxWidth: CGFloat = 180
    var width: CGFloat = 0
    let deltaAngle = maxWidth - (aRange.endAngle - aRange.beginAngle + node.aRange.angleGap)
    var zoom: CGFloat = 1.0
    firstChild.zoom = zoom
    
    if deltaAngle < 0 {
        // the first one
        
        // compute shift in origin position compare to (0, 0)
        // distance shift oppsite to the main angle
        let dr = (sqrt((aRange.endAngle - aRange.beginAngle + node.aRange.angleGap) / maxWidth) - 1.0) * r0
        let mainAngel = firstChild.aRange.angle
        
        r1 = r0 - dr
        shifts.x = -dr * cos(degreesToRadians(mainAngel))
        shifts.y = -dr * sin(degreesToRadians(mainAngel))
        
        zoom = (r0 - dr) / r0;
        
        // new angle
        aRange.beginAngle = node.aRange.beginAngle - (maxWidth - node.aRange.angleGap) * 0.5
        aRange.endAngle = aRange.beginAngle + maxWidth - node.aRange.angleGap
        aRange.angle = (aRange.beginAngle + aRange.endAngle) * 0.5
        aRange.angleLocal = aRange.angle
        aRange.beginAngleLocal = aRange.beginAngle
        aRange.endAngleLocal = aRange.endAngle
        
        // assign the new range
        firstChild.aRange = aRange
        begin = aRange.endAngle + node.aRange.angleGap
        
        // distribut deltaAngle over the remaining child node weigthed by their strength
        delta = -deltaAngle / (totalWeights - CGFloat(maxStrengthIndex))
        
        for child in node.children {
            aRange = child.aRange;
            width = aRange.endAngle - aRange.beginAngle
            
            aRange.beginAngle = begin
            aRange.endAngle = aRange.beginAngle + width + delta * child.strength
            aRange.angle = (aRange.beginAngle + aRange.endAngle) * 0.5
            aRange.angleLocal = aRange.angle
            aRange.beginAngleLocal = aRange.beginAngle
            aRange.endAngleLocal = aRange.endAngle
            
            child.aRange = aRange
            
            begin = aRange.endAngle + node.aRange.angleGap
            child.zoom = zoom
        }
    }
    
    // adjust rPosition for each child node
    // for root only
    node.rPosition = node.distance
    node.aPosition = 0
    
    node.rPositionTran = node.rPosition;
    node.aPositionTran = node.aPosition;
    
    // level one only
    for child in node.children {
        child.rPosition = child.distance
        child.aPosition = child.aRange.angle
        
        child.rPositionTran = child.rPosition
        child.aPositionTran = child.aPosition
    }

    return 0
}

// version one uses the angle ranges decided by the node strength relative to the root circle origin
// the default value layoutStyle for child node is LAYOUTSTYLE_Radial_By_Strength
func radialLayout_node_1(_ node: ANLayoutNode!) -> Int {
    if node == nil || node.children.count == 0 || node.layoutClass != .radial {
        return 0
    }
    
    switch node.layoutStyle {
    case .radialEven: setupNode1RadialEvenDistribution(node)
    case .radialByLeafs: setupNode1(node, style: .radialByLeafs)
    case .radialByStrength: setupNode1(node, style: .radialByStrength)
    default: break
    }
    
    // each child nodes
    for child in node.children {
        let _ = radialLayout_node_2(child)
    }
    
    return 0
}

// even angle distribution
fileprivate func setupNode1RadialEvenDistribution(_ node: ANLayoutNode) {
    var width = node.aRange.endAngle - node.aRange.beginAngle
    width /= CGFloat(node.children.count)
    var begin = node.aRange.beginAngle + node.aRange.angleGap * 0.5
    
    for child in node.children {
        var aRange = child.aRange
        
        aRange.beginAngle = begin
        aRange.endAngle = aRange.beginAngle + width
        aRange.angle = (aRange.beginAngle + aRange.endAngle) * 0.5
        aRange.beginAngleLocal = aRange.beginAngle
        aRange.endAngleLocal = aRange.endAngle
        aRange.angleLocal = aRange.angle
        
        child.aRange = aRange
        child.aPosition = aRange.angle
        
        begin = aRange.endAngle + node.aRange.angleGap
        
        child.zoom = node.zoom
    }
}

// weighted by total leafs in each node
// weighted by node strength
fileprivate func setupNode1(_ node: ANLayoutNode, style: LayoutStyle) {
    var totalWeights: CGFloat = 0
    for child in node.children {
        switch style {
        case .radialByLeafs: totalWeights += CGFloat(child.visibleLeafs)
        case .radialByStrength: totalWeights += child.strength
        default: break
        }
    }
    
    var delta = node.aRange.endAngle - node.aRange.beginAngle
    delta -= node.aRange.angleGap * CGFloat(node.children.count)
    delta /= totalWeights
    
    var begin = node.aRange.beginAngle + node.aRange.angleGap * 0.5
    
    for child in node.children {
        var aRange = child.aRange
        aRange.beginAngle = begin
        
        switch style {
        case .radialByLeafs:
            aRange.endAngle = aRange.beginAngle + CGFloat(child.visibleLeafs) * delta
        case .radialByStrength:
            aRange.endAngle = aRange.beginAngle + child.strength * delta
        default: break
        }
        
        aRange.angle = (aRange.beginAngle + aRange.endAngle) * 0.5
        aRange.beginAngleLocal = aRange.beginAngle
        aRange.endAngleLocal = aRange.endAngle
        aRange.angleLocal = aRange.angle
        
        child.aRange = aRange
        child.aPosition = aRange.angle
        
        begin = aRange.endAngle + node.aRange.angleGap
        
        child.zoom = node.zoom
    }
}


// versions two used range (0 - 180 degree) around node parent circle
// local parent center based. This version will layout the child nodes along the half circle centered at the node position in the direction of current node angle
func radialLayout_node_2(_ node: ANLayoutNode!) -> Int {
    if node == nil || node.children.count == 0 || node.layoutClass != .radial {
        return 0
    }
    
    // angular range for the child nodes is 180.
    // total angular width: width, angular width rate (per weight): delta, distribution offset: begin
    // compute angular range rate
    switch node.layoutStyle {
    case .radialEven: setupNode2RadialEvenDistribution(node)
    case .radialByLeafs: setupNode2(node, style: .radialByLeafs)
    case .radialByStrength: setupNode2(node, style: .radialByStrength)
    default: break
    }
    
    // adjust rPosition for each child node
    let x0 = node.rPositionTran * cos(degreesToRadians(node.aPosition))
    let y0 = node.rPositionTran * sin(degreesToRadians(node.aPosition))
    
    for child in node.children {
        let dx = child.radius * cos(degreesToRadians(child.aRange.angle))
        let dy = child.radius * sin(degreesToRadians(child.aRange.angle))
        
        let x = x0 + dx
        let y = y0 + dy
        
        child.rPosition = sqrt(x * x + y * y)
        child.aPosition = radiansToDegrees(atan2(y, x))
        
        child.rPositionTran = child.rPosition
        child.aPositionTran = child.aPosition
    }
    
    // each child nodes as start of sub tree
    for child in node.children {
        let _ = radialLayout_node_2(child)
    }
    
    return 0
}

// even angle distribution
fileprivate func setupNode2RadialEvenDistribution(_ node: ANLayoutNode) {
    let width = 180.0 - node.aRange.angleGap * CGFloat(node.children.count)
    let delta = width / CGFloat(node.children.count)
    var begin = node.aRange.angle - 90.0 + node.aRange.angleGap * 0.5
    
    for child in node.children {
        var aRange = child.aRange

        aRange.beginAngle = begin
        aRange.endAngle = aRange.beginAngle + delta
        aRange.angle = (aRange.beginAngle + aRange.endAngle) * 0.5
        aRange.beginAngleLocal = aRange.beginAngle
        aRange.endAngleLocal = aRange.endAngle
        aRange.angleLocal = aRange.angle
        
        child.aRange = aRange
        begin = aRange.endAngle + node.aRange.angleGap
        child.zoom = node.zoom
    }
}

// weighted by total leafs in each node
// weighted by node strength
fileprivate func setupNode2(_ node: ANLayoutNode!, style: LayoutStyle) {
    let width = 180.0 - node.aRange.angleGap * CGFloat(node.children.count)
    var begin = node.aRange.angle - 90.0 + node.aRange.angleGap * 0.5
    
    var totalWeights: CGFloat = 0
    for child in node.children {
        switch style {
        case .radialByLeafs: totalWeights += CGFloat(child.visibleLeafs)
        case .radialByStrength: totalWeights += child.strength
        default: break
        }
    }
    
    let delta = width / totalWeights

    for child in node.children {
        var aRange = child.aRange
        
        aRange.beginAngle = begin
        
        switch style {
        case .radialByLeafs:
            aRange.endAngle = aRange.beginAngle + CGFloat(child.visibleLeafs) * delta
        case .radialByStrength:
            aRange.endAngle = aRange.beginAngle + child.strength * delta
        default: break
        }
        
        aRange.angle = (aRange.beginAngle + aRange.endAngle) * 0.5
        aRange.beginAngleLocal = aRange.beginAngle
        aRange.endAngleLocal = aRange.endAngle
        aRange.angleLocal = aRange.angle
        
        child.aRange = aRange
        begin = aRange.endAngle + node.aRange.angleGap
        child.zoom = node.zoom
    }
}

///////////////////////////////////////////////////////////////////////////////
// help functions:

// reset {node.aPosition_tran, node.rPosition_tran} to {node.aPosition, node.rPosition}
func syncRuntimeLayout(_ node: ANLayoutNode!) {
    if node == nil { return }
    node.rPositionTran = node.rPosition
    node.aPositionTran = node.aPosition
    node.sizeTran = node.size
    
    for child in node.children {
        syncRuntimeLayout(child)
    }
}

// hit test for given tree
//int hit_test(ANLayoutNode* node, ANLayoutNode** nodeHit, float x, float y, float* range);

// return tree segment for the given node
//int mainbranch(ANLayoutNode* node, ANLayoutNode** nodeHit);

///////////////////////////////////////////////////////////////////////////////////////
// functions for layout deformation, scaling and transformation of given tree (root or sub)
///////////////////////////////////////////////////////////////////////////////////////

// scaling
struct ScaleRatio {
    var sRatio: CGFloat       // ratio used for calculating node size. 1.0 as default value
    var rRatio: CGFloat       // radius (gap) ratio between the node levels
}

// fill with default scaling ratios version one
// setScalingRatio_1(CircleScaling* ratios)
struct CircleScaling
{
    var ratioRoot = ScaleRatio(sRatio: 1, rRatio: 1)        // root node
    var ratioLevel1 = ScaleRatio(sRatio: 1, rRatio: 1)      // level one
    var ratioLevel2 = ScaleRatio(sRatio: 0.9, rRatio: 1.5)  // level two
    var ratio =  ScaleRatio(sRatio: 0.6, rRatio: 0.5)       // the rest node levels
}

// apply scale space transformation
func radialLayoutTransform_scaling(_ node: ANLayoutNode!, ratios: inout CircleScaling) {
    if node == nil { return }
    
    // set field radius_tran
    switch node.level {
    case 0:
        node.radiusTran = node.radius * ratios.ratioRoot.rRatio
        node.size = node.size * ratios.ratioRoot.sRatio
    case 1:
        node.radiusTran = node.radius * ratios.ratioLevel1.rRatio
        node.size = node.size * ratios.ratioLevel1.sRatio
    case 2:
        node.radiusTran = node.radius * ratios.ratioLevel2.rRatio
        node.size = node.size * ratios.ratioLevel2.sRatio
    default:
        node.radiusTran = node.root.radiusTran * ratios.ratio.rRatio
        node.size = node.root.size * ratios.ratio.sRatio
    }
   
    node.sizeTran = node.size
    
    // we have the radius transformed for this node.  compute new rPosition
    if node.root != nil {
        // adjust rPosition for each child node
        
        let x0 = node.root.rPositionTran * cos(degreesToRadians(node.root.aPosition))
        let y0 = node.root.rPositionTran * sin(degreesToRadians(node.root.aPosition))
        
        let dx = node.radiusTran * cos(degreesToRadians(node.aRange.angle))
        let dy = node.radiusTran * sin(degreesToRadians(node.aRange.angle))
       
        let x = x0 + dx
        let y = y0 + dy

        node.rPosition = sqrt(x * x + y * y)
        node.aPosition = radiansToDegrees(atan2(y, x))
        
        node.rPositionTran = node.rPosition
        node.aPositionTran = node.aPosition
    }
    
    // done.  loop through all child nodes
    for child in node.children {
        radialLayoutTransform_scaling(child, ratios: &ratios)
    }
}

// scaling of

///////////////////////////////////////////////////////////////////////////////////////
// functions for zooming / shifting via transformation between circles
///////////////////////////////////////////////////////////////////////////////////////

// define structure for transformation parameters
struct CircleZoomShift {
    // original circle
    // radius of orginal circle
    var R0: CGFloat
    
    // new circle
    // radius of new circle
    var R: CGFloat
    // shift along radius of original circle.  positive to the right and negative to the left
    var delta: CGFloat
    
}

////////////////////////////////////////////////////////////////
// new version of zooming and shifting via space bending using focusing point
////////////////////////////////////////////////////////////////

struct CircleZoomShiftParams {
    // original circle
    // radius of orginal circle
    var R0: CGFloat
    
    // focus point
    var r0: CGFloat
    var a0: CGFloat
}

// zoom - shift by setting focusing point only
//int radialLayoutTransform_zoom_shift_circle_by_focus(ANLayoutNode* node, CircleZoomShiftParams* tran);

// zoom node tree segment.  !!! tree_seg has to be child of root tree node
//int radialLayoutTransform_zoom_tree_seg(ANLayoutNode* node, ANLayoutNode* tree_seg, float gap, float rootangle);

///////////////////////////////////////////////////////////////////////////////
class ANRadialLayout {
    // properties
    
    // aRatio - weight between uniform angle or by strength for the level one sub trees
    var aRatio: CGFloat = 0.5
    
    // circle to rect mapping parameters
    var mapParams = Circle2RectMapping()
    
    // node tree size distribution over level and distance
    var distanceParams = Level2DistanceParams()
    
    // node layout scale by radius and distance
    var nodeScale = CircleScaling()
    
    // zoom shift parameters for calling radialLayout_zoom_shift_circle
    var zoomShift: CircleZoomShift!
    
    // object otminimize node overlap
    fileprivate var collisionMinimizer = ANLayoutCollisionMinimize()
    
    // methods for setting up layout object
    
    // compute ratio for node visual size for current mapping parameters
    func updateNodeVisualSizeRatio(_ node: ANLayoutNode) {
        // get node tree size after the layout
        var treeSize: CGFloat = 0
        var treeSizeTran: CGFloat = 0
        var edgeTran: CGFloat = 0
        getTreeLength(node, length: &treeSize, lengthTran: &treeSizeTran, edgeTran: &edgeTran)
        
        // compute size ratio for mapping node size in virtual circle to hosting rect area
        mapParams.sizeRatio = (mapParams.right - mapParams.left + mapParams.bottom - mapParams.top) / (4 * treeSize)
    
        // "edge" by size of node on the outside edge
        mapParams.edgeTran = edgeTran

    }
    
    init() {
        distanceParams.setDefaultLevel2DistanceParams(type: .layoutType3)
    }
    
    // access to internal data
    // ratio for node visual presentation
    func nodeVisualSizeRatio() -> CGFloat {
        return mapParams.sizeRatio
    }
    
    // methods for laying out node tree
    
    // layout node tree onto internal virtual circle
    // after this call the given node tree is layout onto internal virtual circle with node overlapping is minimized.
    // {node.aPosition, node.rPosition} = {node.aPosition_tran, node.rPosition_tran} = layout
    func treeLayout_spaceShape(_ node: ANLayoutNode!, uniform:Bool) -> Int {
        if node == nil {  return 0 }
        
        ////////////////////////////////////////
        // Phase one: inital layout onto uniform space
        ////////////////////////////////////////
        distanceParams.layoutClass = .radial

        // (1) compute tree node strength first
        ANLayoutNode.calculateTreeStrength(node, param: &distanceParams)
    
        // virtual circle radius
        mapParams.radius = distanceParams.maxDistance
        
        // (2) angular distribution of root (level one child nodes) node first
        let rc = radialLayout_root_2(node, r0: mapParams.radius, r1: &mapParams.radius1, aRatio: aRatio, shifts: &mapParams.orginShift)
        if rc != 0 { return rc }
  
        // (3) all rest of the nodes (level two and above nodes)
        for child in node.children {
            let _ = radialLayout_node_2(child)
        }
        
        ////////////////////////////////////////
        // (4) bend space shape
        ////////////////////////////////////////
        if !uniform {
            radialLayoutTransform_scaling(node, ratios: &nodeScale)
        }
 
        ////////////////////////////////////////
        // (5) reduce node overlapping
        ////////////////////////////////////////
        if mapParams.bMinimizeOveralp {
            // put the nodes onto a virtual grid first
            collisionMinimizer.attachNodeToGrid(node)
 
            // by reducing node density per cell
            collisionMinimizer.minimizeNodeCollisions_Density(node)
        }
        
        // (6) sync node.rPosition_tran, node.aPosition_tran and node.size_tran
        syncRuntimeLayout(node)
  
        return 0
    }
    
    // map node tree circle layout onto hosting rect
    func treeLayout_virtualCircle_2_hostingRect(_ node: ANLayoutNode!, hostRc: CGRect) -> Int {
        if node == nil { return 0 }

        mapParams.left = hostRc.origin.x
        mapParams.right = mapParams.left + hostRc.width
        mapParams.top = hostRc.origin.y
        mapParams.bottom = mapParams.top + hostRc.height

        updateNodeVisualSizeRatio(node)
        
        // project onto given hosting rect area
        radialLayout_transform(node, mapParams: &mapParams)
        
        return 0
    }
    
    
    // layout the node tree onto given hosting rect area.
    // after this call the node tree is ready for displaying onto the rect area
    // {node.aPosition, node.rPosition} = {node.aPosition_tran, node.rPosition_tran} = layout
    // {node.aPosition_tran, node.rPosition_tran}  => (xPosition, yPosition)
    // node - root
    // bendspace - true if space need to be bent for scaling node to different sizes
    // hostRc - hosting rect area
    func treeLayout_spaceShape(_ node: ANLayoutNode!, bendspace: Bool, hostRc: CGRect) {
        if node == nil { return }
        // first layout node tree onto the virtual circle
        // (1) node tree layout onto internal virtual circle
        let _ = treeLayout_spaceShape(node, uniform: !bendspace)

        // (2) map node tree circle layout onto hosting rect
        let _ = treeLayout_virtualCircle_2_hostingRect(node, hostRc: hostRc)
    }
    
}
