//
//  ANBezierText.h
//  ChordGraph
//
//  Created by Hui Wang on 7/5/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// bezie curve types: http://graphics.wikia.com/wiki/Bézier_curve
typedef enum
{
    // Cubic bezie curve
    BezierType_Quad    = 1,
    // Quadratic Bézier curve
    BezierType_Cubic
}BezierType;

// string alignment style
typedef enum
{
    // to the left
    CurveTextAlignment_Left     = 1,
    // at the center
    CurveTextAlignment_Center,
    // to the right
    CurveTextAlignment_Right
}CurveTextAlignment;

@interface ANBezierText : NSObject{
}

// properties
@property(nonatomic)CurveTextAlignment alignment;

// methods
// text along Cubic bezie curve
-(void)paintTextOnCubicBezier:(CGContextRef)ctx
                         text:(NSAttributedString*)text
                           p0:(CGPoint)p0
                           p1:(CGPoint)p1
                           p2:(CGPoint)p2
                           p3:(CGPoint)p3
                  frameHeight:(int)height;

// text along quadratic bezie curve
-(void)paintTextOnQuadBezier:(CGContextRef)ctx
                        text:(NSAttributedString*)text
                          p0:(CGPoint)p0
                          p1:(CGPoint)p1
                          p2:(CGPoint)p2
                 frameHeight:(int)height;

@end
