//
//  ASymbol_CheckMark_Na_1.m
//  AProgressBars
//
//  Created by hui wang on 8/19/15.
//  Copyright (c) 2015 AnnieLyticx. All rights reserved.
//

#import "ASymbol_CheckMark_Na_1.h"

@interface ASymbol_CheckMark_Na_1 (PrivateMethods)

// draw path
-(void) drawPath;

@end

@implementation ASymbol_CheckMark_Na_1

-(void)initDrawPros
{
    self.pathRefSize = CGPointMake(12, 22);
    
    _lineColor = [UIColor colorWithRed: 1 green: 0.808 blue: 0.047 alpha: 1];
    _lineWidth = 2;
}

// create object and wrap into APathDrawWrap
+ (APathDrawWrap*)warp
{
    ASymbol_CheckMark_Na_1* draw = [[ASymbol_CheckMark_Na_1 alloc] init];
    [draw initDrawPros];
    
    APathDrawWrap* warp = [[APathDrawWrap alloc] initWith:CGRectMake(0, 0, draw.pathRefSize.x, draw.pathRefSize.y) pathDraw:draw];
    
    return warp;
}

// !!! The view area is CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    UIGraphicsPushContext(ctx);
    
    [self drawPath];
    
    /*
     // test drawing
     UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
     CGContextSetLineWidth(ctx, 2.0);
     
     [rectanglePath fill];
     //[rectanglePath stroke];
     */
    
    UIGraphicsPopContext();
    CGContextRestoreGState(ctx);
}

-(void) drawPath
{
    //// Label Drawing
    CGRect labelRect = CGRectMake(0, 0, 11, 22);
    NSMutableParagraphStyle* labelStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    labelStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary* labelFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Arial-BoldMT" size: 18.91], NSForegroundColorAttributeName: _lineColor, NSParagraphStyleAttributeName: labelStyle};
    
    [@"?" drawInRect: labelRect withAttributes: labelFontAttributes];
}

@end
