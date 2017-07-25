//
//  ANGraph.h
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 1/17/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANGraphNodeLayer.h"
#import "ANNodeLayer.h"

// wrap a ANLayoutNode tree
@interface ANGraph : NSObject

// access the root object
-(ANLayoutNode*)getRoot;

/////////////////////////////////////////////////////////////////////////////
// functions for crating and populating graph tree of ANGraphNodeLayer node
// see function createTestGraph for details
/////////////////////////////////////////////////////////////////////////////

// starting a new graph
-(ANLayoutNode*)createNewGraph:(ANNodeLayer*) layer;

// add node
-(ANLayoutNode*)addNode:(ANLayoutNode*) parent index:(int) index weight:(float)weight layer:(ANNodeLayer*) layer;

// remove node
-(void)removeNode:(ANLayoutNode*) parent node:(ANLayoutNode*)node;

/////////////////////////////////////////////////////////////////////////////
// sync up node index.  !!! an internal dynamic array of ANGraphNodeLayer is maintainted internally.  the array is for the purpose of fast accessing to nodes of embeded tree.  as result the index needs to be synced up each time when the tree structure changes
// call this function to resync after delting many nodes
-(void)syncUpNodesIndex;

// access to nodes synced inside array
-(int)numberOfNodes;
-(ANGraphNodeLayer*)node:(int)index;

// pick a sub-tree
-(ANLayoutNode*)pickSubTree;

// pick a segment
-(ANLayoutNode*)pickSegment;

/////////////////////////////////////////////////////////////////////////////
// functions for test purpose
/////////////////////////////////////////////////////////////////////////////

// create tree of graph with presentation layer
-(void) createTestGraph;

@end

