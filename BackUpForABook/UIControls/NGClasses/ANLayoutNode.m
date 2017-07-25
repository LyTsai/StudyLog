//
//  ANLayoutNode.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 1/16/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import "ANLayoutNode.h"

void setDefaultLevel2DistanceParams_Option1(Level2DistanceParams* params);
void setDefaultLevel2DistanceParams_Option2(Level2DistanceParams* params);
void setDefaultLevel2DistanceParams_Uniform(Level2DistanceParams* params);

void setDefaultParams(AngularRange* angleRange)
{
    if (angleRange == nil)
    {
        return ;
    }
    angleRange->_angle = .0;
    angleRange->_beginAngle = .0;
    angleRange->_endAngle = 180.0;
    angleRange->_angle_local = .0;
    angleRange->_beginAngle_local = .0;
    angleRange->_endAngle_local = 180.0;
    angleRange->_angleGap = 5.0;
    
    return ;
}

void setDefaultLevel2DistanceParams(Level2DistanceParams* params, LAYOUTTYPE type)
{
    if (type == LAYOUTTYPE_1)
    {
        // option 1
        setDefaultLevel2DistanceParams_Option1(params);
    }else if (type == LAYOUTTYPE_2)
    {
        // option 2
        setDefaultLevel2DistanceParams_Option2(params);
    }else if (type == LAYOUTTYPE_3)
    {
        // uniform
        setDefaultLevel2DistanceParams_Uniform(params);
    }
    
    return ;
}

// various way of setting the layout parameters

// option 1
void setDefaultLevel2DistanceParams_Option1(Level2DistanceParams* params)
{
    params->_type = SUBTREEGRID_EVEN;
    
    params->_rootRadius = distance_unit * 10;
    params->_rootNodeSize = params->_rootRadius * .8;
    
    params->_firstLevelRadius = distance_unit * 15.0;
    params->_firstLevelNodeSize = distance_unit * 8.0;
    
    params->_secondLevelRadius = distance_unit * 12.0;
    params->_secondLevelNodeSize = distance_unit * 7.0;
    
    params->_focusingNodeSize = distance_unit * 12.0;
    
    params->_gap = params->_firstLevelRadius * .5;
    params->_margin_node = 20;
    params->_margin_level = 20;
    params->_margin_depth = 10;

    // option 1
    params->_sRatio = .5; //3.0 / 4.0;
    params->_rRatio = .5;
    params->_dRatio = 3.0 / 4.0;
    params->_maxDistance = .0;
}

// option 2
void setDefaultLevel2DistanceParams_Option2(Level2DistanceParams* params)
{
    params->_type = SUBTREEGRID_EVEN;
    
    params->_rootRadius = distance_unit * 10;
    params->_rootNodeSize = params->_rootRadius * .8;
    
    params->_firstLevelRadius = distance_unit * 15.0;
    params->_firstLevelNodeSize = distance_unit * 8.0;
    
    params->_secondLevelRadius = distance_unit * 12.0;
    params->_secondLevelNodeSize = distance_unit * 7.0;
    
    params->_focusingNodeSize = distance_unit * 12.0;
    
    params->_gap = params->_firstLevelRadius * .5;
    params->_margin_node = 20;
    params->_margin_level = 20;
    params->_margin_depth = 10;
    
    // option 2
    params->_sRatio = .5;
    params->_rRatio = 3.0 / 4.0;
    params->_dRatio = .5;
    params->_maxDistance = .0;
}

// option 3 (uniform)
void setDefaultLevel2DistanceParams_Uniform(Level2DistanceParams* params)
{
    params->_type = SUBTREEGRID_EVEN;
    
    params->_rootRadius = distance_unit * 10;
    params->_rootNodeSize = params->_rootRadius * .8;
    
    params->_firstLevelRadius = distance_unit * 15.0;
    params->_firstLevelNodeSize = distance_unit * 8.0;
    
    params->_secondLevelRadius = distance_unit * 12.0;
    params->_secondLevelNodeSize = distance_unit * 7.0;
    
    params->_focusingNodeSize = distance_unit * 12.0;
    
    params->_gap = params->_firstLevelRadius * .5;
    params->_margin_node = 20;
    params->_margin_level = 20;
    params->_margin_depth = 10;
    
    params->_sRatio = 1.0;
    params->_rRatio = 1.0;
    params->_dRatio = 1.0;
    params->_maxDistance = .0;
}

