//
//  ANLayoutNode.swift
//  NGClasses
//
//  Created by iMac on 16/12/13.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

// Radians to Degrees
func radiansToDegrees(_ radians: CGFloat) -> CGFloat {
    return radians * CGFloat(180.0 / M_PI)
}

// Degrees to radians
func degreesToRadians(_ angle: CGFloat) -> CGFloat {
    return angle * CGFloat(M_PI / 180.0)
}

// MARK: ------ define node class for layout unit
// sub tree layout (of nodes) class
enum LayoutClass: Int {
    case null         = 0       // not defined
    case random                 // random layout
    case uniform                // uniform layout
    case treeTD                 // tree layout (top down)
    case treeLR                 // tree layout (left right)
    case circleRectLR           // mindjet type
    case radial                 // radial circle
    case graph                  // classic graph layout
    case forceDirect            // force direct graph layout
    case chordChart             // chord chart
    case definedPath  = 10      // based on given path for sub nodes (such as butterflay)
}

// sub tree layout (of nodes) secodary class (options for each LAYOUTCLASS)
enum LayoutSubclass: Int {
    case null         = 1       // no specific style
    case orgchart               // orgchart tree layout where each child node is layed out one line below the node with given offset
    case tree                   // classic tree layout where each child is branching out after the end of node (the same line)
}

// sub tree layout style (for given class) for allocating space at this node level.  layout class has to be selected first
enum LayoutStyle: Int {
    case null         = 0       // not defined
    case radialEven             // even distribution of radial layout.  used in Pavlo method
    case radialByLeafs          // weight by number of leafs (visible)
    case radialByStrength       // weight by each node strength distribution of radial layout.  used in Yee method
    case radialByEStrength      // weighted by effective strength
    case radialEnd
}

// how to compute node size
enum NodeSize: Int {
    case autoFit      = 1       // auto fit into the ring "gap" for the given level.  distance and gap are already decided
    case Focus                  // focusing node is computed differently
    case Fixed                  // use fixed value in size_runtime
    case RatioLevel             // shrink by factor decided by node level
    case RatioRoot              // shrink by factor of root size
}

// tree strength model
enum StrengthModel: Int {
    case radial       = 1       // by angle size
    case width                  // by width
    case height                 // by height
    case size                   // by total size
}

// angular range for the given node
// result of "setDefaultParams(AngularRange* angleRange)"
struct AngularRange {
    // relative to root tree origin (0, 0)
    // angle of sub tree node (branch root)
    var angle: CGFloat           = 0

    // angle range for this sub tree.  use the root center as original
    var beginAngle: CGFloat      = 0
    var endAngle: CGFloat        = 180
   
    // relative to the parent node position
    var angleLocal: CGFloat      = 0

    // local angle range using parent node as center
    var beginAngleLocal: CGFloat = 0
    var endAngleLocal: CGFloat   = 180
    
    // gap between branch segments
    var angleGap: CGFloat        = 5.0
}

// define structure for calculating node distance for given node level
// type of converting
enum SubTreeGrid : Int {
    case even         = 1        // uniform
    case binary                  // half of parent width
    case ratio                   // ratio of parent width
}

// distance is in arb unit.  will be rescaled by the circle radius
let distanceUnit: CGFloat = 1

struct Level2DistanceParams {
    var type: SubTreeGrid = .even        // method for deciding the gap between rings
    
    var layoutClass: LayoutClass = .radial // graph layout class
    var layoutSubclass: LayoutSubclass = .tree
    
    var gap: CGFloat = distanceUnit * 15 * 0.5         // ring gap distance for SUBTREEGRID_EVEN.
    
    var marginNode: CGFloat = 20      // gap between nodes at the same level.  as if along x aix
    var marginLevel: CGFloat = 20     // gap between node levels.  as if along y aix
    var marginDepth: CGFloat = 10     // gap between node and its child node group
    
    var sRatio: CGFloat = 0          // ratio used for calculating node size.  3 / 4 as default
    var rRatio: CGFloat = 0          // r ratio used for SUBTREEGRID_BINARY
    var dRatio: CGFloat = 0          // ratio for calculating distance
    
    // space at the root
    var rootRadius: CGFloat = distanceUnit * 10     // from center to the first level
    // root node size
    var rootNodeSize: CGFloat = distanceUnit * 8
    
