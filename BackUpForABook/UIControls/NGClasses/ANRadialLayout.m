//
//  ANRadialLayout.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 1/16/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import "ANRadialLayout.h"

// radial layout public functions

// !!! the purpose of tree node layout is to compute for each node the following visual paramters: (1) position {r, angle} in circle coordinate (2) radius distance for gap between node level (3) visual size (4)

// layout the tree.  assumes the tree is already setup with size and distance (by calling calculateTreeStrength)
// node - tree root
// r0 - hosting circle radius
// shifts - intrinsic center shift
// aRatio - ratio to combine the two angular range: aRatio * uniform + (1.0 - aRatio) * weighted  aRatio = 1.0 for using uniform angular width
int radialLayout(ANLayoutNode* node, float aRatio, Circle2RecttMapping* mapParams)
{
    // !!! assumes all sub treees have been computed for their distance and strength already (by calling calculateTreeStrength) etc
    
    ////////////////////////////////////////
    // Phase one: inital layout
    ////////////////////////////////////////
    
    Level2DistanceParams distanceParams;
    setDefaultLevel2DistanceParams(&distanceParams, LAYOUTTYPE_1);
    
    // (1) compute tree node strength first
    [ANLayoutNode calculateTreeStrength:node param:&distanceParams];
    
    // virtual circle radius
    mapParams->_radius = distanceParams._maxDistance;
    
    // (2) angular distribution of root (level one child nodes) node first
    int rc = radialLayout_root_2(node, mapParams->_radius, &mapParams->_radius1, aRatio, &(mapParams->_orginShift));
    if (rc != 0)
    {
        return rc;
    }
    
    // (3) all rest of the nodes (level two and above nodes)
    for (int i = 0; i < node.childern.count; i++)
    {
        radialLayout_node_2([node.childern objectAtIndex:i]);
    }
    
    return 0;
}

// version that perform uniform layout first followed by layout space deformation (transform by specified function)
int radialLayout_spaceShape(ANLayoutNode* node, float aRatio, Circle2RecttMapping* mapParams)
{
    // !!! assumes all sub treees have been computed for their distance and strength already (by calling calculateTreeStrength) etc
    
    ////////////////////////////////////////
    // Phase one: inital layout
    ////////////////////////////////////////
    
    Level2DistanceParams distanceParams;
    setDefaultLevel2DistanceParams(&distanceParams, LAYOUTTYPE_3);
    
    // (1) compute tree node strength first
    [ANLayoutNode calculateTreeStrength:node param:&distanceParams];
    
    // virtual circle radius
    mapParams->_radius = distanceParams._maxDistance;
    
    // (2) angular distribution of root (level one child nodes) node first
    int rc = radialLayout_root_2(node, mapParams->_radius, &mapParams->_radius1, aRatio, &(mapParams->_orginShift));
    if (rc != 0)
    {
        return rc;
    }
    
    // (3) all rest of the nodes (level two and above nodes)
    for (int i = 0; i < node.childern.count; i++)
    {
        radialLayout_node_2([node.childern objectAtIndex:i]);
    }

    ////////////////////////////////////////
    // (4) bent space shape
    ////////////////////////////////////////
    CircleScaling ratios;
 
    setScalingRatio_1(&ratios);
    radialLayoutTransform_scaling(node, &ratios);
    
    return 0;
}

// set focusing node on top of inital tree layout
// node - node of sub tree
// size - new size of focusing node
// mapParams [in, out] mapping information
// focusing algorithm:
// (1) locate the node and increse the node size if new size is greater than the current one
// (2) compute the new location (rDiatance) and size of node
// (3) compute the increase in angular as result of (2)
// (4) as result of (3) parent of node will be "pushed" towards the center while child nodes are all enlardged
// (5) compute the shift and new size as result of (4) by calling radialLayout_shiftByAngularRangeChange
int radialLayout_setFocus(ANLayoutNode* node, float size, Circle2RecttMapping* mapParams)
{
    // !! make sure to update node zoom.  see radialLayout_node_1 and radialLayout_node_2
    
    return 0;
}

// transform to rect area for the given rect based mapping information

//!!! to do make a new radialLayout_transform function to:

// call getTreeDimension to get virtual circle dimentison for mapping onto hosting rect area
// the final result is to translate from (aPosition_tran, rPosition_tran) to (xPosition, yPosition)
int radialLayout_transform_by_demension(ANLayoutNode* node, Circle2RecttMapping* mapParams)
{
    if (node == nil || mapParams == nil)
    {
        return 0;
    }
    
    // (0) get original size of tree
    float treeSize = .0, treeSize_tran = .0, edge_tran = .0;
    
    getTreeLength(node, &treeSize, &treeSize_tran, &edge_tran);

    mapParams->_treeSize = treeSize;
    mapParams->_treeSize_tran = treeSize_tran;
    mapParams->_edge_tran = edge_tran;

    // (1) call updateNodeXYTranPositions to project (xPostion, yPostion) from (rPostion_tran, aPositon_tran)
    updateNodeXYTranPositions(node);
    
    // (2) get node tree (xPostion, yPostion) dimension
    mapParams->_xPosition_Min = 10000000.0;
    mapParams->_xPosition_Max = -10000000.0;
    mapParams->_yPosition_Min = 10000000.0;
    mapParams->_yPosition_Max = -10000000.0;
    
    getTreeDimension(node, mapParams);
    
    // (3) map circle of (mapParams->_xPosition_Min, mapParams->_xPosition_Max, mapParams->_yPosition_Min, mapParams->_yPosition_Max) onto (mapParams->_left, mapParams->_right, mapParams->_top, mapParams->_bottom)
    
    mapParams->_kx = (mapParams->_right - mapParams->_left) / (mapParams->_xPosition_Max - mapParams->_xPosition_Min);
    mapParams->_ky = (mapParams->_bottom - mapParams->_top) / (mapParams->_yPosition_Min - mapParams->_yPosition_Max);
    
    // (4) transform the layout
    _linear_tranform_by_demension(node, mapParams);
    
    return 0;
}

// used by radialLayout_transform_by_demension
int _linear_tranform_by_demension(ANLayoutNode* node, Circle2RecttMapping* mapParams)
{
    if (node == nil || mapParams == nil)
    {
        return 0;
    }

    float x = 0.0, y = 0.0;
    
    if (mapParams->_bUseTran)
    {
        x = node.rPosition_tran * cosf(DEGREES_TO_RADIANS(node.aPosition_tran));
        y = node.rPosition_tran * sinf(DEGREES_TO_RADIANS(node.aPosition_tran));
    }else
    {
        x = node.rPosition * cosf(DEGREES_TO_RADIANS(node.aPosition));
        y = node.rPosition * sinf(DEGREES_TO_RADIANS(node.aPosition));
    }

    node.xPosition = mapParams->_kx * (x - mapParams->_xPosition_Min) + mapParams->_left;
    node.yPosition = mapParams->_ky * (y - mapParams->_yPosition_Max) + mapParams->_top;
    
    for (ANLayoutNode* obj in node.childern)
    {
        _linear_tranform_by_demension(obj, mapParams);
    }
    
    return 0;
}

// based on the size of virtual circle
int radialLayout_transform(ANLayoutNode* node, Circle2RecttMapping* mapParams)
{
    if (mapParams == nil)
    {
        return 0;
    }

    if (mapParams->_mappingMode == MAPPINGMODE_BY_RADIUS)
    {
        return radialLayout_transform_by_radius(node, mapParams);
    }else if (mapParams->_mappingMode == MAPPINGMODE_BY_DIMENSION)
    {
     
        return radialLayout_transform_by_demension(node, mapParams);
        
    }
    return 0;
}