@implementation ANLayoutNode
{
    @private
    
    NSMutableArray* _childern;
}

-(id)init
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    _layoutClass = LAYOUTCLASS_RADIAL;
    _layoutSubClass = LAYOUTSUBCLASS_NULL;
    _layoutStyle = LAYOUTSTYLE_Radial_By_Strength;
    
    _index = -1;
    _segment = -1;
    _weight = 1.0;
    _size = 3.0;
    _h2wratio = 1.0;
    _size_type = NODESIZE_AUTO_FIT;
    _sRatio = 1.0 / 1.5;
    _level = 0;
    
    _rRatio = .75;
    _radius = 3.0;
    
    _dRatio = .75;
    _radius = 1.0;
    
    _angleSize = .0; 
    _visibleLeafs = 0;
    _leafs = 0;
    _effectiveLeafs = .0;
    _strength = .0;
    _depth = .0;
    _eRatio = .5;
    
    _mass = .0;
    
    _root = nil;
    _childern = nil;
    
    _state = 0x0000;
    
    _zoom = 1.0;
    _rPosition = .0;
    _aPosition = 0.0;
    _xPosition = .0;
    _yPosition = .0;
    _xySize = .0;
    
    _rPosition_tran = .0;
    _aPosition_tran = .0;
    _radius_tran = _radius;
    _size_tran = _size;
    
    _grid_row = -1;
    _grid_col = -1;
    
    setDefaultParams(&_aRange);
    
    return self;
}

// set node dimension
-(void)setDimension:(float) width
             height:(float) height
{
    _size = width;
    _h2wratio = height / width;
}

// return width or height by _h2wratio
-(float)width
{
    return _size;
}

-(float)height
{
    return _size * _h2wratio;
}

// add one node
-(ANLayoutNode*)addNode:(int)index
                 weight:(float)weight
{
    if (_childern == nil)
    {
        _childern = [[NSMutableArray alloc] init];
    }
    
    // cerate a node
    ANLayoutNode* node = [[ANLayoutNode alloc] init];
    
    node.root = self;
    
    node.index = index;
    node.weight = weight;     
    node.level = _level + 1;
    node.segment = _segment;
    
    // add inot childern collection
    [_childern addObject:node];
    
    return node;
}

// remove one node
-(void)removeNode:(ANLayoutNode*)node
{
    if (node == nil)
    {
        return ;
    }
    
    [_childern removeObject:node];
    
    if (_childern.count == 0)
    {
        _childern = nil;
    }
}

// reset graph related run time parameters
-(void)reSet:(Level2DistanceParams*)param
{
    _distance = .0;
    _angleSize = .0;
    _visibleLeafs = 0;
    _leafs = 0;
    _effectiveLeafs = .0;
    _strength = .0;
    _depth = .0;
    
    _eRatio = .5;
    _sRatio = param->_sRatio;
    _rRatio = param->_rRatio;
    _dRatio = param->_dRatio;
    
    _mass = .0;
    _distance = param->_rootRadius;
    _radius = param->_rootRadius;
    _size = param->_rootNodeSize;
    _h2wratio = 1.0;
    
    _zoom = 1.0;
    _rPosition = .0;
    _aPosition = 0.0;
    _xPosition = .0;
    _yPosition = .0;
    _xySize = .0;
    
    _rPosition_tran = .0;
    _aPosition_tran = .0;
    _radius_tran = _radius;
    _size_tran = _size;
    
    _grid_row = -1;
    _grid_col = -1;
    
    setDefaultParams(&_aRange);
}

// decide the final node strength.  chose the maximum value between node angle size and "strength" computed as the sum of sub node angular width of node tree
-(float)finalStrength
{
    return MAX(_strength, _angleSize);
}