    // space for the first level
    var firstLevelRadius: CGFloat = distanceUnit * 15 // radius of cicle along whose the second levle nodes are drawn
    // first level node size (visual appearence)
    var firstLevelNodeSize: CGFloat = distanceUnit * 8
    
    // space for the second level
    var secondLevelRadius: CGFloat = distanceUnit * 12 // radius of cicle along whose the third levle nodes are drawn
    // second level node size (visual appearence)
    var secondLevelNodeSize: CGFloat = distanceUnit * 7
    
    // focusing node size
    var focusingNodeSize: CGFloat =  distanceUnit * 12
    
    var maxDistance: CGFloat = 0      // maximum node distance in the tree.  this is run time data
    
    // call to setup (radius, size) by level parameters
    // void setDefaultLevel2DistanceParams(Level2DistanceParams* params, LAYOUTTYPE type);
    mutating func setDefaultLevel2DistanceParams(type: LayoutType) {
        switch type {
        case .layoutType1:
            sRatio = 0.5 //3.0 / 4.0
            rRatio = 0.5
            dRatio = 3.0 / 4.0
        case .layoutType2:
            sRatio = 0.5
            rRatio = 3.0 / 4.0
            dRatio = 0.5
        case .layoutType3:
            sRatio = 1
            rRatio = 1
            dRatio = 1
        }
    }
}

// there are serveral ways to setup the layout:
enum LayoutType {
    case layoutType1                // option 1
    case layoutType2                // option 2
    case layoutType3                // option 3 for uniform
}

// define node states
enum NodeState: Int {
    case dot = 0x0001       // point node
    case hide = 0x0002      // node that is hiding
}

// define structure for node layout position
// position from origin (0, 0)
struct RAPos {
    var r: CGFloat
    var a: CGFloat
}

struct XYPos {
    var x: CGFloat
    var y: CGFloat
}

// MARK: ------------------------ class ANLayoutNode ---------------------------
// tree or sub tree starts with root node with child nodes.
// each tree can be layout differently based on the class and style for selected style

class ANLayoutNode {
    // decide whether the node will be shown
    var isHidden = false
    // ------------------------------
    // node tree layout class for child nodes under this node
    var layoutClass = LayoutClass.radial
    
    // node tree layout sub-class depends on layoutCalss
    var layoutSubclass = LayoutSubclass.null
    
    // sub tree layout style
    var layoutStyle = LayoutStyle.radialByStrength
    
    // node index in the original node array for fast access
    var index: Int = -1
    
    // classification or catergory used for custering and palcing the node.  for example, disease, risk, risk factor and life style etc
    var segment: Int = -1
    
    // weight session
    // weight or sensitivity for this node
    var weight: CGFloat = 1.0
    
    // size session
    // node size (original size measured in radius unit)
    // !!! the size can be used in various methods such as representing node visual size, text length, metric intensity etc
    var size: CGFloat = 3
    
    // aspect ratio if node is in rectangel shape (height / width)
    var h2wRatio: CGFloat = 1
    
    // node run time size calculation
    var sizeType = NodeSize.autoFit
    
    // ratio factor used for calculating size_type if size_type is NODESIZE_RATIO_ROOT or NODESIZE_RATIO_LEVEL
    var sRatio: CGFloat = 1 / 1.5
    
    // distance from origin session
    // level or circle distance from the center
    var level: Int = 0
    
    // radius of node where child nodes are distributed witin the given angular range
    // !!! this is different than distance used for estimating the node strength
    // ratio used for computing the node radius
    var rRatio: CGFloat = 0.75
    
    // radius that defines the range child nodes can be distriburted within
    var radius: CGFloat = 3
    
    // distance derived from node level.  from origin (or center).  can be any value relative to the first level
    // !!! note that the distance is measured in the same unit as size
    // delta distance ratio by this node level.  distance = parent_distance + dRatio * parent_width
    var dRatio: CGFloat = 0.75
    
    // distance to circle center used for calculating node strength not really the actuall distance to the cicle center.
    var distance: CGFloat = 1.0
    
    // the angle size of each node is decided by the size divided by the distance to the center (root tree center)
    var angleSize: CGFloat = 0
    
    // total number of visible leafs under this node branch
    var visibleLeafs: Int = 0
    
    // total number of leafs including the hiden ones
    var leafs: Int = 0
    
    // total effective number of leafs (visible only)
    var effectiveLeafs: CGFloat = 0
    
