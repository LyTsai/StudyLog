//
//  CDSliceBackground.h
//  ChordGraph
//
//  Created by Hui Wang on 6/23/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDSliceBackground : NSObject

// highlight state
@property(nonatomic)BOOL highlight;
// highlight state background drawing style
@property(nonatomic)HighLightStyle highlightStyle;
// normal state background drawing style
@property(nonatomic)BackgroudStyle style;
// fill color
@property(strong, nonatomic)UIColor* bkgColor;
// stroke edge color
@property(strong, nonatomic)UIColor* edgeColor;
// region highlight color
@property(strong, nonatomic)UIColor* highlightColor;
// paint on the given context
-(void)paint:(CGContextRef)ctx
      layout:(Slice)size
      center:(CGPoint)origin;
@end