// effective strength is used for weighting the angular width for this node
// decided by strength * eRatio + (1 - eRatio) * effectiveLeafs
-(float)effectiveStrength
{
    return self.strength * self.eRatio + (1.0 - self.eRatio) * self.effectiveLeafs;
}

// return angular weight depends on layoutStyle
-(float)angularStrength
{
    if (self.layoutStyle == LAYOUTSTYLE_Radial_By_Leafs)
    {
        return _effectiveLeafs;
    }else if (self.layoutStyle == LAYOUTSTYLE_Radial_By_Strength)
    {
        return _strength;
    }else if (self.layoutStyle == LAYOUTSTYLE_Radial_By_E_Strength)
    {
        return self.strength * self.eRatio + (1.0 - self.eRatio) * self.effectiveLeafs;
    }else if (self.layoutStyle == LAYOUTSTYLE_Radial_Even)
    {
        // even distribution
        return 1.0;
    }
    
    return 1.0;
}

// reset strength of this node
+(void)reSetTree:(ANLayoutNode*)root
           param:(Level2DistanceParams*)param
{
    if (root == nil)
    {
        return ;
    }
    
    // reset the node first
    [root reSet:param];
    
    // is "root" ?
    if (root.root == nil)
    {
        root.level = 0;
    }else
    {
        root.level = root.root.level + 1;
    }
    
    // reset all child nodes
    if (root.childern != nil)
    {
        for (id obj in root.childern)
        {
            [ANLayoutNode reSetTree:obj param:param];
        }
    }
}

// calculate node distance.  the distance between each node to the hosting circle center is decided by the node level and given algorithm selection found in paramaters
// calculate node distance from center and size
// !!! reSetTree was already called before this
// (1) calculats node distance to center point of hosting circle
// (2) calculats node size
// (3) calculates node radius

// calculate node strength.  called as part of radial layout mode
+(void)_calculateTreeNodeStrength:(ANLayoutNode*)node
{
    if (node == nil || (node.state & (NODESTATE_HIDE | NODESTATE_DOT)))
    {
        return ;
    }
    
    // !!! assumes that the distance is already computed by calling calculateTreeNodeDistance

    node.mass = node.size * node.weight;

    // compute the inital value used for node strength calculation
    if (node.layoutClass == LAYOUTCLASS_RADIAL)
    {
        if (node.distance <= .0)
        {
            node.angleSize = .0;
        }else
        {
            node.angleSize = node.size * node.weight / node.distance;
        }
        node.depth = node.size * node.weight;
    }else if (node.layoutClass == LAYOUTCLASS_TREE_LR)
    {
        node.angleSize = node.height;
        node.depth = node.width;
    }else if (node.layoutClass == LAYOUTCLASS_TREE_TD)
    {
        node.angleSize = node.width;
        node.depth = node.height;
    }else if (node.layoutClass == LAYOUTCLASS_UNIFORM)
    {
        node.angleSize = node.size;
        node.depth = node.size;
    }else
    {
        node.angleSize = node.mass;
        node.depth = node.mass;
    }
   
    // node childern
    if (node.childern != nil)
    {
        float maxdepth = 0.0;
        for (ANLayoutNode* obj in node.childern)
        {
            [ANLayoutNode _calculateTreeNodeStrength:obj];
            
            node.leafs += obj.leafs;
            node.visibleLeafs += obj.visibleLeafs;
            node.effectiveLeafs += obj.effectiveLeafs;
            node.strength += [obj finalStrength];
            
            node.strength += obj.strength;
            if (obj.depth > maxdepth)
            {
                maxdepth = obj.depth;
            }
        }

        if (node.layoutSubClass == LAYOUTSUBCLASS_ORGCHART)
        {
            node.depth = node.depth > maxdepth ? node.depth : maxdepth;
            // add node itself on top of child node contributions
            node.strength += node.angleSize;
        }else
        {
            node.depth += maxdepth;
            // update node.strength to be the max(node.size, node.strength)
            node.strength = [node finalStrength];
        }
    }else
    {
        // node is a leaf
        node.strength = node.angleSize;
        node.leafs = 1;
        node.effectiveLeafs = 1.0;
        
        if (node.level > 0)
        {
            node.effectiveLeafs = 1.0 / node.level;
        }
        
        if ((node.state & NODESTATE_HIDE) == 0)
        {
            node.visibleLeafs = 1;
        }
    }
}