    // total strength calculated by the total angular size of all leafs in this tree.  note that if the node angular width is larger than the tree strenth then use the node's strength
    // !!! this is mostly the measure of seduo width of sub tree below this node
    var strength: CGFloat = 0
    
    // !!! this is mostly the measure of seduo length of sub tree below this node
    var depth: CGFloat = 0
    
    // e ratio for angular distribution weighted by node strength and total number of leafs
    var eRatio: CGFloat = 0.5
    
    // mass or charge (size * weight) used for repulsive force
    var mass: Double = 0
    
    // parent (ANLayoutNode) of this node
    var root: ANLayoutNode!
    
    // childeren (ANLayoutNode) of this node
    // MARK: ----- not assigned to nil here, use the count to judge
    var children = [ANLayoutNode]()
    
    ///////////////////////////////////////////////
    // visual properties
    // TODO: -------- var state: NodeState = 0x00000
    var state = 0x00000
    
    // angular position
    var aRange = AngularRange()
    
    // node coordinate in radius position from origin in the viratual circle coordiante
    // zoom factor applied onto rPosition as result of node layout angular width 180 degree limit.  see function radialLayout_root_1, radialLayout_root_2, radialLayout_node_1, radialLayout_node_2 for details.   
    var zoom: CGFloat = 1
    // layout coordiante by angle and radius
    var rPosition: CGFloat = 0
    var aPosition: CGFloat = 0
    
    ////////////////////////////////////////////////
    // intermediate values used for transformation
    
    // intermediate (rPosition, aPosition) used for run time node position manipulation for the purpose of shifting , zoomin etc
    var rPositionTran: CGFloat = 0
    var aPositionTran: CGFloat = 0
    
    // radius used for layout transformation in radialLayoutTransform_scaling
    // !!! radius_tran is used internally only for getting the radius in radialLayoutTransform_scaling calculation.  it is NOT used for transitional state the way rPosition_tran is used.
    var radiusTran: CGFloat = 3.0 // radius
    
    // dynamic size information depends on the level and node angular range etc
    var sizeTran: CGFloat = 3 // size
    
    ////////////////////////////////////////////////
    
    // node position in hosting rect area based on mapping
    // !!! note that this is NOT the (x,y) form of (r,angle) coordinate conversion it is the projected x, y positon in the new rect coordinate
    var xPosition: CGFloat = 0
    var yPosition: CGFloat = 0
    // projected node size in the final rect area
    var xySize: CGFloat = 0
    
    // dynamic values used for layout
    // assigned cell index (for minimizing node collision)
    var gridRow: Int = -1
    var gridCol: Int = -1
}

// methods
extension ANLayoutNode {
    // set node dimension
    func setDimension(_ width: CGFloat, height: CGFloat) {
        size = width
        h2wRatio = height / width
    }
    
    // return width or height by _h2wratio
    // readonly, as getter
    var width: CGFloat {
        return size
    }
    var height: CGFloat {
        return size * h2wRatio
    }
    
    // add one node
    func addNode(_ index: Int, weight: CGFloat) -> ANLayoutNode {
        let node = ANLayoutNode()
        node.root = self
        
        node.index = index
        node.weight = weight
        node.level = level + 1
        node.segment = segment
        
        children.append(node)
        
        return node
    }
    
    // remove one node
    func removeNode(_ node: ANLayoutNode!) {
        if node == nil {
            return
        }
        
        for (i, child) in children.enumerated() {
            if child === node {
                children.remove(at: i)
            }
        }
    }
    
    // reset graph related run time parameters
    func reset(_ param: Level2DistanceParams) {
        distance = 0
        angleSize = 0
        visibleLeafs = 0
        leafs = 0
        effectiveLeafs = 0
        strength = 0
        depth = 0
        
        eRatio = 0.5
        sRatio = param.sRatio
        rRatio = param.rRatio
        dRatio = param.dRatio
        
        mass = 0
        distance = param.rootRadius
        radius = param.rootRadius
        size = param.rootNodeSize
        h2wRatio = 1.0
        
        zoom = 1.0
        rPosition = 0
        aPosition = 0.0
        xPosition = 0
        yPosition = 0
        xySize = 0
        
        rPositionTran = 0
        aPositionTran = 0
        radiusTran = radius
        sizeTran = size
        
        gridRow = -1
        gridCol = -1
        
        aRange = AngularRange()
    }
    
