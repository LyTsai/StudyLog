//
//  TRSliceTitle.h
//  ATreeRingMap
//
//  Created by Hui Wang on 7/16/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANCircleText.h"
#import "Define.h"

@interface TRSliceTitle : NSObject{
    ANCircleText* textPainter;
}

// properties
// unit font size
@property(nonatomic)float pointsPerFontSize;

// ring size along radius direction to specify the maximum title range.  !!! note that size is in font unit.
@property(nonatomic)float size;
@property(strong, nonatomic)NSMutableDictionary* textAttributes;
// position and orientation style
@property(nonatomic)RingTextStyle style; 
// title
@property(strong,nonatomic)NSMutableString* title;

// method to setup string attributes
-(void)setStringAttributes:(NSString*)font
                      size:(float)size
           foregroundColor:(UIColor*)foregroundColor
               strokeColor:(UIColor*)strokeColor
               strokeWidth:(float)strokeWidth;

// radius - title position along radius direction
// left , right - angle of the slice
-(void)paint:(CGContextRef)ctx
      radius:(float)radius
        left:(float)left
       right:(float)right
      center:(CGPoint)origin
 frameHeight:(int)height;

// hit test.  Potential hit objects: slider, begin arrow and end arrow
-(HitObj)HitTest:(CGPoint)atPoint
          radius:(float)radius
          center:(CGPoint)origin;

@end
