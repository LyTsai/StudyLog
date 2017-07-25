//
//  DSArrow.h
//  ATreeRingMap
//
//  Created by Hui Wang on 5/28/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 
// drawing shape type of class for arrow drawing
//
//      |\
//   |  | \
//  ----   \
//  _2d_   /
//   |  | /
//      |/
// the arrow is represented by following parameters:
// (1) d - the width  of hand
// (2) e - width of head
// (3) l - the length of hand
// (4) h - the length of head
// the path of the arrow edges are defined by: (0, -d), (l, -d), (l, -d-e), (l+h, 0), (l, d + e), (l,d), (0,d)
@interface DSArrow : NSObject

// properties
// 2d is the width of arrow hand
@property(nonatomic)float d;
@property(nonatomic)float e;
@property(nonatomic)float l;
@property(nonatomic)float h;
// arrow size information
@property(readonly, nonatomic)int width;
@property(readonly, nonatomic)int height;
// drawing style
// show or hide
@property(nonatomic)BOOL showArrow;
// put shadow?
@property(nonatomic)BOOL shadow;
// background color
@property(strong, nonatomic)UIColor *faceColor;
// methods
// paint the arrow
-(void)paint:(CGContextRef)ctx;

@end