    // decide the final node strength
    func finalStrength() -> CGFloat {
        return max(strength, angleSize)
    }
    
    // effective strength is used for weighting the angular width for this node
    // decided by strength * eRatio + (1 - eRatio) * effectiveLeafs
    func effectiveStrength() -> CGFloat {
        return strength * eRatio + (1.0 - eRatio) * effectiveLeafs
    }
    
    // return angular weight depends on layoutStyle
    func angularStrength() -> CGFloat {
        switch layoutStyle {
        case .radialByLeafs: return effectiveLeafs
        case .radialByStrength: return strength
        case .radialByEStrength: return effectiveStrength()
        default: return 1.0
        }
    }
    
    // reset strength of this node
    class func resetTree(_ root: ANLayoutNode!, param: Level2DistanceParams) {
        if root == nil { return }
        
        // reset the node first
        root.reset(param)
        
        // is "root" ?
        if root.root == nil {
            root.level = 0
        } else {
            root.level = root.root.level + 1
        }
        
        // reset all child nodes
        for child in root.children {
            ANLayoutNode.resetTree(child, param: param)
        }
    }
    
    //////////////
    // calculate node distance.  the distance between each node to the hosting circle center is decided by the node level and given algorithm selection found in paramaters
    // calculate node distance from center and size
    // !!! reSetTree was already called before this
    // (1) calculats node distance to center point of hosting circle
    // (2) calculats node size
    // (3) calculates node radius
    
    // calculate node strength.  called as part of radial layout mode
    class func calculateTreeNodeStrength(_ node: ANLayoutNode!) {
        if node == nil || (node.state & (NodeState.hide.rawValue | NodeState.dot.rawValue)) != 0  {
            return
        }

        // !!! assumes that the distance is already computed by calling calculateTreeNodeDistance
        node.mass = Double(node.size) * Double(node.weight)
            
        // compute the inital value used for node strength calculation
        switch node.layoutClass {
        case .radial:
            if node.distance <= 0.0 {
                node.angleSize = 0.0
            } else {
                node.angleSize = node.size * node.weight / node.distance
            }
            node.depth = node.size * node.weight
        case .treeLR:
            node.angleSize = node.height
            node.depth = node.width
        case .treeTD:
            node.angleSize = node.width
            node.depth = node.height
        case .uniform:
            node.angleSize = node.size
            node.depth = node.size
        default:
            node.angleSize = CGFloat(node.mass)
            node.depth = CGFloat(node.mass)
        }
        
        // node children
        calculateChildrenForNode(node)
    }
    
    // MARK: ---------- calculate children, used more than once
    fileprivate class func calculateChildrenForNode(_ node: ANLayoutNode!) {
        if node.children.count != 0 {
            var maxDepth: CGFloat = 0
            for child in node.children {
                ANLayoutNode.calculateTreeNodeStrength(child)
                
                node.leafs += child.leafs
                node.visibleLeafs += child.visibleLeafs
                node.effectiveLeafs += child.effectiveLeafs
                node.strength += child.finalStrength()
                
                node.strength += child.strength
                
                if child.depth > maxDepth {
                    maxDepth = child.depth
                }
            }

            if node.layoutSubclass == .orgchart {
                node.depth = max(node.depth, maxDepth)
                // add node itself on top of child node contributions
                node.strength += node.angleSize
            } else {
                node.depth += maxDepth
                // update node.strength to be the max(node.size, node.strength)
                node.strength = node.finalStrength()
            }
        } else {
            // node is a leaf
            node.strength = node.angleSize
            node.leafs = 1
            node.effectiveLeafs = 1.0
            
            if node.level > 0 {
                node.effectiveLeafs = 1.0 / CGFloat(node.level)
            }
            
            if (node.state & NodeState.hide.rawValue) == 0 {
                node.visibleLeafs = 1
            }
    
        }
    }
    
    // calculate node strength by strength model (wiothout resetting the tree).  called as part of top-down or left-right layout mode
    class func calculateTreeNodeStrength(_ node: ANLayoutNode!, param: Level2DistanceParams) {
        if node == nil || (node.state & NodeState.hide.rawValue | NodeState.dot.rawValue) != 0 {
            return
        }
        
        // setup node.angular size
        // node is a leaf.  use node.angleSize for multiple purpose depending on mode
        
