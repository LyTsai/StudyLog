//
//  CDCell.m
//  ChordGraph
//
//  Created by Hui Wang on 6/23/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "CDCell.h"
#import "CDConnection.h"

@interface CDCell (PrivateMethods)

// paint text symbol
-(void)drawSymbol:(CGContextRef)ctx
             size:(Slice)size
           center:(CGPoint)origin;

// paint image
-(void)drawImage:(CGContextRef)ctx
           image:(UIImage*)image
            size:(Slice)size
          center:(CGPoint)origin;

@end

@implementation CDCell

-(id)init
{
    self = [super init];

    _symbolAttributes = nil;
    _showImage = FALSE;
    _showSymbol = FALSE;
    _showBackground = TRUE;
    _backgropund = [[CDSliceBackground alloc] init];
    _sizeWeight = 1.0;

    textPainter = [[ANCircleText alloc] init];
    textPainter.space = 0;
    
    return self;
}

// remove connector
-(void)removeConnector:(id)connectorID
{
    [_connectorIDs removeObject:connectorID];
}

// invalidate gui
-(void)invalidate
{
    int i;
    
    for (i = 0; i < _connectorIDs.count; i++)
    {
        if ([[_connectorIDs objectAtIndex:i] isKindOfClass:[CDConnection class]] == TRUE)
        {
            [[_connectorIDs objectAtIndex:i] invalidate];
        }
    }
}

// paint ring slice
-(void)paint:(CGContextRef)ctx
      center:(CGPoint)origin
      bottom:(float)bottom
         top:(float)top
 frameHeight:(int)height
{
    CGContextSaveGState(ctx);
    
    // paint ring slice back ground first
    Slice size;
    
    size.left = _left;
    size.right = _right;
    size.bottom = bottom;
    size.top = top;
    
    // paint background first
    if (_showBackground)
    {
        // paint bakground
        [_backgropund paint:ctx layout:size center:origin];
    }
    
    // paint image
    if (_showImage && _image != nil)
    {
        // paint image
        [self drawImage:ctx image:_image size:size center:origin];
    }
    
    // paint text
    if (_showSymbol && _symbol != nil && _symbol.length > 0)
    {
        // paint symbol
        [self drawSymbol:ctx size:size center:origin];
    }
    
    // restore the original contest
    CGContextRestoreGState(ctx);
}

// paint text symbol
-(void)drawSymbol:(CGContextRef)ctx
             size:(Slice)size
           center:(CGPoint)origin
{
    // draw symbol at the center of size
    // make attributed string for the title first
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:_symbol attributes:_symbolAttributes];
    
    // symbol style
    RingTextStyle symbolStyle = RingTextStyle_Ori_Left2Right | RingTextStyle_AlignMiddle;
    
    float left = size.left, right = size.right;
    
    // make sure left and right are below 360 degree range
    if (MAX(left, right) >= 360.0)
    {
        left -= 360.0;
        right -= 360.0;
    }
    
    [textPainter paintCircleText:ctx text:attString style:symbolStyle radius:size.bottom width:(size.top - size.bottom) left:left right:right center:origin];
}

// !!! To Do paint image
-(void)drawImage:(CGContextRef)ctx
           image:(UIImage*)image
            size:(Slice)size
          center:(CGPoint)origin
{
    // translate
    // rotate
    // draw image
    
    return ;
}

// call to make sure all visual changes are in sync with the internal data
-(void)onDirtyView
{
    int i;
    float totalIntensity = .0;
    
    if (_connectorIDs.count <= 0)
    {
        return ;
    }
    
    for (i = 0; i < _connectorIDs.count; i++)
    {
        totalIntensity += [[_connectorIDs objectAtIndex:i] getIntensity:self];
    }
    
    float start, end, den;
    
    start = _right;
    den = (_left - _right)/ _connectorIDs.count;
    
    for (i = 0; i < _connectorIDs.count; i++)
    {
        end = start + den;
        [[_connectorIDs objectAtIndex:i] setNodeGuiSize:self left:end right:start];
        start = end;
    }
}

@end