// map circle coordinate onto hosting rect coordiante by circle radius
int radialLayout_transform_by_radius(ANLayoutNode* node, Circle2RecttMapping* mapParams)
{
    if (node == nil || mapParams == nil)
    {
        return 0;
    }
    
    // (1) get original size of tree
    float treeSize = .0, treeSize_tran = .0, edge_tran = .0;
    
    getTreeLength(node, &treeSize, &treeSize_tran, &edge_tran);
    
    mapParams->_treeSize = treeSize;
    mapParams->_treeSize_tran = treeSize_tran;
    mapParams->_edge_tran = edge_tran;
    
    if (mapParams->_bUseTran)
    {
        // use treeSize_tran
        treeSize = treeSize_tran;
        
        // need to leave marge at the edge so node will be kept within hosting rect ?
        treeSize += edge_tran * .5;
    }
    
    // (2) mapping shift stored in mapParams indicates the cut into portion of area to be mapped to smaller rect portion.  so we need to shift the circle mapping origin the oppsite direction
    
    // hosting rect center position
    mapParams->_x0 = (mapParams->_left + mapParams->_right) * .5;
    mapParams->_y0 = (mapParams->_top + mapParams->_bottom) * .5;
    
    // mapping from circle to hosting rect with option of shifting the virtual circel origin
    
    // virtual circle origin offset
    float circel_x0 = mapParams->_orginShift._x;
    float circel_y0 = mapParams->_orginShift._y;
    
    float rect_x0 = mapParams->_x0;
    float rect_y0 = mapParams->_y0;
    
    // this means four way mapping from circle coordinate to rect coordinate:
    // (2.1) (shift._x, treeSize) => ((left + right) / 2, right)      <= less areas are projected into the right half
    // (2.2) (-treeSize, shift._x) => (left, (left + right) / 2)      <= more areas are projected into left half
    // (2.3) (shift._y, treeSize) => ((top + bottom) / 2, top)        <= less areas are projected into the top half
    // (2.4) (-treeSize, shift._y) => (bottom, (left + right) / 2)    <= more areas are projected into the bottom half
    
    mapParams->_kr = (mapParams->_right - rect_x0) / (treeSize - circel_x0);
    mapParams->_kl = (mapParams->_left - rect_x0) / (-treeSize - circel_x0);
    mapParams->_kt = (mapParams->_top - rect_y0) / (treeSize - circel_y0);
    mapParams->_kb = (mapParams->_bottom - rect_y0) / (-treeSize - circel_y0);
    
    // (3) transform node layout
    _linear_tranform(node, mapParams);
    
    return 0;
}

int _linear_tranform(ANLayoutNode* node, Circle2RecttMapping* mapParams)
{
    if (node == nil || mapParams == nil)
    {
        return 0;
    }
    
    float x = 0.0, y = 0.0;
    
    if (mapParams->_bUseTran)
    {
        x = node.rPosition_tran * cosf(DEGREES_TO_RADIANS(node.aPosition_tran));
        y = node.rPosition_tran * sinf(DEGREES_TO_RADIANS(node.aPosition_tran));
    }else
    {
        x = node.rPosition * cosf(DEGREES_TO_RADIANS(node.aPosition));
        y = node.rPosition * sinf(DEGREES_TO_RADIANS(node.aPosition));
    }
    
    if (x > mapParams->_orginShift._x)
    {
        node.xPosition = mapParams->_kr * (x - mapParams->_orginShift._x) + mapParams->_x0;
    }else
    {
        node.xPosition = mapParams->_kl * (x - mapParams->_orginShift._x) + mapParams->_x0;
    }
    
    if (y > mapParams->_orginShift._y)
    {
        node.yPosition = mapParams->_kt * (y - mapParams->_orginShift._y) + mapParams->_y0;
    }else
    {
        node.yPosition = mapParams->_kb * (y - mapParams->_orginShift._y) + mapParams->_y0;
    }
    
    for (ANLayoutNode* obj in node.childern)
    {
        _linear_tranform(obj, mapParams);
    }
    
    return 0;
}

// point coordinate conversion between hosting rect and virtual circle
int circle2rect(float r, float a, float* x, float* y, Circle2RecttMapping* mapParams)
{
    if (x == nil || y == nil || mapParams == nil)
    {
        return 0;
    }
    
    *x = r * cosf(DEGREES_TO_RADIANS(a));
    *y = r * sinf(DEGREES_TO_RADIANS(a));

    if (mapParams->_mappingMode == MAPPINGMODE_BY_RADIUS)
    {
        if (*x > mapParams->_orginShift._x)
        {
            *x = mapParams->_kr * (*x - mapParams->_orginShift._x) + mapParams->_x0;
        }else
        {
            *x = mapParams->_kl * (*x - mapParams->_orginShift._x) + mapParams->_x0;
        }
        
        if (*y > mapParams->_orginShift._y)
        {
            *y = mapParams->_kt * (*y - mapParams->_orginShift._y) + mapParams->_y0;
        }else
        {
            *y = mapParams->_kb * (*y - mapParams->_orginShift._y) + mapParams->_y0;
        }
    }else if (mapParams->_mappingMode == MAPPINGMODE_BY_DIMENSION)
    {
        *x = mapParams->_kx * (*x - mapParams->_xPosition_Min) + mapParams->_left;
        *y = mapParams->_ky * (*y - mapParams->_yPosition_Max) + mapParams->_top;
    }
    
    return 0;
}

int rect2circle(float x, float y, float* r, float* a, Circle2RecttMapping* mapParams)
{
    if (r == nil || a == nil || mapParams == nil)
    {
        return 0;
    }
    
    if (mapParams->_mappingMode == MAPPINGMODE_BY_RADIUS)
    {
        
    }else if (mapParams->_mappingMode == MAPPINGMODE_BY_DIMENSION)
    {
        
    }
    
    return 0;
}

// project node circle coordiante (rPosition, aPosition) to xy coordinate (xPosition, yPosition)
int updateNodeXYPositions(ANLayoutNode* node)
{
    if (node == nil)
    {
        return 0;
    }
    
    node.xPosition = node.rPosition * cosf(DEGREES_TO_RADIANS(node.aPosition));
    node.yPosition = node.rPosition * sinf(DEGREES_TO_RADIANS(node.aPosition));
    
    for (ANLayoutNode* obj in node.childern)
    {
        updateNodeXYPositions(obj);
    }
    
    return 0;
}

// project node circle coordiante (rPosition_tran, aPosition_tran) to xy coordinate (xPosition, yPosition)
int updateNodeXYTranPositions(ANLayoutNode* node)
{
    if (node == nil)
    {
        return 0;
    }
    
    node.xPosition = node.rPosition_tran * cosf(DEGREES_TO_RADIANS(node.aPosition_tran));
    node.yPosition = node.rPosition_tran * sinf(DEGREES_TO_RADIANS(node.aPosition_tran));
    
    for (ANLayoutNode* obj in node.childern)
    {
        updateNodeXYTranPositions(obj);
    }
    
    return 0;
}

// get tree size by (xPosition, yPosition)
int getTreeXYPositionRanges(ANLayoutNode* node, Circle2RecttMapping* mapParams)
{
    if (node == nil || mapParams == nil)
    {
        return 0;
    }
    
    float x = node.xPosition;
    float y = node.yPosition;
    
    if ((x - .5 * node.width) < mapParams->_xPosition_Min)
    {
        mapParams->_xPosition_Min = x - .5 * node.width;
    }
    
    if ((x + .5 * node.width) > mapParams->_xPosition_Max)
    {
        mapParams->_xPosition_Max = x + .5 * node.width;
    }
    
    if ((y - .5 * node.height) < mapParams->_yPosition_Min)
    {
        mapParams->_yPosition_Min = y - .5 * node.height;
    }
    
    if ((y + .5 * node.height) > mapParams->_yPosition_Max)
    {
        mapParams->_yPosition_Max = y + .5 * node.height;
    }

    for (int i = 0; i < node.childern.count; i++)
    {
        getTreeXYPositionRanges([node.childern objectAtIndex:i], mapParams);
    }
    
    return 0;
}

