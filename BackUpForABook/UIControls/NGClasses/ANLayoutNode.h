//
//  ANLayoutNode.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 1/16/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>


// Radians to Degrees
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

// Degrees to radians
#define DEGREES_TO_RADIANS(angle) ((angle) * M_PI / 180.0)

// define node class for layout unit

// sub tree layout (of nodes) class
typedef enum
{
    LAYOUTCLASS_NULL            = 0,    // not defined
    LAYOUTCLASS_RANDOM          = 1,    // random layout
    LAYOUTCLASS_UNIFORM         = 2,    // uniform layout
    LAYOUTCLASS_TREE_TD         = 3,    // tree layout (top down)
    LAYOUTCLASS_TREE_LR         = 4,    // tree layout (left right)
    LAYOUTCLASS_CIRCLE_RECT_LR  = 5,    // mindjet type
    LAYOUTCLASS_RADIAL          = 6,    // radial circle
    LAYOUTCLASS_GRAPH           = 7,    // classic graph layout
    LAYOUTCLASS_FORCEDIRECT     = 8,    // force direct graph layout
    LAYOUTCLASS_CHORDCHART      = 9,    // chord chart
    LAYOUTCLASS_DEFINED_PATH    = 10    // based on given path for sub nodes (such as butterflay)
}LAYOUTCLASS;

// sub tree layout (of nodes) secodary class (options for each LAYOUTCLASS)
typedef  enum
{
    LAYOUTSUBCLASS_NULL         = 1,    // no specific style
    LAYOUTSUBCLASS_ORGCHART     = 2,    // orgchart tree layout where each child node is layed out one line below the node with given offset
    LAYOUTSUBCLASS_TREE         = 3     // classic tree layout where each child is branching out after the end of node (the same line)
}LAYOUTSUBCLASS;

// sub tree layout style (for given class) for allocating space at this node level.  layout class has to be selected first
typedef enum
{
    LAYOUTSTYLE_NULL                = 0,    // not defined
    LAYOUTSTYLE_Radial_Even         = 1,    // even distribution of radial layout.  used in Pavlo method
    LAYOUTSTYLE_Radial_By_Leafs     = 2,    // weight by number of leafs (visible)
    LAYOUTSTYLE_Radial_By_Strength  = 3,    // weight by each node strength distribution of radial layout.  used in Yee method
    LAYOUTSTYLE_Radial_By_E_Strength = 4,   // weighted by effective strength
    LAYOUTSTYLE_Radial_End          = 5
}LAYOUTSTYLE;

// how to compute node size
typedef enum
{
    NODESIZE_AUTO_FIT               = 1,    // auto fit into the ring "gap" for the given level.  distance and gap are already decided
    NODESIZE_FOCUS                  = 2,    // focusing node is computed differently
    NODESIZE_FIXED                  = 3,    // use fixed value in size_runtime
    NODESIZE_RATIO_LEVEL            = 4,    // shrink by factor decided by node level
    NODESIZE_RATIO_ROOT             = 5     // shrink by factor of root size
}NODESIZE;

// tree strength model
typedef enum
{
    STRENGTHMODEL_RADIAL            = 1,    // by angle size
    STRENGTHMODEL_WIDTH             = 2,    // by width
    STRENGTHMODEL_HEIGHT            = 3,    // by height
    STRENGTHMODEL_SIZE              = 4     // by total size
}STRENGTHMODEL;

// angular range for the given node
typedef struct
{
    // relative to root tree origin (0, 0)
    // angle of sub tree node (branch root)
    float _angle;
    
    // angle range for this sub tree.  use the root center as original
    float _beginAngle;
    float _endAngle;
    
    // relative to the parent node position
    float _angle_local;
    // local angle range using parent node as center
    float _beginAngle_local;
    float _endAngle_local;
    
    // gap between branch segments
    float _angleGap;
    
}AngularRange;

void setDefaultParams(AngularRange* angleRange);

// define structure for calculating node distance for given node level
// type of converting
typedef enum
{
    SUBTREEGRID_EVEN    = 1,    // uniform
    SUBTREEGRID_BINARY  = 2,    // half of parent width
    SUBTREEGRID_RATIO   = 3,    // ratio of parent width
}SUBTREEGRID;

// distance is in arb unit.  will be rescaled by the circle radius
#define distance_unit   1

