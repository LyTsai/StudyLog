//
//  DSCircle.h
//  ATreeRingMap
//
//  Created by hui wang on 11/29/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface DSCircle : NSObject

// properties
// show or hide
@property(nonatomic)BOOL show;
// size
@property float size;
// highlight and low color
@property(strong, nonatomic)UIColor* colorHi;
@property(strong, nonatomic)UIColor* colorLo;
// outside and inside color
@property(strong, nonatomic)UIColor* outsideColor;
@property(strong, nonatomic)UIColor* insideColor;

// "handle" bar size
@property float handle_width;
@property (strong, nonatomic)UIColor* handle_Color;

// paint the circle at given location
// origin - center of circle
-(void)paint:(CGContextRef)ctx
      origin:(CGPoint)origin;

// paint the circle woth handle bar
-(void)paint:(CGContextRef)ctx
      origin:(CGPoint)origin
  handle_pos:(CGPoint)handle_pos;

@end