// get current xPosition, yPostion extent for mapping purpose
int getTreeDimension(ANLayoutNode* node, Circle2RecttMapping* mapParams)
{
    if (node == nil || mapParams == nil)
    {
        return 0;
    }
    
    float x = node.xPosition;
    float y = node.yPosition;
    
    if ((x - .5 * node.size_tran) < mapParams->_xPosition_Min)
    {
        mapParams->_xPosition_Min = x - .5 * node.size_tran;
    }
    
    if ((x + .5 * node.size_tran) > mapParams->_xPosition_Max)
    {
        mapParams->_xPosition_Max = x + .5 * node.size_tran;
    }
    
    if ((y - .5 * node.size_tran) < mapParams->_yPosition_Min)
    {
        mapParams->_yPosition_Min = y - .5 * node.size_tran;
    }
    
    if ((y + .5 * node.size_tran) > mapParams->_yPosition_Max)
    {
        mapParams->_yPosition_Max = y + .5 * node.size_tran;
    }
    
    for (int i = 0; i < node.childern.count; i++)
    {
        getTreeDimension([node.childern objectAtIndex:i], mapParams);
    }
    
    return 0;
}

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
int radialLayout_root_1(ANLayoutNode* node, float r0, float* r1, float aRatio, XYPos* shifts)
{
    *r1 = r0;
    shifts->_x = .0;
    shifts->_y = .0;
    
    if (node == nil || node.childern.count == 0 || node.root != nil || node.layoutClass != LAYOUTCLASS_RADIAL)
    {
        return 0;
    }
    
    // (1) set 0 - 360 degree
    AngularRange aR = node.aRange;
    
    // 45 degree pointing to the maximum space exptent direction in case of hosting rectangle
    float mainAngel = 45.0;
    
    aR._beginAngle = mainAngel;
    aR._endAngle = aR._beginAngle + 360.0;
    // set to node range
    node.aRange = aR;
    
    // (2) distribute by LAYOUTSTYLE_Radial_By_Strength
    // weighted by node strength
    float totalWeights = .0;
    float maxStrength = 0.0;
    int i, maxStrengthIndex = 0;
    
    for (i = 0; i < node.childern.count; i++)
    {
        ANLayoutNode* obj = [node.childern objectAtIndex:i];
        
        totalWeights += [obj angularStrength];
        
        if ([obj angularStrength] > maxStrength)
        {
            maxStrength = [obj angularStrength];
            maxStrengthIndex = i;
        }
    }
    
    float delta = (node.aRange._endAngle - node.aRange._beginAngle);
    delta -= node.aRange._angleGap * node.childern.count;
    delta /= totalWeights;
    
    // (3) make sure the array starts with the largest branch
    if (maxStrengthIndex != 0)
    {
        [node.childern exchangeObjectAtIndex:maxStrengthIndex withObjectAtIndex:0];
    }
    
    // (4) assign angle ranges for each childe nodes
    float begin = .0;
    
    // first child
    ANLayoutNode *child = [node.childern objectAtIndex:0];
    AngularRange aRange = child.aRange;
    
    float zoom = 1.0;
    child.zoom = zoom;
    
    // (4.a) make sure the first is within 180 degree range
    if ([child angularStrength] > totalWeights * .5)
    {
        // the rest of angle without the first child (maximum)
        float angle0 = (totalWeights - [child angularStrength]) * delta - node.aRange._angleGap * (node.childern.count - 1);
        
        float totalWidth = node.aRange._endAngle - node.aRange._beginAngle;
        float maxWidth = totalWidth * .5;
        
        aRange._beginAngle = node.aRange._beginAngle - (maxWidth - node.aRange._angleGap) * .5;
        aRange._endAngle = aRange._beginAngle + maxWidth;
        aRange._angle = (aRange._beginAngle + aRange._endAngle) * .5;
        aRange._angle_local = aRange._angle;
        aRange._beginAngle_local = aRange._beginAngle;
        aRange._endAngle_local = aRange._endAngle;
        
        child.aRange = aRange;
        
        begin = aRange._endAngle + node.aRange._angleGap;
        
        // make adjustment for the dela angle per strength
        delta = (node.aRange._endAngle - node.aRange._beginAngle) - maxWidth;
        delta -= node.aRange._angleGap * node.childern.count;
        delta /= (totalWeights - [child angularStrength]);
        
        // compute shift in origin position compare to (0, 0)
        float r = sqrtf(angle0 / 180) * r0;
        float dr = r0 - r;
        
        *r1 = r;
        shifts->_x = -dr * cosf(DEGREES_TO_RADIANS(mainAngel));
        shifts->_y = -dr * sinf(DEGREES_TO_RADIANS(mainAngel));
        
        zoom = *r1 / r0;
    }else
    {
        aRange._beginAngle = node.aRange._beginAngle - [child angularStrength] * delta * .5;
        aRange._endAngle = aRange._beginAngle + [child angularStrength] * delta;
        aRange._angle = (aRange._beginAngle + aRange._endAngle) * .5;
        aRange._angle_local = aRange._angle;
        aRange._beginAngle_local = aRange._beginAngle;
        aRange._endAngle_local = aRange._endAngle;
        
        child.aRange = aRange;
        
        begin = aRange._endAngle + node.aRange._angleGap;
    }
    
    // (4.b) the rest child nodes
    for (i = 1; i < node.childern.count; i++)
    {
        child = [node.childern objectAtIndex:i];
        aRange = child.aRange;
        
        aRange._beginAngle = begin;
        aRange._endAngle = aRange._beginAngle + [child angularStrength] * delta;
        aRange._angle = (aRange._beginAngle + aRange._endAngle) * .5;
        aRange._angle_local = aRange._angle;
        aRange._beginAngle_local = aRange._beginAngle;
        aRange._endAngle_local = aRange._endAngle;
        
        child.aRange = aRange;
        
        begin = aRange._endAngle + node.aRange._angleGap;
        
        child.zoom = zoom;
    }
    
    return 0;
}

// function 2
// versions two used range (0 - 180 degree) around node parent circle
int radialLayout_root_2(ANLayoutNode* node, float r0, float* r1, float aRatio, XYPos* shifts)
{
    *r1 = r0;
    shifts->_x = .0;
    shifts->_y = .0;
    
    if (node == nil || node.childern.count == 0 || node.root != nil || node.layoutClass != LAYOUTCLASS_RADIAL || node.childern.count <= 1)
    {
        return 0;
    }
    

    // (1) set 0 - 360 degree
    AngularRange aR = node.aRange;
    
    // 45 degree pointing to the maximum space exptent direction
    float mainAngel = 45.0;
    
    aR._beginAngle = mainAngel;
    aR._endAngle = aR._beginAngle + 360.0;
    
    node.aRange = aR;
    
    // (2) distribute by LAYOUTSTYLE_Radial_By_Strength
    // weighted by node strength
    float totalWeights = .0;
    float maxStrength = 0.0;
    int i, maxStrengthIndex = 0;
  
    for (i = 0; i < node.childern.count; i++)
    {
        ANLayoutNode* obj = [node.childern objectAtIndex:i];
        
        totalWeights += [obj angularStrength];
        if ([obj angularStrength] > maxStrength)
        {
            maxStrength = [obj angularStrength];
            maxStrengthIndex = i;
        }
    }

    float delta = (node.aRange._endAngle - node.aRange._beginAngle);
    delta -= node.aRange._angleGap * node.childern.count;
    delta /= totalWeights;
   
    // (3) make sure the array starts with the largest branch
    if (maxStrengthIndex != 0)
    {
        [node.childern exchangeObjectAtIndex:maxStrengthIndex withObjectAtIndex:0];
    }
    // (4) mixture of uniform angular range
    float aveAngle = (node.aRange._endAngle - node.aRange._beginAngle) / node.childern.count;
    
    // first child
    ANLayoutNode *child = [node.childern objectAtIndex:0];
    
    float angleWidth = aRatio * aveAngle + (1.0 - aRatio) * [child angularStrength] * delta;
    
    float begin = mainAngel - angleWidth * .5;
    
    AngularRange aRange;
    
    for (i = 0; i < node.childern.count; i++)
    {
        child = [node.childern objectAtIndex:i];
        aRange = child.aRange;
        
        aRange._beginAngle = begin;
        aRange._endAngle = aRange._beginAngle + aRatio * aveAngle + (1.0 - aRatio) * [child angularStrength] * delta;
        aRange._angle = (aRange._beginAngle + aRange._endAngle) * .5;
        aRange._angle_local = aRange._angle;
        aRange._beginAngle_local = aRange._beginAngle;
        aRange._endAngle_local = aRange._endAngle;
        
        child.aRange = aRange;
        
        begin = aRange._endAngle + node.aRange._angleGap;
    }

    // (5) supress the maximum angle within 180 degress by shifting the mapping center
    child = [node.childern objectAtIndex:0];
    aRange = child.aRange;
    float maxWidth = 180.0;
    float width;
    float deltaAngle = maxWidth - (aRange._endAngle - aRange._beginAngle + node.aRange._angleGap);
    
    float zoom = 1.0;
    child.zoom = zoom;
    
    if (deltaAngle < 0)
    {
        // the first one
        
        // compute shift in origin position compare to (0, 0)
        // distance shift oppsite to the main angle
        float dr = (sqrt((aRange._endAngle - aRange._beginAngle + node.aRange._angleGap) / maxWidth) - 1.0) * r0;
        float mainAngel = child.aRange._angle;
        
        *r1 = r0 - dr;
        shifts->_x = -dr * cosf(DEGREES_TO_RADIANS(mainAngel));
        shifts->_y = -dr * sinf(DEGREES_TO_RADIANS(mainAngel));
        
        zoom = (r0 - dr) / r0;

        // new angle
        aRange._beginAngle = node.aRange._beginAngle - (maxWidth - node.aRange._angleGap) * .5;
        aRange._endAngle = aRange._beginAngle + maxWidth - node.aRange._angleGap;
        aRange._angle = (aRange._beginAngle + aRange._endAngle) * .5;
        aRange._angle_local = aRange._angle;
        aRange._beginAngle_local = aRange._beginAngle;
        aRange._endAngle_local = aRange._endAngle;
        
        // assign the new range
        child.aRange = aRange;
        
        begin = aRange._endAngle + node.aRange._angleGap;
        
        // distribut deltaAngle over the remaining child node weigthed by their strength
        delta = -deltaAngle / (totalWeights - maxStrengthIndex);
        
        for (i = 1; i < node.childern.count; i++)
        {
            child = [node.childern objectAtIndex:i];
            AngularRange aRange = child.aRange;
            width = aRange._endAngle - aRange._beginAngle;
            
            aRange._beginAngle = begin;
            aRange._endAngle = aRange._beginAngle + width + delta * child.strength;
            aRange._angle = (aRange._beginAngle + aRange._endAngle) * .5;
            aRange._angle_local = aRange._angle;
            aRange._beginAngle_local = aRange._beginAngle;
            aRange._endAngle_local = aRange._endAngle;
            
            child.aRange = aRange;
            
            begin = aRange._endAngle + node.aRange._angleGap;
            child.zoom = zoom;
        }
    }
    
    // adjust rPosition for each child node
    // for root only
    node.rPosition = node.distance;
    node.aPosition = .0;
    
    node.rPosition_tran = node.rPosition;
    node.aPosition_tran = node.aPosition;
    
    // level one only
    for (int i = 0; i < node.childern.count; i++)
    {
        child = [node.childern objectAtIndex:i];
        
        child.rPosition = child.distance;
        child.aPosition = child.aRange._angle;
        
        child.rPosition_tran = child.rPosition;
        child.aPosition_tran = child.aPosition;
    }
    
    return 0;
}

