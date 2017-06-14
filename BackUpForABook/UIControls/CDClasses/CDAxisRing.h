//
//  CDAxisRing.h
//  ChordGraph
//
//  Created by Hui Wang on 6/28/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "CDRing.h"
#import "ANCircleText.h"

@interface CDAxisRing : NSObject

// properties
// ring size along radius direction
@property(nonatomic)float size;

// here is your chance to compute the run time size
-(void)translateChildernFontSize:(float)pointsPerFontSize;
// get run time size
-(float)runtimeSize;

// hit test
-(HitCDObj)hitTest:(CGPoint)atPoint
            radius:(float)radius
            center:(CGPoint)origin;
@end
