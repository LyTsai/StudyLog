//
//  ANRadialLayout.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 1/16/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ANLayoutNode.h"
#import "ANLayoutCollisionMinimize.h"

// circle corodiante to hoting rect mapping mode
typedef enum
{
    MAPPINGMODE_BY_RADIUS       = 1,    // by circle radius
    MAPPINGMODE_BY_DIMENSION    = 2     // by circle dimension
}MAPPINGMODE;

// define structure for mapping radial positions to hosting rect area
typedef struct
{
    // hosting rect information
    float _left;
    float _right;
    float _top;
    float _bottom;
    
    // circle to rect mapping function selection
    // virtual circle information
    
    // radius (without space bending)
    float _radius;
    
    // radius after space bending
    // by rPosition
    float _treeSize;
    // by rPosition_tran
    float _treeSize_tran;
    // largerst node size on the edge in transitional state
    float _edge_tran;
  
    // map between rect and circle using (rPosition, aPosition) or (rPosition_tran, aPosition_tran)
    bool _bUseTran;
    
    // shift in mapping.  default is to put the circle and rect center on top of each other
    // dynamic parameter
    XYPos _orginShift;
    
    // circle corodinate to hosting rect mapping mode
    MAPPINGMODE _mappingMode;
    
    /////////////////////////////////////////////////////////////////////////
    // dynamic parameters (do not modify):
    /////////////////////////////////////////////////////////////////////////
    
    // ratio used for mapping node size in virtual space to hosting RECT area.  this is the size ration between node size on rect and virtual circle
    float _sizeRatio;
    
    // new radius for the sub trees (exclude the sub tree with greater than 180 degree) areas after moving to the new  circle center (by _orginShift)
    float _radius1;
    
    // rect center position
    float _x0;
    float _y0;

    // run time mapping for the four quad
    float _kr;  // right
    float _kl;  // left
    float _kt;  // top
    float _kb;  // bottom
    
    // run time mapping from circle coordinate to hosting rect coordinate
    float _kx;  //
    float _ky;  //
    
    // (xPosition, yPosition) range of virtual circel for mapping purpose
    float _xPosition_Min;
    float _xPosition_Max;
    float _yPosition_Min;
    float _yPosition_Max;
    
}Circle2RecttMapping;

// data structure used for "zooming" given sub-tree segment
typedef struct
{
    float _k;       // angle slop
    float _c;       // angle shift
    float _b;       // angle bias (or beginning position)
}AngleZoomParams;

///////////////////////////////////////////////////////////////////////////////
// layout the tree.  called top set up the inital tree layout
///////////////////////////////////////////////////////////////////////////////
// node - tree root
// r0 - hosting circle radius
// shifts - intrinsic center shift
// aRatio - ratio to combine the two angular range: aRatio * uniform + (1.0 - aRatio) * weighted  aRatio = 1.0 for using uniform angular width

// default version that
int radialLayout(ANLayoutNode* node, float aRatio, Circle2RecttMapping* mapParams);

// version that perform uniform layout first followed by layout space defromation (transform by specified function)
// aRatio - weight between uniform angle or by strength for the level one sub trees
int radialLayout_spaceShape(ANLayoutNode* node, float aRatio, Circle2RecttMapping* mapParams);

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
int radialLayout_setFocus(ANLayoutNode* node, float size, Circle2RecttMapping* mapParams);

///////////////////////////////////////////////////////////////////////
// transform to rect area for the given rect based mapping information
// (aPosition_tran, rPosition_tran) to (xPosition, yPosition)
// fill out (x, y) or (xPosition, yPosition) field of each node for the given rect and mapping
int radialLayout_transform(ANLayoutNode* node, Circle2RecttMapping* mapParams);

// map circle coordinate onto hosting rect coordiante by circle radius
int radialLayout_transform_by_radius(ANLayoutNode* node, Circle2RecttMapping* mapParams);

// used by radialLayout_transform_by_radius.  node position (xPosition, yPosition) is set after this call
int _linear_tranform(ANLayoutNode* node, Circle2RecttMapping* mapParams);

// call getTreeDimension to get virtual circle dimentison for mapping onto hosting rect area
// the final result is to translate from (aPosition_tran, rPosition_tran) to (xPosition, yPosition)
int radialLayout_transform_by_demension(ANLayoutNode* node, Circle2RecttMapping* mapParams);

// used by radialLayout_transform_by_demension
int _linear_tranform_by_demension(ANLayoutNode* node, Circle2RecttMapping* mapParams);