typedef struct
{
    SUBTREEGRID _type;          // method for deciding the gap between rings
    
    LAYOUTCLASS _layout_class;  // graph layout class
    LAYOUTSUBCLASS _layout_sub_class;
    
    float _gap;                 // ring gap distance for SUBTREEGRID_EVEN.
    
    float _margin_node;         // gap between nodes at the same level.  as if along x aix
    float _margin_level;        // gap between node levels.  as if along y aix
    float _margin_depth;        // gap between node and its child node group
    
    float _sRatio;              // ratio used for calculating node size.  3 / 4 as default
    float _rRatio;              // r ratio used for SUBTREEGRID_BINARY
    float _dRatio;              // ratio for calculating distance
    
    // space at the root
    float _rootRadius;          // from center to the first level
    // root node size
    float _rootNodeSize;
    
    // space for the first level
    float _firstLevelRadius;    // radius of cicle along whose the second levle nodes are drawn
    // first level node size (visual appearence)
    float _firstLevelNodeSize;
    
    // space for the second level
    float _secondLevelRadius;    // radius of cicle along whose the third levle nodes are drawn
    // second level node size (visual appearence)
    float _secondLevelNodeSize;
    
    // focusing node size
    float _focusingNodeSize;
    
    float _maxDistance;         // maximum node distance in the tree.  this is run time data
}Level2DistanceParams;

// there are serveral ways to setup the layout:
typedef enum
{
    LAYOUTTYPE_1,               // option 1
    LAYOUTTYPE_2,               // option 2
    LAYOUTTYPE_3                // option 3 for uniform
}LAYOUTTYPE;

// call to setup (radius, size) by level parameters
void setDefaultLevel2DistanceParams(Level2DistanceParams* params, LAYOUTTYPE type);

// define node states
typedef enum
{
    NODESTATE_DOT       = 0x0001,   // point node
    NODESTATE_HIDE      = 0x0002    // node that is hiding
}NODESTATE;

// define structure for node layout position

// position from origin (0, 0)
typedef struct
{
    float _r;
    float _a;
}RAPos;

typedef struct
{
    float _x;
    float _y;
}XYPos;

@interface ANLayoutNode : NSObject

// tree or sub tree starts with root node with child nodes.
// each tree can be layout differently based on the class and style for selected style

// node tree layout class for child nodes under this node
@property LAYOUTCLASS layoutClass;

// node tree layout sub-class depends on layoutCalss
@property LAYOUTSUBCLASS layoutSubClass;

// sub tree layout style
@property LAYOUTSTYLE layoutStyle;

// node index in the original node array for fast access
@property int index;

// classification or catergory used for custering and palcing the node.  for example, disease, risk, risk factor and life style etc
@property int segment;

// weight session
// weight or sensitivity for this node
@property float weight;

// size session
// node size (original size measured in radius unit)
// !!! the size can be used in various methods such as representing node visual size, text length, metric intensity etc
@property float size;

// aspect ratio if node is in rectangel shape (height / width)
@property float h2wratio;

// node run time size calculation
@property NODESIZE size_type;

// ratio factor used for calculating size_type if size_type is NODESIZE_RATIO_ROOT or NODESIZE_RATIO_LEVEL
@property float sRatio;

// distance from origin session
// level or circle distance from the center
@property int level;

// radius of node where child nodes are distributed witin the given angular range
// !!! this is different than distance used for estimating the node strength
// ratio used for computing the node radius
@property float rRatio;

// radius that defines the range child nodes can be distriburted within
@property float radius;

// distance derived from node level.  from origin (or center).  can be any value relative to the first level
// !!! note that the distance is measured in the same unit as size
// delta distance ratio by this node level.  distance = parent_distance + dRatio * parent_width
@property float dRatio;

// distance to circle center used for calculating node strength not really the actuall distance to the cicle center.
@property float distance;

// the angle size of each node is decided by the size divided by the distance to the center (root tree center)
@property float angleSize;

// total number of visible leafs under this node branch
@property int visibleLeafs;

// total number of leafs including the hiden ones
@property int leafs;

// total effective number of leafs (visible only)
@property float effectiveLeafs;

// total strength calculated by the total angular size of all leafs in this tree.  note that if the node angular width is larger than the tree strenth then use the node's strength
// !!! this is mostly the measure of seduo width of sub tree below this node
@property float strength;

// !!! this is mostly the measure of seduo length of sub tree below this node
@property float depth;

// e ratio for angular distribution weighted by node strength and total number of leafs
@property float eRatio;

// mass or charge (size * weight) used for repulsive force
@property double mass;

// parent (ANLayoutNode) of this node
@property(strong, nonatomic)ANLayoutNode* root;

// childeren (ANLayoutNode) of this node
@property(strong, nonatomic)NSMutableArray* childern;

///////////////////////////////////////////////
// visual properties
@property NODESTATE state;

// angular position
@property AngularRange aRange;