// version one uses the angle ranges decided by the node strength relative to the root circle origin
// angular layout for the given sub node.
int radialLayout_node_1(ANLayoutNode* node)
{
    if (node == nil || node.childern.count == 0 || node.layoutClass != LAYOUTCLASS_RADIAL)
    {
        return 0;
    }
    
    if (node.layoutStyle == LAYOUTSTYLE_Radial_Even)
    {
        // even angle distribution
        float width = (node.aRange._endAngle - node.aRange._beginAngle);
        width -= node.aRange._angleGap * node.childern.count;
        width /= node.childern.count;
        
        float begin = node.aRange._beginAngle + node.aRange._angleGap * .5;
        
        for (int i = 0; i < node.childern.count; i++)
        {
            ANLayoutNode *child = [node.childern objectAtIndex:i];
            
            AngularRange aRange = child.aRange;
            
            aRange._beginAngle = begin;
            aRange._endAngle = aRange._beginAngle + width;
            aRange._angle = (aRange._beginAngle + aRange._endAngle) * .5;
            aRange._beginAngle_local = aRange._beginAngle;
            aRange._endAngle_local = aRange._endAngle;
            aRange._angle_local = aRange._angle;

            child.aRange = aRange;
            child.aPosition = aRange._angle;
            
            begin = aRange._endAngle + node.aRange._angleGap;
            
            child.zoom = node.zoom;
        }
    }else if (node.layoutStyle == LAYOUTSTYLE_Radial_By_Leafs)
    {
        // weighted by total leafs in each node
        float totalWeights = .0;
        
        for (ANLayoutNode* obj in node.childern)
        {
            totalWeights += obj.visibleLeafs;
        }
        
        float delta = (node.aRange._endAngle - node.aRange._beginAngle);
        delta -= node.aRange._angleGap * node.childern.count;
        delta /= totalWeights;
        
        float begin = node.aRange._beginAngle + node.aRange._angleGap * .5;
        
        for (int i = 0; i < node.childern.count; i++)
        {
            ANLayoutNode *child = [node.childern objectAtIndex:i];
            
            AngularRange aRange = child.aRange;
            
            aRange._beginAngle = begin;
            aRange._endAngle = aRange._beginAngle + child.visibleLeafs * delta;
            aRange._angle = (aRange._beginAngle + aRange._endAngle) * .5;
            aRange._beginAngle_local = aRange._beginAngle;
            aRange._endAngle_local = aRange._endAngle;
            aRange._angle_local = aRange._angle;

            child.aRange = aRange;
            child.aPosition = aRange._angle;
            
            begin = aRange._endAngle + node.aRange._angleGap;
            
            child.zoom = node.zoom;
        }
    }else if (node.layoutStyle == LAYOUTSTYLE_Radial_By_Strength)
    {
        // weighted by node strength
        float totalWeights = .0;
        
        for (ANLayoutNode* obj in node.childern)
        {
            totalWeights += obj.strength;
        }
        
        float delta = (node.aRange._endAngle - node.aRange._beginAngle);
        delta -= node.aRange._angleGap * node.childern.count;
        delta /= totalWeights;
        
        float begin = node.aRange._beginAngle + node.aRange._angleGap * .5;
        
        for (int i = 0; i < node.childern.count; i++)
        {
            ANLayoutNode *child = [node.childern objectAtIndex:i];
            
            AngularRange aRange = child.aRange;
            
            aRange._beginAngle = begin;
            aRange._endAngle = aRange._beginAngle + child.strength * delta;
            aRange._angle = (aRange._beginAngle + aRange._endAngle) * .5;
            aRange._beginAngle_local = aRange._beginAngle;
            aRange._endAngle_local = aRange._endAngle;
            aRange._angle_local = aRange._angle;

            child.aRange = aRange;
            child.aPosition = aRange._angle;
            
            begin = aRange._endAngle + node.aRange._angleGap;
            
            child.zoom = node.zoom;
        }
    }
    
    // each child nodes
    for (int i = 0; i < node.childern.count; i++)
    {
        radialLayout_node_2([node.childern objectAtIndex:i]);
    }
    
    return 0;
}

// versions two used range (0 - 180 degree) around node parent circle
// local parent center based.  this version will layout the child nodes along the half circle centered at the node position in the direction of current node angle
int radialLayout_node_2(ANLayoutNode* node)
{
    if (node == nil || node.childern.count == 0 || node.layoutClass != LAYOUTCLASS_RADIAL)
    {
        return 0;
    }
    
    // angular range for the child nodes is 180.
    // total angular width
    float width = 180.0 - node.aRange._angleGap * node.childern.count;
    
    // angular width rate (per weight)
    float delta = .0;
    // distribution offset
    float begin = node.aRange._angle - 90.0 + node.aRange._angleGap * .5;
    
    // compute angular range rate
    ANLayoutNode *child = nil;
    if (node.layoutStyle == LAYOUTSTYLE_Radial_Even)
    {
        // even angle distribution
        delta = width / node.childern.count;
        
        begin = node.aRange._angle - 90.0 + node.aRange._angleGap * .5;
        
        for (int i = 0; i < node.childern.count; i++)
        {
            child = [node.childern objectAtIndex:i];
            
            AngularRange aRange = child.aRange;
            
            aRange._beginAngle = begin;
            aRange._endAngle = aRange._beginAngle + delta;
            aRange._angle = (aRange._beginAngle + aRange._endAngle) * .5;
            aRange._beginAngle_local = aRange._beginAngle;
            aRange._endAngle_local = aRange._endAngle;
            aRange._angle_local = aRange._angle;
            
            child.aRange = aRange;
            
            begin = aRange._endAngle + node.aRange._angleGap;
            
            child.zoom = node.zoom;
        }
    }else if (node.layoutStyle == LAYOUTSTYLE_Radial_By_Leafs)
    {
        // weighted by total leafs in each node
        float totalWeights = .0;
        
        for (ANLayoutNode* obj in node.childern)
        {
            totalWeights += obj.visibleLeafs;
        }
        
        delta = width / totalWeights;
        begin = node.aRange._angle - 90.0 + node.aRange._angleGap * .5;
        
        for (int i = 0; i < node.childern.count; i++)
        {
            child = [node.childern objectAtIndex:i];
            
            AngularRange aRange = child.aRange;
            
            aRange._beginAngle = begin;
            aRange._endAngle = aRange._beginAngle + child.visibleLeafs * delta;
            aRange._angle = (aRange._beginAngle + aRange._endAngle) * .5;
            aRange._beginAngle_local = aRange._beginAngle;
            aRange._endAngle_local = aRange._endAngle;
            aRange._angle_local = aRange._angle;
            
            child.aRange = aRange;
            
            begin = aRange._endAngle + node.aRange._angleGap;
            
            child.zoom = node.zoom;
        }
    }else if (node.layoutStyle == LAYOUTSTYLE_Radial_By_Strength)
    {
        // weighted by node strength
        float totalWeights = .0;
        
        for (ANLayoutNode* obj in node.childern)
        {
            totalWeights += obj.strength;
        }
        
        delta = width / totalWeights;
        begin = node.aRange._angle - 90.0 + node.aRange._angleGap * .5;
        
        for (int i = 0; i < node.childern.count; i++)
        {
            ANLayoutNode *child = [node.childern objectAtIndex:i];
            
            AngularRange aRange = child.aRange;
            
            aRange._beginAngle = begin;
            aRange._endAngle = aRange._beginAngle + child.strength * delta;
            aRange._angle = (aRange._beginAngle + aRange._endAngle) * .5;
            aRange._beginAngle_local = aRange._beginAngle;
            aRange._endAngle_local = aRange._endAngle;
            aRange._angle_local = aRange._angle;
            
            child.aRange = aRange;
            
            begin = aRange._endAngle + node.aRange._angleGap;
            
            child.zoom = node.zoom;
        }
    }
    
    // adjust rPosition for each child node
    float x0, y0, dx, dy;
    
    x0 = node.rPosition * cosf(DEGREES_TO_RADIANS(node.aPosition));
    y0 = node.rPosition * sinf(DEGREES_TO_RADIANS(node.aPosition));
    
    for (int i = 0; i < node.childern.count; i++)
    {
        child = [node.childern objectAtIndex:i];
        
        dx = child.radius * cosf(DEGREES_TO_RADIANS(child.aRange._angle));
        dy = child.radius * sinf(DEGREES_TO_RADIANS(child.aRange._angle));
        
        child.rPosition = sqrtf((x0 + dx) * (x0 + dx) + (y0 + dy) * (y0 + dy));
        child.aPosition = RADIANS_TO_DEGREES(atan2f((y0 + dy), (x0 + dx)));
        
        child.rPosition_tran = child.rPosition;
        child.aPosition_tran = child.aPosition;
    }
    
    // each child nodes as start of sub tree
    for (int i = 0; i < node.childern.count; i++)
    {
        radialLayout_node_2([node.childern objectAtIndex:i]);
    }
    
    return 0;
}