// point coordinate conversion between hosting rect and virtual circle
int circle2rect(float r, float a, float* x, float* y, Circle2RecttMapping* mapParams);
int rect2circle(float x, float y, float* r, float* a, Circle2RecttMapping* mapParams);

// project node circle coordiante (rPosition, aPosition) to xy coordinate (xPosition, yPosition)
int updateNodeXYPositions(ANLayoutNode* node);

// project node circle coordiante (rPosition_tran, aPosition_tran) to xy coordinate (xPosition, yPosition)
int updateNodeXYTranPositions(ANLayoutNode* node);

// get tree size by (xPosition, yPosition)
int getTreeXYPositionRanges(ANLayoutNode* node, Circle2RecttMapping* mapParams);

// get current xPosition, yPostion extent for mapping purpose
int getTreeDimension(ANLayoutNode* node, Circle2RecttMapping* mapParams);

///////////////////////////////////////////////////////////////////////////////
// radial layout functions

// inital layout of segments at the root functions:

// tree root layout functions:
// (1) put the root at the center
// (2) put rect mapping center to the same circle center
// (3) distribute angular range over first level subtree weight
// (4) shift rect mapping center to make sure no sub tree get more than
// r0 - [in] radius of hosting circle
// aRatio - ratio to combine the two angular range: aRatio * uniform + (1.0 - aRatio) * weighted  aRatio = 1.0 for using uniform angular width
// shifts - [in, out] proposed shift in center

// !!! the layut algorithm will try to limit any sub tree within 180 degree width limit.  as result, the zoom factor and circle origin maybe shifted

// version one uses the angle ranges decided by the node strength relative to the root circle origin
// function 1
int radialLayout_root_1(ANLayoutNode* node, float r0, float* r1, float aRatio, XYPos* shifts);

// versions two used range (0 - 180 degree) around node parent circle
// function 2
int radialLayout_root_2(ANLayoutNode* node, float r0, float* r1, float aRatio, XYPos* shifts);

// child node only.
// version one uses the angle ranges decided by the node strength relative to the root circle origin
// the default value layoutStyle for child node is LAYOUTSTYLE_Radial_By_Strength
int radialLayout_node_1(ANLayoutNode* node);

// versions two used range (0 - 180 degree) around node parent circle
// local parent center based
int radialLayout_node_2(ANLayoutNode* node);

///////////////////////////////////////////////////////////////////////////////
// help functions:

// given sub tree with angular range greater than 180 degree compute the off set in center origin and new radius for remainning agular range circle
// angle_max - maximum angle (> 180 degree)
// r0 - radius
// r1 - new readius for the reaminning sub trees
// shifts - to the new circle origin where r0 is used for the sub tree with angle_max to be scaled to 180 degree while r1 will be used for the rtemaining sub trees.
// all remainning sub trees will be centered at the new origin with radius scaled to r1 range
int radialLayout_shift(float angle_max, float r0, float* r1);

// when setting the focusing node the sub tree with focusing node needs to be adjusted for its angular range in order to contain the enlarged node.  the new angular size can be as much as 180 degree.  the remaing sub trees need to be adjusted for their new origin as result of shifting oppsite to the the focusing subtree
// !!! note that this is used for changging the angular range of given segment while preserving the structure of reamining segments.
// root - root node
// node - focusing node
// r0 - radius of hosting circle
// r_focus - size for focusing node
// dr - magnitude of shift in origin oppsite to the focusing node tree.  the new radius of the remaining segments are going to be r0 - dr
ANLayoutNode* radialLayout_setFocusingNode(ANLayoutNode* node, float r0, float r_focus, float* dr);

// return shift magnitude in origin for given angular range and newly incresed range
// !!! note that this is used for changging the angular range of given segment while preserving the structure of reamining segments.
// r0 - radius
// a - sub tree angular range
// da - change in tree angular range due to focusing node
// dr - shift magnitude.  the new radius of the remaining segments are going to be r0 - dr
int radialLayout_shiftByAngularRangeChange(float r0, float a, float da, float * dr);

// return mapping center shift as result of changging (shrinking) the angular range of given segment at the opposite direction
// r0 - original circle radius
// a0 - segment original angle
// a - segment new angle
// dr - [out] shift in the oppsite direction.  the original circle will be broken into two parts: one part that is reducing the angular range keeping the same radius ro and the part that incerse the total angular range but with smaller radius (ro - dr)
int radialLayout_shift_mappingCenter(float r0, float a0, float a, float * dr);

