//
//  ANNodeGraph.m
//  NodeGraph
//
//  Created by hui wang on 11/8/16.
//  Copyright © 2016 hui wang. All rights reserved.
//

#import "ANNodeGraph.h"
#import "ANRadialLayout.h"

@implementation ANNodeGraph
{
@private
    
    // nodes collection (graph nodes and layer presentation)
    ANGraph* _graph;
    
    // radial layout rendering engine
    ANRadialLayout* _radialLayout;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _graph = [[ANGraph alloc] init];
        _radialLayout = [[ANRadialLayout alloc] init];
    }
    
    return self;
}

// access graph node collection: data source
-(ANGraph*) getGraph
{
    return _graph;
}

//////////////////////////////////////////////////////
// test functions
//////////////////////////////////////////////////////

// graph rendering nethods.  after this call the nodes are placed onto coorect positions with size ready for drawing
-(void) radialLayout:(ANGraph*) graph hostRc:(CGRect) hostRc
{
    if (_graph == nil || _radialLayout == nil)
    {
        return ;
    }

    // (1) layout onto page hostRC
    // with space bending
    [_radialLayout treeLayout_spaceShape:_graph.getRoot bendspace:true hostRc:hostRc];

    // (2) resposition layer nodes and put on the page
    [self updateNodeLayerObjects];
}

// call to update layer position based on node graph
-(void) updateNodeLayerObjects
{
    int i, n = [_graph numberOfNodes];
    
    // size ratio between virtual circle and hosting rect
    float radiusRatio = _radialLayout.mapParams._treeSize / _radialLayout.mapParams._treeSize_tran;
    float sizeRatio = [_radialLayout nodeVisualSizeRatio] * radiusRatio;

    for (i = 0; i < n; i++)
    {
        ANGraphNodeLayer *node = [_graph node:i];
        
        if (node == nil)
        {
            continue;
        }
        
        ANNodeLayer *path = node.layer;
        
        CGPoint pos;
        float width, height;
        
        // for visual presentation us the value stored in _tran
        width = node.node.size_tran * sizeRatio;
        height = node.node.size_tran * sizeRatio;
        
        pos.x = node.node.xPosition - width * .5;
        pos.y = node.node.yPosition - height * .5;
        
        CGRect rc = CGRectMake(pos.x, pos.y, width, height);
        
        [path loadOntoPage:self.layer layout:rc];
    }
}

-(void)loadTestNodeTree
{
    CGRect hostRc = CGRectInset(self.bounds, 80, 80);
    
    if (_graph == nil)
    {
        return ;
    }
    
    // (1) create a test node tree and feed it into the graph object
    //_graph.root = ANGraph.createTestGraph_1;
    
    [_graph createTestGraph];
    
    // (2) graph layout objects
    // radial layout
    ANRadialLayout* radialLayout = [[ANRadialLayout alloc] init];
    
    // layout onto page hostRC
    // with space bending
    [radialLayout treeLayout_spaceShape:_graph.getRoot bendspace:true hostRc:hostRc];
    
    // uniform layout
    //[radialLayout treeLayout_spaceShape:_graph.root bendspace:false hostRc:hostRc];
    
    /// older version
    /*
     // (3) !!! test rotation and then zoom - shift
     [radialLayout treeLayout_rotate:_graph.root angle:30 apply2Tran:false];
     [radialLayout treeLayout_zoom_shift_circle:_graph.root hostRc:hostRc R_ratio:.25 dx:0 dy:0];
     */
    
    // (4) !!! test of zoom and shift
    //[radialLayout treeLayout_zoom_shift_circle:_graph.root hostRc:hostRc R_ratio:.25 dx:0 dy:0];
    /// end of older version
    
    // shift- zoom with rotating
    //[radialLayout treeLayout_zoom_shift_circle_by_focus:_graph.root hostRc:hostRc x0_byRatio:.75 y0_byRatio:-.25];
    
    // just shift the focusing point to the right
    //[radialLayout treeLayout_zoom_shift_circle_by_focus_angleoffset:_graph.root hostRc:hostRc x0_byRatio:.75 y0_byRatio:.0 angle:.0];
    
    // zoom onto selected sub tree
    //[radialLayout treeLayout_zoom_sub_tree:_graph.root node_focus:([_graph pickSubTree]) hostRc:hostRc];
    
    // zoom onto selected segment tree
    //[radialLayout treeLayout_zoom_sub_tree:_graph.root node_focus:([_graph pickSegment]) hostRc:hostRc];
    
    // zoom with specific angle
    //[radialLayout treeLayout_zoom_sub_tree:_graph.root node_seg:([_graph pickSegment]) hostRc:hostRc rootangle:90.0];
    
    // (5) !!! test rotation
    //[radialLayout treeLayout_rotate:_graph.root angle:-80 apply2Tran:true];
    
    // resposition layer nodes and put on the page
    [self updateNodeLayerObjects];
}

-(void)loadTestNodeTree_New
{
    if (_graph == nil)
    {
        return ;
    }
    
    // (1) load testing node graph
    [_graph createTestGraph];
    
    // (2) render onto rect area
    CGRect hostRc = CGRectInset(self.bounds, 0, 0);
    [self radialLayout:_graph hostRc:hostRc];
    
    // (3) reposition node layer positions
//    [self updateNodeLayerObjects];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
// draw the connection lines

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // enable for testing purpose
    bool bTest = false;
    
    if (bTest)
    {
        // (1) draw frame
        CGContextSaveGState(context);
        
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, 80, 80)];
        CGContextAddPath(context, rectanglePath.CGPath);
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed: .0 green: .0 blue: .0 alpha: 1].CGColor);
        
        CGContextSetLineWidth(context, 1.0);
        CGContextStrokePath(context);
        
        CGContextRestoreGState(context);
    }
     
    // (2) node to child node connections
    int i, n = [_graph numberOfNodes];
    
    for (i = 0; i < n; i++)
    {
        ANGraphNodeLayer *node = [_graph node:i];
        
        if (node == nil || node.node.childern.count <= 0)
        {
            continue;
        }
        
        for (ANLayoutNode* obj in node.node.childern)
        {
            CGContextSaveGState(context);
            
            // path from root node.node to child node obj
            UIBezierPath *aPath = [UIBezierPath bezierPath];
            
            [aPath moveToPoint:CGPointMake(node.node.xPosition, node.node.yPosition)];
            [aPath addLineToPoint:CGPointMake(obj.xPosition, obj.yPosition)];
            
            CGContextAddPath(context, aPath.CGPath);
            
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed: .0 green: .0 blue: .0 alpha: .6].CGColor);
            
            CGContextSetLineWidth(context, 1.0);
            CGContextStrokePath(context);
            
            // fram around the node
            
            CGContextRestoreGState(context);
        }
    }
}

@end