// calculate node strength by strength model (wiothout resetting the tree).  called as part of top-down or left-right layout mode
+(void)_calculateTreeNodeStrength:(ANLayoutNode*)node
                            param:(Level2DistanceParams*) param
{
    if (node == nil || (node.state & (NODESTATE_HIDE | NODESTATE_DOT)))
    {
        return ;
    }
    
    // setup node.angular size
    // node is a leaf.  use node.angleSize for multiple purpose depending on mode
    
    // !!! assumes that the distance is already computed by calling calculateTreeNodeDistance if model == STRENGTHMODEL_RADIAL
    node.mass = node.size * node.weight;
    
    // compute the inital value used for node strength calculation
    if (node.layoutClass == LAYOUTCLASS_RADIAL)
    {
        if (node.distance <= .0)
        {
            node.angleSize = .0;
        }else
        {
            node.angleSize = node.size * node.weight / node.distance;
        }
        node.depth = node.size * node.weight;
    }else if (node.layoutClass == LAYOUTCLASS_TREE_LR)
    {
        node.angleSize = node.height + param->_margin_node;
        node.depth = node.width;
    }else if (node.layoutClass == LAYOUTCLASS_TREE_TD)
    {
        node.angleSize = node.width + param->_margin_node;
        node.depth = node.height;
    }else if (node.layoutClass == LAYOUTCLASS_UNIFORM)
    {
        node.angleSize = node.size + param->_margin_node;
        node.depth = node.size;
    }else
    {
        node.angleSize = node.mass + param->_margin_node;
        node.depth = node.mass;
    }

    // node childern
    if (node.childern != nil)
    {
        float maxdepth = 0.0;
        for (ANLayoutNode* obj in node.childern)
        {
            [ANLayoutNode _calculateTreeNodeStrength:obj param:param];
            
            node.leafs += obj.leafs;
            node.visibleLeafs += obj.visibleLeafs;
            node.effectiveLeafs += obj.effectiveLeafs;
            
            node.strength += obj.strength;
            
            if (obj.depth > maxdepth)
            {
                maxdepth = obj.depth;
            }
        }
        
        maxdepth += param->_margin_depth;
        
        if (node.layoutSubClass == LAYOUTSUBCLASS_ORGCHART)
        {
            node.depth = node.depth > maxdepth ? node.depth : maxdepth;
            // add node itself on top of child node contributions
            node.strength += node.angleSize;
        }else
        {
            node.depth += maxdepth;
            // update node.strength to be the max(node.size, node.strength)
            node.strength = [node finalStrength];

        }
        
    }else
    {
        node.strength = node.angleSize;
        node.leafs = 1;
        node.effectiveLeafs = 1.0;
        
        if (node.level > 0)
        {
            node.effectiveLeafs = 1.0 / node.level;
        }
        
        if ((node.state & NODESTATE_HIDE) == 0)
        {
            node.visibleLeafs = 1;
        }
    }
}