        // !!! assumes that the distance is already computed by calling calculateTreeNodeDistance if model == STRENGTHMODEL_RADIAL
        node.mass = Double(node.size) * Double(node.weight)
        
        // compute the inital value used for node strength calculation
        switch node.layoutClass {
        case .radial:
            if node.distance <= 0.0 {
                node.angleSize = 0
            }else {
                node.angleSize = node.size * node.weight / node.distance
            }
            node.depth = node.size * node.weight
        case .treeLR:
            node.angleSize = node.height + param.marginNode
            node.depth = node.width
        case .treeTD:
            node.angleSize = node.width + param.marginNode
            node.depth = node.height
        case .uniform:
            node.angleSize = node.size + param.marginNode
            node.depth = node.size
        default:
            node.angleSize = CGFloat(node.mass) + param.marginNode
            node.depth = CGFloat(node.mass)
        }
        
        // node childern
        calculateChildrenForNode(node!)
    }
    
    
    // calculate node distance from center and size.  used for radial layout mode
    class func calculateTreeNodeDistanceAndSize(_ node: ANLayoutNode!, param: inout Level2DistanceParams) {
        if node == nil { return }
        
        // level 0 (root) - level 2
        switch node.level {
        case 0:
            node.distance = 0
            node.size = param.rootNodeSize
            node.radius = param.rootRadius
        case 1:
            node.distance = param.rootRadius
            node.size = param.firstLevelNodeSize
            node.radius = param.firstLevelRadius
        case 2: // level = 2
            node.distance = param.firstLevelRadius
            node.size = param.secondLevelNodeSize
            node.radius = param.secondLevelRadius
        default: // level >= 3
            node.size = node.root.size * node.sRatio
            node.radius = node.root.radius * node.rRatio
            
            switch param.type {
            case .even: node.distance = node.root.distance + param.gap
            case .binary: node.distance = node.root.distance + (1.0 + 1.0 / exp2(CGFloat(node.level - 2))) * param.gap
            case .ratio: node.distance = node.root.distance + (node.root.distance - node.root.root.distance) * node.dRatio
            }
        }
        
        // by default set rPosition from distance
        node.rPosition = node.distance
        node.rPositionTran = node.distance
        
        // setup node layoutClass field
        node.layoutClass = param.layoutClass
        node.layoutSubclass = param.layoutSubclass
        
        // record the extent of this tree
        if node.distance > param.maxDistance {
            param.maxDistance = node.distance
        }
        
        for child in node.children {
            ANLayoutNode.calculateTreeNodeDistanceAndSize(child, param: &param)
        }
    }
    
    ///////////////
    // calculate node distance from center and size.  used for left-right or top-down tree layout mode
    class func calculateTreeNodeDistanceAndSize(_ node: ANLayoutNode!, model: StrengthModel, param: inout Level2DistanceParams) {
        // MARK: ------ param set as can not be nil
        if node == nil { return }
        
        switch model {
        case .radial:
            calculateTreeNodeDistanceAndSize(node, param: &param)
        case .width:
            // strength by width then distance by height
            node.distance = node.root.distance + node.width
        case .height:
            // strength by heigth then distance by width
            node.distance = node.root.distance + node.height
        case .size:
            node.distance = node.root.distance + node.size
        // MARK: ------ no other situation -------
//        default:
//            node.distance = node.root.distance + CGFloat(node.mass)
        }
        
        // by default set rPosition from distance;
        node.rPosition = node.distance
        node.rPositionTran = node.distance
        
        // record the extent of this tree
        if node.distance > param.maxDistance {
            param.maxDistance = node.distance
        }
        
        if node.children.count == 0 { return }
        
        for child in node.children {
            ANLayoutNode.calculateTreeNodeDistanceAndSize(child, model: model, param: &param)
        }
        
        return
    }
    
    // calculate tree strength.  used for radial layout mode
    class func calculateTreeStrength(_ root: ANLayoutNode!, param: inout Level2DistanceParams) {
        if root == nil { return }
        
        // reset first
        ANLayoutNode.resetTree(root, param: param)

        // compute distance from center for each node
        ANLayoutNode.calculateTreeNodeDistanceAndSize(root, param: &param)
        // compute strength
        ANLayoutNode.calculateTreeNodeStrength(root)
    
    }
}

// MARK: ------------------------ public methods, as int method(param) in OC files