// rotate child node by given degree.
// rotate the subtree nodes
int rotateSubtree(ANLayoutNode* node, float angle, bool apply2Tran);

// shift tree by given vector
int radialLayout_tran(ANLayoutNode* node, float dx, float dy, bool apply2Tran);

// linear transformation of angle only
int angleLinear_tran(ANLayoutNode* node, AngleZoomParams* params, bool apply2Tran);

// make sure node angle are in (0 - 360) range
int angle360range(ANLayoutNode* node, bool apply2Tran);

// reset {node.aPosition_tran, node.rPosition_tran} to {node.aPosition, node.rPosition}
int syncRuntimeLayout(ANLayoutNode* node);

// hit test for given tree
int hit_test(ANLayoutNode* node, ANLayoutNode** nodeHit, float x, float y, float* range);

// return tree segment for the given node
int mainbranch(ANLayoutNode* node, ANLayoutNode** nodeHit);

///////////////////////////////////////////////////////////////////////////////////////
// functions for layout deformation, scaling and transformation of given tree (root or sub)
///////////////////////////////////////////////////////////////////////////////////////

// scaling
typedef struct
{
    float _sRatio;              // ratio used for calculating node size. 1.0 as default value
    float _rRatio;              // radius (gap) ratio between the node levels
}ScaleRatio;

typedef struct
{
    ScaleRatio _ratio_root;     // root node
    ScaleRatio _ratio_level1;   // level one
    ScaleRatio _ratio_level2;   // level two
    ScaleRatio _ratio;          // the rest node levels
}CircleScaling;

// default scaling ratios version one
int setScalingRatio_1(CircleScaling* ratios);

// apply scale space transformation
int radialLayoutTransform_scaling(ANLayoutNode* node, CircleScaling* ratios);

// scaling of

///////////////////////////////////////////////////////////////////////////////////////
// functions for zooming / shifting via transformation between circles
///////////////////////////////////////////////////////////////////////////////////////

// define structure for transformation parameters
typedef struct
{
    // original circle
    // radius of orginal circle
    float _R0;
    
    // new circle
    // radius of new circle
    float _R;
    // shift along radius of original circle.  positive to the right and negative to the left
    float _delta;
    
}CircleZoomShift;

// call this function to transfor node positions from one circle domain to positions in a new given circle coordinate.  the goal is to set new valus for intermediate node position {node.aPosition_tran, node.rPosition_tran}
int radialLayoutTransform_zoom_shift_circle(ANLayoutNode* node, CircleZoomShift* tran);

// function used to perform real time shift and zoom transform to set up node position (xPosition, yPosition) by calling radialLayoutTransform_zoom_shift_circle
// R_ratio - radius of the new circle in percentage of original circle radius
// dx, dy - shift of the new circle
int radialLayout_zoom_shift_circle(ANLayoutNode* node, float R_ratio, float dx, float dy);

////////////////////////////////////////////////////////////////
// new version of zooming and shifting via space bending using focusing point
////////////////////////////////////////////////////////////////
typedef struct
{
    // original circle
    // radius of orginal circle
    float _R0;
    
    // focus point
    float _r0;
    float _a0;
}CircleZoomShiftParams;

// zoom - shift by setting focusing point only
int radialLayoutTransform_zoom_shift_circle_by_focus(ANLayoutNode* node, CircleZoomShiftParams* tran);

// zoom node tree segment.  !!! tree_seg has to be child of root tree node
int radialLayoutTransform_zoom_tree_seg(ANLayoutNode* node, ANLayoutNode* tree_seg, float gap, float rootangle);

///////////////////////////////////////////////////////////////////////////////

@interface ANRadialLayout : NSObject

// properties

// aRatio - weight between uniform angle or by strength for the level one sub trees
@property float aRatio;

// circle to rect mapping parameters
@property Circle2RecttMapping mapParams;

// node tree size distribution over level and distance
@property Level2DistanceParams distanceParams;

// node layout scale by radius and distance
@property CircleScaling nodeScale;

// zoom shift parameters for calling radialLayout_zoom_shift_circle
@property CircleZoomShift zoomShift;

// access to internal data
// ratio for node visual presentation
-(float) nodeVisualSizeRatio;

// methods for laying out node tree

// layout node tree onto internal virtual circle
// after this call the given node tree is layout onto internal virtual circle with node overlapping is minimized.
// {node.aPosition, node.rPosition} = {node.aPosition_tran, node.rPosition_tran} = layout
-(int) treeLayout_spaceShape:(ANLayoutNode*) node
                     uniform:(bool)uniform;

