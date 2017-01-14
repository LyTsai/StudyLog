//
//  DSSlider.h
//  ATreeRingMap
//
//  Created by Hui Wang on 5/29/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// slider bar on the edge of tree ring slice.
// the slider bar is defined by length, height, spacing to head and end arrow etc
@interface DSSlider : NSObject

// properties
// length of the bar
@property(nonatomic)float length;
// height of the bar
@property(nonatomic)float height;
// space between direction arrow and bar
@property(nonatomic)int space;
// drawing style
@property(nonatomic)UIColor* faceColor;

// methods
// paint the slider
-(void)paint:(CGContextRef)ctx;
@end
