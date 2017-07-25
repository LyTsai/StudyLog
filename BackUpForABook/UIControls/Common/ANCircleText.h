//
//  ANCircleText.h
//  ChordGraph
//
//  Created by Hui Wang on 7/1/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

// ring text style for text wintin given circle ring
typedef enum
{
    RingTextStyle_None          = 0x00,
    RingTextStyle_AlignTop      = 0x01,     // align top ring
    RingTextStyle_AlignMiddle   = 0x02,     // align ring middle point
    RingTextStyle_AlignBottom   = 0x04,     // align ring bottom ring
    RingTextStyle_Ori_Circle    = 0x10,     // text orientation along the circle
    RingTextStyle_Ori_Left2Right = 0x20     // always left to right using 180 degree line
}RingTextStyle;

@interface ANCircleText : NSObject

// properties
// space between charactors
@property(nonatomic)int space;

// method
-(void)paintCircleText:(CGContextRef)ctx
                  text:(NSMutableAttributedString*)text
                 style:(RingTextStyle)style
                radius:(float)radius
                 width:(float)width
                  left:(float)left
                 right:(float)right
                center:(CGPoint)origin;
@end