// map node tree circle layout onto hosting rect
// {node.aPosition_tran, node.rPosition_tran}  => (xPosition, yPosition)
-(int) treeLayout_virtualCircle_2_hostingRect:(ANLayoutNode*) node
                                       hostRc:(CGRect) hostRc;

///////////////////////////////////////////////////////////////////////////////////
// functions called for mapping node tree onto given hosting rect
///////////////////////////////////////////////////////////////////////////////////
// layout the node tree onto given hosting rect area.
// after this call the node tree is ready for displaying onto the rect area
// {node.aPosition, node.rPosition} = {node.aPosition_tran, node.rPosition_tran} = layout
// {node.aPosition_tran, node.rPosition_tran}  => (xPosition, yPosition)
// node - root
// bendspace - true if space need to be bent for scaling node to different sizes
// hostRc - hosting rect area
-(int) treeLayout_spaceShape:(ANLayoutNode*) node
                   bendspace:(bool) bendspace
                      hostRc:(CGRect) hostRc;

///////////////////////////////////////////////////////////////////////////////////
// methods to change layout (zoom or shifting) at run time
///////////////////////////////////////////////////////////////////////////////////
// zoom - shift of node tree of a already mapped node tree
// !!! make sure you already called treeLayout_spaceShape or treeLayout_spaceShape to layout the node tree onto virtual circle
// updated in {node.aPosition_tran, node.rPosition_tran}
// {node.aPosition_tran, node.rPosition_tran}  => (xPosition, yPosition)
-(int) treeLayout_zoom_shift_circle:(ANLayoutNode*) node
                             hostRc:(CGRect) hostRc
                            R_ratio:(float) R_ratio
                                 dx:(float) dx
                                 dy:(float) dy;

// zoom - shift by setting focusing point only.
// (x0, y0) - focusing point for zoom - shift transformation in the format of ratio over R0
// !!! basicly the same as treeLayout_zoom_shift_circle using the size_tran as R0
// !!! the operation is done on top of (node.rPosition_tran, node.aPosition)
-(int) treeLayout_zoom_shift_circle_by_focus:(ANLayoutNode*) node
                                      hostRc:(CGRect) hostRc
                                  x0_byRatio:(float)x0_byRatio
                                  y0_byRatio:(float)y0_byRatio;

// zoom - shift by rotate, zoom-shift and rotate back
-(int) treeLayout_zoom_shift_circle_by_focus_angleoffset:(ANLayoutNode*) node
                                                  hostRc:(CGRect) hostRc
                                              x0_byRatio:(float)x0_byRatio
                                              y0_byRatio:(float)y0_byRatio
                                                   angle:(float)angle;

// zoom onto given node to focus on the node only

/////////////////////////////////////////////////
// zoon onto given sub tree
// zoom onto the given sub-tree.
// rotate to the subtree position and shift to mid point to the node
// node - root
// node_focus - node of focusing sub tree
-(int) treeLayout_zoom_sub_tree:(ANLayoutNode*) node
                     node_focus:(ANLayoutNode*) node_focus
                         hostRc:(CGRect) hostRc;

// via new root angle for space "bending"
// node - root
// node_seg - node of sub-tree segment
// hostRc - hosting rect
// rootangle - angle area of sub-tree segment
-(int) treeLayout_zoom_sub_tree:(ANLayoutNode*)node
                       node_seg:(ANLayoutNode*) node_seg
                         hostRc:(CGRect) hostRc
                      rootangle:(float)rootangle;

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
                     range:(float)range;

///////////////////////////////////////////////////////////////////////////////////
// rotate node tree layout
///////////////////////////////////////////////////////////////////////////////////
// !!! make sure you already called treeLayout_spaceShape or treeLayout_spaceShape to layout the node tree onto virtual circle
// change node.aPosition
-(int) treeLayout_rotate:(ANLayoutNode*) node
                   angle:(float)angle
              apply2Tran:(bool)apply2Tran;

///////////////////////////////////////////////////////////////////////////////////
// reset to original layout
///////////////////////////////////////////////////////////////////////////////////
// !!! make sure you already called treeLayout_spaceShape or treeLayout_spaceShape to layout the node tree onto virtual circle
// {node.aPosition, node.rPosition} => {node.aPosition_tran, node.rPosition_tran}
-(int) treeLayout_syncRuntimeLayout:(ANLayoutNode*) node;

@end