//////////////////////////////////////////////////////////////////////////////////
// helper functions

// shift the circel center so angle gap is limited within 180 degree
// given sub tree with angular range greater than 180 degree compute the offset in center origin and new radius for remainning agular range circle
// can be used for computing the width distribution for left-right tree layout also
// angle_max - maximum angle (> 180 degree)
// r0 - radius
// r1 - new readius for the reaminning sub trees
// shifts - to the new circle origin where r0 is used for the sub tree with angle_max to be scaled to 180 degree while r1 will be used for the rtemaining sub trees.
// all remainning sub trees will be centered at the new origin with radius scaled to r1 range
int radialLayout_shift(float angle_max, float r0, float* r1)
{
    if (angle_max <= 180.0)
    {
        *r1 = r0;
        
        return 0;
    }
    
    *r1 = sqrtf(2.0 - angle_max / 180.0) * r0;
    
    return 0;
}

// when setting the focusing node the sub tree with focusing node needs to be adjusted for its angular range in order to contain the enlarged node.  the new angular size can be as much as 180 degree.  the remaing sub trees need to be adjusted for their new origin as result of shifting oppsite to the the focusing subtree
// root - root node
// node - focusing node
// r0 - radius of hosting circle
// r_focus - size for focusing node
// dr - magnitude of shift in origin oppsite to the focusing node tree
ANLayoutNode* radialLayout_setFocusingNode(ANLayoutNode* node, float r0, float r_focus, float* dr)
{
    if (node == nil)
    {
        *dr = 0.0;
        return nil;
    }
    
    // root node
    ANLayoutNode* root = nil, *treeNode = nil;
    
    root = node;
    treeNode = root;
    
    while (root.root != nil)
    {
        treeNode = root;
        root = root.root;
    }
    
    // for change in angular range as result of new node size r_focus for the focusing node
    float a = (treeNode.aRange._endAngle - treeNode.aRange._beginAngle), da = .0;
    
    // decide the shift oppsite to the direction of treeNode
    radialLayout_shiftByAngularRangeChange(r0, a, da, dr);
    
    // adjust tree treeNode based on its new angular range and the size set for focusing node
    
    
    return treeNode;
}

// return shift magnitude in origin for given angular range and newly incresed range
// r0 - radius
// a - sub tree angular range
// da - change in tree angular range due to focusing node
// dr - shift magnitude
int radialLayout_shiftByAngularRangeChange(float r0, float a, float da, float * dr)
{
    if (da == .0)
    {
        *dr = .0;
        return 0;
    }
    
    if ((a + da) == 180.0)
    {
        float c = 1.0 / ((1.0 - tanf((a + da) * .5) / tanf(a * .5)) * cosf(a * .5));
        *dr = r0 / (1.0 + c);
    }
    
    return 0;
}

// return mapping center shift as result of changging (shrinking) the angular range of given segment at the opposite direction
// r0 - original circle radius
// a0 - segment original angle
// a - segment new angle
// dr - [out] shift in the oppsite direction.  the original circle will be broken into two parts: one part that is reducing the angular range keeping the same radius ro and the part that incerse the total angular range but with smaller radius (r0 - dr)
int radialLayout_shift_mappingCenter(float r0, float a0, float a, float * dr)
{
    *dr = (sqrt(a0 / a) - 1.0) * r0;
    return 0;
}

// rotate child node by given degree.
// rotate the subtree nodes
// change aPosition only
int rotateSubtree(ANLayoutNode* node, float angle, bool apply2Tran)
{
    if (node == nil)
    {
        return 0;
    }
    
    if (apply2Tran)
    {
        node.aPosition_tran += angle;
    }else
    {
        node.aPosition += angle;
    }
    
    for (ANLayoutNode* obj in node.childern)
    {
        if (obj == nil)
        {
            continue;
        }
        
        rotateSubtree(obj, angle, apply2Tran);
    }
    
    return 0;
}

// shift tree by given vector
int radialLayout_tran(ANLayoutNode* node, float dx, float dy, bool apply2Tran)
{
    if (node == nil)
    {
        return 0;
    }
    
    if (apply2Tran)
    {
        float x = node.rPosition * cosf(DEGREES_TO_RADIANS(node.aPosition)) + dx;
        float y = node.rPosition * sinf(DEGREES_TO_RADIANS(node.aPosition)) + dy;
        
        node.aPosition = RADIANS_TO_DEGREES(atan2f(y, x));
        node.rPosition = sqrt(x * x + y * y);
    }else
    {
        float x = node.rPosition_tran * cosf(DEGREES_TO_RADIANS(node.aPosition_tran)) + dx;
        float y = node.rPosition_tran * sinf(DEGREES_TO_RADIANS(node.aPosition_tran)) + dy;
        
        node.aPosition_tran = RADIANS_TO_DEGREES(atan2f(y, x));
        node.rPosition_tran = sqrt(x * x + y * y);
    }
    
    for (ANLayoutNode* obj in node.childern)
    {
        if (obj == nil)
        {
            continue;
        }
        
        radialLayout_tran(node, dx, dy, apply2Tran);
    }

    return 0;
}

// linear transformation of angle only
int angleLinear_tran(ANLayoutNode* node, AngleZoomParams* params, bool apply2Tran)
{
    if (node == nil || params == nil)
    {
        return 0;
    }
    
    if (apply2Tran)
    {
        node.aPosition_tran = params->_k * (node.aPosition_tran - params->_b) + params->_c;
        node.size_tran *= params->_k;
    }else
    {
        node.aPosition = params->_k * (node.aPosition - params->_b) + params->_c;
        node.size *= params->_k;
    }
    
    for (ANLayoutNode* obj in node.childern)
    {
        angleLinear_tran(obj, params, apply2Tran);
    }
    
    return 0;
}

// make sure node angle are in (0 - 360) range
int angle360range(ANLayoutNode* node, bool apply2Tran)
{
    if (node == nil)
    {
        return 0;
    }
    
    if (apply2Tran)
    {
        if (node.aPosition_tran < 0.)
        {
            node.aPosition_tran += 360.0;
        }
        
        if (node.aPosition_tran > 360.0)
        {
            node.aPosition_tran -= 360.0;
        }
    }else
    {
        if (node.aPosition < 0.)
        {
            node.aPosition += 360.0;
        }
        
        if (node.aPosition > 360.0)
        {
            node.aPosition -= 360.0;
        }
    }
    
    for (ANLayoutNode* obj in node.childern)
    {
        angle360range(obj, apply2Tran);
    }
    
    return 0;
}

