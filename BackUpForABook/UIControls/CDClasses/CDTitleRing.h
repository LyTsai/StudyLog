//
//  CDTitleRing.h
//  ChordGraph
//
//  Created by Hui Wang on 6/28/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "CDRing.h" 
#import "ANCircleText.h"

@interface CDTitleRing : NSObject{
    ANCircleText* textPainter;
}

// properties
// ring size along radius direction.  !!! note that size is in font unit.
@property(nonatomic)float size;
@property(strong, nonatomic)NSMutableDictionary* textAttributes;
// position and orientation style
@property(nonatomic)RingTextStyle style;
@property(nonatomic)int characterSpacing;

// here is your chance to compute the run time size
-(void)translateChildernFontSize:(float)pointsPerFontSize;
// get run time size
-(float)runtimeSize;

-(void)paint:(CGContextRef)ctx
  archorRing:(CDRing*)archor
      radius:(float)radius
      center:(CGPoint)origin
 frameHeight:(int)height;

// hit test
-(HitCDObj)hitTest:(CGPoint)atPoint
        archorRing:(CDRing*)archor
            radius:(float)radius
            center:(CGPoint)origin;

@end
