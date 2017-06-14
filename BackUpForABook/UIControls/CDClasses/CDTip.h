//
//  CDTip.h
//  ChordGraph
//
//  Created by Hui Wang on 7/4/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>

// chord graph tip message
@interface CDTip : NSObject

// tip messagedisplayed at the center
@property(strong, nonatomic)NSMutableDictionary* attrDictionary;
@property(strong, nonatomic)NSMutableString* tip;
@property(nonatomic)BOOL showTip;
// shadow color
@property(strong, nonatomic)UIColor *blurColor;
// shadow style
@property(nonatomic)CGSize blurSize;
@property(nonatomic)float blurRadius;

// method
// paint tip message at the center
-(void)paint:(CGContextRef)ctx
      radius:(float)radius
      center:(CGPoint)origin
 frameHeight:(int)height;

@end
