//
//  CDEdge.h
//  ChordGraph
//
//  Created by Hui Wang on 7/16/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"
#import "CDSliceBackground.h"

// represents the edge ring of graph
@interface CDEdge : NSObject

// properties
// ring size along radius direction
@property(nonatomic)float size;

// here is your chance to compute the run time size
-(void)translateChildernFontSize:(float)pointsPerFontSize;
// get run time size
-(float)runtimeSize;

@property(strong, nonatomic)CDSliceBackground* background;
@end