// reset {node.aPosition_tran, node.rPosition_tran} to {node.aPosition, node.rPosition}
// node.size_tran = node.size
int syncRuntimeLayout(ANLayoutNode* node)
{
    if (node == nil)
    {
        return 0;
    }
    
    node.rPosition_tran = node.rPosition;
    node.aPosition_tran = node.aPosition;
    node.size_tran = node.size;
    
    for (ANLayoutNode* obj in node.childern)
    {
        if (obj == nil)
        {
            continue;
        }
        
        syncRuntimeLayout(obj);
    }
   
    return 0;
}

// hit test for given tree
int hit_test(ANLayoutNode* node, ANLayoutNode** nodeHit, float x, float y, float* range)
{
    if (node == nil || nodeHit == nil || range == nil)
    {
        return 0;
    }
    
    *nodeHit = nil;
    
    // check this node
    
    // distance between (x,y) and node
    float dx = x - node.xPosition;
    float dy = y - node.yPosition;
    
    if (fabsf(dx) < *range && fabsf(dy) < *range && sqrtf(dx * dx + dy * dy) < *range)
    {
        *range = sqrtf(dx * dx + dy * dy);
        *nodeHit = node;
    }
    
    // and all sub nodes
    for (ANLayoutNode* obj in node.childern)
    {
        if (obj == nil)
        {
            continue;
        }
        
        hit_test(obj, nodeHit, x, y, range);
    }
    
    return 0;
}

// return tree segment for the given node
int mainbranch(ANLayoutNode* node, ANLayoutNode** nodeHit)
{
    if (node == nil || *nodeHit == nil || node.root == nil || (*nodeHit).root == nil)
    {
        // stop
        return 0;
    }
    
    // keep going
    *nodeHit = node.root;
    mainbranch(node, nodeHit);
    
    return 0;
}

// default scaling ratios version one
int setScalingRatio_1(CircleScaling* ratios)
{
    if (ratios == nil)
    {
        return 0;
    }
    
    ratios->_ratio_root._rRatio = 1.0;
    ratios->_ratio_root._sRatio = 1.0;
    
    ratios->_ratio_level1._rRatio = 1.0;
    ratios->_ratio_level1._sRatio = 1.0;
    
    ratios->_ratio_level2._rRatio = 1.5;
    ratios->_ratio_level2._sRatio = .9;
    
    ratios->_ratio._rRatio = .5;
    ratios->_ratio._sRatio = .6;
    
    return 0;
}

// apply scale space "bending" transformation
// !!! radius_tran is used internally only for getting the radius in radialLayoutTransform_scaling calculation.  it is NOT used for trsnsitional state the way rPosition_tran is used
int radialLayoutTransform_scaling(ANLayoutNode* node, CircleScaling* ratios)
{
    if (node == nil || ratios == nil)
    {
        return 0;
    }
    
    // set field radius_tran
    if (node.level == 0)
    {
        node.radius_tran = node.radius * ratios->_ratio_root._rRatio;
        node.size = node.size * ratios->_ratio_root._sRatio;
    }else if (node.level == 1)
    {
        node.radius_tran = node.radius * ratios->_ratio_level1._rRatio;
        node.size = node.size * ratios->_ratio_level1._sRatio;
    }else if (node.level == 2)
    {
        node.radius_tran = node.radius * ratios->_ratio_level2._rRatio;
        node.size = node.size * ratios->_ratio_level2._sRatio;
    }else
    {
        node.radius_tran = node.root.radius_tran * ratios->_ratio._rRatio;
        node.size = node.root.size * ratios->_ratio._sRatio;
    }
    
    node.size_tran = node.size;
    
    // we have the radius transformed for this node.  compute new rPosition
    if (node.root != nil)
    {
        // adjust rPosition for each child node
        float x0, y0, dx, dy;
    
        x0 = node.root.rPosition_tran * cosf(DEGREES_TO_RADIANS(node.root.aPosition));
        y0 = node.root.rPosition_tran * sinf(DEGREES_TO_RADIANS(node.root.aPosition));
    
        dx = node.radius_tran * cosf(DEGREES_TO_RADIANS(node.aRange._angle));
        dy = node.radius_tran * sinf(DEGREES_TO_RADIANS(node.aRange._angle));
        
        node.rPosition = sqrtf((x0 + dx) * (x0 + dx) + (y0 + dy) * (y0 + dy));
        node.aPosition = RADIANS_TO_DEGREES(atan2f((y0 + dy), (x0 + dx)));
        
        node.rPosition_tran = node.rPosition;
        node.aPosition_tran = node.aPosition;
        
    }
    
    // done.  loop through all child nodes
    for (int i = 0; i < node.childern.count; i++)
    {
        radialLayoutTransform_scaling([node.childern objectAtIndex:i], ratios);
    }

    return 0;
}

// call this function to transfor node positions from one circle domain to positions in a new given circle coordinate.  the goal is to set new valus for node transformation position {node.aPosition_tran, node.rPosition_tran}
int radialLayoutTransform_zoom_shift_circle(ANLayoutNode* node, CircleZoomShift* tran)
{
    if (node == nil || tran == nil)
    {
        return 0;
    }
    
    // transform this node position
    
    // new node rPosition:
    float r = sqrtf(node.rPosition * node.rPosition + tran->_delta * tran->_delta - 2.0 * node.rPosition * tran->_delta * cosf(DEGREES_TO_RADIANS(node.aPosition)));
    
    // new node aPosition
    float cos_a = (node.rPosition * node.rPosition - r * r - tran->_delta * tran->_delta) / (2.0 * r * tran->_delta);
    node.aPosition_tran = RADIANS_TO_DEGREES(acosf(cos_a));
    
    // make sure in sync with node.aPosition to be in the right quad
    if (node.aPosition > 180.0 || node.aPosition < .0)
    {
        node.aPosition_tran = 360.0 - node.aPosition_tran;
    }
    
    // compute rmax
    float a, b;
    
    a = 2.0 * tran->_delta * cos_a;
    b = tran->_delta * tran->_delta - tran->_R0 * tran->_R0;
    
    float r_max = -.5 * a + .5 * sqrtf(a * a - 4.0 * b);
    
    // node.rPosition is projected from range (0, r_max) to range (0, R)
    // !!! options for doing this.  it can be done via linear or cetain functions
    
    ////////////////////////
    // linear distribution of rPosition
    node.rPosition_tran = r * tran->_R / r_max;
    node.size_tran = node.size * tran->_R / r_max;
    
    ////////////////////////
    // transform all child nodes
    for (int i = 0; i < node.childern.count; i++)
    {
        radialLayoutTransform_zoom_shift_circle([node.childern objectAtIndex:i], tran);
    }
    
    return 0;
}

// function used to perform real time shift and zoom transform to set up node position (xPosition, yPosition) by calling radialLayoutTransform_zoom_shift_circle
// R_ratio - radius of the new circle in percentage of original circle radius
// dx, dy - shift of the new circle
int radialLayout_zoom_shift_circle(ANLayoutNode* node, float R_ratio, float dx, float dy)
{
    // (1) get size of tree
    float treeSize = .0, treeSize_tran = .0, edge_tran = .0;
    getTreeLength(node, &treeSize, &treeSize_tran, &edge_tran);
    
    // (2) setup transformation parameters
    CircleZoomShift tran;
    tran._R0 = treeSize;
    
    // !!! test.  for now
    //tran._R = tran._R0 * R_ratio;
    
    tran._R = tran._R0 * .25;
    tran._delta = tran._R0 * .75;
    
    // end of test
    
    // (3) transform onto the new circle
    radialLayoutTransform_zoom_shift_circle(node, &tran);
    
    return 0;
}

