//
//  ANGraph.m
//  AnnieVisualyticsPageView
//
//  Created by hui wang on 1/17/16.
//  Copyright (c) 2016 AnnieLyticx. All rights reserved.
//

#import "ANGraph.h"

#import "AImage_LifeStyle0.h"
// factory for hot spot node path
#import "ANSymbolFactory.h"


@implementation ANGraph
{
    @private
    
    // root of embeded node tree.
    // caller can directly attach a ANLayoutNode tree by passing a root.  an empty ANGraphNodeLayer object will be crated for each node for reserving the drawing layer
    ANLayoutNode* _root;
    
    // array of ANGraphNodeLayer stored in _root
    NSMutableArray* _allNodes;
}

-(id)init
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }
    
    _allNodes = [[NSMutableArray alloc] init];
    
    return self;
}

// access the root object
-(ANLayoutNode*)getRoot
{
    return _root;
}

// functions for crating and populating graph tree of ANGraphNodeLayer node
// starting a new graph
-(ANLayoutNode*)createNewGraph:(APageLayerPath*) layer
{
    _root = [[ANLayoutNode alloc] init];
    _allNodes = [[NSMutableArray alloc] init];
    
    // create {node, layer} object and add onto _allNodes
    _root.index = _allNodes.count;
    [_allNodes addObject:[[ANGraphNodeLayer alloc] initWith:_root layer:layer]];
    
    return _root;
}

// add node
-(ANLayoutNode*)addNode:(ANLayoutNode*) parent index:(int) index weight:(float)weight layer:(APageLayerPath*) layer
{
    if (parent == nil)
    {
        return nil;
    }
    
    // create a new node
    ANLayoutNode* node = [parent addNode:index weight:weight];
    
    if (_allNodes == nil)
    {
        _allNodes = [[NSMutableArray alloc] init];
    }
    
    // create {node, layer} object and add onto _allNodes
    node.index = _allNodes.count;
    [_allNodes addObject:[[ANGraphNodeLayer alloc] initWith:node layer:layer]];
    
    return node;
}

// remove node
-(void)removeNode:(ANLayoutNode*) parent node:(ANLayoutNode*)node
{
    if (parent == nil || node == nil)
    {
        return ;
    }
    
    // remove from _allNodes
    if (_allNodes != nil && node.index >= 0 && node.index < _allNodes.count)
    {
        _allNodes[node.index] = nil;
    }
    [parent removeNode:node];
}

// access to nodes synced inside array
-(int)numberOfNodes
{
    return _allNodes.count;
}

-(ANGraphNodeLayer*)node:(int)index
{
    if (index >= _allNodes.count)
    {
        return nil;
    }
    
    return [_allNodes objectAtIndex:index];
}

-(void)_syncUp:(ANLayoutNode*)node
     nodeArray:(NSMutableArray*)allNodes
{
    if (node == nil || allNodes == nil)
    {
        return ;
    }
    
    node.index = allNodes.count;
    [allNodes addObject:[[ANGraphNodeLayer alloc] initWith:node]];
    
    for (ANLayoutNode* obj in node.childern)
    {
        [self _syncUp:obj nodeArray:allNodes];
    }
}

// sync up node index.  !!! an internal dynamic array of ANGraphNodeLayer is maintainted internally.  the array is for the purpose of fast accessing to nodes of embeded tree.  as result the index needs to be synced up each time when the tree structure changes
-(void)syncUpNodesIndex
{
    if (_root == nil)
    {
        return ;
    }
    
    if (_allNodes == nil)
    {
        _allNodes = [[NSMutableArray alloc] init];
    }
    
    [self _syncUp:_root nodeArray:_allNodes];
}

// pick a sub-tree
-(ANLayoutNode*)pickSubTree
{
    ANLayoutNode* node = [_root.childern objectAtIndex:(_root.childern.count - 1)];
    
    node = [node.childern objectAtIndex:(node.childern.count - 1)];
    
    return node;
}

// pick a segment
-(ANLayoutNode*)pickSegment
{
    return [_root.childern objectAtIndex:(_root.childern.count - 1)];
}

/////////////////////////////////////////////////////////////////////////////
// functions for test purpose
/////////////////////////////////////////////////////////////////////////////
// create tree of graph with presentation layer
-(void) createTestGraph
{
    ANLayoutNode* root = [self createNewGraph:getRandomSymbolPath_Face()];
    
    int nNodes = 0;
    float weight = 1.0;
    int segment = 0;
    
    // segment Prenatal
    ANLayoutNode* Prenatal = [self addNode:root index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    Prenatal.segment = segment;
    
    ANLayoutNode* node = [self addNode:Prenatal index:nNodes weight:weight layer:getRandomSymbolPath()];     node.segment = segment;
    
    ANLayoutNode* risks = [self addNode:Prenatal index:nNodes weight:weight layer:getRandomSymbolPath()];
    risks.segment = segment;
    
    node = [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    node.segment = segment;
    node = [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    node.segment = segment;
    
    risks = [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    risks.segment = segment;
    
    node = [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    node.segment = segment;
    node = [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    node.segment = segment;
    
    risks = [self addNode:Prenatal index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    risks.segment = segment;
    
    node = [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    node.segment = segment;
    node = [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    node.segment = segment;
    
    // segment Infant
    segment += 1;
    ANLayoutNode* Infant = [self addNode:root index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    [self addNode:Infant index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    
    risks = [self addNode:Infant index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    
    // segment Child
    ANLayoutNode* Child = [self addNode:root index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    [self addNode:Child index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    
    risks = [self addNode:Child index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    
    
    // segment Adult
    ANLayoutNode* Adult = [self addNode:root index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    [self addNode:Adult index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    
    risks = [self addNode:Adult index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    
    risks = [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    
    // segment Elderly
    ANLayoutNode* Elderly = [self addNode:root index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    [self addNode:Elderly index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    
    risks = [self addNode:Elderly index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    
    risks = [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath_Face()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
    [self addNode:risks index:nNodes weight:weight layer:getRandomSymbolPath()];
}

@end