// calculate node distance from center and size.  used for radial layout mode
+(void)calculateTreeNodeDistanceAndSize:(ANLayoutNode*)node
                                  param:(Level2DistanceParams*)param
{
    if (node == nil)
    {
        return ;
    }
    
    // level 0 (root) - level 2
    if (node.level == 0)
    {
        node.distance = .0;
        node.size = param->_rootNodeSize;
        node.radius = param->_rootRadius;
    }else if (node.level == 1)
    {
        node.distance = param->_rootRadius;
        node.size = param->_firstLevelNodeSize;
        node.radius = param->_firstLevelRadius;
    }else if (node.level == 2)
    {
        // level  = 2
        node.distance = param->_firstLevelRadius;
        node.size = param->_secondLevelNodeSize;
        node.radius = param->_secondLevelRadius;
    }else
    {
        // level >= 3
        node.size = node.root.size * node.sRatio;
        node.radius = node.root.radius * node.rRatio;
        
        if (param->_type == SUBTREEGRID_EVEN)
        {
            node.distance = node.root.distance + param->_gap;
        }else if (param->_type == SUBTREEGRID_BINARY)
        {
            node.distance = node.root.distance + (1.0 + 1.0 / exp2(node.level - 2)) * param->_gap;
        }else if (param->_type == SUBTREEGRID_RATIO)
        {
            node.distance = node.root.distance + (node.root.distance - node.root.root.distance) * node.dRatio;
        }
    }
    
    // by default set rPosition from distance;
    node.rPosition = node.distance;
    node.rPosition_tran = node.distance;
    
    // setup node layoutClass field
    node.layoutClass = param->_layout_class;
    node.layoutSubClass = param->_layout_sub_class;
    
    // record the extent of this tree
    if (node.distance > param->_maxDistance)
    {
        param->_maxDistance = node.distance;
    }
    
    if (node.childern == nil)
    {
        return ;
    }
    
    for (ANLayoutNode* obj in node.childern)
    {
        [ANLayoutNode calculateTreeNodeDistanceAndSize:obj param:param];
    }
    
    return ;
}

// calculate node distance from center and size.  used for left-right or top-down tree layout mode
+(void)calculateTreeNodeDistanceAndSize:(ANLayoutNode*)node
                                  model:(STRENGTHMODEL)model
                                  param:(Level2DistanceParams*)param
{
    if (node == nil || param == nil)
    {
        return ;
    }
    
    if (model == STRENGTHMODEL_RADIAL)
    {
        [self calculateTreeNodeDistanceAndSize:node param:param];
    }
    
    if (model == STRENGTHMODEL_WIDTH)
    {
        // strength by width then distance by height
        node.distance = node.root.distance + node.width;
    }else if (model == STRENGTHMODEL_HEIGHT)
    {
        // strength by heigth then distance by width
        node.distance = node.root.distance + node.height;
    }else if (model == STRENGTHMODEL_SIZE)
    {
        node.distance = node.root.distance + node.size;
    }else
    {
        node.distance = node.root.distance + node.mass;
    }
    
    // by default set rPosition from distance;
    node.rPosition = node.distance;
    node.rPosition_tran = node.distance;
    
    // record the extent of this tree
    if (node.distance > param->_maxDistance)
    {
        param->_maxDistance = node.distance;
    }
    
    if (node.childern == nil)
    {
        return ;
    }
    
    for (ANLayoutNode* obj in node.childern)
    {
        [ANLayoutNode calculateTreeNodeDistanceAndSize:obj model:model param:param];
    }
    
    return ;
}

// calculate tree strength.  called as part of radial layour mode
+(void)calculateTreeStrength:(ANLayoutNode*)root
                       param:(Level2DistanceParams*) param
{
    if (root == nil)
    {
        return ;
    }
    
    // reset first
    [ANLayoutNode reSetTree:root param:param];

    // compute distance from center for each node
    [ANLayoutNode calculateTreeNodeDistanceAndSize:root param:param];

    // compute strength
    [ANLayoutNode _calculateTreeNodeStrength:root];
   
}

// get maximum rPosition info of given tree
// length - length of non-transition state
// length_tran - length of transitional state
// edge_tran - node size of the out most node used for leaving space for node on the out most edge when mapping onto hosting rect area
int getTreeLength(ANLayoutNode* node, float* length, float* length_tran, float* edge_tran)
{
    if (node == nil)
    {
        return 0;
    }
    
    if (node.rPosition * node.zoom > *length)
    {
        *length = node.rPosition * node.zoom;
    }

    if (node.rPosition_tran * node.zoom > *length_tran)
    {
        // found a "out" most node
        *length_tran = node.rPosition_tran * node.zoom;
        
        if (node.size_tran * node.zoom > *edge_tran)
        {
            *edge_tran = node.size_tran * node.zoom;
        }
    }
    
    for (int i = 0; i < node.childern.count; i++)
    {
        getTreeLength([node.childern objectAtIndex:i], length, length_tran, edge_tran);
    }
    
    return 0;
}