// zooming and shifting via space bending using focusing point
int radialLayoutTransform_zoom_shift_circle_by_focus(ANLayoutNode* node, CircleZoomShiftParams* tran)
{
    if (node == nil || tran == nil)
    {
        return 0;
    }
    
    // transform this node position
  
    // (1) angle of line (node.rPosition, node.aPosition) - (r0, a0):
    float dx = node.rPosition_tran * cosf(DEGREES_TO_RADIANS(node.aPosition_tran)) - tran->_r0 * cosf(DEGREES_TO_RADIANS(tran->_a0));
    float dy = node.rPosition_tran * sinf(DEGREES_TO_RADIANS(node.aPosition_tran)) - tran->_r0 * sinf(DEGREES_TO_RADIANS(tran->_a0));
    
    // new angle postion
    float  a1 = RADIANS_TO_DEGREES(atan2f(dy, dx));
    
    // (2) r distance from (node.rPosition, node.aPosition) to focusing point (r0, a0)
    float r1 = sqrtf(node.rPosition_tran * node.rPosition_tran + tran->_r0 * tran->_r0 - 2.0 * node.rPosition_tran* tran->_r0 * cosf(DEGREES_TO_RADIANS(node.aPosition_tran - tran->_a0)));
    
    // (3) maximum distance = from edge of circle point to (r0, a0) along the line
    // compute rmax
    float a, b;
    
    a = 2.0 * tran->_r0 * cosf(DEGREES_TO_RADIANS(a1 - tran->_a0));
    b = tran->_r0 * tran->_r0 - tran->_R0 * tran->_R0;
    
    float r_max = -.5 * a + .5 * sqrtf(a * a - 4.0 * b);
    
    ////////////////////////
    // (4) update new coordsinate psotion
    
    // set new angle position
    node.aPosition_tran = a1;
    
    // linear distribution of rPosition
    node.rPosition_tran = r1 * tran->_R0 / r_max;
    node.size_tran = node.size_tran * tran->_R0 / r_max;
    
    ////////////////////////
    // transform all child nodes
    for (int i = 0; i < node.childern.count; i++)
    {
        radialLayoutTransform_zoom_shift_circle_by_focus([node.childern objectAtIndex:i], tran);
    }
    
    return 0;
}

// zoom node tree segment.  !!! tree_seg has to be child of root tree node
int radialLayoutTransform_zoom_tree_seg(ANLayoutNode* node, ANLayoutNode* tree_seg, float gap, float rootangle)
{
    // (1) get angle range of tree_seg
    float begin_a, end_a, begin_a_tran, end_a_tran;
    
    begin_a = 720.0;
    end_a = -720.0;
    begin_a_tran = 720.0;
    end_a_tran = -720.0;
    
    getTreeWidth(tree_seg, &begin_a, &end_a, &begin_a_tran, &end_a_tran);
    
    // (2) rotate by -begin_a_tran to make sure the segment is from 0 to 2 * (end_a_tran - begin_a_tran)
    rotateSubtree(node, -begin_a_tran, true);
    
    // mid point difference for rotating back
    float dmid = .5 * (begin_a_tran + end_a_tran) - .5 * rootangle;
    
    // (3) make sure node angles are in (0, 360) range
    angle360range(node, true);
    
    end_a_tran -= begin_a_tran;
    begin_a_tran -= begin_a_tran;
    
    // (4) zoom params for the focusing segment
    AngleZoomParams zoomParams;
    
    float bAngle = begin_a_tran;
    float eAngle = end_a_tran;
    
    zoomParams._k = rootangle / (eAngle - bAngle);
    zoomParams._c = .5 * (eAngle + bAngle - rootangle);
    zoomParams._b = bAngle;
    
    // (5) linear scale of tree_seg
    angleLinear_tran(tree_seg, &zoomParams, true);

    // (6) linear scale the rest of segments to range of (360 - rootangle)
    bAngle = zoomParams._k * (end_a_tran - zoomParams._b) + zoomParams._c + .5 * gap;
    eAngle = 360.0 - .5 * gap;
    rootangle = 360.0 - rootangle;
    
    zoomParams._k = rootangle / (eAngle - bAngle);
    zoomParams._c = .5 * (eAngle + bAngle - rootangle);
    zoomParams._b = bAngle;
    
    for (ANLayoutNode* obj in node.childern)
    {
        if (obj == tree_seg)
        {
            // skip this one.  already done
            continue;
        }
        
        angleLinear_tran(obj, &zoomParams, true);
    }

    // (7) done.  rotate back
    rotateSubtree(node, dmid, true);
    
    return 0;
}

////////////////////////////////////////////////////////////////////////////
// ANRadialLayout interface
////////////////////////////////////////////////////////////////////////////

@implementation ANRadialLayout
{
@private
    
    // object otminimize node overlap
    ANLayoutCollisionMinimize* _collisionMinimizer;
}

// methods for setting up layout object
-(void) setDefaultMappingParams
{
    // use (rPosition, aPosition)
    _mapParams._bUseTran = true;
    _mapParams._sizeRatio = 1.0;
    _mapParams._edge_tran = .0;
    _mapParams._mappingMode = MAPPINGMODE_BY_DIMENSION;
    
    // radius of virtual circle
    _mapParams._radius = 100.0;
    _mapParams._radius1 = _mapParams._radius;
    _mapParams._orginShift._x = .0;
    _mapParams._orginShift._y = .0;
}

// compute ratio for node visual size for current mapping parameters
-(void) updateNodeVisualSizeRatio:(ANLayoutNode*) node
{
    // get node tree size after the layout
    float treeSize = .0, treeSize_tran = .0, edge_tran = .0;
    getTreeLength(node, &treeSize, &treeSize_tran, &edge_tran);
    
    // compute size ratio for mapping node size in virtual circle to hosting rect area
    _mapParams._sizeRatio = ((_mapParams._right - _mapParams._left) + (_mapParams._bottom - _mapParams._top)) / (4.0 * treeSize);
    
    // "edge" by size of node on the outside edge
    _mapParams._edge_tran = edge_tran;

}

-(id)init
{
    self = [super init];
    if (self == nil)
    {
        return nil;
    }
    
    _aRatio = .5;
    
    _collisionMinimizer = [[ANLayoutCollisionMinimize alloc] init];
    
    [self setDefaultMappingParams];
    setScalingRatio_1(&_nodeScale);
    setDefaultLevel2DistanceParams(&_distanceParams, LAYOUTTYPE_3);
    
    return self;
}

// ratio for node visual presentation
-(float) nodeVisualSizeRatio
{
    return _mapParams._sizeRatio;
}

// layout node tree onto internal virtual circle via space bending
// after this call the given node tree is layout onto internal virtual circle with node overlapping is minimized
-(int) treeLayout_spaceShape:(ANLayoutNode*) node
                     uniform:(bool)uniform
{
    if (node == nil)
    {
        return 0;
    }

    
    ////////////////////////////////////////
    // Phase one: inital layout onto uniform space
    ////////////////////////////////////////
    _distanceParams._layout_class = LAYOUTCLASS_RADIAL;
    
    // (1) compute tree node strength first
    [ANLayoutNode calculateTreeStrength:node param:&_distanceParams];
    // virtual circle radius
    _mapParams._radius = _distanceParams._maxDistance;

    // (2) angular distribution of root (level one child nodes) node first
    int rc = radialLayout_root_2(node, _mapParams._radius, &(_mapParams._radius1), _aRatio, &(_mapParams._orginShift));
    if (rc != 0)
    {
        return rc;
    }
    
    
    // (3) all rest of the nodes (level two and above nodes)
    for (int i = 0; i < node.childern.count; i++)
    {
        radialLayout_node_2([node.childern objectAtIndex:i]);
    }
    
    ////////////////////////////////////////
    // (4) bend space shape
    ////////////////////////////////////////
    if (uniform != true)
    {
        radialLayoutTransform_scaling(node, &_nodeScale);
    }
    
    
    ////////////////////////////////////////
    // (5) reduce node overlapping
    ////////////////////////////////////////
    
    if (_collisionMinimizer == nil)
    {
        _collisionMinimizer = [[ANLayoutCollisionMinimize alloc] init];
    }
    
    [_collisionMinimizer attachNodeToGrid:node];
    
    // by reducing node density per cell
    [_collisionMinimizer minimizeNodeCollisions_Density:node];
    
    // (6) sync node.rPosition_tran, node.aPosition_tran and node.size_tran
    syncRuntimeLayout(node);
    
    return 0;
}

// map node tree circle layout onto hosting rect
-(int) treeLayout_virtualCircle_2_hostingRect:(ANLayoutNode*) node
                                       hostRc:(CGRect) hostRc
{
    if (node == nil)
    {
        return 0;
    }
    
    _mapParams._left = hostRc.origin.x;
    _mapParams._right = _mapParams._left + hostRc.size.width;
    _mapParams._top = hostRc.origin.y;
    _mapParams._bottom = _mapParams._top + hostRc.size.height;
   
    [self updateNodeVisualSizeRatio:node];

    // project onto given hosting rect area
    radialLayout_transform(node, &_mapParams);
    
    return 0;
}

// layout the node tree onto given hosting rect area.
// after this call the node tree is ready for displaying onto the rect area
// {node.aPosition, node.rPosition} = {node.aPosition_tran, node.rPosition_tran} = layout
// {node.aPosition_tran, node.rPosition_tran}  => (xPosition, yPosition)
// node - root
// bendspace - true if space need to be bent for scaling node to different sizes
// hostRc - hosting rect area
-(int) treeLayout_spaceShape:(ANLayoutNode*) node
                   bendspace:(bool) bendspace
                      hostRc:(CGRect) hostRc
{
    if (node == nil)
    {
        return 0;
    }
    
    // first layout node tree onto the virtual circle
    // (1) node tree layout onto internal virtual circle
    [self treeLayout_spaceShape:node uniform:!bendspace];

    // (2) map node tree circle layout onto hosting rect
    [self treeLayout_virtualCircle_2_hostingRect:node hostRc:hostRc];

    
    return 0;
}