// node coordinate in radius position from origin in the viratual circle coordiante
// zoom factor applied onto rPosition as result of node layout angular width 180 degree limit.  see function radialLayout_root_1, radialLayout_root_2, radialLayout_node_1, radialLayout_node_2 for details.   
@property float zoom;
// layout coordiante by angle and radius
@property float rPosition;
@property float aPosition;

////////////////////////////////////////////////
// intermediate values used for transformation

// intermediate (rPosition, aPosition) used for run time node position manipulation for the purpose of shifting , zoomin etc
@property float rPosition_tran;
@property float aPosition_tran;

// radius used for layout transformation in radialLayoutTransform_scaling
// !!! radius_tran is used internally only for getting the radius in radialLayoutTransform_scaling calculation.  it is NOT used for transitional state the way rPosition_tran is used.
@property float radius_tran;

// dynamic size information depends on the level and node angular range etc
@property float size_tran;

////////////////////////////////////////////////

// node position in hosting rect area based on mapping
// !!! note that this is NOT the (x,y) form of (r,angle) coordinate conversion it is the projected x, y positon in the new rect coordinate
@property float xPosition;
@property float yPosition;
// projected node size in the final rect area
@property float xySize;

// dynamic values used for layout
// assigned cell index (for minimizing node collision)
@property int grid_row;
@property int grid_col;

// methods

// set node dimension
-(void)setDimension:(float) width
             height:(float) height;

// return width or height by _h2wratio
-(float)width;
-(float)height;

// add one node
-(ANLayoutNode*)addNode:(int)index
                 weight:(float)weight;

// remove one node
-(void)removeNode:(ANLayoutNode*)node;

// reset graph related run time parameters
-(void)reSet:(Level2DistanceParams*)param;

// decide the final node strength
-(float)finalStrength;

// effective strength is used for weighting the angular width for this node
// decided by strength * eRatio + (1 - eRatio) * effectiveLeafs
-(float)effectiveStrength;

// return angular weight depends on layoutStyle
-(float)angularStrength;

// reset strength of this node
+(void)reSetTree:(ANLayoutNode*)root
           param:(Level2DistanceParams*)param;

//////////////
// calculate node distance.  the distance between each node to the hosting circle center is decided by the node level and given algorithm selection found in paramaters
// calculate node distance from center and size
// !!! reSetTree was already called before this
// (1) calculats node distance to center point of hosting circle
// (2) calculats node size
// (3) calculates node radius

// calculate node strength.  called as part of radial layout mode
+(void)_calculateTreeNodeStrength:(ANLayoutNode*)root;

// calculate node strength by strength model (wiothout resetting the tree).  called as part of top-down or left-right layout mode
+(void)_calculateTreeNodeStrength:(ANLayoutNode*)node
                            param:(Level2DistanceParams*) param;

// calculate node distance from center and size.  used for radial layout mode
+(void)calculateTreeNodeDistanceAndSize:(ANLayoutNode*)node
                                  param:(Level2DistanceParams*)param;

// calculate tree strength.  used for radial layout mode
+(void)calculateTreeStrength:(ANLayoutNode*)root
                       param:(Level2DistanceParams*) param;

///////////////
// calculate node distance from center and size.  used for left-right or top-down tree layout mode
+(void)calculateTreeNodeDistanceAndSize:(ANLayoutNode*)node
                                  model:(STRENGTHMODEL)model
                                  param:(Level2DistanceParams*)param;

// get maximum rPosition info of given tree
// length - length of non-transition state
// length_tran - length of transitional state
// edge_tran - node size of the out most node used for leaving space for node on the out most edge when mapping onto hosting rect area
int getTreeLength(ANLayoutNode* node, float* length, float* length_tran, float* edge_tran);

// get angle range (aPosition) for the given sub-tree
int getTreeWidth(ANLayoutNode* node, float* begin_a, float* end_a, float* begin_a_tran, float* end_a_tran);

// extract average tree node size
// node - tree root node
// totalSize - sum of all tree node sizes
// numberOfNodes - total number of tree nodes
int getTreeNodeAverageSize(ANLayoutNode* node, float* totalSize, float* numberOfNodes);

// get size (radius around node position) of given sub tree
// node - sub node
// radius - radius by (rPosition, aPosition)
// radius_tran - radius by (rPosition_tran, aPosition_tran)
int getSubTreeSize(ANLayoutNode* node, float* radius, float* radius_tran);

// reset _tran intermediate state values to its original
// !!! _Tran object properties are used for run time simulations such as shift, zoom purpose etc
int reSetIntermediateProperties(ANLayoutNode* node);

@end
