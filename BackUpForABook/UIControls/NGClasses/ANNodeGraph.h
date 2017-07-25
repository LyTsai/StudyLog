//
//  ANNodeGraph.h
//  NodeGraph
//
//  Created by hui wang on 11/8/16.
//  Copyright © 2016 hui wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ANGraph.h"

@interface ANNodeGraph : UIView  

// access graph node collection: data source
// you need to get ANGraph object before feeding data set.
// see how graph data are loaded into graph from createTestGraph function
-(ANGraph*) getGraph;

// graph rendering nethods.  after this call the nodes are placed onto coorect positions with size ready for drawing
-(void) radialLayout:(ANGraph*) graph hostRc:(CGRect) hostRc;

// call to update layer position based on node graph
-(void) updateNodeLayerObjects;

//////////////////////////////////////////////
// test functions
//////////////////////////////////////////////

-(void)loadTestNodeTree;

-(void)loadTestNodeTree_New;

@end