// get maximum rPosition info of given tree
// length - length of non-transition state
// length_tran - length of transitional state
// edge_tran - node size of the out most node used for leaving space for node on the out most edge when mapping onto hosting rect area
func getTreeLength(_ node: ANLayoutNode!, length: inout CGFloat, lengthTran: inout CGFloat, edgeTran: inout CGFloat) {
    if node == nil { return }
    
    length = max(length, node.rPosition * node.zoom)

    if node.rPositionTran * node.zoom > lengthTran {
        // found a "out" most node
        lengthTran = node.rPositionTran * node.zoom
        edgeTran = max(edgeTran, node.sizeTran * node.zoom)
    }

    for child in node.children {
        getTreeLength(child, length: &length, lengthTran: &lengthTran, edgeTran: &edgeTran)
    }
}

// get angle range (aPosition) for the given sub-tree
func getTreeWidth(_ node: ANLayoutNode!, beginA: inout CGFloat, endA: inout CGFloat, beginATran: inout CGFloat, endATran: inout CGFloat) {
    if node == nil { return }
    
    beginA = min(node.aPosition, beginA)
    endA = max(node.aPosition, endA)
    
    beginATran = min(node.aPositionTran, beginATran)
    endATran = max(node.aPositionTran, endATran)
    
    for child in node.children {
        getTreeWidth(child, beginA: &beginA, endA: &endA, beginATran: &beginATran, endATran: &endATran)
    }
}

// extract average tree node size
// node - tree root node
// totalSize - sum of all tree node sizes
// numberOfNodes - total number of tree nodes
func getTreeNodeAverageSize(_ node: ANLayoutNode!, totalSize: inout CGFloat, numberOfNodes: inout CGFloat)  {
    if node == nil {
        return
    }
    
    totalSize = node.size + totalSize
    numberOfNodes = numberOfNodes + 1
    
    for child in node.children {
        getTreeNodeAverageSize(child, totalSize: &totalSize, numberOfNodes: &numberOfNodes)
    }
}

// get size (radius around node position) of given sub tree
// node - sub node
// radius - radius by (rPosition, aPosition)
// radius_tran - radius by (rPosition_tran, aPosition_tran)
func getMaxRadius(_ x0: CGFloat, y0: CGFloat, x0Tran: CGFloat, y0Tran: CGFloat, node: ANLayoutNode!, radius: inout CGFloat!, radiusTran: inout CGFloat!) {
    if (node == nil || radius == nil || radiusTran == nil) {
        return
    }
    // distance between node and root
    var dx = node.rPosition * cos(degreesToRadians(node.aPosition)) - x0
    var dy = node.rPosition * sin(degreesToRadians(node.aPosition)) - y0
    var r = sqrt(dx * dx + dy * dy)
    radius = max(radius, r)
    
    dx = node.rPositionTran * cos(degreesToRadians(node.aPositionTran)) - x0Tran
    dy = node.rPositionTran * sin(degreesToRadians(node.aPositionTran)) - y0Tran
    r = sqrt(dx * dx + dy * dy)
    radiusTran = max(radiusTran, r)
    
    for child in node.children {
        getMaxRadius(x0, y0: y0, x0Tran: x0Tran, y0Tran: y0Tran, node: child, radius: &radius, radiusTran: &radiusTran)
    }
}

func getSubTreeSize(_ node: ANLayoutNode!, radius: inout CGFloat!, radiusTran: inout CGFloat!) {
    if (node == nil || radius == nil || radiusTran == nil) {
        return
    }
    
    radius = 0
    radiusTran = 0
    
    getMaxRadius(node.rPosition * cos(degreesToRadians(node.aPosition)), y0: node.rPositionTran * sin(degreesToRadians(node.aPositionTran)), x0Tran: node.rPositionTran * cos(degreesToRadians(node.aPositionTran)), y0Tran: node.rPositionTran * sin(degreesToRadians(node.aPositionTran)), node: node, radius: &radius, radiusTran: &radiusTran)
}

// reset _tran intermediate state values to its original
// !!! _Tran object properties are used for run time simulations such as shift, zoom purpose etc
func resetIntermediateProperties(_ node: ANLayoutNode!) {
    if node == nil { return }
    node.rPositionTran = node.rPosition
    node.aPositionTran = node.aPosition
    node.sizeTran = node.size
    
    for child in node.children {
        resetIntermediateProperties(child)
    }
}