// zoom - shift of node tree
-(int) treeLayout_zoom_shift_circle:(ANLayoutNode*) node
                             hostRc:(CGRect) hostRc
                            R_ratio:(float) R_ratio
                                 dx:(float) dx
                                 dy:(float) dy
{
    if (node == nil)
    {
        return 0;
    }
    
    // (1) zoom - shift
    radialLayout_zoom_shift_circle(node, R_ratio, dx, dy);
    
    // (2) re-map onto the hodting rect
    _mapParams._left = hostRc.origin.x;
    _mapParams._right = _mapParams._left + hostRc.size.width;
    _mapParams._top = hostRc.origin.y;
    _mapParams._bottom = _mapParams._top + hostRc.size.height;
    _mapParams._mappingMode = MAPPINGMODE_BY_DIMENSION;
    
    [self updateNodeVisualSizeRatio:node];
    
    radialLayout_transform(node, &_mapParams);
    
    return 0;
}

// zoom - shift by setting focusing point only
// (x0, y0) - focusing point for zoom - shift transformation in the format of ratio over R0
// !!! the operation is done on top of (node.rPosition_tran, node.aPosition)
-(int) treeLayout_zoom_shift_circle_by_focus:(ANLayoutNode*) node
                                      hostRc:(CGRect) hostRc
                                  x0_byRatio:(float)x0_byRatio
                                  y0_byRatio:(float)y0_byRatio
{
    if (node == nil)
    {
        return 0;
    }
    
    // get tree size
    float treeSize = .0, treeSize_tran = .0, edge_tran = .0;
    getTreeLength(node, &treeSize, &treeSize_tran, &edge_tran);
    
    // use treeSize_tran as circle radius
    float R0 =  treeSize_tran;
    
    // (1) zoom - shift
    CircleZoomShiftParams tran_params;
    
    float x0 = x0_byRatio * R0;
    float y0 = y0_byRatio * R0;
    
    tran_params._a0 = RADIANS_TO_DEGREES(atan2f(y0, x0));
    tran_params._r0 = sqrtf(x0 * x0 + y0 * y0);
    tran_params._R0 = R0;
    
    radialLayoutTransform_zoom_shift_circle_by_focus(node, &tran_params);
    
    // (2) re-map onto the hodting rect
    _mapParams._left = hostRc.origin.x;
    _mapParams._right = _mapParams._left + hostRc.size.width;
    _mapParams._top = hostRc.origin.y;
    _mapParams._bottom = _mapParams._top + hostRc.size.height;
    _mapParams._mappingMode = MAPPINGMODE_BY_DIMENSION;
    
    [self updateNodeVisualSizeRatio:node];
    
    radialLayout_transform(node, &_mapParams);
    
    return 0;
}

// zoom - shift by rotate, zoom and rotate back
-(int) treeLayout_zoom_shift_circle_by_focus_angleoffset:(ANLayoutNode*) node
                                                  hostRc:(CGRect) hostRc
                                              x0_byRatio:(float)x0_byRatio
                                              y0_byRatio:(float)y0_byRatio
                                                   angle:(float)angle
{
    if (node == nil)
    {
        return 0;
    }
    
    // get tree size
    float treeSize = .0, treeSize_tran = .0, edge_tran = .0;
    getTreeLength(node, &treeSize, &treeSize_tran, &edge_tran);
    
    // use treeSize_tran as circle radius
    float R0 =  treeSize_tran;
    
    // (1) zoom - shift
    CircleZoomShiftParams tran_params;
    
    float x0 = x0_byRatio * R0;
    float y0 = y0_byRatio * R0;
    
    tran_params._a0 = RADIANS_TO_DEGREES(atan2f(y0, x0));
    tran_params._r0 = sqrtf(x0 * x0 + y0 * y0);
    tran_params._R0 = R0;
    
    rotateSubtree(node, angle, true);
    radialLayoutTransform_zoom_shift_circle_by_focus(node, &tran_params);
    rotateSubtree(node, -angle, true);
    
    // (2) re-map onto the hodting rect
    _mapParams._left = hostRc.origin.x;
    _mapParams._right = _mapParams._left + hostRc.size.width;
    _mapParams._top = hostRc.origin.y;
    _mapParams._bottom = _mapParams._top + hostRc.size.height;
    _mapParams._mappingMode = MAPPINGMODE_BY_DIMENSION;
    
    [self updateNodeVisualSizeRatio:node];
    
    radialLayout_transform(node, &_mapParams);
    
    return 0;
}

// zoom onto the given sub-tree.
// rotate to the subtree position and shift to mid point to the node
// node - root
// node_focus - node of focusing sub tree
-(int) treeLayout_zoom_sub_tree:(ANLayoutNode*) node
                     node_focus:(ANLayoutNode*) node_focus
                         hostRc:(CGRect) hostRc
{
    if (node == nil || node_focus == nil)
    {
        return 0;
    }
    
    // get tree size
    float treeSize = .0, treeSize_tran = .0, edge_tran = .0;
    getTreeLength(node, &treeSize, &treeSize_tran, &edge_tran);
    
    // (1) get angle of this sub tree
    float angle = node_focus.aPosition_tran;
    
    // (2) zoom-shift
    float rRatio = (node_focus.rPosition_tran - node_focus.size_tran) / treeSize_tran;
    
    [self treeLayout_zoom_shift_circle_by_focus_angleoffset:node hostRc:hostRc x0_byRatio:rRatio y0_byRatio:.0 angle:-angle];
    
    return 0;
}

// via new root angle for space "bending"
// node - root
// node_seg - node of sub-tree segment
// hostRc - hosting rect
// rootangle - angle area of sub-tree segment
-(int) treeLayout_zoom_sub_tree:(ANLayoutNode*) node
                       node_seg:(ANLayoutNode*) node_seg
                         hostRc:(CGRect) hostRc
                      rootangle:(float)rootangle
{
    if (node == nil || node_seg == nil)
    {
        return 0;
    }
    
    // (1) scale tree segments
    radialLayoutTransform_zoom_tree_seg(node, node_seg, _distanceParams._gap, rootangle);
    
    // (2) re-map onto the hodting rect
    _mapParams._left = hostRc.origin.x;
    _mapParams._right = _mapParams._left + hostRc.size.width;
    _mapParams._top = hostRc.origin.y;
    _mapParams._bottom = _mapParams._top + hostRc.size.height;
    _mapParams._mappingMode = MAPPINGMODE_BY_DIMENSION;
    
    [self updateNodeVisualSizeRatio:node];
    
    radialLayout_transform(node, &_mapParams);
    
    return 0;
}

// hit test to return node and subtree being hit within given range
// node - root
// nodeHit - the nearst node
// treeHit - the nodeHit belong to
// x, y - coordinate in the hosting rect
// range - serach range
-(int) treeLayout_hit_test:(ANLayoutNode*) node
                   nodeHit:(ANLayoutNode**)nodeHit
                   treeHit:(ANLayoutNode**)treeHit
                         x:(float)x
                         y:(float)y
                     range:(float)range
{
    // serach for hit
    if (node == nil || nodeHit == nil || treeHit == nil)
    {
        return 0;
    }
    
    float minDis = 100000000.0;
    
    hit_test(node, nodeHit, x, y, &minDis);
    
    // find the sub tree being hit
    mainbranch(*nodeHit, treeHit);
    
    return 0;
}

// !!! make sure you already called treeLayout_spaceShape or treeLayout_spaceShape to layout the node tree onto virtual circle
-(int) treeLayout_rotate:(ANLayoutNode*) node
                   angle:(float)angle
              apply2Tran:(bool)apply2Tran
{
    if (node == nil)
    {
        return 0;
    }
    
    rotateSubtree(node, angle, apply2Tran);
    radialLayout_transform(node, &_mapParams);
    
    return 0;
}

// !!! make sure you already called treeLayout_spaceShape or treeLayout_spaceShape to layout the node tree onto virtual circle
// {node.aPosition, node.rPosition} => {node.aPosition_tran, node.rPosition_tran}
-(int) treeLayout_syncRuntimeLayout:(ANLayoutNode*) node
{
    syncRuntimeLayout(node);
    radialLayout_transform(node, &_mapParams);
    
    return 0;
}

@end