// get angle range (aPosition) for the given sub-tree
int getTreeWidth(ANLayoutNode* node, float* begin_a, float* end_a, float* begin_a_tran, float* end_a_tran)
{
    if (node == nil)
    {
        return 0;
    }
    
    if (node.aPosition < *begin_a)
    {
        *begin_a = node.aPosition;
    }
    
    if (node.aPosition > *end_a)
    {
        *end_a = node.aPosition;
    }

    if (node.aPosition_tran < *begin_a_tran)
    {
        *begin_a_tran = node.aPosition_tran;
    }
    
    if (node.aPosition_tran > *end_a_tran)
    {
        *end_a_tran = node.aPosition_tran;
    }

    for (ANLayoutNode* obj in node.childern)
    {
        getTreeWidth(obj, begin_a, end_a, begin_a_tran, end_a_tran);
    }
    
    return 0;
}

// extract average tree node size
// node - tree root node
// totalSize - sum of all tree node sizes
// numberOfNodes - total number of tree nodes
int getTreeNodeAverageSize(ANLayoutNode* node, float* totalSize, float* numberOfNodes)
{
    if (node == nil | totalSize == nil || numberOfNodes == nil)
    {
        return 0;
    }
    
    *totalSize += node.size;
    *numberOfNodes = *numberOfNodes + 1;
    
    for (int i = 0; i < node.childern.count; i++)
    {
        getTreeNodeAverageSize([node.childern objectAtIndex:i], totalSize, numberOfNodes);
    }
    
    return 0;
}

// get size (radius around node position) of given sub tree
// node - sub node
// radius - radius by (rPosition, aPosition)
// radius_tran - radius by (rPosition_tran, aPosition_tran)
int _getMaxRadius(float x0, float y0, float x0_tran, float y0_tran, ANLayoutNode* node, float* radius, float* radius_tran)
{
    if (node == nil || radius == nil || radius_tran == nil)
    {
        return 0;
    }

    // distance between node and root
    float dx = node.rPosition * cosf(DEGREES_TO_RADIANS(node.aPosition)) - x0;
    float dy = node.rPosition * sinf(DEGREES_TO_RADIANS(node.aPosition)) - y0;
    float r = sqrtf(dx * dx + dy * dy);
    
    if (r > *radius)
    {
        *radius = r;
    }
    
    dx = node.rPosition_tran * cosf(DEGREES_TO_RADIANS(node.aPosition_tran)) - x0_tran;
    dy = node.rPosition_tran * sinf(DEGREES_TO_RADIANS(node.aPosition_tran)) - y0_tran;
    r = sqrtf(dx * dx + dy * dy);
    
    if (r > *radius_tran)
    {
        *radius_tran = r;
    }

    for (ANLayoutNode* obj in node.childern)
    {
        _getMaxRadius(x0, y0, x0_tran, y0_tran, obj, radius, radius_tran);
    }
    
    return 0;
}

int getSubTreeSize(ANLayoutNode* node, float* radius, float* radius_tran)
{
    if (node == nil || radius == 0 || radius_tran == nil)
    {
        return 0;
    }
    
    *radius = .0;
    *radius_tran = .0;
    
    return _getMaxRadius(node.rPosition * cosf(DEGREES_TO_RADIANS(node.aPosition)),
                         node.rPosition * sinf(DEGREES_TO_RADIANS(node.aPosition)),
                         node.rPosition_tran * cosf(DEGREES_TO_RADIANS(node.aPosition_tran)),
                         node.rPosition_tran * sinf(DEGREES_TO_RADIANS(node.aPosition_tran)),
                         node,
                         radius,
                         radius_tran);
}

// reset _tran intermediate state values to its original
// !!! _Tran object properties are used for run time simulations such as shift, zoom purpose etc
int reSetIntermediateProperties(ANLayoutNode* node)
{
    if (node == nil)
    {
        return 0;
    }
    
    node.rPosition_tran = node.rPosition;
    node.aPosition_tran = node.aPosition;
    node.size_tran = node.size;

    for (int i = 0; i < node.childern.count; i++)
    {
        reSetIntermediateProperties([node.childern objectAtIndex:i]);
    }
    
    return 0;
}

@end
